-- ============================================================================
-- urhox-libs/3D · Group
-- three.js Group：纯容器 Object3D（语义等同 Object3D，仅多 isGroup 标志）。
-- ============================================================================

local Object3D = require("urhox-libs/3D/Core/Object3D")

local Group = {}

local function gget(_, k)
    if k == "isGroup" then return true end
    if k == "type" then return "Group" end
    return nil
end

local mt = Object3D.makeMeta({}, gget, nil)

function Group.new()
    local self = setmetatable({}, mt)
    Object3D.setup(self)
    return self
end

return Group
