-- ============================================================================
-- urhox-libs/3D · MeshStandardMaterial
-- three.js MeshStandardMaterial。设计见 §4.3。
-- 纯色 → PBRNoTexture；有贴图按组合选 PBRDiff/Normal/Emissive/MetallicRough* 变体。
-- rough/metal 贴图存在时标量作乘数（→ TextureRoughnessFactor/TextureMetallicFactor，
-- 与 three.js 一致）；无贴图时喂标量 Roughness/Metallic。贴图异步就绪后设到纹理单元。
--
-- 运行时可变（three.js 语义）：mat.color/opacity/roughness/metalness/emissive/...
-- 直接改即生效。标量/颜色走轻量 setter；贴图增减、transparent 翻转走 rebuild（重选
-- 技术 + 重绑纹理）。属性读取返回逻辑值（props）。
-- ============================================================================

local Convert = require("urhox-libs/3D/Core/Convert")
local ORMComposer = require("urhox-libs/3D/Core/ORMComposer")
local Color = require("urhox-libs/3D/Core/Color")

local M = {}
local methods = {}

-- 把 hex/string/{r,g,b}/THREE.Color 规整为 THREE.Color；已是 Color 则原样（保留引用，three.js 语义）
local function asColor(v)
    if type(v) == "table" and v.clone and v.setHex then return v end
    return Color.new(v)
end

-- three.js side → UrhoX CullMode（RH 投影翻转绕序，正面剔除用 CULL_CW）
local function sideToCull(side)
    if side == "double" or side == 2 then return CULL_NONE end
    if side == "back" or side == 1 then return CULL_CCW end
    return CULL_CW
end

-- 按贴图组合选技术变体
local function pickTechnique(hasMap, hasNormal, hasEmissive, hasORM, alpha, vcol)
    local a = alpha and "Alpha" or ""
    -- vertexColors：UrhoX 仅两种 VCol 变体——纯顶点色(NOUV) 与 全 ORM+normal。
    -- 纯色/带普通 map 都走 PBRDiffVCol(无贴图，MatDiffColor×顶点色)；全套走 MetallicRough 版。
    if vcol then
        if hasORM and hasNormal then return "PBRMetallicRoughDiffNormalSpecVCol" end
        return "PBRDiffVCol"
    end
    if hasORM then
        if hasEmissive then return "PBRMetallicRoughDiffNormalSpecEmissive" .. a end
        if hasNormal then return "PBRMetallicRoughDiffNormalSpec" .. a end
        return "PBRMetallicRoughDiffSpec" .. a
    end
    if hasMap then
        if hasEmissive then return "PBRDiffNormalEmissive" .. a end -- 含 normal（缺则用默认法线图）
        if hasNormal then return "PBRDiffNormal" .. a end
        return "PBRDiff" .. a
    end
    return "PBRNoTexture" .. a
end

-- 把一张 THREE.Texture 就绪后设到纹理单元；sRGB 解码依据 texture.colorSpace（对标 three.js）。
-- "srgb" → 解码；"srgb-linear" 等显式线性 → 不解码；NoColorSpace("")/未设 → 用槽位默认
-- （diffuse/emissive 颜色图 = sRGB，法线/ORM 数据图 = linear）。
local function bindTex(mat, tex, unit, slotDefaultSRGB)
    if not tex then return end
    tex:onReady(function(native)
        if not native then return end
        if native.SetSRGB then
            local cs = tex.colorSpace
            local srgb
            if cs == "srgb" then
                srgb = true
            elseif cs == nil or cs == "" then
                srgb = slotDefaultSRGB
            else
                srgb = false -- srgb-linear 等显式线性
            end
            native:SetSRGB(srgb and true or false)
        end
        mat:SetTexture(unit, native)
    end)
end

-- alpha（半透）状态：transparent 显式开，或 opacity<1
local function isAlpha(p)
    return p.transparent == true or (p.opacity ~= nil and p.opacity < 1)
end

local function hasORM(p)
    return (p.metalnessMap or p.roughnessMap or p.aoMap) ~= nil
end

-- 暂未支持的 three.js 属性（接口暴露但 no-op，见 docs/design/threejs-3d-api-design.md §6.3）
-- alphaMap：UrhoX 无独立 alpha 贴图槽；normalScale：PBR shader 无 uniform；envMap：Zone 级 IBL（Phase 2）
local UNSUPPORTED = {
    alphaMap = "无独立 alpha 贴图槽",
    normalScale = "PBR shader 无 NormalScale uniform",
    envMap = "环境贴图是 Zone 级 IBL，归 Phase 2 scene.environment",
    envMapIntensity = "随 envMap，Phase 2",
    alphaTest = "引擎 Mask 变体测 spec.a 而非 diffuse.a，语义待对齐",
    flatShading = "需 non-indexed 几何 / 面法线重算，UrhoX 暂无对应",
    -- MeshPhysicalMaterial physical-only（引擎 PBR 无 sheen/clearcoat/transmission shader）
    sheen = "引擎 PBR 无 sheen",
    sheenColor = "引擎 PBR 无 sheen",
    sheenRoughness = "引擎 PBR 无 sheen",
    clearcoat = "引擎 PBR 无 clearcoat",
    clearcoatRoughness = "引擎 PBR 无 clearcoat",
    transmission = "引擎 PBR 无 transmission",
    thickness = "引擎 PBR 无 transmission",
    ior = "引擎 PBR 无可调 IOR",
    specularIntensity = "引擎 PBR 无 specularIntensity",
    specularColor = "引擎 PBR 无 specularColor",
    iridescence = "引擎 PBR 无 iridescence",
    -- 渲染状态（需引擎 Pass 的 Lua 绑定，见 docs/guides/technical-debt.md）
    depthTest = "需引擎 Pass 绑定（technique 级渲染状态）",
    depthWrite = "需引擎 Pass 绑定（technique 级渲染状态）",
    depthFunc = "需引擎 Pass 绑定（technique 级渲染状态）",
    colorWrite = "需引擎 Pass 绑定（technique 级渲染状态）",
    blending = "需引擎 Pass 绑定（混合模式在 technique）",
    polygonOffset = "引擎无 polygonOffset（仅 depthBias，语义不同）",
    toneMapped = "色调映射是 Zone/后处理级，非材质级",
    wireframeLinewidth = "引擎 FILL_WIREFRAME 无线宽控制",
    -- 贴图强度 / 位移（需 PBR shader uniform）
    aoMapIntensity = "PBR shader 无 AO intensity uniform",
    lightMap = "PBR shader 无独立 lightmap 通道",
    lightMapIntensity = "PBR shader 无 lightmap intensity uniform",
    displacementMap = "PBR 顶点着色器无 displacement 支持",
    displacementScale = "随 displacementMap",
    displacementBias = "随 displacementMap",
    bumpMap = "PBR shader 无独立 bump（用 normalMap）",
    bumpScale = "随 bumpMap",
}
local function warnUnsupported(k)
    log:Write(LOG_ERROR, "MeshStandardMaterial: 属性 '" .. k .. "' 暂未支持（" ..
        UNSUPPORTED[k] .. "），已忽略。见 docs/design/threejs-3d-api-design.md §6.3")
end

--------------------------------------------------------------------------------
-- apply 子函数（各自只更新对应 native 状态）
--------------------------------------------------------------------------------

-- 基础色（color.rgb + opacity.a → MatDiffColor）
local function applyDiffColor(self)
    local p = self.props
    local c = Convert.color(p.color or 0xffffff, p.opacity ~= nil and p.opacity or 1.0)
    self._mat:SetShaderParameter("MatDiffColor", Variant(c))
end

-- rough/metal：有贴图作乘数，否则标量
local function applyRoughMetal(self)
    local p = self.props
    local rough = p.roughness or 1.0
    local metal = p.metalness or 0.0
    if hasORM(p) then
        self._mat:SetShaderParameter("TextureRoughnessFactor", Variant(rough))
        self._mat:SetShaderParameter("TextureMetallicFactor", Variant(metal))
    else
        self._mat:SetShaderParameter("Roughness", Variant(rough))
        self._mat:SetShaderParameter("Metallic", Variant(metal))
    end
end

-- 自发光（emissive * emissiveIntensity → MatEmissiveColor）
local function applyEmissive(self)
    local p = self.props
    if p.emissive or p.emissiveMap then
        local ei = p.emissiveIntensity or 1.0
        local ec = Convert.color(p.emissive or 0xffffff)
        self._mat:SetShaderParameter("MatEmissiveColor", Variant(Vector3(ec.r * ei, ec.g * ei, ec.b * ei)))
    end
end

-- UV 变换（repeat/offset，取首个贴图的）：用引擎 SetUVTiling/SetUVOffset
-- （内部 UpdateUVShaderParam 才会正确算出并上传 UOffset/VOffset；直接塞 shaderParam 无效）
local function applyUV(self)
    local p = self.props
    local uvtex = p.map or p.normalMap or p.metalnessMap or p.roughnessMap or p.aoMap or p.emissiveMap
    if uvtex then
        local rp = uvtex.repeat_ or { x = 1, y = 1 }
        local of = uvtex.offset or { x = 0, y = 0 }
        -- SetUVTransform 一并带旋转（uvtex.rotation；center 引擎隐式 0.5）
        self._mat:SetUVTransform(Vector2(of.x, of.y), uvtex.rotation or 0, Vector2(rp.x, rp.y))
    end
end

local function applySide(self)
    self._mat:SetCullMode(sideToCull(self.props.side))
end

local function applyWireframe(self)
    if self._mat.SetFillMode then
        self._mat:SetFillMode(self.props.wireframe and FILL_WIREFRAME or FILL_SOLID)
    end
end

-- 结构性：技术变体 + 纹理单元（贴图增减 / alpha 翻转时重做）
local function applyTechniqueAndTextures(self)
    local p = self.props
    local mat = self._mat
    -- 三张独立的 rough/metal/ao 源图 → CPU 合成一张 UrhoX 序 ORM（线性，立即就绪）
    local vcol = p.vertexColors == true
    local ormTex = (not vcol or (p.normalMap and (p.roughnessMap or p.metalnessMap or p.aoMap)))
        and ORMComposer.build(p.roughnessMap, p.metalnessMap, p.aoMap) or nil
    local techName = pickTechnique(p.map ~= nil, p.normalMap ~= nil, p.emissiveMap ~= nil, ormTex ~= nil, isAlpha(p), vcol)
    mat:SetTechnique(0, cache:GetResource("Technique", "Techniques/PBR/" .. techName .. ".xml"))
    -- 贴图：diffuse/emissive=sRGB（异步就绪后绑定）；normal=linear；ORM 已是合成好的 native
    bindTex(mat, p.map, TU_DIFFUSE, true)
    bindTex(mat, p.normalMap, TU_NORMAL, false)
    if ormTex then mat:SetTexture(TU_SPECULAR, ormTex) end
    bindTex(mat, p.emissiveMap, TU_EMISSIVE, true)
    rawset(self, "_orm", ormTex) -- 持有引用，防 GC
    rawset(self, "_alpha", isAlpha(p))
end

-- 全量重建（结构 + 全部参数）
local function rebuild(self)
    applyTechniqueAndTextures(self)
    applyDiffColor(self)
    applyRoughMetal(self)
    applyEmissive(self)
    applyUV(self)
    applySide(self)
    applyWireframe(self)
end

--------------------------------------------------------------------------------
-- setter 路由表（__newindex 用）：props 已写入新值后调用
--------------------------------------------------------------------------------

-- opacity 可能翻转 alpha 状态 → 翻转则 rebuild，否则只更新颜色
local function setOpacity(self)
    if isAlpha(self.props) ~= rawget(self, "_alpha") then
        rebuild(self)
    else
        applyDiffColor(self)
    end
end

-- color/emissive 规整为绑定了 _onChange 的 Color：就地 color.setHex()/multiplyScalar() 也能热更新。
local function bindColorProp(self, key, applyFn)
    local c = asColor(self.props[key])
    c._onChange = function() applyFn(self) end
    self.props[key] = c
    return c
end
local function setColor(self) bindColorProp(self, "color", applyDiffColor); applyDiffColor(self) end
local function setEmissive(self) bindColorProp(self, "emissive", applyEmissive); applyEmissive(self) end

local setters = {
    color = setColor,
    opacity = setOpacity,
    transparent = rebuild,
    roughness = applyRoughMetal,
    metalness = applyRoughMetal,
    emissive = setEmissive,
    emissiveIntensity = applyEmissive,
    side = applySide,
    wireframe = applyWireframe,
    -- 结构性：贴图增减 → 重选技术 + 重绑
    map = rebuild,
    normalMap = rebuild,
    roughnessMap = rebuild,
    metalnessMap = rebuild,
    aoMap = rebuild,
    emissiveMap = rebuild,
    vertexColors = rebuild,
    -- three.js：改完贴图 UV 等手动触发刷新
    needsUpdate = function(self, v) if v then rebuild(self) end end,
}

local mt = {
    __index = function(self, k)
        if k == "isMaterial" or k == "isMeshStandardMaterial" then return true end
        if k == "isMeshPhysicalMaterial" then return rawget(self, "_isPhysical") == true end
        if k == "type" then return rawget(self, "_isPhysical") and "MeshPhysicalMaterial" or "MeshStandardMaterial" end
        return methods[k] or rawget(self, "props")[k]
    end,
    __newindex = function(self, k, v)
        rawget(self, "props")[k] = v
        if UNSUPPORTED[k] then warnUnsupported(k) return end
        local s = setters[k]
        if s then s(self, v) end
    end,
}

function M.new(opts, isPhysical)
    opts = opts or {}
    local self = setmetatable({}, mt)
    rawset(self, "_mat", Material:new())
    rawset(self, "_alpha", false)
    rawset(self, "_isPhysical", isPhysical == true) -- MeshPhysicalMaterial 降级复用本实现
    -- 复制 opts 为逻辑状态（props）；后续读写都走它
    local props = {}
    for k, v in pairs(opts) do
        props[k] = v
        if UNSUPPORTED[k] then warnUnsupported(k) end
    end
    rawset(self, "props", props)
    -- color/emissive 规整为绑定的 Color 对象（three.js：material.color 必是 Color，支持就地改）
    bindColorProp(self, "color", applyDiffColor) -- color 缺省 → 白
    if props.emissive ~= nil then bindColorProp(self, "emissive", applyEmissive) end
    rebuild(self)
    return self
end

-- three.js clone：拷 props（Color 取独立副本），经 M.new 重建 native（绑定正确）
function methods:clone()
    local opts = {}
    for k, v in pairs(rawget(self, "props")) do
        if type(v) == "table" and v.clone and v.setHex then opts[k] = v:clone() else opts[k] = v end
    end
    return M.new(opts, rawget(self, "_isPhysical"))
end
function methods:copy(src)
    local c = src:clone()
    rawset(self, "_mat", rawget(c, "_mat"))
    rawset(self, "props", rawget(c, "props"))
    rawset(self, "_isPhysical", rawget(c, "_isPhysical"))
    return self
end
function methods:dispose() rawset(self, "_mat", nil); return self end

function methods:getNative() return rawget(self, "_mat") end

return M
