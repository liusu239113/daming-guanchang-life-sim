-- ============================================================================
-- urhox-libs/3D · AsyncLoader（内部）
-- 基于引擎 cache:GetResourceAsyncEx：原地返回非空占位 Resource 指针(立即可用)，
-- 真内容异步加载并原地热替换(DWP 下载 / 本地后台 reload，与 DWP 下 GetResource 一致)。
-- 指针稳定 → 调用方一次性绑定即可；onLoad(真内容到达)走主线程事件，缓存命中立即触发。
-- ============================================================================

local AsyncLoader = {}

local pending = {}     -- pending[name] = { onLoad=, onError= }
local evtNode, evtObj

local function ensureSubscribed()
    if evtObj then return end
    evtNode = Node()
    evtObj = evtNode:CreateScriptObject("LuaScriptObject")
    -- ResourceBackgroundLoaded：后台加载 / 占位热替换(reload) 完成时主线程恒发，带 ResourceName + Success
    evtObj:SubscribeToEvent("ResourceBackgroundLoaded", function(_, _, data)
        local nameVar = data["ResourceName"]
        if not nameVar then return end
        local name = nameVar:GetString()
        local p = pending[name]
        if not p then return end
        local ok = (data["Success"] == nil) or data["Success"]:GetBool()
        pending[name] = nil
        if ok then
            if p.onLoad then p.onLoad() end
        elseif p.onError then
            p.onError(name)
        end
    end)
end

-- 立即返回非空占位 Resource(或缓存的真资源)；真内容到达时触发 onLoad。
function AsyncLoader.load(type, name, onLoad, onError)
    local res = cache:GetResourceAsyncEx(type, name)
    if not res then
        if onError then onError(name) end
        return nil
    end
    ensureSubscribed()
    -- 已有真资源(非占位)时事件不会再发；这里统一登记，占位热替换完成会触发，
    -- 缓存命中场景由调用方拿到 res 即可用（native 立即有效）。
    pending[name] = { onLoad = onLoad, onError = onError }
    return res
end

return AsyncLoader
