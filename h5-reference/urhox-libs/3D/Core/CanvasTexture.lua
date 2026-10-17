-- ============================================================================
-- urhox-libs/3D · CanvasTexture
-- three.js CanvasTexture(canvas)：用 canvas 的内容做贴图。
-- 这里 canvas 的内容由 NanoVG 渲染到一张 render-target Texture2D（见 Canvas.lua），
-- CanvasTexture 把该 RT 包成 THREE.Texture（getNative/onReady/采样态），可直接喂材质 map
-- 或 SpotLight.map。canvas 每帧 replay display list → RT 自动更新（needsUpdate 实质自动）。
-- ============================================================================

local Texture = require("urhox-libs/3D/Core/Texture")

local CanvasTexture = {}

function CanvasTexture.new(canvas)
    local tex = Texture.new("[canvas]")
    if canvas then
        if canvas.getContext then canvas:getContext("2d") end -- 确保 RT + NVG 已建
        local rt = canvas.getRenderTarget and canvas:getRenderTarget() or nil
        if rt then tex:_setNative(rt) end
        rawset(tex, "_canvas", canvas)
    end
    return tex
end

return CanvasTexture
