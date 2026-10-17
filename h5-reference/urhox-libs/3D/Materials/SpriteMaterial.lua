-- ============================================================================
-- urhox-libs/3D · SpriteMaterial
-- three.js SpriteMaterial({color, map, rotation, sizeAttenuation, opacity, transparent})。
-- 不受光（unlit）→ DiffUnlit / NoTextureUnlit。供 Sprite（BillboardSet）用。
-- rotation/sizeAttenuation 仅存值，由 Sprite 应用到 billboard。
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

local function applyDiffColor(self)
    local p = self.props
    local c = Convert.color(p.color or 0xffffff, p.opacity ~= nil and p.opacity or 1.0)
    self._mat:SetShaderParameter("MatDiffColor", Variant(c))
end

local function applyTechniqueAndTexture(self)
    local p = self.props
    local mat = self._mat
    local alpha = isAlpha(p) or (p.map ~= nil) -- sprite 带图常需 alpha 混合
    local tech
    if p.map then
        tech = alpha and "Techniques/DiffUnlitAlpha.xml" or "Techniques/DiffUnlit.xml"
    else
        tech = alpha and "Techniques/NoTextureUnlitAlpha.xml" or "Techniques/NoTextureUnlit.xml"
    end
    mat:SetTechnique(0, cache:GetResource("Technique", tech))
    if p.map then
        p.map:onReady(function(native)
            if not native then return end
            if native.SetSRGB then native:SetSRGB(true) end
            mat:SetTexture(TU_DIFFUSE, native)
        end)
    end
    rawset(self, "_alpha", alpha)
end

local function rebuild(self)
    applyTechniqueAndTexture(self)
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
    map = rebuild,
    needsUpdate = function(self, v) if v then rebuild(self) end end,
    -- rotation / sizeAttenuation：存值即可（由 Sprite 读取应用到 billboard）
}

local mt = {
    __index = function(self, k)
        if k == "isSpriteMaterial" or k == "isMaterial" then return true end
        if k == "type" then return "SpriteMaterial" end
        return methods[k] or rawget(self, "props")[k]
    end,
    __newindex = function(self, k, v)
        rawget(self, "props")[k] = v
        local s = setters[k]
        if s then s(self, v) end
    end,
}

function M.new(opts)
    opts = opts or {}
    local self = setmetatable({}, mt)
    rawset(self, "_mat", Material:new())
    rawset(self, "_alpha", false)
    local props = { sizeAttenuation = true, rotation = 0 }
    for k, v in pairs(opts) do props[k] = v end
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
