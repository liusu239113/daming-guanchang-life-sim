-- ============================================================================
-- urhox-libs/3D · PointLight
-- three.js PointLight(color, intensity, distance, decay)。Object3D + Light(LIGHT_POINT)。
-- distance=0（three.js 无限）→ 取较大默认 range。decay 固定物理(2)，存值 no-op。
-- 运行时：color/intensity/distance/castShadow/shadow。
-- ============================================================================

local Object3D = require("urhox-libs/3D/Core/Object3D")
local LC = require("urhox-libs/3D/Lights/LightCommon")

local PL = {}

local function pget(self, k)
    if k == "isPointLight" then return true end
    if k == "type" then return "PointLight" end
    if k == "distance" then return rawget(self, "_light").range end
    return LC.get(self, k)
end

local function pset(self, k, v)
    if k == "distance" then rawget(self, "_light").range = (v and v > 0) and v or 100.0; return true end
    if k == "decay" then return true end -- UrhoX 固定物理衰减
    return LC.set(self, k, v)
end

local mt = Object3D.makeMeta({}, pget, pset)

function PL.new(color, intensity, distance, decay)
    local self = setmetatable({}, mt)
    local light = LC.setupLight(self, LIGHT_POINT, color, intensity)
    light.range = (distance and distance > 0) and distance or 100.0
    return self
end

return PL
