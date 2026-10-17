-- ============================================================================
-- urhox-libs/3D · Spherical
-- 忠实复刻 three.js Spherical（球坐标 radius/phi/theta）。纯 Lua。
-- phi = 自 +Y 轴的极角 [0, π]；theta = 绕 Y 的方位角（atan2(x, z)）。
-- 与 Vector3.setFromSpherical / setFromSphericalCoords 配套。
-- ============================================================================

local Spherical = {}
local methods = {}
local mt = { __index = methods }

local function clamp(v, lo, hi) return math.max(lo, math.min(hi, v)) end

function Spherical.new(radius, phi, theta)
    return setmetatable({
        radius = radius or 1,
        phi = phi or 0,
        theta = theta or 0,
    }, mt)
end

function methods:set(radius, phi, theta)
    self.radius = radius; self.phi = phi; self.theta = theta
    return self
end

function methods:copy(other)
    self.radius = other.radius; self.phi = other.phi; self.theta = other.theta
    return self
end

function methods:clone() return Spherical.new():copy(self) end

-- 限制 phi 不落在极点（避免 setFromSpherical 退化）
function methods:makeSafe()
    local EPS = 0.000001
    self.phi = clamp(self.phi, EPS, math.pi - EPS)
    return self
end

function methods:setFromVector3(v)
    return self:setFromCartesianCoords(v.x, v.y, v.z)
end

function methods:setFromCartesianCoords(x, y, z)
    self.radius = math.sqrt(x * x + y * y + z * z)
    if self.radius == 0 then
        self.theta = 0
        self.phi = 0
    else
        self.theta = math.atan(x, z) -- Lua atan(y,x) == JS atan2(y,x)
        self.phi = math.acos(clamp(y / self.radius, -1, 1))
    end
    return self
end

return Spherical
