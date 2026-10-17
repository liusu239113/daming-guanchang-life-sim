-- ============================================================================
-- urhox-libs/3D · InstancedMesh（最小版）
-- three.js InstancedMesh(geometry, material, count)。Object3D + StaticModelGroup。
--
-- 几何经 GeometryToModel 转 Model 后交给 StaticModelGroup；每个实例是 group 节点下的
-- 子 Node，AddInstanceNode 注册。实例 Node 的世界变换 = 本对象世界 × 子 local，
-- 故 setMatrixAt 的矩阵（本地实例矩阵）直接写子 Node local，等价 three.js
-- final = instancedMesh.matrixWorld × instanceMatrix。
--
-- 最小范围：setMatrixAt/getMatrixAt/count。setColorAt（逐实例色）后续。
-- ============================================================================

local NativeVector3 = Vector3      -- 引擎原生构造器（在 require 遮蔽前捕获）
local NativeQuaternion = Quaternion

local Object3D = require("urhox-libs/3D/Core/Object3D")
local Matrix4 = require("urhox-libs/3D/Core/Matrix4")
local Vec3 = require("urhox-libs/3D/Core/Vector3")
local Quat = require("urhox-libs/3D/Core/Quaternion")
local GeometryToModel = require("urhox-libs/3D/Core/GeometryToModel")

local IM = {}
local imMethods = {}

local function nativeOf(m) return m and m.getNative and m:getNative() or nil end

local function img(self, k)
    if k == "isInstancedMesh" or k == "isMesh" then return true end
    if k == "type" then return "InstancedMesh" end
    if k == "geometry" then return rawget(self, "_geometry") end
    if k == "material" then return rawget(self, "_material") end
    if k == "count" then return rawget(self, "_count") end
    return nil
end

local function ims(self, k, v)
    if k == "material" then
        rawset(self, "_material", v)
        local g = rawget(self, "_group")
        local native = nativeOf(v)
        if g and native then g.material = native end
        return true
    end
    if k == "setColorAt" then return true end -- 占位，下同 method 警告
    return false
end

local mt = Object3D.makeMeta(imMethods, img, ims)

function IM.new(geometry, material, count)
    count = count or 1
    local self = setmetatable({}, mt)
    Object3D.setup(self)
    local node = self:getNode()
    local group = node:CreateComponent("StaticModelGroup")
    local model = GeometryToModel.toModel(geometry)
    if model then group.model = model end
    local native = nativeOf(material)
    if native then group.material = native end

    local insts = {}
    for i = 1, count do
        local inode = node:CreateChild("instance")
        group:AddInstanceNode(inode)
        insts[i] = inode
    end
    rawset(self, "_group", group)
    rawset(self, "_geometry", geometry)
    rawset(self, "_material", material)
    rawset(self, "_count", count)
    rawset(self, "_instances", insts)
    return self
end

-- 设第 i 个实例（0-based，three.js）的本地矩阵。matrix 为本库 Matrix4。
function imMethods:setMatrixAt(i, matrix)
    local inode = rawget(self, "_instances")[i + 1]
    if not inode then return self end
    local p, q, s = Vec3.new(), Quat.new(), Vec3.new()
    matrix:decompose(p, q, s)
    inode.position = NativeVector3(p.x, p.y, p.z)
    inode.rotation = NativeQuaternion(q.w, q.x, q.y, q.z) -- 原生 (w,x,y,z) ↔ three.js (x,y,z,w)
    inode.scale = NativeVector3(s.x, s.y, s.z)
    return self
end

-- 读第 i 个实例矩阵到 target（本库 Matrix4），返回 target。
function imMethods:getMatrixAt(i, target)
    target = target or Matrix4.new()
    local inode = rawget(self, "_instances")[i + 1]
    if not inode then return target end
    local p, r, s = inode.position, inode.rotation, inode.scale
    return target:compose(
        { x = p.x, y = p.y, z = p.z },
        { x = r.x, y = r.y, z = r.z, w = r.w },
        { x = s.x, y = s.y, z = s.z })
end

function imMethods:setColorAt(i, color)
    log:Write(LOG_ERROR, "InstancedMesh: setColorAt 暂未支持（逐实例色需 instanceColor 顶点流），已忽略。")
    return self
end

function imMethods:getGroup() return rawget(self, "_group") end

return IM
