-- ============================================================================
-- urhox-libs/3D · OrbitControls
-- three.js examples/jsm/controls/OrbitControls。绕 target 的球坐标轨道相机：
-- 左拖旋转 / 滚轮缩放 / 右拖(或中拖)平移。支持 target / min-maxDistance / min-maxPolarAngle /
-- min-maxAzimuthAngle / enableDamping+dampingFactor / autoRotate / enableZoom/Rotate/Pan。
-- update() 每帧调用（damping/autoRotate 必需）。映射 UrhoX 鼠标输入（scoped 订阅）。
-- ============================================================================

local Vector3 = require("urhox-libs/3D/Core/Vector3")

local OC = {}
local methods = {}
local mt = { __index = methods, __newindex = function(self, k, v) rawset(self, k, v) end }

local INF = math.huge
local EPS = 1e-6

local function getInput() return (GetInput and GetInput()) or _G.input end

function OC.new(object, domElement)
    local self = setmetatable({}, mt)
    rawset(self, "object", object)
    rawset(self, "domElement", domElement)
    -- three.js 默认参数
    self.enabled = true
    self.target = Vector3.new(0, 0, 0)
    self.minDistance = 0; self.maxDistance = INF
    self.minPolarAngle = 0; self.maxPolarAngle = math.pi
    self.minAzimuthAngle = -INF; self.maxAzimuthAngle = INF
    self.enableDamping = false; self.dampingFactor = 0.05
    self.enableZoom = true; self.zoomSpeed = 1.0
    self.enableRotate = true; self.rotateSpeed = 1.0
    self.enablePan = true; self.panSpeed = 1.0
    self.autoRotate = false; self.autoRotateSpeed = 2.0

    -- 内部球坐标（相对 target）：radius/theta(方位,绕Y)/phi(极角,自+Y)
    local cam = object.position
    local ox, oy, oz = cam.x - self.target.x, cam.y - self.target.y, cam.z - self.target.z
    local r = math.sqrt(ox * ox + oy * oy + oz * oz)
    if r < EPS then r = 1 end
    rawset(self, "_radius", r)
    rawset(self, "_theta", math.atan(ox, oz))
    rawset(self, "_phi", math.acos(math.max(-1, math.min(1, oy / r))))
    -- 累积增量（事件处理里累加，update 里消费）
    rawset(self, "_dTheta", 0); rawset(self, "_dPhi", 0); rawset(self, "_dRadiusScale", 1)
    rawset(self, "_panX", 0); rawset(self, "_panY", 0)

    self:_bindInput()
    self:update()
    return self
end

function methods:_bindInput()
    local node = Node()
    rawset(self, "_evtNode", node)
    local obj = node:CreateScriptObject("LuaScriptObject")
    rawset(self, "_evtObj", obj)

    obj:SubscribeToEvent("MouseMove", function(_, _, data)
        if not self.enabled then return end
        local input = getInput()
        local dx = data["DX"] and data["DX"]:GetInt() or 0
        local dy = data["DY"] and data["DY"]:GetInt() or 0
        if input and input:GetMouseButtonDown(MOUSEB_LEFT) and self.enableRotate then
            -- three.js：方位/极角都按 像素/视口高度 比例旋转（与分辨率无关，对标 element.clientHeight）
            local h = (graphics and graphics.height) or 800
            rawset(self, "_dTheta", rawget(self, "_dTheta") - 2 * math.pi * dx / h * self.rotateSpeed)
            rawset(self, "_dPhi", rawget(self, "_dPhi") - 2 * math.pi * dy / h * self.rotateSpeed)
        elseif input and (input:GetMouseButtonDown(MOUSEB_RIGHT) or input:GetMouseButtonDown(MOUSEB_MIDDLE)) and self.enablePan then
            rawset(self, "_panX", rawget(self, "_panX") + dx)
            rawset(self, "_panY", rawget(self, "_panY") + dy)
        end
    end)

    obj:SubscribeToEvent("MouseWheel", function(_, _, data)
        if not self.enabled or not self.enableZoom then return end
        local w = data["Wheel"] and data["Wheel"]:GetInt() or 0
        local scale = 0.95 ^ self.zoomSpeed
        if w > 0 then
            rawset(self, "_dRadiusScale", rawget(self, "_dRadiusScale") * scale)      -- 滚上=拉近
        elseif w < 0 then
            rawset(self, "_dRadiusScale", rawget(self, "_dRadiusScale") / scale)
        end
    end)
end

-- 平移 target：在垂直于视线的平面内按屏幕 dx,dy 移动
local function applyPan(self)
    local px, py = rawget(self, "_panX"), rawget(self, "_panY")
    if px == 0 and py == 0 then return end
    local cam = self.object.position
    local vx, vy, vz = self.target.x - cam.x, self.target.y - cam.y, self.target.z - cam.z
    local vl = math.sqrt(vx * vx + vy * vy + vz * vz); if vl < EPS then return end
    vx, vy, vz = vx / vl, vy / vl, vz / vl
    -- right = normalize(cross(viewDir, worldUp))
    local rx, ry, rz = vy * 0 - vz * 1, vz * 0 - vx * 0, vx * 1 - vy * 0 -- cross(v,(0,1,0))=( -vz,0,vx )? 重算
    rx, ry, rz = vz, 0, -vx                                              -- cross((vx,vy,vz),(0,1,0)) = (vy*0-vz*1, vz*0-vx*0, vx*1-vy*0)=(-vz,0,vx)；取右手相机右向用 (vz,0,-vx)
    local rl = math.sqrt(rx * rx + rz * rz); if rl > EPS then rx, rz = rx / rl, rz / rl end
    -- camUp = cross(right, viewDir)
    local ux = ry * vz - rz * vy
    local uy = rz * vx - rx * vz
    local uz = rx * vy - ry * vx
    local scale = rawget(self, "_radius") * 0.002 * self.panSpeed
    -- 屏幕右移(dx>0) → target 左移；屏幕下移(dy>0) → target 上移
    local mx = (-px * rx + py * ux) * scale
    local my = (-px * ry + py * uy) * scale
    local mz = (-px * rz + py * uz) * scale
    self.target:set(self.target.x + mx, self.target.y + my, self.target.z + mz)
    rawset(self, "_panX", 0); rawset(self, "_panY", 0)
end

function methods:update()
    local damp = self.enableDamping and self.dampingFactor or 1.0

    -- autoRotate：每帧绕 Y 转一点（three.js 用固定步长近似）
    if self.autoRotate then
        rawset(self, "_dTheta", rawget(self, "_dTheta") - (2 * math.pi / 60 / 60) * self.autoRotateSpeed * 60 * 0.016)
    end

    rawset(self, "_theta", rawget(self, "_theta") + rawget(self, "_dTheta") * damp)
    rawset(self, "_phi", rawget(self, "_phi") + rawget(self, "_dPhi") * damp)
    rawset(self, "_radius", rawget(self, "_radius") * (1 + (rawget(self, "_dRadiusScale") - 1) * damp))

    -- 限制
    rawset(self, "_theta", math.max(self.minAzimuthAngle, math.min(self.maxAzimuthAngle, rawget(self, "_theta"))))
    rawset(self, "_phi", math.max(self.minPolarAngle + EPS, math.min(self.maxPolarAngle - EPS, rawget(self, "_phi"))))
    rawset(self, "_radius", math.max(self.minDistance, math.min(self.maxDistance, rawget(self, "_radius"))))

    applyPan(self)

    -- 球坐标 → 笛卡尔（相对 target）
    local r, theta, phi = rawget(self, "_radius"), rawget(self, "_theta"), rawget(self, "_phi")
    local sinPhi = math.sin(phi)
    local x = r * sinPhi * math.sin(theta)
    local y = r * math.cos(phi)
    local z = r * sinPhi * math.cos(theta)
    self.object.position:set(self.target.x + x, self.target.y + y, self.target.z + z)
    self.object:lookAt(self.target.x, self.target.y, self.target.z)

    -- 消费增量（damping 下保留衰减残量，否则清零）
    if self.enableDamping then
        rawset(self, "_dTheta", rawget(self, "_dTheta") * (1 - damp))
        rawset(self, "_dPhi", rawget(self, "_dPhi") * (1 - damp))
        rawset(self, "_dRadiusScale", 1 + (rawget(self, "_dRadiusScale") - 1) * (1 - damp))
    else
        rawset(self, "_dTheta", 0); rawset(self, "_dPhi", 0); rawset(self, "_dRadiusScale", 1)
    end
    return true
end

function methods:getDistance() return rawget(self, "_radius") end
function methods:getPolarAngle() return rawget(self, "_phi") end
function methods:getAzimuthalAngle() return rawget(self, "_theta") end
function methods:saveState() end
function methods:reset() end
function methods:dispose()
    local n = rawget(self, "_evtNode"); if n then n:Remove() end
end

return OC
