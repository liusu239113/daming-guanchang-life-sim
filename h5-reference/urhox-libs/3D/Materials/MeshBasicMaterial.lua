-- ============================================================================
-- urhox-libs/3D · MeshBasicMaterial
-- three.js MeshBasicMaterial({color, map, side, opacity, transparent, wireframe})。
-- 不受光（unlit）→ NoTextureUnlit / DiffUnlit（AGENTS.md 规则 #9.4）。
--
-- 运行时可变（three.js 语义）：mat.color/opacity/map/... 直接改即生效。
-- 标量/颜色走轻量 setter；map 增减、transparent 翻转走 rebuild（重选技术 + 重绑）。
-- ============================================================================

local Convert = require("urhox-libs/3D/Core/Convert")
local Color = require("urhox-libs/3D/Core/Color")

local M = {}
local methods = {}

local function asColor(v)
    if type(v) == "table" and v.clone and v.setHex then return v end
    return Color.new(v)
end

local function sideToCull(side)
    if side == "double" or side == 2 then return CULL_NONE end
    if side == "back" or side == 1 then return CULL_CCW end
    return CULL_CW -- front / 默认（RH 绕序）
end

local function isAlpha(p)
    return p.transparent == true or (p.opacity ~= nil and p.opacity < 1)
end

-- 暂未支持（接口暴露但 no-op，见 docs/design/threejs-3d-api-design.md §6.3）
local UNSUPPORTED = {
    alphaMap = "无独立 alpha 贴图槽",
    envMap = "环境贴图是 Zone 级，归 Phase 2",
    alphaTest = "引擎 Mask 变体测 spec.a 而非 diffuse.a，语义待对齐",
}
local function warnUnsupported(k)
    log:Write(LOG_ERROR, "MeshBasicMaterial: 属性 '" .. k .. "' 暂未支持（" ..
        UNSUPPORTED[k] .. "），已忽略。见 docs/design/threejs-3d-api-design.md §6.3")
end

local function applyDiffColor(self)
    local p = self.props
    local c = Convert.color(p.color or 0xffffff, p.opacity ~= nil and p.opacity or 1.0)
    self._mat:SetShaderParameter("MatDiffColor", Variant(c))
end

local function applyUV(self)
    local map = self.props.map
    if map then
        local rp = map.repeat_ or { x = 1, y = 1 }
        local of = map.offset or { x = 0, y = 0 }
        -- 用 SetUVTransform 一并带上旋转（rotation；center 引擎隐式 0.5）
        self._mat:SetUVTransform(Vector2(of.x, of.y), map.rotation or 0, Vector2(rp.x, rp.y))
    end
end

local function applySide(self)
    self._mat:SetCullMode(sideToCull(self.props.side))
end

local function applyWireframe(self)
    if self._mat.SetFillMode then
        self._mat:SetFillMode(self.props.wireframe and FILL_WIREFRAME or FILL_SOLID)
    end
end

-- 结构性：技术变体 + 贴图（map 增减 / alpha 翻转时重做）
local function applyTechniqueAndTexture(self)
    local p = self.props
    local mat = self._mat
    local alpha = isAlpha(p)
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
    applyUV(self)
    applySide(self)
    applyWireframe(self)
end

local function setOpacity(self)
    if isAlpha(self.props) ~= rawget(self, "_alpha") then
        rebuild(self)
    else
        applyDiffColor(self)
    end
end

local function bindColorProp(self, key, applyFn)
    local c = asColor(self.props[key])
    c._onChange = function() applyFn(self) end
    self.props[key] = c
    return c
end
local function setColor(self) bindColorProp(self, "color", applyDiffColor); applyDiffColor(self) end

local setters = {
    color = setColor,
    opacity = setOpacity,
    transparent = rebuild,
    side = applySide,
    wireframe = applyWireframe,
    map = rebuild,
    needsUpdate = function(self, v) if v then rebuild(self) end end,
}

local mt = {
    __index = function(self, k)
        if k == "isMeshBasicMaterial" or k == "isMaterial" then return true end
        if k == "type" then return "MeshBasicMaterial" end
        return methods[k] or rawget(self, "props")[k]
    end,
    __newindex = function(self, k, v)
        rawget(self, "props")[k] = v
        if UNSUPPORTED[k] then warnUnsupported(k) return end
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
    bindColorProp(self, "color", applyDiffColor) -- color 必是 Color 对象（缺省白）
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
