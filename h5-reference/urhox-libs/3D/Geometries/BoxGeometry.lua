-- ============================================================================
-- urhox-libs/3D · BoxGeometry
-- three.js BoxGeometry(width, height, depth, widthSegments, heightSegments, depthSegments)。
-- CustomGeometry 后端（§4.2 后端 A）。6 个 geometry group（每面一个，索引顺序对齐 three.js
-- 材质组：0=+X 1=-X 2=+Y 3=-Y 4=+Z 5=-Z），支持多材质数组（mesh.material = [m0..m5]）。
-- 每面按 segments 双线性细分成 su×sv 网格，UV 0..1。
-- ============================================================================

local Box = {}

-- 6 面：法线 + 4 角(CCW，单位 ±0.5)。角 1..4 对应 UV (0,0)(1,0)(1,1)(0,1)
local FACES = {
    { n = { 1, 0, 0 },  c = { { 0.5, -0.5, 0.5 }, { 0.5, -0.5, -0.5 }, { 0.5, 0.5, -0.5 }, { 0.5, 0.5, 0.5 } } },
    { n = { -1, 0, 0 }, c = { { -0.5, -0.5, -0.5 }, { -0.5, -0.5, 0.5 }, { -0.5, 0.5, 0.5 }, { -0.5, 0.5, -0.5 } } },
    { n = { 0, 1, 0 },  c = { { -0.5, 0.5, 0.5 }, { 0.5, 0.5, 0.5 }, { 0.5, 0.5, -0.5 }, { -0.5, 0.5, -0.5 } } },
    { n = { 0, -1, 0 }, c = { { -0.5, -0.5, -0.5 }, { 0.5, -0.5, -0.5 }, { 0.5, -0.5, 0.5 }, { -0.5, -0.5, 0.5 } } },
    { n = { 0, 0, 1 },  c = { { -0.5, -0.5, 0.5 }, { 0.5, -0.5, 0.5 }, { 0.5, 0.5, 0.5 }, { -0.5, 0.5, 0.5 } } },
    { n = { 0, 0, -1 }, c = { { 0.5, -0.5, -0.5 }, { -0.5, -0.5, -0.5 }, { -0.5, 0.5, -0.5 }, { 0.5, 0.5, -0.5 } } },
}

-- 每面 (su, sv) 段数（对齐 three.js：±X 用 depth×height、±Y 用 width×depth、±Z 用 width×height）
local function faceSegs(fi, ws, hs, ds)
    if fi == 1 or fi == 2 then return ds, hs end
    if fi == 3 or fi == 4 then return ws, ds end
    return ws, hs
end

local function build(self, node, nativeMaterial)
    local hw, hh, hd = self.w, self.h, self.d -- 角是 ±0.5，乘尺寸即可（0.5*2*size = size）
    local ws, hs, ds = self.widthSegments, self.heightSegments, self.depthSegments
    local geom = node:CreateComponent("CustomGeometry")
    geom:SetNumGeometries(6)
    for fi, f in ipairs(FACES) do
        geom:BeginGeometry(fi - 1, TRIANGLE_LIST) -- group 0..5（对齐 three.js 材质组）
        local n = Vector3(f.n[1], f.n[2], f.n[3])
        local c = f.c
        -- 4 角实际坐标（c 为 ±0.5 单位 → ×size）
        local function cw(i) return c[i][1] * hw, c[i][2] * hh, c[i][3] * hd end
        local x1, y1, z1 = cw(1); local x2, y2, z2 = cw(2)
        local x3, y3, z3 = cw(3); local x4, y4, z4 = cw(4)
        -- 双线性：c1(u0,v0) c2(u1,v0) c3(u1,v1) c4(u0,v1)
        local function P(u, v)
            local a, b, cc, d = (1 - u) * (1 - v), u * (1 - v), u * v, (1 - u) * v
            return x1 * a + x2 * b + x3 * cc + x4 * d,
                y1 * a + y2 * b + y3 * cc + y4 * d,
                z1 * a + z2 * b + z3 * cc + z4 * d
        end
        local su, sv = faceSegs(fi, ws, hs, ds)
        local function emitV(u, v)
            local px, py, pz = P(u, v)
            geom:DefineVertex(Vector3(px, py, pz)); geom:DefineNormal(n); geom:DefineTexCoord(Vector2(u, v))
        end
        for j = 0, sv - 1 do
            for i = 0, su - 1 do
                local u0, u1, v0, v1 = i / su, (i + 1) / su, j / sv, (j + 1) / sv
                emitV(u0, v0); emitV(u1, v0); emitV(u1, v1) -- tri 1（同原 ORDER 1,2,3）
                emitV(u0, v0); emitV(u1, v1); emitV(u0, v1) -- tri 2（同原 ORDER 1,3,4）
            end
        end
    end
    geom:Commit()
    if nativeMaterial then geom:SetMaterial(nativeMaterial) end
    return geom
end

function Box.new(width, height, depth, widthSegments, heightSegments, depthSegments)
    local w, h, d = width or 1, height or 1, depth or 1
    local ws = math.max(1, math.floor(widthSegments or 1))
    local hs = math.max(1, math.floor(heightSegments or 1))
    local ds = math.max(1, math.floor(depthSegments or 1))
    return {
        _kind = "geometry", w = w, h = h, d = d,
        widthSegments = ws, heightSegments = hs, depthSegments = ds,
        parameters = { width = w, height = h, depth = d,
            widthSegments = ws, heightSegments = hs, depthSegments = ds },
        build = build,
    }
end

return Box
