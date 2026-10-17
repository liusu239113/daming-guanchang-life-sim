-- ============================================================================
-- urhox-libs/3D · Box3
-- 忠实复刻 three.js Box3（轴对齐包围盒，min/max 为 Vector3）。纯 Lua。
-- 供 BufferGeometry.computeBoundingBox / Raycaster 用。
-- ============================================================================

local Vector3 = require("urhox-libs/3D/Core/Vector3")

local Box3 = {}
local methods = {}
local mt = { __index = methods }

local INF = math.huge

function Box3.new(min, max)
    local self = setmetatable({}, mt)
    self.min = min or Vector3.new(INF, INF, INF)
    self.max = max or Vector3.new(-INF, -INF, -INF)
    return self
end

function methods:set(min, max) self.min:copy(min); self.max:copy(max); return self end

function methods:makeEmpty()
    self.min:set(INF, INF, INF)
    self.max:set(-INF, -INF, -INF)
    return self
end

function methods:isEmpty()
    return (self.max.x < self.min.x) or (self.max.y < self.min.y) or (self.max.z < self.min.z)
end

function methods:expandByPoint(point)
    self.min:min(point)
    self.max:max(point)
    return self
end

function methods:setFromPoints(points)
    self:makeEmpty()
    for i = 1, #points do self:expandByPoint(points[i]) end
    return self
end

local _v = Vector3.new()
-- attribute：BufferAttribute（itemSize>=3，含 getX/Y/Z + count）
function methods:setFromBufferAttribute(attribute)
    self:makeEmpty()
    for i = 0, attribute.count - 1 do
        self:expandByPoint(_v:fromBufferAttribute(attribute, i))
    end
    return self
end

function methods:getCenter(target)
    target = target or Vector3.new()
    if self:isEmpty() then return target:set(0, 0, 0) end
    return target:addVectors(self.min, self.max):multiplyScalar(0.5)
end

function methods:getSize(target)
    target = target or Vector3.new()
    if self:isEmpty() then return target:set(0, 0, 0) end
    return target:subVectors(self.max, self.min)
end

function methods:containsPoint(point)
    return point.x >= self.min.x and point.x <= self.max.x
        and point.y >= self.min.y and point.y <= self.max.y
        and point.z >= self.min.z and point.z <= self.max.z
end

-- target：Sphere（避免循环 require，运行时传入或在 BufferGeometry 侧组合）
function methods:getBoundingSphere(target)
    self:getCenter(target.center)
    target.radius = self:getSize(_v):length() * 0.5
    return target
end

function methods:copy(box) self.min:copy(box.min); self.max:copy(box.max); return self end
function methods:clone() return Box3.new():copy(self) end

return Box3
