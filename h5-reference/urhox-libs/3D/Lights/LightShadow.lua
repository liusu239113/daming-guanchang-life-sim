-- ============================================================================
-- urhox-libs/3D · LightShadow（内部）
-- 复刻 three.js light.shadow：mapSize / bias / normalBias / radius / camera。
-- 映射 UrhoX Light：SetShadowResolution(mapSize) + SetShadowBias(BiasParameters)。
-- camera.{near,far,left,right,top,bottom} 存值（UrhoX 平行光阴影自动级联拟合、聚光用锥，
-- 不逐项精确对应）；对聚光把 camera.far 同步到 light.range 作 best-effort。
-- ============================================================================

local LightShadow = {}
local methods = {}

-- bias 映射：three.js 的 bias(NDC 深度小常量，默认 0、常为负) 与 normalBias(世界法向偏移)
-- 是为其自身深度管线调的，量纲/符号与 UrhoX 不通用，直接透传会自阴影 acne（面向光的细
-- 几何如房梁发黑）。UrhoX BiasParameters(constantBias, slopeScaledBias, normalOffset)：
--   · constantBias 为正小值（引擎默认 0.0002，复杂场景常用 ~0.001）；负值会加剧 acne。
--   · slopeScaledBias 抗斜面自阴影。
--   · normalOffset 是阴影相机 orthoSize 的“纹素比例倍数”（Batch.cpp 用 orthoSize×normalOffset
--     缩放），有效区间约 1~3，而非世界单位。
-- 故取 UrhoX 经验基线保证不 acne，并把 three.js 的 normalBias 放大到纹素量级；three.js bias
-- 仅当为正时作微调叠加（负值忽略——UrhoX 不用负 constantBias）。
local function applyBias(self)
    local l = rawget(self, "_light")
    if not (l and l.SetShadowBias) then return end
    local p = self._props
    local constantBias = 0.0008
    if p.bias and p.bias > 0 then constantBias = constantBias + p.bias end
    local slope = 2.0
    local normalOffset = 0.0
    if p.normalBias and p.normalBias > 0 then normalOffset = math.max(1.0, p.normalBias * 50.0) end
    l:SetShadowBias(BiasParameters(constantBias, slope, normalOffset))
end

-- mapSize：带 :set(w,h) 的小对象，变更即推 SetShadowResolution
local function makeMapSize(light)
    local ms = { x = 1024, y = 1024 }
    local function push(self) if light.SetShadowResolution then light:SetShadowResolution(math.max(self.x, self.y)) end end
    ms.set = function(self, w, h) self.x = w; self.y = h or w; push(self); return self end
    return ms
end

-- shadow.camera：存 near/far/left/right/top/bottom + updateProjectionMatrix no-op
local function makeShadowCamera(light)
    local cam = { near = 0.5, far = 500, left = -5, right = 5, top = 5, bottom = -5, fov = 50, zoom = 1 }
    cam.updateProjectionMatrix = function(self)
        -- 聚光：far → range（best-effort）；平行光：UrhoX 自动级联，忽略 bounds
        if light.lightType == LIGHT_SPOT and self.far then light.range = self.far end
        return self
    end
    return cam
end

local mt = {
    __index = function(self, k)
        if k == "mapSize" then return rawget(self, "_mapSize") end
        if k == "camera" then return rawget(self, "_camera") end
        return methods[k] or rawget(self, "_props")[k]
    end,
    __newindex = function(self, k, v)
        if k == "mapSize" or k == "camera" then rawset(self, "_" .. k, v); return end
        rawget(self, "_props")[k] = v
        if k == "bias" or k == "normalBias" then applyBias(self) end
    end,
}

function LightShadow.new(light)
    local self = setmetatable({}, mt)
    rawset(self, "_light", light)
    rawset(self, "_props", { bias = 0.0, normalBias = 0.0, radius = 1.0 })
    rawset(self, "_mapSize", makeMapSize(light))
    rawset(self, "_camera", makeShadowCamera(light))
    return self
end

return LightShadow
