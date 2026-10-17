-- ============================================================================
-- urhox-libs/3D · Quaternion
-- 忠实复刻 three.js Quaternion(x, y, z, w)。
-- 双身份（同 Vector3）：① 独立实例 THREE.Quaternion(...)；② Object3D.quaternion 活视图
-- （读写直达底层 Node 旋转）。统一靠 _g(self)→x,y,z,w 与 _s(self,x,y,z,w) 访问器。
-- ============================================================================

local Quaternion = {}
local methods = {}

local function read4(q)
    if type(q) == "table" and q._g then return q._g(q) end
    return q.x, q.y, q.z, q.w
end

local function stdGet(s) return s._x, s._y, s._z, s._w end
local function stdSet(s, x, y, z, w) s._x = x; s._y = y; s._z = z; s._w = w end

local mt = {
    __index = function(self, k)
        if k == "x" then local x = self._g(self); return x end
        if k == "y" then local _, y = self._g(self); return y end
        if k == "z" then local _, _, z = self._g(self); return z end
        if k == "w" then local _, _, _, w = self._g(self); return w end
        return methods[k]
    end,
    __newindex = function(self, k, v)
        if k == "x" then local _, y, z, w = self._g(self); self._s(self, v, y, z, w)
        elseif k == "y" then local x, _, z, w = self._g(self); self._s(self, x, v, z, w)
        elseif k == "z" then local x, y, _, w = self._g(self); self._s(self, x, y, v, w)
        elseif k == "w" then local x, y, z = self._g(self); self._s(self, x, y, z, v)
        else rawset(self, k, v) end
    end,
    __tostring = function(self)
        local x, y, z, w = self._g(self)
        return string.format("Quaternion(%.3f, %.3f, %.3f, %.3f)", x, y, z, w)
    end,
}

function Quaternion.new(x, y, z, w)
    local o = setmetatable({ _x = x or 0, _y = y or 0, _z = z or 0, _w = w == nil and 1 or w }, mt)
    o._g = stdGet; o._s = stdSet
    return o
end

-- 活视图：传入自定义 get/set（由 Object3D 绑定到 Node 旋转）
function Quaternion.bound(getter, setter)
    local o = setmetatable({}, mt)
    o._g = getter; o._s = setter
    return o
end

function methods:set(x, y, z, w) self._s(self, x, y, z, w); return self end
function methods:copy(q) self._s(self, read4(q)); return self end
function methods:clone() return Quaternion.new(self._g(self)) end

function methods:setFromAxisAngle(axis, angle)
    local h = angle * 0.5; local s = math.sin(h)
    self._s(self, axis.x * s, axis.y * s, axis.z * s, math.cos(h)); return self
end

function methods:setFromEuler(e) -- three.js Euler XYZ
    local c1, c2, c3 = math.cos(e.x * 0.5), math.cos(e.y * 0.5), math.cos(e.z * 0.5)
    local s1, s2, s3 = math.sin(e.x * 0.5), math.sin(e.y * 0.5), math.sin(e.z * 0.5)
    self._s(self,
        s1 * c2 * c3 + c1 * s2 * s3,
        c1 * s2 * c3 - s1 * c2 * s3,
        c1 * c2 * s3 + s1 * s2 * c3,
        c1 * c2 * c3 - s1 * s2 * s3)
    return self
end

-- 用两个单位向量构造最短弧旋转（three.js setFromUnitVectors）
function methods:setFromUnitVectors(vFrom, vTo)
    local fx, fy, fz = vFrom.x, vFrom.y, vFrom.z
    local tx, ty, tz = vTo.x, vTo.y, vTo.z
    local r = fx * tx + fy * ty + fz * tz + 1
    local x, y, z, w
    if r < 1e-8 then -- 与 three.js 同 epsilon；反向时取任意垂直轴，w=0
        if math.abs(fx) > math.abs(fz) then x, y, z, w = -fy, fx, 0, 0 else x, y, z, w = 0, -fz, fy, 0 end
    else
        x = fy * tz - fz * ty; y = fz * tx - fx * tz; z = fx * ty - fy * tx; w = r
    end
    self._s(self, x, y, z, w); return self:normalize()
end

function methods:multiplyQuaternions(a, b)
    local ax, ay, az, aw = read4(a); local bx, by, bz, bw = read4(b)
    self._s(self,
        aw * bx + ax * bw + ay * bz - az * by,
        aw * by - ax * bz + ay * bw + az * bx,
        aw * bz + ax * by - ay * bx + az * bw,
        aw * bw - ax * bx - ay * by - az * bz)
    return self
end

function methods:multiply(q) return self:multiplyQuaternions(self, q) end
function methods:premultiply(q) return self:multiplyQuaternions(q, self) end

function methods:dot(q) local x, y, z, w = self._g(self); local bx, by, bz, bw = read4(q); return x * bx + y * by + z * bz + w * bw end
function methods:length() local x, y, z, w = self._g(self); return math.sqrt(x * x + y * y + z * z + w * w) end

function methods:normalize()
    local l = self:length()
    if l == 0 then self._s(self, 0, 0, 0, 1) else
        l = 1 / l; local x, y, z, w = self._g(self); self._s(self, x * l, y * l, z * l, w * l)
    end
    return self
end

function methods:conjugate() local x, y, z, w = self._g(self); self._s(self, -x, -y, -z, w); return self end
function methods:invert() return self:conjugate() end -- 单位四元数：逆 = 共轭（three.js 同实现）

function methods:angleTo(q) return 2 * math.acos(math.abs(math.max(-1, math.min(1, self:dot(q))))) end

function methods:equals(q)
    local x, y, z, w = self._g(self); local bx, by, bz, bw = read4(q)
    return x == bx and y == by and z == bz and w == bw
end

-- 球面线性插值（three.js slerp 现版，就地写入 self）
function methods:slerp(qb, t)
    local x, y, z, w = self._g(self)
    local bx, by, bz, bw = read4(qb)
    local dot = w * bw + x * bx + y * by + z * bz
    if dot < 0 then bx, by, bz, bw = -bx, -by, -bz, -bw; dot = -dot end
    local s = 1 - t
    if dot < 0.9995 then
        local theta = math.acos(dot)
        local sinT = math.sin(theta)
        s = math.sin(s * theta) / sinT
        t = math.sin(t * theta) / sinT
        self._s(self, x * s + bx * t, y * s + by * t, z * s + bz * t, w * s + bw * t)
    else
        -- 小角度：lerp 后归一化
        self._s(self, x * s + bx * t, y * s + by * t, z * s + bz * t, w * s + bw * t)
        return self:normalize()
    end
    return self
end

function methods:fromArray(arr, offset)
    offset = offset or 0
    self._s(self, arr[offset + 1], arr[offset + 2], arr[offset + 3], arr[offset + 4]); return self
end

function methods:toArray() local x, y, z, w = self._g(self); return { x, y, z, w } end

-- 从 BufferAttribute 第 index 项取 x/y/z/w
function methods:fromBufferAttribute(attribute, index)
    if attribute.getX then
        self._s(self, attribute:getX(index), attribute:getY(index), attribute:getZ(index), attribute:getW(index))
    else
        local arr, is = attribute.array, attribute.itemSize or 4
        local o = index * is
        self._s(self, arr[o + 1], arr[o + 2], arr[o + 3], arr[o + 4])
    end
    return self
end

function methods:identity() self._s(self, 0, 0, 0, 1); return self end

function methods:lengthSq() local x, y, z, w = self._g(self); return x * x + y * y + z * z + w * w end

-- 从旋转矩阵（Matrix4，只用左上 3x3）反推四元数。m.elements 为 1-based。
function methods:setFromRotationMatrix(m)
    local te = m.elements
    local m11, m12, m13 = te[1], te[5], te[9]
    local m21, m22, m23 = te[2], te[6], te[10]
    local m31, m32, m33 = te[3], te[7], te[11]
    local trace = m11 + m22 + m33
    local x, y, z, w
    if trace > 0 then
        local s = 0.5 / math.sqrt(trace + 1.0)
        w = 0.25 / s
        x = (m32 - m23) * s; y = (m13 - m31) * s; z = (m21 - m12) * s
    elseif m11 > m22 and m11 > m33 then
        local s = 2.0 * math.sqrt(1.0 + m11 - m22 - m33)
        w = (m32 - m23) / s; x = 0.25 * s; y = (m12 + m21) / s; z = (m13 + m31) / s
    elseif m22 > m33 then
        local s = 2.0 * math.sqrt(1.0 + m22 - m11 - m33)
        w = (m13 - m31) / s; x = (m12 + m21) / s; y = 0.25 * s; z = (m23 + m32) / s
    else
        local s = 2.0 * math.sqrt(1.0 + m33 - m11 - m22)
        w = (m21 - m12) / s; x = (m13 + m31) / s; y = (m23 + m32) / s; z = 0.25 * s
    end
    self._s(self, x, y, z, w); return self
end

-- 朝 q 旋转最多 step 弧度（three.js rotateTowards）
function methods:rotateTowards(q, step)
    local angle = self:angleTo(q)
    if angle == 0 then return self end
    self:slerp(q, math.min(1, step / angle)); return self
end

function methods:slerpQuaternions(qa, qb, t) return self:copy(qa):slerp(qb, t) end

-- 均匀随机单位四元数（Ken Shoemake 算法，three.js 同款）
function methods:random()
    local theta1 = 2 * math.pi * math.random()
    local theta2 = 2 * math.pi * math.random()
    local x0 = math.random()
    local r1 = math.sqrt(1 - x0)
    local r2 = math.sqrt(x0)
    self._s(self, r1 * math.sin(theta1), r1 * math.cos(theta1), r2 * math.sin(theta2), r2 * math.cos(theta2))
    return self
end

return Quaternion
