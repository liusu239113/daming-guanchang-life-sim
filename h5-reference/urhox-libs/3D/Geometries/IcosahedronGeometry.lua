-- ============================================================================
-- urhox-libs/3D · IcosahedronGeometry(radius, detail)
-- three.js 同名几何：20 面体基础顶点 + PolyhedronGeometry 细分/投影。
-- ============================================================================

local Poly = require("urhox-libs/3D/Geometries/PolyhedronGeometry")

local Ico = {}

local t = (1 + math.sqrt(5)) / 2
local VERTS = {
    -1, t, 0, 1, t, 0, -1, -t, 0, 1, -t, 0,
    0, -1, t, 0, 1, t, 0, -1, -t, 0, 1, -t,
    t, 0, -1, t, 0, 1, -t, 0, -1, -t, 0, 1,
}
local IDX = {
    0, 11, 5, 0, 5, 1, 0, 1, 7, 0, 7, 10, 0, 10, 11,
    1, 5, 9, 5, 11, 4, 11, 10, 2, 10, 7, 6, 7, 1, 8,
    3, 9, 4, 3, 4, 2, 3, 2, 6, 3, 6, 8, 3, 8, 9,
    4, 9, 5, 2, 4, 11, 6, 2, 10, 8, 6, 7, 9, 8, 1,
}

function Ico.new(radius, detail)
    local g = Poly.make(VERTS, IDX, radius or 1, detail or 0)
    g.parameters = { radius = radius or 1, detail = detail or 0 }
    return g
end

return Ico
