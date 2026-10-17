-- ============================================================================
-- urhox-libs/3D · OrthographicCamera
-- three.js OrthographicCamera(left, right, top, bottom, near, far)。Object3D + Camera。
-- 映射：orthoSize = top-bottom（垂直世界高度），aspectRatio = (right-left)/(top-bottom)，
-- zoom 同步原生 cam.zoom；非对称（离轴）frustum 用 projectionOffset 移回中心。
-- left/right/top/bottom/near/far/zoom 运行时可读写（改后即时重算原生参数）。
--
-- 投影/世界矩阵按 three.js 语义自行合成（Matrix4:makeOrthographic，WebGL NDC），
-- 供 Vector3.project/unproject 使用，不读引擎 D3D 投影。
-- ============================================================================

local Object3D = require("urhox-libs/3D/Core/Object3D")
local Matrix4 = require("urhox-libs/3D/Core/Matrix4")

local OC = {}
local ocMethods = {}

-- 把当前 frustum 写入原生 Camera（渲染用）
local function applyNative(self)
    local cam = rawget(self, "_cam")
    local l, r = rawget(self, "left"), rawget(self, "right")
    local t, b = rawget(self, "top"), rawget(self, "bottom")
    local width, height = r - l, t - b
    cam.orthographic = true
    cam.orthoSize = height
    cam.aspectRatio = width / height
    cam.autoAspectRatio = false
    cam.zoom = rawget(self, "zoom")
    cam.nearClip = rawget(self, "near")
    cam.farClip = rawget(self, "far")
    local cx, cy = (l + r) * 0.5, (t + b) * 0.5
    if cx ~= 0 or cy ~= 0 then
        cam.projectionOffset = Vector2(-cx / width, -cy / height)
    elseif cam.projectionOffset ~= nil then
        cam.projectionOffset = Vector2(0, 0)
    end
end

-- 合成 three.js 正交投影矩阵（本库 Matrix4，WebGL NDC）
local function computeProjection(self)
    local l, r = rawget(self, "left"), rawget(self, "right")
    local t, b = rawget(self, "top"), rawget(self, "bottom")
    local zoom = rawget(self, "zoom")
    local dx = (r - l) / (2 * zoom)
    local dy = (t - b) / (2 * zoom)
    local cx, cy = (r + l) / 2, (t + b) / 2
    local left, right = cx - dx, cx + dx
    local top, bottom = cy + dy, cy - dy
    local view = rawget(self, "_view")
    if view and view.enabled then
        local scaleW = (r - l) / view.fullWidth / zoom
        local scaleH = (t - b) / view.fullHeight / zoom
        left = left + scaleW * view.offsetX
        right = left + scaleW * view.width
        top = top - scaleH * view.offsetY
        bottom = top - scaleH * view.height
    end
    return Matrix4.new():makeOrthographic(left, right, top, bottom, rawget(self, "near"), rawget(self, "far"))
end

local function computeMatrixWorld(self)
    return Matrix4.new():compose(self:getWorldPosition(), self:getWorldQuaternion(), self:getWorldScale())
end

-- ---- 缓存：投影按 l/r/t/b/near/far/zoom/view、世界矩阵按节点 PRS，变了才重建 -------
local function getProjCache(self)
    local sig = rawget(self, "left") .. "|" .. rawget(self, "right") .. "|" .. rawget(self, "top") .. "|"
        .. rawget(self, "bottom") .. "|" .. rawget(self, "near") .. "|" .. rawget(self, "far") .. "|"
        .. rawget(self, "zoom")
    local c = rawget(self, "_projCache")
    if c and c.sig == sig and c.view == rawget(self, "_view") then return c end
    local proj = computeProjection(self)
    c = { sig = sig, view = rawget(self, "_view"), proj = proj, projInv = proj:clone():invert() }
    rawset(self, "_projCache", c)
    return c
end

local function getWorldCache(self)
    local node = rawget(self, "_node")
    local p, r, s = node.worldPosition, node.worldRotation, node.worldScale
    local c = rawget(self, "_worldCache")
    if c and c.px == p.x and c.py == p.y and c.pz == p.z
        and c.qx == r.x and c.qy == r.y and c.qz == r.z and c.qw == r.w
        and c.sx == s.x and c.sy == s.y and c.sz == s.z then
        return c
    end
    local world = computeMatrixWorld(self)
    c = { px = p.x, py = p.y, pz = p.z, qx = r.x, qy = r.y, qz = r.z, qw = r.w,
        sx = s.x, sy = s.y, sz = s.z, world = world, worldInv = world:clone():invert() }
    rawset(self, "_worldCache", c)
    return c
end

local function get(self, k)
    if k == "isCamera" or k == "isOrthographicCamera" then return true end
    if k == "coordinateSystem" then return Matrix4.WebGLCoordinateSystem end
    if k == "left" or k == "right" or k == "top" or k == "bottom"
        or k == "near" or k == "far" or k == "zoom" then return rawget(self, k) end
    if k == "view" then return rawget(self, "_view") end
    if k == "projectionMatrix" then return getProjCache(self).proj end
    if k == "projectionMatrixInverse" then return getProjCache(self).projInv end
    if k == "matrixWorld" then return getWorldCache(self).world end
    if k == "matrixWorldInverse" then return getWorldCache(self).worldInv end
    return nil
end

local function set(self, k, v)
    if k == "left" or k == "right" or k == "top" or k == "bottom"
        or k == "near" or k == "far" or k == "zoom" then
        rawset(self, k, v)
        applyNative(self)
        return true
    end
    return false
end

function ocMethods:setViewOffset(fullWidth, fullHeight, x, y, width, height)
    rawset(self, "_view", {
        enabled = true, fullWidth = fullWidth, fullHeight = fullHeight,
        offsetX = x, offsetY = y, width = width, height = height,
    })
    return self
end
function ocMethods:clearViewOffset()
    rawset(self, "_view", nil)
    return self
end
function ocMethods:updateProjectionMatrix() applyNative(self); return self end
function ocMethods:getCamera() return rawget(self, "_cam") end

local mt = Object3D.makeMeta(ocMethods, get, set)

function OC.new(left, right, top, bottom, near, far)
    local self = setmetatable({}, mt)
    Object3D.setup(self)
    rawset(self, "_lookInverted", true) -- 相机看 -Z（three.js lookAt 相机约定）
    local cam = self:getNode():CreateComponent("Camera")
    cam.handedness = HANDEDNESS_RH -- 只把本相机设为右手系
    rawset(self, "_cam", cam)
    rawset(self, "left", left or -1)
    rawset(self, "right", right or 1)
    rawset(self, "top", top or 1)
    rawset(self, "bottom", bottom or -1)
    rawset(self, "near", near or 0.1)
    rawset(self, "far", far or 2000.0)
    rawset(self, "zoom", 1)
    applyNative(self)
    return self
end

return OC
