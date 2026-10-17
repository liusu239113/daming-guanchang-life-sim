-- ============================================================================
-- urhox-libs/3D · PlaneGeometry
-- three.js PlaneGeometry(width, height, widthSegments, heightSegments)。
-- 位于 XY 平面、法线 +Z；做地面常配合 rotation.x = -pi/2。
-- 返回 BufferGeometry → 可 .attributes.position / computeVertexNormals / 运行时改顶点
--（动态窗帘）。winding 沿用旧实现（CULL_CW 下正面正确）。
-- ============================================================================

local BufferGeometry = require("urhox-libs/3D/Core/BufferGeometry")
local BufferAttribute = require("urhox-libs/3D/Core/BufferAttribute")

local Plane = {}

function Plane.new(width, height, widthSegments, heightSegments)
    local w = width or 1
    local h = height or 1
    local ws = math.max(1, math.floor(widthSegments or 1))
    local hs = math.max(1, math.floor(heightSegments or 1))
    local x0, y0 = -w * 0.5, -h * 0.5
    local dx, dy = w / ws, h / hs

    local positions, normals, uvs, index = {}, {}, {}, {}
    -- 顶点网格 (ws+1)x(hs+1)
    for iy = 0, hs do
        for ix = 0, ws do
            positions[#positions + 1] = x0 + ix * dx
            positions[#positions + 1] = y0 + iy * dy
            positions[#positions + 1] = 0
            normals[#normals + 1] = 0; normals[#normals + 1] = 0; normals[#normals + 1] = 1
            uvs[#uvs + 1] = ix / ws; uvs[#uvs + 1] = iy / hs
        end
    end
    -- 索引（0-based）：cell 两三角 (a,b,c)(a,c,d)，与旧 winding 一致
    local stride = ws + 1
    for iy = 0, hs - 1 do
        for ix = 0, ws - 1 do
            local a = iy * stride + ix
            local b = a + 1
            local c = a + 1 + stride
            local d = a + stride
            index[#index + 1] = a; index[#index + 1] = b; index[#index + 1] = c
            index[#index + 1] = a; index[#index + 1] = c; index[#index + 1] = d
        end
    end

    local geo = BufferGeometry.new()
    geo:setAttribute("position", BufferAttribute.new(positions, 3))
    geo:setAttribute("normal", BufferAttribute.new(normals, 3))
    geo:setAttribute("uv", BufferAttribute.new(uvs, 2))
    geo:setIndex(index)
    geo.parameters = { width = w, height = h, widthSegments = ws, heightSegments = hs }
    return geo
end

return Plane
