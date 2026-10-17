-- ============================================================================
-- urhox-libs/3D · _transformable（内部）
-- 给 build-once 几何生成器（Box/Sphere/...，直接 emit 到 CustomGeometry，无保留数组）
-- 加 three.js 的 geometry.translate/rotateX/rotateY/rotateZ/scale —— 不改任何生成器文件：
-- 包装构造器，记录变换 ops；build 时用代理 node/geom 拦截 DefineVertex/DefineNormal 套用变换。
-- ops 按调用顺序逐顶点串行应用（= three.js 顺序，每次变换作用于当前几何）。
-- 注：构造期变换（加入 Mesh 前调用）；build 后再 translate 不重 emit（build-once 限制，
--     需要运行时改顶点请用 BufferGeometry）。
-- ============================================================================

local NativeVector3 = Vector3

local T = {}

local function applyPos(ops, x, y, z)
    for i = 1, #ops do x, y, z = ops[i].pos(x, y, z) end
    return x, y, z
end
local function applyNrm(ops, x, y, z)
    for i = 1, #ops do local f = ops[i].nrm; if f then x, y, z = f(x, y, z) end end
    return x, y, z
end

-- geom 代理：拦截 DefineVertex/DefineNormal 套变换，其余转发真组件
local function makeGeomProxy(real, ops)
    return setmetatable({}, {
        __index = function(_, key)
            if key == "DefineVertex" then
                return function(_, v)
                    local x, y, z = applyPos(ops, v.x, v.y, v.z)
                    real:DefineVertex(NativeVector3(x, y, z))
                end
            elseif key == "DefineNormal" then
                return function(_, n)
                    local x, y, z = applyNrm(ops, n.x, n.y, n.z)
                    local l = math.sqrt(x * x + y * y + z * z)
                    if l > 0 then x, y, z = x / l, y / l, z / l end
                    real:DefineNormal(NativeVector3(x, y, z))
                end
            end
            local f = real[key]
            if type(f) == "function" then return function(_, ...) return f(real, ...) end end
            return f
        end,
    })
end

-- node 代理：CreateComponent("CustomGeometry") → geom 代理；其余转发
local function makeNodeProxy(real, ops)
    return setmetatable({}, {
        __index = function(_, key)
            if key == "CreateComponent" then
                return function(_, t)
                    local c = real:CreateComponent(t)
                    if t == "CustomGeometry" then return makeGeomProxy(c, ops) end
                    return c
                end
            end
            local f = real[key]
            if type(f) == "function" then return function(_, ...) return f(real, ...) end end
            return f
        end,
    })
end

-- 包装一个 build-once 几何构造器，返回带 translate/rotate/scale 的版本
function T.wrap(ctor)
    return function(...)
        local geo = ctor(...)
        if type(geo) ~= "table" or not geo.build or geo.translate then
            return geo -- 非 build-once（如 BufferGeometry 已自带变换）→ 原样
        end
        local ops = {}
        local origBuild = geo.build
        geo.build = function(self, node, mat)
            if #ops == 0 then return origBuild(self, node, mat) end
            return origBuild(self, makeNodeProxy(node, ops), mat)
        end
        geo.translate = function(self, x, y, z)
            ops[#ops + 1] = { pos = function(px, py, pz) return px + x, py + y, pz + z end }
            return self
        end
        geo.scale = function(self, x, y, z)
            ops[#ops + 1] = {
                pos = function(px, py, pz) return px * x, py * y, pz * z end,
                nrm = function(nx, ny, nz) return nx / x, ny / y, nz / z end,
            }
            return self
        end
        local function rot(c, s, axis)
            if axis == "x" then return function(x, y, z) return x, y * c - z * s, y * s + z * c end end
            if axis == "y" then return function(x, y, z) return x * c + z * s, y, -x * s + z * c end end
            return function(x, y, z) return x * c - y * s, x * s + y * c, z end
        end
        geo.rotateX = function(self, a) local f = rot(math.cos(a), math.sin(a), "x"); ops[#ops + 1] = { pos = f, nrm = f }; return self end
        geo.rotateY = function(self, a) local f = rot(math.cos(a), math.sin(a), "y"); ops[#ops + 1] = { pos = f, nrm = f }; return self end
        geo.rotateZ = function(self, a) local f = rot(math.cos(a), math.sin(a), "z"); ops[#ops + 1] = { pos = f, nrm = f }; return self end
        return geo
    end
end

return T
