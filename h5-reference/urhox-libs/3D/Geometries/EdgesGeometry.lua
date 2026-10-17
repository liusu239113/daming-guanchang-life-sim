-- ============================================================================
-- urhox-libs/3D · EdgesGeometry
-- 忠实复刻 three.js EdgesGeometry：按二面角阈值提取硬边/轮廓 → 线段端点 position 的
-- BufferGeometry。边只出现一次（边界）或两相邻面法线夹角 > thresholdAngle 时输出。
-- 用法同 three.js：THREE.LineSegments(EdgesGeometry(geo, angle), mat)。
-- ============================================================================

local BufferGeometry = require("urhox-libs/3D/Core/BufferGeometry")
local BufferAttribute = require("urhox-libs/3D/Core/BufferAttribute")
local Tris = require("urhox-libs/3D/Geometries/_geometryTriangles")

local E = {}

local DEG2RAD = math.pi / 180
local PRES = 1e4
local function hkey(x, y, z)
    return string.format("%d,%d,%d",
        math.floor(x * PRES + 0.5), math.floor(y * PRES + 0.5), math.floor(z * PRES + 0.5))
end

function E.make(geometry, thresholdAngle)
    thresholdAngle = thresholdAngle or 1
    local thresholdDot = math.cos(DEG2RAD * thresholdAngle)
    local tri = Tris.readTriangles(geometry)
    local verts = {}
    if not tri then
        local g = BufferGeometry.new(); g:setAttribute("position", BufferAttribute.new({}, 3)); return g
    end

    local index = tri.index
    local count = index and #index or tri.count
    local edgeData = {} -- hash -> {v0={x,y,z}, v1={x,y,z}, nx,ny,nz} | false(已消费)

    for t = 0, count - 1, 3 do
        local i0, i1, i2
        if index then i0, i1, i2 = index[t + 1], index[t + 2], index[t + 3] else i0, i1, i2 = t, t + 1, t + 2 end
        local P = {
            { tri:getX(i0), tri:getY(i0), tri:getZ(i0) },
            { tri:getX(i1), tri:getY(i1), tri:getZ(i1) },
            { tri:getX(i2), tri:getY(i2), tri:getZ(i2) },
        }
        -- 面法线 normalize((c-b) × (a-b))
        local bx, by, bz = P[2][1], P[2][2], P[2][3]
        local cb1, cb2, cb3 = P[3][1] - bx, P[3][2] - by, P[3][3] - bz
        local ab1, ab2, ab3 = P[1][1] - bx, P[1][2] - by, P[1][3] - bz
        local nx = cb2 * ab3 - cb3 * ab2
        local ny = cb3 * ab1 - cb1 * ab3
        local nz = cb1 * ab2 - cb2 * ab1
        local nl = math.sqrt(nx * nx + ny * ny + nz * nz)
        if nl > 0 then nx, ny, nz = nx / nl, ny / nl, nz / nl end

        local h = {
            hkey(P[1][1], P[1][2], P[1][3]),
            hkey(P[2][1], P[2][2], P[2][3]),
            hkey(P[3][1], P[3][2], P[3][3]),
        }
        if h[1] == h[2] or h[2] == h[3] or h[3] == h[1] then
            -- 退化三角形，跳过（同 three.js）
        else
            for j = 1, 3 do
                local jn = (j % 3) + 1
                local hash = h[j] .. "_" .. h[jn]
                local reverse = h[jn] .. "_" .. h[j]
                local rev = edgeData[reverse]
                if rev and rev ~= false then
                    -- 该边的第二个相邻面：法线夹角足够大 → 硬边，输出
                    if (nx * rev.nx + ny * rev.ny + nz * rev.nz) <= thresholdDot then
                        local a, b = P[j], P[jn]
                        verts[#verts + 1] = a[1]; verts[#verts + 1] = a[2]; verts[#verts + 1] = a[3]
                        verts[#verts + 1] = b[1]; verts[#verts + 1] = b[2]; verts[#verts + 1] = b[3]
                    end
                    edgeData[reverse] = false -- 标记已消费
                elseif edgeData[hash] == nil then
                    edgeData[hash] = {
                        v0 = { P[j][1], P[j][2], P[j][3] },
                        v1 = { P[jn][1], P[jn][2], P[jn][3] },
                        nx = nx, ny = ny, nz = nz,
                    }
                end
            end
        end
    end

    -- 仅出现一次的边界边 → 输出
    for _, e in pairs(edgeData) do
        if e and e ~= false then
            verts[#verts + 1] = e.v0[1]; verts[#verts + 1] = e.v0[2]; verts[#verts + 1] = e.v0[3]
            verts[#verts + 1] = e.v1[1]; verts[#verts + 1] = e.v1[2]; verts[#verts + 1] = e.v1[3]
        end
    end

    local g = BufferGeometry.new()
    g:setAttribute("position", BufferAttribute.new(verts, 3))
    g.type = "EdgesGeometry"
    return g
end

return E
