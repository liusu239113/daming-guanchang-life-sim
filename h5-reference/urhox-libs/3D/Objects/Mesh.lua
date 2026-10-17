-- ============================================================================
-- urhox-libs/3D · Mesh
-- three.js Mesh(geometry, material)。Object3D + 几何(CustomGeometry 后端) + 材质。
--
-- three.js 语义：
--   .geometry / .material   读到构造时传入的对象（material 可运行时替换 → 热换 native）
--   .isMesh = true
--   .castShadow / .receiveShadow   映射 Drawable:SetCastShadows（receiveShadow 由 zone/材质
--                                   决定，UrhoX 无逐 drawable 接收开关，存值 no-op）
--   material 多材质数组：暂用第 1 个（完整 geometry group 支持见 Tier B）
-- ============================================================================

local Object3D = require("urhox-libs/3D/Core/Object3D")

local Mesh = {}
local meshMethods = {}

-- 是否材质数组（three.js mesh.material = [m0,m1,...]）
local function isMaterialArray(mat)
    return type(mat) == "table" and mat[1] ~= nil and not mat.getNative
end

-- 取"有效材质"：数组取首个；否则原样（build 初次喂一个即可，逐组在 applyMaterialToComponent 处理）
local function effectiveMaterial(mat)
    if isMaterialArray(mat) then return mat[1] end
    return mat
end

local function nativeOf(m) return m and m.getNative and m:getNative() or nil end

-- 应用材质到 CustomGeometry：数组 → 逐 group SetMaterial(i, mat_i)；单个 → 全部 group
local function applyMaterialToComponent(self)
    local comp = rawget(self, "_component")
    if not comp or not comp.SetMaterial then return end
    local mat = rawget(self, "_material")
    if isMaterialArray(mat) then
        local n = comp.GetNumGeometries and comp:GetNumGeometries() or #mat
        for i = 0, n - 1 do
            local native = nativeOf(mat[i + 1] or mat[#mat]) -- 不足则复用最后一个
            if native then comp:SetMaterial(i, native) end
        end
    else
        local native = nativeOf(mat)
        if native then comp:SetMaterial(native) end
    end
end

local function applyCastShadow(self)
    local comp = rawget(self, "_component")
    if comp and comp.SetCastShadows then
        comp:SetCastShadows(rawget(self, "_castShadow") and true or false)
    end
end

local function mget(self, k)
    if k == "isMesh" then return true end
    if k == "type" then return "Mesh" end
    if k == "geometry" then return rawget(self, "_geometry") end
    if k == "material" then return rawget(self, "_material") end
    if k == "castShadow" then return rawget(self, "_castShadow") or false end
    if k == "receiveShadow" then return rawget(self, "_receiveShadow") and true or false end
    return nil
end

local function mset(self, k, v)
    if k == "material" then
        rawset(self, "_material", v); applyMaterialToComponent(self); return true
    end
    if k == "geometry" then rawset(self, "_geometry", v); return true end
    if k == "castShadow" then rawset(self, "_castShadow", v); applyCastShadow(self); return true end
    if k == "receiveShadow" then rawset(self, "_receiveShadow", v); return true end
    return false
end

-- three.js Mesh.clone：共享 material（引用）；geometry 若可 clone 则取独立副本
-- （避免两个 Mesh 共享同一 BufferGeometry 的 _component，保留模式下会互相覆盖）
function meshMethods:clone(recursive)
    local geo = self.geometry
    if geo and geo.clone then geo = geo:clone() end
    local m = Mesh.new(geo, self.material)
    m:copy(self, recursive)
    return m
end

local mt = Object3D.makeMeta(meshMethods, mget, mset)

function Mesh.new(geometry, material)
    local self = setmetatable({}, mt)
    Object3D.setup(self)
    rawset(self, "_geometry", geometry)
    rawset(self, "_material", material)
    rawset(self, "_castShadow", false)   -- three.js 默认 false
    rawset(self, "_receiveShadow", false)

    local nativeMat = nativeOf(effectiveMaterial(material))
    if geometry and geometry.build then
        rawset(self, "_component", geometry:build(self:getNode(), nativeMat))
    end
    if isMaterialArray(material) then applyMaterialToComponent(self) end -- 逐 group 应用材质数组
    applyCastShadow(self) -- 应用 three.js 默认（不投影）
    return self
end

return Mesh
