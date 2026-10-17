-- ============================================================================
-- urhox-libs/3D · RoundedBoxGeometry
-- three.js addons RoundedBoxGeometry(width, height, depth, segments, radius)。
-- 做法：把每个面细分成 segments×segments 网格 → 每个顶点先钳制到"内盒"(half-r)，
-- 再沿到内盒的方向外推 radius，得到圆角；法线 = 该外推方向（平面处即面法线，棱/角处径向）。
-- segments 越大圆角越平滑（three.js 默认 2 较粗；本实现默认 6）。
-- ============================================================================

local Rounded = {}

-- 6 面：法线 + 4 角（CCW，单位 ±0.5），u 边=q1→q2，v 边=q1→q4（与 BoxGeometry 一致）
local FACES = {
    { n = { 1, 0, 0 },  c = { { 0.5, -0.5, 0.5 }, { 0.5, -0.5, -0.5 }, { 0.5, 0.5, -0.5 }, { 0.5, 0.5, 0.5 } } },
    { n = { -1, 0, 0 }, c = { { -0.5, -0.5, -0.5 }, { -0.5, -0.5, 0.5 }, { -0.5, 0.5, 0.5 }, { -0.5, 0.5, -0.5 } } },
    { n = { 0, 1, 0 },  c = { { -0.5, 0.5, 0.5 }, { 0.5, 0.5, 0.5 }, { 0.5, 0.5, -0.5 }, { -0.5, 0.5, -0.5 } } },
    { n = { 0, -1, 0 }, c = { { -0.5, -0.5, -0.5 }, { 0.5, -0.5, -0.5 }, { 0.5, -0.5, 0.5 }, { -0.5, -0.5, 0.5 } } },
    { n = { 0, 0, 1 },  c = { { -0.5, -0.5, 0.5 }, { 0.5, -0.5, 0.5 }, { 0.5, 0.5, 0.5 }, { -0.5, 0.5, 0.5 } } },
    { n = { 0, 0, -1 }, c = { { 0.5, -0.5, -0.5 }, { -0.5, -0.5, -0.5 }, { -0.5, 0.5, -0.5 }, { 0.5, 0.5, -0.5 } } },
}

local function build(self, node, nativeMaterial)
    local w, h, d = self.w, self.h, self.d
    local seg = self.seg
    local hw, hh, hd = w * 0.5, h * 0.5, d * 0.5
    local r = math.min(self.r, hw, hh, hd) -- 半径不能超过任一半长
    local ix, iy, iz = hw - r, hh - r, hd - r

    -- 把单位面坐标(±0.5)→全尺寸 box 点 → 圆角形变；返回 pos + normal
    local function deform(ux, uy, uz)
        local px, py, pz = ux * w, uy * h, uz * d
        local cx = math.max(-ix, math.min(ix, px))
        local cy = math.max(-iy, math.min(iy, py))
        local cz = math.max(-iz, math.min(iz, pz))
        local dx, dy, dz = px - cx, py - cy, pz - cz
        local len = math.sqrt(dx * dx + dy * dy + dz * dz)
        if len > 1e-6 then
            local inv = r / len
            return cx + dx * inv, cy + dy * inv, cz + dz * inv, dx / len, dy / len, dz / len
        end
        return px, py, pz, 0, 0, 0
    end

    local geom = node:CreateComponent("CustomGeometry")
    geom:BeginGeometry(0, TRIANGLE_LIST)

    for _, f in ipairs(FACES) do
        local q1, q2, q4 = f.c[1], f.c[2], f.c[4]
        -- 网格点(i,j)的单位坐标 = q1 + (i/seg)*(q2-q1) + (j/seg)*(q4-q1)
        local function gridUnit(i, j)
            local u, v = i / seg, j / seg
            return q1[1] + u * (q2[1] - q1[1]) + v * (q4[1] - q1[1]),
                q1[2] + u * (q2[2] - q1[2]) + v * (q4[2] - q1[2]),
                q1[3] + u * (q2[3] - q1[3]) + v * (q4[3] - q1[3])
        end
        local function emit(i, j)
            local ux, uy, uz = gridUnit(i, j)
            local x, y, z, nx, ny, nz = deform(ux, uy, uz)
            geom:DefineVertex(Vector3(x, y, z))
            geom:DefineNormal(Vector3(nx, ny, nz))
            geom:DefineTexCoord(Vector2(i / seg, j / seg))
        end
        for i = 0, seg - 1 do
            for j = 0, seg - 1 do
                -- cell 两三角 (a,b,c)(a,c,d)，a=(i,j) b=(i+1,j) c=(i+1,j+1) d=(i,j+1)
                emit(i, j); emit(i + 1, j); emit(i + 1, j + 1)
                emit(i, j); emit(i + 1, j + 1); emit(i, j + 1)
            end
        end
    end

    geom:Commit()
    if nativeMaterial then geom:SetMaterial(nativeMaterial) end
    return geom
end

function Rounded.new(width, height, depth, segments, radius)
    return {
        _kind = "geometry",
        w = width or 1, h = height or 1, d = depth or 1,
        seg = math.max(1, math.floor(segments or 6)),
        r = radius or 0.1,
        parameters = { width = width or 1, height = height or 1, depth = depth or 1,
            segments = math.max(1, math.floor(segments or 6)), radius = radius or 0.1 },
        build = build,
    }
end

return Rounded
