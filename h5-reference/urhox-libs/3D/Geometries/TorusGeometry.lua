-- ============================================================================
-- urhox-libs/3D · TorusGeometry
-- three.js TorusGeometry(radius, tube, radialSegments, tubularSegments, arc)
-- 逐行移植（环在 XY 平面，孔沿 Z）。顶点/法线/UV/绕序照搬。CustomGeometry 后端。
-- ============================================================================

local Torus = {}
local sin, cos, max, pi = math.sin, math.cos, math.max, math.pi

local function build(self, node, nativeMaterial)
    local radius, tube = self.radius, self.tube
    local radialSeg, tubularSeg = self.radialSeg, self.tubularSeg
    local arc = self.arc

    -- grid[j+1][i+1] = {px,py,pz, nx,ny,nz, u,v}
    local grid = {}
    for j = 0, radialSeg do
        local row = {}
        for i = 0, tubularSeg do
            local u = i / tubularSeg * arc
            local v = j / radialSeg * pi * 2
            local cu, su = cos(u), sin(u)
            local cv = cos(v)
            local px = (radius + tube * cv) * cu
            local py = (radius + tube * cv) * su
            local pz = tube * sin(v)
            -- 法线 = normalize(vertex - 环心)
            local cx, cy, cz = radius * cu, radius * su, 0
            local nx, ny, nz = px - cx, py - cy, pz - cz
            local inv = 1.0 / max(1e-8, math.sqrt(nx * nx + ny * ny + nz * nz))
            row[i + 1] = { px, py, pz, nx * inv, ny * inv, nz * inv, i / tubularSeg, j / radialSeg }
        end
        grid[j + 1] = row
    end

    local geom = node:CreateComponent("CustomGeometry")
    geom:BeginGeometry(0, TRIANGLE_LIST)
    local function emit(vtx)
        geom:DefineVertex(Vector3(vtx[1], vtx[2], vtx[3]))
        geom:DefineNormal(Vector3(vtx[4], vtx[5], vtx[6]))
        geom:DefineTexCoord(Vector2(vtx[7], vtx[8]))
    end
    for j = 1, radialSeg do
        for i = 1, tubularSeg do
            local a = grid[j + 1][i]
            local b = grid[j][i]
            local c = grid[j][i + 1]
            local d = grid[j + 1][i + 1]
            emit(a); emit(b); emit(d)
            emit(b); emit(c); emit(d)
        end
    end
    geom:Commit()
    if nativeMaterial then geom:SetMaterial(nativeMaterial) end
    return geom
end

function Torus.new(radius, tube, radialSegments, tubularSegments, arc)
    return {
        _kind = "geometry",
        radius = radius or 1,
        tube = tube or 0.4,
        radialSeg = max(2, math.floor(radialSegments or 12)),
        tubularSeg = max(3, math.floor(tubularSegments or 48)),
        arc = arc or (pi * 2),
        parameters = {
            radius = radius or 1, tube = tube or 0.4,
            radialSegments = max(2, math.floor(radialSegments or 12)),
            tubularSegments = max(3, math.floor(tubularSegments or 48)),
            arc = arc or (pi * 2),
        },
        build = build,
    }
end

return Torus
