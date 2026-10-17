-- ============================================================================
-- urhox-libs/3D · Sphere
-- 忠实复刻 three.js Sphere（center: Vector3, radius）。纯 Lua。
-- 供 BufferGeometry.computeBoundingSphere / Raycaster 用。
-- ============================================================================

local Vector3 = require("urhox-libs/3D/Core/Vector3")
local Box3 = require("urhox-libs/3D/Core/Box3")

local Sphere = {}
local methods = {}
local mt = { __index = methods }

function Sphere.new(center, radius)
    local self = setmetatable({}, mt)
    self.center = center or Vector3.new()
    self.radius = radius or -1 -- 负 = 空（three.js 约定）
    return self
end

function methods:set(center, radius) self.center:copy(center); self.radius = radius; return self end

function methods:isEmpty() return self.radius < 0 end

local _box = Box3.new()
-- points：Vector3 数组；optionalCenter：可选 Vector3
function methods:setFromPoints(points, optionalCenter)
    local center = self.center
    if optionalCenter ~= nil then
        center:copy(optionalCenter)
    else
        _box:setFromPoints(points):getCenter(center)
    end
    local maxRadiusSq = 0
    for i = 1, #points do
        maxRadiusSq = math.max(maxRadiusSq, center:distanceToSquared(points[i]))
    end
    self.radius = math.sqrt(maxRadiusSq)
    return self
end

function methods:containsPoint(point)
    return point:distanceToSquared(self.center) <= (self.radius * self.radius)
end

function methods:copy(s) self.center:copy(s.center); self.radius = s.radius; return self end
function methods:clone() return Sphere.new():copy(self) end

return Sphere
