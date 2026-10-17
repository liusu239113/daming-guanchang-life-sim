-- ============================================================================
-- urhox-libs/3D · TubeGeometry
-- three.js TubeGeometry(path, tubularSegments, radius, radialSegments, closed)。
-- 沿曲线(path)用 Frenet frames 扫一个半径 radius 的圆 → 管状网格。返回 BufferGeometry。
-- winding 对齐 PlaneGeometry（CULL_CW 下正面正确）。
-- ============================================================================

local BufferGeometry = require("urhox-libs/3D/Core/BufferGeometry")
local BufferAttribute = require("urhox-libs/3D/Core/BufferAttribute")

local Tube = {}

function Tube.new(path, tubularSegments, radius, radialSegments, closed)
    tubularSegments = tubularSegments or 64
    radius = radius or 1
    radialSegments = radialSegments or 8
    closed = closed or false

    local frames = path:computeFrenetFrames(tubularSegments, closed)
    local N, B = frames.normals, frames.binormals
    local positions, normals, uvs, index = {}, {}, {}, {}

    for i = 0, tubularSegments do
        local P = path:getPoint(i / tubularSegments)
        local n = N[i + 1]
        local b = B[i + 1]
        for j = 0, radialSegments do
            local v = j / radialSegments * math.pi * 2
            local sin, cos = math.sin(v), -math.cos(v)
            local nx = cos * n.x + sin * b.x
            local ny = cos * n.y + sin * b.y
            local nz = cos * n.z + sin * b.z
            local nl = math.sqrt(nx * nx + ny * ny + nz * nz)
            if nl > 0 then nx, ny, nz = nx / nl, ny / nl, nz / nl end
            positions[#positions + 1] = P.x + radius * nx
            positions[#positions + 1] = P.y + radius * ny
            positions[#positions + 1] = P.z + radius * nz
            normals[#normals + 1] = nx; normals[#normals + 1] = ny; normals[#normals + 1] = nz
            uvs[#uvs + 1] = i / tubularSegments; uvs[#uvs + 1] = j / radialSegments
        end
    end

    local stride = radialSegments + 1
    for i = 0, tubularSegments - 1 do
        for j = 0, radialSegments - 1 do
            local a = i * stride + j
            local b2 = a + 1
            local c = a + 1 + stride
            local d = a + stride
            index[#index + 1] = a; index[#index + 1] = b2; index[#index + 1] = c
            index[#index + 1] = a; index[#index + 1] = c; index[#index + 1] = d
        end
    end

    local geo = BufferGeometry.new()
    geo:setAttribute("position", BufferAttribute.new(positions, 3))
    geo:setAttribute("normal", BufferAttribute.new(normals, 3))
    geo:setAttribute("uv", BufferAttribute.new(uvs, 2))
    geo:setIndex(index)
    geo.parameters = { path = path, tubularSegments = tubularSegments, radius = radius,
        radialSegments = radialSegments, closed = closed }
    return geo
end

return Tube
