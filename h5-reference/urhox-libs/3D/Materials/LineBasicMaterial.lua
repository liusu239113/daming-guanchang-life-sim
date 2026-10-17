-- ============================================================================
-- urhox-libs/3D · LineBasicMaterial
-- three.js LineBasicMaterial({color, opacity, transparent, vertexColors, linewidth})。
-- 不受光（unlit）→ NoTextureUnlit / NoTextureUnlitVCol。供 Line/LineSegments/LineLoop 用。
--
-- 已知降级：`linewidth` 在 BGFX/WebGL 下线宽恒 1px（与 three.js 实际表现一致），存值不报错。
-- ============================================================================

local Convert = require("urhox-libs/3D/Core/Convert")
local Color = require("urhox-libs/3D/Core/Color")

local M = {}
local methods = {}

local function asColor(v)
    if type(v) == "table" and v.clone and v.setHex then return v end
    return Color.new(v)
end

local function isAlpha(p)
    return p.transparent == true or (p.opacity ~= nil and p.opacity < 1)
end

-- 暂未支持（接口暴露但 no-op）
local UNSUPPORTED = {
    map = "线材质暂不支持纹理",
    linewidth = "BGFX/WebGL 线宽恒 1px（与 three.js 实际一致）",
    fog = "雾是 Zone 级",
    dashed = "暂未支持虚线（需 LineDashedMaterial）",
}
local function warnUnsupported(k)
    -- linewidth/fog 是常见无害属性，仅 dashed/map 这类才告警
    if k == "map" or k == "dashed" then
        log:Write(LOG_ERROR, "LineBasicMaterial: 属性 '" .. k .. "' 暂未支持（" .. UNSUPPORTED[k] .. "），已忽略。")
    end
end

local function applyDiffColor(self)
    local p = self.props
    local c = Convert.color(p.color or 0xffffff, p.opacity ~= nil and p.opacity or 1.0)
    self._mat:SetShaderParameter("MatDiffColor", Variant(c))
end

local function applyTechnique(self)
    local p = self.props
    local alpha = isAlpha(p)
    local tech
    if p.vertexColors then
        tech = "Techniques/NoTextureUnlitVCol.xml" -- 顶点色（无独立 alpha 变体，alpha 由顶点色 a 通道带）
    else
        tech = alpha and "Techniques/NoTextureUnlitAlpha.xml" or "Techniques/NoTextureUnlit.xml"
    end
    self._mat:SetTechnique(0, cache:GetResource("Technique", tech))
    rawset(self, "_alpha", alpha)
end

local function rebuild(self)
    applyTechnique(self)
    applyDiffColor(self)
end

local function setOpacity(self)
    if isAlpha(self.props) ~= rawget(self, "_alpha") then rebuild(self) else applyDiffColor(self) end
end

local function bindColorProp(self)
    local c = asColor(self.props.color)
    c._onChange = function() applyDiffColor(self) end
    self.props.color = c
    return c
end

local setters = {
    color = function(self) bindColorProp(self); applyDiffColor(self) end,
    opacity = setOpacity,
    transparent = rebuild,
    vertexColors = rebuild,
    needsUpdate = function(self, v) if v then rebuild(self) end end,
}

local mt = {
    __index = function(self, k)
        if k == "isLineBasicMaterial" or k == "isMaterial" then return true end
        if k == "type" then return "LineBasicMaterial" end
        return methods[k] or rawget(self, "props")[k]
    end,
    __newindex = function(self, k, v)
        rawget(self, "props")[k] = v
        if UNSUPPORTED[k] then warnUnsupported(k); return end
        local s = setters[k]
        if s then s(self, v) end
    end,
}

function M.new(opts)
    opts = opts or {}
    local self = setmetatable({}, mt)
    rawset(self, "_mat", Material:new())
    rawset(self, "_alpha", false)
    local props = {}
    for k, v in pairs(opts) do
        props[k] = v
        if UNSUPPORTED[k] then warnUnsupported(k) end
    end
    rawset(self, "props", props)
    bindColorProp(self)
    rebuild(self)
    return self
end

function methods:clone()
    local opts = {}
    for k, v in pairs(rawget(self, "props")) do
        if type(v) == "table" and v.clone and v.setHex then opts[k] = v:clone() else opts[k] = v end
    end
    return M.new(opts)
end
function methods:copy(src)
    local c = src:clone()
    rawset(self, "_mat", rawget(c, "_mat")); rawset(self, "props", rawget(c, "props"))
    return self
end
function methods:dispose() rawset(self, "_mat", nil); return self end

function methods:getNative() return rawget(self, "_mat") end

return M
