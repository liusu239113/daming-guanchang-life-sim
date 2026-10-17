-- ============================================================================
-- urhox-libs/3D · Scene
-- three.js Scene。包装 UrhoX Scene 节点 + 自动 Octree（drawable 必需）。
-- 维护**唯一环境 Zone**（Core/Environment）：scene.environment / HemisphereLight /
-- AmbientLight / 后效 都写它；默认无 ambient 贡献 → 全黑环境（精确复刻 three.js）。
--   scene.environment / environmentIntensity → Zone IBL
--   scene.background → 背景色（clear）/ skybox（best-effort）
--   scene.fog（THREE.Fog/FogExp2）→ Zone fog
-- ============================================================================

local NativeScene = Scene  -- 引擎原生 Scene 构造器，在遮蔽前捕获
local NativeColor = Color
local Object3D = require("urhox-libs/3D/Core/Object3D")
local Environment = require("urhox-libs/3D/Core/Environment")
local Convert = require("urhox-libs/3D/Core/Convert")

local SceneMod = {}
local methods = {}

-- 纯色背景：THREE.Color(已 linear) / hex / "#rrggbb" → {r,g,b}(linear)。纹理(有 getNative/mapping)返回 nil
local function colorRGBOf(v)
    if type(v) == "number" or type(v) == "string" then
        local c = Convert.color(v); return { c.r, c.g, c.b }
    end
    if type(v) == "table" and v.r and v.g and v.b and not (v.getNative or v.mapping) then
        return { v.r, v.g, v.b }
    end
    return nil
end

-- 仅接受真 native 纹理(userdata)；PMREM/占位的空表 → nil（无 IBL，优雅降级，不 tolua 报错）
local function nativeTexOf(v)
    if type(v) == "userdata" then return v end
    if type(v) == "table" and v.getNative then
        local n = v:getNative()
        if type(n) == "userdata" then return n end
    end
    return nil
end

-- 取 cubemap 背景的 native cube（mapping=Cube/CubeUV）
local function nativeCubeOf(v)
    if type(v) == "table" and (v.mapping == 301 or v.mapping == 306) then
        return nativeTexOf(v)
    end
    return nil
end

-- scene.background → 纯色（Zone clear/fogColor）/ cubemap（Skybox 组件）。equirect 暂 warn。
local function applyBackground(self, v)
    local sceneNode = rawget(self, "_node")
    local skyNode = rawget(self, "_skyboxNode")
    if v == nil then
        if skyNode then skyNode:SetEnabled(false) end
        Environment.setBackgroundColor(nil) -- 恢复默认背景
        return
    end
    -- 纯色背景：关掉天空盒，设 Zone 背景色（clear color = fogColor，不雾化几何）
    local col = colorRGBOf(v)
    if col then
        if skyNode then skyNode:SetEnabled(false) end
        Environment.setBackgroundColor(col)
        return
    end
    local cube = nativeCubeOf(v)
    if cube then
        Environment.setBackgroundColor(nil) -- 用天空盒，清掉纯色背景
        if not skyNode then
            skyNode = sceneNode:CreateChild("__skybox")
            rawset(self, "_skyboxNode", skyNode)
            local sb = skyNode:CreateComponent("Skybox")
            sb:SetModel(cache:GetResource("Model", "Models/Box.mdl"))
            rawset(self, "_skybox", sb)
        end
        skyNode:SetEnabled(true)
        local mat = Material:new()
        mat:SetTechnique(0, cache:GetResource("Technique", "Techniques/DiffSkybox.xml"))
        mat:SetTexture(TU_DIFFUSE, cube)
        rawget(self, "_skybox"):SetMaterial(mat)
        rawset(self, "_skyMat", mat) -- 持引用防 GC
    else
        log:Write(LOG_WARNING,
            "scene.background：仅支持 cubemap 纹理(CubeTextureLoader/DDSLoader)；纯色/equirect 背景暂未支持")
    end
end

-- 需引擎 Zone/IBL 能力、暂以 expose-but-warn 存值的属性（见 technical-debt.md）
local DEFERRED = {
    backgroundIntensity = true, backgroundBlurriness = true, backgroundRotation = true,
    environmentRotation = true, overrideMaterial = true,
}
local warnedDeferred = {}

local function sget(self, k)
    if k == "isScene" then return true end
    if k == "environment" then return rawget(self, "_environment") end
    if k == "environmentIntensity" then return rawget(self, "_envIntensity") end
    if k == "background" then return rawget(self, "_background") end
    if k == "fog" then return rawget(self, "_fog") end
    if DEFERRED[k] then return rawget(self, "_" .. k) end
    return nil
end

local function sset(self, k, v)
    if k == "environment" then
        rawset(self, "_environment", v)
        -- PMREM 产物(mapping=CubeUVReflectionMapping=306 或 _isBakedEnv) → 走 bake cache 取结果；
        -- 原始 equirect/cube → SetSourceTexture 触发烘焙
        local fromBake = type(v) == "table" and (v.mapping == 306 or rawget(v, "_isBakedEnv") == true)
        Environment.setIBL(v and nativeTexOf(v) or nil, rawget(self, "_envIntensity") or 1.0, fromBake)
        return true
    end
    if k == "environmentIntensity" then
        rawset(self, "_envIntensity", v); Environment.setIBLIntensity(v); return true
    end
    if k == "background" then
        rawset(self, "_background", v)
        applyBackground(self, v)
        return true
    end
    if k == "fog" then
        rawset(self, "_fog", v)
        if v then
            local c = v.color
            Environment.setFog({
                color = c and { c.r, c.g, c.b } or { 1, 1, 1 },
                near = v.near, far = v.far, density = v.density, exp = v.isFogExp2 == true,
            })
        else
            Environment.setFog(nil)
        end
        return true
    end
    if DEFERRED[k] then
        rawset(self, "_" .. k, v) -- 存值，暂无实效（需引擎 Zone/IBL 旋转/模糊/场景级覆盖）
        if not warnedDeferred[k] then
            warnedDeferred[k] = true
            log:Write(LOG_WARNING, "Scene." .. k .. "：需引擎 Zone/IBL 能力，暂存值不生效（见 docs/guides/technical-debt.md）")
        end
        return true
    end
    return false
end

local mt = Object3D.makeMeta(methods, sget, sset)

function SceneMod.new()
    local self = setmetatable({}, mt)
    local sc = NativeScene()
    sc:CreateComponent("Octree") -- drawable 必需
    Object3D.setup(self, sc)
    rawset(self, "_envIntensity", 1.0)

    -- 唯一环境 Zone（大包围盒，默认黑 ambient = three.js 无环境光）
    local zone = sc:CreateComponent("Zone")
    zone.boundingBox = BoundingBox(Vector3(-100000, -100000, -100000), Vector3(100000, 100000, 100000))
    zone.ambientSource = AMBIENT_COLOR
    zone.ambientColor = NativeColor(0, 0, 0, 1.0)
    zone.ambientIntensity = 1.0 -- 引擎默认 0.3 会缩放 IBL/SH；显式置 1 对标 three.js（IBL 时由 environmentIntensity 覆盖）
    rawset(self, "_zone", zone)
    Environment.setZone(zone)
    return self
end

return SceneMod
