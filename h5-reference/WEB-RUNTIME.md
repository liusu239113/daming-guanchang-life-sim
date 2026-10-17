# UrhoX Web/WASM 运行时 —— 实测调查报告

> **调查目的**：确认 Maker 工程能否在浏览器里用**官方 Web/WASM 运行时**直接运行（而非自行重写渲染）。
>
> **调查方式**：直接分析官方播放器源码 `index.min.js`，并实测 CDN 上的运行时文件可达性。
> 所有 URL 与数据均为 **2026-10-18 实测**结果，非推测。

---

## 一、结论速览

| 问题 | 结论 |
|------|------|
| 官方有 Web/WASM 运行时吗？ | ✅ **有**，`UrhoXRuntime.js` / `.wasm` / `.data` 三件套 |
| 运行时文件能直接下载吗？ | ✅ **能**，公开 CDN，无需鉴权（实测 HTTP 200） |
| 引擎版本号？ | ✅ **1.34.15**（stable，2026-10-16），client hash `3c445fc9` |
| 允许自托管吗？ | ⚠️ 代码中存在换 host 分支，但**授权需官方确认** |
| 工程本身是 Web 构建产物吗？ | ✅ `dist/` 就是完整 Web 产物 |
| `UrhoXCLI` 能打包吗？ | ❌ **不能**，只有模型转换工具，无 build/package 命令 |

---

## 二、引擎版本信息

**清单入口**：`https://tapcode-sce.spark.xd.com/src/engine/latest.json`

```json
{
  "format": 1,
  "version": "1.34.15",
  "build": 1,
  "client": "3c445fc9",
  "server": "665d5a66",
  "generated_at": "2026-10-16T19:00:50.128086Z"
}
```

| 项目 | 值 |
|------|-----|
| 引擎版本 | **1.34.15** |
| 引擎 client hash | `3c445fc9` |
| base_url | `https://tapcode-sce.spark.xd.com/src/engine/` |
| 引擎清单 | `.../src/engine/1.34.15/manifest-3c445fc9.json` |

> 注：`settings.json` 中的 tag 为 `stable`（非语义版本号）。
> 本项目构建时锁定的是 `ef9e23e2`（见 `dist/1.0.59/engine-ef9e23e2.json`），与当前 stable 的 `3c445fc9` 不同 —— 说明引擎版本会随平台更新。

---

## 三、运行时文件与 CDN 地址（核心）

### 寻址规则

从官方播放器 `index.min.js` 源码中提取的真实逻辑：

```js
let engineUrl = engineSrc.base_url;              // https://.../src/engine/
engineUrl += engineVer.version + '/';            // 1.34.15/
const manifest = await fetchJson(engineUrl + 'manifest-' + engineVer.client + '.json');
buildFileMap(manifest.files, engineUrl + 'assets/');

// buildFileMap 内部：
// fileMap.set(f.fs_path, { url: baseUrl + f.uuid + '-' + f.hash + f.ext })
```

**最终 URL 规则**：

```
https://tapcode-sce.spark.xd.com/src/engine/assets/{uuid}-{hash}{ext}
```

### 运行时三件套（2026-10-18 实测）

| 文件 | 大小 | 完整 URL | 实测 |
|------|------|---------|------|
| `UrhoXRuntime.js` | 338,323 B（0.32 MB） | `.../src/engine/assets/F_eHcSf-SM3QhZC0tLIFdqPF-2cee04d1.js` | ✅ 200 |
| `UrhoXRuntime.wasm` | 40,840,396 B（**38.95 MB**） | `.../src/engine/assets/ANHo6ZWrXNgrQz58G-lCGaOB-ee10ffc9.wasm` | ✅ 200 |
| `UrhoXRuntime.data` | 95,039,696 B（**90.64 MB**） | `.../src/engine/assets/BbTo8SDowugga3YXpnunSY6G-b6880fe6.data` | ✅ 200 |
| `version.json` | 125 B | `.../src/engine/assets/AnaBaUzBLPaFI1X7JHm0jv0y-6577a09e.json` | — |

> ⚠️ uuid 与 hash 随引擎版本变化，上表对应 **1.34.15**。换版本需重新读 manifest。

### 完整加载流程（还原自源码）

```js
// 1. 读引擎配置（来自 <version>/engine-<hash>.json）
let engineUrl = engineSrc.base_url;   // https://tapcode-sce.spark.xd.com/src/engine/

// 2. 发布态时替换 host（关键！说明官方支持自托管）
if (engineUrl && isPublishGame) {
    engineUrl = engineUrl.replace(new URL(engineUrl).host, location.host);
}
if (engineUrl && !engineUrl.endsWith('/')) engineUrl += '/';

// 3. 拉取引擎版本清单
const engineVer = await fetchJson(engineUrl + verName);              // latest.json
const manifest = await fetchJson(
    engineUrl + engineVer.version + '/manifest-' + engineVer.client + '.json');

// 4. 建立文件映射：fs_path -> {uuid}-{hash}{ext}
buildFileMap(manifest.files, engineUrl + 'assets/');

// 5. 按需加载 UrhoXRuntime.js / .wasm / .data
```

---

## 四、本工程的 Web 构建产物

**`dist/` 目录本身就是完整的 Web 构建产物**，官方播放器所需文件齐备：

```
dist/
├── index.html                           ← Web 入口（加载 index.min.js）
├── __preview-bridge.js                  ← 预览桥接
├── latest.json                          ← 版本指针
├── 1.x.x.json
├── env.json                             ← {"env":"production"}
├── assets.7z                (64.7 MB)   ← 游戏资源包
└── 1.0.59/
    ├── engine-ef9e23e2.json             ← 引擎 base_url 配置
    ├── manifest-c1b5d01b.json   (621 个文件)  ← 客户端资源清单
    ├── manifest-2d5b4caf.json           ← 服务端资源清单
    ├── manifest-origin.json
    ├── version.json
    └── project.json
```

**`engine-ef9e23e2.json` 内容**：
```json
{ "tag": "stable", "base_url": "https://tapcode-sce.spark.xd.com/src/engine/" }
```

**游戏 manifest 结构**（`manifest-c1b5d01b.json`）：
- `files`: 621 项，每项含 `fs_path` / `uuid` / `hash` / `size`
- `asset_prefixes`: `["assets", "scripts"]`
- 示例项：
  ```
  Textures/war_horse_00_D.jpg  uuid=A1a4gdK9OwrcsiZHX10Ffm22  hash=680ccb14  409525 B
  UI/FuneralModal.lua          uuid=A2AxCdGBrAopGY-gktXNCC0C  hash=b725e6d0   32348 B
  ```

> 游戏资源的**分发地址未公开**（探测 `src/engine/p_eshc/`、`projects/p_eshc/` 等均 404）。
> 本地已有完整产物，但线上分发路径需向平台确认。

---

## 五、`UrhoXCLI` 能力实测

二进制：`.cli/UrhoXCLI`（Linux ELF x86-64），**可正常运行**。

**完整命令列表**（实测输出）：

```
UrhoXCLI - Engine CLI tool collection

Commands:
  import-model         Import FBX model to MDL format
  import-gltf          Import GLB/glTF model to MDL format
  model-info           Show MDL model information (LOD, bbox, bones)
  anim-info            Show animation file information (tracks, keyframes)
  retarget-anim        Retarget animation between skeletons
  build-anim-mappings  Enrich AnimationMappings.json with skeleton data
  convert-panorama     Convert equirectangular panorama to cubemap (DDS/KTX)
```

**关键结论**：**只有模型转换工具，没有任何打包/构建命令**。
实测 `build`、`package`、`web` 三个子命令均返回 `Unknown command`。

→ **工程打包由平台侧的 MCP `build` 工具完成，CLI 不提供此能力。**
→ 无 Windows 版可查（工作区内只有这一个 Linux ELF）。

---

## 六、Web 预览 URL

**未能从工作区推出**，需平台提供。

已排除的路径（实测 404）：
- `src/engine/p_eshc/manifest-c1b5d01b.json`
- `projects/p_eshc/manifest-c1b5d01b.json`
- `src/project/p_eshc/manifest-c1b5d01b.json`

已知的公开入口仅 `https://tapcode-sce.spark.xd.com/src/web/src/index.min.js`（播放器本体，146 KB）。

---

## 七、对 H5 复刻的意义

### 好消息

1. **运行时文件可下载** —— 三件套（js/wasm/data）合计约 130 MB，公开可访问，理论上可自托管
2. **官方代码存在自托管分支** —— `isPublishGame` 时把 host 换成 `location.host`，说明架构上支持换域
3. **引擎原生输出 Web** —— 无需"转换"，`dist/` 即是 Web 产物
4. **`urhox-libs/3D` 复刻 three.js API** —— 3D 部分往 three.js 映射非常直接

### 需平台确认

1. **自托管授权** —— 代码支持 ≠ 许可允许，需官方明确
2. **游戏资源分发路径** —— manifest 的 621 个 uuid 文件从哪加载
3. **Web 预览 URL** 与访问权限（登录/白名单）
4. **打包方式** —— CLI 无此能力，是否只能走平台构建机

### 两条技术路线

| 路线 | 说明 | 依赖 |
|------|------|------|
| **A. 自托管官方运行时** | 下载三件套 + 游戏产物，换 host 加载 | 需平台授权；最接近"1:1" |
| **B. 自研 Web 运行时** | Lua WASM 解释器 + 引擎 API shim | 无授权问题；工作量大（见 README 第四节） |

---

## 八、可直接向平台提的问题（精简版）

> 我想在浏览器里用官方 WASM 运行时跑 Maker 工程（不自研渲染）。
> 已自行查明：引擎 stable 为 **1.34.15**，运行时文件可从
> `https://tapcode-sce.spark.xd.com/src/engine/assets/{uuid}-{hash}{ext}` 下载
> （`UrhoXRuntime.js` 338KB / `.wasm` 38.95MB / `.data` 90.64MB），`dist/` 已是完整 Web 构建产物。
>
> 请确认四点：
> 1. 该工程的 **Web 预览/发布 URL**（`https://.../g/p_eshc/` 形式）？是否需要登录或白名单？
> 2. **游戏资源包**（manifest 里 621 个 uuid 文件 + `assets.7z`）的分发地址？有无公开规律？
> 3. `index.min.js` 中有 `isPublishGame` 时把 engineUrl 的 host 替换为 `location.host` 的分支
>    —— **是否官方允许自托管运行时**用于开发调试？有无授权条件？
> 4. `UrhoXCLI` 只有模型工具、无打包命令，**Windows 版或替代打包方式**是否存在？

---

*调查日期：2026-10-18*
*数据来源：官方播放器 `index.min.js` 源码 + CDN 实测*
