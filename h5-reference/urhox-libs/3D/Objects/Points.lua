-- ============================================================================
-- urhox-libs/3D · Points
-- three.js Points(geometry, material)。Object3D + CustomGeometry(POINT_LIST) + 点材质。
-- 逐点一个 DefineVertex；vertexColors 时读 attributes.color。
-- 已知降级：引擎 POINT_LIST 无点尺寸控制，实际恒 1px（material.size 存值不生效）。
-- ============================================================================

local Object3D = require("urhox-libs/3D/Core/Object3D")

local NativeVector3 = Vector3
local NativeColor = Color

local Points = {}
local pointsMethods = {}

local function nativeOf(m) return m and m.getNative and m:getNative() or nil end

local function emit(self)
    local geom = rawget(self, "_component")
    if not geom then return end
    local g = rawget(self, "_geometry")
    local attrs = g and g.attributes
    local pos = attrs and attrs.position
    if not pos then return end
    local mat = rawget(self, "_material")
    local col = (mat and mat.vertexColors and attrs.color) or nil

    geom:BeginGeometry(0, POINT_LIST)
    for i = 0, pos.count - 1 do
        geom:DefineVertex(NativeVector3(pos:getX(i), pos:getY(i), pos:getZ(i)))
        if col then geom:DefineColor(NativeColor(col:getX(i), col:getY(i), col:getZ(i), 1)) end
    end
    geom:Commit()
    local native = nativeOf(mat)
    if native then geom:SetMaterial(native) end
end

local function mget(self, k)
    if k == "isPoints" then return true end
    if k == "type" then return "Points" end
    if k == "geometry" then return rawget(self, "_geometry") end
    if k == "material" then return rawget(self, "_material") end
    return nil
end

local function mset(self, k, v)
    if k == "material" then
        rawset(self, "_material", v)
        local geom = rawget(self, "_component")
        local native = nativeOf(v)
        if geom and native then geom:SetMaterial(native) end
        return true
    end
    if k == "geometry" then rawset(self, "_geometry", v); emit(self); return true end
    return false
end

local mt = Object3D.makeMeta(pointsMethods, mget, mset)

function Points.new(geometry, material)
    local self = setmetatable({}, mt)
    Object3D.setup(self)
    rawset(self, "_geometry", geometry)
    rawset(self, "_material", material)
    rawset(self, "_component", self:getNode():CreateComponent("CustomGeometry"))
    emit(self)
    return self
end

function pointsMethods:updateGeometry() emit(self); return self end

return Points
