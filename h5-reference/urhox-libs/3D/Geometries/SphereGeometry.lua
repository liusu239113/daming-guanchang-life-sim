-- ============================================================================
-- urhox-libs/3D · SphereGeometry
-- three.js SphereGeometry(radius, widthSegments, heightSegments,
--                         phiStart, phiLength, thetaStart, thetaLength)
-- 逐行移植 three.js 生成器（顶点/法线/UV/绕序照搬）。CustomGeometry 后端。
-- ============================================================================

local Sphere = {}
local sin, cos, max, pi = math.sin, math.cos, math.max, math.pi

local function build(self, node, nativeMaterial)
    local radius = self.radius
    local wSeg = self.wSeg
    local hSeg = self.hSeg
    local phiStart, phiLength = self.phiStart, self.phiLength
    local thetaStart, thetaLength = self.thetaStart, self.thetaLength
    local thetaEnd = math.min(thetaStart + thetaLength, pi)

    -- 顶点网格 grid[iy+1][ix+1] = {px,py,pz, nx,ny,nz, u, v}
    local grid = {}
    for iy = 0, hSeg do
        local row = {}
        local v = iy / hSeg
        -- three.js 极点 UV 偏移
        local uOffset = 0
        if iy == 0 and thetaStart == 0 then
            uOffset = 0.5 / wSeg
        elseif iy == hSeg and thetaEnd == pi then
            uOffset = -0.5 / wSeg
        end
        for ix = 0, wSeg do
            local u = ix / wSeg
            local px = -radius * cos(phiStart + u * phiLength) * sin(thetaStart + v * thetaLength)
            local py = radius * cos(thetaStart + v * thetaLength)
            local pz = radius * sin(phiStart + u * phiLength) * sin(thetaStart + v * thetaLength)
            local inv = 1.0 / max(1e-8, math.sqrt(px * px + py * py + pz * pz))
            row[ix + 1] = { px, py, pz, px * inv, py * inv, pz * inv, u + uOffset, 1 - v }
        end
        grid[iy + 1] = row
    end

    local geom = node:CreateComponent("CustomGeometry")
    geom:BeginGeometry(0, TRIANGLE_LIST)
    local function emit(vtx)
        geom:DefineVertex(Vector3(vtx[1], vtx[2], vtx[3]))
        geom:DefineNormal(Vector3(vtx[4], vtx[5], vtx[6]))
        geom:DefineTexCoord(Vector2(vtx[7], vtx[8]))
    end
    for iy = 0, hSeg - 1 do
        for ix = 0, wSeg - 1 do
            local a = grid[iy + 1][ix + 2]
            local b = grid[iy + 1][ix + 1]
            local c = grid[iy + 2][ix + 1]
            local d = grid[iy + 2][ix + 2]
            if iy ~= 0 or thetaStart > 0 then emit(a); emit(b); emit(d) end
            if iy ~= hSeg - 1 or thetaEnd < pi then emit(b); emit(c); emit(d) end
        end
    end
    geom:Commit()
    if nativeMaterial then geom:SetMaterial(nativeMaterial) end
    return geom
end

function Sphere.new(radius, widthSegments, heightSegments, phiStart, phiLength, thetaStart, thetaLength)
    return {
        _kind = "geometry",
        radius = radius or 1,
        wSeg = max(3, math.floor(widthSegments or 32)),
        hSeg = max(2, math.floor(heightSegments or 16)),
        phiStart = phiStart or 0,
        phiLength = phiLength or (pi * 2),
        thetaStart = thetaStart or 0,
        thetaLength = thetaLength or pi,
        parameters = {
            radius = radius or 1,
            widthSegments = max(3, math.floor(widthSegments or 32)),
            heightSegments = max(2, math.floor(heightSegments or 16)),
            phiStart = phiStart or 0, phiLength = phiLength or (pi * 2),
            thetaStart = thetaStart or 0, thetaLength = thetaLength or pi,
        },
        build = build,
    }
end

return Sphere
