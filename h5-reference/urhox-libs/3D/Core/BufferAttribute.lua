-- ============================================================================
-- urhox-libs/3D · BufferAttribute
-- 忠实复刻 three.js BufferAttribute：扁平 Lua 数组 + itemSize，getX/Y/Z/W、setX/Y/Z/W、
-- setXYZ、count、needsUpdate。索引 i 为 0-based（three.js 语义），内部 Lua 数组 1-based。
-- needsUpdate=true → 触发所属 BufferGeometry 重传 GPU（onUpdate 回调由几何注入）。
-- ============================================================================

local BufferAttribute = {}
local methods = {}

local mt = {
    __index = function(self, k)
        if k == "count" then return math.floor(#rawget(self, "array") / rawget(self, "itemSize")) end
        if k == "needsUpdate" then return rawget(self, "_needsUpdate") end
        return methods[k]
    end,
    __newindex = function(self, k, v)
        if k == "needsUpdate" then
            rawset(self, "_needsUpdate", v)
            if v then
                local cb = rawget(self, "_onUpdate")
                if cb then cb() end
                rawset(self, "_needsUpdate", false)
            end
        else
            rawset(self, k, v)
        end
    end,
}

function BufferAttribute.new(array, itemSize, normalized)
    local self = setmetatable({}, mt)
    rawset(self, "array", array or {})
    rawset(self, "itemSize", itemSize or 3)
    rawset(self, "_needsUpdate", false)
    rawset(self, "normalized", normalized or false)
    rawset(self, "usage", 35044) -- StaticDrawUsage（three.js 默认）
    return self
end

-- i：0-based 顶点索引；comp：0=x,1=y,2=z,3=w
local function idx(self, i, comp) return i * rawget(self, "itemSize") + comp + 1 end

function methods:getX(i) return rawget(self, "array")[idx(self, i, 0)] end
function methods:getY(i) return rawget(self, "array")[idx(self, i, 1)] end
function methods:getZ(i) return rawget(self, "array")[idx(self, i, 2)] end
function methods:getW(i) return rawget(self, "array")[idx(self, i, 3)] end

function methods:setX(i, v) rawget(self, "array")[idx(self, i, 0)] = v; return self end
function methods:setY(i, v) rawget(self, "array")[idx(self, i, 1)] = v; return self end
function methods:setZ(i, v) rawget(self, "array")[idx(self, i, 2)] = v; return self end
function methods:setW(i, v) rawget(self, "array")[idx(self, i, 3)] = v; return self end

function methods:setXYZ(i, x, y, z)
    local a, base = rawget(self, "array"), i * rawget(self, "itemSize")
    a[base + 1] = x; a[base + 2] = y; a[base + 3] = z; return self
end

function methods:setXYZW(i, x, y, z, w)
    local a, base = rawget(self, "array"), i * rawget(self, "itemSize")
    a[base + 1] = x; a[base + 2] = y; a[base + 3] = z; a[base + 4] = w; return self
end

-- ---- P2 补全 -------------------------------------------------------------
function methods:setXY(i, x, y)
    local a, base = rawget(self, "array"), i * rawget(self, "itemSize")
    a[base + 1] = x; a[base + 2] = y; return self
end

function methods:getComponent(i, component)
    return rawget(self, "array")[idx(self, i, component)]
end
function methods:setComponent(i, component, value)
    rawget(self, "array")[idx(self, i, component)] = value; return self
end

-- 从 attribute 第 index 项拷贝 itemSize 个分量到 self 第 i 项
function methods:copyAt(i, attribute, index)
    local dst, src = rawget(self, "array"), rawget(attribute, "array")
    local is = rawget(self, "itemSize")
    local db, sb = i * is, index * rawget(attribute, "itemSize")
    for c = 1, is do dst[db + c] = src[sb + c] end
    return self
end

function methods:copyArray(arr) rawset(self, "array", arr); return self end
function methods:setUsage(usage) rawset(self, "usage", usage); return self end

function methods:clone()
    local a = rawget(self, "array")
    local copy = {}
    for i = 1, #a do copy[i] = a[i] end
    return BufferAttribute.new(copy, rawget(self, "itemSize"), rawget(self, "normalized"))
end

function methods:copy(attr)
    local src = rawget(attr, "array")
    local dst = {}
    for i = 1, #src do dst[i] = src[i] end
    rawset(self, "array", dst)
    rawset(self, "itemSize", rawget(attr, "itemSize"))
    rawset(self, "normalized", rawget(attr, "normalized"))
    return self
end

-- 矩阵变换（m.elements 1-based；itemSize 须为 3）。变换后需 attr.needsUpdate=true 重传。
function methods:applyMatrix3(m)
    local e = m.elements
    for i = 0, self.count - 1 do
        local x, y, z = self:getX(i), self:getY(i), self:getZ(i)
        self:setXYZ(i,
            e[1] * x + e[4] * y + e[7] * z,
            e[2] * x + e[5] * y + e[8] * z,
            e[3] * x + e[6] * y + e[9] * z)
    end
    return self
end

function methods:applyMatrix4(m)
    local e = m.elements
    for i = 0, self.count - 1 do
        local x, y, z = self:getX(i), self:getY(i), self:getZ(i)
        local w = 1 / (e[4] * x + e[8] * y + e[12] * z + e[16])
        self:setXYZ(i,
            (e[1] * x + e[5] * y + e[9] * z + e[13]) * w,
            (e[2] * x + e[6] * y + e[10] * z + e[14]) * w,
            (e[3] * x + e[7] * y + e[11] * z + e[15]) * w)
    end
    return self
end

function methods:applyNormalMatrix(m)
    self:applyMatrix3(m)
    for i = 0, self.count - 1 do
        local x, y, z = self:getX(i), self:getY(i), self:getZ(i)
        local l = math.sqrt(x * x + y * y + z * z)
        if l > 0 then self:setXYZ(i, x / l, y / l, z / l) end
    end
    return self
end

function methods:transformDirection(m)
    local e = m.elements
    for i = 0, self.count - 1 do
        local x, y, z = self:getX(i), self:getY(i), self:getZ(i)
        local nx = e[1] * x + e[5] * y + e[9] * z
        local ny = e[2] * x + e[6] * y + e[10] * z
        local nz = e[3] * x + e[7] * y + e[11] * z
        local l = math.sqrt(nx * nx + ny * ny + nz * nz)
        if l > 0 then nx, ny, nz = nx / l, ny / l, nz / l end
        self:setXYZ(i, nx, ny, nz)
    end
    return self
end

return BufferAttribute
