-- ============================================================================
-- urhox-libs/3D · CubeTextureLoader
-- three.js CubeTextureLoader：load({px,nx,py,ny,pz,nz}, onLoad) —— **6 张面图** → CubeTexture。
-- 6 张 Image(同步)逐面 SetData 到 UrhoX TextureCube；包成 THREE.Texture
-- (mapping=CubeReflectionMapping)，可赋 scene.background / scene.environment。
-- 单张文件 cube(.dds/.ktx2) 请用 DDSLoader；单张全景图用 TextureLoader + Equirect mapping。
-- ============================================================================

local Texture = require("urhox-libs/3D/Core/Texture")

local CTL = {}
local methods = {}
local mt = { __index = methods }

local FACES = { FACE_POSITIVE_X, FACE_NEGATIVE_X, FACE_POSITIVE_Y, FACE_NEGATIVE_Y, FACE_POSITIVE_Z, FACE_NEGATIVE_Z }

function methods:setPath(p) rawset(self, "_path", p); return self end

-- urls：6 元素数组 {px, nx, py, ny, pz, nz}
function methods:load(urls, onLoad, onProgress, onError)
    local prefix = rawget(self, "_path") or ""
    local tex = Texture.new("[cube]")
    tex.mapping = Texture.CubeReflectionMapping
    local cube = TextureCube:new()
    local ok = true
    for i = 1, 6 do
        local u = urls and urls[i]
        local img = u and cache:GetResource("Image", prefix .. u) or nil
        if img and cube.SetData then cube:SetData(FACES[i], img) else ok = false end
    end
    tex:_setNative(cube)
    if ok then
        if onLoad then onLoad(tex) end
    elseif onError then
        onError("CubeTextureLoader: 部分面加载失败")
    end
    return tex
end

function CTL.new() return setmetatable({}, mt) end

return CTL
