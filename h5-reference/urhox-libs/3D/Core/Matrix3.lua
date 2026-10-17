-- ============================================================================
-- urhox-libs/3D · Matrix3
-- 忠实复刻 three.js Matrix3（3x3，列主序）。纯 Lua，无引擎依赖。
-- 存储：elements 为 1-based Lua 数组，elements[k] 对应 three.js te[k-1]。
-- 主要用途：法线矩阵（getNormalMatrix）、纹理 UV 变换（setUvTransform）、Vector3/Color.applyMatrix3。
-- ============================================================================

local Matrix3 = {}
local methods = {}
local mt = { __index = methods }

local _m3 -- 延迟构造（scale/rotate/translate 用的 scratch）

function Matrix3.new()
    local o = setmetatable({}, mt)
    o.elements = { 1, 0, 0, 0, 1, 0, 0, 0, 1 }
    return o
end
Matrix3.isMatrix3 = true

function methods:set(n11, n12, n13, n21, n22, n23, n31, n32, n33)
    local te = self.elements
    te[1] = n11; te[2] = n21; te[3] = n31
    te[4] = n12; te[5] = n22; te[6] = n32
    te[7] = n13; te[8] = n23; te[9] = n33
    return self
end

function methods:identity()
    return self:set(1, 0, 0, 0, 1, 0, 0, 0, 1)
end

function methods:copy(m)
    local te, me = self.elements, m.elements
    for i = 1, 9 do te[i] = me[i] end
    return self
end

function methods:extractBasis(xAxis, yAxis, zAxis)
    xAxis:setFromMatrix3Column(self, 0)
    yAxis:setFromMatrix3Column(self, 1)
    zAxis:setFromMatrix3Column(self, 2)
    return self
end

function methods:setFromMatrix4(m)
    local me = m.elements
    return self:set(
        me[1], me[5], me[9],
        me[2], me[6], me[10],
        me[3], me[7], me[11])
end

function methods:multiply(m) return self:multiplyMatrices(self, m) end
function methods:premultiply(m) return self:multiplyMatrices(m, self) end

function methods:multiplyMatrices(a, b)
    local ae, be, te = a.elements, b.elements, self.elements
    local a11, a12, a13 = ae[1], ae[4], ae[7]
    local a21, a22, a23 = ae[2], ae[5], ae[8]
    local a31, a32, a33 = ae[3], ae[6], ae[9]
    local b11, b12, b13 = be[1], be[4], be[7]
    local b21, b22, b23 = be[2], be[5], be[8]
    local b31, b32, b33 = be[3], be[6], be[9]
    te[1] = a11 * b11 + a12 * b21 + a13 * b31
    te[4] = a11 * b12 + a12 * b22 + a13 * b32
    te[7] = a11 * b13 + a12 * b23 + a13 * b33
    te[2] = a21 * b11 + a22 * b21 + a23 * b31
    te[5] = a21 * b12 + a22 * b22 + a23 * b32
    te[8] = a21 * b13 + a22 * b23 + a23 * b33
    te[3] = a31 * b11 + a32 * b21 + a33 * b31
    te[6] = a31 * b12 + a32 * b22 + a33 * b32
    te[9] = a31 * b13 + a32 * b23 + a33 * b33
    return self
end

function methods:multiplyScalar(s)
    local te = self.elements
    for i = 1, 9 do te[i] = te[i] * s end
    return self
end

function methods:determinant()
    local te = self.elements
    local a, b, c = te[1], te[2], te[3]
    local d, e, f = te[4], te[5], te[6]
    local g, h, i = te[7], te[8], te[9]
    return a * e * i - a * f * h - b * d * i + b * f * g + c * d * h - c * e * g
end

function methods:invert()
    local te = self.elements
    local n11, n21, n31 = te[1], te[2], te[3]
    local n12, n22, n32 = te[4], te[5], te[6]
    local n13, n23, n33 = te[7], te[8], te[9]
    local t11 = n33 * n22 - n32 * n23
    local t12 = n32 * n13 - n33 * n12
    local t13 = n23 * n12 - n22 * n13
    local det = n11 * t11 + n21 * t12 + n31 * t13
    if det == 0 then return self:set(0, 0, 0, 0, 0, 0, 0, 0, 0) end
    local detInv = 1 / det
    te[1] = t11 * detInv
    te[2] = (n31 * n23 - n33 * n21) * detInv
    te[3] = (n32 * n21 - n31 * n22) * detInv
    te[4] = t12 * detInv
    te[5] = (n33 * n11 - n31 * n13) * detInv
    te[6] = (n31 * n12 - n32 * n11) * detInv
    te[7] = t13 * detInv
    te[8] = (n21 * n13 - n23 * n11) * detInv
    te[9] = (n22 * n11 - n21 * n12) * detInv
    return self
end

function methods:transpose()
    local m = self.elements
    local tmp
    tmp = m[2]; m[2] = m[4]; m[4] = tmp
    tmp = m[3]; m[3] = m[7]; m[7] = tmp
    tmp = m[6]; m[6] = m[8]; m[8] = tmp
    return self
end

function methods:getNormalMatrix(matrix4)
    return self:setFromMatrix4(matrix4):invert():transpose()
end

function methods:transposeIntoArray(r)
    local m = self.elements
    r[1] = m[1]; r[2] = m[4]; r[3] = m[7]
    r[4] = m[2]; r[5] = m[5]; r[6] = m[8]
    r[7] = m[3]; r[8] = m[6]; r[9] = m[9]
    return self
end

function methods:setUvTransform(tx, ty, sx, sy, rotation, cx, cy)
    local c = math.cos(rotation)
    local s = math.sin(rotation)
    return self:set(
        sx * c, sx * s, -sx * (c * cx + s * cy) + cx + tx,
        -sy * s, sy * c, -sy * (-s * cx + c * cy) + cy + ty,
        0, 0, 1)
end

function methods:scale(sx, sy)
    return self:premultiply(_m3:makeScale(sx, sy))
end

function methods:rotate(theta)
    return self:premultiply(_m3:makeRotation(-theta))
end

function methods:translate(tx, ty)
    return self:premultiply(_m3:makeTranslation(tx, ty))
end

function methods:makeTranslation(x, y)
    if type(x) == "table" then x, y = x.x, x.y end
    return self:set(1, 0, x, 0, 1, y, 0, 0, 1)
end

function methods:makeRotation(theta)
    local c = math.cos(theta)
    local s = math.sin(theta)
    return self:set(c, -s, 0, s, c, 0, 0, 0, 1)
end

function methods:makeScale(x, y)
    return self:set(x, 0, 0, 0, y, 0, 0, 0, 1)
end

function methods:equals(matrix)
    local te, me = self.elements, matrix.elements
    for i = 1, 9 do
        if te[i] ~= me[i] then return false end
    end
    return true
end

function methods:fromArray(array, offset)
    offset = offset or 0
    for i = 1, 9 do self.elements[i] = array[i + offset] end
    return self
end

function methods:toArray(array, offset)
    array = array or {}
    offset = offset or 0
    local te = self.elements
    for i = 1, 9 do array[offset + i] = te[i] end
    return array
end

function methods:clone() return Matrix3.new():fromArray(self.elements) end

_m3 = Matrix3.new()

return Matrix3
