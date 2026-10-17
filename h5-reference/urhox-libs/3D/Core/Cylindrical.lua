-- ============================================================================
-- urhox-libs/3D · Cylindrical
-- 忠实复刻 three.js Cylindrical（柱坐标 radius/theta/y）。纯 Lua。
-- radius = 到 Y 轴的距离；theta = 绕 Y 的方位角（atan2(x, z)）；y = 高度。
-- 与 Vector3.setFromCylindrical / setFromCylindricalCoords 配套。
-- ============================================================================

local Cylindrical = {}
local methods = {}
local mt = { __index = methods }

function Cylindrical.new(radius, theta, y)
    return setmetatable({
        radius = radius or 1,
        theta = theta or 0,
        y = y or 0,
    }, mt)
end

function methods:set(radius, theta, y)
    self.radius = radius; self.theta = theta; self.y = y
    return self
end

function methods:copy(other)
    self.radius = other.radius; self.theta = other.theta; self.y = other.y
    return self
end

function methods:clone() return Cylindrical.new():copy(self) end

function methods:setFromVector3(v)
    return self:setFromCartesianCoords(v.x, v.y, v.z)
end

function methods:setFromCartesianCoords(x, y, z)
    self.radius = math.sqrt(x * x + z * z)
    self.theta = math.atan(x, z) -- Lua atan(y,x) == JS atan2(y,x)
    self.y = y
    return self
end

return Cylindrical
