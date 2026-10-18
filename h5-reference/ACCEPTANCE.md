# 移植验收标准（第 23/24/25 项）

> 对应规格调研清单的【F. 验收标准】。
> **官方未提供**像素基准与差异列表，因此本文用**本项目实际数据**建立可执行的验收依据。

---

## 23. UI 参考截图与基准用例

### 官方基准：❌ 拿不到

引擎**未提供**公开的 UI 像素对比基准或 golden image。

### ✅ 但官方做过浏览器对标（重要线索）

`urhox-libs/UI/Core/Widget.lua` 中多处注释记录了**对 Chromium 的实测覆盖率**，
说明官方内部按浏览器行为调校过渲染：

| 行号 | 注释摘要 |
|------|---------|
| `:2644` | "radial thickness paints solid ink where Chromium is at <10% coverage (measured: ...)" |
| `:2671` | "One fill of the EXACT remaining wedge at 22% alpha reproduces that" |
| `:2677` | "browser coverage <8% there — it draws nothing, and neither should our fringe" |
| `:2786` | "Butt-to-butt AA fringes at an exact seam are deduped first-wins" |
| `:2790` | "Extension length: min(1, r*0.35). One fringe (1px) fully re-covers the ..." |

> **对移植的意义**：这些区域是官方**为对齐浏览器**做的适配。移植到纯 H5 时，
> 浏览器原生渲染可能**天然更接近**目标。建议直接读 `Widget.lua` 2600–2800 行。

### ✅ 本项目可用的基准素材

已复制到本目录 `baseline-screenshots/`，可作为**非官方**验收参照：

| 截图 | 尺寸 | 场景 | 验收重点 |
|------|------|------|---------|
| `screenshot_family_tree.png` | 1200×1749 | 族谱主界面 | 顶部信息栏、资源条、卡片、底部导航 |
| `screenshot_clan.png` | — | 宗祠 | 面板布局、列表 |
| `screenshot_industry.png` | — | 经营 | 网格布局、数值显示 |
| `screenshot_battle.png` | — | 3D 战斗 | 3D 渲染、相机、UI 叠加 |

> 原图在 `game_material/`，此处为副本。

### ✅ 截图 ↔ 主题色比对（已验证）

对 `screenshot_family_tree.png` 做全图扫描（步长 3px，容差 ±4），
统计主题定义色的命中次数：

| 主题常量 | RGB | 命中次数 |
|---------|-----|---------|
| `BG_LIGHT` | (250,245,232) | 6386 |
| `BG_PANEL` | (248,243,230) | 5847 |
| `BG_INPUT` | (242,237,222) | 5436 |
| `BORDER` | (218,210,190) | 1050 |
| `BORDER_GOLD` | (195,165,85) | 400 |
| `GOLD` | (195,155,60) | 172 |
| `TEXT_PRIMARY` | (45,38,28) | 116 |
| `PRIMARY` | (45,140,100) | 110 |
| `TEXT_SECONDARY` | (85,78,65) | 93 |
| `GREEN` | (76,175,80) | 62 |

**结论**：`scripts/UI/Theme.lua` 中的颜色定义与实机渲染**一致**（±4 容差内）。
→ 移植时**直接采用 `Theme.lua` 的 RGB 值**即可，无需从截图反推。

---

## 24. Web 运行时与原生引擎的已知差异列表

### 官方差异列表：❌ 拿不到

引擎**未提供**此文档。

### ✅ 但可从工作区推导出确定的行为差异

以下差异**有据可查**（源码或文档明确记录），移植时必须处理：

| # | 差异点 | 原生/引擎行为 | 移植注意 |
|---|--------|--------------|---------|
| 1 | **`nvgImagePatternTinted`** | 上游 `nvgImagePattern` 第 8 参是 `alpha`(number)；UrhoX 改为 `NVGcolor` 做**乘法叠色** | **必须特判**，否则染色失效 |
| 2 | **`nvgCreate` 返回类型** | C 中为 `NVGcontext*` 指针；Lua 中为 `Object`（非 integer） | 不能按指针处理 |
| 3 | **`nvgSetRenderOrder`** | UrhoX 扩展，UI 库设为 `999990` | 需在 H5 侧实现图层排序 |
| 4 | **Spine/SVG 渲染** | `nvgSpineCreate/Render`、`nvgSvgCreate/Render` 为 UrhoX 扩展 | 上游 NanoVG 无此 API |
| 5 | **`nvgTextScaleMode`** | UrhoX 扩展 | 上游无 |
| 6 | **设备方向切换** | `common.setDeviceOrientation()` 仅 Android/iOS；桌面/WASM/鸿蒙返回 `onError` + `"unsupported"` | 见 `recipes/ui.md:2085` |
| 7 | **震动** | Web/WASM 走 `navigator.vibrate`；Web 忽略 `type` 参数 | 见 `recipes/sdk.md:98,116` |
| 8 | **3D 色彩管理** | `THREE.ColorManagement` 默认 `enabled=true`，hex 自动 sRGB→linear | 与 three.js r152+ 一致 |
| 9 | **视频播放** | 支持 WASM 与原生，但实现路径不同 | 见 `recipes/video-screen-3d.md:435` |
| 10 | **UI 圆角/AA** | 有 Chromium 覆盖率对标的人工调校 | 见第 23 项 |

### ⚠️ 待你自行验证的差异

| 项 | 说明 |
|----|------|
| premultiplied alpha | 上游 NanoVG 默认预乘，UrhoX 是否改动**无据可查** |
| sRGB framebuffer（UI 管线） | 仅 3D 部分有文档 |
| 纹理默认 filter/mipmap | 枚举已知，**默认值未知** |
| 每帧事件顺序 | Update vs Render 排序**无文档** |
| stb_truetype 版本/参数 | **无据可查** |

---

## 25. 参数清单逐项确认

### 官方确认：❌ 我无法代表官方

但**可以对照工作区做技术核对**（`engine-docs/` + `urhox-libs/` 源码是权威依据）。

### ✅ 已从本项目提取的可核对参数基线

#### 字号规格（本项目实际使用）

| 字号 | 出现次数 | 用途 |
|------|---------|------|
| 11 px | 113 | 辅助文字 |
| **12 px** | **209** | **最常用（正文/说明）** |
| 13 px | 148 | 正文 |
| 14 px | 152 | 正文/按钮 |
| 15 px | 88 | 强调 |
| 16 px | 55 | 小标题 |
| 17–18 px | 50 | 标题 |
| 20 px | 15 | 大标题 |
| 30–40 px | 8 | 特大数字 |

#### 圆角规格

| 圆角 | 出现次数 | 用途 |
|------|---------|------|
| 3 px | 10 | 细边 |
| 4 px | 42 | 小元素 |
| 5 px | 11 | — |
| **6 px** | **99** | **按钮/卡片** |
| **8 px** | **104** | **卡片/面板** |
| 10 px | 20 | 大卡片 |
| 12 px | 11 | 弹窗 |
| 36 px | 6 | 圆形头像（r = h/2） |

#### 间距规格

| 间距 | 出现次数 | 用途 |
|------|---------|------|
| 2 px | 90 | 紧凑 |
| 3 px | 37 | — |
| **4 px** | **207** | **最常用** |
| 6 px | 129 | 标准 |
| 8 px | 169 | 区块 |
| 10 px | 91 | — |
| 12 px | 72 | 大间距 |
| 16 px | 23 | 区块分隔 |

> **规律**：间距以 **2px 为基准单位**，常用 4/6/8/10/12，符合 UI 库 README 的 "4px 基准" 约定。

#### 缩放公式（第 9 项，已完整确认）

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

#### 手势阈值（第 17 项，已完整确认）

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

> 完整定义见 `urhox-libs/UI/Core/Gesture.lua:36-56`。

#### 命中测试规则

```lua
-- 绝对布局矩形判定
return x >= l.x and x <= l.x + l.w
   and y >= l.y and y <= l.y + l.h
```

#### 本项目实际主题（非 default-dark）

本项目在 `scripts/main.lua` 中**覆盖**了 UI 库默认主题为浅色暖白：

| 语义 | 本项目值 | 库默认值 |
|------|---------|---------|
| `background` | (247,242,230) | — |
| `primary` | (56,168,120) | (59,130,246) |
| `text` | (55,50,40) | — |
| `border` | (225,220,210) | — |

→ **移植时以 `scripts/UI/Theme.lua` + `main.lua` 的覆盖为准**，不要用库默认。

---

## 提交参数清单的建议格式

为便于逐项核对，建议按以下模板提交：

```markdown
| # | 参数 | 我的实现值 | 依据 | 是否需确认 |
|---|------|-----------|------|-----------|
| 1 | 字号基准 | 12px 正文 / 14px 按钮 | Theme.lua 统计 | 否 |
| 2 | 圆角基准 | 6px 按钮 / 8px 卡片 | Theme.lua 统计 | 否 |
| 3 | 间距基准 | 4px 单位 | README "4px 基准" | 否 |
| 4 | 缩放公式 | dpr * clamp(sqrt(短边/720), 0.625, 1.0) | UI.lua:47 | 否 |
| 5 | Tap 判定 | <300ms 且 <10px | Gesture.lua:38 | 否 |
| ... | | | | |
```

**我能做的**：对照 `engine-docs/` 与 `urhox-libs/` 源码，逐项标注
「一致 / 不一致 / 无据可查」，并指出差异点。

---

## 结论

| 项 | 官方 | 本项目可做 |
|----|------|-----------|
| 23 基准截图 | ❌ | ✅ 4 张实机截图 + 主题色比对验证 |
| 24 差异列表 | ❌ | ✅ 10 条有据可查的差异 + 5 条待验证 |
| 25 逐项确认 | ❌ | ✅ 参数基线已提取，可对照源码核对 |

**核心结论**：官方不给基准，但**工作区本身提供了足够权威的依据** ——
`Theme.lua`（颜色）、`UI.lua`（缩放）、`Gesture.lua`（阈值）、
`engine-docs/`（行为文档）。移植时以这些为准，比截图反推更可靠。

---

*数据采集日期：2026-10-18*
*依据：`scripts/` 源码统计 + `game_material/` 实机截图 + `urhox-libs/` 源码*
