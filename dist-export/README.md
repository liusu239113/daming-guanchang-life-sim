# dist 导出包说明

本目录存放《大明人生官场模拟》的 Web 构建产物打包，用于本地实跑验证官方播放器。

---

## 包列表

| 包 | 大小 | 是否入库 | 内容 |
|----|------|---------|------|
| `daming-dist-manifest.tar.gz` | 134 KiB | ✅ 入库 | 清单部分（除 `assets.7z` 外全部） |
| `daming-dist-full.tar.gz` | 62 MiB | ❌ 未入库 | 完整 dist（含 `assets.7z`） |

> 完整包体积较大（62 MiB），不适合入库，仅保留在工作区本地。
> 如需重新生成，见下方"重新打包"。

---

## 清单包内容

```
daming-dist-manifest.tar.gz
├── index.html                    ← Web 入口（加载官方播放器 index.min.js）
├── __preview-bridge.js           ← 预览桥接
├── latest.json                   ← 版本指针（→ 1.0.59）
├── 1.x.x.json
├── env.json                      ← {"env":"production"}
├── project.json
└── 1.0.59/
    ├── engine-ef9e23e2.json      ← 引擎配置（tag=stable，不锁版本）
    ├── manifest-c1b5d01b.json    ← 客户端资源清单（621 文件）
    ├── manifest-2d5b4caf.json    ← 服务端资源清单
    ├── manifest-origin.json
    ├── manifest-origin.b2.json
    ├── version.json
    └── project.json
```

**完整包**在此基础上多一个 `assets.7z`（62 MiB，游戏资源）。

---

## ⚠️ 已排除的文件

打包时**主动排除了**以下两个文件（含登录凭证，不可外传）：

| 文件 | 内容 |
|------|------|
| `user_info.json` | `login_token` / `login_token_secret` / `token` |
| `mac-token.json` | MAC 签名凭证 |

---

## 用途：本地跑官方播放器

按 `h5-reference/WEB-RUNTIME.md` 还原的加载链路：

```
index.html
  └─ 加载官方播放器  https://tapcode-sce.spark.xd.com/src/web/src/index.min.js
       ├─ 读引擎配置        <version>/engine-<hash>.json     → base_url
       ├─ 读引擎版本        {base_url}stable.json            → 1.34.8 / 2f2ba032
       ├─ 读引擎清单        {base_url}1.34.8/manifest-2f2ba032.json
       ├─ 读游戏清单        <version>/manifest-c1b5d01b.json  → 621 文件
       └─ 按 {uuid}-{hash}{ext} 加载资源
```

**关键点**：
- 引擎运行时（js/wasm/data）从官方 CDN 加载，**不在此包内**
- 引擎版本**不锁定**（`tag=stable`），实际加载当前 stable 引擎
- 游戏资源来自 `assets.7z`（完整包内）

---

## 重新打包

```bash
cd /workspace/dist

# 清单包（不含 assets.7z）
tar czf /path/to/daming-dist-manifest.tar.gz \
  index.html latest.json 1.x.x.json env.json \
  __preview-bridge.js project.json 1.0.59

# 完整包（含 assets.7z）
tar czf /path/to/daming-dist-full.tar.gz \
  index.html latest.json 1.x.x.json env.json \
  __preview-bridge.js project.json 1.0.59 assets.7z
```

> 注意：不要把 `user_info.json` / `mac-token.json` 打进包里。

---

*导出来源：`/workspace/dist/`（项目版本 1.0.59）*
*导出日期：2026-10-18*
