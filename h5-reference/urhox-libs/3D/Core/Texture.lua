-- ============================================================================
-- urhox-libs/3D · Texture
-- three.js Texture：先于 GPU 资源存在的"属性包"(wrapS/repeat/filter...)，
-- 底层异步到达的 UrhoX Texture2D 就绪时 flush 采样态。设计见 §6（纹理）。
-- 共享策略：采样态直接设在 cache 的 Texture2D 上（方案 A，先验证；冲突优化后续）。
-- ============================================================================

local Matrix3 = require("urhox-libs/3D/Core/Matrix3")

local Texture = {}
local methods = {}
local mt = {
    __index = function(self, k)
        if k == "needsUpdate" then return rawget(self, "_needsUpdate") end
        if k == "repeat" then return rawget(self, "repeat_") end -- repeat 是 Lua 关键字，点访问兜底
        return methods[k]
    end,
    __newindex = function(self, k, v)
        if k == "needsUpdate" then
            rawset(self, "_needsUpdate", v)
            if v and rawget(self, "_native") then methods.applySampler(self) end
        elseif k == "repeat" then
            rawset(self, "repeat_", v)
        else
            rawset(self, k, v)
        end
    end,
}

-- three.js mapping 常量（env 处理依据：原始 equirect/cube 需卷积；CubeUV 已是 PMREM 产物）
Texture.UVMapping = 300
Texture.CubeReflectionMapping = 301
Texture.CubeRefractionMapping = 302
Texture.EquirectangularReflectionMapping = 303
Texture.EquirectangularRefractionMapping = 304
Texture.CubeUVReflectionMapping = 306

-- three.js 常量（数值与 three.js 对齐）
Texture.RepeatWrapping = 1000
Texture.ClampToEdgeWrapping = 1001
Texture.MirroredRepeatWrapping = 1002
Texture.NearestFilter = 1003
Texture.LinearFilter = 1006
Texture.LinearMipmapLinearFilter = 1008

-- three.js wrap → UrhoX TextureAddressMode (WRAP=0, MIRROR=1, CLAMP=2)
local function wrapToAddr(w)
    if w == Texture.ClampToEdgeWrapping then return ADDRESS_CLAMP end
    if w == Texture.MirroredRepeatWrapping then return ADDRESS_MIRROR end
    return ADDRESS_WRAP
end

-- three.js mag/min → UrhoX FilterMode（组合查表，非降级）
local function filterMode(mag, min)
    if mag == Texture.NearestFilter then return FILTER_NEAREST end
    -- mag=Linear：有 mipmap-linear → TRILINEAR，否则 BILINEAR
    if min == Texture.LinearMipmapLinearFilter or min == 1005 then return FILTER_TRILINEAR end
    return FILTER_BILINEAR
end

function Texture.new(url)
    local self = setmetatable({}, mt)
    rawset(self, "_native", nil)
    rawset(self, "_ready", false)
    rawset(self, "_readyCbs", {})
    rawset(self, "_needsUpdate", false)
    self.url = url
    self.wrapS = Texture.RepeatWrapping
    self.wrapT = Texture.RepeatWrapping
    self.repeat_ = { x = 1, y = 1 } -- repeat 是 Lua 关键字，导出名见下
    self.offset = { x = 0, y = 0 }
    self.magFilter = Texture.LinearFilter
    self.minFilter = Texture.LinearMipmapLinearFilter
    self.flipY = true
    self.colorSpace = "" -- "srgb" / ""(linear)；由材质按 slot 决定
    self.mapping = Texture.UVMapping -- 默认普通 UV 贴图
    self.center = { x = 0, y = 0 }   -- UV 旋转中心（three.js 默认 0,0）
    self.rotation = 0                -- UV 旋转（弧度）
    self.matrix = Matrix3.new()      -- UV 变换矩阵（updateMatrix 填充）
    self.anisotropy = 1
    self.generateMipmaps = true
    self.format = nil                -- 存值 no-op（cook/load 期定）
    self.premultiplyAlpha = false
    return self
end

-- 从 offset/repeat/rotation/center 重算 UV 变换矩阵（three.js Texture.updateMatrix）
function methods:updateMatrix()
    local o, r, c = self.offset, self.repeat_, self.center
    self.matrix:setUvTransform(o.x, o.y, r.x, r.y, self.rotation, c.x, c.y)
    return self
end

-- 用 UV 矩阵变换一个 uv（含 x,y 的表），就地写回
function methods:transformUv(uv)
    self:updateMatrix()
    local e = self.matrix.elements -- 1-based（Matrix3）
    local x, y = uv.x, uv.y
    uv.x = e[1] * x + e[4] * y + e[7]
    uv.y = e[2] * x + e[5] * y + e[8]
    return uv
end

-- 把采样态 flush 到 native Texture2D（共享）
function methods:applySampler()
    local tex = rawget(self, "_native")
    if not tex then return end
    if tex.SetAddressMode then
        tex:SetAddressMode(COORD_U, wrapToAddr(self.wrapS))
        tex:SetAddressMode(COORD_V, wrapToAddr(self.wrapT))
    end
    if tex.SetFilterMode then tex:SetFilterMode(filterMode(self.magFilter, self.minFilter)) end
    if tex.SetAnisotropy and self.anisotropy and self.anisotropy > 1 then tex:SetAnisotropy(self.anisotropy) end
    if tex.SetNumLevels and self.generateMipmaps == false then tex:SetNumLevels(1) end
    rawset(self, "_needsUpdate", false)
end

-- native 就绪（AsyncLoader 回调里调）
function methods:_setNative(tex)
    rawset(self, "_native", tex)
    rawset(self, "_ready", true)
    methods.applySampler(self)
    local cbs = rawget(self, "_readyCbs")
    for _, cb in ipairs(cbs) do cb(tex) end
    rawset(self, "_readyCbs", {})
end

-- 注册就绪回调（材质用：拿到 native 后设到纹理单元）；已就绪则立即调
function methods:onReady(fn)
    if rawget(self, "_ready") then fn(rawget(self, "_native")) else
        table.insert(rawget(self, "_readyCbs"), fn)
    end
    return self
end

function methods:getNative() return rawget(self, "_native") end
function methods:isReady() return rawget(self, "_ready") end

-- 拷贝采样/变换属性（不含 native 就绪态）
function methods:copy(src)
    self.url = src.url
    self.wrapS = src.wrapS; self.wrapT = src.wrapT
    self.repeat_ = { x = src.repeat_.x, y = src.repeat_.y }
    self.offset = { x = src.offset.x, y = src.offset.y }
    self.center = { x = src.center.x, y = src.center.y }
    self.rotation = src.rotation
    self.magFilter = src.magFilter; self.minFilter = src.minFilter
    self.flipY = src.flipY; self.colorSpace = src.colorSpace; self.mapping = src.mapping
    self.anisotropy = src.anisotropy; self.generateMipmaps = src.generateMipmaps
    self.premultiplyAlpha = src.premultiplyAlpha
    return self
end

-- clone：新属性包 + 共享底层 native（同源 GPU 纹理）
function methods:clone()
    local t = Texture.new(self.url)
    t:copy(self)
    local n = rawget(self, "_native")
    if n then t:_setNative(n) end
    return t
end

-- three.js dispose：释放。native 由 cache 持有，这里断本包装引用即可。
function methods:dispose()
    rawset(self, "_native", nil)
    rawset(self, "_ready", false)
    return self
end

return Texture
