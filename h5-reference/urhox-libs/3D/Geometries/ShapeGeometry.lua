-- ============================================================================
-- urhox-libs/3D · ShapeGeometry
-- three.js ShapeGeometry(shapes, curveSegments=12)：把 2D Shape（含 holes）三角化成平面
-- 几何（XY 平面，z=0，法线 +Z，UV = 顶点 (x,y)）。shapes 支持 Shape 或 Shape 数组。
-- 三角化逻辑与 ExtrudeGeometry 同源（耳切 + 最近顶点桥接合并 holes）。
-- ============================================================================

local BufferGeometry = require("urhox-libs/3D/Core/BufferGeometry")
local BufferAttribute = require("urhox-libs/3D/Core/BufferAttribute")

local function signedArea(c)
    local a, n = 0, #c
    for i = 1, n do
        local j = (i % n) + 1
        a = a + (c[i].x * c[j].y - c[j].x * c[i].y)
    end
    return a * 0.5
end

local function pointInTri(px, py, ax, ay, bx, by, cx, cy)
    local v0x, v0y = cx - ax, cy - ay
    local v1x, v1y = bx - ax, by - ay
    local v2x, v2y = px - ax, py - ay
    local d00 = v0x * v0x + v0y * v0y
    local d01 = v0x * v1x + v0y * v1y
    local d02 = v0x * v2x + v0y * v2y
    local d11 = v1x * v1x + v1y * v1y
    local d12 = v1x * v2x + v1y * v2y
    local denom = d00 * d11 - d01 * d01
    if math.abs(denom) < 1e-12 then return false end
    local inv = 1 / denom
    local u = (d11 * d02 - d01 * d12) * inv
    local v = (d00 * d12 - d01 * d02) * inv
    return u >= -1e-9 and v >= -1e-9 and (u + v) <= 1 + 1e-9
end

-- 耳切（contour CCW），返回三角 {i1,i2,i3}（1-based）
local function triangulate(contour)
    local n = #contour
    local V = {}; for i = 1, n do V[i] = i end
    local result = {}
    local nv = n
    local count = 2 * nv
    local v = nv
    while nv > 2 do
        count = count - 1; if count < 0 then break end
        local u = v; if nv < u then u = 1 end
        v = u + 1; if nv < v then v = 1 end
        local w = v + 1; if nv < w then w = 1 end
        local ia, ib, ic = V[u], V[v], V[w]
        local ax, ay = contour[ia].x, contour[ia].y
        local bx, by = contour[ib].x, contour[ib].y
        local cx, cy = contour[ic].x, contour[ic].y
        local cross = (bx - ax) * (cy - ay) - (by - ay) * (cx - ax)
        local ear = cross > 1e-12
        if ear then
            for p = 1, nv do
                if p ~= u and p ~= v and p ~= w then
                    local pp = contour[V[p]]
                    if pointInTri(pp.x, pp.y, ax, ay, bx, by, cx, cy) then ear = false; break end
                end
            end
        end
        if ear then
            result[#result + 1] = { ia, ib, ic }
            for s = v, nv - 1 do V[s] = V[s + 1] end
            nv = nv - 1; count = 2 * nv
        end
    end
    return result
end

-- 把 holes 用"最近顶点桥接"并入外轮廓
local function mergeHoles(outer, holes)
    if not holes or #holes == 0 then return outer end
    local merged = {}
    for i = 1, #outer do merged[i] = { x = outer[i].x, y = outer[i].y } end
    for _, hole in ipairs(holes) do
        local h = {}
        if signedArea(hole) > 0 then
            for i = #hole, 1, -1 do h[#h + 1] = { x = hole[i].x, y = hole[i].y } end
        else
            for i = 1, #hole do h[#h + 1] = { x = hole[i].x, y = hole[i].y } end
        end
        local best, boi, bhi = math.huge, 1, 1
        for oi = 1, #merged do
            for hi = 1, #h do
                local dx, dy = merged[oi].x - h[hi].x, merged[oi].y - h[hi].y
                local d = dx * dx + dy * dy
                if d < best then best, boi, bhi = d, oi, hi end
            end
        end
        local out = {}
        for i = 1, boi do out[#out + 1] = merged[i] end
        for k = 0, #h do out[#out + 1] = h[((bhi - 1 + k) % #h) + 1] end
        for i = boi, #merged do out[#out + 1] = merged[i] end
        merged = out
    end
    return merged
end

local function dedupe(c)
    if #c > 1 then
        local a, b = c[1], c[#c]
        if math.abs(a.x - b.x) < 1e-9 and math.abs(a.y - b.y) < 1e-9 then table.remove(c, #c) end
    end
    return c
end

-- 取一个 shape 的外轮廓 + holes（点为 {x,y}）
local function shapePoints(shape, curveSegments)
    local outer = shape:getPoints(curveSegments)
    dedupe(outer)
    if signedArea(outer) < 0 then -- 保证 CCW
        local r = {}; for i = #outer, 1, -1 do r[#r + 1] = outer[i] end; outer = r
    end
    local holes = {}
    if shape.holes then
        for _, hp in ipairs(shape.holes) do
            local h = hp.getPoints and hp:getPoints(curveSegments) or hp
            dedupe(h); holes[#holes + 1] = h
        end
    end
    return outer, holes
end

local Shape = {}

function Shape.new(shapes, curveSegments)
    curveSegments = math.max(1, math.floor(curveSegments or 12))
    -- shapes：Shape 或 Shape 数组（检测 [1] 是否为 shape-like）
    local list
    if type(shapes) == "table" and shapes[1] and (shapes[1].getPoints or shapes[1].moveTo) then
        list = shapes
    else
        list = { shapes }
    end

    local positions, uvs, normals = {}, {}, {}
    local function emit(x, y)
        positions[#positions + 1] = x; positions[#positions + 1] = y; positions[#positions + 1] = 0
        uvs[#uvs + 1] = x; uvs[#uvs + 1] = y -- three.js ShapeGeometry：UV = 顶点 (x,y)
        normals[#normals + 1] = 0; normals[#normals + 1] = 0; normals[#normals + 1] = 1
    end

    for _, shape in ipairs(list) do
        local outer, holes = shapePoints(shape, curveSegments)
        local merged = mergeHoles(outer, holes)
        local tris = triangulate(merged)
        for _, t in ipairs(tris) do
            local a, b, c = merged[t[1]], merged[t[2]], merged[t[3]]
            emit(a.x, a.y); emit(b.x, b.y); emit(c.x, c.y) -- CCW → 法线 +Z
        end
    end

    local geo = BufferGeometry.new()
    geo:setAttribute("position", BufferAttribute.new(positions, 3))
    geo:setAttribute("uv", BufferAttribute.new(uvs, 2))
    geo:setAttribute("normal", BufferAttribute.new(normals, 3))
    geo.parameters = { shapes = shapes, curveSegments = curveSegments }
    return geo
end

return Shape
