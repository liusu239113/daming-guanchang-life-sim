# UrhoX / Maker 引擎参考资料包（H5 复刻用）

本目录汇总了 UrhoX（TapTap Maker / 星火编辑器）引擎在**脱离原生引擎、用纯 Web 技术栈复刻**时所需的全部可用资料。

> **用途**：为「浏览器里 1:1 运行 Maker 工程」这一目标提供权威 API 依据。
> 包含完整 Lua API 定义、官方库源码、引擎文档、示例工程与脚手架。

---

## 一、资料清单

| 目录 | 内容 | 文件数 | 体积 |
|------|------|--------|------|
| `.emmylua/` | **引擎 API 类型定义**（每个类一个 `.d.lua`） | 287 | 2.0 MB |
| `urhox-libs/` | **引擎官方 Lua 库源码**（UI / 3D / Camera / Physics2D…） | 235 | 4.0 MB |
| `engine-docs/` | **引擎技术文档**（API 参考 + 方案 recipes） | 71 | 1.0 MB |
| `examples/` | **官方示例工程**（25 个，含 3D / 物理 / 体素 / 联网） | 218 | 8.6 MB |
| `templates/` | **项目脚手架**（2D / 3D 场景 / 3D 角色） | 5 | 85 KB |
| `schemas/` | 项目与清单配置的 JSON Schema | 7 | 45 KB |
| `lua-tools/` | Lua LSP 工具（语法/类型检查） | 3 | 113 KB |

另见仓库根目录的 **`makerapi.md`** —— 从 `.emmylua/` 自动提取的**完整 API 清单**（单文件，便于查阅与喂给 AI）。

---

## 二、各项资料详解

### 1. `.emmylua/` —— 引擎 API 类型定义（最权威）

引擎的完整 Lua API 面，**每个类一个文件**，EmmyLua 格式。

- 总计：**638 个类、6340 个函数、1183 个枚举常量、260 个事件**
- 格式示例：

```lua
---@class Input : Object
---@field mousePosition IntVector2
---@field mouseMode MouseMode
function Input:GetKeyDown(key) end
---@param key integer
---@return boolean
function Input:GetKeyPress(key) end
```

**关键文件**：
| 文件 | 说明 |
|------|------|
| `Events.d.lua` | 260 个事件名 + 各自的事件数据结构 |
| `Common.d.lua` | 全局函数（`GetSafeAreaInsets`、`GetBinaryVersion` 等） |
| `ResourceCache.extensions.d.lua` | 手写扩展：`GetResRefs`、`DownloadResource` 等 |
| `NanoVG.manual.d.lua` | NanoVG 全部绘图函数（H5 需 shim 到 Canvas2D/WebGL） |
| `YogaLayout.manual.d.lua` | Yoga flexbox 布局绑定 |
| `LuaScriptObject.manual.d.lua` | `ScriptObject` 基类（事件接收器） |
| `__manual_types.d.lua` | 其它手工补全的类型 |

> **全局对象**（无需声明直接用）：`audio` `cache` `console` `context` `engine` `fileSystem` `graphics` `input` `localization` `log` `network` `renderer` `time` `ui`

### 2. `urhox-libs/` —— 引擎官方 Lua 库源码（MIT 许可）

引擎的高层库，**源码可直接阅读和移植**。许可证为 MIT（Copyright © 2026 TapTap），允许再分发与修改。

| 子目录 | 说明 | H5 复刻重要性 |
|--------|------|--------------|
| `UI/` | **UI 系统（85 文件、64055 行）** | 🔴 **最高** —— 游戏 100% UI 驱动 |
| `3D/` | three.js API 复刻库 | 🔴 高 —— 3D 场景可直接映射 |
| `Camera/` | 相机（含 ThirdPersonCamera） | 🟡 中 |
| `Physics2D/` | Box2D 封装 | 🟡 中 |
| `Animation/` | 动画状态机 | 🟡 中 |
| `Rendering/` `Effects/` `Geometry/` `Sprite/` | 渲染与几何 | 🟡 中 |
| `Network/` `GameLobby/` | 联网 | 🟢 按需 |
| `Platform/` | 平台适配（含 Web/WASM 分支） | 🔴 高 |
| `Input/` | 输入适配 | 🟡 中 |
| `Video/` `Shop/` `FakeAd/` `Plugin/` `System/` `Profiler/` `Testing/` | 其它 | 🟢 按需 |

**`UI/` 是复刻工作的重心**，它依赖：
- **77 个 `nvg*` 函数** —— NanoVG 的 C API，需 shim 到 Canvas2D 或 WebGL
- **Yoga flexbox** —— 布局引擎，JS 侧有官方 wasm 包（`yoga-layout`）可直接用
- 引擎对象：`graphics.width/height/GetDPR`、`time.elapsedTime`、`input:GetKeyDown` 等

### 3. `engine-docs/` —— 引擎技术文档

| 路径 | 内容 |
|------|------|
| `lua-scripting-guide.md` | ⭐ **Lua 开发指南（必读）**，含常见错误速查 |
| `api/*.md` | 20 个模块的 API 索引（core / graphics / input / audio / physics…） |
| `recipes/*.md` | **方案文档**：UI、渲染、材质、网络、存档、i18n、体素物理… |
| `gotchas/` | 踩坑记录（如相机 orthoSize 的 0.5 因子） |

**与 H5 直接相关的 recipes**：
- `recipes/ui.md` —— UI 系统（40+ 控件、Yoga 布局、分辨率缩放策略）
- `recipes/threejs-3d-scenes.md` —— **用 three.js 语法写 3D 场景**（对 H5 移植极有价值）
- `recipes/rendering.md`、`recipes/post-processing.md`、`recipes/lights-and-shadows.md`
- `recipes/network-game-guide.md` —— 联网架构
- `recipes/file-storage.md` —— 存档沙箱（H5 需换 IndexedDB/localStorage）
- `recipes/download-while-playing.md`、`recipes/preload-and-build-refs.md` —— 资源加载

### 4. `examples/` —— 官方示例工程（25 个）

**3D / 物理相关（H5 复刻的直接参照）**：

| 示例 | 内容 |
|------|------|
| `12-fruit-ninja-3d-game.lua` | 3D 水果忍者（相机、物理、切割） |
| `18-physics-collision-3d.lua` | 3D 物理碰撞最佳实践 |
| `22-third-person-shooter/` | **模块化 3D 射击**（动画状态机 + 角色控制 + 联网） |
| `25-surface-custom-light-scene/` | SurfaceShader 自定义光照 |
| `27-voxel-town/` | 体素物理沙盒（可破坏） |
| `29-procedural-sky/` | 程序化天空 + 环境光 |
| `30-pelican-bike/` | 延迟渲染综合场景（昼夜/天气/体积光/FFT 海面） |
| `07-minecraft-voxel-world/` | 体素世界（模块化架构） |

**其它**：2D 游戏（Flappy Bird、超级马里奥）、UI（组件画廊、虚拟列表、聊天窗口）、云变量/排行榜、视频播放器、断线重连等。

`examples/api-index.md` 可按 API 反查示例。

### 5. `templates/` —— 项目脚手架

| 文件 | 用途 |
|------|------|
| `scaffold-2d.lua` | 纯 2D 游戏 |
| `scaffold-2d-physics.lua` | 2D 物理（平台跳跃） |
| `scaffold-3d-scene.lua` | 3D 场景展示（自由相机） |
| `scaffold-3d-character.lua` | 3D 角色游戏 |

### 6. `schemas/` —— 配置 Schema

`project.schema.json`、`settings.schema.json`、`manifest.schema.json`、`i18n.schema.json` 等，用于校验工程配置格式。

### 7. `lua-tools/` —— Lua LSP 工具

`lua_lsp_server.py`、`lua_lsp_query.py` —— 用于对 Lua 代码做语法与类型检查，可在移植过程中验证脚本正确性。

---

## 三、本游戏（大明人生官场模拟）的实际 API 面

对复刻工作而言，**引擎虽有 638 个类，但本项目实际只用到很小一部分**。以下为静态扫描结果：

### 引擎全局对象（6 个，110 次调用）

| 对象 | 调用次数 | 用到的方法/属性 |
|------|---------|----------------|
| `log` | 63 | `Write`、`.text`、`.year` |
| `cache` | 29 | `GetResource`、`Exists`、`DownloadResources`、`GetFile` |
| `fileSystem` | 10 | `FileExists`、`Delete`、`CreateDir` |
| `audio` | 4 | `SetMasterGain` |
| `renderer` | 2 | `SetViewport`、`.hdrRendering` |
| `graphics` | 1 | `.windowTitle`（UI 库另用 `width`/`height`/`GetDPR`） |

### 引擎类（7 个）

`Vector3`(28) · `Variant`(16) · `Quaternion`(10) · `Color`(6) · `File`(5) · `Scene`(3) · `Vector2`(2) · `Material:new()`(6) · `Viewport:new()`(1)

### 组件（8 种）

`StaticModel` · `SoundSource` · `Octree` · `DebugRenderer` · `Camera` · `AnimatedModel` · `AnimationController` · `AnimationStateMachine`

### 资源类型（7 种）

`Model` · `Technique` · `Material` · `Sound` · `XMLFile` · `Texture2D` · `JSONFile`

### 引擎常量（8 个）

`LOG_INFO` · `LOG_WARNING` · `LOG_ERROR` · `ADDRESS_WRAP` · `FILTER_TRILINEAR` · `COORD_U` · `COORD_V` · `TU_DIFFUSE`

> 3D 实现集中在 `scripts/Battle/BattleScene.lua`（1512 行），是完整的 3D 俯视角实时战斗：战场、相机、单位寻敌、箭矢弹道、阵型。可作为复刻的对照实现。

---

## 四、复刻工作量评估（按优先级）

| 优先级 | 模块 | 说明 |
|--------|------|------|
| 🔴 P0 | **NanoVG → Canvas2D/WebGL shim** | 77 个 `nvg*` 函数，UI 渲染的基础 |
| 🔴 P0 | **Yoga 布局** | 直接用官方 `yoga-layout` wasm 包 |
| 🔴 P0 | **Lua 运行时** | `wasmoon`（Lua 5.4 WASM）或 `fengari` |
| 🔴 P1 | **UI 库适配** | `urhox-libs/UI` 85 文件，依赖上面三项 |
| 🟡 P2 | 引擎核心对象 | `graphics` `input` `time` `cache` `log` `audio` `fileSystem` |
| 🟡 P2 | 3D 映射 | `Vector3`/`Quaternion`/`Scene`/`Node` → three.js |
| 🟢 P3 | 资源加载 | `cache:GetResource` → fetch + 格式解析 |
| 🟢 P3 | 存档 | `fileSystem` → IndexedDB/localStorage |

---

## 五、引擎版本与平台支持

| 项目 | 值 |
|------|-----|
| 引擎 tag | `stable` |
| 引擎标识 | `ef9e23e2`（hash，非语义版本号） |
| 项目版本 | `1.0.59` |
| Web/WebGL 支持 | ✅ **原生支持**（引擎自身即可输出 Web 构建） |
| Web 运行时 | 由官方 CDN 托管：`https://tapcode-sce.spark.xd.com/src/web/src/index.min.js` |
| WASM 平台标识 | 文档中以 "WASM" 指代 Web 平台 |

> ⚠️ **无法提供的资料**（工作区中不存在，引擎闭源分发）：
> - 引擎 C++ 源码、tolua 绑定生成物、CMake 构建脚本
> - 可自托管的 `.wasm` / `.js` 运行时包（运行时从 CDN 动态加载）

---

## 六、许可与来源

- `urhox-libs/` —— **MIT License, Copyright © 2026 TapTap**（见 `urhox-libs/LICENSE`），允许再分发与修改
- 其余资料为引擎随附的开发辅助内容（类型定义、文档、示例、脚手架）
- 本资料包仅供开发参考，引擎本身为 TapTap 闭源分发

---

*资料打包日期：2026-10-18*
