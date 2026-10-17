-- ============================================================================
-- urhox-libs/3D · TorusKnotGeometry
-- three.js TorusKnotGeometry(radius, tube, tubularSegments, radialSegments, p, q)
-- 逐行移植 three.js 生成器（(p,q) 环面纽结参数曲线 + 管壁）。CustomGeometry 后端。
-- ============================================================================

local TorusKnot = {}
local sin, cos, max, pi, sqrt = math.sin, math.cos, math.max, math.pi, math.sqrt

-- 曲线上的位置（three.js calculatePositionOnCurve）
local function curvePos(u, p, q, radius)
    local cu = cos(u)
    local su = sin(u)
    local quOverP = q / p * u
    local cs = cos(quOverP)
    local x = radius * (2 + cs) * 0.5 * cu
    local y = radius * (2 + cs) * su * 0.5
    local z = radius * sin(quOverP) * 0.5
    return x, y, z
end

local function norm3(x, y, z)
    local l = sqrt(x * x + y * y + z * z)
    if l < 1e-8 then return 0, 0, 0 end
    return x / l, y / l, z / l
end

local function build(self, node, nativeMaterial)
    local radius, tube = self.radius, self.tube
    local tSeg, rSeg = self.tubularSegments, self.radialSegments
    local p, q = self.p, self.q

    -- grid[i+1][j+1] = {px,py,pz, nx,ny,nz, u,v}
    local grid = {}
    for i = 0, tSeg do
        local u = i / tSeg * p * pi * 2
        local p1x, p1y, p1z = curvePos(u, p, q, radius)
        local p2x, p2y, p2z = curvePos(u + 0.01, p, q, radius)
        -- T = P2-P1, N = P2+P1, B = T×N, N = B×T
        local tx, ty, tz = p2x - p1x, p2y - p1y, p2z - p1z
        local nx, ny, nz = p2x + p1x, p2y + p1y, p2z + p1z
        local bx, by, bz = ty * nz - tz * ny, tz * nx - tx * nz, tx * ny - ty * nx
        nx, ny, nz = by * tz - bz * ty, bz * tx - bx * tz, bx * ty - by * tx
        bx, by, bz = norm3(bx, by, bz)
        nx, ny, nz = norm3(nx, ny, nz)
        local row = {}
        for j = 0, rSeg do
            local v = j / rSeg * pi * 2
            local cx = -tube * cos(v)
            local cy = tube * sin(v)
            local vx = p1x + (cx * nx + cy * bx)
            local vy = p1y + (cx * ny + cy * by)
            local vz = p1z + (cx * nz + cy * bz)
            local vnx, vny, vnz = norm3(vx - p1x, vy - p1y, vz - p1z)
            row[j + 1] = { vx, vy, vz, vnx, vny, vnz, i / tSeg, j / rSeg }
        end
        grid[i + 1] = row
    end

    local geom = node:CreateComponent("CustomGeometry")
    geom:BeginGeometry(0, TRIANGLE_LIST)
    local function emit(vt)
        geom:DefineVertex(Vector3(vt[1], vt[2], vt[3]))
        geom:DefineNormal(Vector3(vt[4], vt[5], vt[6]))
        geom:DefineTexCoord(Vector2(vt[7], vt[8]))
    end
    for i = 1, tSeg do
        for j = 1, rSeg do
            local a = grid[i][j]
            local b = grid[i + 1][j]
            local c = grid[i + 1][j + 1]
            local d = grid[i][j + 1]
            emit(a); emit(b); emit(d)
            emit(b); emit(c); emit(d)
        end
    end
    geom:Commit()
    if nativeMaterial then geom:SetMaterial(nativeMaterial) end
    return geom
end

function TorusKnot.new(radius, tube, tubularSegments, radialSegments, p, q)
    return {
        _kind = "geometry",
        radius = radius or 1,
        tube = tube or 0.4,
        tubularSegments = max(3, math.floor(tubularSegments or 64)),
        radialSegments = max(3, math.floor(radialSegments or 8)),
        p = p or 2,
        q = q or 3,
        parameters = {
            radius = radius or 1, tube = tube or 0.4,
            tubularSegments = max(3, math.floor(tubularSegments or 64)),
            radialSegments = max(3, math.floor(radialSegments or 8)),
            p = p or 2, q = q or 3,
        },
        build = build,
    }
end

return TorusKnot
