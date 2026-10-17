-- ============================================================================
-- urhox-libs/3D · ConeGeometry
-- three.js ConeGeometry(radius, height, radialSegments, heightSegments,
--                       openEnded, thetaStart, thetaLength)
-- = CylinderGeometry(radiusTop=0, radiusBottom=radius, ...)。
-- ============================================================================

local Cylinder = require("urhox-libs/3D/Geometries/CylinderGeometry")

local Cone = {}

function Cone.new(radius, height, radialSegments, heightSegments, openEnded, thetaStart, thetaLength)
    local g = Cylinder.new(0, radius or 1, height or 1, radialSegments, heightSegments, openEnded, thetaStart, thetaLength)
    g.parameters = {
        radius = radius or 1, height = height or 1,
        radialSegments = math.max(3, math.floor(radialSegments or 32)),
        heightSegments = math.max(1, math.floor(heightSegments or 1)),
        openEnded = openEnded or false,
        thetaStart = thetaStart or 0, thetaLength = thetaLength or (math.pi * 2),
    }
    return g
end

return Cone
