-- ============================================================================
-- urhox-libs/3D · AmbientLight
-- three.js AmbientLight(color, intensity)：均匀环境光。
-- 不再各自建 Zone —— 向 Core/Environment 注册 ambient 贡献(color*intensity)，由唯一环境
-- Zone 累加。多个 AmbientLight 叠加（与 three.js 一致）；全部移除 → 环境归黑。
-- 运行时 color/intensity 可改。
-- ============================================================================

local Object3D = require("urhox-libs/3D/Core/Object3D")
local Color = require("urhox-libs/3D/Core/Color")
local Environment = require("urhox-libs/3D/Core/Environment")

local AL = {}

local function isColorObj(v) return type(v) == "table" and v.clone and v.setHex end

local function applyContrib(self)
    local c = rawget(self, "_color")
    local i = rawget(self, "_intensity")
    Environment.setAmbient(self, c.r * i, c.g * i, c.b * i)
end

local function bindColor(self, v)
    local c = isColorObj(v) and v or Color.new(v == nil and 0xffffff or v)
    c._onChange = function() applyContrib(self) end
    rawset(self, "_color", c)
    return c
end

local function aget(self, k)
    if k == "isAmbientLight" or k == "isLight" then return true end
    if k == "type" then return "AmbientLight" end
    if k == "color" then return rawget(self, "_color") end
    if k == "intensity" then return rawget(self, "_intensity") end
    if k == "dispose" then return AL.dispose end
    return nil
end

-- three.js dispose：撤销本灯对环境 ambient 的贡献；幂等。
function AL.dispose(self)
    if rawget(self, "_disposed") then return self end
    rawset(self, "_disposed", true)
    Environment.clearAmbient(self)
    return self
end
local function aset(self, k, v)
    if k == "color" then bindColor(self, v); applyContrib(self); return true end
    if k == "intensity" then rawset(self, "_intensity", v); applyContrib(self); return true end
    return false
end

local mt = Object3D.makeMeta({}, aget, aset)

function AL.new(color, intensity)
    local self = setmetatable({}, mt)
    Object3D.setup(self)
    rawset(self, "_intensity", intensity or 1.0)
    bindColor(self, color)
    applyContrib(self)
    return self
end

return AL
