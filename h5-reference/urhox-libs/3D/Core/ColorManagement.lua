-- ============================================================================
-- urhox-libs/3D · ColorManagement
-- 忠实移植 three.js THREE.ColorManagement 单例（core 部分）。
-- three.js 工作空间 = Linear-sRGB(Rec709)：hex/CSS 等 sRGB 输入构造时即解码到 linear，
-- 渲染输出再编码回 sRGB。引擎 PBR 同样是线性光照 + sRGB 输出（diffuse 贴图 SetSRGB 解码），
-- 故工作空间固定 Linear-sRGB；只注册 sRGB / srgb-linear / NoColorSpace 三个空间——
-- 三者同 Rec709 基色，sRGB↔linear 仅差 transfer 函数，无需色域矩阵。
--
-- API 对齐 three.js：enabled / workingColorSpace / convert / colorSpaceToWorking /
-- workingToColorSpace / getTransfer / SRGBToLinear / LinearToSRGB。
-- 项目可改：THREE.ColorManagement.enabled=false（关闭转换，色值直通，复刻 legacy 行为）。
-- ============================================================================

local CM = {}

-- 色彩空间常量（字符串值与 three.js constants.js 完全一致）
local NoColorSpace = ""
local SRGBColorSpace = "srgb"
local LinearSRGBColorSpace = "srgb-linear"
CM.NoColorSpace = NoColorSpace
CM.SRGBColorSpace = SRGBColorSpace
CM.LinearSRGBColorSpace = LinearSRGBColorSpace

CM.enabled = true
CM.workingColorSpace = LinearSRGBColorSpace

-- transfer 函数（与 three.js ColorManagement.js 的 SRGBToLinear/LinearToSRGB 完全一致）
local function SRGBToLinear(c)
    return (c < 0.04045) and (c * 0.0773993808) or ((c * 0.9478672986 + 0.0521327014) ^ 2.4)
end
local function LinearToSRGB(c)
    return (c < 0.0031308) and (c * 12.92) or (1.055 * (c ^ 0.41666) - 0.055)
end
CM.SRGBToLinear = SRGBToLinear
CM.LinearToSRGB = LinearToSRGB

-- 已注册空间的 transfer（primaries 统一 Rec709）。NoColorSpace 视为线性（同 three.js getTransfer）。
local SRGBTransfer = "srgb"
local LinearTransfer = "linear"
local transferOf = {
    [NoColorSpace] = LinearTransfer,
    [LinearSRGBColorSpace] = LinearTransfer,
    [SRGBColorSpace] = SRGBTransfer,
}

local warned = {}
local function transfer(cs)
    local t = transferOf[cs]
    if t == nil then
        if not warned[cs] then
            warned[cs] = true
            -- @diagnostic disable-next-line: undefined-global
            if log then
                log:Write(LOG_WARNING, "ColorManagement: unsupported color space '" .. tostring(cs)
                    .. "', treated as linear (engine working space is Linear-sRGB / Rec709)")
            end
        end
        return LinearTransfer
    end
    return t
end

-- 空字符串(NoColorSpace) / nil 视为 falsy（对标 three.js 里 '' 为假值 → convert 直接早退）
local function falsy(cs) return cs == nil or cs == NoColorSpace end

function CM.getTransfer(cs)
    if cs == NoColorSpace then return LinearTransfer end
    return transfer(cs)
end

-- convert(color, src, dst)：就地转换 color.r/g/b（与 three.js convert 同逻辑）。
-- enabled=false / src==dst / 任一为 NoColorSpace 或 nil → 直通；
-- 否则按 src/dst 的 transfer 做 sRGB↔linear。仅 Rec709 系空间，省略 primaries 色域矩阵步骤。
function CM.convert(color, src, dst)
    if (not CM.enabled) or src == dst or falsy(src) or falsy(dst) then return color end
    if transfer(src) == SRGBTransfer then
        color.r = SRGBToLinear(color.r); color.g = SRGBToLinear(color.g); color.b = SRGBToLinear(color.b)
    end
    if transfer(dst) == SRGBTransfer then
        color.r = LinearToSRGB(color.r); color.g = LinearToSRGB(color.g); color.b = LinearToSRGB(color.b)
    end
    return color
end

function CM.colorSpaceToWorking(color, src) return CM.convert(color, src, CM.workingColorSpace) end
function CM.workingToColorSpace(color, dst) return CM.convert(color, CM.workingColorSpace, dst) end

return CM
