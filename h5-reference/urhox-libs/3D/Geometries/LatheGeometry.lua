-- ============================================================================
-- urhox-libs/3D · LatheGeometry
-- three.js LatheGeometry(points, segments, phiStart, phiLength)
-- points = {{x,y},...}（剖面，绕 Y 轴旋转）。逐行移植：剖面法线预计算 + 旋转成面。
-- CustomGeometry 后端。
-- ============================================================================

local Lathe = {}
local sin, cos, sqrt, max, pi = math.sin, math.cos, math.sqrt, math.max, math.pi

-- points: array of {x,y}
local function buildFrom(points, segments, phiStart, phiLength, node, nativeMaterial)
    local np = #points
    -- 预计算剖面法线（three.js initNormals）：z=0 平面内
    local initN = {} -- initN[j] = {nx,ny}
    local prevx, prevy = 0, 0
    for j = 1, np do
        if j == 1 then
            local dx = points[2][1] - points[1][1]
            local dy = points[2][2] - points[1][2]
            local nx, ny = dy, -dx
            prevx, prevy = nx, ny
            local l = sqrt(nx * nx + ny * ny); if l < 1e-8 then l = 1e-8 end
            initN[j] = { nx / l, ny / l }
        elseif j == np then
            local l = sqrt(prevx * prevx + prevy * prevy); if l < 1e-8 then l = 1e-8 end
            initN[j] = { prevx / l, prevy / l }
        else
            local dx = points[j + 1][1] - points[j][1]
            local dy = points[j + 1][2] - points[j][2]
            local cnx, cny = dy, -dx
            local nx, ny = cnx + prevx, cny + prevy
            prevx, prevy = cnx, cny
            local l = sqrt(nx * nx + ny * ny); if l < 1e-8 then l = 1e-8 end
            initN[j] = { nx / l, ny / l }
        end
    end

    -- grid[i+1][j+1] = {px,py,pz, nx,ny,nz, u,v}
    local grid = {}
    for i = 0, segments do
        local phi = phiStart + i / segments * phiLength
        local sp, cp = sin(phi), cos(phi)
        local row = {}
        for j = 1, np do
            local px = points[j][1] * sp
            local py = points[j][2]
            local pz = points[j][1] * cp
            local n0x, n0y = initN[j][1], initN[j][2]
            local nx = n0x * sp
            local ny = n0y
            local nz = n0x * cp
            local l = sqrt(nx * nx + ny * ny + nz * nz); if l < 1e-8 then l = 1e-8 end
            row[j] = { px, py, pz, nx / l, ny / l, nz / l, i / segments, (j - 1) / (np - 1) }
        end
        grid[i + 1] = row
    end

    local geom = node:CreateComponent("CustomGeometry")
    geom:BeginGeometry(0, TRIANGLE_LIST)
    local function emit(v)
        geom:DefineVertex(Vector3(v[1], v[2], v[3]))
        geom:DefineNormal(Vector3(v[4], v[5], v[6]))
        geom:DefineTexCoord(Vector2(v[7], v[8]))
    end
    for i = 0, segments - 1 do
        for j = 1, np - 1 do
            local a = grid[i + 1][j]
            local b = grid[i + 2][j]
            local c = grid[i + 2][j + 1]
            local d = grid[i + 1][j + 1]
            emit(a); emit(b); emit(d)
            emit(b); emit(c); emit(d)
        end
    end
    geom:Commit()
    if nativeMaterial then geom:SetMaterial(nativeMaterial) end
    return geom
end

local function build(self, node, nativeMaterial)
    return buildFrom(self.points, self.segments, self.phiStart, self.phiLength, node, nativeMaterial)
end

function Lathe.new(points, segments, phiStart, phiLength)
    return {
        _kind = "geometry",
        points = points or { { 0, -0.5 }, { 0.5, 0 }, { 0, 0.5 } },
        segments = max(3, math.floor(segments or 12)),
        phiStart = phiStart or 0,
        phiLength = phiLength or (pi * 2),
        parameters = {
            points = points or { { 0, -0.5 }, { 0.5, 0 }, { 0, 0.5 } },
            segments = max(3, math.floor(segments or 12)),
            phiStart = phiStart or 0, phiLength = phiLength or (pi * 2),
        },
        build = build,
    }
end

-- 供 CapsuleGeometry 等复用
Lathe.buildFrom = buildFrom

return Lathe
