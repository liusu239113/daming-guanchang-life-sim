-- ============================================================================
-- urhox-libs/3D · BufferGeometry
-- 忠实复刻 three.js BufferGeometry：保留 CPU 端 attributes(position/normal/uv) + index，
-- 支持运行时改顶点(attributes.position.setZ + needsUpdate → 重传 GPU)、computeVertexNormals、
-- translate/rotateX/Y/Z/scale。后端 = CustomGeometry，needsUpdate 时整段重 emit。
--
-- index：扁平数组，元素为 0-based 顶点索引（three.js 语义）；nil = 非索引(顺序三角)。
-- 注：动态几何 + 运行时换材质同时用是边缘情形（重 emit 会复用 build 时的材质）。
-- ============================================================================

local BufferAttribute = require("urhox-libs/3D/Core/BufferAttribute")
local Box3 = require("urhox-libs/3D/Core/Box3")
local Sphere = require("urhox-libs/3D/Core/Sphere")
local Matrix3 = require("urhox-libs/3D/Core/Matrix3")
local Matrix4 = require("urhox-libs/3D/Core/Matrix4")
local Vec3 = require("urhox-libs/3D/Core/Vector3")

local NativeVector3 = Vector3
local NativeVector2 = Vector2

local BufferGeometry = {}
local methods = {}

local mt = {
    __index = function(self, k)
        if k == "attributes" then return rawget(self, "_attributes") end
        if k == "index" then return rawget(self, "_index") end
        if k == "groups" then return rawget(self, "_groups") end
        if k == "drawRange" then return rawget(self, "_drawRange") end
        return methods[k]
    end,
    __newindex = function(self, k, v) rawset(self, k, v) end,
}

function BufferGeometry.new()
    local self = setmetatable({}, mt)
    rawset(self, "_attributes", {})
    rawset(self, "_index", nil)
    rawset(self, "_nativeMat", nil)
    return self
end

function methods:setAttribute(name, attr) rawget(self, "_attributes")[name] = attr; return self end
function methods:getAttribute(name) return rawget(self, "_attributes")[name] end
function methods:setIndex(arr) rawset(self, "_index", arr); return self end

-- 从当前 attributes/index 重新 emit 到 CustomGeometry（build 与 needsUpdate 都走它）
-- 支持 groups（多材质：每 group 一个 CustomGeometry 子几何）与 drawRange（无 group 时限定范围）。
local function emit(self)
    local geom = rawget(self, "_component")
    if not geom then return end
    local attrs = rawget(self, "_attributes")
    local pos, nrm, uv = attrs.position, attrs.normal, attrs.uv
    if not pos then return end
    local index = rawget(self, "_index")
    local groups = rawget(self, "_groups")

    local function vert(i)
        geom:DefineVertex(NativeVector3(pos:getX(i), pos:getY(i), pos:getZ(i)))
        if nrm then geom:DefineNormal(NativeVector3(nrm:getX(i), nrm:getY(i), nrm:getZ(i)))
        else geom:DefineNormal(NativeVector3(0, 1, 0)) end
        if uv then geom:DefineTexCoord(NativeVector2(uv:getX(i), uv:getY(i)))
        else geom:DefineTexCoord(NativeVector2(0, 0)) end
    end
    -- start/count 为 three.js 语义：索引几何下是 index 偏移，非索引下是顶点偏移
    local function emitRange(geomIndex, start, count)
        geom:BeginGeometry(geomIndex, TRIANGLE_LIST)
        if index then
            for t = start + 1, start + count, 3 do vert(index[t]); vert(index[t + 1]); vert(index[t + 2]) end
        else
            for v = start, start + count - 1 do vert(v) end
        end
    end

    if groups and #groups > 0 then
        geom:SetNumGeometries(#groups) -- 必须先扩容，否则 BeginGeometry(gi>0) 越界报错、顶点错位
        for gi = 1, #groups do
            local g = groups[gi]
            emitRange(gi - 1, g.start, g.count)
        end
    else
        geom:SetNumGeometries(1) -- 复位（防 clearGroups 后残留多余子几何）
        local total = index and #index or pos.count
        local dr = rawget(self, "_drawRange")
        local start = (dr and dr.start) or 0
        local count = (dr and dr.count and dr.count >= 0) and dr.count or (total - start)
        count = math.min(count, total - start) -- math.huge(three.js Infinity)/越界 → 全部绘制
        emitRange(0, start, count)
    end
    geom:Commit()
    local m = rawget(self, "_nativeMat")
    if m then geom:SetMaterial(m) end -- 重 emit 后复用材质（材质数组由 Mesh 逐 group 覆盖）
end

function methods:build(node, nativeMaterial)
    local geom = node:CreateComponent("CustomGeometry")
    rawset(self, "_component", geom)
    rawset(self, "_nativeMat", nativeMaterial)
    emit(self)
    -- 把 position/normal/uv 的 needsUpdate → 重传 GPU
    local function reupload() emit(self) end
    local attrs = rawget(self, "_attributes")
    for _, name in ipairs({ "position", "normal", "uv" }) do
        if attrs[name] then rawset(attrs[name], "_onUpdate", reupload) end
    end
    return geom
end

-- three.js computeVertexNormals：按面法线累加到顶点再归一化
function methods:computeVertexNormals()
    local pos = rawget(self, "_attributes").position
    if not pos then return self end
    local index = rawget(self, "_index")
    local cnt = pos.count
    local nx, ny, nz = {}, {}, {}
    for i = 0, cnt - 1 do nx[i] = 0; ny[i] = 0; nz[i] = 0 end
    local function face(ia, ib, ic)
        local ax, ay, az = pos:getX(ia), pos:getY(ia), pos:getZ(ia)
        local bx, by, bz = pos:getX(ib), pos:getY(ib), pos:getZ(ib)
        local cx, cy, cz = pos:getX(ic), pos:getY(ic), pos:getZ(ic)
        local e1x, e1y, e1z = bx - ax, by - ay, bz - az
        local e2x, e2y, e2z = cx - ax, cy - ay, cz - az
        local fx = e1y * e2z - e1z * e2y
        local fy = e1z * e2x - e1x * e2z
        local fz = e1x * e2y - e1y * e2x
        nx[ia] = nx[ia] + fx; ny[ia] = ny[ia] + fy; nz[ia] = nz[ia] + fz
        nx[ib] = nx[ib] + fx; ny[ib] = ny[ib] + fy; nz[ib] = nz[ib] + fz
        nx[ic] = nx[ic] + fx; ny[ic] = ny[ic] + fy; nz[ic] = nz[ic] + fz
    end
    if index then
        for t = 1, #index, 3 do face(index[t], index[t + 1], index[t + 2]) end
    else
        for i = 0, cnt - 1, 3 do face(i, i + 1, i + 2) end
    end
    local na = rawget(self, "_attributes").normal
    if not na then
        na = BufferAttribute.new({}, 3); self:setAttribute("normal", na)
        if rawget(self, "_component") then rawset(na, "_onUpdate", function() emit(self) end) end
    end
    for i = 0, cnt - 1 do
        local x, y, z = nx[i], ny[i], nz[i]
        local l = math.sqrt(x * x + y * y + z * z)
        if l > 0 then x, y, z = x / l, y / l, z / l end
        na:setXYZ(i, x, y, z)
    end
    if rawget(self, "_component") then emit(self) end
    return self
end

-- 顶点变换（构造期或运行时；运行时自动重传）
local function eachPos(self, fn)
    local pos = rawget(self, "_attributes").position
    if not pos then return end
    for i = 0, pos.count - 1 do
        local x, y, z = fn(pos:getX(i), pos:getY(i), pos:getZ(i))
        pos:setXYZ(i, x, y, z)
    end
    if rawget(self, "_component") then emit(self) end
end

function methods:translate(x, y, z)
    eachPos(self, function(px, py, pz) return px + x, py + y, pz + z end)
    return self
end

function methods:scale(x, y, z)
    eachPos(self, function(px, py, pz) return px * x, py * y, pz * z end)
    return self
end

function methods:rotateX(a)
    local c, s = math.cos(a), math.sin(a)
    eachPos(self, function(x, y, z) return x, y * c - z * s, y * s + z * c end)
    return self
end

function methods:rotateY(a)
    local c, s = math.cos(a), math.sin(a)
    eachPos(self, function(x, y, z) return x * c + z * s, y, -x * s + z * c end)
    return self
end

function methods:rotateZ(a)
    local c, s = math.cos(a), math.sin(a)
    eachPos(self, function(x, y, z) return x * c - y * s, x * s + y * c, z end)
    return self
end

-- ---- P2 补全 -------------------------------------------------------------
function methods:getIndex() return rawget(self, "_index") end
function methods:hasAttribute(name) return rawget(self, "_attributes")[name] ~= nil end
function methods:deleteAttribute(name) rawget(self, "_attributes")[name] = nil; return self end

-- 点数组（Vector3 / {x,y,z}）→ position 属性
function methods:setFromPoints(points)
    local arr = {}
    for i = 1, #points do
        local p = points[i]
        arr[#arr + 1] = p.x; arr[#arr + 1] = p.y; arr[#arr + 1] = p.z or 0
    end
    self:setAttribute("position", BufferAttribute.new(arr, 3))
    return self
end

function methods:computeBoundingBox()
    local pos = rawget(self, "_attributes").position
    if not pos then return self end
    local box = rawget(self, "boundingBox") or Box3.new()
    box:setFromBufferAttribute(pos)
    rawset(self, "boundingBox", box)
    return self
end

function methods:computeBoundingSphere()
    local pos = rawget(self, "_attributes").position
    if not pos then return self end
    local sph = rawget(self, "boundingSphere") or Sphere.new()
    local box = Box3.new():setFromBufferAttribute(pos)
    local center = box:getCenter(sph.center)
    local maxSq = 0
    local v = Vec3.new()
    for i = 0, pos.count - 1 do
        v:fromBufferAttribute(pos, i)
        maxSq = math.max(maxSq, center:distanceToSquared(v))
    end
    sph.radius = math.sqrt(maxSq)
    rawset(self, "boundingSphere", sph)
    return self
end

-- 以包围盒中心居中
function methods:center()
    self:computeBoundingBox()
    local c = rawget(self, "boundingBox"):getCenter(Vec3.new())
    self:translate(-c.x, -c.y, -c.z)
    return self
end

function methods:normalizeNormals()
    local nrm = rawget(self, "_attributes").normal
    if not nrm then return self end
    for i = 0, nrm.count - 1 do
        local x, y, z = nrm:getX(i), nrm:getY(i), nrm:getZ(i)
        local l = math.sqrt(x * x + y * y + z * z)
        if l > 0 then nrm:setXYZ(i, x / l, y / l, z / l) end
    end
    if rawget(self, "_component") then emit(self) end
    return self
end

function methods:setDrawRange(start, count)
    rawset(self, "_drawRange", { start = start, count = count })
    if rawget(self, "_component") then emit(self) end
    return self
end

function methods:addGroup(start, count, materialIndex)
    local groups = rawget(self, "_groups")
    if not groups then groups = {}; rawset(self, "_groups", groups) end
    groups[#groups + 1] = { start = start, count = count, materialIndex = materialIndex or 0 }
    if rawget(self, "_component") then emit(self) end
    return self
end

function methods:clearGroups()
    rawset(self, "_groups", {})
    if rawget(self, "_component") then emit(self) end
    return self
end

-- 矩阵变换整段几何（position + normal 法线矩阵）；运行时自动重传
function methods:applyMatrix4(m)
    local attrs = rawget(self, "_attributes")
    if attrs.position then attrs.position:applyMatrix4(m) end
    if attrs.normal then attrs.normal:applyNormalMatrix(Matrix3.new():getNormalMatrix(m)) end
    if attrs.tangent then attrs.tangent:transformDirection(m) end
    if rawget(self, "boundingBox") then self:computeBoundingBox() end
    if rawget(self, "boundingSphere") then self:computeBoundingSphere() end
    if rawget(self, "_component") then emit(self) end
    return self
end

function methods:applyQuaternion(q)
    return self:applyMatrix4(Matrix4.new():makeRotationFromQuaternion(q))
end

-- 旋转几何使其 +Z 朝向 vector（对标 three.js geometry.lookAt）
function methods:lookAt(vector)
    return self:applyMatrix4(Matrix4.new():lookAt(Vec3.new(0, 0, 0), vector, Vec3.new(0, 1, 0)))
end

-- 索引展开为非索引（顺序属性），返回新 BufferGeometry
function methods:toNonIndexed()
    local index = rawget(self, "_index")
    if not index then return self end
    local g2 = BufferGeometry.new()
    local attrs = rawget(self, "_attributes")
    for name, attr in pairs(attrs) do
        local is = rawget(attr, "itemSize")
        local src = rawget(attr, "array")
        local out = {}
        local o = 0
        for i = 1, #index do
            local base = index[i] * is
            for c = 1, is do o = o + 1; out[o] = src[base + c] end
        end
        g2:setAttribute(name, BufferAttribute.new(out, is, rawget(attr, "normalized")))
    end
    return g2
end

function methods:clone()
    local g2 = BufferGeometry.new()
    local attrs = rawget(self, "_attributes")
    for name, attr in pairs(attrs) do g2:setAttribute(name, attr:clone()) end
    local index = rawget(self, "_index")
    if index then
        local copy = {}
        for i = 1, #index do copy[i] = index[i] end
        g2:setIndex(copy)
    end
    local groups = rawget(self, "_groups")
    if groups then
        for i = 1, #groups do
            local g = groups[i]; g2:addGroup(g.start, g.count, g.materialIndex)
        end
    end
    return g2
end

-- three.js dispose：释放。保留模式下 CustomGeometry 生命周期随 Mesh 节点；此处断引用即可。
function methods:dispose()
    rawset(self, "_nativeMat", nil)
    return self
end

return BufferGeometry
