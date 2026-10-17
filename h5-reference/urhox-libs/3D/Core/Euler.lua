-- ============================================================================
-- urhox-libs/3D · Euler
-- three.js Euler(x, y, z, order)。弧度。独立实例用；Object3D.rotation 是其活视图等价物。
-- Phase 0.5：order 仅记录，实际旋转换算固定 XYZ（§4.10）。
-- ============================================================================

local Convert = require("urhox-libs/3D/Core/Convert")

local Euler = {}
local methods = {}
local mt = { __index = methods, __tostring = function(s)
    return string.format("Euler(%.3f, %.3f, %.3f, %s)", s.x, s.y, s.z, s.order)
end }

local warnedReorder = false

function Euler.new(x, y, z, order)
    return setmetatable({ x = x or 0, y = y or 0, z = z or 0, order = order or "XYZ" }, mt)
end

function methods:set(x, y, z, order)
    self.x, self.y, self.z = x, y, z
    if order then self.order = order end
    return self
end

function methods:copy(e)
    self.x, self.y, self.z, self.order = e.x, e.y, e.z, e.order or self.order
    return self
end

function methods:clone() return Euler.new(self.x, self.y, self.z, self.order) end

-- 从四元数反推欧拉角（固定 XYZ；复用 Convert.quatToEuler，与 Object3D.rotation 读取一致）
function methods:setFromQuaternion(q, order)
    local ex, ey, ez = Convert.quatToEuler(q.w, q.x, q.y, q.z)
    self.x, self.y, self.z = ex, ey, ez
    if order then self.order = order end
    return self
end

function methods:setFromVector3(v, order)
    self.x, self.y, self.z = v.x, v.y, v.z
    if order then self.order = order end
    return self
end

-- order 仅记录（实际换算固定 XYZ）；调用 reorder 时若改成非 XYZ 给一次告警
function methods:reorder(order)
    self.order = order
    if order ~= "XYZ" and not warnedReorder then
        warnedReorder = true
        -- @diagnostic disable-next-line: undefined-global
        if log then log:Write(LOG_WARNING, "Euler.reorder: 仅支持 XYZ 顺序，其它 order 仅记录不生效") end
    end
    return self
end

function methods:fromArray(arr)
    self.x, self.y, self.z = arr[1], arr[2], arr[3]
    if arr[4] then self.order = arr[4] end
    return self
end

function methods:toArray() return { self.x, self.y, self.z, self.order } end

function methods:equals(e) return self.x == e.x and self.y == e.y and self.z == e.z and self.order == e.order end

-- 从纯旋转矩阵（Matrix4，左上 3x3 须为正交无缩放）按指定 order 反推欧拉角。m.elements 1-based。
local function clamp(v, lo, hi) return math.max(lo, math.min(hi, v)) end
function methods:setFromRotationMatrix(m, order)
    order = order or self.order
    local te = m.elements
    local m11, m12, m13 = te[1], te[5], te[9]
    local m21, m22, m23 = te[2], te[6], te[10]
    local m31, m32, m33 = te[3], te[7], te[11]
    if order == "XYZ" then
        self.y = math.asin(clamp(m13, -1, 1))
        if math.abs(m13) < 0.9999999 then
            self.x = math.atan(-m23, m33); self.z = math.atan(-m12, m11)
        else
            self.x = math.atan(m32, m22); self.z = 0
        end
    elseif order == "YXZ" then
        self.x = math.asin(-clamp(m23, -1, 1))
        if math.abs(m23) < 0.9999999 then
            self.y = math.atan(m13, m33); self.z = math.atan(m21, m22)
        else
            self.y = math.atan(-m31, m11); self.z = 0
        end
    elseif order == "ZXY" then
        self.x = math.asin(clamp(m32, -1, 1))
        if math.abs(m32) < 0.9999999 then
            self.y = math.atan(-m31, m33); self.z = math.atan(-m12, m22)
        else
            self.y = 0; self.z = math.atan(m21, m11)
        end
    elseif order == "ZYX" then
        self.y = math.asin(-clamp(m31, -1, 1))
        if math.abs(m31) < 0.9999999 then
            self.x = math.atan(m32, m33); self.z = math.atan(m21, m11)
        else
            self.x = 0; self.z = math.atan(-m12, m22)
        end
    elseif order == "YZX" then
        self.z = math.asin(clamp(m21, -1, 1))
        if math.abs(m21) < 0.9999999 then
            self.x = math.atan(-m23, m22); self.y = math.atan(-m31, m11)
        else
            self.x = 0; self.y = math.atan(m13, m33)
        end
    elseif order == "XZY" then
        self.z = math.asin(-clamp(m12, -1, 1))
        if math.abs(m12) < 0.9999999 then
            self.x = math.atan(m32, m22); self.y = math.atan(m13, m11)
        else
            self.x = math.atan(-m23, m33); self.y = 0
        end
    end
    self.order = order
    return self
end

return Euler
