-- ============================================================================
-- urhox-libs/3D · DirectionalLight
-- three.js DirectionalLight(color, intensity)。Object3D + Light(LIGHT_DIRECTIONAL)。
-- 方向：Urho 光沿节点 +Z 照射，故 :lookAt(target) / 设 .target 让 +Z 指向目标。
-- 运行时：color/intensity/castShadow/target/shadow（见 LightCommon/LightShadow）。
-- ============================================================================

local Object3D = require("urhox-libs/3D/Core/Object3D")
local LC = require("urhox-libs/3D/Lights/LightCommon")

local DL = {}

local function dget(self, k)
    if k == "isDirectionalLight" then return true end
    if k == "type" then return "DirectionalLight" end
    return LC.get(self, k)
end

local mt = Object3D.makeMeta({}, dget, LC.set)

function DL.new(color, intensity)
    local self = setmetatable({}, mt)
    local light = LC.setupLight(self, LIGHT_DIRECTIONAL, color, intensity)
    -- 默认阴影级联（castShadow 开启后阴影才覆盖场景；split 适配中小场景，单位≈米）。
    if light.shadowCascade then light.shadowCascade = CascadeParameters(20.0, 80.0, 200.0, 0.0, 0.8) end
    LC.initTarget(self) -- three.js 默认 target（在原点）：light.target.position 可直接访问
    return self
end

return DL
