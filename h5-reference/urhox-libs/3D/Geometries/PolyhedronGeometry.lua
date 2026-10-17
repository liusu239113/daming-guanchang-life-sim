-- ============================================================================
-- urhox-libs/3D · PolyhedronGeometry（多面体基类）
-- three.js PolyhedronGeometry(vertices, indices, radius, detail)
-- 逐行移植：按 detail 细分每个三角面 → 投影到球面 → 法线=归一化位置 → 方位/俯仰 UV。
-- Tetrahedron/Octahedron/Icosahedron/Dodecahedron 复用此基类。CustomGeometry 后端。
-- ============================================================================

local Poly = {}
local sqrt, atan, asin, abs, pi, max = math.sqrt, math.atan, math.asin, math.abs, math.pi, math.max

-- baseVerts: 扁平 {x,y,z,...}；baseIdx: 扁平三角索引(0-based)
local function build(self, node, nativeMaterial)
    local baseVerts, baseIdx = self.baseVerts, self.baseIdx
    local radius, detail = self.radius, self.detail

    -- 取基础顶点为向量
    local function baseV(i) return { baseVerts[i * 3 + 1], baseVerts[i * 3 + 2], baseVerts[i * 3 + 3] } end

    local positions = {} -- 细分后的位置（投影前）

    -- 线性插值 a→b
    local function lerpv(a, b, t)
        return { a[1] + (b[1] - a[1]) * t, a[2] + (b[2] - a[2]) * t, a[3] + (b[3] - a[3]) * t }
    end

    -- 细分一个三角面（three.js subdivideFace）
    local function subdivideFace(a, b, c)
        local cols = detail + 1
        local v = {} -- v[i+1][j+1]
        for i = 0, cols do
            v[i + 1] = {}
            local aj = lerpv(a, c, i / cols)
            local bj = lerpv(b, c, i / cols)
            local rows = cols - i
            for j = 0, rows do
                if j == 0 and i == cols then
                    v[i + 1][j + 1] = aj
                else
                    v[i + 1][j + 1] = lerpv(aj, bj, rows == 0 and 0 or j / rows)
                end
            end
        end
        for i = 0, cols - 1 do
            for j = 0, 2 * (cols - i) - 2 do
                local k = math.floor(j / 2)
                if j % 2 == 0 then
                    positions[#positions + 1] = v[i + 1][k + 2]
                    positions[#positions + 1] = v[i + 2][k + 1]
                    positions[#positions + 1] = v[i + 1][k + 1]
                else
                    positions[#positions + 1] = v[i + 1][k + 2]
                    positions[#positions + 1] = v[i + 2][k + 2]
                    positions[#positions + 1] = v[i + 2][k + 1]
                end
            end
        end
    end

    for f = 0, (#baseIdx / 3) - 1 do
        local a = baseV(baseIdx[f * 3 + 1])
        local b = baseV(baseIdx[f * 3 + 2])
        local c = baseV(baseIdx[f * 3 + 3])
        subdivideFace(a, b, c)
    end

    local geom = node:CreateComponent("CustomGeometry")
    geom:BeginGeometry(0, TRIANGLE_LIST)
    for i = 1, #positions do
        local p = positions[i]
        -- 投影到球面（归一化 * radius），法线 = 归一化位置
        local l = sqrt(p[1] * p[1] + p[2] * p[2] + p[3] * p[3])
        if l < 1e-8 then l = 1e-8 end
        local nx, ny, nz = p[1] / l, p[2] / l, p[3] / l
        -- 方位/俯仰 UV（three.js azimuth/inclination）
        local u = atan(nz, -nx) / (2 * pi) + 0.5
        local vv = atan(-ny, sqrt(nx * nx + nz * nz)) / pi + 0.5
        geom:DefineVertex(Vector3(nx * radius, ny * radius, nz * radius))
        geom:DefineNormal(Vector3(nx, ny, nz))
        geom:DefineTexCoord(Vector2(u, vv))
    end
    geom:Commit()
    if nativeMaterial then geom:SetMaterial(nativeMaterial) end
    return geom
end

-- 供 4 个多面体复用：传入基础顶点/索引
function Poly.make(baseVerts, baseIdx, radius, detail)
    return {
        _kind = "geometry",
        baseVerts = baseVerts,
        baseIdx = baseIdx,
        radius = radius or 1,
        detail = max(0, math.floor(detail or 0)),
        build = build,
    }
end

return Poly
