-- ============================================================================
-- urhox-libs/3D · Path / Shape
-- three.js extras/core：2D 路径。moveTo/lineTo/quadraticCurveTo/bezierCurveTo/
-- absarc/arc/absellipse → getPoints(divisions) 展平为 2D 点序列（{x,y}）。
-- Shape = Path + holes（子 Path 数组），供 ExtrudeGeometry。
-- 实现为把每段曲线按 divisions 采样累积（与 three.js Curve.getPoints 思路一致）。
-- ============================================================================

local Path = {}
local methods = {}
local mt = { __index = methods }

local function newPath(pts)
    local self = setmetatable({}, mt)
    self._segs = {}                 -- 每段：function(out, divisions) 追加点
    self._cx, self._cy = 0, 0       -- 当前点
    self._startx, self._starty = 0, 0
    self.holes = {}                 -- Shape 用
    if pts then
        for i = 1, #pts do
            local p = pts[i]
            if i == 1 then self:moveTo(p.x, p.y) else self:lineTo(p.x, p.y) end
        end
    end
    return self
end

function methods:moveTo(x, y)
    self._cx, self._cy = x, y
    self._startx, self._starty = x, y
    return self
end

function methods:lineTo(x, y)
    local x0, y0 = self._cx, self._cy
    self._segs[#self._segs + 1] = function(out, _) out[#out + 1] = { x = x, y = y } end
    self._cx, self._cy = x, y
    return self
end

function methods:quadraticCurveTo(cx, cy, x, y)
    local x0, y0 = self._cx, self._cy
    self._segs[#self._segs + 1] = function(out, div)
        for i = 1, div do
            local t = i / div; local mt_ = 1 - t
            out[#out + 1] = {
                x = mt_ * mt_ * x0 + 2 * mt_ * t * cx + t * t * x,
                y = mt_ * mt_ * y0 + 2 * mt_ * t * cy + t * t * y,
            }
        end
    end
    self._cx, self._cy = x, y
    return self
end

function methods:bezierCurveTo(c1x, c1y, c2x, c2y, x, y)
    local x0, y0 = self._cx, self._cy
    self._segs[#self._segs + 1] = function(out, div)
        for i = 1, div do
            local t = i / div; local mt_ = 1 - t
            local a = mt_ * mt_ * mt_; local b = 3 * mt_ * mt_ * t
            local c = 3 * mt_ * t * t; local d = t * t * t
            out[#out + 1] = {
                x = a * x0 + b * c1x + c * c2x + d * x,
                y = a * y0 + b * c1y + c * c2y + d * y,
            }
        end
    end
    self._cx, self._cy = x, y
    return self
end

-- absarc(cx,cy,r,a0,a1,ccw)：绝对坐标圆弧
function methods:absarc(cx, cy, r, a0, a1, ccw)
    return self:absellipse(cx, cy, r, r, a0, a1, ccw, 0)
end
function methods:arc(cx, cy, r, a0, a1, ccw)
    return self:absarc(self._cx + cx, self._cy + cy, r, a0, a1, ccw)
end

function methods:absellipse(cx, cy, rx, ry, a0, a1, ccw, rotation)
    rotation = rotation or 0
    self._segs[#self._segs + 1] = function(out, div)
        local da = a1 - a0
        if not ccw and da < 0 then da = da + math.pi * 2 end
        if ccw and da > 0 then da = da - math.pi * 2 end
        local cosR, sinR = math.cos(rotation), math.sin(rotation)
        for i = 1, div do
            local t = i / div; local ang = a0 + da * t
            local px, py = math.cos(ang) * rx, math.sin(ang) * ry
            out[#out + 1] = { x = cx + px * cosR - py * sinR, y = cy + px * sinR + py * cosR }
        end
    end
    -- 更新当前点为弧末
    local cosR, sinR = math.cos(rotation), math.sin(rotation)
    local px, py = math.cos(a1) * rx, math.sin(a1) * ry
    self._cx, self._cy = cx + px * cosR - py * sinR, cy + px * sinR + py * cosR
    return self
end

function methods:closePath()
    if self._cx ~= self._startx or self._cy ~= self._starty then
        self:lineTo(self._startx, self._starty)
    end
    return self
end

-- 展平为 2D 点序列（含起点）
function methods:getPoints(divisions)
    divisions = divisions or 12
    local out = {}
    out[1] = { x = self._startx, y = self._starty }
    for i = 1, #self._segs do self._segs[i](out, divisions) end
    return out
end

-- Shape：Path + holes
function methods:getPointsHoles(divisions)
    local holes = {}
    for i = 1, #self.holes do holes[i] = self.holes[i]:getPoints(divisions) end
    return holes
end

Path.new = newPath
-- Shape 与 Path 同实现（Shape 多用 holes 字段）；分别暴露便于语义/isShape
function Path.newShape(pts)
    local s = newPath(pts)
    s.isShape = true
    return s
end

return Path
