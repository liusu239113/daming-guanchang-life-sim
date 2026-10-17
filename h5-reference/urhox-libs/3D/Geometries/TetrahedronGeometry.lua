-- ============================================================================
-- urhox-libs/3D · TetrahedronGeometry(radius, detail)
-- three.js 同名几何：4 面体基础顶点 + PolyhedronGeometry。
-- ============================================================================

local Poly = require("urhox-libs/3D/Geometries/PolyhedronGeometry")

local Tetra = {}

local VERTS = { 1, 1, 1, -1, -1, 1, -1, 1, -1, 1, -1, -1 }
local IDX = { 2, 1, 0, 0, 3, 2, 1, 3, 0, 2, 3, 1 }

function Tetra.new(radius, detail)
    local g = Poly.make(VERTS, IDX, radius or 1, detail or 0)
    g.parameters = { radius = radius or 1, detail = detail or 0 }
    return g
end

return Tetra
