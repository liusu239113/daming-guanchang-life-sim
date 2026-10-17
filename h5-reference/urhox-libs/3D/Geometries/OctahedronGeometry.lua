-- ============================================================================
-- urhox-libs/3D · OctahedronGeometry(radius, detail)
-- three.js 同名几何：8 面体基础顶点 + PolyhedronGeometry。
-- ============================================================================

local Poly = require("urhox-libs/3D/Geometries/PolyhedronGeometry")

local Octa = {}

local VERTS = { 1, 0, 0, -1, 0, 0, 0, 1, 0, 0, -1, 0, 0, 0, 1, 0, 0, -1 }
local IDX = { 0, 2, 4, 0, 4, 3, 0, 3, 5, 0, 5, 2, 1, 2, 5, 1, 5, 3, 1, 3, 4, 1, 4, 2 }

function Octa.new(radius, detail)
    local g = Poly.make(VERTS, IDX, radius or 1, detail or 0)
    g.parameters = { radius = radius or 1, detail = detail or 0 }
    return g
end

return Octa
