-- ============================================================================
-- urhox-libs/3D · Canvas（Web Canvas 2D shim，NanoVG 后端）
-- 复刻浏览器 document.createElement('canvas') + getContext('2d') 的常用子集，
-- 后端用 UrhoX NanoVG 渲染到 Texture2D（render target）。参考样例 56_NanoVG_UIComponent。
--
-- NanoVG 只能在 render pass 内绘制（nvgBeginFrame/EndFrame），故 2D context 把绘制命令
-- 记成 display list（ops），由 scoped render hook 每帧 replay。clearRect(整画布) 重置 ops
-- （支持重绘/动画）。ops 元素：function(ctx, st)，st = 每次 replay 的状态(fill/stroke/...)。
--
-- 已支持：fillRect/clearRect/strokeRect、beginPath/moveTo/lineTo/rect/arc/closePath/fill/stroke、
--   fillStyle/strokeStyle/lineWidth/globalAlpha、createLinearGradient/createRadialGradient(2 stop)、
--   font/textAlign/textBaseline/fillText、save/restore/translate/rotate/scale。
-- 限制：渐变只取首/末 stop（NanoVG 两色）；clearRect 非整画布按透明矩形近似。
-- ============================================================================

local Canvas = {}

--------------------------------------------------------------------------------
-- 颜色解析 → r,g,b,a (0-255)
--------------------------------------------------------------------------------
local NAMED = {
    black = { 0, 0, 0 }, white = { 255, 255, 255 }, red = { 255, 0, 0 }, green = { 0, 128, 0 },
    blue = { 0, 0, 255 }, yellow = { 255, 255, 0 }, gray = { 128, 128, 128 }, grey = { 128, 128, 128 },
    orange = { 255, 165, 0 }, transparent = { 0, 0, 0, 0 },
}
local function parseColor(s)
    if type(s) == "table" then return s end -- 已是 {r,g,b,a}
    s = tostring(s)
    local hex = s:match("^#(%x+)$")
    if hex then
        if #hex == 3 then
            local r, g, b = hex:sub(1, 1), hex:sub(2, 2), hex:sub(3, 3)
            return { tonumber(r .. r, 16), tonumber(g .. g, 16), tonumber(b .. b, 16), 255 }
        elseif #hex >= 6 then
            return { tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16),
                #hex >= 8 and tonumber(hex:sub(7, 8), 16) or 255 }
        end
    end
    local r, g, b, a = s:match("rgba?%(%s*([%d%.]+)%s*,%s*([%d%.]+)%s*,%s*([%d%.]+)%s*,?%s*([%d%.]*)%s*%)")
    if r then
        return { tonumber(r), tonumber(g), tonumber(b), (a ~= "" and math.floor(tonumber(a) * 255)) or 255 }
    end
    local n = NAMED[s:lower()]
    if n then return { n[1], n[2], n[3], n[4] or 255 } end
    return { 255, 255, 255, 255 }
end
local function toNvg(c) return nvgRGBA(c[1], c[2], c[3], c[4] or 255) end

--------------------------------------------------------------------------------
-- Context2D
--------------------------------------------------------------------------------
local Ctx = {}
local ctxMeta = {
    __index = function(self, k) return Ctx[k] end,
    __newindex = function(self, k, v)
        -- filter：解析 blur(Npx)。NanoVG 无通用模糊，对 rect/roundRect 的 fill 用 box gradient 羽化近似软边。
        if k == "filter" then
            local px = type(v) == "string" and tonumber(v:match("blur%(%s*([%d%.]+)")) or nil
            rawset(self, "_filterBlur", px or 0)
            rawset(self, "filter", v)
            return
        end
        -- 样式属性即时存（fill 时才套用），其余 rawset
        if k == "fillStyle" or k == "strokeStyle" or k == "lineWidth" or k == "globalAlpha"
            or k == "font" or k == "textAlign" or k == "textBaseline" then
            rawset(self, "_" .. k, v)
            local ops = rawget(self, "_ops")
            if k == "fillStyle" then ops[#ops + 1] = function(_, st) st.fill = v end end
            if k == "strokeStyle" then ops[#ops + 1] = function(_, st) st.stroke = v end end
            if k == "lineWidth" then ops[#ops + 1] = function(_, st) st.lineWidth = v end end
            if k == "globalAlpha" then ops[#ops + 1] = function(c, st) st.alpha = v; nvgGlobalAlpha(c, v) end end
            if k == "font" then ops[#ops + 1] = function(_, st) st.fontSize = tonumber(v:match("(%d+)") or 16) end end
            if k == "textAlign" then ops[#ops + 1] = function(_, st) st.textAlign = v end end
            if k == "textBaseline" then ops[#ops + 1] = function(_, st) st.textBaseline = v end end
        else
            rawset(self, k, v)
        end
    end,
}

local function newCtx(canvas)
    local self = setmetatable({}, ctxMeta)
    rawset(self, "canvas", canvas)
    rawset(self, "_ops", {})
    rawset(self, "_fillStyle", "#000")
    rawset(self, "_strokeStyle", "#000")
    rawset(self, "_lineWidth", 1)
    rawset(self, "_globalAlpha", 1)
    rawset(self, "_font", "16px sans")
    return self
end

local function push(self, fn) local o = rawget(self, "_ops"); o[#o + 1] = fn end

-- 解析 fill 规格（颜色串 / gradient 表）→ 在 replay 时设 nvg paint，返回是否用 paint
local function applyFill(c, spec)
    if type(spec) == "table" and spec._grad then
        local stops = spec.stops
        local ic = toNvg(stops[1] and stops[1].color or { 255, 255, 255 })
        local oc = toNvg(stops[#stops] and stops[#stops].color or { 255, 255, 255 })
        local paint
        if spec._grad == "linear" then
            paint = nvgLinearGradient(c, spec.x0, spec.y0, spec.x1, spec.y1, ic, oc)
        else
            paint = nvgRadialGradient(c, spec.x1, spec.y1, spec.r0, spec.r1, ic, oc)
        end
        nvgFillPaint(c, paint)
    else
        nvgFillColor(c, toNvg(parseColor(spec or "#000")))
    end
end

-- filter=blur(N) 下的软边填充：用 box gradient 从填充色羽化到透明，近似 CSS blur 的软边
-- （内框 x,y,w,h 圆角 r，羽化 blur；覆盖矩形向外扩 blur 显示落差）。
local function pushBlurredBox(self, x, y, w, h, r, spec, blur)
    push(self, function(c)
        local col = toNvg(parseColor(type(spec) == "table" and { 255, 255, 255 } or spec))
        local boxGrad = nvgBoxGradientGaussian or nvgBoxGradient
        local paint = boxGrad(c, x, y, w, h, r, blur, col, nvgRGBA(0, 0, 0, 0))
        nvgBeginPath(c)
        nvgRect(c, x - blur, y - blur, w + 2 * blur, h + 2 * blur)
        nvgFillPaint(c, paint)
        nvgFill(c)
    end)
end

function Ctx:fillRect(x, y, w, h)
    local spec = rawget(self, "_fillStyle")
    local blur = rawget(self, "_filterBlur") or 0
    if blur > 0 then
        pushBlurredBox(self, x, y, w, h, 0, spec, blur)
    else
        push(self, function(c)
            nvgBeginPath(c); nvgRect(c, x, y, w, h); applyFill(c, spec); nvgFill(c)
        end)
    end
end

function Ctx:clearRect(x, y, w, h)
    local cv = rawget(self, "canvas")
    if x <= 0 and y <= 0 and w >= cv.width and h >= cv.height then
        rawset(self, "_ops", {}) -- 整画布清除 = 重置 display list
    else
        push(self, function(c) -- 局部清除近似：填透明黑
            nvgBeginPath(c); nvgRect(c, x, y, w, h); nvgFillColor(c, nvgRGBA(0, 0, 0, 0)); nvgFill(c)
        end)
    end
end

function Ctx:strokeRect(x, y, w, h)
    local sc, lw = rawget(self, "_strokeStyle"), rawget(self, "_lineWidth")
    push(self, function(c)
        nvgBeginPath(c); nvgRect(c, x, y, w, h)
        nvgStrokeColor(c, toNvg(parseColor(sc))); nvgStrokeWidth(c, lw); nvgStroke(c)
    end)
end

function Ctx:beginPath() rawset(self, "_lastRect", nil); push(self, function(c) nvgBeginPath(c) end) end
function Ctx:closePath() push(self, function(c) nvgClosePath(c) end) end
function Ctx:moveTo(x, y) push(self, function(c) nvgMoveTo(c, x, y) end) end
function Ctx:lineTo(x, y) push(self, function(c) nvgLineTo(c, x, y) end) end
function Ctx:rect(x, y, w, h)
    rawset(self, "_lastRect", { x = x, y = y, w = w, h = h, r = 0 })
    push(self, function(c) nvgRect(c, x, y, w, h) end)
end

-- Canvas2D roundRect(x,y,w,h,radii)：radii 支持数字或数组（取首值近似四角等径）
function Ctx:roundRect(x, y, w, h, radii)
    local r = radii
    if type(r) == "table" then r = r[1] or 0 end
    r = r or 0
    rawset(self, "_lastRect", { x = x, y = y, w = w, h = h, r = r })
    push(self, function(c) nvgRoundedRect(c, x, y, w, h, r) end)
end
function Ctx:arc(cx, cy, r, a0, a1, ccw)
    push(self, function(c) nvgArc(c, cx, cy, r, a0, a1, ccw and 1 or 2) end) -- NVG_CCW=1 NVG_CW=2
end

function Ctx:fill()
    local spec = rawget(self, "_fillStyle")
    local blur = rawget(self, "_filterBlur") or 0
    local lr = rawget(self, "_lastRect")
    if blur > 0 and lr then
        -- 软边：当前路径是 rect/roundRect → 用羽化 box gradient 替代硬填充
        pushBlurredBox(self, lr.x, lr.y, lr.w, lr.h, lr.r or 0, spec, blur)
    else
        push(self, function(c) applyFill(c, spec); nvgFill(c) end)
    end
end

function Ctx:stroke()
    local sc, lw = rawget(self, "_strokeStyle"), rawget(self, "_lineWidth")
    push(self, function(c) nvgStrokeColor(c, toNvg(parseColor(sc))); nvgStrokeWidth(c, lw); nvgStroke(c) end)
end

function Ctx:save() push(self, function(c) nvgSave(c) end) end
function Ctx:restore() push(self, function(c) nvgRestore(c) end) end
function Ctx:translate(x, y) push(self, function(c) nvgTranslate(c, x, y) end) end
function Ctx:rotate(a) push(self, function(c) nvgRotate(c, a) end) end
function Ctx:scale(x, y) push(self, function(c) nvgScale(c, x, y) end) end

function Ctx:fillText(text, x, y)
    local spec = rawget(self, "_fillStyle")
    local size = tonumber((rawget(self, "_font") or "16px"):match("(%d+)") or 16)
    local align = rawget(self, "_textAlign")
    local baseline = rawget(self, "_textBaseline")
    push(self, function(c, st)
        local fid = rawget(rawget(self, "canvas"), "_fontId")
        if fid and fid ~= -1 then nvgFontFaceId(c, fid) end
        nvgFontSize(c, size)
        local a = 0 -- NVG_ALIGN_LEFT
        if align == "center" then a = 2 elseif align == "right" then a = 4 end -- LEFT=1<<0? 用数值见 NanoVGTypes
        -- NanoVG align bits: LEFT=1,CENTER=2,RIGHT=4,TOP=8,MIDDLE=16,BOTTOM=32,BASELINE=64
        local ha = (align == "center" and 2) or (align == "right" and 4) or 1
        local va = (baseline == "top" and 8) or (baseline == "middle" and 16) or (baseline == "bottom" and 32) or 64
        nvgTextAlign(c, ha + va)
        applyFill(c, spec)
        nvgText(c, x, y, text, nil)
    end)
end

function Ctx:createLinearGradient(x0, y0, x1, y1)
    return { _grad = "linear", x0 = x0, y0 = y0, x1 = x1, y1 = y1, stops = {},
        addColorStop = function(g, t, color) g.stops[#g.stops + 1] = { t = t, color = parseColor(color) } end }
end
function Ctx:createRadialGradient(x0, y0, r0, x1, y1, r1)
    return { _grad = "radial", x0 = x0, y0 = y0, r0 = r0, x1 = x1, y1 = y1, r1 = r1, stops = {},
        addColorStop = function(g, t, color) g.stops[#g.stops + 1] = { t = t, color = parseColor(color) } end }
end

--------------------------------------------------------------------------------
-- Canvas
--------------------------------------------------------------------------------
local canvasMeta
local function ensureRender(self)
    if rawget(self, "_evtObj") then return end
    local node = Node()
    rawset(self, "_evtNode", node)
    local obj = node:CreateScriptObject("LuaScriptObject")
    rawset(self, "_evtObj", obj)
    obj:SubscribeToEvent("EndAllViewsRender", function()
        local ctx = rawget(self, "_nvg")
        local rt = rawget(self, "_rt")
        local c2d = rawget(self, "_ctx")
        if not ctx or not c2d then return end
        local w, h = rawget(self, "width"), rawget(self, "height")
        nvgBeginFrame(ctx, w, h, 1.0)
        local st = { fill = "#000", stroke = "#000", lineWidth = 1, alpha = 1 }
        local ops = rawget(c2d, "_ops")
        for i = 1, #ops do ops[i](ctx, st) end
        nvgEndFrame(ctx)
    end)
end

canvasMeta = {
    __index = function(self, k) return rawget(self, "_methods")[k] end,
    __newindex = function(self, k, v)
        if k == "width" or k == "height" then
            rawset(self, k, v)
            local rt = rawget(self, "_rt")
            if rt then rt:SetSize(rawget(self, "width"), rawget(self, "height"), Graphics:GetRGBAFormat(), TEXTURE_RENDERTARGET) end
        else
            rawset(self, k, v)
        end
    end,
}

local methods = {
    getContext = function(self, kind)
        local c2d = rawget(self, "_ctx")
        if not c2d then
            c2d = newCtx(self); rawset(self, "_ctx", c2d)
            -- 懒建 NVG + render target
            local rt = Texture2D:new()
            rt:SetNumLevels(1)
            rt:SetSize(rawget(self, "width"), rawget(self, "height"), Graphics:GetRGBAFormat(), TEXTURE_RENDERTARGET)
            rt:SetFilterMode(FILTER_BILINEAR)
            rawset(self, "_rt", rt)
            local nvg = nvgCreate(1)
            rawset(self, "_nvg", nvg)
            nvgSetRenderTarget(nvg, rt)
            -- 默认字体（若有）
            local fid = nvgCreateFont and nvgCreateFont(nvg, "canvas", "Fonts/MiSans-Regular.ttf") or -1
            rawset(self, "_fontId", fid)
            ensureRender(self)
        end
        return c2d
    end,
    getRenderTarget = function(self) return rawget(self, "_rt") end,
    dispose = function(self)
        local n = rawget(self, "_evtNode"); if n then n:Remove() end
        local nvg = rawget(self, "_nvg"); if nvg then nvgDelete(nvg) end
    end,
}

function Canvas.new(width, height)
    local self = setmetatable({}, canvasMeta)
    rawset(self, "_methods", methods)
    rawset(self, "width", width or 300)
    rawset(self, "height", height or 150)
    return self
end

return Canvas
