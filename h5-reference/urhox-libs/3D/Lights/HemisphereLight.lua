-- ============================================================================
-- urhox-libs/3D · HemisphereLight
-- three.js HemisphereLight(skyColor, groundColor, intensity)：天/地双色渐变环境光。
-- UrhoX 无半球渐变 → 近似 flat = (sky+ground)/2 * intensity，向 Core/Environment 注册 ambient
-- 贡献（与 AmbientLight 共用唯一环境 Zone，叠加）。runtime：color(=sky)/groundColor/intensity。
-- ============================================================================

local Object3D = require("urhox-libs/3D/Core/Object3D")
local Color = require("urhox-libs/3D/Core/Color")
local Environment = require("urhox-libs/3D/Core/Environment")

local HL = {}

local function isColorObj(v) return type(v) == "table" and v.clone and v.setHex end

local function applyContrib(self)
    local sky = rawget(self, "_skyColor")
    local gnd = rawget(self, "_groundColor")
    local i = rawget(self, "_intensity")
    Environment.setAmbient(self,
        (sky.r + gnd.r) * 0.5 * i,
        (sky.g + gnd.g) * 0.5 * i,
        (sky.b + gnd.b) * 0.5 * i)
end

local function bindColor(self, key, v)
    local c = isColorObj(v) and v or Color.new(v == nil and 0xffffff or v)
    c._onChange = function() applyContrib(self) end
    rawset(self, key, c)
    return c
end

local function hget(self, k)
    if k == "isHemisphereLight" or k == "isLight" then return true end
    if k == "type" then return "HemisphereLight" end
    if k == "intensity" then return rawget(self, "_intensity") end
    if k == "color" then return rawget(self, "_skyColor") end
    if k == "groundColor" then return rawget(self, "_groundColor") end
    if k == "dispose" then return HL.dispose end
    return nil
end

-- three.js dispose：撤销本灯对环境 ambient 的贡献；幂等。
function HL.dispose(self)
    if rawget(self, "_disposed") then return self end
    rawset(self, "_disposed", true)
    Environment.clearAmbient(self)
    return self
end
local function hset(self, k, v)
    if k == "intensity" then rawset(self, "_intensity", v); applyContrib(self); return true end
    if k == "color" then bindColor(self, "_skyColor", v); applyContrib(self); return true end
    if k == "groundColor" then bindColor(self, "_groundColor", v); applyContrib(self); return true end
    return false
end

local mt = Object3D.makeMeta({}, hget, hset)

function HL.new(skyColor, groundColor, intensity)
    local self = setmetatable({}, mt)
    Object3D.setup(self)
    rawset(self, "_intensity", intensity or 1.0)
    bindColor(self, "_skyColor", skyColor)
    bindColor(self, "_groundColor", groundColor)
    applyContrib(self)
    return self
end

return HL
