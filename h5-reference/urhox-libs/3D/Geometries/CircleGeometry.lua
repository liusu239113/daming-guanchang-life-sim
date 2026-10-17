-- ============================================================================
-- urhox-libs/3D · CircleGeometry
-- three.js CircleGeometry(radius, segments, thetaStart, thetaLength)
-- 逐行移植 three.js 生成器（中心扇形）。CustomGeometry 后端。
-- ============================================================================

local Circle = {}
local sin, cos, max, pi = math.sin, math.cos, math.max, math.pi

local function build(self, node, nativeMaterial)
    local radius = self.radius
    local segments = self.segments
    local thetaStart, thetaLength = self.thetaStart, self.thetaLength

    -- 顶点：中心 + 边缘环（three.js 顺序）
    local verts = {}
    verts[1] = { 0, 0, 0, 0, 0, 1, 0.5, 0.5 } -- center
    for s = 0, segments do
        local segment = thetaStart + s / segments * thetaLength
        local x = radius * cos(segment)
        local y = radius * sin(segment)
        verts[#verts + 1] = { x, y, 0, 0, 0, 1, (x / radius + 1) * 0.5, (y / radius + 1) * 0.5 }
    end

    local geom = node:CreateComponent("CustomGeometry")
    geom:BeginGeometry(0, TRIANGLE_LIST)
    local function emit(v)
        geom:DefineVertex(Vector3(v[1], v[2], v[3]))
        geom:DefineNormal(Vector3(v[4], v[5], v[6]))
        geom:DefineTexCoord(Vector2(v[7], v[8]))
    end
    -- 索引：(i, i+1, center) 对应 three.js (i, i+1, 0)；顶点表 1-based，center 在 [1]，环从 [2]
    for i = 1, segments do
        emit(verts[i + 1]); emit(verts[i + 2]); emit(verts[1])
    end
    geom:Commit()
    if nativeMaterial then geom:SetMaterial(nativeMaterial) end
    return geom
end

function Circle.new(radius, segments, thetaStart, thetaLength)
    return {
        _kind = "geometry",
        radius = radius or 1,
        segments = max(3, math.floor(segments or 32)),
        thetaStart = thetaStart or 0,
        thetaLength = thetaLength or (pi * 2),
        parameters = {
            radius = radius or 1, segments = max(3, math.floor(segments or 32)),
            thetaStart = thetaStart or 0, thetaLength = thetaLength or (pi * 2),
        },
        build = build,
    }
end

return Circle
