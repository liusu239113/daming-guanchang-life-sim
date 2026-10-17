# 用 three.js 语法写 3D 场景

> UrhoX 提供 `urhox-libs/3D`——一套**忠实复刻 three.js API** 的 Lua 库。
> 你（AI）可以**像写 three.js 一样**直接写 3D 场景：相同的类名、方法名、坐标系、颜色语义。
> 唯一要记住的是 **JS→Lua 的固定语法差异**（下表）。引擎负责把 three.js 的右手坐标、
> sRGB 颜色等差异在底层兜平——**按你对 three.js 的认知写就对了，不用为引擎差异操心。**

---

## 心智模型

| 你脑子里的 three.js | 这里怎么写 |
|---|---|
| `import * as THREE from 'three'` | `local THREE = require("urhox-libs/3D")` |
| `new THREE.Mesh(geo, mat)` | `THREE.Mesh(geo, mat)`（去掉 `new`） |
| `obj.position.set(1,2,3)` | `obj.position:set(1,2,3)`（**方法用冒号 `:`**） |
| `obj.position.x = 1` | `obj.position.x = 1`（**属性用点 `.`**，不变） |
| `{ color: 0xff0000, roughness: 0.5 }` | `{ color = 0xff0000, roughness = 0.5 }`（**`:`→`=`**） |
| `[1, 2, 3]` | `{1, 2, 3}` |
| `Math.PI`, `Math.sin` | `math.pi`, `math.sin` |
| 方法链 `.set().add()` | `:set():add()`（一样支持链式） |

**就这些。** 类名、方法名、构造参数顺序、属性名、坐标系、单位、颜色全部和 three.js 一致。
遇到任何 three.js API，先按原样翻译这几条语法差异，绝大多数能直接跑。

---

## 只用 three.js 接口（变换/旋转/数学/颜色全部齐全）

**用 `THREE.*` 写场景的每一处变换、旋转、向量数学和颜色。** 库已 100% 覆盖这些能力，
照 three.js 写即可。下面是常见需求对应的 three.js 接口（按 three.js 原名）：

| 需求 | three.js 接口 |
|---|---|
| 设/读旋转（欧拉） | `obj.rotation.x/y/z`、`obj.rotation:set(x,y,z)` |
| 设/读旋转（四元数） | `obj.quaternion`、`obj:setRotationFromQuaternion(q)`、`obj.quaternion:setFromEuler(e)` |
| 用轴角设朝向 | `obj:setRotationFromAxisAngle(axis, rad)`、`obj.quaternion:setFromAxisAngle(axis, rad)` |
| 增量旋转 | `obj:rotateX/Y/Z(rad)`、`obj:rotateOnAxis(axis, rad)`、`obj:rotateOnWorldAxis(...)` |
| 朝向目标 | `obj:lookAt(x, y, z)` |
| 世界位置/旋转/缩放/朝向 | `obj:getWorldPosition()` / `getWorldQuaternion()` / `getWorldScale()` / `getWorldDirection()` |
| 局部↔世界坐标 | `obj:localToWorld(v)` / `obj:worldToLocal(v)` |
| 平移 | `obj.position:add(v)`、`obj:translateX/Y/Z(d)`、`obj:translateOnAxis(axis, d)` |
| 向量数学 | `THREE.Vector3`（`applyQuaternion`/`applyEuler`/`cross`/`lerp`/`normalize`/`project*`…） |
| 四元数数学 | `THREE.Quaternion`（`setFromEuler`/`setFromAxisAngle`/`slerp`/`multiply`/`invert`…） |
| 设材质/灯颜色 | `material.color:set(0xRRGGBB)`、`light.color:set(...)`（自动 sRGB→linear） |
| 挂自定义数据 | `obj.userData.xxx = ...` |

**这些接口的语义与 three.js 完全一致**，按 three.js 的认知写就对。

---

## 坐标系：和 three.js 完全一致（右手系、Y 向上）

```
        +Y (上)
         │
         │
         └────── +X (右)
        ╱
      +Z (朝向屏幕外 / 观察者)        相机默认看向 -Z
```

- **右手系，Y 轴向上，+X 向右，-Z 朝屏幕里**——和 three.js 一模一样。
- **单位 ≈ 米**（和 three.js 惯例一致）。
- **旋转**：`Euler` 用弧度、默认 `XYZ` 顺序；四元数同语义。
- `obj:lookAt(x, y, z)` / `camera:lookAt(target)`：和 three.js 同样的朝向语义。

> **直接用 three.js 的坐标/向量/旋转数值即可**——不需要翻转 Z、不需要换旋转顺序、不需要镜像。
> 一切按 three.js 写。

---

## 颜色：写 sRGB hex，和 three.js 一样

- `THREE.Color(0xff8800)`、材质 `color = 0xff8800`、灯 `color`——**都按 sRGB 写**（即你在设计工具里看到的 hex）。
- 库内置 `THREE.ColorManagement`（默认 `enabled = true`，工作空间 Linear-sRGB），
  **hex / `"#rrggbb"` 自动 sRGB→linear**，渲染输出再编码回 sRGB——和 three.js r152+ 行为一致。
- `THREE.Color(0.5, 0.5, 0.5)`（浮点三元组）按 **linear** 处理（同 three.js `setRGB`）。
- 颜色贴图标 `texture.colorSpace = THREE.SRGBColorSpace`；数据贴图（法线/粗糙度等）保持默认 `NoColorSpace`（linear）——同 three.js。

**结论**：照搬 three.js 的颜色写法即可，不要自己做 gamma 转换。

---

## 最小可运行场景

游戏入口是全局 `function Start()`。构建场景后调用 `THREE.WebGLRenderer({ scene, camera })`，
引擎即自动每帧渲染（保留模式，无需手写渲染循环）。

```lua
local THREE = require("urhox-libs/3D")

function Start()
    -- 场景
    local scene = THREE.Scene()

    -- 相机（45° fov, 16:9, near 0.1, far 100）
    local camera = THREE.PerspectiveCamera(45, 16 / 9, 0.1, 100)
    camera.position:set(4, 3, 6)
    camera:lookAt(0, 0, 0)

    -- 一个立方体
    local cube = THREE.Mesh(
        THREE.BoxGeometry(2, 2, 2),
        THREE.MeshStandardMaterial({ color = 0xcc5533, roughness = 0.6, metalness = 0.1 })
    )
    cube.castShadow = true
    scene:add(cube)

    -- 地面
    local ground = THREE.Mesh(
        THREE.PlaneGeometry(40, 40),
        THREE.MeshStandardMaterial({ color = 0xbbbbbb, roughness = 0.9 })
    )
    ground.rotation.x = -math.pi / 2 -- 平面默认在 XY，转成水平地面
    ground.receiveShadow = true
    scene:add(ground)

    -- 灯光：环境 + 平行光（投影）
    scene:add(THREE.HemisphereLight(0x99aacc, 0x554433, 0.5))
    local sun = THREE.DirectionalLight(0xffffff, 2.0)
    sun.position:set(5, 8, 4)
    sun.castShadow = true            -- 平行光投影
    -- sun.target.position:set(0,0,0) -- 默认 target 已在原点（同 three.js）
    scene:add(sun)

    -- 渲染器：开阴影 + ACES tonemap
    local renderer = THREE.WebGLRenderer({ scene = scene, camera = camera })
    renderer.shadowMap.enabled = true
    renderer.toneMapping = THREE.ACESFilmicToneMapping

    -- 可选：轨道控制（鼠标拖拽看模型）
    local controls = THREE.OrbitControls(camera, renderer.domElement)
    controls.enableDamping = true
    controls.target:set(0, 0, 0)
    controls:update()
end
```

### 每帧逻辑（动画 / 交互）

```lua
renderer:setAnimationLoop(function(dt)   -- dt = 帧间隔秒
    cube.rotation.y = cube.rotation.y + dt
    controls:update()
end)
```

> `renderer:render()` 在这里是**空操作**（引擎已自动渲染，保留模式）；用 `setAnimationLoop` 写逐帧逻辑。

---

## 可用 API 一览（按 three.js 原名）

**核心**：`Scene` `Object3D` `Group` `Mesh` `PerspectiveCamera` `OrthographicCamera` `WebGLRenderer` `OrbitControls` `Clock`

**数学**：`Vector3` `Vector2` `Color` `Euler` `Quaternion`（方法面对齐 three.js，含 `applyQuaternion`/`slerp`/`Object3D.quaternion`/`getWorld*` 等）

**几何体**：`BoxGeometry` `PlaneGeometry` `SphereGeometry` `CylinderGeometry` `ConeGeometry`
`TorusGeometry` `TorusKnotGeometry` `CircleGeometry` `RingGeometry` `ShapeGeometry`
`TetrahedronGeometry` `OctahedronGeometry` `IcosahedronGeometry` `DodecahedronGeometry`
`PolyhedronGeometry` `LatheGeometry` `CapsuleGeometry` `TubeGeometry` `ExtrudeGeometry`
`RoundedBoxGeometry` `BufferGeometry` `BufferAttribute` `Shape` `Path` `CatmullRomCurve3`
（构造参数对齐 three.js 0.184，每个都有 `.parameters`；缺 `EdgesGeometry`/`WireframeGeometry`）

**材质**：`MeshStandardMaterial` `MeshPhysicalMaterial` `MeshBasicMaterial`
（`side`: `THREE.FrontSide`/`BackSide`/`DoubleSide`；PBR 属性 `roughness`/`metalness`/`map`/
`normalMap`/`roughnessMap`/`metalnessMap`/`aoMap`/`emissive`/`emissiveMap`/`vertexColors` 等）

**灯光**：`DirectionalLight` `PointLight` `SpotLight` `AmbientLight` `HemisphereLight`
（`DirectionalLight`/`SpotLight` 自带默认 `.target`，可直接 `light.target.position:set(...)`）

**纹理 / 环境**：`Texture` `TextureLoader` `CanvasTexture` `CubeTextureLoader` `DDSLoader`
`PMREMGenerator` `RoomEnvironment` `Fog` `FogExp2`

**色彩管理**：`ColorManagement` `SRGBColorSpace` `LinearSRGBColorSpace` `NoColorSpace`

**Tone mapping 常量**：`NoToneMapping` `LinearToneMapping` `ReinhardToneMapping`
`CineonToneMapping` `ACESFilmicToneMapping` `AgXToneMapping` `NeutralToneMapping`

**后处理**：`EffectComposer` `RenderPass` `UnrealBloomPass` `OutputPass` `GTAOPass` 等，
以及新路径 `RenderPipeline` / `PostProcessing` + TSL（`pass`/`bloom`/`ao`/…）。

---

## 阴影怎么开（和 three.js 一致）

```lua
renderer.shadowMap.enabled = true   -- 总开关
light.castShadow = true             -- 投影的灯（平行光/聚光）
mesh.castShadow = true              -- 投射阴影的物体
mesh.receiveShadow = true           -- 接收阴影的物体
light.shadow.mapSize:set(2048, 2048)
light.shadow.bias = ...             -- 可设；引擎会映射到合适的内部 bias（防 acne）
renderer.shadowMap.type = THREE.PCFSoftShadowMap  -- 常量已定义；当前为外壳，软阴影由引擎默认提供
```

---

## 暂未支持 / 自动降级（不会崩，会告警）

调用了这些时，库会打印告警并**优雅降级**（忽略该属性 / 跳过），不会中断脚本：

| API / 属性 | 状态 |
|---|---|
| `GLTFLoader` / `.glb` 加载 | 暂未支持（规划中） |
| `AnimationMixer` / 关键帧动画 | 暂未支持（规划中） |
| 材质 `flatShading` / `sheen` / `alphaMap` / `alphaTest` / `normalScale` | 暂未支持，忽略 |
| `scene.background` equirect 全景 | 支持纯色与 cubemap；equirect 背景告警 |
| `renderer.toneMappingExposure` | 当前忽略（引擎缺手动曝光标量，待补） |
| 后处理 pass 的细节参数 | 接口在，真实效果由引擎 Zone 后效统一控制，部分为降级 |

> 写场景时优先用已支持的 API；用到未支持项不会报错，但效果可能与 three.js 有差异。

---

## 常见陷阱（JS→Lua 易错点）

- **方法用 `:`，属性用 `.`**：`obj.position:set(...)`（方法）vs `obj.position.x = 1`（属性）。
  写成 `obj.position.set(...)` 会报 "attempt to call a nil value"。
- **对象字面量用 `=`**：`THREE.MeshStandardMaterial({ color = 0xff0000 })`，不是 `{ color: 0xff0000 }`。
- **`PlaneGeometry` 默认在 XY 平面**（法线 +Z），做地面要 `rotation.x = -math.pi/2`——同 three.js。
- **入口是 `function Start()`**，且必须调用一次 `THREE.WebGLRenderer({scene=, camera=})` 才会渲染。
- **逐帧逻辑用 `renderer:setAnimationLoop(fn)`**，`fn` 收到 `dt`（秒）；不要写 `requestAnimationFrame`。
- 颜色**不要手动做 gamma**——直接写 sRGB hex，库已对齐 three.js 的 ColorManagement。

---

## 参考

- 库源码：`engine/bin/Data/urhox-libs/3D/`（`init.lua` 是全部导出入口）
- 颜色/坐标兜底细节见库内 `Core/ColorManagement.lua`、`Core/Convert.lua`、`Cameras/*`。
