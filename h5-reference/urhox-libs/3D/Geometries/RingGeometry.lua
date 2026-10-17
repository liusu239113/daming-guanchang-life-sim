-- ============================================================================
-- urhox-libs/3D · RingGeometry
-- three.js RingGeometry(innerRadius, outerRadius, thetaSegments, phiSegments,
--                       thetaStart, thetaLength)
-- 逐行移植 three.js 生成器（环面网格）。CustomGeometry 后端。
-- ============================================================================

local Ring = {}
local sin, cos, max, min, pi, sqrt = math.sin, math.cos, math.max, math.min, math.pi, math.sqrt

local function build(self, node, nativeMaterial)
    local inner = self.innerRadius
    local outer = self.outerRadius
    local thetaSeg = self.thetaSegments
    local phiSeg = self.phiSegments
    local thetaStart, thetaLength = self.thetaStart, self.thetaLength

    -- grid[j+1][i+1] = {px,py,pz, nx,ny,nz, u,v}；radius 由内到外
    local grid = {}
    local radius = inner
    local radiusStep = (outer - inner) / phiSeg
    for j = 0, phiSeg do
        local row = {}
        for i = 0, thetaSeg do
            local segment = thetaStart + i / thetaSeg * thetaLength
            local x = radius * cos(segment)
            local y = radius * sin(segment)
            row[i + 1] = { x, y, 0, 0, 0, 1, (x / outer + 1) * 0.5, (y / outer + 1) * 0.5 }
        end
        grid[j + 1] = row
        radius = radius + radiusStep
    end

    local geom = node:CreateComponent("CustomGeometry")
    geom:BeginGeometry(0, TRIANGLE_LIST)
    local function emit(v)
        geom:DefineVertex(Vector3(v[1], v[2], v[3]))
        geom:DefineNormal(Vector3(v[4], v[5], v[6]))
        geom:DefineTexCoord(Vector2(v[7], v[8]))
    end
    for j = 0, phiSeg - 1 do
        for i = 0, thetaSeg - 1 do
            local a = grid[j + 1][i + 1]
            local b = grid[j + 2][i + 1]
            local c = grid[j + 2][i + 2]
            local d = grid[j + 1][i + 2]
            emit(a); emit(b); emit(d)
            emit(b); emit(c); emit(d)
        end
    end
    geom:Commit()
    if nativeMaterial then geom:SetMaterial(nativeMaterial) end
    return geom
end

function Ring.new(innerRadius, outerRadius, thetaSegments, phiSegments, thetaStart, thetaLength)
    return {
        _kind = "geometry",
        innerRadius = innerRadius or 0.5,
        outerRadius = outerRadius or 1,
        thetaSegments = max(3, math.floor(thetaSegments or 32)),
        phiSegments = max(1, math.floor(phiSegments or 1)),
        thetaStart = thetaStart or 0,
        thetaLength = thetaLength or (pi * 2),
        parameters = {
            innerRadius = innerRadius or 0.5, outerRadius = outerRadius or 1,
            thetaSegments = max(3, math.floor(thetaSegments or 32)),
            phiSegments = max(1, math.floor(phiSegments or 1)),
            thetaStart = thetaStart or 0, thetaLength = thetaLength or (pi * 2),
        },
        build = build,
    }
end

return Ring
