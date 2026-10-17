# UrhoX 开发文档索引

**完整的 UrhoX Lua 开发文档库**

---

## 🚀 快速开始

### AI 开发者必读（按顺序）

1. **[principles.md](principles.md)** - 开发准则
2. **[lua-scripting-guide.md](lua-scripting-guide.md)** - Lua 开发指南
3. **至少 3 个相关示例** - 从 [../examples/api-index.md](../examples/api-index.md) 查找

### 3D 开发额外必读 ⭐

**做任何 3D 游戏前，必须先阅读以下文档：**

4. **[recipes/materials.md](recipes/materials.md)** - PBR 材质系统参数详解 🎨
5. **[recipes/rendering.md](recipes/rendering.md)** - 光照配置、LightGroup 预设、天空盒/天空球 💡
6. **[built-in-models.md](built-in-models.md)** - 基础模型尺寸参考 📐

---

## 📖 文档结构

### 核心文档

| 文档 | 说明 | 何时阅读 |
|------|------|----------|
| [principles.md](principles.md) | 开发准则和最佳实践 | 开始任何开发前 |
| [lua-scripting-guide.md](lua-scripting-guide.md) | Lua 开发完整指南 | 开始任何开发前 |
| [index.md](index.md) | 文档主索引 | 查找文档时 |

### 专题文档（3D 开发必读）

| 文档 | 说明 | 何时阅读 | 优先级 |
|------|------|----------|--------|
| [recipes/materials.md](recipes/materials.md) | PBR 材质参数详解 | 3D 开发时 | ⭐ 必读 |
| [recipes/rendering.md](recipes/rendering.md) | 光照、LightGroup 配置、天空盒/天空球 | 3D 开发时 | ⭐ 必读 |
| [built-in-models.md](built-in-models.md) | 基础模型尺寸 | 3D 开发时 | 推荐 |

### API 参考

| 文档 | 说明 |
|------|------|
| [api/index.md](api/index.md) | API 索引 |
| [api/core.md](api/core.md) | Scene, Node, Component |
| [api/graphics.md](api/graphics.md) | 图形渲染 API |
| [api/physics.md](api/physics.md) | 3D 物理系统 |
| [api/physics-2d.md](api/physics-2d.md) | 2D 物理系统 |
| [api/ui.md](api/ui.md) | UI 系统 |
| [api/input.md](api/input.md) | 输入系统 |
| [api/audio.md](api/audio.md) | 音频系统 |
| ... | 更多 API 文档 |

### 解决方案

| 文档 | 说明 |
|------|------|
| [recipes/ui.md](recipes/ui.md) | **UI 开发指南（Yoga + NanoVG，40+ 控件）** ⭐ |
| [recipes/input-controls.md](recipes/input-controls.md) | 输入与虚拟控制指南（摇杆、触摸、键盘）⭐ |
| [recipes/camera.md](recipes/camera.md) | 相机系统指南（第三人称、模式切换） |
| [recipes/create-menu.md](recipes/create-menu.md) | 创建菜单系统 |
| [recipes/file-storage.md](recipes/file-storage.md) | 本地文件存档（File/FileSystem，沙箱读写） |
| [recipes/download-while-playing.md](recipes/download-while-playing.md) | 边玩边下（DWP）资源加载与下载 |
| [recipes/sdk.md](recipes/sdk.md) | SDK 接口使用指南（广告、宿主环境等） |
| [recipes/server-time.md](recipes/server-time.md) | 服务器时间（`common.get_server_time`，权威 Unix 秒时间戳） |

---

## 🎯 使用场景

### 场景1: 开始新项目

```
1. 阅读 principles.md
2. 阅读 lua-scripting-guide.md
3. 选择脚手架（templates/）
   - 2D 休闲 → scaffold-2d.lua
   - 2D 物理 → scaffold-2d-physics.lua
   - 3D 场景展示 → scaffold-3d-scene.lua（自由相机，无角色）
   - 3D 角色游戏 → scaffold-3d-character.lua（Fall Guys、Roblox风格）
4. ⚠️ 如果是3D项目，必须阅读：
   - recipes/materials.md（PBR材质系统）
   - recipes/rendering.md（光照配置）
   - built-in-models.md（模型尺寸）
5. 查看相关示例（examples/）
6. 开始编码
```

### 场景2: 查找 API

```
1. 打开 api/index.md
2. 定位到相关模块
3. 阅读 API 详细说明
```

### 场景3: 解决问题

```
1. 查看 lua-scripting-guide.md → "关键注意事项"
2. 查看 lua-scripting-guide.md → "常见错误信息解读"
3. 重新阅读相关 API 文档
```

---

## 📚 相关资源

- **[../templates/](../templates/)** - 项目脚手架
- **[../examples/](../examples/)** - 完整示例
- **[../urhox-libs/](../urhox-libs/)** - 通用依赖库

---

**最后更新**: 2025-11-20
