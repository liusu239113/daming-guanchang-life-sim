-- ============================================================================
-- urhox-libs/3D · DDSLoader
-- three.js DDSLoader：加载单张 DDS（可含 cubemap）→ 单文件 cube/2D 贴图。
-- UrhoX 原生支持直接加载单张 cube DDS，故走 AsyncLoader（type "TextureCube"），
-- 与 TextureLoader 同模式（占位热替换）。默认按 cube 处理（mapping=CubeReflectionMapping，
-- 天空盒/环境最常见）；2D DDS 请用 TextureLoader。
-- ============================================================================

local Texture = require("urhox-libs/3D/Core/Texture")
local AsyncLoader = require("urhox-libs/3D/Core/AsyncLoader")

local DDS = {}
local methods = {}
local mt = { __index = methods }

function methods:setPath(p) rawset(self, "_path", p); return self end

function methods:load(url, onLoad, onProgress, onError)
    local prefix = rawget(self, "_path") or ""
    local tex = Texture.new(url)
    tex.mapping = Texture.CubeReflectionMapping
    -- 单张 cube DDS：异步加载占位 + 真内容热替换（指针稳定）
    local res = AsyncLoader.load("TextureCube", prefix .. url,
        function() if onLoad then onLoad(tex) end end,
        function(name) if onError then onError(name) end end)
    if res then tex:_setNative(res) end
    return tex
end

function DDS.new() return setmetatable({}, mt) end

return DDS
