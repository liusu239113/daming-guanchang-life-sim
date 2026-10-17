-- ============================================================================
-- urhox-libs/3D · Line / LineSegments / LineLoop
-- three.js Line(geometry, material)。Object3D + CustomGeometry(LINE_LIST) + 线材质。
--
-- 引擎只有 LINE_LIST（无 LINE_STRIP），故连接方式在此层决定：
--   Line      相邻点成对   (v0,v1)(v1,v2)…        顶点数 2*(n-1)
--   LineSegments 不相连对  (v0,v1)(v2,v3)…        顶点数 n（直接顺序发）
--   LineLoop  Line + 闭合  …(v_{n-1},v0)          顶点数 2*n
-- geometry：含 attributes.position 的 BufferGeometry；vertexColors 时读 attributes.color。
-- ============================================================================

local Object3D = require("urhox-libs/3D/Core/Object3D")

local NativeVector3 = Vector3 -- 引擎原生构造器
local NativeColor = Color

local Line = {}
local lineMethods = {}

local function nativeOf(m) return m and m.getNative and m:getNative() or nil end

-- 把 geometry 的点按 mode 发到 CustomGeometry（LINE_LIST）
local function emit(self)
    local geom = rawget(self, "_component")
    if not geom then return end
    local g = rawget(self, "_geometry")
    local attrs = g and g.attributes
    local pos = attrs and attrs.position
    if not pos then return end
    local mat = rawget(self, "_material")
    local useVCol = mat and mat.vertexColors and attrs.color
    local col = useVCol and attrs.color or nil
    local n = pos.count
    local mode = rawget(self, "_mode")

    geom:BeginGeometry(0, LINE_LIST)
    local function v(i)
        geom:DefineVertex(NativeVector3(pos:getX(i), pos:getY(i), pos:getZ(i)))
        if col then geom:DefineColor(NativeColor(col:getX(i), col:getY(i), col:getZ(i), 1)) end
    end
    if mode == "segments" then
        for i = 0, n - 1 do v(i) end                 -- 顺序成对 = LINE_LIST 段
    else
        for i = 0, n - 2 do v(i); v(i + 1) end        -- 折线：相邻成对
        if mode == "loop" and n > 2 then v(n - 1); v(0) end -- 闭合
    end
    geom:Commit()
    local native = nativeOf(mat)
    if native then geom:SetMaterial(native) end
end

local function mget(self, k)
    if k == "isLine" then return true end
    if k == "isLineSegments" then return rawget(self, "_mode") == "segments" end
    if k == "isLineLoop" then return rawget(self, "_mode") == "loop" end
    if k == "type" then return rawget(self, "_type") end
    if k == "geometry" then return rawget(self, "_geometry") end
    if k == "material" then return rawget(self, "_material") end
    return nil
end

local function mset(self, k, v)
    if k == "material" then
        rawset(self, "_material", v)
        local geom = rawget(self, "_component")
        local native = nativeOf(v)
        if geom and native then geom:SetMaterial(native) end
        return true
    end
    if k == "geometry" then rawset(self, "_geometry", v); emit(self); return true end
    return false
end

local mt = Object3D.makeMeta(lineMethods, mget, mset)

local function construct(geometry, material, mode, typeName)
    local self = setmetatable({}, mt)
    Object3D.setup(self)
    rawset(self, "_geometry", geometry)
    rawset(self, "_material", material)
    rawset(self, "_mode", mode)
    rawset(self, "_type", typeName)
    rawset(self, "_component", self:getNode():CreateComponent("CustomGeometry"))
    emit(self)
    return self
end

function Line.new(geometry, material) return construct(geometry, material, "line", "Line") end
function Line.newSegments(geometry, material) return construct(geometry, material, "segments", "LineSegments") end
function Line.newLoop(geometry, material) return construct(geometry, material, "loop", "LineLoop") end

-- 暴露给 init：可手动重发（geometry 顶点变更后）
function lineMethods:updateGeometry() emit(self); return self end

return Line
