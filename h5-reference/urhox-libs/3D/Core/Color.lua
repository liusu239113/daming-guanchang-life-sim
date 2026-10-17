-- ============================================================================
-- urhox-libs/3D · Color
-- 忠实复刻 three.js Color。r/g/b 分量存于 linear 工作空间（与 Convert.color 一致，
-- 故 THREE.Color 实例可直接传给材质 color）。设计见 §4.8 / §5.2。
-- 色彩管理对标 three.js（工作空间 = Linear-sRGB）：hex/字符串输入按 sRGB→linear 存储，
-- getHex/getHexString 再 linear→sRGB 编回；(r,g,b) 浮点与 setHSL 视为已 linear（同 setRGB）。
-- ============================================================================

local CM = require("urhox-libs/3D/Core/ColorManagement")
local SRGBColorSpace = CM.SRGBColorSpace

local Color = {}
local methods = {}
local mt = { __index = methods, __tostring = function(s)
    return string.format("Color(%.3f, %.3f, %.3f)", s.r, s.g, s.b)
end }

-- 就地变更通知：材质把 color/emissive 的 _onChange 绑到自己，AI 改 color.setHex()/multiplyScalar()
-- 等就地变更能热更新 native。clone() 副本无 _onChange，独立可改不影响原材质（three.js 语义）。
local function fire(self) local f = self._onChange; if f then f(self) end end

-- 所有写入经 ColorManagement（对标 three.js）：hex/字符串默认按 sRGB 解码到工作空间(linear)；
-- (r,g,b) 浮点默认按工作空间(linear)原样存。可显式传 colorSpace 覆盖；CM.enabled=false 时直通。
function methods:setHex(hex, colorSpace)
    self.r = math.floor(hex / 65536) % 256 / 255.0
    self.g = math.floor(hex / 256) % 256 / 255.0
    self.b = hex % 256 / 255.0
    CM.colorSpaceToWorking(self, colorSpace or SRGBColorSpace)
    fire(self)
    return self
end

function methods:setRGB(r, g, b, colorSpace)
    self.r, self.g, self.b = r, g, b
    CM.colorSpaceToWorking(self, colorSpace or CM.workingColorSpace)
    fire(self)
    return self
end

-- 支持 "#rrggbb" / "rrggbb" / "#rgb" / "rgb(r,g,b)" / 命名色（其余回落 setColorName 告警）。
function methods:setStyle(style, colorSpace)
    colorSpace = colorSpace or SRGBColorSpace
    local s = tostring(style)
    -- rgb(r,g,b) / rgba(r,g,b,a)：r/g/b 为 0-255 整数（忽略 alpha）
    local r, g, b = s:match("^rgba?%(%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
    if r then
        self.r, self.g, self.b = tonumber(r) / 255, tonumber(g) / 255, tonumber(b) / 255
        CM.colorSpaceToWorking(self, colorSpace); fire(self); return self
    end
    local hex = s:gsub("^#", "")
    if hex:match("^%x%x%x%x%x%x$") then -- #rrggbb
        self.r = tonumber(hex:sub(1, 2), 16) / 255
        self.g = tonumber(hex:sub(3, 4), 16) / 255
        self.b = tonumber(hex:sub(5, 6), 16) / 255
        CM.colorSpaceToWorking(self, colorSpace); fire(self); return self
    elseif hex:match("^%x%x%x$") then -- #rgb（每位翻倍）
        local function d(c) local v = tonumber(c, 16); return (v * 16 + v) / 255 end
        self.r, self.g, self.b = d(hex:sub(1, 1)), d(hex:sub(2, 2)), d(hex:sub(3, 3))
        CM.colorSpaceToWorking(self, colorSpace); fire(self); return self
    end
    return self:setColorName(s, colorSpace) -- 命名色 / 未知（告警）
end

-- 接受：(THREE.Color/{r,g,b} 表) | (hex 整数) | (r,g,b 浮点) | ("#hex")（对标 three.js Color.set 分派）
function methods:set(a, b, c)
    if type(a) == "table" then
        self.r, self.g, self.b = a.r or a[1] or 1, a.g or a[2] or 1, a.b or a[3] or 1
        fire(self)
        return self
    elseif b ~= nil then
        return self:setRGB(a, b, c) -- (r,g,b) 浮点 → 工作空间(linear)，不转
    elseif type(a) == "number" then
        return self:setHex(a) -- hex → sRGB 解码
    elseif type(a) == "string" then
        return self:setStyle(a) -- "#hex" → sRGB 解码
    end
    return self
end

function Color.new(a, b, c)
    local o = setmetatable({ r = 1, g = 1, b = 1 }, mt)
    if a ~= nil then o:set(a, b, c) end
    return o
end

function methods:copy(c) self.r, self.g, self.b = c.r, c.g, c.b; fire(self); return self end
function methods:clone() return setmetatable({ r = self.r, g = self.g, b = self.b }, mt) end

-- linear → 目标空间 编回（默认 sRGB，对标 three.js getHex(colorSpace=SRGBColorSpace)）
function methods:getHex(colorSpace)
    local c = { r = self.r, g = self.g, b = self.b }
    CM.workingToColorSpace(c, colorSpace or SRGBColorSpace)
    local function q(v) return math.max(0, math.min(255, math.floor(v * 255 + 0.5))) end
    return q(c.r) * 65536 + q(c.g) * 256 + q(c.b)
end

function methods:getHexString(colorSpace) return string.format("%06x", self:getHex(colorSpace)) end

-- three.js Color.convertSRGBToLinear / convertLinearToSRGB（就地转换当前分量）
function methods:convertSRGBToLinear()
    self.r, self.g, self.b = CM.SRGBToLinear(self.r), CM.SRGBToLinear(self.g), CM.SRGBToLinear(self.b)
    fire(self)
    return self
end

function methods:convertLinearToSRGB()
    self.r, self.g, self.b = CM.LinearToSRGB(self.r), CM.LinearToSRGB(self.g), CM.LinearToSRGB(self.b)
    fire(self)
    return self
end

function methods:multiplyScalar(s) self.r, self.g, self.b = self.r * s, self.g * s, self.b * s; fire(self); return self end

function methods:lerp(c, t)
    self.r = self.r + (c.r - self.r) * t
    self.g = self.g + (c.g - self.g) * t
    self.b = self.b + (c.b - self.b) * t
    fire(self)
    return self
end

function methods:equals(c) return self.r == c.r and self.g == c.g and self.b == c.b end

-- HSL → RGB（h,s,l 均 0-1，three.js setHSL）。默认 colorSpace=工作空间(linear) → 不二次转换。
function methods:setHSL(h, s, l, colorSpace)
    if s == 0 then
        self.r, self.g, self.b = l, l, l
    else
        local function hue2rgb(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1 / 6 then return p + (q - p) * 6 * t end
            if t < 1 / 2 then return q end
            if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
            return p
        end
        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q
        self.r = hue2rgb(p, q, h + 1 / 3)
        self.g = hue2rgb(p, q, h)
        self.b = hue2rgb(p, q, h - 1 / 3)
    end
    CM.colorSpaceToWorking(self, colorSpace or CM.workingColorSpace)
    fire(self)
    return self
end

-- 转 UrhoX 原生 Color（a 默认 1）。_G.Color 是引擎原生构造器（本模块 local Color 是包装表）
function methods:toUrho(a) return _G.Color(self.r, self.g, self.b, a or 1) end

-- ---- 分量算术 / HSL / 命名色 / 矩阵 ----------------------------------------
-- 分量算术均在工作空间(linear)进行（同 three.js）。
local _c = {} -- 转换 scratch（getHSL/getRGB/getStyle 用，避免分配）

function methods:setScalar(s) self.r, self.g, self.b = s, s, s; fire(self); return self end
function methods:addScalar(s) self.r, self.g, self.b = self.r + s, self.g + s, self.b + s; fire(self); return self end
function methods:add(c) self.r, self.g, self.b = self.r + c.r, self.g + c.g, self.b + c.b; fire(self); return self end
function methods:addColors(c1, c2) self.r, self.g, self.b = c1.r + c2.r, c1.g + c2.g, c1.b + c2.b; fire(self); return self end
function methods:sub(c)
    self.r = math.max(0, self.r - c.r); self.g = math.max(0, self.g - c.g); self.b = math.max(0, self.b - c.b)
    fire(self); return self
end
function methods:multiply(c) self.r, self.g, self.b = self.r * c.r, self.g * c.g, self.b * c.b; fire(self); return self end

function methods:lerpColors(c1, c2, t)
    self.r = c1.r + (c2.r - c1.r) * t
    self.g = c1.g + (c2.g - c1.g) * t
    self.b = c1.b + (c2.b - c1.b) * t
    fire(self); return self
end

function methods:setFromVector3(v) self.r, self.g, self.b = v.x, v.y, v.z; fire(self); return self end

-- 用 color 的分量经 linear↔sRGB 转换填入 self（three.js copyLinearToSRGB/copySRGBToLinear）
function methods:copyLinearToSRGB(c)
    self.r, self.g, self.b = CM.LinearToSRGB(c.r), CM.LinearToSRGB(c.g), CM.LinearToSRGB(c.b); fire(self); return self
end
function methods:copySRGBToLinear(c)
    self.r, self.g, self.b = CM.SRGBToLinear(c.r), CM.SRGBToLinear(c.g), CM.SRGBToLinear(c.b); fire(self); return self
end

-- m.elements 1-based（Matrix3）
function methods:applyMatrix3(m)
    local r, g, b = self.r, self.g, self.b
    local e = m.elements
    self.r = e[1] * r + e[4] * g + e[7] * b
    self.g = e[2] * r + e[5] * g + e[8] * b
    self.b = e[3] * r + e[6] * g + e[9] * b
    fire(self); return self
end

function methods:fromArray(arr, offset)
    offset = offset or 0
    self.r, self.g, self.b = arr[offset + 1], arr[offset + 2], arr[offset + 3]; fire(self); return self
end
function methods:toArray(arr, offset)
    arr = arr or {}; offset = offset or 0
    arr[offset + 1], arr[offset + 2], arr[offset + 3] = self.r, self.g, self.b; return arr
end

-- 从 BufferAttribute 第 index 项取 r/g/b（原样，不做色彩空间转换，同 three.js）
function methods:fromBufferAttribute(attribute, index)
    if attribute.getX then
        self.r, self.g, self.b = attribute:getX(index), attribute:getY(index), attribute:getZ(index)
    else
        local arr, is = attribute.array, attribute.itemSize or 3
        local o = index * is
        self.r, self.g, self.b = arr[o + 1], arr[o + 2], arr[o + 3]
    end
    fire(self); return self
end

-- RGB(工作空间 linear) → HSL，先把分量转到目标空间（默认工作空间）再算（同 three.js getHSL）
function methods:getHSL(target, colorSpace)
    _c.r, _c.g, _c.b = self.r, self.g, self.b
    CM.workingToColorSpace(_c, colorSpace or CM.workingColorSpace)
    local r, g, b = _c.r, _c.g, _c.b
    local mx, mn = math.max(r, g, b), math.min(r, g, b)
    local hue, sat
    local light = (mn + mx) / 2
    if mn == mx then
        hue, sat = 0, 0
    else
        local delta = mx - mn
        sat = light <= 0.5 and delta / (mx + mn) or delta / (2 - mx - mn)
        if mx == r then
            hue = (g - b) / delta + (g < b and 6 or 0)
        elseif mx == g then
            hue = (b - r) / delta + 2
        else
            hue = (r - g) / delta + 4
        end
        hue = hue / 6
    end
    target = target or {}
    target.h, target.s, target.l = hue, sat, light
    return target
end

function methods:getRGB(target, colorSpace)
    _c.r, _c.g, _c.b = self.r, self.g, self.b
    CM.workingToColorSpace(_c, colorSpace or CM.workingColorSpace)
    target = target or {}
    target.r, target.g, target.b = _c.r, _c.g, _c.b
    return target
end

-- CSS 字符串（默认 sRGB → "rgb(r,g,b)"）。仅实现 sRGB 常用路径。
function methods:getStyle(colorSpace)
    colorSpace = colorSpace or SRGBColorSpace
    _c.r, _c.g, _c.b = self.r, self.g, self.b
    CM.workingToColorSpace(_c, colorSpace)
    if colorSpace ~= SRGBColorSpace then
        return string.format("color(%s %.3f %.3f %.3f)", colorSpace, _c.r, _c.g, _c.b)
    end
    return string.format("rgb(%d,%d,%d)",
        math.floor(_c.r * 255 + 0.5), math.floor(_c.g * 255 + 0.5), math.floor(_c.b * 255 + 0.5))
end

-- HSL 偏移 / 插值（经 getHSL → setHSL，工作空间内）
function methods:offsetHSL(h, s, l)
    local hsl = self:getHSL({})
    return self:setHSL(hsl.h + h, hsl.s + s, hsl.l + l)
end
function methods:lerpHSL(c, t)
    local a = self:getHSL({})
    local b = c:getHSL({})
    return self:setHSL(a.h + (b.h - a.h) * t, a.s + (b.s - a.s) * t, a.l + (b.l - a.l) * t)
end

-- CSS 命名色（X11/SVG 关键字，与 three.js _colorKeywords 完全一致）。默认按 sRGB 解码。
local colorKeywords = {
    aliceblue = 0xF0F8FF, antiquewhite = 0xFAEBD7, aqua = 0x00FFFF, aquamarine = 0x7FFFD4, azure = 0xF0FFFF,
    beige = 0xF5F5DC, bisque = 0xFFE4C4, black = 0x000000, blanchedalmond = 0xFFEBCD, blue = 0x0000FF, blueviolet = 0x8A2BE2,
    brown = 0xA52A2A, burlywood = 0xDEB887, cadetblue = 0x5F9EA0, chartreuse = 0x7FFF00, chocolate = 0xD2691E, coral = 0xFF7F50,
    cornflowerblue = 0x6495ED, cornsilk = 0xFFF8DC, crimson = 0xDC143C, cyan = 0x00FFFF, darkblue = 0x00008B, darkcyan = 0x008B8B,
    darkgoldenrod = 0xB8860B, darkgray = 0xA9A9A9, darkgreen = 0x006400, darkgrey = 0xA9A9A9, darkkhaki = 0xBDB76B, darkmagenta = 0x8B008B,
    darkolivegreen = 0x556B2F, darkorange = 0xFF8C00, darkorchid = 0x9932CC, darkred = 0x8B0000, darksalmon = 0xE9967A, darkseagreen = 0x8FBC8F,
    darkslateblue = 0x483D8B, darkslategray = 0x2F4F4F, darkslategrey = 0x2F4F4F, darkturquoise = 0x00CED1, darkviolet = 0x9400D3,
    deeppink = 0xFF1493, deepskyblue = 0x00BFFF, dimgray = 0x696969, dimgrey = 0x696969, dodgerblue = 0x1E90FF, firebrick = 0xB22222,
    floralwhite = 0xFFFAF0, forestgreen = 0x228B22, fuchsia = 0xFF00FF, gainsboro = 0xDCDCDC, ghostwhite = 0xF8F8FF, gold = 0xFFD700,
    goldenrod = 0xDAA520, gray = 0x808080, green = 0x008000, greenyellow = 0xADFF2F, grey = 0x808080, honeydew = 0xF0FFF0, hotpink = 0xFF69B4,
    indianred = 0xCD5C5C, indigo = 0x4B0082, ivory = 0xFFFFF0, khaki = 0xF0E68C, lavender = 0xE6E6FA, lavenderblush = 0xFFF0F5, lawngreen = 0x7CFC00,
    lemonchiffon = 0xFFFACD, lightblue = 0xADD8E6, lightcoral = 0xF08080, lightcyan = 0xE0FFFF, lightgoldenrodyellow = 0xFAFAD2, lightgray = 0xD3D3D3,
    lightgreen = 0x90EE90, lightgrey = 0xD3D3D3, lightpink = 0xFFB6C1, lightsalmon = 0xFFA07A, lightseagreen = 0x20B2AA, lightskyblue = 0x87CEFA,
    lightslategray = 0x778899, lightslategrey = 0x778899, lightsteelblue = 0xB0C4DE, lightyellow = 0xFFFFE0, lime = 0x00FF00, limegreen = 0x32CD32,
    linen = 0xFAF0E6, magenta = 0xFF00FF, maroon = 0x800000, mediumaquamarine = 0x66CDAA, mediumblue = 0x0000CD, mediumorchid = 0xBA55D3,
    mediumpurple = 0x9370DB, mediumseagreen = 0x3CB371, mediumslateblue = 0x7B68EE, mediumspringgreen = 0x00FA9A, mediumturquoise = 0x48D1CC,
    mediumvioletred = 0xC71585, midnightblue = 0x191970, mintcream = 0xF5FFFA, mistyrose = 0xFFE4E1, moccasin = 0xFFE4B5, navajowhite = 0xFFDEAD,
    navy = 0x000080, oldlace = 0xFDF5E6, olive = 0x808000, olivedrab = 0x6B8E23, orange = 0xFFA500, orangered = 0xFF4500, orchid = 0xDA70D6,
    palegoldenrod = 0xEEE8AA, palegreen = 0x98FB98, paleturquoise = 0xAFEEEE, palevioletred = 0xDB7093, papayawhip = 0xFFEFD5, peachpuff = 0xFFDAB9,
    peru = 0xCD853F, pink = 0xFFC0CB, plum = 0xDDA0DD, powderblue = 0xB0E0E6, purple = 0x800080, rebeccapurple = 0x663399, red = 0xFF0000, rosybrown = 0xBC8F8F,
    royalblue = 0x4169E1, saddlebrown = 0x8B4513, salmon = 0xFA8072, sandybrown = 0xF4A460, seagreen = 0x2E8B57, seashell = 0xFFF5EE,
    sienna = 0xA0522D, silver = 0xC0C0C0, skyblue = 0x87CEEB, slateblue = 0x6A5ACD, slategray = 0x708090, slategrey = 0x708090, snow = 0xFFFAFA,
    springgreen = 0x00FF7F, steelblue = 0x4682B4, tan = 0xD2B48C, teal = 0x008080, thistle = 0xD8BFD8, tomato = 0xFF6347, turquoise = 0x40E0D0,
    violet = 0xEE82EE, wheat = 0xF5DEB3, white = 0xFFFFFF, whitesmoke = 0xF5F5F5, yellow = 0xFFFF00, yellowgreen = 0x9ACD32,
}
Color.NAMES = colorKeywords

function methods:setColorName(style, colorSpace)
    local hex = colorKeywords[tostring(style):lower()]
    if hex ~= nil then
        return self:setHex(hex, colorSpace or SRGBColorSpace)
    end
    -- @diagnostic disable-next-line: undefined-global
    if log then log:Write(LOG_WARNING, "Color: Unknown color " .. tostring(style)) end
    return self
end

return Color
