-- ============================================================================
-- urhox-libs/3D · TextureLoader
-- three.js TextureLoader：load(url, onLoad, onProgress, onError) 同步返回占位 Texture，
-- 图片异步到达后填充 native 并触发 onLoad（同一对象）。走 AsyncLoader（方案 A）。
-- onProgress：UrhoX 无字节级进度，忽略。
-- ============================================================================

local Texture = require("urhox-libs/3D/Core/Texture")
local AsyncLoader = require("urhox-libs/3D/Core/AsyncLoader")

local TL = {}
local methods = {}
local mt = { __index = methods }

function TL.new()
    return setmetatable({}, mt)
end

function methods:load(url, onLoad, onProgress, onError)
    local tex = Texture.new(url)
    -- GetResourceAsyncEx 立刻返回非空占位 Texture2D（指针稳定，真内容到达原地热替换）
    local res = AsyncLoader.load("Texture2D", url,
        function() if onLoad then onLoad(tex) end end, -- 真内容到达（同一 tex 对象，three.js 语义）
        function(name) if onError then onError(name) end end)
    if res then tex:_setNative(res) end -- 占位 native 立即绑定；热替换对材质透明（同一指针）
    return tex
end

return TL
