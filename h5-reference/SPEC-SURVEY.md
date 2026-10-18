# UrhoX → 纯 H5 移植：规格调研（25 项）

> **目标**：把 UrhoX Lua 工程移植为**纯原生 H5**（不用 WebAssembly、不用多线程，任何浏览器/WebView 可运行）。
> **只要规格与行为，不要源码。**
>
> **方法**：逐项查证工作区内的 `engine-docs/`、`urhox-libs/`、`.emmylua/`、`scripts/`。
> 能确定的给依据（文件:行号），查不到的**明确标注"拿不到"**，不编造。
>
> **调查日期**：2026-10-18

---

## 状态总览

| # | 项目 | 状态 |
|---|------|------|
| 1 | NanoVG fork/commit | ❌ 拿不到（补丁 ✅） |
| 2 | Yoga 版本 | ❌ 拿不到 |
| 3 | urhox-libs 版本 | ✅ v1.1.0 |
| 4 | wasm 构建参数 | ❌ **未验证** |
| 5 | 官方文档链接 | ❌（本地文档 ✅） |
| 6 | 混合模式 | ⚠️ 部分 |
| 7 | 色彩空间 | ⚠️ 仅 3D |
| 8 | 纹理采样 | ⚠️ 枚举 ✅ 默认 ❌ |
| 9 | 对齐/DPR 公式 | ✅ **完整** |
| 10 | 抗锯齿 | ✅ 开启 |
| 11 | 圆角/AA 一致性 | ⚠️ 有 Chromium 对标 |
| 12 | 内置字体 | ⚠️ MiSans，清单 ❌ |
| 13 | fallback 顺序 | ⚠️ 优先级 ✅ 逐级 ❌ |
| 14 | 字体光栅化 | ⚠️ fons+stb，参数 ❌ |
| 15 | 字体度量 | ⚠️ 部分 |
| 16 | Yoga 参数 | ⚠️ 部分 |
| 17 | 输入/手势 | ✅ **完整** |
| 18 | 事件时序 | ⚠️ 订阅 ✅ 顺序 ❌ |
| 19 | 主题来源 | ✅ **urhox-libs** |
| 20 | clientCloud | ✅ **完整** |
| 21 | SDK 契约 | ⚠️ 广告 ✅ 登录/分享 ❌ |
| 22 | 降级行为 | ⚠️ 部分 |
| 23 | 像素基准 | ❌ 官方无 → 见 `ACCEPTANCE.md` |
| 24 | 差异列表 | ❌ 官方无 → 见 `ACCEPTANCE.md` |
| 25 | 逐项确认 | ❌ 需官方 → 见 `ACCEPTANCE.md` |

---

# 【A. 版本与来源】

## 1. NanoVG fork / commit / 自定义补丁

- **fork 与 commit：拿不到** —— 工作区无 NanoVG 源码或版本声明。
  `.emmylua/NanoVG.manual.d.lua` 仅定义 `NVGContextWrapper` 包装类（717 B）。
- **✅ 确认有自定义补丁**，依据 `engine-docs/lua-scripting-guide.md:104`：

  > `nvgImagePatternTinted` — 上游 `nvgImagePattern` 第 8 参是 `alpha`（数字），
  > 只能控透明度、无法染色；UrhoX 版把第 8 参换成 `NVGcolor`，
  > 对图片做**乘法叠色**（texture × color）。

  签名：`nvgImagePatternTinted(ctx, ox,oy, ex,ey, angle, image, color)`

- **其它 UrhoX 扩展**（非上游 NanoVG）：`nvgSetRenderOrder`、`nvgSpineCreate/nvgSpineRender`、
  `nvgSvgCreate/nvgSvgRender`、`nvgTextScaleMode`
- **补丁影响的行为**：`nvgImagePattern` 染色语义（第 8 参类型不同）→ **移植必须特判**。

## 2. Yoga 版本

- **版本号：拿不到** —— `.emmylua/YogaLayout.manual.d.lua` 仅声明
  `YGNodeRef`/`YGConfigRef` 为不透明指针。
- **✅ 确认使用像素对齐 API**：`YGConfigSetPointScaleFactor(config, scale)`
  （`urhox-libs/UI/README.md:144`）—— 这是 Yoga 原生 API，非 fork 改动。

## 3. urhox-libs 版本

- **✅ 拿到**：`UI.VERSION = "1.1.0"`（`urhox-libs/UI/init.lua:283`）
- README 标注 `版本: v2.0`（`urhox-libs/README.md:146`）
- **commit：拿不到**（无 git 元数据）
- 许可证：MIT，Copyright © 2026 TapTap

## 4. Web 运行时构建参数（pthreads / SharedArrayBuffer / 单线程）

- **❌ 拿不到，且未验证** —— 需下载分析 38 MB wasm，工作区无构建脚本。
- **不能给你结论**。官方 `UrhoXRuntime.wasm` 是否强依赖 SAB，需实测或问官方。

## 5. 官方公开文档链接

- **公开 URL：拿不到**（无官方文档站链接）。
- **✅ 但工作区有完整文档**：
  - `engine-docs/lua-scripting-guide.md` —— Lua 开发指南
  - `engine-docs/api/*.md` —— 20 个模块 API 索引
  - `engine-docs/recipes/*.md` —— 40 篇方案文档
  - `engine-docs/principles.md` —— 设计原则

---

# 【B. 渲染规格】

## 6. 混合模式 / premultiplied alpha

**✅ 混合模式映射表**（`urhox-libs/UI/Core/UI.lua:1442`）：

```lua
local blendModeMap = {
    ["normal"]           = NVG_SOURCE_OVER,
    ["lighter"]          = NVG_LIGHTER,
    ["copy"]             = NVG_COPY,
    ["xor"]              = NVG_XOR,
    ["destination-over"] = NVG_DESTINATION_OVER,
    ["source-in"]        = NVG_SOURCE_IN,
    ["source-out"]       = NVG_SOURCE_OUT,
    ["destination-in"]   = NVG_DESTINATION_IN,
    ["destination-out"]  = NVG_DESTINATION_OUT,
}
```
默认 `NVG_SOURCE_OVER`。

**❌ premultiplied alpha 的具体 blend func：拿不到** —— NanoVG 内部实现，工作区无源码。
上游 NanoVG 默认预乘 alpha，但 UrhoX 是否改动无据可查。

## 7. 色彩空间 / sRGB framebuffer

- **✅ 3D 部分拿到**（`engine-docs/recipes/threejs-3d-scenes.md:76`）：
  库内置 `THREE.ColorManagement`（默认 `enabled=true`，工作空间 Linear-sRGB），
  hex 自动 sRGB→linear，渲染输出编码回 sRGB。与 three.js r152+ 一致。
- **❌ UI/NanoVG 管线：拿不到** —— 无文档说明是否 sRGB framebuffer。

## 8. 纹理采样

**✅ 枚举拿到**（`.emmylua/GraphicsDefs.d.lua:207`）：

| 枚举 | 值 |
|------|-----|
| `FILTER_NEAREST` | 0 |
| `FILTER_BILINEAR` | 1 |
| `FILTER_TRILINEAR` | 2 |
| `FILTER_ANISOTROPIC` | 3 |
| `FILTER_NEAREST_ANISOTROPIC` | 4 |

**❌ 默认值：拿不到**。**❌ mipmap 规则：拿不到**。

## 9. 几何/文本对齐、半像素偏移、DPR 缩放公式 ✅ 完整

**这是移植像素一致的核心。**

### 坐标系

| 概念 | 说明 |
|------|------|
| **基准像素（Base Pixels）** | 代码中直接使用的逻辑坐标单位 |
| **物理像素** | 屏幕实际像素 = 基准像素 × scale |

### 缩放公式（`urhox-libs/UI/Core/UI.lua:47`）

```lua
-- UI.Scale.DPR_DENSITY_ADAPTIVE（默认）
DPR_DENSITY_ADAPTIVE = function()
    local dpr = graphics:GetDPR()
    local shortSide = math.min(graphics.width, graphics.height) / dpr
    local PC_REF = 720                                  -- PC 参考短边 (CSS px)
    local densityFactor = math.sqrt(shortSide / PC_REF)
    densityFactor = math.max(0.625, math.min(densityFactor, 1.0))
    return dpr * densityFactor
end
```

### Yoga 像素对齐

`YGConfigSetPointScaleFactor(config, scale)` —— Yoga 在基准像素空间布局，
内部 ×scale 舍入后 ÷scale，确保结果 ×scale 是整数像素。

**对齐示例**（`urhox-libs/UI/README.md:146`）：
> 屏幕 1920px、scale=2、7 个 flex:1 子元素
> Yoga 在基础像素空间（960px）算 960/7 = 137.14...
> 像素对齐后：`137, 137, 137, 137, 137.5, 137.5, 137`（和 = 960）
> 渲染 ×2 后精确对齐屏幕像素，无黑边

### 精度链（关键！）

```
Yoga 返回 137.5（基础像素，已像素对齐）
    ↓ GetLayout() 直接返回浮点，❌ 不可 math.floor()
nvgRect(nvg, 137.5, ...)      ← NanoVG 原生支持 float
    ↓ nvgScale(2)
137.5 × 2 = 275（精确屏幕像素）
```

### 三个转换点（`README.md:230`）

| 位置 | 转换 | 说明 |
|------|------|------|
| `UI.Init()` | `YGConfigSetPointScaleFactor` | 设置 Yoga 像素对齐因子 |
| `UI.HandleMouseMove/Down/Up()` | `/ scale` | 屏幕像素 → 基础像素 |
| `UI.Render()` | `nvgScale(scale)` | 基础像素 → 屏幕像素 |

**❌ 半像素偏移**：未见 `+0.5` 类显式偏移的文档记录。

## 10. 抗锯齿 ✅

- **✅ AA 开启**：`nvg_ = nvgCreate(1)` —— 参数 `1 = antialias`
  （`urhox-libs/UI/Core/UI.lua:251`）
- **❌ fringe/coverage 的上游定义：拿不到**，但 `Widget.lua` 有针对性实现（见第 11 项）。

## 11. 裁剪/圆角/渐变/阴影 vs 上游一致性 ⚠️

**⚠️ 不一致，官方有专门适配。** `urhox-libs/UI/Core/Widget.lua` 多处注释显式对标
**Chromium 的像素覆盖率**：

| 行号 | 注释摘要 |
|------|---------|
| `:2644` | "radial thickness paints solid ink where Chromium is at <10% coverage (measured: ...)" |
| `:2671` | "One fill of the EXACT remaining wedge at 22% alpha reproduces that" |
| `:2677` | "browser coverage <8% there — it draws nothing, and neither should our fringe" |
| `:2786` | "Butt-to-butt AA fringes at an exact seam are deduped first-wins" |
| `:2790` | "Extension length: min(1, r*0.35). One fringe (1px) fully re-covers the ..." |

**对移植的意义**：这些是官方**为对齐浏览器**做的人工调校。
移植到纯 H5 时，浏览器原生渲染可能**天然更接近**目标。
**建议直接读 `Widget.lua` 2600–2800 行**。

---

# 【C. 字体】

## 12. 内置字体清单

- **✅ 兜底字体为 MiSans**（`engine-docs/recipes/ui.md:202`）：
  > `fonts`：`options.fonts` > `theme.fonts` > **内置 MiSans 兜底**

  文档示例使用 `Fonts/MiSans-Regular.ttf` 与 `Fonts/MiSans-Bold.ttf`（两个字重）
- **✅ 含 CJK**：MiSans 是小米开源 CJK 字体；示例中明确演示"中文字体渲染 - MiSans"
- **❌ `.data` 内完整字体清单：拿不到**（需解包 90 MB `.data`）
- **❌ 字体版本：拿不到**

## 13. 字体 fallback 顺序

- **✅ 优先级链拿到**：`options.fonts` > `theme.fonts` > **内置 MiSans 兜底**
- **❌ 逐级缺字回退顺序：拿不到**

## 14. 字体光栅化

- **✅ 确认走 fontstash**：`urhox-libs/UI/README.md:339` 提到 `fonsSetSize(ctx->fs, ...)`
- **✅ 后端为 stb_truetype**（fontstash 默认后端）
- **❌ stb_truetype 版本、hinting/oversample 参数、行高/字距规则：全部拿不到**

**✅ 关键行为**（`README.md:339`）：
```cpp
float nvgText(...) {
    float scale = nvg__getFontScale(state);   // 从 transform 提取缩放
    fonsSetSize(ctx->fs, state->fontSize * scale);
}
```
- `nvgFontSize(14)` + `nvgScale(2)` → **实际渲染 28px 字体**（不是 14px 放大）
- `nvgTextBounds` 返回值自动转换回 local coordinate space（基准像素）

## 15. 动态字号缩放时的字体度量

- **✅ `fontSizeMethod` 选项**（`urhox-libs/UI/Core/UI.lua:220`）：

| 取值 | 行为 |
|------|------|
| `"pixel"`（默认） | `nvgFontSize` 用像素；`Theme.FontSize` 把 pt 转 px |
| `"char"` | `nvgFontSize` 直接用 pt；`Theme.FontSize` 原样传递 |

- **❌ 具体换算公式：拿不到**

---

# 【D. 布局与交互】

## 16. Yoga 布局参数

- **✅ 间距体系（基准像素）**：`xs=4, sm=8, md=16, lg=24, xl=32, xxl=48`
- **✅ 圆角体系**：`sm=4, md=8, lg=16, full=9999`
- **✅ 已知坑**：Yoga 默认 `flexShrink=0`，子元素溢出需显式设 `flexShrink=1`
  （`engine-docs/recipes/ui.md`）
- **❌ 默认 flex 方向、百分比、min/max 处理：拿不到**（Yoga 上游默认 `flexDirection=column`，
  但 UrhoX 是否覆盖无据）

## 17. 输入事件派发与判定阈值 ✅ 完整

### 事件列表（`urhox-libs/UI/Core/UI.lua` 订阅）

`MouseMove`、`MouseButtonDown/Up`、`MouseWheel`、`TouchBegin/Move/End`、
`KeyDown/Up`、`TextInput`、`InputFocus`

### 派发顺序

```
屏幕像素坐标 → /scale → 基准像素 → findWidgetAt(x,y) → widget:OnPointer*
```

### 命中测试规则

```lua
-- 绝对布局矩形判定
return x >= l.x and x <= l.x + l.w
   and y >= l.y and y <= l.y + l.h
```

### 手势阈值（`urhox-libs/UI/Core/Gesture.lua:36-56`）

| 手势 | 参数 | 值 |
|------|------|-----|
| Tap | `tapMaxDuration` | 300 ms |
| Tap | `tapMaxDistance` | 10 px |
| DoubleTap | `doubleTapMaxInterval` | 300 ms |
| DoubleTap | `doubleTapMaxDistance` | 30 px |
| LongPress | `longPressMinDuration` | 500 ms |
| LongPress | `longPressMaxDistance` | 10 px |
| Swipe | `swipeMinDistance` | 50 px |
| Swipe | `swipeMaxDuration` | 500 ms |
| Swipe | `swipeMinVelocity` | 0.3 px/ms |
| Pan | `panMinDistance` | 5 px |
| Pinch | `pinchMinDistance` | 10 px |

## 18. 事件时序与 dt

- **✅ 订阅确认**：`Update`（→ `UI.Update(dt)`）、`NanoVGRender`（→ `UI.Render()`）、
  输入事件（Mouse/Touch/Key）
- **✅ dt 来源**：`eventData["TimeStep"]:GetFloat()` —— **每帧变长 dt，非固定**
- **❌ 每帧精确顺序（Update vs Render 谁先）：拿不到** —— 无文档明确排序

## 19. 主题/样式默认值来源 ✅

**✅ 来自 urhox-libs，非引擎内置。** `urhox-libs/UI/Core/Theme.lua` + `defaultTheme`。

### 库默认主题色（`engine-docs/recipes/ui.md:1763`）

| 语义 | 值 |
|------|-----|
| `primary` | (59,130,246,255) |
| `secondary` | (100,116,139,255) |
| `success` | (34,197,94,255) |
| `error` | (239,68,68,255) |
| `warning` | (245,158,11,255) |

### 组件默认

| 组件 | 值 |
|------|-----|
| Button | `height=44, paddingH=16, radius=8` |
| TextField | `height=40, radius=4` |
| Panel | `radius=8` |

### ⚠️ 本项目实际主题（非库默认）

本项目在 `scripts/main.lua:626` 用 `UITheme.ExtendTheme` 覆盖为**浅色暖白**：

| 语义 | 本项目值 |
|------|---------|
| `primary` | (56,168,120,255) |
| `background` | (247,242,230,255) |
| `surface` | (255,255,255,250) |
| `text` | (55,50,40,255) |
| `border` | (225,220,210,255) |

→ **移植时以 `scripts/UI/Theme.lua` + `main.lua` 覆盖为准**。

---

# 【E. 平台 SDK 契约】

## 20. clientCloud ✅ 完整

依据 `.emmylua/ClientCloud.d.lua` + `engine-docs/recipes/client-cloud-score.md`。

### API 一览

| 方法 | 签名 | 数据去向 |
|------|------|---------|
| `Set` | `(key, value, events)` | → values |
| `SetInt` | `(key, value, events)` | → iscores |
| `Add` | `(key, delta, events)` | → iscores |
| `Get` | `(key, events)` | ← `(values, iscores)` |
| `BatchSet` | 链式 `:Set/:SetInt/:Add/:Delete` → `:Save(description, events)` | — |
| `BatchGet` | 链式 `:Key(key)` → `:Fetch(events)` | — |
| `GetRankList` | `(key, start, count, [orderAsc,] events, otherKey...)` | — |
| `GetUserRank` | `(userId, key, events)` | — |
| `GetRankTotal` | `(key, events)` | — |

### 回调结构

```lua
{
    ok      = function(...),          -- 成功
    error   = function(code, reason), -- 失败
    timeout = function()              -- 超时（可选）
}
```

### ✅ 错误码

| 限制项 | 值 | 超限行为 |
|--------|-----|---------|
| 读请求频率 | 300 次/分钟 | `error(-429, "send failed")` |
| 写请求频率 | 300 次/分钟 | `error(-429, "send failed")` |
| 数据量 | 48 MB/分钟 | `error(-429, "send failed")` |

### 排行榜 item 结构

```lua
{ userId, player(废弃), iscore, score, sscore(废弃恒空) }
```

### ⚠️ 昵称

**不存储在云变量中**。用 `GetUserNickname({userIds, onSuccess, onError})` 查询。

## 21. 登录/云存档/激励视频/分享

### ✅ 激励视频（`engine-docs/recipes/sdk.md`）

```lua
sdk:ShowRewardVideoAd(callback) -> boolean
```

**回调 `result`**：
```lua
{ success: boolean, msg: string, extra: string }
```

| msg | success | 含义 |
|-----|---------|------|
| `"embed success"` | `true` | 完整观看，可发奖 |
| `"embed manual close"` | `false` | 用户中途关闭，**不发奖**（仅 iOS Embed） |
| `"unsupported platform"` | `false` | 平台不支持 |
| 其他字符串 | `false` | TapSDK 内部错误描述 |

**返回值语义**：
- `true` = 请求已被受理（结果以回调为准）
- `false` = 未被受理（3秒防抖/冷却/已有请求进行中/宿主不可用/缺广告位）

**⚠️ 关键**：返回 `false` 时回调**可能同步触发也可能完全不触发**，
调用方必须**同时处理返回值和回调**，并用一次性完成状态避免重复发奖。

### ✅ 云存档

`clientCloud:SaveScene(slot, scene, options, events)` / `LoadScene(...)`

结构：`CloudSceneInfo { version, totalBytes, chunkCount }`
选项：`CloudSceneSaveOptions { data, compress(默认true), blockSize(4096-262144) }`

### ❌ 登录、分享

**拿不到** —— 工作区无这两个 API 的定义或文档。

## 22. 本地无后端时的降级行为

- **⚠️ 部分拿到**：
  - 广告：`"unsupported platform"` → `success=false`
  - 云变量：无明确降级文档
- **❌ 完整的"无后端降级"清单：拿不到**

---

# 【F. 验收标准】

> 详见 **[`ACCEPTANCE.md`](ACCEPTANCE.md)**（用本项目实际数据建立了可执行依据）。

## 23. 官方 UI 参考截图/基准用例

- **❌ 官方基准：拿不到** —— 无公开的像素对比基准或 golden image
- **✅ 但官方做过浏览器对标**：`Widget.lua` 记录了对 Chromium 覆盖率的实测
- **✅ 本项目有 4 张实机截图**（`baseline-screenshots/`）
- **✅ 主题色比对已验证**：`Theme.lua` 定义与实机渲染一致（±4 容差）

## 24. Web 运行时与原生引擎差异列表

- **❌ 官方列表：拿不到**
- **✅ 但可推导出 10 条确定差异**（详见 `ACCEPTANCE.md`），含
  `nvgImagePatternTinted`、`nvgCreate` 返回类型、`nvgSetRenderOrder`、
  Spine/SVG 扩展、设备方向、震动、3D 色彩管理、视频、UI 圆角 AA 等

## 25. 参数清单逐项确认

- **❌ 我无法代表官方确认**
- **✅ 但已提取可核对参数基线**（字号/圆角/间距分布、缩放公式、手势阈值）
- **✅ 我可以帮你对照源码逐项核对** —— 提交清单后标注「一致/不一致/无据可查」

---

# 三点最关键发现

## 1. 第 9 项（对齐/DPR 公式）是像素一致的核心

公式、示例、精度链全部有据可查：
- 缩放公式（`UI.lua:47`）
- Yoga 像素对齐（`README.md:144-152`）
- 浮点精度链（不可 `math.floor`）
- 三个转换点

**建议优先落地。**

## 2. 第 11 项：官方已为对齐浏览器做过调校

`Widget.lua` 2600–2800 行有针对 **Chromium 覆盖率**的人工适配。
移植到纯 H5 时，这些区域**可能天然更接近浏览器** —— 值得直接读源码。

## 3. 第 19 项：主题来自 urhox-libs 而非引擎

意味着可**直接复用 `urhox-libs/UI/Core/Theme.lua` 的逻辑**。
但注意本项目用**自定义浅色主题**，移植时以 `scripts/UI/Theme.lua` 为准。

---

*调查日期：2026-10-18*
*依据：`engine-docs/` + `urhox-libs/` + `.emmylua/` + `scripts/` 源码查证*
