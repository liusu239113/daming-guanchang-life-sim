-- ============================================================================
-- urhox-libs/3D · Renderer / WebGLRenderer
-- three.js WebGLRenderer。UrhoX 是保留模式：构造时建 Viewport + SetViewport，
-- 引擎自动每帧渲染。故 :render() 空操作；:setAnimationLoop(fn) → 每帧回调（§5.5）。
--
-- ⚠️ 事件订阅必须走 Node + ScriptObject 的 scoped 订阅（仿 UI 库），
--    不能用全局 SubscribeToEvent——否则会被外部全局 Update 订阅顶掉（Urho Lua
--    全局事件每类型仅一个 handler）。
-- ============================================================================

local Environment = require("urhox-libs/3D/Core/Environment")

local R = {}
local methods = {}
local mt = {
    __index = methods,
    __newindex = function(self, k, v)
        rawset(self, k, v)
        -- three.js 渲染器后效 → 唯一环境 Zone（Core/Environment）
        if k == "toneMapping" then
            Environment.setPost("tonemap", v ~= nil and v ~= 0) -- NoToneMapping=0；其余(含 ACES) → tonemap LUT
        elseif k == "toneMappingExposure" then
            -- UrhoX 无固定曝光标量（只有直方图自动曝光）。>1 视为需要更亮 → 暂存，效果近似留待后续。
            -- 这里不强行开 autoExposure，避免与美术意图冲突。
        end
    end,
}

function R.new(opts)
    opts = opts or {}
    local self = setmetatable({}, mt)
    -- three.js renderer.shadowMap.enabled → 引擎 Renderer:SetDrawShadows。默认开（three.js 场景
    -- 设了 castShadow 即期望出阴影）；可 renderer.shadowMap.enabled=false 关。
    if renderer.SetDrawShadows then
        renderer:SetDrawShadows(true)
        if renderer.SetShadowMapSize then renderer:SetShadowMapSize(2048) end
    end
    rawset(self, "shadowMap", setmetatable({ enabled = true }, {
        __newindex = function(t, k, v)
            rawset(t, k, v)
            if k == "enabled" and renderer.SetDrawShadows then renderer:SetDrawShadows(v and true or false) end
        end,
    }))
    local sceneObj, cameraObj = opts.scene, opts.camera
    if sceneObj and cameraObj then
        self:setSceneCamera(sceneObj, cameraObj)
    end
    return self
end

function methods:setSceneCamera(sceneObj, cameraObj)
    local cam = cameraObj:getNode():GetComponent("Camera")
    local vp = Viewport:new(sceneObj:getNode(), cam)
    renderer:SetViewport(0, vp) -- 全局 Renderer 子系统
    rawset(self, "_vp", vp)
    return self
end

-- 保留模式下空操作（引擎已自动渲染）；保 API 形状
function methods:render() end

-- three.js 每帧回调。走 scoped 订阅，避免被外部全局 Update 顶掉。
-- 再次调用会替换上一个 loop（同 three.js 语义）。
function methods:setAnimationLoop(fn)
    -- 懒创建独立的事件 Node + ScriptObject（隔离订阅）
    if not rawget(self, "_evtObj") then
        local node = Node()
        rawset(self, "_evtNode", node)
        rawset(self, "_evtObj", node:CreateScriptObject("LuaScriptObject"))
    end
    local obj = rawget(self, "_evtObj")

    if not fn then
        obj:UnsubscribeFromEvent("Update")
        return
    end
    -- scoped 回调签名：function(self, eventType, eventData)
    obj:SubscribeToEvent("Update", function(_, _, eventData)
        fn(eventData["TimeStep"]:GetFloat())
    end)
end

-- 清理（three.js 无对应；释放事件 Node）
function methods:dispose()
    local node = rawget(self, "_evtNode")
    if node then node:Remove(); rawset(self, "_evtNode", nil); rawset(self, "_evtObj", nil) end
end

return R
