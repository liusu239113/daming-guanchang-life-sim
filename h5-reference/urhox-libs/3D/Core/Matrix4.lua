-- ============================================================================
-- urhox-libs/3D · Matrix4
-- 忠实复刻 three.js Matrix4（4x4，列主序）。纯 Lua，无引擎依赖。
-- 存储：elements 为 1-based Lua 数组，elements[k] 对应 three.js te[k-1]
-- （即 three.js 的 te[0] = Lua elements[1]）。所有索引相对源码 +1，列主序布局不变。
-- 解锁下游：Vector3.applyMatrix4/transformDirection、Euler/Quaternion.setFromRotationMatrix、
-- BufferGeometry.applyMatrix4、Matrix3.getNormalMatrix 等。
-- ============================================================================

local Vector3 = require("urhox-libs/3D/Core/Vector3")
local Quaternion = require("urhox-libs/3D/Core/Quaternion")

local Matrix4 = {}
local methods = {}
local mt = { __index = methods }

-- 模块级 scratch（对标 three.js 的 _v1/_zero/_one/_x/_y/_z/_m1）
local _v1 = Vector3.new()
local _zero = Vector3.new(0, 0, 0)
local _one = Vector3.new(1, 1, 1)
local _x = Vector3.new()
local _y = Vector3.new()
local _z = Vector3.new()
local _m1 -- 延迟到构造器定义后再建（见文件尾）

function Matrix4.new()
    local o = setmetatable({}, mt)
    o.elements = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
    return o
end
Matrix4.isMatrix4 = true
-- 坐标系常量（与 three.js constants.js 一致；makePerspective/makeOrthographic 用 WebGL NDC）
Matrix4.WebGLCoordinateSystem = 2000
Matrix4.WebGPUCoordinateSystem = 2001

function methods:set(n11, n12, n13, n14, n21, n22, n23, n24, n31, n32, n33, n34, n41, n42, n43, n44)
    local te = self.elements
    te[1] = n11; te[5] = n12; te[9] = n13; te[13] = n14
    te[2] = n21; te[6] = n22; te[10] = n23; te[14] = n24
    te[3] = n31; te[7] = n32; te[11] = n33; te[15] = n34
    te[4] = n41; te[8] = n42; te[12] = n43; te[16] = n44
    return self
end

function methods:identity()
    return self:set(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
end

function methods:clone() return Matrix4.new():fromArray(self.elements) end

function methods:copy(m)
    local te, me = self.elements, m.elements
    for i = 1, 16 do te[i] = me[i] end
    return self
end

function methods:copyPosition(m)
    local te, me = self.elements, m.elements
    te[13] = me[13]; te[14] = me[14]; te[15] = me[15]
    return self
end

function methods:setFromMatrix3(m)
    local me = m.elements
    return self:set(
        me[1], me[4], me[7], 0,
        me[2], me[5], me[8], 0,
        me[3], me[6], me[9], 0,
        0, 0, 0, 1)
end

function methods:extractBasis(xAxis, yAxis, zAxis)
    xAxis:setFromMatrixColumn(self, 0)
    yAxis:setFromMatrixColumn(self, 1)
    zAxis:setFromMatrixColumn(self, 2)
    return self
end

function methods:makeBasis(xAxis, yAxis, zAxis)
    return self:set(
        xAxis.x, yAxis.x, zAxis.x, 0,
        xAxis.y, yAxis.y, zAxis.y, 0,
        xAxis.z, yAxis.z, zAxis.z, 0,
        0, 0, 0, 1)
end

function methods:extractRotation(m)
    if m:determinant() == 0 then return self:identity() end
    local te, me = self.elements, m.elements
    local scaleX = 1 / _v1:setFromMatrixColumn(m, 0):length()
    local scaleY = 1 / _v1:setFromMatrixColumn(m, 1):length()
    local scaleZ = 1 / _v1:setFromMatrixColumn(m, 2):length()
    te[1] = me[1] * scaleX; te[2] = me[2] * scaleX; te[3] = me[3] * scaleX; te[4] = 0
    te[5] = me[5] * scaleY; te[6] = me[6] * scaleY; te[7] = me[7] * scaleY; te[8] = 0
    te[9] = me[9] * scaleZ; te[10] = me[10] * scaleZ; te[11] = me[11] * scaleZ; te[12] = 0
    te[13] = 0; te[14] = 0; te[15] = 0; te[16] = 1
    return self
end

function methods:makeRotationFromEuler(euler)
    local te = self.elements
    local x, y, z = euler.x, euler.y, euler.z
    local a, b = math.cos(x), math.sin(x)
    local c, d = math.cos(y), math.sin(y)
    local e, f = math.cos(z), math.sin(z)
    local order = euler.order or "XYZ"
    if order == "XYZ" then
        local ae, af, be, bf = a * e, a * f, b * e, b * f
        te[1] = c * e; te[5] = -c * f; te[9] = d
        te[2] = af + be * d; te[6] = ae - bf * d; te[10] = -b * c
        te[3] = bf - ae * d; te[7] = be + af * d; te[11] = a * c
    elseif order == "YXZ" then
        local ce, cf, de, df = c * e, c * f, d * e, d * f
        te[1] = ce + df * b; te[5] = de * b - cf; te[9] = a * d
        te[2] = a * f; te[6] = a * e; te[10] = -b
        te[3] = cf * b - de; te[7] = df + ce * b; te[11] = a * c
    elseif order == "ZXY" then
        local ce, cf, de, df = c * e, c * f, d * e, d * f
        te[1] = ce - df * b; te[5] = -a * f; te[9] = de + cf * b
        te[2] = cf + de * b; te[6] = a * e; te[10] = df - ce * b
        te[3] = -a * d; te[7] = b; te[11] = a * c
    elseif order == "ZYX" then
        local ae, af, be, bf = a * e, a * f, b * e, b * f
        te[1] = c * e; te[5] = be * d - af; te[9] = ae * d + bf
        te[2] = c * f; te[6] = bf * d + ae; te[10] = af * d - be
        te[3] = -d; te[7] = b * c; te[11] = a * c
    elseif order == "YZX" then
        local ac, ad, bc, bd = a * c, a * d, b * c, b * d
        te[1] = c * e; te[5] = bd - ac * f; te[9] = bc * f + ad
        te[2] = f; te[6] = a * e; te[10] = -b * e
        te[3] = -d * e; te[7] = ad * f + bc; te[11] = ac - bd * f
    elseif order == "XZY" then
        local ac, ad, bc, bd = a * c, a * d, b * c, b * d
        te[1] = c * e; te[5] = -f; te[9] = d * e
        te[2] = ac * f + bd; te[6] = a * e; te[10] = ad * f - bc
        te[3] = bc * f - ad; te[7] = b * e; te[11] = bd * f + ac
    end
    te[4] = 0; te[8] = 0; te[12] = 0
    te[13] = 0; te[14] = 0; te[15] = 0; te[16] = 1
    return self
end

function methods:makeRotationFromQuaternion(q)
    return self:compose(_zero, q, _one)
end

function methods:lookAt(eye, target, up)
    local te = self.elements
    _z:subVectors(eye, target)
    if _z:lengthSq() == 0 then _z.z = 1 end
    _z:normalize()
    _x:crossVectors(up, _z)
    if _x:lengthSq() == 0 then
        if math.abs(up.z) == 1 then _z.x = _z.x + 0.0001 else _z.z = _z.z + 0.0001 end
        _z:normalize()
        _x:crossVectors(up, _z)
    end
    _x:normalize()
    _y:crossVectors(_z, _x)
    te[1] = _x.x; te[5] = _y.x; te[9] = _z.x
    te[2] = _x.y; te[6] = _y.y; te[10] = _z.y
    te[3] = _x.z; te[7] = _y.z; te[11] = _z.z
    return self
end

function methods:multiply(m) return self:multiplyMatrices(self, m) end
function methods:premultiply(m) return self:multiplyMatrices(m, self) end

function methods:multiplyMatrices(a, b)
    local ae, be, te = a.elements, b.elements, self.elements
    local a11, a12, a13, a14 = ae[1], ae[5], ae[9], ae[13]
    local a21, a22, a23, a24 = ae[2], ae[6], ae[10], ae[14]
    local a31, a32, a33, a34 = ae[3], ae[7], ae[11], ae[15]
    local a41, a42, a43, a44 = ae[4], ae[8], ae[12], ae[16]
    local b11, b12, b13, b14 = be[1], be[5], be[9], be[13]
    local b21, b22, b23, b24 = be[2], be[6], be[10], be[14]
    local b31, b32, b33, b34 = be[3], be[7], be[11], be[15]
    local b41, b42, b43, b44 = be[4], be[8], be[12], be[16]
    te[1] = a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41
    te[5] = a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42
    te[9] = a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43
    te[13] = a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44
    te[2] = a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41
    te[6] = a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42
    te[10] = a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43
    te[14] = a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44
    te[3] = a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41
    te[7] = a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42
    te[11] = a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43
    te[15] = a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44
    te[4] = a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41
    te[8] = a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42
    te[12] = a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43
    te[16] = a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44
    return self
end

function methods:multiplyScalar(s)
    local te = self.elements
    for i = 1, 16 do te[i] = te[i] * s end
    return self
end

function methods:determinant()
    local te = self.elements
    local n11, n12, n13, n14 = te[1], te[5], te[9], te[13]
    local n21, n22, n23, n24 = te[2], te[6], te[10], te[14]
    local n31, n32, n33, n34 = te[3], te[7], te[11], te[15]
    local n41, n42, n43, n44 = te[4], te[8], te[12], te[16]
    local t11 = n23 * n34 - n24 * n33
    local t12 = n22 * n34 - n24 * n32
    local t13 = n22 * n33 - n23 * n32
    local t21 = n21 * n34 - n24 * n31
    local t22 = n21 * n33 - n23 * n31
    local t23 = n21 * n32 - n22 * n31
    return n11 * (n42 * t11 - n43 * t12 + n44 * t13) -
        n12 * (n41 * t11 - n43 * t21 + n44 * t22) +
        n13 * (n41 * t12 - n42 * t21 + n44 * t23) -
        n14 * (n41 * t13 - n42 * t22 + n43 * t23)
end

function methods:transpose()
    local te = self.elements
    local tmp
    tmp = te[2]; te[2] = te[5]; te[5] = tmp
    tmp = te[3]; te[3] = te[9]; te[9] = tmp
    tmp = te[7]; te[7] = te[10]; te[10] = tmp
    tmp = te[4]; te[4] = te[13]; te[13] = tmp
    tmp = te[8]; te[8] = te[14]; te[14] = tmp
    tmp = te[12]; te[12] = te[15]; te[15] = tmp
    return self
end

function methods:setPosition(x, y, z)
    local te = self.elements
    if type(x) == "table" then
        te[13] = x.x; te[14] = x.y; te[15] = x.z
    else
        te[13] = x; te[14] = y; te[15] = z
    end
    return self
end

function methods:invert()
    local te = self.elements
    local n11, n21, n31, n41 = te[1], te[2], te[3], te[4]
    local n12, n22, n32, n42 = te[5], te[6], te[7], te[8]
    local n13, n23, n33, n43 = te[9], te[10], te[11], te[12]
    local n14, n24, n34, n44 = te[13], te[14], te[15], te[16]
    local t1 = n11 * n22 - n21 * n12
    local t2 = n11 * n32 - n31 * n12
    local t3 = n11 * n42 - n41 * n12
    local t4 = n21 * n32 - n31 * n22
    local t5 = n21 * n42 - n41 * n22
    local t6 = n31 * n42 - n41 * n32
    local t7 = n13 * n24 - n23 * n14
    local t8 = n13 * n34 - n33 * n14
    local t9 = n13 * n44 - n43 * n14
    local t10 = n23 * n34 - n33 * n24
    local t11 = n23 * n44 - n43 * n24
    local t12 = n33 * n44 - n43 * n34
    local det = t1 * t12 - t2 * t11 + t3 * t10 + t4 * t9 - t5 * t8 + t6 * t7
    if det == 0 then return self:set(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) end
    local detInv = 1 / det
    te[1] = (n22 * t12 - n32 * t11 + n42 * t10) * detInv
    te[2] = (n31 * t11 - n21 * t12 - n41 * t10) * detInv
    te[3] = (n24 * t6 - n34 * t5 + n44 * t4) * detInv
    te[4] = (n33 * t5 - n23 * t6 - n43 * t4) * detInv
    te[5] = (n32 * t9 - n12 * t12 - n42 * t8) * detInv
    te[6] = (n11 * t12 - n31 * t9 + n41 * t8) * detInv
    te[7] = (n34 * t3 - n14 * t6 - n44 * t2) * detInv
    te[8] = (n13 * t6 - n33 * t3 + n43 * t2) * detInv
    te[9] = (n12 * t11 - n22 * t9 + n42 * t7) * detInv
    te[10] = (n21 * t9 - n11 * t11 - n41 * t7) * detInv
    te[11] = (n14 * t5 - n24 * t3 + n44 * t1) * detInv
    te[12] = (n23 * t3 - n13 * t5 - n43 * t1) * detInv
    te[13] = (n22 * t8 - n12 * t10 - n32 * t7) * detInv
    te[14] = (n11 * t10 - n21 * t8 + n31 * t7) * detInv
    te[15] = (n24 * t2 - n14 * t4 - n34 * t1) * detInv
    te[16] = (n13 * t4 - n23 * t2 + n33 * t1) * detInv
    return self
end

function methods:scale(v)
    local te = self.elements
    local x, y, z = v.x, v.y, v.z
    te[1] = te[1] * x; te[5] = te[5] * y; te[9] = te[9] * z
    te[2] = te[2] * x; te[6] = te[6] * y; te[10] = te[10] * z
    te[3] = te[3] * x; te[7] = te[7] * y; te[11] = te[11] * z
    te[4] = te[4] * x; te[8] = te[8] * y; te[12] = te[12] * z
    return self
end

function methods:getMaxScaleOnAxis()
    local te = self.elements
    local sx = te[1] * te[1] + te[2] * te[2] + te[3] * te[3]
    local sy = te[5] * te[5] + te[6] * te[6] + te[7] * te[7]
    local sz = te[9] * te[9] + te[10] * te[10] + te[11] * te[11]
    return math.sqrt(math.max(sx, sy, sz))
end

function methods:makeTranslation(x, y, z)
    if type(x) == "table" then x, y, z = x.x, x.y, x.z end
    return self:set(1, 0, 0, x, 0, 1, 0, y, 0, 0, 1, z, 0, 0, 0, 1)
end

function methods:makeScale(x, y, z)
    return self:set(x, 0, 0, 0, 0, y, 0, 0, 0, 0, z, 0, 0, 0, 0, 1)
end

function methods:makeRotationX(theta)
    local c, s = math.cos(theta), math.sin(theta)
    return self:set(1, 0, 0, 0, 0, c, -s, 0, 0, s, c, 0, 0, 0, 0, 1)
end

function methods:makeRotationY(theta)
    local c, s = math.cos(theta), math.sin(theta)
    return self:set(c, 0, s, 0, 0, 1, 0, 0, -s, 0, c, 0, 0, 0, 0, 1)
end

function methods:makeRotationZ(theta)
    local c, s = math.cos(theta), math.sin(theta)
    return self:set(c, -s, 0, 0, s, c, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
end

function methods:makeRotationAxis(axis, angle)
    local c = math.cos(angle)
    local s = math.sin(angle)
    local t = 1 - c
    local x, y, z = axis.x, axis.y, axis.z
    local tx, ty = t * x, t * y
    return self:set(
        tx * x + c, tx * y - s * z, tx * z + s * y, 0,
        tx * y + s * z, ty * y + c, ty * z - s * x, 0,
        tx * z - s * y, ty * z + s * x, t * z * z + c, 0,
        0, 0, 0, 1)
end

-- 透视投影矩阵（默认 WebGL NDC：z ∈ [-1,1]）。引擎相机自带投影，此方法供算法/求交使用。
function methods:makePerspective(left, right, top, bottom, near, far)
    local te = self.elements
    local x = 2 * near / (right - left)
    local y = 2 * near / (top - bottom)
    local a = (right + left) / (right - left)
    local b = (top + bottom) / (top - bottom)
    local c = -(far + near) / (far - near)
    local d = (-2 * far * near) / (far - near)
    te[1] = x; te[5] = 0; te[9] = a; te[13] = 0
    te[2] = 0; te[6] = y; te[10] = b; te[14] = 0
    te[3] = 0; te[7] = 0; te[11] = c; te[15] = d
    te[4] = 0; te[8] = 0; te[12] = -1; te[16] = 0
    return self
end

-- 正交投影矩阵（默认 WebGL NDC：z ∈ [-1,1]）。
function methods:makeOrthographic(left, right, top, bottom, near, far)
    local te = self.elements
    local w = 1.0 / (right - left)
    local h = 1.0 / (top - bottom)
    local p = 1.0 / (far - near)
    local x = (right + left) * w
    local y = (top + bottom) * h
    local z = (far + near) * p
    te[1] = 2 * w; te[5] = 0; te[9] = 0; te[13] = -x
    te[2] = 0; te[6] = 2 * h; te[10] = 0; te[14] = -y
    te[3] = 0; te[7] = 0; te[11] = -2 * p; te[15] = -z
    te[4] = 0; te[8] = 0; te[12] = 0; te[16] = 1
    return self
end

function methods:compose(position, quaternion, scale)
    local te = self.elements
    local x, y, z, w = quaternion.x, quaternion.y, quaternion.z, quaternion.w
    local x2, y2, z2 = x + x, y + y, z + z
    local xx, xy, xz = x * x2, x * y2, x * z2
    local yy, yz, zz = y * y2, y * z2, z * z2
    local wx, wy, wz = w * x2, w * y2, w * z2
    local sx, sy, sz = scale.x, scale.y, scale.z
    te[1] = (1 - (yy + zz)) * sx
    te[2] = (xy + wz) * sx
    te[3] = (xz - wy) * sx
    te[4] = 0
    te[5] = (xy - wz) * sy
    te[6] = (1 - (xx + zz)) * sy
    te[7] = (yz + wx) * sy
    te[8] = 0
    te[9] = (xz + wy) * sz
    te[10] = (yz - wx) * sz
    te[11] = (1 - (xx + yy)) * sz
    te[12] = 0
    te[13] = position.x
    te[14] = position.y
    te[15] = position.z
    te[16] = 1
    return self
end

function methods:decompose(position, quaternion, scale)
    local te = self.elements
    position:set(te[13], te[14], te[15])
    local det = self:determinant()
    if det == 0 then
        scale:set(1, 1, 1)
        quaternion:identity()
        return self
    end
    local sx = _v1:set(te[1], te[2], te[3]):length()
    local sy = _v1:set(te[5], te[6], te[7]):length()
    local sz = _v1:set(te[9], te[10], te[11]):length()
    if det < 0 then sx = -sx end
    _m1:copy(self)
    local invSX, invSY, invSZ = 1 / sx, 1 / sy, 1 / sz
    local me = _m1.elements
    me[1] = me[1] * invSX; me[2] = me[2] * invSX; me[3] = me[3] * invSX
    me[5] = me[5] * invSY; me[6] = me[6] * invSY; me[7] = me[7] * invSY
    me[9] = me[9] * invSZ; me[10] = me[10] * invSZ; me[11] = me[11] * invSZ
    quaternion:setFromRotationMatrix(_m1)
    scale:set(sx, sy, sz)
    return self
end

function methods:equals(matrix)
    local te, me = self.elements, matrix.elements
    for i = 1, 16 do
        if te[i] ~= me[i] then return false end
    end
    return true
end

function methods:fromArray(array, offset)
    offset = offset or 0
    for i = 1, 16 do self.elements[i] = array[i + offset] end
    return self
end

function methods:toArray(array, offset)
    array = array or {}
    offset = offset or 0
    local te = self.elements
    for i = 1, 16 do array[offset + i] = te[i] end
    return array
end

_m1 = Matrix4.new()

return Matrix4
