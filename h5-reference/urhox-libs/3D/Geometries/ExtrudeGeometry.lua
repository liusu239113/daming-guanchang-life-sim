-- ============================================================================
-- urhox-libs/3D · ExtrudeGeometry
-- three.js ExtrudeGeometry(shape, options)：2D Shape 沿 +Z 挤出 depth。
-- 支持：holes（shape.holes，桥接合并后耳切做盖）、bevel（bevelEnabled/Thickness/Size/Segments，
--   四分弧内缩斜角圈）、steps（暂按 1）。options.depth/curveSegments/bevelEnabled/bevelThickness/
--   bevelSize/bevelSegments/bevelOffset。computeVertexNormals 出法线（平直，适合挤出/斜角）。
-- ============================================================================

local BufferGeometry = require("urhox-libs/3D/Core/BufferGeometry")
local BufferAttribute = require("urhox-libs/3D/Core/BufferAttribute")

local Extrude = {}

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

-- 把 holes 用"最近顶点桥接"并入外轮廓，得到单一可三角化多边形
local function mergeHoles(outer, holes)
    if not holes or #holes == 0 then return outer end
    local merged = {}
    for i = 1, #outer do merged[i] = { x = outer[i].x, y = outer[i].y } end
    for _, hole in ipairs(holes) do
        -- hole 取 CW（与 CCW 外轮廓相反），使桥接成有效简单多边形
        local h = {}
        if signedArea(hole) > 0 then
            for i = #hole, 1, -1 do h[#h + 1] = { x = hole[i].x, y = hole[i].y } end
        else
            for i = 1, #hole do h[#h + 1] = { x = hole[i].x, y = hole[i].y } end
        end
        -- 找 merged[oi] 与 h[hi] 最近的一对
        local best, boi, bhi = math.huge, 1, 1
        for oi = 1, #merged do
            for hi = 1, #h do
                local dx, dy = merged[oi].x - h[hi].x, merged[oi].y - h[hi].y
                local d = dx * dx + dy * dy
                if d < best then best, boi, bhi = d, oi, hi end
            end
        end
        -- 拼接：merged[1..boi] + h[bhi..end,1..bhi] + merged[boi..end]（桥两端各复制一个顶点）
        local out = {}
        for i = 1, boi do out[#out + 1] = merged[i] end
        for k = 0, #h do out[#out + 1] = h[((bhi - 1 + k) % #h) + 1] end
        for i = boi, #merged do out[#out + 1] = merged[i] end
        merged = out
    end
    return merged
end

-- 轮廓逐顶点的 2D 内向法线（相邻边法线平均；CCW 取左侧为内）
local function inwardNormals(contour)
    local n = #contour
    local nrm = {}
    for i = 1, n do
        local p0 = contour[((i - 2) % n) + 1]
        local p1 = contour[i]
        local p2 = contour[(i % n) + 1]
        -- 边法线（CCW 内向 = 边方向左转 90°：(-dy, dx)）
        local e1x, e1y = p1.x - p0.x, p1.y - p0.y
        local e2x, e2y = p2.x - p1.x, p2.y - p1.y
        local n1x, n1y = -e1y, e1x
        local n2x, n2y = -e2y, e2x
        local nx, ny = n1x + n2x, n1y + n2y
        local l = math.sqrt(nx * nx + ny * ny)
        if l > 1e-9 then nx, ny = nx / l, ny / l else nx, ny = 0, 0 end
        nrm[i] = { x = nx, y = ny }
    end
    return nrm
end

function Extrude.new(shape, options)
    options = options or {}
    -- shapes 数组（Shape[]）：逐个挤出后合并 position/uv（对齐 three.js ExtrudeGeometry(shapes,...)）
    if type(shape) == "table" and shape[1] and (shape[1].getPoints or shape[1].moveTo) then
        local positions, uvs = {}, {}
        for _, s in ipairs(shape) do
            local g = Extrude.new(s, options)
            local p, u = g:getAttribute("position"), g:getAttribute("uv")
            for i = 0, p.count - 1 do
                positions[#positions + 1] = p:getX(i); positions[#positions + 1] = p:getY(i); positions[#positions + 1] = p:getZ(i)
                uvs[#uvs + 1] = u:getX(i); uvs[#uvs + 1] = u:getY(i)
            end
        end
        local geo = BufferGeometry.new()
        geo:setAttribute("position", BufferAttribute.new(positions, 3))
        geo:setAttribute("uv", BufferAttribute.new(uvs, 2))
        geo:computeVertexNormals()
        geo.parameters = { shapes = shape, options = options }
        return geo
    end
    local depth = options.depth or 1
    local curveSegments = options.curveSegments or 12
    local bevelEnabled = options.bevelEnabled ~= false -- three.js 默认 true
    local bevelThickness = options.bevelThickness or 0.2
    local bevelSize = options.bevelSize or (bevelThickness - 0.1)
    local bevelSegments = math.max(1, math.floor(options.bevelSegments or 3))
    if not bevelEnabled then bevelThickness = 0; bevelSize = 0; bevelSegments = 0 end

    -- 外轮廓（去重复闭合点）
    local outer = shape:getPoints(curveSegments)
    local function dedupe(c)
        if #c > 1 then
            local a, b = c[1], c[#c]
            if math.abs(a.x - b.x) < 1e-9 and math.abs(a.y - b.y) < 1e-9 then table.remove(c, #c) end
        end
        return c
    end
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

    -- 盖三角化（外轮廓 + holes 合并）
    local merged = mergeHoles(outer, holes)
    local capTris = triangulate(merged)

    local positions, uvs = {}, {}
    local function emit(x, y, z, u, vv)
        positions[#positions + 1] = x; positions[#positions + 1] = y; positions[#positions + 1] = z
        uvs[#uvs + 1] = u; uvs[#uvs + 1] = vv
    end
    local function emitTri(a, b, c) -- a/b/c = {x,y,z}
        emit(a.x, a.y, a.z, a.x, a.y); emit(b.x, b.y, b.z, b.x, b.y); emit(c.x, c.y, c.z, c.x, c.y)
    end

    -- 盖：前盖 z=-bevelThickness（法线 -Z，逆序）；后盖 z=depth+bevelThickness（法线 +Z）
    local zFront = -bevelThickness
    local zBack = depth + bevelThickness
    for _, t in ipairs(capTris) do
        local a, b, c = merged[t[1]], merged[t[2]], merged[t[3]]
        emitTri({ x = a.x, y = a.y, z = zFront }, { x = c.x, y = c.y, z = zFront }, { x = b.x, y = b.y, z = zFront })
        emitTri({ x = a.x, y = a.y, z = zBack }, { x = b.x, y = b.y, z = zBack }, { x = c.x, y = c.y, z = zBack })
    end

    -- 侧壁 + 斜角：对每条轮廓（外 + 每个 hole）按 z 层生成环并连成 quad
    -- 层定义（z, inset）：前斜角(0→bevelThickness)、直壁、后斜角。inset = bevelSize*(1-cos)
    local function buildContourSides(contour, reverseWinding)
        local nrm = inwardNormals(contour)
        local n = #contour
        -- 生成 z 层列表：{z, inset}
        local layers = {}
        for s = 0, bevelSegments do
            local t = (bevelSegments > 0) and (s / bevelSegments) or 0
            local ang = t * math.pi * 0.5
            layers[#layers + 1] = { z = -bevelThickness + bevelThickness * math.sin(ang), inset = bevelSize * (1 - math.cos(ang)) }
        end
        layers[#layers + 1] = { z = 0, inset = 0 }
        layers[#layers + 1] = { z = depth, inset = 0 }
        for s = bevelSegments, 0, -1 do
            local t = (bevelSegments > 0) and (s / bevelSegments) or 0
            local ang = t * math.pi * 0.5
            layers[#layers + 1] = { z = depth + bevelThickness - bevelThickness * math.sin(ang), inset = bevelSize * (1 - math.cos(ang)) }
        end
        -- 环顶点位置
        local function ringPos(li, i)
            local L = layers[li]; local p = contour[i]; local nn = nrm[i]
            return { x = p.x + nn.x * L.inset, y = p.y + nn.y * L.inset, z = L.z }
        end
        for li = 1, #layers - 1 do
            for i = 1, n do
                local j = (i % n) + 1
                local a = ringPos(li, i)
                local b = ringPos(li, j)
                local c = ringPos(li + 1, j)
                local d = ringPos(li + 1, i)
                if reverseWinding then
                    emitTri(a, c, b); emitTri(a, d, c)
                else
                    emitTri(a, b, c); emitTri(a, c, d)
                end
            end
        end
    end

    buildContourSides(outer, false)
    for _, h in ipairs(holes) do
        -- hole 内壁朝向相反（其内向法线指向 hole 内部 = 远离材料，故 inset 用反向 + 翻绕序）
        local hc = {}; for i = 1, #h do hc[i] = h[i] end
        if signedArea(hc) > 0 then -- hole 转 CW 让 inwardNormals 指向材料侧
            local r = {}; for i = #hc, 1, -1 do r[#r + 1] = hc[i] end; hc = r
        end
        buildContourSides(hc, true)
    end

    local geo = BufferGeometry.new()
    geo:setAttribute("position", BufferAttribute.new(positions, 3))
    geo:setAttribute("uv", BufferAttribute.new(uvs, 2))
    geo:computeVertexNormals()
    geo.parameters = { shapes = shape, options = options }
    return geo
end

return Extrude
