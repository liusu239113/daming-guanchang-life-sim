-- ============================================================================
-- urhox-libs/3D · CapsuleGeometry(radius, length, capSegments, radialSegments)
-- three.js 同名几何：底/顶两段半圆弧拼成剖面，绕 Y 用 LatheGeometry 旋转成胶囊。
-- ============================================================================

local Lathe = require("urhox-libs/3D/Geometries/LatheGeometry")

local Capsule = {}
local sin, cos, max, pi = math.sin, math.cos, math.max, math.pi

local function build(self, node, nativeMaterial)
    local radius = self.radius
    local halfLen = self.length * 0.5
    local cap = self.capSegments
    local hSeg = self.heightSegments
    -- 剖面点（x>=0，绕 Y）：底半圆(-90°→0°) + 直筒体 + 顶半圆(0°→90°)
    local points = {}
    for i = 0, cap do
        local a = -pi * 0.5 + (i / cap) * (pi * 0.5)
        points[#points + 1] = { radius * cos(a), -halfLen + radius * sin(a) }
    end
    -- 直筒体：(radius,-halfLen)→(radius,halfLen) 间插 hSeg-1 个中间点（端点由两弧提供）
    for i = 1, hSeg - 1 do
        local t = i / hSeg
        points[#points + 1] = { radius, -halfLen + t * (2 * halfLen) }
    end
    for i = 0, cap do
        local a = (i / cap) * (pi * 0.5)
        points[#points + 1] = { radius * cos(a), halfLen + radius * sin(a) }
    end
    return Lathe.buildFrom(points, self.radialSegments, 0, pi * 2, node, nativeMaterial)
end

-- three.js: CapsuleGeometry(radius, length, capSegments, radialSegments, heightSegments)
function Capsule.new(radius, length, capSegments, radialSegments, heightSegments)
    local r, len = radius or 1, length or 1
    local cs = max(1, math.floor(capSegments or 4))
    local rs = max(3, math.floor(radialSegments or 8))
    local hs = max(1, math.floor(heightSegments or 1))
    return {
        _kind = "geometry",
        radius = r, length = len, capSegments = cs, radialSegments = rs, heightSegments = hs,
        -- three.js 参数名用 height（= length）
        parameters = { radius = r, height = len, capSegments = cs, radialSegments = rs, heightSegments = hs },
        build = build,
    }
end

return Capsule
