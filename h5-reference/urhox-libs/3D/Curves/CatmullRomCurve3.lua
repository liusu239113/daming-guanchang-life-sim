-- ============================================================================
-- urhox-libs/3D · CatmullRomCurve3
-- 忠实移植 three.js CatmullRomCurve3：过点的样条（centripetal/chordal/catmullrom）。
-- getPoint(t)/getPoints(n)/getTangent(t)/computeFrenetFrames —— 供 TubeGeometry 扫管用。
-- 点用 THREE.Vector3（读 .x/.y/.z）。
-- ============================================================================

local Vector3 = require("urhox-libs/3D/Core/Vector3")

local Curve = {}
local methods = {}
local mt = { __index = methods }

-- CubicPoly（three.js 同名）
local function CubicPoly()
    return { c0 = 0, c1 = 0, c2 = 0, c3 = 0,
        init = function(self, x0, x1, t0, t1)
            self.c0 = x0; self.c1 = t0
            self.c2 = -3 * x0 + 3 * x1 - 2 * t0 - t1
            self.c3 = 2 * x0 - 2 * x1 + t0 + t1
        end,
        initCatmullRom = function(self, x0, x1, x2, x3, tension)
            self:init(x1, x2, tension * (x2 - x0), tension * (x3 - x1))
        end,
        initNonuniform = function(self, x0, x1, x2, x3, dt0, dt1, dt2)
            local t1 = (x1 - x0) / dt0 - (x2 - x0) / (dt0 + dt1) + (x2 - x1) / dt1
            local t2 = (x2 - x1) / dt1 - (x3 - x1) / (dt1 + dt2) + (x3 - x2) / dt2
            t1 = t1 * dt1; t2 = t2 * dt1
            self:init(x1, x2, t1, t2)
        end,
        calc = function(self, t)
            local t2 = t * t; local t3 = t2 * t
            return self.c0 + self.c1 * t + self.c2 * t2 + self.c3 * t3
        end,
    }
end

function Curve.new(points, closed, curveType, tension)
    local self = setmetatable({}, mt)
    self.points = points or {}
    self.closed = closed or false
    self.curveType = curveType or "centripetal"
    self.tension = tension or 0.5
    self.isCatmullRomCurve3 = true
    self.arcLengthDivisions = 200 -- three.js Curve 默认
    self.needsUpdate = false
    return self
end

function methods:getPoint(t)
    local points = self.points
    local l = #points
    local p = (l - (self.closed and 0 or 1)) * t
    local intPoint = math.floor(p)
    local weight = p - intPoint
    if self.closed then
        intPoint = intPoint + (intPoint > 0 and 0 or (math.floor(math.abs(intPoint) / l) + 1) * l)
    elseif weight == 0 and intPoint == l - 1 then
        intPoint = l - 2; weight = 1
    end
    -- 1-based 取点辅助（intPoint 是 0-based 段索引）
    local function P(i) return points[(i % l) + 1] end
    local p0, p1, p2, p3
    p1 = P(intPoint)
    p2 = P(intPoint + 1)
    if self.closed or intPoint > 0 then
        p0 = P(intPoint - 1)
    else
        -- 端点外推：2*p1 - p2
        p0 = { x = 2 * p1.x - p2.x, y = 2 * p1.y - p2.y, z = 2 * p1.z - p2.z }
    end
    if self.closed or intPoint + 2 < l then
        p3 = P(intPoint + 2)
    else
        p3 = { x = 2 * p2.x - p1.x, y = 2 * p2.y - p1.y, z = 2 * p2.z - p1.z }
    end

    local px, py, pz = CubicPoly(), CubicPoly(), CubicPoly()
    if self.curveType == "centripetal" or self.curveType == "chordal" then
        local pow = self.curveType == "chordal" and 0.5 or 0.25
        local function dist(a, b)
            local dx, dy, dz = a.x - b.x, a.y - b.y, a.z - b.z
            return (dx * dx + dy * dy + dz * dz) ^ pow
        end
        local dt0 = dist(p0, p1); local dt1 = dist(p1, p2); local dt2 = dist(p2, p3)
        if dt1 < 1e-4 then dt1 = 1.0 end
        if dt0 < 1e-4 then dt0 = dt1 end
        if dt2 < 1e-4 then dt2 = dt1 end
        px:initNonuniform(p0.x, p1.x, p2.x, p3.x, dt0, dt1, dt2)
        py:initNonuniform(p0.y, p1.y, p2.y, p3.y, dt0, dt1, dt2)
        pz:initNonuniform(p0.z, p1.z, p2.z, p3.z, dt0, dt1, dt2)
    else
        px:initCatmullRom(p0.x, p1.x, p2.x, p3.x, self.tension)
        py:initCatmullRom(p0.y, p1.y, p2.y, p3.y, self.tension)
        pz:initCatmullRom(p0.z, p1.z, p2.z, p3.z, self.tension)
    end
    return Vector3.new(px:calc(weight), py:calc(weight), pz:calc(weight))
end

function methods:getPoints(divisions)
    divisions = divisions or 5
    local pts = {}
    for i = 0, divisions do pts[#pts + 1] = self:getPoint(i / divisions) end
    return pts
end

-- ---- 弧长重参数化家族（three.js Curve 基类）-------------------------------
-- 累积弧长表：cache[1]=0，cache[p+1]=前 p 段折线长度和。divisions+1 个采样点。
function methods:getLengths(divisions)
    divisions = divisions or self.arcLengthDivisions
    local cache = self.cacheArcLengths
    if cache and #cache == divisions + 1 and not self.needsUpdate then return cache end
    self.needsUpdate = false
    cache = {}
    local last = self:getPoint(0)
    local sum = 0
    cache[1] = 0
    for p = 1, divisions do
        local current = self:getPoint(p / divisions)
        sum = sum + current:distanceTo(last)
        cache[p + 1] = sum
        last = current
    end
    self.cacheArcLengths = cache
    return cache
end

function methods:getLength()
    local lengths = self:getLengths()
    return lengths[#lengths]
end

function methods:updateArcLengths()
    self.needsUpdate = true
    self:getLengths()
end

-- u(弧长归一 0..1) → t(参数 0..1)。二分查找累积弧长表后线性内插（逻辑索引 i 保持 0-based）。
function methods:getUtoTmapping(u, distance)
    local arcLengths = self:getLengths()
    local il = #arcLengths -- = divisions + 1
    local targetArcLength = distance or (u * arcLengths[il])
    local low, high, i = 0, il - 1, 0
    while low <= high do
        i = math.floor(low + (high - low) / 2)
        local comparison = arcLengths[i + 1] - targetArcLength
        if comparison < 0 then
            low = i + 1
        elseif comparison > 0 then
            high = i - 1
        else
            high = i; break
        end
    end
    i = high
    if arcLengths[i + 1] == targetArcLength then return i / (il - 1) end
    local lengthBefore = arcLengths[i + 1]
    local lengthAfter = arcLengths[i + 2]
    local segmentLength = lengthAfter - lengthBefore
    local segmentFraction = (targetArcLength - lengthBefore) / segmentLength
    return (i + segmentFraction) / (il - 1)
end

function methods:getPointAt(u) return self:getPoint(self:getUtoTmapping(u)) end
function methods:getTangentAt(u) return self:getTangent(self:getUtoTmapping(u)) end

-- 等弧长间隔取点（three.js getSpacedPoints：经 getPointAt 弧长重参数化，非等参数）
function methods:getSpacedPoints(divisions)
    divisions = divisions or 5
    local pts = {}
    for d = 0, divisions do pts[#pts + 1] = self:getPointAt(d / divisions) end
    return pts
end

function methods:getTangent(t)
    local d = 1e-4
    local t1 = math.max(0, t - d); local t2 = math.min(1, t + d)
    local a, b = self:getPoint(t1), self:getPoint(t2)
    local v = Vector3.new(b.x - a.x, b.y - a.y, b.z - a.z)
    return v:normalize()
end

-- three.js computeFrenetFrames：沿曲线算 tangents/normals/binormals
function methods:computeFrenetFrames(segments, closed)
    local tangents, normals, binormals = {}, {}, {}
    for i = 0, segments do tangents[i + 1] = self:getTangent(i / segments) end
    -- 初始法线：选 tangent 最小分量轴叉乘
    local normal = Vector3.new(0, 0, 0)
    local t0 = tangents[1]
    local ax, ay, az = math.abs(t0.x), math.abs(t0.y), math.abs(t0.z)
    local minv, ux, uy, uz = ax, 1, 0, 0
    if ay <= minv then minv = ay; ux, uy, uz = 0, 1, 0 end
    if az <= minv then ux, uy, uz = 0, 0, 1 end
    -- normal = normalize(cross(cross(t0,u), t0))
    local function cross(a1, a2, a3, b1, b2, b3) return a2 * b3 - a3 * b2, a3 * b1 - a1 * b3, a1 * b2 - a2 * b1 end
    local vx, vy, vz = cross(t0.x, t0.y, t0.z, ux, uy, uz)
    local nx, ny, nz = cross(vx, vy, vz, t0.x, t0.y, t0.z)
    local nl = math.sqrt(nx * nx + ny * ny + nz * nz); if nl > 0 then nx, ny, nz = nx / nl, ny / nl, nz / nl end
    normals[1] = Vector3.new(nx, ny, nz)
    local bx, by, bz = cross(t0.x, t0.y, t0.z, nx, ny, nz)
    binormals[1] = Vector3.new(bx, by, bz)
    -- 沿线旋转传播法线
    for i = 2, segments + 1 do
        local pt, ct = tangents[i - 1], tangents[i]
        local pn = normals[i - 1]
        nx, ny, nz = pn.x, pn.y, pn.z
        -- 旋转轴 = cross(prevT, curT)
        local rx, ry, rz = cross(pt.x, pt.y, pt.z, ct.x, ct.y, ct.z)
        local rl = math.sqrt(rx * rx + ry * ry + rz * rz)
        if rl > 1e-6 then
            rx, ry, rz = rx / rl, ry / rl, rz / rl
            local dot = math.max(-1, math.min(1, pt.x * ct.x + pt.y * ct.y + pt.z * ct.z))
            local theta = math.acos(dot)
            -- Rodrigues 旋转 normal 绕 r 转 theta
            local c, s = math.cos(theta), math.sin(theta)
            local d = rx * nx + ry * ny + rz * nz
            local ox = nx * c + (ry * nz - rz * ny) * s + rx * d * (1 - c)
            local oy = ny * c + (rz * nx - rx * nz) * s + ry * d * (1 - c)
            local oz = nz * c + (rx * ny - ry * nx) * s + rz * d * (1 - c)
            nx, ny, nz = ox, oy, oz
        end
        normals[i] = Vector3.new(nx, ny, nz)
        bx, by, bz = cross(ct.x, ct.y, ct.z, nx, ny, nz)
        binormals[i] = Vector3.new(bx, by, bz)
    end

    -- 闭合曲线：首末帧间残余扭转 → 按 θ/segments 均摊到每个 frame，消除接缝鼓包（three.js 同款）
    if closed then
        local n0, nN = normals[1], normals[segments + 1]
        local theta = math.acos(math.max(-1, math.min(1, n0.x * nN.x + n0.y * nN.y + n0.z * nN.z))) / segments
        local t1 = tangents[1]
        local ccx, ccy, ccz = cross(n0.x, n0.y, n0.z, nN.x, nN.y, nN.z)
        if (t1.x * ccx + t1.y * ccy + t1.z * ccz) > 0 then theta = -theta end
        for i = 2, segments + 1 do
            local ang = theta * (i - 1)
            local t = tangents[i]; local n = normals[i]
            local c, s = math.cos(ang), math.sin(ang)
            local d = t.x * n.x + t.y * n.y + t.z * n.z
            local ox = n.x * c + (t.y * n.z - t.z * n.y) * s + t.x * d * (1 - c)
            local oy = n.y * c + (t.z * n.x - t.x * n.z) * s + t.y * d * (1 - c)
            local oz = n.z * c + (t.x * n.y - t.y * n.x) * s + t.z * d * (1 - c)
            normals[i] = Vector3.new(ox, oy, oz)
            local bbx, bby, bbz = cross(t.x, t.y, t.z, ox, oy, oz)
            binormals[i] = Vector3.new(bbx, bby, bbz)
        end
    end

    return { tangents = tangents, normals = normals, binormals = binormals }
end

return Curve
