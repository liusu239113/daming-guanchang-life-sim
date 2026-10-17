-- ============================================================================
-- urhox-libs/3D · Object3D
-- 忠实复刻 three.js Object3D。1:1 包装一个 UrhoX Node。设计见 §4.1 / §4.10 / §2.3。
-- ============================================================================
--
-- 薄封装：变换读写直达底层 Node。逃生通道 :getNode()。
--   .position / .scale  活视图 → 直读写 Node.position / Node.scale
--   .rotation           Euler(弧度, XYZ)：读=从 Node 四元数实时反推、写=重算 Node 四元数（始终同步）
--   .visible → Node.enabled ; .name → Node.name
--   .children            子对象数组（持久维护，three.js 场景图真源）
--   .parent              父对象（add/remove 维护）
--
-- 可子类化：Mesh/Group/Light/Camera 用 Object3D.makeMeta(subMethods, get, set) 造元表，
--   并在构造里调 Object3D.setup(self [, node]) 初始化 node + 变换活视图 + children。
-- ============================================================================

local NativeVector3 = Vector3 -- 引擎原生构造器，在下行 require 遮蔽前捕获
local Vector3 = require("urhox-libs/3D/Core/Vector3")
local QuaternionLib = require("urhox-libs/3D/Core/Quaternion") -- 用 QuaternionLib 命名，避免遮蔽 lookAt 用的全局原生 Quaternion
local Convert = require("urhox-libs/3D/Core/Convert")
local Matrix4 = require("urhox-libs/3D/Core/Matrix4")

local Object3D = {}
local methods = {}
Object3D.methods = methods

-- ---- id / uuid / layers 辅助 -----------------------------------------------
local nextId = 0

-- 私有 LCG 生成 uuid：不调 math.randomseed、不碰全局 math.random / 引擎 Random()，
-- 避免污染游戏逻辑随机流。种子取 os 时间（跨运行不同）；隔离环境无 os 时退化为 0，
-- 但每次生成混入自增 id，保证同进程内唯一。
local rngState
do
    local ok, seed = pcall(function() return os.time() + math.floor((os.clock() or 0) * 1e6) end)
    rngState = ((ok and seed) or 0) & 0x7fffffff
end
local HEX = "0123456789abcdef"
local function genUuid()
    rngState = (rngState ~ (nextId * 2654435761)) & 0x7fffffff -- 混入唯一 id
    local function h(n)
        local s = ""
        for _ = 1, n do
            rngState = (rngState * 1103515245 + 12345) & 0x7fffffff
            local k = (rngState >> 16) % 16 -- 取高位更随机
            s = s .. HEX:sub(k + 1, k + 1)
        end
        return s
    end
    return (h(8) .. "-" .. h(4) .. "-4" .. h(3) .. "-" .. h(4) .. "-" .. h(12)):upper()
end

-- layers mask → 底层 Drawable:SetViewMask（best-effort：Mesh/Line/Points 的 _component 或灯的 _light）
local function applyViewMask(self, mask)
    local d = rawget(self, "_component") or rawget(self, "_light")
    if d and d.SetViewMask then d:SetViewMask(mask) end
end

-- three.js Layers（mask + set/enable/disable/toggle/test/isEnabled），变更即 best-effort 应用
local function makeLayers(obj)
    local L = { mask = 1 }
    local function apply() applyViewMask(obj, L.mask) end
    function L:set(ch) self.mask = (1 << ch) & 0xffffffff; apply() end
    function L:enable(ch) self.mask = self.mask | (1 << ch); apply() end
    function L:enableAll() self.mask = 0xffffffff; apply() end
    function L:disable(ch) self.mask = self.mask & (~(1 << ch) & 0xffffffff); apply() end
    function L:disableAll() self.mask = 0; apply() end
    function L:toggle(ch) self.mask = self.mask ~ (1 << ch); apply() end
    function L:test(layers) return (self.mask & layers.mask) ~= 0 end
    function L:isEnabled(ch) return (self.mask & (1 << ch)) ~= 0 end
    return L
end

-- ---- 实例初始化（子类在自己的实例上调用）---------------------------------
function Object3D.setup(self, node)
    local n = node or Node()
    rawset(self, "_node", n)
    rawset(self, "_children", {})

    rawset(self, "_position", Vector3.bound(
        function() local p = n.position; return p.x, p.y, p.z end,
        function(_, x, y, z) n.position = NativeVector3(x, y, z) end
    ))
    rawset(self, "_scale", Vector3.bound(
        function() local s = n.scale; return s.x, s.y, s.z end,
        function(_, x, y, z) n.scale = NativeVector3(x, y, z) end
    ))
    -- rotation：Euler(弧度, XYZ)。读=节点四元数实时反推；写=欧拉→四元数写回。
    rawset(self, "_rotation", Vector3.bound(
        function()
            local q = n.rotation
            return Convert.quatToEuler(q.w, q.x, q.y, q.z)
        end,
        function(_, x, y, z) n.rotation = Convert.eulerToUrhoQuat(x, y, z) end
    ))
    -- quaternion：活视图，直达节点旋转。three.js 序 (x,y,z,w) ↔ 原生 Quaternion(w,x,y,z)。
    -- 与 rotation(Euler) 共享同一节点旋转，读写互相一致（同 three.js）。
    rawset(self, "_quaternion", QuaternionLib.bound(
        function() local q = n.rotation; return q.x, q.y, q.z, q.w end,
        function(_, x, y, z, w) n.rotation = Quaternion(w, x, y, z) end
    ))
    rawset(self, "_up", Vector3.new(0, 1, 0))   -- three.js 默认 up
    rawset(self, "_userData", {})               -- three.js userData（任意挂载数据）
    nextId = nextId + 1
    rawset(self, "_id", nextId)                 -- three.js 自增 id
    return self
end

-- ---- 共享属性路由（基类 transform/visible/name/children/parent）-----------
-- getProp 返回 nil 表示"未处理"（交给上层 methods）。
function Object3D.getProp(self, k)
    if k == "position" then return rawget(self, "_position") end
    if k == "rotation" then return rawget(self, "_rotation") end
    if k == "quaternion" then return rawget(self, "_quaternion") end
    if k == "scale" then return rawget(self, "_scale") end
    if k == "up" then return rawget(self, "_up") end
    if k == "userData" then return rawget(self, "_userData") end
    if k == "visible" then return rawget(self, "_node").enabled end
    if k == "name" then return rawget(self, "_node").name end
    if k == "children" then return rawget(self, "_children") end
    if k == "parent" then return rawget(self, "_parent") end
    if k == "id" then return rawget(self, "_id") end
    if k == "uuid" then
        local u = rawget(self, "_uuid")
        if not u then u = genUuid(); rawset(self, "_uuid", u) end
        return u
    end
    if k == "type" then return "Object3D" end -- 子类 extraGet 优先返回各自 type
    if k == "renderOrder" then return rawget(self, "_renderOrder") or 0 end
    if k == "frustumCulled" then
        local f = rawget(self, "_frustumCulled"); if f == nil then return true end; return f
    end
    if k == "matrixAutoUpdate" then
        local m = rawget(self, "_matrixAutoUpdate"); if m == nil then return true end; return m
    end
    if k == "layers" then
        local L = rawget(self, "_layers")
        if not L then L = makeLayers(self); rawset(self, "_layers", L) end
        return L
    end
    return nil
end

-- setProp 返回 true 表示"已处理"。
function Object3D.setProp(self, k, v)
    if k == "position" then rawget(self, "_position"):copy(v) return true end
    if k == "rotation" then rawget(self, "_rotation"):copy(v) return true end
    if k == "quaternion" then rawget(self, "_quaternion"):copy(v) return true end
    if k == "scale" then rawget(self, "_scale"):copy(v) return true end
    if k == "up" then rawget(self, "_up"):copy(v) return true end
    if k == "userData" then rawset(self, "_userData", v) return true end
    if k == "visible" then rawget(self, "_node").enabled = v return true end
    if k == "name" then rawget(self, "_node").name = v return true end
    if k == "frustumCulled" then rawset(self, "_frustumCulled", v) return true end -- 存值（Urho 恒视锥剔除）
    if k == "matrixAutoUpdate" then rawset(self, "_matrixAutoUpdate", v) return true end -- 保留模式 no-op
    if k == "renderOrder" then
        rawset(self, "_renderOrder", v)
        -- best-effort：映射到材质渲染序（three.js 0 ↔ Urho 128）
        local m = rawget(self, "_material")
        if m and m.getNative then
            local nm = m:getNative()
            if nm and nm.SetRenderOrder then nm:SetRenderOrder(math.max(0, math.min(255, 128 + v))) end
        end
        return true
    end
    return false
end

-- ---- 子类元表工厂 ----------------------------------------------------------
-- subMethods：子类方法表（缺则回落 Object3D.methods）。
-- extraGet(self,k)->v|nil / extraSet(self,k,v)->handled：子类额外属性钩子（优先于基类）。
function Object3D.makeMeta(subMethods, extraGet, extraSet)
    subMethods = subMethods or {}
    return {
        __index = function(self, k)
            if extraGet then
                local v = extraGet(self, k)
                if v ~= nil then return v end
            end
            local v = Object3D.getProp(self, k)
            if v ~= nil then return v end
            local m = subMethods[k]
            if m ~= nil then return m end
            return methods[k]
        end,
        __newindex = function(self, k, v)
            if extraSet and extraSet(self, k, v) then return end
            if Object3D.setProp(self, k, v) then return end
            rawset(self, k, v)
        end,
    }
end

local baseMeta = Object3D.makeMeta(methods, nil, nil)

-- 构造：可传入已有 Node；否则创建 detached Node()（对应 three.js 未入场景的对象）
function Object3D.new(node)
    local self = setmetatable({}, baseMeta)
    Object3D.setup(self, node)
    return self
end

-- ---- 方法 -------------------------------------------------------------------
function methods:getNode() return rawget(self, "_node") end

-- add(child1, child2, ...)：多参，维护 Node 树 + children 数组 + parent。
function methods:add(...)
    local n = rawget(self, "_node")
    local kids = rawget(self, "_children")
    for i = 1, select("#", ...) do
        local child = select(i, ...)
        if child then
            n:AddChild(child:getNode())
            kids[#kids + 1] = child
            rawset(child, "_parent", self)
        end
    end
    return self
end

function methods:remove(...)
    local n = rawget(self, "_node")
    local kids = rawget(self, "_children")
    for i = 1, select("#", ...) do
        local child = select(i, ...)
        if child then
            n:RemoveChild(child:getNode())
            for idx = #kids, 1, -1 do
                if kids[idx] == child then table.remove(kids, idx) break end
            end
            if rawget(child, "_parent") == self then rawset(child, "_parent", nil) end
        end
    end
    return self
end

-- three.js traverse：先 self 再递归子树（深度优先）。
function methods:traverse(cb)
    cb(self)
    local kids = rawget(self, "_children")
    for i = 1, #kids do kids[i]:traverse(cb) end
    return self
end

-- 仅可见子树（对标 three.js：visible===false 则跳过自身+子树；子节点无条件递归，各自自查）
function methods:traverseVisible(cb)
    if rawget(self, "_node").enabled == false then return self end
    cb(self)
    local kids = rawget(self, "_children")
    for i = 1, #kids do kids[i]:traverseVisible(cb) end -- 每个子节点在自己的调用里检查可见性
    return self
end

function methods:getObjectByName(name)
    local found
    self:traverse(function(o)
        if not found and o.name == name then found = o end
    end)
    return found
end

-- three.js lookAt：不走 Node:LookAt（那套依赖引擎 FORWARD/最短弧，不控 roll）。
-- 按 three.js Matrix4.lookAt 原样复刻：叉乘建正交基 → 手算四元数。
-- 相机/光（_lookInverted）：z = eye-target（-Z 对准目标）；普通物体：z = target-eye。
local function normalize3(x, y, z)
    local l = x * x + y * y + z * z
    if l > 0 then l = 1.0 / math.sqrt(l); return x * l, y * l, z * l end
    return x, y, z
end
local function cross3(ax, ay, az, bx, by, bz)
    return ay * bz - az * by, az * bx - ax * bz, ax * by - ay * bx
end

function methods:lookAt(x, y, z)
    -- 支持传入 Vector3 / 含 x,y,z 的表
    if type(x) == "table" then x, y, z = x.x, x.y, x.z end
    local n = rawget(self, "_node")
    local wp = n.worldPosition
    local ex, ey, ez = wp.x, wp.y, wp.z
    local zx, zy, zz
    if rawget(self, "_lookInverted") then
        zx, zy, zz = ex - x, ey - y, ez - z
    else
        zx, zy, zz = x - ex, y - ey, z - ez
    end
    zx, zy, zz = normalize3(zx, zy, zz)
    -- up 向量取 self.up（对标 three.js lookAt 读 this.up），默认 (0,1,0)
    local up = rawget(self, "_up")
    local ux, uy, uz = up and up.x or 0, up and up.y or 1, up and up.z or 0
    local xx, xy, xz = cross3(ux, uy, uz, zx, zy, zz)
    if (xx * xx + xy * xy + xz * xz) < 1e-12 then
        zx = zx + 1e-4
        zx, zy, zz = normalize3(zx, zy, zz)
        xx, xy, xz = cross3(ux, uy, uz, zx, zy, zz)
    end
    xx, xy, xz = normalize3(xx, xy, xz)
    local yx, yy, yz = cross3(zx, zy, zz, xx, xy, xz)
    local m11, m12, m13 = xx, yx, zx
    local m21, m22, m23 = xy, yy, zy
    local m31, m32, m33 = xz, yz, zz
    local tr = m11 + m22 + m33
    local qw, qx, qy, qz
    if tr > 0 then
        local s = 0.5 / math.sqrt(tr + 1.0)
        qw = 0.25 / s; qx = (m32 - m23) * s; qy = (m13 - m31) * s; qz = (m21 - m12) * s
    elseif m11 > m22 and m11 > m33 then
        local s = 2.0 * math.sqrt(1.0 + m11 - m22 - m33)
        qw = (m32 - m23) / s; qx = 0.25 * s; qy = (m12 + m21) / s; qz = (m13 + m31) / s
    elseif m22 > m33 then
        local s = 2.0 * math.sqrt(1.0 + m22 - m11 - m33)
        qw = (m13 - m31) / s; qx = (m12 + m21) / s; qy = 0.25 * s; qz = (m23 + m32) / s
    else
        local s = 2.0 * math.sqrt(1.0 + m33 - m11 - m22)
        qw = (m21 - m12) / s; qx = (m13 + m31) / s; qy = (m23 + m32) / s; qz = 0.25 * s
    end
    n.rotation = Quaternion(qw, qx, qy, qz)
    return self
end

-- ---- 世界变换 getter（three.js：可传 target 填入，否则新建）-------------------
function methods:getWorldPosition(target)
    local p = rawget(self, "_node").worldPosition
    return (target or Vector3.new()):set(p.x, p.y, p.z)
end

function methods:getWorldScale(target)
    local s = rawget(self, "_node").worldScale
    return (target or Vector3.new()):set(s.x, s.y, s.z)
end

function methods:getWorldQuaternion(target)
    local q = rawget(self, "_node").worldRotation
    return (target or QuaternionLib.new()):set(q.x, q.y, q.z, q.w)
end

-- three.js：物体局部 +Z 轴在世界空间的方向
function methods:getWorldDirection(target)
    local q = rawget(self, "_node").worldRotation
    return (target or Vector3.new()):set(0, 0, 1):applyQuaternion({ x = q.x, y = q.y, z = q.z, w = q.w })
end

-- ---- 坐标系转换（就地写入并返回传入的向量）---------------------------------
function methods:localToWorld(v)
    local r = rawget(self, "_node"):LocalToWorld(NativeVector3(v.x, v.y, v.z))
    return v:set(r.x, r.y, r.z)
end

function methods:worldToLocal(v)
    local r = rawget(self, "_node"):WorldToLocal(NativeVector3(v.x, v.y, v.z))
    return v:set(r.x, r.y, r.z)
end

-- ---- 平移（沿本地轴；axis 须单位向量，distance 世界单位）---------------------
function methods:translateOnAxis(axis, distance)
    rawget(self, "_node"):Translate(NativeVector3(axis.x * distance, axis.y * distance, axis.z * distance), TS_LOCAL)
    return self
end

function methods:translateX(d) return self:translateOnAxis({ x = 1, y = 0, z = 0 }, d) end
function methods:translateY(d) return self:translateOnAxis({ x = 0, y = 1, z = 0 }, d) end
function methods:translateZ(d) return self:translateOnAxis({ x = 0, y = 0, z = 1 }, d) end

-- ---- 旋转（angle 弧度）-----------------------------------------------------
function methods:rotateOnAxis(axis, angle) -- 绕本地轴
    rawget(self, "_quaternion"):multiply(QuaternionLib.new():setFromAxisAngle(axis, angle))
    return self
end

function methods:rotateOnWorldAxis(axis, angle) -- 绕世界轴
    rawget(self, "_quaternion"):premultiply(QuaternionLib.new():setFromAxisAngle(axis, angle))
    return self
end

function methods:rotateX(a) return self:rotateOnAxis({ x = 1, y = 0, z = 0 }, a) end
function methods:rotateY(a) return self:rotateOnAxis({ x = 0, y = 1, z = 0 }, a) end
function methods:rotateZ(a) return self:rotateOnAxis({ x = 0, y = 0, z = 1 }, a) end

-- ---- 直接设置/施加旋转 ------------------------------------------------------
function methods:setRotationFromAxisAngle(axis, angle) rawget(self, "_quaternion"):setFromAxisAngle(axis, angle); return self end
function methods:setRotationFromEuler(e) rawget(self, "_quaternion"):setFromEuler(e); return self end
function methods:setRotationFromQuaternion(q) rawget(self, "_quaternion"):copy(q); return self end
function methods:applyQuaternion(q) rawget(self, "_quaternion"):premultiply(q); return self end -- three.js：左乘

-- ---- 场景图增补 ------------------------------------------------------------
function methods:removeFromParent()
    local parent = rawget(self, "_parent")
    if parent then parent:remove(self) end
    return self
end

function methods:clear()
    local kids = rawget(self, "_children")
    for i = #kids, 1, -1 do self:remove(kids[i]) end
    return self
end

function methods:getObjectById(id)
    local found
    self:traverse(function(o) if not found and o:getNode():GetID() == id then found = o end end)
    return found
end

function methods:getObjectByProperty(name, value)
    local found
    self:traverse(function(o) if not found and o[name] == value then found = o end end)
    return found
end

function methods:traverseAncestors(cb)
    local parent = rawget(self, "_parent")
    if parent then cb(parent); parent:traverseAncestors(cb) end
    return self
end

-- ---- P2b：矩阵施加 / 克隆 / attach / 查询 ----------------------------------
-- three.js applyMatrix4：左乘当前局部矩阵后分解写回（保留模式：compose→premultiply→decompose）
function methods:applyMatrix4(m)
    local cur = Matrix4.new():compose(rawget(self, "_position"), rawget(self, "_quaternion"), rawget(self, "_scale"))
    cur:premultiply(m)
    local p, q, s = Vector3.new(), QuaternionLib.new(), Vector3.new()
    cur:decompose(p, q, s)
    rawget(self, "_position"):set(p.x, p.y, p.z)
    rawget(self, "_quaternion"):set(q.x, q.y, q.z, q.w)
    rawget(self, "_scale"):set(s.x, s.y, s.z)
    return self
end

function methods:setRotationFromMatrix(m)
    rawget(self, "_quaternion"):setFromRotationMatrix(m); return self
end

-- 递归收集 self[name]==value 的对象
function methods:getObjectsByProperty(name, value, result)
    result = result or {}
    self:traverse(function(o) if o[name] == value then result[#result + 1] = o end end)
    return result
end

-- 拷贝变换/名称/可见/up/userData（+ 递归 clone children 加入）。geometry/material 由子类处理。
function methods:copy(source, recursive)
    if recursive == nil then recursive = true end
    rawget(self, "_position"):copy(source.position)
    rawget(self, "_quaternion"):copy(source.quaternion)
    rawget(self, "_scale"):copy(source.scale)
    rawget(self, "_up"):copy(source.up)
    self.name = source.name
    self.visible = source.visible
    rawset(self, "_renderOrder", source.renderOrder)
    local ud = {}
    for k, v in pairs(source.userData or {}) do ud[k] = v end
    rawset(self, "_userData", ud)
    if recursive then
        local kids = rawget(source, "_children")
        for i = 1, #kids do self:add(kids[i]:clone(true)) end
    end
    return self
end

function methods:clone(recursive)
    return Object3D.new():copy(self, recursive)
end

-- three.js attach：保持世界变换地把 object 接到 self 下
function methods:attach(object)
    local objWorld = Matrix4.new():compose(object:getWorldPosition(), object:getWorldQuaternion(), object:getWorldScale())
    local selfWorldInv = Matrix4.new():compose(self:getWorldPosition(), self:getWorldQuaternion(), self:getWorldScale()):invert()
    local parent = rawget(object, "_parent")
    if parent then parent:remove(object) end
    self:add(object)
    local localM = Matrix4.new():multiplyMatrices(selfWorldInv, objWorld)
    local p, q, s = Vector3.new(), QuaternionLib.new(), Vector3.new()
    localM:decompose(p, q, s)
    object.position:set(p.x, p.y, p.z)
    object.quaternion:set(q.x, q.y, q.z, q.w)
    object.scale:set(s.x, s.y, s.z)
    return self
end

-- 保留模式下变换实时生效；这些方法为兼容 three.js 调用，空操作返回 self。
function methods:updateMatrix() return self end
function methods:updateMatrixWorld() return self end
function methods:updateWorldMatrix() return self end

return Object3D
