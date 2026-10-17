-- ============================================================================
-- urhox-libs/3D · Sprite
-- three.js Sprite(material)：永远朝相机的 2D 贴图/色块。Object3D + BillboardSet(单 billboard)。
--   - SetFaceCameraMode(FC_ROTATE_XYZ)：屏幕对齐朝相机
--   - SetScaled(true) + billboard.size=(0.5,0.5)：sprite.scale(=node.scale) 直接作世界尺寸
--   - SetRelative(true)：billboard 跟随节点位置
--   - sizeAttenuation=false → SetFixedScreenSize(true)（恒屏幕大小）
-- center 锚点：映射到 billboard.anchor（引擎 C++ 在四角偏移实现，见 BillboardSet）。
-- 已知降级：动态改 material.rotation 后需重设 material 触发刷新（不逐帧追踪）。
-- ============================================================================

local NativeVector3 = Vector3 -- 引擎原生构造器，在 require 遮蔽前捕获
local NativeVector2 = Vector2
local NativeColor = Color

local Object3D = require("urhox-libs/3D/Core/Object3D")
local Vec2 = require("urhox-libs/3D/Core/Vector2")

local RAD2DEG = 180 / math.pi

local Sprite = {}
local methods = {}

local function nativeOf(m) return m and m.getNative and m:getNative() or nil end

-- 把 material 的 rotation / sizeAttenuation 应用到 billboard 并 Commit
local function applyFromMaterial(self)
    local bs = rawget(self, "_bs")
    local m = rawget(self, "_material")
    local b = bs:GetBillboard(0)
    b.rotation = (m and m.rotation or 0) * RAD2DEG
    bs:SetFixedScreenSize(m and m.sizeAttenuation == false or false)
    bs:Commit()
end

-- 把 center 锚点映射到 billboard.anchor（引擎按 half-extent 单位偏移四角）。
-- three.js: center(0.5,0.5)=居中→anchor(0,0)；center(0.5,0)=底锚→sprite 在 position 上方。
local function applyCenter(self)
    local c = rawget(self, "_center")
    local bs = rawget(self, "_bs")
    local b = bs:GetBillboard(0)
    if b.anchor ~= nil then -- 引擎已支持（重编后）
        b.anchor = NativeVector2((0.5 - c.x) * 2, (0.5 - c.y) * 2)
        bs:Commit()
    end
end

local function sget(self, k)
    if k == "isSprite" then return true end
    if k == "type" then return "Sprite" end
    if k == "material" then return rawget(self, "_material") end
    if k == "center" then return rawget(self, "_center") end
    return nil
end

local function sset(self, k, v)
    if k == "material" then
        rawset(self, "_material", v)
        local native = nativeOf(v)
        if native then rawget(self, "_bs"):SetMaterial(native) end
        applyFromMaterial(self)
        return true
    end
    if k == "center" then rawset(self, "_center", v); applyCenter(self); return true end
    return false
end

local mt = Object3D.makeMeta(methods, sget, sset)

function Sprite.new(material)
    local self = setmetatable({}, mt)
    Object3D.setup(self)
    local node = self:getNode()
    local bs = node:CreateComponent("BillboardSet")
    bs:SetNumBillboards(1)
    bs:SetRelative(true)
    bs:SetScaled(true) -- 节点 scale 缩放 billboard → 映射 sprite.scale
    bs:SetFaceCameraMode(FC_ROTATE_XYZ)
    rawset(self, "_bs", bs)
    rawset(self, "_material", material)
    rawset(self, "_center", Vec2.new(0.5, 0.5))

    local b = bs:GetBillboard(0)
    b.position = NativeVector3(0, 0, 0)
    b.size = NativeVector2(0.5, 0.5) -- 配合 SetScaled：scale=1 → 1×1 世界单位
    b.uv = Rect(0, 0, 1, 1)
    b.color = NativeColor(1, 1, 1, 1)
    b.enabled = true
    local native = nativeOf(material)
    if native then bs:SetMaterial(native) end
    applyFromMaterial(self)
    applyCenter(self)
    return self
end

function methods:getBillboardSet() return rawget(self, "_bs") end

return Sprite
