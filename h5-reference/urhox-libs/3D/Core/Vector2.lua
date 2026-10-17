-- ============================================================================
-- urhox-libs/3D · Vector2
-- 忠实复刻 three.js Vector2。x/y 直存字段（独立纯数学实例；不做活视图）。
-- 用于 LatheGeometry 剖面点、shadow.mapSize、UV 等。
-- ============================================================================

local Vector2 = {}
local methods = {}

local function read2(v) return v.x or 0, v.y or 0 end

local mt = {
    __index = methods,
    __tostring = function(s) return string.format("Vector2(%.3f, %.3f)", s.x, s.y) end,
}

function Vector2.new(x, y)
    return setmetatable({ x = x or 0, y = y or 0 }, mt)
end

function methods:set(x, y) self.x, self.y = x, y; return self end
function methods:setScalar(s) self.x, self.y = s, s; return self end
function methods:copy(v) self.x, self.y = v.x, v.y; return self end
function methods:clone() return Vector2.new(self.x, self.y) end

function methods:add(v) local bx, by = read2(v); self.x, self.y = self.x + bx, self.y + by; return self end
function methods:sub(v) local bx, by = read2(v); self.x, self.y = self.x - bx, self.y - by; return self end
function methods:subVectors(a, b) self.x, self.y = a.x - b.x, a.y - b.y; return self end
function methods:multiplyScalar(s) self.x, self.y = self.x * s, self.y * s; return self end
function methods:dot(v) return self.x * v.x + self.y * v.y end
function methods:cross(v) return self.x * v.y - self.y * v.x end
function methods:length() return math.sqrt(self.x * self.x + self.y * self.y) end
function methods:lengthSq() return self.x * self.x + self.y * self.y end
function methods:normalize()
    local l = self:length()
    if l > 0 then self.x, self.y = self.x / l, self.y / l end
    return self
end
function methods:distanceTo(v) local dx, dy = self.x - v.x, self.y - v.y; return math.sqrt(dx * dx + dy * dy) end
function methods:angle() local a = math.atan(self.y, self.x); if a < 0 then a = a + 2 * math.pi end; return a end
function methods:lerp(v, t) self.x, self.y = self.x + (v.x - self.x) * t, self.y + (v.y - self.y) * t; return self end
function methods:equals(v) return self.x == v.x and self.y == v.y end
function methods:toArray() return { self.x, self.y } end

-- ---- 加减乘除 / clamp / 旋转 / 分量 / 矩阵 ---------------------------------
function methods:setX(x) self.x = x; return self end
function methods:setY(y) self.y = y; return self end

function methods:addScalar(s) self.x, self.y = self.x + s, self.y + s; return self end
function methods:addScaledVector(v, s) self.x, self.y = self.x + v.x * s, self.y + v.y * s; return self end
function methods:addVectors(a, b) self.x, self.y = a.x + b.x, a.y + b.y; return self end
function methods:subScalar(s) self.x, self.y = self.x - s, self.y - s; return self end
function methods:multiply(v) self.x, self.y = self.x * v.x, self.y * v.y; return self end
function methods:multiplyVectors(a, b) self.x, self.y = a.x * b.x, a.y * b.y; return self end
function methods:divide(v) self.x, self.y = self.x / v.x, self.y / v.y; return self end
function methods:divideScalar(s) return self:multiplyScalar(1 / s) end
function methods:negate() self.x, self.y = -self.x, -self.y; return self end

function methods:min(v) self.x, self.y = math.min(self.x, v.x), math.min(self.y, v.y); return self end
function methods:max(v) self.x, self.y = math.max(self.x, v.x), math.max(self.y, v.y); return self end
function methods:clamp(lo, hi)
    self.x = math.max(lo.x, math.min(hi.x, self.x))
    self.y = math.max(lo.y, math.min(hi.y, self.y))
    return self
end
function methods:clampScalar(lo, hi)
    self.x = math.max(lo, math.min(hi, self.x))
    self.y = math.max(lo, math.min(hi, self.y))
    return self
end
function methods:clampLength(minL, maxL)
    local len = self:length()
    return self:divideScalar(len == 0 and 1 or len):multiplyScalar(math.max(minL, math.min(maxL, len)))
end
function methods:setLength(l) return self:normalize():multiplyScalar(l) end

function methods:lerpVectors(a, b, t)
    self.x, self.y = a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t; return self
end

function methods:angleTo(v)
    local denom = math.sqrt(self:lengthSq() * (v.x * v.x + v.y * v.y))
    if denom == 0 then return math.pi / 2 end
    return math.acos(math.max(-1, math.min(1, self:dot(v) / denom)))
end

function methods:distanceToSquared(v) local dx, dy = self.x - v.x, self.y - v.y; return dx * dx + dy * dy end
function methods:manhattanLength() return math.abs(self.x) + math.abs(self.y) end
function methods:manhattanDistanceTo(v) return math.abs(self.x - v.x) + math.abs(self.y - v.y) end

local function trunc(v) return v < 0 and math.ceil(v) or math.floor(v) end
function methods:ceil() self.x, self.y = math.ceil(self.x), math.ceil(self.y); return self end
function methods:floor() self.x, self.y = math.floor(self.x), math.floor(self.y); return self end
function methods:round() self.x, self.y = math.floor(self.x + 0.5), math.floor(self.y + 0.5); return self end
function methods:roundToZero() self.x, self.y = trunc(self.x), trunc(self.y); return self end

-- 绕 center 旋转 angle（弧度，CCW）
function methods:rotateAround(center, angle)
    local c, s = math.cos(angle), math.sin(angle)
    local x, y = self.x - center.x, self.y - center.y
    self.x = x * c - y * s + center.x
    self.y = x * s + y * c + center.y
    return self
end

function methods:getComponent(index)
    if index == 0 then return self.x elseif index == 1 then return self.y end
    error("index is out of range: " .. tostring(index))
end
function methods:setComponent(index, value)
    if index == 0 then self.x = value elseif index == 1 then self.y = value
    else error("index is out of range: " .. tostring(index)) end
    return self
end

-- m.elements 1-based（Matrix3）
function methods:applyMatrix3(m)
    local x, y = self.x, self.y
    local e = m.elements
    self.x = e[1] * x + e[4] * y + e[7]
    self.y = e[2] * x + e[5] * y + e[8]
    return self
end

function methods:fromArray(arr, offset)
    offset = offset or 0
    self.x, self.y = arr[offset + 1], arr[offset + 2]; return self
end

function methods:fromBufferAttribute(attribute, index)
    if attribute.getX then
        self.x, self.y = attribute:getX(index), attribute:getY(index)
    else
        local arr, is = attribute.array, attribute.itemSize or 2
        local o = index * is
        self.x, self.y = arr[o + 1], arr[o + 2]
    end
    return self
end

return Vector2
