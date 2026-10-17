-- ============================================================================
-- urhox-libs/3D · SpotLight
-- three.js SpotLight(color, intensity, distance, angle, penumbra, decay)。
-- Object3D + Light(LIGHT_SPOT)。angle=外锥半角(弧度)；penumbra∈[0,1] 软边比例。
-- 方向用 :lookAt(target) / .target（Urho 光沿 +Z 照射）。
-- 运行时：color/intensity/distance/angle/penumbra/castShadow/target/shadow/map。
-- map(gobo)：SpotLight 投影纹理 → UrhoX Light shapeTexture（B4 接 CanvasTexture）。
-- ============================================================================

local Object3D = require("urhox-libs/3D/Core/Object3D")
local Convert = require("urhox-libs/3D/Core/Convert")
local LC = require("urhox-libs/3D/Lights/LightCommon")

local SL = {}

local function applyCone(self)
    local l = rawget(self, "_light")
    local ang = rawget(self, "_angle")
    local pen = rawget(self, "_penumbra")
    l.outerConeAngle = Convert.radToDeg(ang)
    l.innerConeAngle = Convert.radToDeg(ang * (1 - pen))
    l.fov = Convert.radToDeg(ang * 2)
end

-- 把 THREE.Texture(gobo) 设为聚光投影纹理（就绪后绑定）
local function applyMap(self)
    local tex = rawget(self, "_map")
    local l = rawget(self, "_light")
    if not tex or not l.SetShapeTexture then return end
    if tex.onReady then
        tex:onReady(function(native) if native then l:SetShapeTexture(native) end end)
    elseif tex.getNative then
        local n = tex:getNative(); if n then l:SetShapeTexture(n) end
    end
end

local function sget(self, k)
    if k == "isSpotLight" then return true end
    if k == "type" then return "SpotLight" end
    if k == "angle" then return rawget(self, "_angle") end
    if k == "penumbra" then return rawget(self, "_penumbra") end
    if k == "distance" then return rawget(self, "_light").range end
    if k == "map" then return rawget(self, "_map") end
    return LC.get(self, k)
end

local function sset(self, k, v)
    if k == "angle" then rawset(self, "_angle", v); applyCone(self); return true end
    if k == "penumbra" then rawset(self, "_penumbra", v); applyCone(self); return true end
    if k == "distance" then rawget(self, "_light").range = (v and v > 0) and v or 100.0; return true end
    if k == "decay" then return true end
    if k == "map" then rawset(self, "_map", v); applyMap(self); return true end
    return LC.set(self, k, v)
end

local mt = Object3D.makeMeta({}, sget, sset)

function SL.new(color, intensity, distance, angle, penumbra, decay)
    local self = setmetatable({}, mt)
    local light = LC.setupLight(self, LIGHT_SPOT, color, intensity)
    light.range = (distance and distance > 0) and distance or 100.0
    rawset(self, "_angle", angle or (math.pi / 3))
    rawset(self, "_penumbra", penumbra or 0)
    applyCone(self)
    LC.initTarget(self) -- three.js 默认 target（在原点）：light.target.position 可直接访问
    return self
end

return SL
