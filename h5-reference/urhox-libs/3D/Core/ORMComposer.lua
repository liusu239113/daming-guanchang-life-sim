-- ============================================================================
-- urhox-libs/3D · ORMComposer（内部）
-- three.js 的 aoMap/roughnessMap/metalnessMap 是三个独立采样器（各读 .r/.g/.b），
-- 而 UrhoX PBR 只有一个 sSpecMap，通道布局 R=粗糙 G=金属 B=AO。
-- 这里把 three.js 的（最多）三张源图在 CPU 合成成一张 UrhoX 序的 ORM：
--   R = roughnessMap.g  (缺 → 1.0)
--   G = metalnessMap.b  (缺 → 1.0)
--   B = aoMap.r         (缺 → 1.0，即无遮蔽)
-- 标量永远走 TextureRoughnessFactor/TextureMetallicFactor（动态可改），不烤进贴图。
--
-- v1：源图同步加载 + 逐像素合成（局部一次性开销，非每帧）。
-- 后续优化方向：异步源图 + 后台合成、SetData 走原始字节、大图降采样上限。
-- ============================================================================

local M = {}

-- 取 THREE.Texture 的 url 同步加载为 Image（v1）
local function loadImage(threeTex)
    if not threeTex or not threeTex.url then return nil end
    return cache:GetResource("Image", threeTex.url)
end

-- 合成 ORM；三张源图都缺则返回 nil（调用方走纯标量路径）
-- @return Texture2D|nil
function M.build(roughnessMap, metalnessMap, aoMap)
    local rImg = loadImage(roughnessMap)
    local mImg = loadImage(metalnessMap)
    local aImg = loadImage(aoMap)
    if not (rImg or mImg or aImg) then return nil end

    -- 目标尺寸：取存在源图的最大边（不同尺寸用双线性重采样对齐）
    local w, h = 1, 1
    for _, img in ipairs({ rImg, mImg, aImg }) do
        if img then
            w = math.max(w, img:GetWidth())
            h = math.max(h, img:GetHeight())
        end
    end

    local out = Image()
    out:SetSize(w, h, 4)
    for y = 0, h - 1 do
        local v = (h > 1) and (y / (h - 1)) or 0
        for x = 0, w - 1 do
            local u = (w > 1) and (x / (w - 1)) or 0
            local r = rImg and rImg:GetPixelBilinear(u, v).g or 1.0
            local g = mImg and mImg:GetPixelBilinear(u, v).b or 1.0
            local b = aImg and aImg:GetPixelBilinear(u, v).r or 1.0
            out:SetPixel(x, y, Color(r, g, b, 1.0))
        end
    end

    local tex = Texture2D:new()
    tex:SetData(out) -- 线性数据，不设 sRGB
    return tex
end

return M
