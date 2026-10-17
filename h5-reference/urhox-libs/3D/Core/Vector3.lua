-- ============================================================================
-- urhox-libs/3D · Vector3
-- 忠实复刻 three.js Vector3（方法名/语义照搬）。设计见 §4.8 / §2.3。
-- ============================================================================
--
-- 双身份（§2.3 活属性）：同一个类既是
--   ① 独立纯数学实例：local v = THREE.Vector3(1,2,3)（自持 _x/_y/_z）
--   ② Object3D 的活视图：mesh.position（读写直达底层 Node）
-- 统一靠内部 _g(self)→x,y,z 与 _s(self,x,y,z) 两个访问器；所有方法都走它俩，与身份无关。
--
-- ============================================================================

local Vector3 = {}
local methods = {}

-- 读任意"类向量"：优先 _g（本类实例），否则退 .x/.y/.z（plain table / 原生 Vector3）
local function read3(v)
    if type(v) == "table" and v._g then return v._g(v) end
    return v.x, v.y, v.z
end

-- ---- 独立实例的共享访问器（无 per-instance 闭包）-----------------------------
local function stdGet(s) return s._x, s._y, s._z end
local function stdSet(s, x, y, z) s._x = x; s._y = y; s._z = z end

local mt = {
    __index = function(self, k)
        if k == "x" then local x = self._g(self); return x end
        if k == "y" then local _, y = self._g(self); return y end
        if k == "z" then local _, _, z = self._g(self); return z end
        return methods[k]
    end,
    __newindex = function(self, k, v)
        if k == "x" then local _, y, z = self._g(self); self._s(self, v, y, z)
        elseif k == "y" then local x, _, z = self._g(self); self._s(self, x, v, z)
        elseif k == "z" then local x, y = self._g(self); self._s(self, x, y, v)
        else rawset(self, k, v) end
    end,
    __tostring = function(self)
        local x, y, z = self._g(self)
        return string.format("Vector3(%.3f, %.3f, %.3f)", x, y, z)
    end,
}

-- ---- 构造 -------------------------------------------------------------------
-- 独立实例
function Vector3.new(x, y, z)
    local o = setmetatable({ _x = x or 0, _y = y or 0, _z = z or 0 }, mt)
    o._g = stdGet
    o._s = stdSet
    return o
end

-- 活视图：传入自定义 get/set（由 Object3D 绑定到 Node）
function Vector3.bound(getter, setter)
    local o = setmetatable({}, mt)
    o._g = getter
    o._s = setter
    return o
end

-- ---- three.js 方法（全部 return self 支持链式，clone 例外）---------------------
function methods:set(x, y, z) self._s(self, x, y, z); return self end

function methods:setScalar(s) self._s(self, s, s, s); return self end

function methods:copy(v) local x, y, z = read3(v); self._s(self, x, y, z); return self end

function methods:clone() return Vector3.new(self._g(self)) end -- clone 永远是独立实例

function methods:add(v)
    local ax, ay, az = self._g(self); local bx, by, bz = read3(v)
    self._s(self, ax + bx, ay + by, az + bz); return self
end

function methods:addScaledVector(v, s)
    local ax, ay, az = self._g(self); local bx, by, bz = read3(v)
    self._s(self, ax + bx * s, ay + by * s, az + bz * s); return self
end

function methods:sub(v)
    local ax, ay, az = self._g(self); local bx, by, bz = read3(v)
    self._s(self, ax - bx, ay - by, az - bz); return self
end

function methods:subVectors(a, b)
    local ax, ay, az = read3(a); local bx, by, bz = read3(b)
    self._s(self, ax - bx, ay - by, az - bz); return self
end

function methods:multiplyScalar(s)
    local x, y, z = self._g(self); self._s(self, x * s, y * s, z * s); return self
end

function methods:dot(v) local ax, ay, az = self._g(self); local bx, by, bz = read3(v); return ax * bx + ay * by + az * bz end

function methods:cross(v)
    local ax, ay, az = self._g(self); local bx, by, bz = read3(v)
    self._s(self, ay * bz - az * by, az * bx - ax * bz, ax * by - ay * bx); return self
end

function methods:length() local x, y, z = self._g(self); return math.sqrt(x * x + y * y + z * z) end

function methods:lengthSq() local x, y, z = self._g(self); return x * x + y * y + z * z end

function methods:normalize()
    local len = self:length()
    if len > 0 then self:multiplyScalar(1 / len) end
    return self
end

function methods:distanceTo(v)
    local ax, ay, az = self._g(self); local bx, by, bz = read3(v)
    local dx, dy, dz = ax - bx, ay - by, az - bz
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

function methods:lerp(v, t)
    local ax, ay, az = self._g(self); local bx, by, bz = read3(v)
    self._s(self, ax + (bx - ax) * t, ay + (by - ay) * t, az + (bz - az) * t); return self
end

function methods:equals(v)
    local ax, ay, az = self._g(self); local bx, by, bz = read3(v)
    return ax == bx and ay == by and az == bz
end

function methods:toArray() local x, y, z = self._g(self); return { x, y, z } end

-- ---- 补齐 three.js Vector3 常用接口 ----------------------------------------
function methods:setX(x) local _, y, z = self._g(self); self._s(self, x, y, z); return self end
function methods:setY(y) local x, _, z = self._g(self); self._s(self, x, y, z); return self end
function methods:setZ(z) local x, y = self._g(self); self._s(self, x, y, z); return self end

function methods:addScalar(s) local x, y, z = self._g(self); self._s(self, x + s, y + s, z + s); return self end

function methods:addVectors(a, b)
    local ax, ay, az = read3(a); local bx, by, bz = read3(b)
    self._s(self, ax + bx, ay + by, az + bz); return self
end

function methods:subScalar(s) local x, y, z = self._g(self); self._s(self, x - s, y - s, z - s); return self end

function methods:multiply(v)
    local ax, ay, az = self._g(self); local bx, by, bz = read3(v)
    self._s(self, ax * bx, ay * by, az * bz); return self
end

function methods:multiplyVectors(a, b)
    local ax, ay, az = read3(a); local bx, by, bz = read3(b)
    self._s(self, ax * bx, ay * by, az * bz); return self
end

function methods:divide(v)
    local ax, ay, az = self._g(self); local bx, by, bz = read3(v)
    self._s(self, ax / bx, ay / by, az / bz); return self
end

function methods:divideScalar(s) return self:multiplyScalar(1 / s) end

function methods:negate() local x, y, z = self._g(self); self._s(self, -x, -y, -z); return self end

function methods:crossVectors(a, b)
    local ax, ay, az = read3(a); local bx, by, bz = read3(b)
    self._s(self, ay * bz - az * by, az * bx - ax * bz, ax * by - ay * bx); return self
end

function methods:setLength(l) return self:normalize():multiplyScalar(l) end

function methods:manhattanLength() local x, y, z = self._g(self); return math.abs(x) + math.abs(y) + math.abs(z) end

function methods:distanceToSquared(v)
    local ax, ay, az = self._g(self); local bx, by, bz = read3(v)
    local dx, dy, dz = ax - bx, ay - by, az - bz
    return dx * dx + dy * dy + dz * dz
end

function methods:min(v)
    local ax, ay, az = self._g(self); local bx, by, bz = read3(v)
    self._s(self, math.min(ax, bx), math.min(ay, by), math.min(az, bz)); return self
end

function methods:max(v)
    local ax, ay, az = self._g(self); local bx, by, bz = read3(v)
    self._s(self, math.max(ax, bx), math.max(ay, by), math.max(az, bz)); return self
end

function methods:clamp(minV, maxV)
    local x, y, z = self._g(self)
    local nx, ny, nz = read3(minV); local xx, xy, xz = read3(maxV)
    self._s(self, math.max(nx, math.min(xx, x)), math.max(ny, math.min(xy, y)), math.max(nz, math.min(xz, z)))
    return self
end

function methods:clampScalar(minV, maxV)
    local x, y, z = self._g(self)
    local function c(v) return math.max(minV, math.min(maxV, v)) end
    self._s(self, c(x), c(y), c(z)); return self
end

function methods:lerpVectors(a, b, t)
    local ax, ay, az = read3(a); local bx, by, bz = read3(b)
    self._s(self, ax + (bx - ax) * t, ay + (by - ay) * t, az + (bz - az) * t); return self
end

function methods:angleTo(v)
    local denom = math.sqrt(self:lengthSq() * (function() local x, y, z = read3(v); return x * x + y * y + z * z end)())
    if denom == 0 then return math.pi / 2 end
    local theta = self:dot(v) / denom
    return math.acos(math.max(-1, math.min(1, theta)))
end

function methods:projectOnVector(v)
    local bx, by, bz = read3(v)
    local denom = bx * bx + by * by + bz * bz
    if denom == 0 then self._s(self, 0, 0, 0); return self end
    local scalar = self:dot(v) / denom
    self._s(self, bx * scalar, by * scalar, bz * scalar); return self
end

function methods:reflect(n)
    -- v - 2*(v·n)*n（n 须为单位向量，three.js 同约定）
    local nx, ny, nz = read3(n)
    local d = self:dot(n)
    local x, y, z = self._g(self)
    self._s(self, x - 2 * d * nx, y - 2 * d * ny, z - 2 * d * nz); return self
end

function methods:fromArray(arr, offset)
    offset = offset or 0
    self._s(self, arr[offset + 1], arr[offset + 2], arr[offset + 3]); return self
end

-- 用四元数旋转本向量（q = THREE.Quaternion 或含 x,y,z,w 的表）。公式逐行同 three.js 现版。
function methods:applyQuaternion(q)
    local vx, vy, vz = self._g(self)
    local qx, qy, qz, qw = q.x, q.y, q.z, q.w
    -- t = 2 * cross(q.xyz, v)
    local tx = 2 * (qy * vz - qz * vy)
    local ty = 2 * (qz * vx - qx * vz)
    local tz = 2 * (qx * vy - qy * vx)
    -- v + q.w * t + cross(q.xyz, t)
    self._s(self,
        vx + qw * tx + qy * tz - qz * ty,
        vy + qw * ty + qz * tx - qx * tz,
        vz + qw * tz + qx * ty - qy * tx)
    return self
end

-- 绕单位轴旋转 angle（弧度）。内联 axis-angle→quat 后 applyQuaternion，避免循环依赖。
function methods:applyAxisAngle(axis, angle)
    local h = angle * 0.5; local s = math.sin(h)
    local ax, ay, az = read3(axis)
    return self:applyQuaternion({ x = ax * s, y = ay * s, z = az * s, w = math.cos(h) })
end

-- ---- 矩阵 / 球柱坐标 / 分量 / 随机 ------------------------------------------
-- 矩阵参数只读 .elements（1-based：three.js te[i] ↔ 本库 e[i+1]），故无 require 循环。

function methods:applyMatrix3(m)
    local x, y, z = self._g(self)
    local e = m.elements
    self._s(self,
        e[1] * x + e[4] * y + e[7] * z,
        e[2] * x + e[5] * y + e[8] * z,
        e[3] * x + e[6] * y + e[9] * z)
    return self
end

function methods:applyNormalMatrix(m) return self:applyMatrix3(m):normalize() end

function methods:applyMatrix4(m)
    local x, y, z = self._g(self)
    local e = m.elements
    local w = 1 / (e[4] * x + e[8] * y + e[12] * z + e[16])
    self._s(self,
        (e[1] * x + e[5] * y + e[9] * z + e[13]) * w,
        (e[2] * x + e[6] * y + e[10] * z + e[14]) * w,
        (e[3] * x + e[7] * y + e[11] * z + e[15]) * w)
    return self
end

function methods:transformDirection(m)
    local x, y, z = self._g(self)
    local e = m.elements
    self._s(self,
        e[1] * x + e[5] * y + e[9] * z,
        e[2] * x + e[6] * y + e[10] * z,
        e[3] * x + e[7] * y + e[11] * z)
    return self:normalize()
end

-- 投影到以 planeNormal 为法线的平面（= self - projectOnVector(planeNormal)）
function methods:projectOnPlane(planeNormal)
    local x, y, z = self._g(self)
    local nx, ny, nz = read3(planeNormal)
    local denom = nx * nx + ny * ny + nz * nz
    if denom == 0 then return self end
    local s = (x * nx + y * ny + z * nz) / denom
    self._s(self, x - nx * s, y - ny * s, z - nz * s); return self
end

local function trunc(v) return v < 0 and math.ceil(v) or math.floor(v) end
function methods:ceil() local x, y, z = self._g(self); self._s(self, math.ceil(x), math.ceil(y), math.ceil(z)); return self end
function methods:floor() local x, y, z = self._g(self); self._s(self, math.floor(x), math.floor(y), math.floor(z)); return self end
function methods:round() local x, y, z = self._g(self); self._s(self, math.floor(x + 0.5), math.floor(y + 0.5), math.floor(z + 0.5)); return self end
function methods:roundToZero() local x, y, z = self._g(self); self._s(self, trunc(x), trunc(y), trunc(z)); return self end

function methods:clampLength(minL, maxL)
    local len = self:length()
    return self:divideScalar(len == 0 and 1 or len):multiplyScalar(math.max(minL, math.min(maxL, len)))
end

function methods:manhattanDistanceTo(v)
    local x, y, z = self._g(self); local bx, by, bz = read3(v)
    return math.abs(x - bx) + math.abs(y - by) + math.abs(z - bz)
end

function methods:getComponent(index)
    local x, y, z = self._g(self)
    if index == 0 then return x elseif index == 1 then return y elseif index == 2 then return z end
    error("index is out of range: " .. tostring(index))
end

function methods:setComponent(index, value)
    local x, y, z = self._g(self)
    if index == 0 then x = value elseif index == 1 then y = value elseif index == 2 then z = value
    else error("index is out of range: " .. tostring(index)) end
    self._s(self, x, y, z); return self
end

function methods:setFromSphericalCoords(radius, phi, theta)
    local sinPhiR = math.sin(phi) * radius
    self._s(self, sinPhiR * math.sin(theta), math.cos(phi) * radius, sinPhiR * math.cos(theta)); return self
end
function methods:setFromSpherical(s) return self:setFromSphericalCoords(s.radius, s.phi, s.theta) end

function methods:setFromCylindricalCoords(radius, theta, y)
    self._s(self, radius * math.sin(theta), y, radius * math.cos(theta)); return self
end
function methods:setFromCylindrical(c) return self:setFromCylindricalCoords(c.radius, c.theta, c.y) end

function methods:setFromMatrixPosition(m)
    local e = m.elements
    self._s(self, e[13], e[14], e[15]); return self
end

function methods:setFromMatrixColumn(m, index) return self:fromArray(m.elements, index * 4) end
function methods:setFromMatrix3Column(m, index) return self:fromArray(m.elements, index * 3) end

function methods:setFromMatrixScale(m)
    local sx = self:setFromMatrixColumn(m, 0):length()
    local sy = self:setFromMatrixColumn(m, 1):length()
    local sz = self:setFromMatrixColumn(m, 2):length()
    self._s(self, sx, sy, sz); return self
end

function methods:setFromEuler(e) self._s(self, e.x, e.y, e.z); return self end
function methods:setFromColor(c) self._s(self, c.r, c.g, c.b); return self end

-- 世界坐标 → NDC（three.js 原式）。camera 须暴露 matrixWorldInverse / projectionMatrix
-- （本库相机用自合成 WebGL 投影，z∈[-1,1]，与 three.js 一致）。
function methods:project(camera)
    return self:applyMatrix4(camera.matrixWorldInverse):applyMatrix4(camera.projectionMatrix)
end

-- NDC → 世界坐标（project 的逆）
function methods:unproject(camera)
    return self:applyMatrix4(camera.projectionMatrixInverse):applyMatrix4(camera.matrixWorld)
end

function methods:random()
    self._s(self, math.random(), math.random(), math.random()); return self
end

function methods:randomDirection()
    local theta = math.random() * math.pi * 2
    local u = math.random() * 2 - 1
    local c = math.sqrt(1 - u * u)
    self._s(self, c * math.cos(theta), u, c * math.sin(theta)); return self
end

function methods:fromBufferAttribute(attribute, index)
    if attribute.getX then
        self._s(self, attribute:getX(index), attribute:getY(index), attribute:getZ(index))
    else
        local arr, is = attribute.array, attribute.itemSize or 3
        local o = index * is
        self._s(self, arr[o + 1], arr[o + 2], arr[o + 3])
    end
    return self
end

-- 用 Euler(弧度, XYZ) 旋转本向量。内联 euler→quat。
function methods:applyEuler(e)
    local c1, c2, c3 = math.cos(e.x * 0.5), math.cos(e.y * 0.5), math.cos(e.z * 0.5)
    local s1, s2, s3 = math.sin(e.x * 0.5), math.sin(e.y * 0.5), math.sin(e.z * 0.5)
    return self:applyQuaternion({
        x = s1 * c2 * c3 + c1 * s2 * s3,
        y = c1 * s2 * c3 - s1 * c2 * s3,
        z = c1 * c2 * s3 + s1 * s2 * c3,
        w = c1 * c2 * c3 - s1 * s2 * s3,
    })
end

return Vector3
