-- ============================================================================
-- urhox-libs/3D · 入口
-- 用 Lua 忠实复刻 three.js 接口。设计：docs/design/threejs-3d-api-design.md
-- 用法：local THREE = require("urhox-libs/3D")
-- 构造器以"可调用"暴露：THREE.X(...) 对应 three.js new THREE.X(...)
-- ============================================================================

-- 数学
local Vector3 = require("urhox-libs/3D/Core/Vector3")
local Vector2 = require("urhox-libs/3D/Core/Vector2")
local Color = require("urhox-libs/3D/Core/Color")
local Euler = require("urhox-libs/3D/Core/Euler")
local Quaternion = require("urhox-libs/3D/Core/Quaternion")
local Matrix3 = require("urhox-libs/3D/Core/Matrix3")
local Matrix4 = require("urhox-libs/3D/Core/Matrix4")
local Spherical = require("urhox-libs/3D/Core/Spherical")
local Cylindrical = require("urhox-libs/3D/Core/Cylindrical")
local Box3 = require("urhox-libs/3D/Core/Box3")
local Sphere = require("urhox-libs/3D/Core/Sphere")
local Convert = require("urhox-libs/3D/Core/Convert")
local ColorManagement = require("urhox-libs/3D/Core/ColorManagement")
local Clock = require("urhox-libs/3D/Core/Clock")

-- 场景图 / 渲染
local Object3D = require("urhox-libs/3D/Core/Object3D")
local Scene = require("urhox-libs/3D/Core/Scene")
local Renderer = require("urhox-libs/3D/Core/Renderer")
local BufferGeometry = require("urhox-libs/3D/Core/BufferGeometry")
local BufferAttribute = require("urhox-libs/3D/Core/BufferAttribute")
local CatmullRomCurve3 = require("urhox-libs/3D/Curves/CatmullRomCurve3")
local PathMod = require("urhox-libs/3D/Curves/Path")

-- 纹理 / 加载器
local Texture = require("urhox-libs/3D/Core/Texture")
local TextureLoader = require("urhox-libs/3D/Loaders/TextureLoader")
local Canvas = require("urhox-libs/3D/Core/Canvas")
local CanvasTexture = require("urhox-libs/3D/Core/CanvasTexture")
local PMREMGenerator = require("urhox-libs/3D/Core/PMREMGenerator")
local CubeTextureLoader = require("urhox-libs/3D/Loaders/CubeTextureLoader")
local DDSLoader = require("urhox-libs/3D/Loaders/DDSLoader")
local PP = require("urhox-libs/3D/Postprocessing/Postprocessing")

-- 物体 / 几何 / 材质
local Mesh = require("urhox-libs/3D/Objects/Mesh")
local Group = require("urhox-libs/3D/Objects/Group")
local Line = require("urhox-libs/3D/Objects/Line")
local Points = require("urhox-libs/3D/Objects/Points")
local InstancedMesh = require("urhox-libs/3D/Objects/InstancedMesh")
local Sprite = require("urhox-libs/3D/Objects/Sprite")
local LineBasicMaterial = require("urhox-libs/3D/Materials/LineBasicMaterial")
local PointsMaterial = require("urhox-libs/3D/Materials/PointsMaterial")
local SpriteMaterial = require("urhox-libs/3D/Materials/SpriteMaterial")
local BoxGeometry = require("urhox-libs/3D/Geometries/BoxGeometry")
local PlaneGeometry = require("urhox-libs/3D/Geometries/PlaneGeometry")
local SphereGeometry = require("urhox-libs/3D/Geometries/SphereGeometry")
local CylinderGeometry = require("urhox-libs/3D/Geometries/CylinderGeometry")
local ConeGeometry = require("urhox-libs/3D/Geometries/ConeGeometry")
local TorusGeometry = require("urhox-libs/3D/Geometries/TorusGeometry")
local CircleGeometry = require("urhox-libs/3D/Geometries/CircleGeometry")
local RingGeometry = require("urhox-libs/3D/Geometries/RingGeometry")
local TorusKnotGeometry = require("urhox-libs/3D/Geometries/TorusKnotGeometry")
local TetrahedronGeometry = require("urhox-libs/3D/Geometries/TetrahedronGeometry")
local OctahedronGeometry = require("urhox-libs/3D/Geometries/OctahedronGeometry")
local IcosahedronGeometry = require("urhox-libs/3D/Geometries/IcosahedronGeometry")
local DodecahedronGeometry = require("urhox-libs/3D/Geometries/DodecahedronGeometry")
local LatheGeometry = require("urhox-libs/3D/Geometries/LatheGeometry")
local CapsuleGeometry = require("urhox-libs/3D/Geometries/CapsuleGeometry")
local TubeGeometry = require("urhox-libs/3D/Geometries/TubeGeometry")
local ExtrudeGeometry = require("urhox-libs/3D/Geometries/ExtrudeGeometry")
local ShapeGeometry = require("urhox-libs/3D/Geometries/ShapeGeometry")
local PolyhedronGeometry = require("urhox-libs/3D/Geometries/PolyhedronGeometry")
local MeshStandardMaterial = require("urhox-libs/3D/Materials/MeshStandardMaterial")
local MeshPhysicalMaterial = require("urhox-libs/3D/Materials/MeshPhysicalMaterial")
local MeshBasicMaterial = require("urhox-libs/3D/Materials/MeshBasicMaterial")
local RoundedBoxGeometry = require("urhox-libs/3D/Geometries/RoundedBoxGeometry")
local EdgesGeometry = require("urhox-libs/3D/Geometries/EdgesGeometry")
local WireframeGeometry = require("urhox-libs/3D/Geometries/WireframeGeometry")
local TF = require("urhox-libs/3D/Geometries/_transformable") -- 给 build-once 几何加 translate/rotate/scale

-- 灯光 / 相机
local DirectionalLight = require("urhox-libs/3D/Lights/DirectionalLight")
local PointLight = require("urhox-libs/3D/Lights/PointLight")
local SpotLight = require("urhox-libs/3D/Lights/SpotLight")
local AmbientLight = require("urhox-libs/3D/Lights/AmbientLight")
local HemisphereLight = require("urhox-libs/3D/Lights/HemisphereLight")
local PerspectiveCamera = require("urhox-libs/3D/Cameras/PerspectiveCamera")
local OrthographicCamera = require("urhox-libs/3D/Cameras/OrthographicCamera")
local OrbitControls = require("urhox-libs/3D/Controls/OrbitControls")

local THREE = {}

-- 数学类
THREE.Vector3 = Vector3.new
THREE.Vector2 = Vector2.new
THREE.Color = Color.new
THREE.Euler = Euler.new
THREE.Quaternion = Quaternion.new
THREE.Matrix3 = Matrix3.new
THREE.Matrix4 = Matrix4.new
THREE.Spherical = Spherical.new
THREE.Cylindrical = Cylindrical.new
THREE.Box3 = Box3.new
THREE.Sphere = Sphere.new
THREE.Clock = Clock.new

-- 场景图
THREE.Object3D = Object3D.new
THREE.Scene = Scene.new
THREE.BufferGeometry = BufferGeometry.new
THREE.BufferAttribute = function(array, itemSize) return BufferAttribute.new(array, itemSize) end
THREE.CatmullRomCurve3 = CatmullRomCurve3.new
THREE.Shape = PathMod.newShape
THREE.Path = PathMod.new

-- 物体 / 几何 / 材质
THREE.Mesh = Mesh.new
THREE.Group = Group.new
THREE.Line = Line.new
THREE.LineSegments = Line.newSegments
THREE.LineLoop = Line.newLoop
THREE.Points = Points.new
THREE.InstancedMesh = InstancedMesh.new
THREE.Sprite = Sprite.new
THREE.LineBasicMaterial = LineBasicMaterial.new
THREE.PointsMaterial = PointsMaterial.new
THREE.SpriteMaterial = SpriteMaterial.new
-- 几何构造器统一过 TF.wrap：build-once 的获得 translate/rotate/scale；已自带变换的(Plane/BufferGeometry)原样
THREE.BoxGeometry = TF.wrap(BoxGeometry.new)
THREE.PlaneGeometry = PlaneGeometry.new
THREE.SphereGeometry = TF.wrap(SphereGeometry.new)
THREE.CylinderGeometry = TF.wrap(CylinderGeometry.new)
THREE.ConeGeometry = TF.wrap(ConeGeometry.new)
THREE.TorusGeometry = TF.wrap(TorusGeometry.new)
THREE.CircleGeometry = TF.wrap(CircleGeometry.new)
THREE.RingGeometry = TF.wrap(RingGeometry.new)
THREE.TorusKnotGeometry = TF.wrap(TorusKnotGeometry.new)
THREE.TetrahedronGeometry = TF.wrap(TetrahedronGeometry.new)
THREE.OctahedronGeometry = TF.wrap(OctahedronGeometry.new)
THREE.IcosahedronGeometry = TF.wrap(IcosahedronGeometry.new)
THREE.DodecahedronGeometry = TF.wrap(DodecahedronGeometry.new)
THREE.LatheGeometry = TF.wrap(LatheGeometry.new)
THREE.CapsuleGeometry = TF.wrap(CapsuleGeometry.new)
THREE.TubeGeometry = TF.wrap(TubeGeometry.new)
THREE.ExtrudeGeometry = TF.wrap(ExtrudeGeometry.new)
THREE.ShapeGeometry = TF.wrap(ShapeGeometry.new)
THREE.PolyhedronGeometry = TF.wrap(function(vertices, indices, radius, detail)
    local g = PolyhedronGeometry.make(vertices, indices, radius or 1, detail or 0)
    g.parameters = { vertices = vertices, indices = indices, radius = radius or 1, detail = detail or 0 }
    return g
end)
THREE.MeshStandardMaterial = MeshStandardMaterial.new
THREE.MeshPhysicalMaterial = MeshPhysicalMaterial.new
THREE.MeshBasicMaterial = MeshBasicMaterial.new
THREE.RoundedBoxGeometry = TF.wrap(RoundedBoxGeometry.new)
-- Edges/Wireframe 返回完整 BufferGeometry（不过 TF.wrap），喂 THREE.LineSegments 渲染
THREE.EdgesGeometry = function(geo, thresholdAngle) return EdgesGeometry.make(geo, thresholdAngle) end
THREE.WireframeGeometry = function(geo) return WireframeGeometry.make(geo) end

-- 灯光 / 相机
THREE.DirectionalLight = DirectionalLight.new
THREE.PointLight = PointLight.new
THREE.SpotLight = SpotLight.new
THREE.AmbientLight = AmbientLight.new
THREE.HemisphereLight = HemisphereLight.new
THREE.OrbitControls = OrbitControls.new
THREE.PerspectiveCamera = PerspectiveCamera.new
THREE.OrthographicCamera = OrthographicCamera.new

-- 渲染器（three.js 两个名字都给）
THREE.Renderer = Renderer.new
THREE.WebGLRenderer = Renderer.new

-- 常量（three.js side）
THREE.FrontSide = 0
THREE.BackSide = 1
THREE.DoubleSide = 2

-- 阴影类型常量（renderer.shadowMap.type = THREE.PCFSoftShadowMap 等）。
-- 外壳：值与 three.js 对齐，引擎阴影质量自有管线，这里仅供赋值不报错（软阴影由引擎默认 PCF 提供）。
THREE.BasicShadowMap = 0
THREE.PCFShadowMap = 1
THREE.PCFSoftShadowMap = 2
THREE.VSMShadowMap = 3

-- tone mapping 常量（renderer.toneMapping = THREE.ACESFilmicToneMapping 等；非 0 → Zone tonemap LUT）
THREE.NoToneMapping = 0
THREE.LinearToneMapping = 1
THREE.ReinhardToneMapping = 2
THREE.CineonToneMapping = 3
THREE.ACESFilmicToneMapping = 4
THREE.AgXToneMapping = 6
THREE.NeutralToneMapping = 7

-- Fog / FogExp2（→ Scene.fog → Environment → Zone fog）
THREE.Fog = function(color, near, far)
    return { color = Color.new(color), near = near or 1, far = far or 1000, isFog = true }
end
THREE.FogExp2 = function(color, density)
    return { color = Color.new(color), density = density or 0.00025, isFogExp2 = true }
end

-- IBL 环境生成器：底层接引擎 EnvironmentBakeCache（fromEquirectangular/fromCubemap 触发烘焙）
THREE.PMREMGenerator = PMREMGenerator.new
THREE.CubeTextureLoader = CubeTextureLoader.new
THREE.DDSLoader = DDSLoader.new
THREE.RoomEnvironment = function() return { isScene = true, _isRoomEnvironment = true } end

-- texture mapping 常量（决定 scene.environment 的 env 处理方式）
THREE.UVMapping = Texture.UVMapping
THREE.CubeReflectionMapping = Texture.CubeReflectionMapping
THREE.CubeRefractionMapping = Texture.CubeRefractionMapping
THREE.EquirectangularReflectionMapping = Texture.EquirectangularReflectionMapping
THREE.EquirectangularRefractionMapping = Texture.EquirectangularRefractionMapping
THREE.CubeUVReflectionMapping = Texture.CubeUVReflectionMapping

-- 后处理（three/addons/postprocessing）：EffectComposer + passes，意图映射到 Zone 后效
THREE.EffectComposer = PP.EffectComposer
THREE.RenderPass = PP.RenderPass
THREE.UnrealBloomPass = PP.UnrealBloomPass
THREE.OutputPass = PP.OutputPass
THREE.ShaderPass = PP.ShaderPass
THREE.SSAOPass = PP.SSAOPass
THREE.GTAOPass = PP.GTAOPass
THREE.SMAAPass = PP.SMAAPass
THREE.BokehPass = PP.BokehPass
THREE.FilmPass = PP.FilmPass
THREE.GlitchPass = PP.GlitchPass
THREE.FXAAShader = PP.FXAAShader

-- 新后处理路径（three r160+）：RenderPipeline + TSL 节点（PostProcessing 为弃用别名）
THREE.RenderPipeline = PP.RenderPipeline
THREE.PostProcessing = PP.PostProcessing
THREE.TSL = PP.tsl
THREE.pass = PP.tsl.pass
THREE.bloom = PP.tsl.bloom
THREE.ao = PP.tsl.ao
THREE.gtao = PP.tsl.gtao
THREE.fxaa = PP.tsl.fxaa
THREE.smaa = PP.tsl.smaa
THREE.output = PP.tsl.output
THREE.mrt = PP.tsl.mrt

-- 纹理 / 加载器
THREE.Texture = Texture.new
THREE.TextureLoader = TextureLoader.new
THREE.CanvasTexture = CanvasTexture.new

-- 浏览器 canvas shim：document.createElement('canvas') → UrhoX NanoVG-backed Canvas。
-- 守卫：仅在未定义 document 时装；createElement 兼容 .（无 self）/ :（带 self）两种调用。
if rawget(_G, "document") == nil then
    rawset(_G, "document", {
        createElement = function(a, b)
            local t = b or a
            if t == "canvas" then return Canvas.new() end
            return nil
        end,
    })
end
-- 纹理常量（与 three.js 数值对齐）
THREE.RepeatWrapping = Texture.RepeatWrapping
THREE.ClampToEdgeWrapping = Texture.ClampToEdgeWrapping
THREE.MirroredRepeatWrapping = Texture.MirroredRepeatWrapping
THREE.NearestFilter = Texture.NearestFilter
THREE.LinearFilter = Texture.LinearFilter
THREE.LinearMipmapLinearFilter = Texture.LinearMipmapLinearFilter
THREE.SRGBColorSpace = "srgb"
THREE.LinearSRGBColorSpace = "srgb-linear"
THREE.NoColorSpace = ""

-- 坐标系常量（camera.coordinateSystem；与 three.js constants.js 数值一致）
THREE.WebGLCoordinateSystem = 2000
THREE.WebGPUCoordinateSystem = 2001

-- 色彩管理单例（对标 three.js THREE.ColorManagement）：enabled / workingColorSpace / convert ...
THREE.ColorManagement = ColorManagement

THREE._Convert = Convert

return THREE
