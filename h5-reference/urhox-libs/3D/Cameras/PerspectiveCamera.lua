-- ============================================================================
-- urhox-libs/3D · PerspectiveCamera
-- three.js PerspectiveCamera(fov, aspect, near, far)。Object3D + Camera 组件。
-- aspect 默认交给视口自适应（autoAspectRatio），忽略传入值。
-- 运行时可变：camera.fov / near / far / zoom 直接改即生效。
--
-- 投影/世界矩阵（projectionMatrix / matrixWorldInverse 等）按 three.js 语义**自行合成**：
-- 用本库 Matrix4:makePerspective（WebGL NDC，z∈[-1,1]）从 fov/aspect/near/far/zoom 算，
-- 而非读引擎的 GetProjection（那是 D3D NDC depth 0..1）。这样 Vector3.project/unproject
-- 是 three.js 原式，无 NDC 歧义。matrixWorld 由 Object3D 世界变换 compose 得到。
-- ============================================================================

local Object3D = require("urhox-libs/3D/Core/Object3D")
local Matrix4 = require("urhox-libs/3D/Core/Matrix4")
local Vector3 = require("urhox-libs/3D/Core/Vector3")
local Vector2 = require("urhox-libs/3D/Core/Vector2")

local DEG2RAD = math.pi / 180
local RAD2DEG = 180 / math.pi

local PC = {}
local pcMethods = {}

-- 当前 aspect：优先引擎实时视口比例，未就绪（detached / 无 viewport）兜底 1
local function aspectOf(self)
    local a = rawget(self, "_cam").aspectRatio
    if not a or a <= 0 then return 1 end
    return a
end

-- 合成 three.js 透视投影矩阵（本库 Matrix4，WebGL NDC）
local function computeProjection(self)
    local cam = rawget(self, "_cam")
    local fov = cam.fov
    local near, far = cam.nearClip, cam.farClip
    local zoom = cam.zoom
    local aspect = aspectOf(self)
    local top = near * math.tan(DEG2RAD * 0.5 * fov) / zoom
    local height = 2 * top
    local width = aspect * height
    local left = -0.5 * width
    local view = rawget(self, "_view")
    if view and view.enabled then
        left = left + view.offsetX * width / view.fullWidth
        top = top - view.offsetY * height / view.fullHeight
        width = width * view.width / view.fullWidth
        height = height * view.height / view.fullHeight
    end
    local skew = rawget(self, "filmOffset") or 0
    if skew ~= 0 then
        local filmWidth = (rawget(self, "filmGauge") or 35) * math.min(aspect, 1)
        left = left + near * skew / filmWidth
    end
    return Matrix4.new():makePerspective(left, left + width, top, top - height, near, far)
end

-- 相机世界矩阵（compose 自 Object3D 世界 PRS；detached 也成立）
local function computeMatrixWorld(self)
    return Matrix4.new():compose(self:getWorldPosition(), self:getWorldQuaternion(), self:getWorldScale())
end

-- ---- 缓存：投影按输入签名、世界矩阵按节点 PRS 签名，变了才重建 -----------------
local function getProjCache(self)
    local cam = rawget(self, "_cam")
    local fov, near, far, zoom, aspect = cam.fov, cam.nearClip, cam.farClip, cam.zoom, aspectOf(self)
    local filmOff = rawget(self, "filmOffset") or 0
    local view = rawget(self, "_view")
    local c = rawget(self, "_projCache")
    if c and c.fov == fov and c.near == near and c.far == far and c.zoom == zoom
        and c.aspect == aspect and c.filmOff == filmOff and c.view == view then
        return c
    end
    local proj = computeProjection(self)
    c = { fov = fov, near = near, far = far, zoom = zoom, aspect = aspect, filmOff = filmOff, view = view,
        proj = proj, projInv = proj:clone():invert() }
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
    if k == "isCamera" or k == "isPerspectiveCamera" then return true end
    local cam = rawget(self, "_cam")
    if k == "fov" then return cam.fov end
    if k == "near" then return cam.nearClip end
    if k == "far" then return cam.farClip end
    if k == "aspect" then return cam.aspectRatio end
    if k == "zoom" then return cam.zoom end
    if k == "coordinateSystem" then return Matrix4.WebGLCoordinateSystem end
    if k == "view" then return rawget(self, "_view") end
    if k == "projectionMatrix" then return getProjCache(self).proj end
    if k == "projectionMatrixInverse" then return getProjCache(self).projInv end
    if k == "matrixWorld" then return getWorldCache(self).world end
    if k == "matrixWorldInverse" then return getWorldCache(self).worldInv end
    return nil
end

local function set(self, k, v)
    local cam = rawget(self, "_cam")
    if k == "fov" then cam.fov = v; return true end
    if k == "near" then cam.nearClip = v; return true end
    if k == "far" then cam.farClip = v; return true end
    if k == "aspect" then return true end          -- 视口自适应，忽略（与原行为一致）
    if k == "zoom" then cam.zoom = v; return true end -- 同步原生，保证渲染与合成投影一致
    return false
end

-- ---- three.js 胶片/焦距/缩放 派生量（纯数学）-------------------------------
function pcMethods:getFilmWidth()
    return (rawget(self, "filmGauge") or 35) * math.min(aspectOf(self), 1)
end
function pcMethods:getFilmHeight()
    return (rawget(self, "filmGauge") or 35) / math.max(aspectOf(self), 1)
end
function pcMethods:getEffectiveFOV()
    return RAD2DEG * 2 * math.atan(math.tan(DEG2RAD * 0.5 * rawget(self, "_cam").fov) / rawget(self, "_cam").zoom)
end
function pcMethods:getFocalLength()
    local vExtentSlope = math.tan(DEG2RAD * 0.5 * rawget(self, "_cam").fov)
    return 0.5 * self:getFilmHeight() / vExtentSlope
end
function pcMethods:setFocalLength(focalLength)
    local vExtentSlope = 0.5 * self:getFilmHeight() / focalLength
    rawget(self, "_cam").fov = RAD2DEG * 2 * math.atan(vExtentSlope)
    return self
end

-- 子区渲染偏移（three.js view offset）。引擎侧 best-effort 设 projectionOffset（仅平移近似）。
function pcMethods:setViewOffset(fullWidth, fullHeight, x, y, width, height)
    rawset(self, "_view", {
        enabled = true, fullWidth = fullWidth, fullHeight = fullHeight,
        offsetX = x, offsetY = y, width = width, height = height,
    })
    local cam = rawget(self, "_cam")
    if cam.SetProjectionOffset or cam.projectionOffset ~= nil then
        local cx = (x + width * 0.5) / fullWidth - 0.5
        local cy = (y + height * 0.5) / fullHeight - 0.5
        cam.projectionOffset = Vector2(-cx, cy)
    end
    return self
end
function pcMethods:clearViewOffset()
    rawset(self, "_view", nil)
    local cam = rawget(self, "_cam")
    if cam.projectionOffset ~= nil then cam.projectionOffset = Vector2(0, 0) end
    return self
end

-- 某距离处视锥在 XY 平面的边界 / 尺寸（three.js 原式，反投影 NDC 角点）。
-- minTarget/maxTarget/target 为 Vector2，就地写入。
function pcMethods:getViewBounds(distance, minTarget, maxTarget)
    local pmi = self.projectionMatrixInverse
    local v = Vector3.new(-1, -1, 0.5):applyMatrix4(pmi)
    minTarget:set(v.x, v.y):multiplyScalar(-distance / v.z)
    v:set(1, 1, 0.5):applyMatrix4(pmi)
    maxTarget:set(v.x, v.y):multiplyScalar(-distance / v.z)
    return self
end
function pcMethods:getViewSize(distance, target)
    local mn, mx = Vector2.new(), Vector2.new()
    self:getViewBounds(distance, mn, mx)
    return target:subVectors(mx, mn)
end

function pcMethods:updateProjectionMatrix() return self end -- 投影按需合成，无缓存可刷
function pcMethods:getCamera() return rawget(self, "_cam") end

local mt = Object3D.makeMeta(pcMethods, get, set)

function PC.new(fov, aspect, near, far)
    local self = setmetatable({}, mt)
    Object3D.setup(self)
    rawset(self, "_lookInverted", true) -- 相机看 -Z（three.js lookAt 相机约定）
    local cam = self:getNode():CreateComponent("Camera")
    cam.handedness = HANDEDNESS_RH -- 只把本相机设为右手系（引擎其余相机保持 LH）
    cam.fov = fov or 50.0
    cam.nearClip = near or 0.1
    cam.farClip = far or 2000.0
    rawset(self, "_cam", cam)
    -- three.js 默认胶片参数（getFocalLength/getEffectiveFOV 用）
    rawset(self, "focus", 10)
    rawset(self, "filmGauge", 35)
    rawset(self, "filmOffset", 0)
    return self
end

return PC
