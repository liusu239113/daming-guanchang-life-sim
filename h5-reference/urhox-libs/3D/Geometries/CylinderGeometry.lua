-- ============================================================================
-- urhox-libs/3D · CylinderGeometry
-- three.js CylinderGeometry(radiusTop, radiusBottom, height, radialSegments,
--                           heightSegments, openEnded, thetaStart, thetaLength)
-- 逐行移植 three.js（torso + 顶/底盖；顶点/法线/UV/绕序照搬）。CustomGeometry 后端。
-- ConeGeometry = Cylinder(radiusTop=0)。
-- ============================================================================

local Cyl = {}
local sin, cos, sqrt, max, pi = math.sin, math.cos, math.sqrt, math.max, math.pi

local function build(self, node, nativeMaterial)
    local radiusTop, radiusBottom = self.radiusTop, self.radiusBottom
    local height = self.height
    local radialSeg, heightSeg = self.radialSeg, self.heightSeg
    local openEnded = self.openEnded
    local thetaStart, thetaLength = self.thetaStart, self.thetaLength
    local halfH = height * 0.5

    local geom = node:CreateComponent("CustomGeometry")
    geom:BeginGeometry(0, TRIANGLE_LIST)
    local function emit(v)
        geom:DefineVertex(Vector3(v[1], v[2], v[3]))
        geom:DefineNormal(Vector3(v[4], v[5], v[6]))
        geom:DefineTexCoord(Vector2(v[7], v[8]))
    end

    -- ---- torso（侧壁）----
    local slope = (radiusBottom - radiusTop) / height
    local grid = {}
    for iy = 0, heightSeg do
        local row = {}
        local vv = iy / heightSeg
        local radius = vv * (radiusBottom - radiusTop) + radiusTop
        for ix = 0, radialSeg do
            local u = ix / radialSeg
            local theta = u * thetaLength + thetaStart
            local sinT, cosT = sin(theta), cos(theta)
            local px = radius * sinT
            local py = -vv * height + halfH
            local pz = radius * cosT
            -- 法线（含斜率）
            local nx, ny, nz = sinT, slope, cosT
            local inv = 1.0 / max(1e-8, sqrt(nx * nx + ny * ny + nz * nz))
            row[ix + 1] = { px, py, pz, nx * inv, ny * inv, nz * inv, u, 1 - vv }
        end
        grid[iy + 1] = row
    end
    for iy = 0, heightSeg - 1 do
        for ix = 0, radialSeg - 1 do
            local a = grid[iy + 1][ix + 1]
            local b = grid[iy + 2][ix + 1]
            local c = grid[iy + 2][ix + 2]
            local d = grid[iy + 1][ix + 2]
            emit(a); emit(b); emit(d)
            emit(b); emit(c); emit(d)
        end
    end

    -- ---- caps（顶/底盖）----
    local function generateCap(top)
        local radius = top and radiusTop or radiusBottom
        if radius <= 0 then return end
        local sign = top and 1 or -1
        local capY = halfH * sign
        local ny = sign
        for ix = 0, radialSeg - 1 do
            local u0 = ix / radialSeg
            local u1 = (ix + 1) / radialSeg
            local t0 = u0 * thetaLength + thetaStart
            local t1 = u1 * thetaLength + thetaStart
            -- 中心点 + 边缘两点；top 与 bottom 绕序相反
            local center = { 0, capY, 0, 0, ny, 0, 0.5, 0.5 }
            local function edge(t)
                local s, c = sin(t), cos(t)
                return { radius * s, capY, radius * c, 0, ny, 0, s * 0.5 * sign + 0.5, c * 0.5 + 0.5 }
            end
            local e0, e1 = edge(t0), edge(t1)
            if top then
                emit(center); emit(e1); emit(e0)
            else
                emit(center); emit(e0); emit(e1)
            end
        end
    end
    if not openEnded then
        generateCap(true)
        generateCap(false)
    end

    geom:Commit()
    if nativeMaterial then geom:SetMaterial(nativeMaterial) end
    return geom
end

function Cyl.new(radiusTop, radiusBottom, height, radialSegments, heightSegments, openEnded, thetaStart, thetaLength)
    return {
        _kind = "geometry",
        radiusTop = radiusTop or 1,
        radiusBottom = radiusBottom or 1,
        height = height or 1,
        radialSeg = max(3, math.floor(radialSegments or 32)),
        heightSeg = max(1, math.floor(heightSegments or 1)),
        openEnded = openEnded or false,
        thetaStart = thetaStart or 0,
        thetaLength = thetaLength or (pi * 2),
        parameters = {
            radiusTop = radiusTop or 1, radiusBottom = radiusBottom or 1, height = height or 1,
            radialSegments = max(3, math.floor(radialSegments or 32)),
            heightSegments = max(1, math.floor(heightSegments or 1)),
            openEnded = openEnded or false,
            thetaStart = thetaStart or 0, thetaLength = thetaLength or (pi * 2),
        },
        build = build,
    }
end

return Cyl
