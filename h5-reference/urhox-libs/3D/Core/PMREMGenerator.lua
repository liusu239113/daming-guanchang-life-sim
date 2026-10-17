-- ============================================================================
-- urhox-libs/3D · PMREMGenerator
-- three.js PMREMGenerator：把环境源(equirect/cube/scene)预卷积成可直接用的 IBL 贴图。
-- 这里底层接引擎 EnvironmentBakeCache：fromEquirectangular/fromCubemap 触发 RequestBake，
-- 返回一个"已烘焙 env"句柄（native=源纹理=cache key，mapping=CubeUVReflectionMapping，标记
-- _isBakedEnv）。scene.environment 收到它 → Zone:SetSourceTextureFromBakeCache(源) 取缓存结果。
-- fromScene（从场景烘焙）需 scene→cube 渲染，暂不支持（warn，返回占位）。
-- ============================================================================

local Texture = require("urhox-libs/3D/Core/Texture")

local PMREM = {}
local methods = {}
local mt = { __index = methods }

local function bakedEnvHandle(srcNative)
    local env = Texture.new("[pmrem]")
    env.mapping = Texture.CubeUVReflectionMapping
    rawset(env, "_isBakedEnv", true)
    if srcNative then env:_setNative(srcNative) end -- native = 源指针（EnvironmentBakeCache 的 key）
    return { texture = env }
end

local function bakeFromTexture(threeTex)
    local src = threeTex and threeTex.getNative and threeTex:getNative() or threeTex
    if type(src) == "userdata" then
        local bc = environmentBakeCache -- 引擎子系统全局（GetEnvironmentBakeCache）
        if bc and bc.RequestBake then bc:RequestBake(src) end -- 触发烘焙，结果入缓存
    else
        src = nil
    end
    return bakedEnvHandle(src)
end

function methods:fromEquirectangular(tex) return bakeFromTexture(tex) end
function methods:fromCubemap(tex) return bakeFromTexture(tex) end

-- RoomEnvironment 源环境资产：从 three.js RoomEnvironment 用 CubeCamera 渲染→equirect 导出
-- （提取页 extract-roomenv.html，在 three.js 工程内运行），放到下面路径。
-- runtime 走 EnvironmentBakeCache 烘焙，源环境与 three.js 一致。
local ROOM_ENV_ASSET = "urhox-libs/3D/assets/RoomEnvironment.png"

function methods:fromScene(scene, sigma, near, far)
    -- 当前支持 three.js RoomEnvironment：加载预导出的 equirect 源环境 → 真实烘焙
    if type(scene) == "table" and scene._isRoomEnvironment then
        local native = cache:GetResource("Texture2D", ROOM_ENV_ASSET)
        if native then
            -- 资产导出为**线性**数据（EnvironmentBakeCache 的 spec 预滤波不做 sRGB 解码、假定线性源），
            -- 故不可标 sRGB，按线性直接烘焙即正确。
            return bakeFromTexture(native) -- 复用 equirect 烘焙路径（EnvironmentBakeCache）
        end
        log:Write(LOG_WARNING,
            "RoomEnvironment 源资产缺失（" .. ROOM_ENV_ASSET .. "）；该环境暂无 IBL。"
            .. "用 extract-roomenv.html 从 three.js 导出 equirect 放到该路径即可生效")
        return bakedEnvHandle(nil)
    end
    -- 其它任意场景烘焙需 scene→cube 实时渲染，暂不支持
    log:Write(LOG_WARNING, "PMREMGenerator.fromScene 目前仅支持 RoomEnvironment；自定义场景烘焙暂不支持，将无 IBL")
    return bakedEnvHandle(nil)
end

methods.compileEquirectangularShader = function() end
methods.compileCubemapShader = function() end
methods.dispose = function() end

function PMREM.new(renderer)
    return setmetatable({ renderer = renderer }, mt)
end

return PMREM
