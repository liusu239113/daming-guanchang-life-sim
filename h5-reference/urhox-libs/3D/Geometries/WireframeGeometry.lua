-- ============================================================================
-- urhox-libs/3D · WireframeGeometry
-- 忠实复刻 three.js WireframeGeometry：源几何全部三角形边（按位置去重）→ 线段端点 position
-- 的 BufferGeometry。用法同 three.js：THREE.LineSegments(WireframeGeometry(geo), mat)。
-- ============================================================================

local BufferGeometry = require("urhox-libs/3D/Core/BufferGeometry")
local BufferAttribute = require("urhox-libs/3D/Core/BufferAttribute")
local Tris = require("urhox-libs/3D/Geometries/_geometryTriangles")

local W = {}

local PRES = 1e4
local function hkey(x, y, z)
    return string.format("%d,%d,%d",
        math.floor(x * PRES + 0.5), math.floor(y * PRES + 0.5), math.floor(z * PRES + 0.5))
end

function W.make(geometry)
    local tri = Tris.readTriangles(geometry)
    local verts = {}
    if not tri then
        local g = BufferGeometry.new(); g:setAttribute("position", BufferAttribute.new({}, 3)); return g
    end
    local edges = {}
    local index = tri.index
    -- triangle vertex 0-based 索引序列
    local count = index and #index or tri.count

    local function px(vi) return tri:getX(vi) end
    local function py(vi) return tri:getY(vi) end
    local function pz(vi) return tri:getZ(vi) end

    for t = 0, count - 1, 3 do
        local i0, i1, i2
        if index then i0, i1, i2 = index[t + 1], index[t + 2], index[t + 3] else i0, i1, i2 = t, t + 1, t + 2 end
        local ids = { i0, i1, i2 }
        for j = 1, 3 do
            local a = ids[j]
            local b = ids[(j % 3) + 1]
            local ax, ay, az = px(a), py(a), pz(a)
            local bx, by, bz = px(b), py(b), pz(b)
            local ka, kb = hkey(ax, ay, az), hkey(bx, by, bz)
            local h1, h2 = ka .. "-" .. kb, kb .. "-" .. ka
            if not (edges[h1] or edges[h2]) then
                edges[h1] = true; edges[h2] = true
                verts[#verts + 1] = ax; verts[#verts + 1] = ay; verts[#verts + 1] = az
                verts[#verts + 1] = bx; verts[#verts + 1] = by; verts[#verts + 1] = bz
            end
        end
    end

    local g = BufferGeometry.new()
    g:setAttribute("position", BufferAttribute.new(verts, 3))
    g.type = "WireframeGeometry"
    return g
end

return W
