-- ============================================================================
-- urhox-libs/3D · Postprocessing（three/addons/postprocessing 复刻）
-- 支持 EffectComposer + 常用 passes 的**完整调用路径**：构造/addPass/insertPass/removePass/
-- render/setSize 都不报错；各 pass 的"意图"翻译到引擎唯一环境 Zone 的后效（Core/Environment）。
-- composer:render() 空操作 —— 引擎已通过 Zone 后效渲染（不存在可自定义 RenderPath）。
--
-- 映射：UnrealBloomPass→Zone bloom；OutputPass→tonemap；SSAOPass/GTAOPass→引擎 SSAO 常开(no-op)；
--   SMAAPass / ShaderPass(FXAAShader)→Zone FXAA；BokehPass→DOF(暂 no-op)；RenderPass/泛 ShaderPass→no-op。
-- pass 属性运行时可改（strength/threshold... 改完即重映射，只要它已 addPass）。
-- ============================================================================

local Environment = require("urhox-libs/3D/Core/Environment")

local M = {}

-- pass 工厂：props 走 _p 代理（保证 __newindex 始终拦截以重映射）；applyFn 据 active+enabled 写 Environment
local function definePass(applyFn)
    local methods = {}
    methods.setSize = function() end
    methods.dispose = function() end
    methods._activate = function(self) rawset(self, "_active", true); applyFn(self) end
    methods._deactivate = function(self) rawset(self, "_active", false); applyFn(self) end
    local mt = {
        __index = function(self, k)
            local p = rawget(self, "_p")
            local v = p[k]
            if v ~= nil then return v end
            return methods[k]
        end,
        __newindex = function(self, k, v)
            rawget(self, "_p")[k] = v
            if rawget(self, "_active") then applyFn(self) end
        end,
    }
    return function(props)
        local self = setmetatable({}, mt)
        rawset(self, "_p", props or {})
        rawset(self, "_active", false)
        return self
    end
end

local function on(self) return rawget(self, "_active") and self.enabled ~= false end

--------------------------------------------------------------------------------
-- Passes
--------------------------------------------------------------------------------

-- RenderPass(scene, camera)：引擎已渲染场景 → no-op
local newRender = definePass(function() end)
function M.RenderPass(scene, camera)
    return newRender({ scene = scene, camera = camera, enabled = true, isRenderPass = true })
end

-- UnrealBloomPass(resolution, strength=1, radius, threshold) → Zone bloom
local newBloom = definePass(function(self)
    Environment.setPost("bloom", on(self))
    if on(self) then
        Environment.setPost("bloomIntensity", self.strength or 1)
        Environment.setPost("bloomThreshold", self.threshold or 0)
        Environment.setPost("bloomWeight", self.radius or 0.2)
    end
end)
function M.UnrealBloomPass(resolution, strength, radius, threshold)
    return newBloom({ resolution = resolution, strength = strength or 1, radius = radius or 0,
        threshold = threshold or 0, enabled = true, isUnrealBloomPass = true })
end

-- OutputPass()：tone mapping + 颜色空间转换 → Zone tonemap
local newOutput = definePass(function(self) Environment.setPost("tonemap", on(self)) end)
function M.OutputPass() return newOutput({ enabled = true, isOutputPass = true }) end

-- SSAOPass / GTAOPass：引擎 SSAO(CEMapSSAO) 默认常开 → no-op（不报错即可）
local newAO = definePass(function() end)
function M.SSAOPass(scene, camera, w, h)
    return newAO({ scene = scene, camera = camera, width = w, height = h, enabled = true,
        kernelRadius = 8, minDistance = 0.005, maxDistance = 0.1, output = 0, isSSAOPass = true })
end
M.GTAOPass = function(scene, camera, w, h)
    local p = M.SSAOPass(scene, camera, w, h); p.isGTAOPass = true; return p
end

-- SMAAPass(w,h) → Zone FXAA（近似的边缘抗锯齿）
local newSMAA = definePass(function(self) Environment.setPost("fxaa", on(self)) end)
function M.SMAAPass(w, h) return newSMAA({ width = w, height = h, enabled = true, isSMAAPass = true }) end

-- BokehPass(scene,camera,params)：DOF —— 引擎有 DOF 但 Zone 未暴露开关 → 暂 no-op（不报错）
local newBokeh = definePass(function() end)
function M.BokehPass(scene, camera, params)
    params = params or {}
    return newBokeh({ scene = scene, camera = camera, enabled = true,
        uniforms = { focus = { value = params.focus or 1 }, aperture = { value = params.aperture or 0.025 }, maxblur = { value = params.maxblur or 0.01 } },
        isBokehPass = true })
end

-- FXAA shader 标记（ShaderPass(FXAAShader) → Zone FXAA）
M.FXAAShader = { _isFXAAShader = true, uniforms = { resolution = { value = nil } } }

-- ShaderPass(shader, textureID)：泛自定义着色 pass。识别 FXAAShader → Zone FXAA；其余 no-op（不报错）。
local newShader = definePass(function(self)
    if self.shader and self.shader._isFXAAShader then Environment.setPost("fxaa", on(self)) end
end)
function M.ShaderPass(shader, textureID)
    return newShader({ shader = shader, textureID = textureID, enabled = true,
        uniforms = (shader and shader.uniforms) or {}, isShaderPass = true })
end

-- FilmPass / GlitchPass 等少见 → no-op 占位（构造不报错）
local newNoop = definePass(function() end)
function M.FilmPass(...) return newNoop({ enabled = true }) end
function M.GlitchPass(...) return newNoop({ enabled = true }) end

--------------------------------------------------------------------------------
-- EffectComposer(renderer, renderTarget?)
--------------------------------------------------------------------------------
local ecMethods = {}
local ecMt = {
    __index = function(self, k)
        local v = rawget(self, "_f")[k]
        if v ~= nil then return v end
        return ecMethods[k]
    end,
    __newindex = function(self, k, v) rawget(self, "_f")[k] = v end,
}

function ecMethods:addPass(pass)
    table.insert(rawget(self, "passes"), pass)
    if pass and pass._activate then pass:_activate() end
    return self
end
function ecMethods:insertPass(pass, index)
    table.insert(rawget(self, "passes"), (index or 0) + 1, pass)
    if pass and pass._activate then pass:_activate() end
end
function ecMethods:removePass(pass)
    local passes = rawget(self, "passes")
    for i = #passes, 1, -1 do
        if passes[i] == pass then
            table.remove(passes, i)
            if pass._deactivate then pass:_deactivate() end
            break
        end
    end
end
function ecMethods:render(_deltaTime) end -- 引擎已通过 Zone 后效渲染
function ecMethods:setSize(_w, _h) end
function ecMethods:setPixelRatio(_p) end
function ecMethods:reset() end
function ecMethods:dispose() end

function M.EffectComposer(renderer, renderTarget)
    local self = setmetatable({}, ecMt)
    rawset(self, "passes", {})
    rawset(self, "_f", { renderer = renderer, renderTarget = renderTarget, renderToScreen = true })
    return self
end

--------------------------------------------------------------------------------
-- 新后处理路径（three r160+，非弃用）：RenderPipeline + TSL 节点
-- pass(scene,camera) / bloom(node,strength,radius,threshold) / node:add(...) 构 outputNode，
-- RenderPipeline(renderer, outputNode).render()。节点携带效果描述（_effects），应用到 Zone。
-- TSL 是庞大的着色器图 DSL；这里只实现"收集效果 + passthrough 链式"，让调用路径不崩 + 常用效果落地。
--------------------------------------------------------------------------------

local nodeMethods = {}
local function mergeEffects(a, b)
    local e = {}
    for _, x in ipairs(a or {}) do e[#e + 1] = x end
    for _, x in ipairs(b or {}) do e[#e + 1] = x end
    return e
end
local function effectsOf(v) return (type(v) == "table" and v._effects) or {} end

local nodeMt
local function newNode(effects)
    return setmetatable({ _effects = effects or {} }, nodeMt)
end
nodeMt = {
    __index = function(self, k)
        local m = nodeMethods[k]
        if m ~= nil then return m end
        if k == "_effects" then return rawget(self, "_effects") end
        -- 未知 TSL 链式方法（toneMapping/mul/mix/saturate/renderOutput/...）→ passthrough，返回自身节点
        return function(_, ...) return self end
    end,
}
-- 组合类：合并两侧效果
function nodeMethods:add(o) return newNode(mergeEffects(self._effects, effectsOf(o))) end
nodeMethods.mul = function(self, o) return newNode(mergeEffects(self._effects, effectsOf(o))) end
nodeMethods.mix = nodeMethods.add
nodeMethods.screen = nodeMethods.add
function nodeMethods:getTextureNode() return self end
function nodeMethods:getTexture() return self end

M.tsl = {}
function M.tsl.pass(scene, camera) return newNode({}) end
function M.tsl.bloom(input, strength, radius, threshold)
    local n = newNode(effectsOf(input))
    n._effects[#n._effects + 1] = { kind = "bloom", strength = strength or 0.8, radius = radius or 0, threshold = threshold or 0 }
    return n
end
function M.tsl.ao(input) local n = newNode(effectsOf(input)); n._effects[#n._effects + 1] = { kind = "ao" }; return n end
M.tsl.gtao = M.tsl.ao
function M.tsl.fxaa(input) local n = newNode(effectsOf(input)); n._effects[#n._effects + 1] = { kind = "fxaa" }; return n end
M.tsl.smaa = M.tsl.fxaa
function M.tsl.output(input) return newNode(effectsOf(input)) end
function M.tsl.mrt(_) return newNode({}) end
-- 其它常见 TSL 入口（emissive/texture/uniform/vec3...）→ 空节点 passthrough
setmetatable(M.tsl, { __index = function() return function(...) return newNode({}) end end })

-- 把 outputNode 收集到的效果应用到唯一环境 Zone
local function applyPipeline(self)
    local node = rawget(self, "_f").outputNode
    local effects = effectsOf(node)
    -- 先全关，再按 effects 开（幂等）
    local hasBloom, hasFxaa = false, false
    for _, e in ipairs(effects) do
        if e.kind == "bloom" then
            hasBloom = true
            Environment.setPost("bloomIntensity", e.strength or 0.8)
            Environment.setPost("bloomThreshold", e.threshold or 0)
            Environment.setPost("bloomWeight", e.radius or 0.2)
        elseif e.kind == "fxaa" then
            hasFxaa = true
        end
        -- ao：引擎 SSAO 常开，no-op
    end
    Environment.setPost("bloom", hasBloom)
    Environment.setPost("fxaa", hasFxaa)
end

local rpMethods = {}
local rpMt = {
    __index = function(self, k)
        local v = rawget(self, "_f")[k]
        if v ~= nil then return v end
        return rpMethods[k]
    end,
    __newindex = function(self, k, v)
        rawget(self, "_f")[k] = v
        if k == "outputNode" then applyPipeline(self) end
    end,
}
function rpMethods:render() applyPipeline(self) end -- 引擎已渲染；这里同步效果
rpMethods.renderAsync = rpMethods.render
function rpMethods:dispose() end
function rpMethods:setSize(_w, _h) end

function M.RenderPipeline(renderer, outputNode)
    local self = setmetatable({}, rpMt)
    rawset(self, "_f", { renderer = renderer, outputNode = outputNode, outputColorTransform = true, needsUpdate = true })
    if outputNode then applyPipeline(self) end
    return self
end
M.PostProcessing = M.RenderPipeline -- 弃用别名（兼容）

return M
