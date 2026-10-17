# UrhoX Development Principles 开发准则

AI 辅助开发 UrhoX 项目时应遵循的核心准则和方法论。

---

## 📚 准则 #1: 充分阅读文档（必须）

**开始开发前必须充分阅读开发文档**：

### 必读文档
1. **[index.md](index.md)** - 主索引，了解整体文档结构
2. **[lua-scripting-guide.md](lua-scripting-guide.md)** - Lua 开发指南，掌握关键规则
3. **3D 开发必读**（如果做 3D 游戏）：
   - **[recipes/materials.md](recipes/materials.md)** ⭐ - PBR 材质系统参数详解
   - **[recipes/rendering.md](recipes/rendering.md)** ⭐ - 光照配置、LightGroup 预设、天空盒/天空球
   - **[built-in-models.md](built-in-models.md)** - 基础模型尺寸参考

### 阅读要点
- ✅ 了解 Lua 5.4 特性和限制
- ✅ 理解 eventData 访问方式
- ✅ 掌握 NanoVG 渲染规则
- ✅ 熟悉项目结构和依赖引用
- ✅ **3D 开发：使用 PBR 材质系统**（MatDiffColor, Metallic, Roughness）⭐ 首选 `PBRNoTexture.xml`
- ✅ **3D 开发：使用 LightGroup 预设光照**（不要手动配置光照）
- ✅ **3D 开发：获取模型尺寸**（用 boundingBox 或查文档，不要假设 1×1×1）

**记住**：5分钟阅读文档，节省1小时调试时间。

---

## 🏗️ 准则 #2: 脚手架起手（必须）

**不要从零开始写代码，必须基于标准脚手架开始**。

### 选择正确的脚手架

1. **纯 2D 游戏** (无物理引擎)
   - 使用: `templates/scaffold-2d.lua`
   - 适用: 消除、卡牌、解谜、简单移动游戏

2. **2D 物理游戏** (Box2D)
   - 使用: `templates/scaffold-2d-physics.lua`
   - 适用: 平台跳跃、物理弹射、愤怒的小鸟类

3. **3D 场景展示** (自由相机，无角色)
   - 使用: `templates/scaffold-3d-scene.lua`
   - 适用: 建筑漫游、3D 可视化、产品展示
   - ⚠️ 使用前必读: materials.md 和 rendering.md

4. **3D 角色游戏** (第三人称)
   - 使用: `templates/scaffold-3d-character.lua`
   - 适用: Fall Guys、Roblox 风格、马里奥 3D
   - ⚠️ 使用前必读: materials.md 和 rendering.md

### 如何使用

1. **复制**脚手架文件内容
2. **创建**新文件 (如 `scripts/MyGame.lua`)
3. **粘贴**内容
4. **实现** `CreateGameContent` 和 `HandleUpdate` 函数

**记住**：脚手架已经处理好了视口、NanoVG 初始化、事件订阅等繁琐工作，直接用！

---

## 🔍 准则 #3: 学习示例代码（必须）

**开始开发前必须充分阅读相关示例，至少阅读 3 篇**。

### 如何选择示例

1. **根据需求查找**
   - 查看 [../examples/api-index.md](../examples/api-index.md) - 按 API 查找
   - 或查看 [index.md](index.md) 中的示例列表 - 按功能查找

2. **至少阅读 3 个示例**
   - 找到最接近用户需求的示例
   - 查看相关功能的示例
   - 参考实现细节和代码模式


### 阅读重点
- ✅ 初始化流程（Start 函数）
- ✅ 事件订阅模式
- ✅ 资源加载方式
- ✅ 代码组织结构

### ⚠️ 示例的正确使用方式

**示例可以作为模板使用，但需要定制化**：

| ✅ 正确 | ❌ 错误 |
|---------|---------|
| 复制契合的示例到用户目录，重命名后做定制 | 原封不动地把示例给用户 |
| 基于示例修改配置、美化UI、调整玩法 | 只改个文件名就交付 |
| 从示例学习技术，应用到用户需求 | 不理解示例代码就直接使用 |

**当示例非常契合用户需求时**：
1. 复制示例到用户项目目录（如 `scripts/`）
2. 重命名为用户指定的名称
3. 根据用户需求调整配置参数、美化 UI、定制玩法
4. 确保代码被理解和可维护

**记住**：好的示例是快速起步的捷径，但交付给用户的应该是**定制化的游戏**，而不是"换皮"的示例。

---

## 📝 准则 #4: 日志先行策略

**首次交付的代码要尽量多写日志输出，确保没问题后再清理**。

### 日志策略

```lua
-- ✅ 开发阶段：充足的日志
function Start()
    print("=== Start() called ===")
    
    self.vg = nvgCreate(1)
    print("NanoVG context created:", self.vg ~= nil)
    
    self.fontId = nvgCreateFont(self.vg, "sans", "Fonts/MiSans-Regular.ttf")
    print("Font loaded, fontId =", self.fontId)
    
    print("=== Start() complete ===")
end

function HandleUpdate(eventType, eventData)
    local dt = eventData["TimeStep"]:GetFloat()
    print("Update: dt =", dt, "bird.y =", self.bird.y)
end
```

### 日志级别

**开发阶段**（首次交付）：
- ✅ 关键函数入口/出口
- ✅ 重要变量的值
- ✅ 资源加载结果
- ✅ 条件分支判断

**稳定阶段**（确认无问题）：
- ✅ 只保留关键错误日志
- ✅ 删除调试用的 print
- ✅ 保持代码简洁

**记住**：过度日志好过无日志，但最终要清理。

---

## 🎯 准则 #5: 物理系统开发流程

**实现物理/碰撞检测前，必须先画出碰撞区域示意图**。

### 开发流程

#### 第一步：设计阶段（必须）
```
1. 画出碰撞区域示意图（用注释或文字描述）
2. 明确检测目的（检测什么？触发什么？）
3. 推演边界情况（最小值、最大值、边界重叠）
```

**示例**：
```lua
-- 碰撞检测设计
-- ┌──────────────────────┐
-- │  Bird (radius: 18)   │  ← 圆形碰撞体
-- └──────────────────────┘
--
-- ┌──────────────────────┐
-- │  Pipe (rect)         │  ← 矩形碰撞体
-- │  width: 70           │
-- │  height: 可变        │
-- └──────────────────────┘
--
-- 检测目的：鸟碰到管道 → 游戏结束
-- 边界情况：
-- - 鸟刚好擦边（圆心距 = radius）
-- - 鸟在缝隙中心（安全）
-- - 鸟碰到地面/天花板

function CheckCollision(bird, pipe)
    -- 实现碰撞检测...
end
```

#### 第二步：实现阶段
- 根据设计实现代码
- 添加充足的日志
- 测试边界情况

#### 第三步：验证阶段
- 验证所有边界情况
- 调整参数
- 清理日志

**记住**：设计不清晰，代码必混乱。先设计，后实现。

---

## 🔎 准则 #6: API 查询流程

**遇到不存在的 API，必须先查询文档和示例，不要瞎猜**。

### 查询流程

#### 第一步：查 API 文档
1. 打开 [api/index.md](api/index.md)
2. 找到相关模块（如 Scene、Graphics、Physics）
3. 查看详细 API 说明

#### 第二步：搜索示例
1. 打开 [examples/api-index.md](examples/api-index.md)
2. 搜索 API 名称
3. 查看实际使用示例

#### 第三步：验证用法
```lua
-- ✅ 正确：参考文档和示例
-- 1. 查 api/core.md 确认 CreateChild 签名
-- 2. 查 examples/ 看实际用法
local node = scene:CreateChild("MyNode")

-- ❌ 错误：凭感觉瞎猜
local node = scene:AddChild("MyNode")  -- API 不存在！
```

### 常用 API 文档快速链接

| 需求 | 文档 |
|------|------|
| 3D 材质系统 | [recipes/materials.md](recipes/materials.md) ⭐ |
| 3D 光照配置、天空盒/天空球 | [recipes/rendering.md](recipes/rendering.md) ⭐ |
| 3D 模型尺寸 | [built-in-models.md](built-in-models.md) |
| 场景/节点 | [api/core.md](api/core.md) |
| 3D 图形 | [api/graphics.md](api/graphics.md) |
| 2D 图形 | [api/graphics-2d.md](api/graphics-2d.md) |
| 物理 | [api/physics.md](api/physics.md) |
| **UI（Yoga + NanoVG）** | **[recipes/ui.md](recipes/ui.md)** ⭐ |
| 输入 | [api/input.md](api/input.md) |

**记住**：文档是你的朋友，不是敌人。

---

## 🌐 准则 #7: 联机游戏开发规则

**开发联机多人游戏时必须遵循的核心规则**。

### 必读文档
- **[network-game-guide.md](recipes/network-game-guide.md)** - 联机游戏开发指南

### 核心规则

#### 规则 #1: 先注册再订阅
```lua
-- ✅ 正确：先注册远程事件，再订阅
network:RegisterRemoteEvent("ChatMessage")
SubscribeToEvent("ChatMessage", HandleChatMessage)

-- ❌ 错误：只订阅不注册（事件不会被识别为远程事件）
```

#### 规则 #2: 客户端节点用 LOCAL
```lua
-- 客户端创建的节点使用 LOCAL
local localNode = scene:CreateChild("LocalUI", LOCAL)
```

#### 规则 #3: 删除网络节点用 Dispose()
```lua
-- 使用 Dispose() 删除 REPLICATED 节点
playerNode:Dispose()

```

#### 规则 #4: 服务器用 StartServer()
```lua
-- ✅ 推荐：分离服务器和客户端入口
function StartServer()
    -- 服务器专用逻辑
end

function Start()
    -- 客户端专用逻辑
end
```

#### 规则 #5: 共享定义单独文件
```lua
-- ✅ 正确：事件名定义在 Shared.lua，双端引用
-- Network/Shared.lua
local M = {}
M.EVENTS = {
    PLAYER_READY = "PlayerReady",
    GAME_START = "GameStart",
}
return M

-- Server.lua / Client.lua
local Shared = require("Network.Shared")
network:RegisterRemoteEvent(Shared.EVENTS.PLAYER_READY)
```


---

## 📋 开发检查清单

在提交代码前，确认：

- [ ] 已阅读 index.md 和 lua-scripting-guide.md
- [ ] **已选择并使用了正确的脚手架** (2D/Physics/3D-Scene/3D-Character)
- [ ] **3D 开发：已阅读 materials.md 和 rendering.md** ⭐
- [ ] **3D 开发：使用了 PBR 材质系统**（不是旧材质文件）
- [ ] **3D 开发：使用了 LightGroup 预设光照**（不是手动配置）
- [ ] **联机开发：先注册再订阅远程事件** ⭐
- [ ] **联机开发：客户端节点用 LOCAL，删除用 Dispose()** ⭐
- [ ] 已阅读至少 3 个相关示例
- [ ] 代码包含充足的调试日志
- [ ] 物理系统有清晰的设计说明
- [ ] 所有 API 都已验证存在
- [ ] eventData 访问格式正确
- [ ] 数组索引从 1 开始
- [ ] 依赖引用路径正确
- [ ] NanoVG 使用 NanoVGRender 事件

---

## 🎯 核心理念

### 理念 #1: 文档优先
**先查文档，再写代码** - 5 分钟阅读，节省 1 小时调试

### 理念 #2: 脚手架起手
**站在巨人肩膀上** - 使用标准脚手架，避免基础配置错误

### 理念 #3: 示例驱动
**从示例学习，向示例看齐** - 模仿优秀代码是最快的学习方式

### 理念 #4: 日志辅助
**日志是开发的眼睛** - 看不见就无法调试

### 理念 #5: 设计先行
**设计清晰，实现简单** - 复杂系统必须先设计

### 理念 #6: 验证为王
**API 不确定就查询** - 不要浪费时间在不存在的 API 上

---

## 📖 相关文档

- [index.md](index.md) - 主索引
- [lua-scripting-guide.md](lua-scripting-guide.md) - Lua 开发指南
- [recipes/materials.md](recipes/materials.md) - 3D 材质系统 ⭐
- [recipes/rendering.md](recipes/rendering.md) - 3D 光照配置、天空盒/天空球 ⭐
- [built-in-models.md](built-in-models.md) - 3D 模型尺寸
- [../claude.md](../claude.md) - AI 入口
- [api/index.md](api/index.md) - API 参考
- [../examples/api-index.md](../examples/api-index.md) - 示例索引

---

**版本**: v1.2  
**最后更新**: 2026-01-31  
**目标**：提高开发效率，减少常见错误
