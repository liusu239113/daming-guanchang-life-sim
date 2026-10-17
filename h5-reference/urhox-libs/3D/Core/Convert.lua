-- ============================================================================
-- urhox-libs/3D · Convert
-- three.js → UrhoX 的色彩/角度/旋转转换（设计见 docs/design/threejs-3d-api-design.md §5）
-- ============================================================================
--
-- 手性由引擎处理（相机 Camera.handedness = RH），坐标/向量纯直通，无需转换。
-- 本模块只负责：角度（弧度↔度）、Euler→四元数、色彩格式。
--
-- ============================================================================

local CM = require("urhox-libs/3D/Core/ColorManagement")

local Convert = {}

-- ---- 角度（three.js 用弧度，UrhoX 用度数）-------------------------------------
local DEG = 180.0 / math.pi
local RAD = math.pi / 180.0

function Convert.degToRad(d) return d * RAD end
function Convert.radToDeg(r) return r * DEG end

-- ---- 旋转：three.js Euler(弧度, XYZ 序) → UrhoX 原生 Quaternion --------------
-- 标准 three.js setFromEuler(XYZ) → 四元数。Urho 四元数构造器为 (w, x, y, z)。
local sin, cos = math.sin, math.cos
function Convert.eulerToUrhoQuat(ex, ey, ez)
    local c1, c2, c3 = cos(ex * 0.5), cos(ey * 0.5), cos(ez * 0.5)
    local s1, s2, s3 = sin(ex * 0.5), sin(ey * 0.5), sin(ez * 0.5)
    local qx = s1 * c2 * c3 + c1 * s2 * s3
    local qy = c1 * s2 * c3 - s1 * c2 * s3
    local qz = c1 * c2 * s3 + s1 * s2 * c3
    local qw = c1 * c2 * c3 - s1 * s2 * s3
    return Quaternion(qw, qx, qy, qz)
end

-- ---- 旋转：UrhoX Quaternion → three.js Euler(弧度, XYZ 序) -------------------
-- eulerToUrhoQuat 的逆：标准 three.js Euler.setFromQuaternion(order='XYZ')。
-- 用于 Object3D.rotation 的读取：从节点实际四元数实时反推，保证 lookAt/动画后仍同步。
local asin, atan, abs = math.asin, math.atan, math.abs
function Convert.quatToEuler(qw, qx, qy, qz)
    local x2, y2, z2 = qx + qx, qy + qy, qz + qz
    local xx, xy, xz = qx * x2, qx * y2, qx * z2
    local yy, yz, zz = qy * y2, qy * z2, qz * z2
    local wx, wy, wz = qw * x2, qw * y2, qw * z2
    local m11 = 1.0 - (yy + zz)
    local m12 = xy - wz
    local m13 = xz + wy
    local m22 = 1.0 - (xx + zz)
    local m23 = yz - wx
    local m32 = yz + wx
    local m33 = 1.0 - (xx + yy)
    local m13c = m13 < -1.0 and -1.0 or (m13 > 1.0 and 1.0 or m13)
    local ey = asin(m13c)
    local ex, ez
    if abs(m13) < 0.9999999 then
        ex = atan(-m23, m33)
        ez = atan(-m12, m11)
    else
        ex = atan(m32, m22)
        ez = 0.0
    end
    return ex, ey, ez
end

-- ---- 色彩：three.js 多格式 → UrhoX Color（linear 工作空间，经 ColorManagement）-----
-- 接受：0xRRGGBB(整数) | "#rrggbb"/"#rrggbbaa" | {r,g,b[,a]} | Color(原样返回)
-- hex/字符串 = sRGB 输入 → colorSpaceToWorking 解码到 linear（对标 three.js setHex/setStyle）；
-- 浮点 {r,g,b} 与 THREE.Color 视为已在 linear 工作空间，原样返回（对标 three.js setRGB）。
-- 关闭 ColorManagement.enabled 时 colorSpaceToWorking 直通（色值不转，复刻 legacy）。
Convert.srgbToLinear = CM.SRGBToLinear -- 兼容别名
Convert.linearToSRGB = CM.LinearToSRGB

function Convert.color(c, a)
    a = a or 1.0
    local t = type(c)
    if t == "number" then
        -- 0xRRGGBB 十六进制整数 → sRGB→linear
        local tmp = {
            r = math.floor(c / 65536) % 256 / 255.0,
            g = math.floor(c / 256) % 256 / 255.0,
            b = c % 256 / 255.0,
        }
        CM.colorSpaceToWorking(tmp, CM.SRGBColorSpace)
        return Color(tmp.r, tmp.g, tmp.b, a)
    elseif t == "string" then
        local hex = c:gsub("^#", "")
        local aa = #hex >= 8 and (tonumber(hex:sub(7, 8), 16) / 255.0) or a
        local tmp = {
            r = (tonumber(hex:sub(1, 2), 16) or 255) / 255.0,
            g = (tonumber(hex:sub(3, 4), 16) or 255) / 255.0,
            b = (tonumber(hex:sub(5, 6), 16) or 255) / 255.0,
        }
        CM.colorSpaceToWorking(tmp, CM.SRGBColorSpace)
        return Color(tmp.r, tmp.g, tmp.b, aa)
    elseif t == "table" then
        -- {r,g,b[,a]} 或 THREE.Color：已是 linear 工作空间，原样
        local r = c.r or c[1] or 1.0
        local g = c.g or c[2] or 1.0
        local b = c.b or c[3] or 1.0
        local aa = c.a or c[4] or a
        return Color(r, g, b, aa)
    else
        -- 已是 Color（userdata）：原样返回
        return c
    end
end

return Convert
