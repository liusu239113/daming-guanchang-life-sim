# urhox-libs/3D — three.js 风格的 3D Lua 库

用 Lua **忠实复刻 three.js 接口**，让 AI / 开发者用熟悉的 three.js 心智模型写 UrhoX 3D 场景。
同样的类名、构造器签名、camelCase 方法、属性访问、`Vector3`/`Euler`/`Color` 数学类型。

> 设计文档：[`docs/design/threejs-3d-api-design.md`](../../../../docs/design/threejs-3d-api-design.md)
> 方法论同 `urhox-libs/UI`（蹭主流 API 形态的训练数据：UI 蹭 React/CSS，3D 蹭 three.js）。

---

## 快速上手：three.js 代码 → Lua 几乎机械搬运

three.js（JS）：
```js
const scene = new THREE.Scene();
const geo   = new THREE.BoxGeometry(1, 1, 1);
const mat   = new THREE.MeshStandardMaterial({ color: 0x88ccff, roughness: 0.4 });
const cube  = new THREE.Mesh(geo, mat);
cube.position.set(0, 0.5, 0);
scene.add(cube);

const light = new THREE.DirectionalLight(0xffffff, 1.2);
light.position.set(5, 10, 7);
scene.add(light);

const camera = new THREE.PerspectiveCamera(60, aspect, 0.1, 1000);
camera.position.set(0, 3, 7);
camera.lookAt(0, 0, 0);

const renderer = new THREE.WebGLRenderer();
renderer.setAnimationLoop(() => { cube.rotation.y += 0.01; });
```

本库（Lua）—— **只有三处必然语法差异**：
```lua
local THREE = require("urhox-libs/3D")

local scene = THREE.Scene()
local geo   = THREE.BoxGeometry(1, 1, 1)                                   -- new X() → X()
local mat   = THREE.MeshStandardMaterial({ color = 0x88ccff, roughness = 0.4 })
local cube  = THREE.Mesh(geo, mat)
cube.position:set(0, 0.5, 0)                                               -- .set() → :set()
scene:add(cube)                                                            -- .add() → :add()

local light = THREE.DirectionalLight(0xffffff, 1.2)
light.position:set(5, 10, 7)
scene:add(light)
light:lookAt(0, 0, 0)

local camera = THREE.PerspectiveCamera(60, aspect, 0.1, 1000)
camera.position:set(0, 3, 7)
camera:lookAt(0, 0, 0)

local renderer = THREE.WebGLRenderer({ scene = scene, camera = camera })
renderer:setAnimationLoop(function() cube.rotation.y = cube.rotation.y + 0.01 end)
```

**JS→Lua 三规则**：① `new X(...)` → `X(...)`；② `obj.method()` → `obj:method()`（点变冒号）；
③ 对象字面量 `{k: v}` → `{k = v}`。类名/属性名/方法名/参数顺序/常量名一律照搬 three.js。

---

## 坐标系：右手系（同 three.js）

本库的相机以**右手系**渲染（+Z 朝观察者，相机看 -Z），与 three.js 一致。
位置/旋转/几何**按 three.js 原样写，零转换**——例如地板：
```lua
local ground = THREE.Mesh(THREE.PlaneGeometry(20, 20), mat)
ground.rotation.x = -math.pi / 2   -- 同 three.js，躺平成地板
```
手性由引擎处理（`Camera.handedness = RH`，`PerspectiveCamera` 自动设置），无需任何 z 取反技巧。

---

## 已实现 API（Phase 0）

| 分类 | 已实现 |
|---|---|
| 数学 | `Vector3`（含 set/add/sub/cross/dot/normalize/lerp…）、`Color`（hex/rgb/hsl）、`Euler`、`Quaternion` |
| 场景图 | `Scene`（自动 Octree）、`Object3D`（position/rotation/scale/visible/name/add/remove/lookAt/getNode） |
| 物体/几何 | `Mesh`、`BoxGeometry`、`PlaneGeometry` |
| 材质 | `MeshStandardMaterial`（color/roughness/metalness/side） |
| 灯光/相机 | `DirectionalLight`、`PerspectiveCamera` |
| 渲染器 | `WebGLRenderer` / `Renderer`（setSceneCamera / setAnimationLoop / render 空操作） |
| 常量 | `THREE.FrontSide/BackSide/DoubleSide` |

---

## 与 three.js 的范式差异（仅一处需重新理解）

UrhoX 是**保留模式**渲染：`WebGLRenderer{scene,camera}` 构造时即建好视口，引擎自动每帧渲染。
- `renderer:render(scene, camera)` 接受调用但为**空操作**（无需每帧手调）。
- `renderer:setAnimationLoop(fn)` → 每帧回调（映射 Update 事件，scoped 订阅，不被外部全局 Update 顶掉）。

逃生通道：`obj:getNode()` 拿原生 UrhoX `Node`；`material:getNative()` 拿原生 `Material`。

---

## 运行（本地调试）

```
UrhoXRuntime.exe <script>.lua -tapcode_dir=<项目目录> -skip_login
```

---

## 状态与后续

- **Phase 0 已完成并截图验证**（核心场景图 + 数学 + 引擎 RH + 基础渲染）。
- 后续（Phase 1+）：几何生成器（Sphere/Cylinder/Torus…）、材质/纹理细节、更多灯光/相机、动画、GLTF 装载、氛围（雾/辉光/调色）。覆盖度与路线见设计文档 §13。
- ⚠️ RH 当前覆盖基础前向 + Bloom；**阴影 / SSAO / 体积光 / 遮挡剔除**等子系统在 RH 下尚未逐一验证，用到时可能需引擎侧补 RH 分支。

> 改本库需同步 bench 仓 `../urhox-bench/workspace-template/urhox-libs/`（见根 AGENTS.md 跨仓 SOP）。
