-- ============================================================================
-- urhox-libs/3D · Clock
-- 忠实复刻 three.js Clock：start/stop/getElapsedTime/getDelta + running/elapsedTime。
-- 时间源用引擎 time.elapsedTime（墙钟秒）。语义与 three.js 一致（autoStart 默认 true）。
-- ============================================================================

local Clock = {}
local methods = {}
local mt = { __index = methods }

local function now()
    -- @diagnostic disable-next-line: undefined-global
    if time then return time.elapsedTime end
    return 0
end

-- THREE.Clock(autoStart=true)
function Clock.new(autoStart)
    local self = setmetatable({}, mt)
    self.autoStart = autoStart ~= false -- 默认 true
    self.startTime = 0
    self.oldTime = 0
    self.elapsedTime = 0
    self.running = false
    return self
end

function methods:start()
    self.startTime = now()
    self.oldTime = self.startTime
    self.elapsedTime = 0
    self.running = true
end

function methods:stop()
    self:getElapsedTime()
    self.running = false
    self.autoStart = false
end

function methods:getElapsedTime()
    self:getDelta()
    return self.elapsedTime
end

function methods:getDelta()
    local diff = 0
    if self.autoStart and not self.running then
        self:start()
        return 0
    end
    if self.running then
        local newTime = now()
        diff = newTime - self.oldTime
        self.oldTime = newTime
        self.elapsedTime = self.elapsedTime + diff
    end
    return diff
end

return Clock
