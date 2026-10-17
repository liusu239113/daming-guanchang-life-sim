-- ============================================================================
-- urhox-libs/3D · Environment（内部，单一 Zone 中枢）
-- three.js 的环境是全局的：所有 AmbientLight/HemisphereLight 的环境光叠加 + scene.environment
-- 的 IBL + 后效（tonemap/bloom/曝光/vignette/fog），在 UrhoX 里**统一由一个 Zone 承载**。
-- Scene 创建该 Zone 并 setZone()；各方往这里写贡献，recompute() 同步到 Zone。
-- 默认无任何 ambient 贡献 → ambientColor=黑、无 IBL = 精确复刻 three.js（无环境光即全黑环境）。
-- ============================================================================

local NativeColor = Color

local Environment = {}

local zone = nil
local ambientContribs = {} -- key(对象) → {r,g,b}（已乘 intensity）
local ibl = { texture = nil, intensity = 1.0 }
local post = {
    tonemap = false, autoExposure = false,
    bloom = false, bloomThreshold = 0.8, bloomIntensity = 1.0, bloomWeight = 0.2,
    vignette = false, vignetteIntensity = 0.5,
    fxaa = false,
}
local fog = nil -- { color={r,g,b}, near, far, density, exp }
local bgColor = nil -- scene.background 纯色 {r,g,b}(linear)；引擎 clear color="fog" → 即 Zone fogColor

local function recompute()
    if not zone then return end
    -- 1) ambient：所有贡献求和（无贡献 → 黑）
    local r, g, b = 0, 0, 0
    for _, c in pairs(ambientContribs) do r = r + c[1]; g = g + c[2]; b = b + c[3] end
    if ibl.texture then
        -- scene.environment 的源纹理（equirect Texture2D 或 TextureCube），引擎经 EnvironmentBakeCache
        -- 烘焙漫反射 SH + 镜面 cubemap，AMBIENT_PREBAKED 消费。强度用整体 ambientIntensity 近似
        --（three.js 单一 envMapIntensity，无漫/镜分离；EnvTextureDiff/SpecIntensity 未绑 Lua）。
        -- 局限：单一 Zone ambientSource 互斥，IBL 激活时 flat ambient(hemisphere) 不再叠加。
        if ibl.fromBakeCache then
            -- PMREM 产物：烘焙已由 PMREMGenerator 触发，这里只取缓存结果（内部已设 AMBIENT_PREBAKED）
            if zone.SetSourceTextureFromBakeCache then zone:SetSourceTextureFromBakeCache(ibl.texture) end
        else
            -- 原始 equirect/cube 直接赋 environment：SetSourceTexture 触发烘焙
            zone.ambientSource = AMBIENT_PREBAKED
            if zone.SetSourceTexture then zone:SetSourceTexture(ibl.texture) end
        end
        zone.ambientIntensity = ibl.intensity
    else
        zone.ambientSource = AMBIENT_COLOR
        zone.ambientColor = NativeColor(r, g, b, 1.0) -- 无贡献=黑
        zone.ambientIntensity = 1.0 -- flat ambient 已含强度；置 1 防引擎默认 0.3 在其它路径泄漏
    end
    -- 2) 后效（Zone 控制）
    if zone.SetTonemapLUTEnabled then zone:SetTonemapLUTEnabled(post.tonemap) end
    if zone.SetAutoExposureEnabled then zone:SetAutoExposureEnabled(post.autoExposure) end
    if zone.SetBloomPlusEnabled then
        zone:SetBloomPlusEnabled(post.bloom)
        if post.bloom then
            if zone.SetBloomThreshold then zone:SetBloomThreshold(post.bloomThreshold) end
            if zone.SetBloomWeight then zone:SetBloomWeight(post.bloomWeight) end
            if zone.SetBloomPlusIntensity then zone:SetBloomPlusIntensity(post.bloomIntensity) end
        end
    end
    if zone.SetFXAAEnabled then zone:SetFXAAEnabled(post.fxaa) end
    if zone.SetVignetteEnabled then
        zone:SetVignetteEnabled(post.vignette)
        if post.vignette and zone.SetVignetteIntensity then zone:SetVignetteIntensity(post.vignetteIntensity) end
    end
    -- 3) fog / background
    -- 引擎基础 RenderPath 用 clear color="fog" → 背景色 = Zone fogColor。
    -- · 有 scene.fog：fogColor=雾色 + 雾起止（雾化几何，背景同雾色，符合 three.js 常见用法）
    -- · 仅 scene.background 纯色：fogColor=背景色 + 雾推到极远（不雾化几何，仅作背景 clear）
    -- 注：引擎单一 fogColor，无法同时让"背景色"与"雾色"取不同值（罕见），以雾色优先。
    if fog then
        if fog.color then zone.fogColor = NativeColor(fog.color[1], fog.color[2], fog.color[3], 1.0) end
        if fog.exp then
            -- FogExp2：引擎距离雾为线性模型，用密度近似线性起止（exp 衰减到 ~95% 处 ≈ 1.73/density），
            -- 保证可见且随密度变化；同时设 density（若引擎用到）。
            local density = math.max(fog.density or 0.00025, 1e-5)
            if zone.SetFogDensity then zone:SetFogDensity(density) end
            if zone.SetFogStart then zone:SetFogStart(0) end
            if zone.SetFogEnd then zone:SetFogEnd(1.73 / density) end
        else
            if zone.SetFogStart then zone:SetFogStart(fog.near or 1) end
            if zone.SetFogEnd then zone:SetFogEnd(fog.far or 1000) end
        end
    elseif bgColor then
        zone.fogColor = NativeColor(bgColor[1], bgColor[2], bgColor[3], 1.0)
        if zone.SetFogStart then zone:SetFogStart(100000) end -- 推远，避免雾化几何
        if zone.SetFogEnd then zone:SetFogEnd(1000000) end
    end
end

-- Scene 注册它的 Zone（替换当前活动 Zone）
function Environment.setZone(z) zone = z; recompute() end
function Environment.getZone() return zone end

-- scene.background 纯色（{r,g,b} linear，或 nil 恢复默认）
function Environment.setBackgroundColor(rgb) bgColor = rgb; recompute() end

-- ambient 贡献（key 用 light 对象本身，便于更新/移除）
function Environment.setAmbient(key, r, g, b) ambientContribs[key] = { r, g, b }; recompute() end
function Environment.clearAmbient(key) ambientContribs[key] = nil; recompute() end

-- IBL（scene.environment）。texture=native；fromBakeCache=true 表示 PMREM 产物（走 SetSourceTextureFromBakeCache）
function Environment.setIBL(texture, intensity, fromBakeCache)
    ibl.texture = texture; ibl.intensity = intensity or ibl.intensity; ibl.fromBakeCache = fromBakeCache == true
    recompute()
end
function Environment.setIBLIntensity(i) ibl.intensity = i; recompute() end

-- 后效
function Environment.setPost(k, v) post[k] = v; recompute() end
function Environment.getPost() return post end

-- fog
function Environment.setFog(f) fog = f; recompute() end

return Environment
