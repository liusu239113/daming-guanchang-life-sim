-- ============================================================================
-- urhox-libs/3D · LightCommon（内部）
-- 所有 three.js 灯共有的属性路由：color/intensity/castShadow/shadow/target/visible。
-- 各灯文件用 Object3D.makeMeta(子方法, 自己的 get(回落 LC.get), LC.set) 组装。
-- ============================================================================

local NativeVector3 = Vector3 -- 引擎原生构造器，在下行 require 遮蔽前捕获
local Object3D = require("urhox-libs/3D/Core/Object3D")
local Color = require("urhox-libs/3D/Core/Color")
local Convert = require("urhox-libs/3D/Core/Convert")
local LightShadow = require("urhox-libs/3D/Lights/LightShadow")
local Vec3 = require("urhox-libs/3D/Core/Vector3")

local LC = {}

local function isColorObj(v) return type(v) == "table" and v.clone and v.setHex end

-- 把 color 绑成 Color 对象：onChange → 写 native light.color
local function bindColor(self, light, v)
    local c = isColorObj(v) and v or Color.new(v == nil and 0xffffff or v)
    c._onChange = function() light.color = Convert.color(c) end
    light.color = Convert.color(c)
    rawset(self, "_color", c)
    return c
end

-- 创建 Light 组件 + 绑定 color/intensity 活属性（各灯构造里调）
function LC.setupLight(self, lightType, color, intensity)
    Object3D.setup(self)
    local light = self:getNode():CreateComponent("Light")
    light.lightType = lightType
    light.brightness = intensity or 1.0
    rawset(self, "_light", light)
    rawset(self, "_castShadow", false)
    bindColor(self, light, color)
    return light
end

-- 重新瞄准：让 light 节点 +Z 指向 target 的世界位置
-- （对标 three.js：方向由 light 与 target 的世界矩阵共同决定）
function LC.reaim(self)
    local t = rawget(self, "_target")
    if not t then return end
    local wp = t:getNode().worldPosition
    self:lookAt(wp.x, wp.y, wp.z)
end

-- 为 DirectionalLight/SpotLight 初始化默认 target（three.js 默认 target 在原点）。
-- 包裹 target.position 与 light.position：任一变化都重新瞄准，使
-- `light.target.position:set(...)` 与移动光源都能正确更新方向。
function LC.initTarget(self)
    local target = Object3D.new()
    rawset(self, "_target", target)

    local tn = target:getNode()
    rawset(target, "_position", Vec3.bound(
        function() local p = tn.position; return p.x, p.y, p.z end,
        function(_, x, y, z) tn.position = NativeVector3(x, y, z); LC.reaim(self) end
    ))

    local ln = self:getNode()
    rawset(self, "_position", Vec3.bound(
        function() local p = ln.position; return p.x, p.y, p.z end,
        function(_, x, y, z) ln.position = NativeVector3(x, y, z); LC.reaim(self) end
    ))

    LC.reaim(self) -- 默认瞄准原点
end

-- 共有属性读
function LC.get(self, k)
    if k == "isLight" then return true end
    local light = rawget(self, "_light")
    if k == "color" then return rawget(self, "_color") end
    if k == "intensity" then return light.brightness end
    if k == "castShadow" then return rawget(self, "_castShadow") and true or false end
    if k == "shadow" then
        local s = rawget(self, "_shadow")
        if not s then s = LightShadow.new(light); rawset(self, "_shadow", s) end
        return s
    end
    if k == "target" then return rawget(self, "_target") end
    if k == "dispose" then return LC.dispose end
    return nil
end

-- three.js dispose：释放灯光。移除底层 Light 组件并脱离父节点；幂等。
function LC.dispose(self)
    if rawget(self, "_disposed") then return self end
    rawset(self, "_disposed", true)
    local light = rawget(self, "_light")
    if light and light.Remove then light:Remove() end
    rawset(self, "_light", nil)
    if self.removeFromParent then self:removeFromParent() end
    return self
end

-- 共有属性写（返回 true 表示已处理）
function LC.set(self, k, v)
    local light = rawget(self, "_light")
    if k == "color" then bindColor(self, light, v); return true end
    if k == "intensity" then light.brightness = v; return true end
    if k == "castShadow" then
        rawset(self, "_castShadow", v and true or false)
        if light.SetCastShadows then light:SetCastShadows(v and true or false) end
        return true
    end
    if k == "target" then
        rawset(self, "_target", v)
        LC.reaim(self)
        return true
    end
    return false
end

return LC
