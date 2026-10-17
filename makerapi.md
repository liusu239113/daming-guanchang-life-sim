# UrhoX / Maker 引擎 Lua API 全量清单

> 本文档从引擎类型定义 `.emmylua/` 自动提取，供**调试工具（harness）开发**使用：
> 了解引擎完整 API 面，正确 stub 未实现的 API，避免游戏脚本启动即报错退出。

## 统计总览

| 项目 | 数量 |
|------|------|
| 类型定义文件 | 276 |
| 类（Class） | 355 |
| 方法（Method） | 5521 |
| 属性字段（Field） | 2313 |
| 枚举常量（Enum） | 1091 |
| 事件（Event） | 260 |

**目录**

- [一、全局对象](#一全局对象无需声明直接可用)
- [二、枚举常量](#二枚举常量)
- [三、类与方法](#三类与方法)
- [四、事件系统](#四事件系统)
- [五、harness 实现建议](#五harness-实现建议)

---

## 一、全局对象（无需声明，直接可用）

harness 必须在全局表上预置以下对象，否则游戏脚本一启动就报 nil。

| 全局名 | 类型 | 说明 |
|--------|------|------|
| `audio` | Audio | 音频播放、总线音量 |
| `cache` | ResourceCache | 资源缓存与加载（含 DownloadResource 扩展） |
| `console` | Console | 控制台 |
| `context` | Context | 引擎上下文（子系统容器） |
| `engine` | Engine | 引擎生命周期、帧循环 |
| `fileSystem` | FileSystem | 文件系统、路径、沙箱读写 |
| `graphics` | Graphics | 分辨率、窗口、GPU 信息 |
| `input` | Input | 键鼠、触摸、手柄输入 |
| `localization` | Localization | 多语言 |
| `log` | Log | 日志输出（log:Write） |
| `network` | Network | 网络（多人模式） |
| `renderer` | Renderer | 视口、渲染路径、后效 |
| `time` | Time | 时间、帧率、时间缩放 |
| `ui` | UI | 原生 UI 根元素（已废弃，仅供兼容） |

### 全局函数

| 函数 | 说明 |
|------|------|
| `SubscribeToEvent(event, handler)` | 订阅事件（harness 可做成 no-op 并记录） |
| `UnsubscribeFromEvent(event)` | 取消订阅 |
| `SendEvent(event, data)` | 发送事件 |
| `ScriptObject()` | 创建脚本对象基类（事件接收器） |
| `GetSafeAreaInsets(calcScale?)` | 获取安全区（刘海屏） |
| `GetBinaryVersion()` | 获取引擎二进制版本 |
| `print(...)` | 日志输出 |

### 全局函数（395 个）

harness 需把这些函数全部注入全局表，否则游戏脚本调用即报 `nil`。

| 函数 | 签名 | 说明 |
|------|------|------|
| `Abs` | `(value: number) -> number` |  |
| `AbsInt` | `(value: integer) -> integer` |  |
| `Acos` | `(x: number) -> number` |  |
| `AddTrailingSlash` | `(pathName: string) -> string` |  |
| `Asin` | `(x: number) -> number` |  |
| `Atan` | `(x: number) -> number` |  |
| `Atan2` | `(y: number, x: number) -> number` |  |
| `BoxGeometry` | `(width?: number, height?: number, depth?: number, widthSegments?: integer, heightSegments?: integer, depthSegments?: integer) -> ProceduralGeometry` |  |
| `BoxLineGeometry` | `(width?: number, height?: number, depth?: number, widthSegments?: integer, heightSegments?: integer, depthSegments?: integer) -> ProceduralGeometry` |  |
| `CapsuleGeometry` | `(radius?: number, height?: number, capSegments?: integer, radialSegments?: integer, heightSegments?: integer) -> ProceduralGeometry` |  |
| `Ceil` | `(x: number) -> number` |  |
| `CeilToInt` | `(x: number) -> integer` |  |
| `CircleGeometry` | `(radius?: number, segments?: integer, thetaStart?: number, thetaLength?: number) -> ProceduralGeometry` |  |
| `Clamp` | `(value: number, min: number, max: number) -> number` |  |
| `ClampInt` | `(value: integer, min: integer, max: integer) -> integer` |  |
| `CompressVectorBuffer` | `(src: VectorBuffer) -> VectorBuffer` |  |
| `ConeGeometry` | `(radius?: number, height?: number, radialSegments?: integer, heightSegments?: integer, openEnded?: boolean, thetaStart?: number, thetaLength?: number) -> ProceduralGeometry` |  |
| `ConvexGeometry` | `(points: Vector3[]) -> ProceduralGeometry` |  |
| `Cos` | `(angle: number) -> number` |  |
| `CountSetBits` | `(value: integer) -> integer` |  |
| `CylinderGeometry` | `(radiusTop?: number, radiusBottom?: number, height?: number, radialSegments?: integer, heightSegments?: integer, openEnded?: boolean, thetaStart?: number, thetaLength?: number) -> ProceduralGeometry` |  |
| `DecalGeometry` | `(mesh: ProceduralGeometry, position: Vector3, orientation: Quaternion, size: Vector3) -> ProceduralGeometry` |  |
| `DecompressVectorBuffer` | `(src: VectorBuffer) -> VectorBuffer` |  |
| `DodecahedronGeometry` | `(radius?: number, detail?: integer) -> ProceduralGeometry` |  |
| `EdgesGeometry` | `(geometry: ProceduralGeometry, thresholdAngle?: number) -> ProceduralGeometry` |  |
| `Equals` | `(lhs: number, rhs: number) -> boolean` |  |
| `ErrorDialog` | `(title: string, message: string)` |  |
| `ErrorExit` | `(message?: string, exitCode?: integer)` |  |
| `ExtrudeGeometry` | `(contour: Vector2[], depth?: number) -> ProceduralGeometry` |  |
| `Floor` | `(x: number) -> number` |  |
| `FloorToInt` | `(x: number) -> integer` |  |
| `Fract` | `(x: number) -> number` |  |
| `GetArguments` | `() -> string[]` |  |
| `GetAudio` | `() -> Audio` |  |
| `GetBinaryVersion` | `() -> integer` |  |
| `GetCache` | `() -> ResourceCache` |  |
| `GetConsole` | `() -> Console` |  |
| `GetConsoleInput` | `() -> string` |  |
| `GetContext` | `() -> Context` |  |
| `GetDBAPI` | `() -> DBAPI` |  |
| `GetDatabase` | `() -> Database` |  |
| `GetDebugHud` | `() -> DebugHud` |  |
| `GetDownloadManager` | `() -> DownloadManager` | Get the DownloadManager subsystem |
| `GetEngine` | `() -> Engine` |  |
| `GetEnvironmentBakeCache` | `() -> EnvironmentBakeCache` |  |
| `GetEventSender` | `() -> Object` |  |
| `GetExecuteConsoleCommands` | `() -> boolean` |  |
| `GetExtension` | `(fullPath: string, lowercaseExtension?: boolean) -> string` |  |
| `GetFileName` | `(fullPath: string) -> string` |  |
| `GetFileNameAndExtension` | `(fullPath: string, lowercaseExtension?: boolean) -> string` |  |
| `GetFileSizeString` | `(memorySize: integer) -> string` |  |
| `GetFileSystem` | `() -> FileSystem` |  |
| `GetGlobalVar` | `(key: string) -> Variant` |  |
| `GetGlobalVars` | `() -> VariantMap` |  |
| `GetGraphics` | `() -> Graphics` |  |
| `GetHostName` | `() -> string` |  |
| `GetHttp` | `() -> HttpManager` |  |
| `GetInput` | `() -> Input` |  |
| `GetInternalPath` | `(pathName: string) -> string` |  |
| `GetLocalization` | `() -> Localization` |  |
| `GetLog` | `() -> Log` |  |
| `GetLoginName` | `() -> string` |  |
| `GetMiniDumpDir` | `() -> string` |  |
| `GetNanoVGContext` | `() -> NVGContextWrapper` | Deprecated compat alias, use NVGContextWrapper. Get or create the glob |
| `GetNativePath` | `(pathName: string) -> string` |  |
| `GetNativePlatform` | `() -> string` |  |
| `GetNetwork` | `() -> Network` |  |
| `GetNumLogicalCPUs` | `() -> integer` |  |
| `GetNumPhysicalCPUs` | `() -> integer` |  |
| `GetOSVersion` | `() -> string` |  |
| `GetParentPath` | `(pathName: string) -> string` |  |
| `GetPath` | `(fullPath: string) -> string` |  |
| `GetPlatform` | `() -> string` |  |
| `GetRandomSeed` | `() -> integer` |  |
| `GetRenderer` | `() -> Renderer` |  |
| `GetRuntimeDebugger` | `() -> RuntimeDebugger` |  |
| `GetRuntimeMode` | `() -> string` | Get the current runtime mode ("server" or "client"). |
| `GetSafeAreaInsets` | `(calcScale?: boolean) -> Rect` |  |
| `GetTime` | `() -> Time` |  |
| `GetTotalMemory` | `() -> integer` |  |
| `GetUI` | `() -> UI` |  |
| `GetUserNickname` | `(options: GetUserNicknameOptions)` | Query TapTap nicknames for one or more users. |
| `HasSubscribedToEvent` | `(eventName: string) -> boolean` |  |
| `IcosahedronGeometry` | `(radius?: number, detail?: integer) -> ProceduralGeometry` |  |
| `InverseLerp` | `(lhs: number, rhs: number, x: number) -> number` |  |
| `IsAbsolutePath` | `(pathName: string) -> boolean` |  |
| `IsAlpha` | `(ch: integer) -> boolean` |  |
| `IsClientMode` | `() -> boolean` | Check if running in client mode. |
| `IsDigit` | `(ch: integer) -> boolean` |  |
| `IsNaN` | `(value: number) -> boolean` |  |
| `IsNetworkMode` | `() -> boolean` | Check whether the application is running in network mode. |
| `IsPowerOfTwo` | `(value: integer) -> boolean` |  |
| `IsServerMode` | `() -> boolean` | Check if running in server mode. |
| `LatheGeometry` | `(points: Vector2[], segments?: integer, phiStart?: number, phiLength?: number) -> ProceduralGeometry` |  |
| `Lerp` | `(lhs: number, rhs: number, t: number) -> number` |  |
| `Ln` | `(x: number) -> number` |  |
| `LoftGeometry` | `(sections: Vector3[][] Array of cross-sections, each a Lua array of Vector3 (uniform length), closedSections?: boolean) -> ProceduralGeometry` |  |
| `LogBaseTwo` | `(value: integer) -> integer` |  |
| `Max` | `(lhs: number, rhs: number) -> number` |  |
| `MaxInt` | `(lhs: integer, rhs: integer) -> integer` |  |
| `Min` | `(lhs: number, rhs: number) -> number` |  |
| `MinInt` | `(lhs: integer, rhs: integer) -> integer` |  |
| `Mod` | `(x: number, y: number) -> number` |  |
| `NextPowerOfTwo` | `(value: integer) -> integer` |  |
| `OctahedronGeometry` | `(radius?: number, detail?: integer) -> ProceduralGeometry` |  |
| `OpenConsoleWindow` | `()` |  |
| `ParametricGeometry` | `(func: integer|string Built-in surface: enum index (0=Klein 1=Plane 2=Mobius 3=Mobius3D) or a case-insensitive name, slices?: integer, stacks?: integer) -> ProceduralGeometry` |  |
| `PlaneGeometry` | `(width?: number, height?: number, widthSegments?: integer, heightSegments?: integer) -> ProceduralGeometry` |  |
| `PolyhedronGeometry` | `(vertices: number[], indices: integer[], radius?: number, detail?: integer) -> ProceduralGeometry` |  |
| `Pow` | `(x: number, y: number) -> number` |  |
| `PrintLine` | `(str: string, error?: boolean)` |  |
| `Rand` | `() -> integer` |  |
| `RandStandardNormal` | `() -> number` |  |
| `Random` | `(range: number) -> number` |  |
| `RandomInt` | `(range: integer) -> integer` |  |
| `RandomNormal` | `(meanValue: number, variance: number) -> number` |  |
| `RegisterEventName` | `(eventName: string)` |  |
| `RemoveTrailingSlash` | `(pathName: string) -> string` |  |
| `ReplaceExtension` | `(fullPath: string, newExtension: string) -> string` |  |
| `RingGeometry` | `(innerRadius?: number, outerRadius?: number, thetaSegments?: integer, phiSegments?: integer, thetaStart?: number, thetaLength?: number) -> ProceduralGeometry` |  |
| `Round` | `(x: number) -> number` |  |
| `RoundToInt` | `(x: number) -> integer` |  |
| `RoundedBoxGeometry` | `(width?: number, height?: number, depth?: number, segments?: integer, radius?: number) -> ProceduralGeometry` |  |
| `SDBMHash` | `(hash: integer, c: number -- unsigned char) -> integer` |  |
| `ScriptObject` | `() -> LuaScriptObject` | Create a new script object class that inherits from LuaScriptObject Us |
| `SendEvent` | `(eventName: string, eventData?: VariantMap)` |  |
| `SetExecuteConsoleCommands` | `(enable: boolean)` |  |
| `SetGlobalVar` | `(key: string, value: Variant)` |  |
| `SetMiniDumpDir` | `(pathName: string)` |  |
| `SetRandomSeed` | `(seed: integer)` |  |
| `ShapeGeometry` | `(contour: Vector2[]) -> ProceduralGeometry` |  |
| `Sign` | `(value: number) -> number` |  |
| `Sin` | `(angle: number) -> number` |  |
| `SmoothStep` | `(lhs: number, rhs: number, t: number) -> number` |  |
| `SphereGeometry` | `(radius?: number, widthSegments?: integer, heightSegments?: integer, phiStart?: number, phiLength?: number, thetaStart?: number, thetaLength?: number) -> ProceduralGeometry` |  |
| `Sqrt` | `(x: number) -> number` |  |
| `StableRandom` | `(seed: Vector3) -> number` |  |
| `SubscribeToEvent` | `(eventName: string, functionOrFunctionName: fun(eventType: StringHash|string, eventData: VariantMap)|string)  (+520 重载)` |  |
| `Tan` | `(angle: number) -> number` |  |
| `TeapotGeometry` | `(size?: number, segments?: integer, bottom?: boolean, lid?: boolean, body?: boolean, fitLid?: boolean, blinn?: boolean) -> ProceduralGeometry` |  |
| `TetrahedronGeometry` | `(radius?: number, detail?: integer) -> ProceduralGeometry` |  |
| `ToBool` | `(source: string) -> boolean` |  |
| `ToColor` | `(source: string) -> Color` |  |
| `ToFloat` | `(source: string) -> number` |  |
| `ToInt` | `(source: string, base?: integer) -> integer` |  |
| `ToInt64` | `(source: string, base?: integer) -> integer` |  |
| `ToIntRect` | `(source: string) -> IntRect` |  |
| `ToIntVector2` | `(source: string) -> IntVector2` |  |
| `ToIntVector3` | `(source: string) -> IntVector3` |  |
| `ToLower` | `(ch: integer) -> integer` |  |
| `ToMatrix3` | `(source: string) -> Matrix3` |  |
| `ToMatrix3x4` | `(source: string) -> Matrix3x4` |  |
| `ToMatrix4` | `(source: string) -> Matrix4` |  |
| `ToQuaternion` | `(source: string) -> Quaternion` |  |
| `ToRect` | `(source: string) -> Rect` |  |
| `ToString` | `(value: function|string -- function or function name) -> string` |  |
| `ToStringHex` | `(value: integer) -> string` |  |
| `ToUInt` | `(source: string, base?: integer) -> integer` |  |
| `ToUInt64` | `(source: string, base?: integer) -> integer` |  |
| `ToUpper` | `(ch: integer) -> integer` |  |
| `ToVector2` | `(source: string) -> Vector2` |  |
| `ToVector3` | `(source: string) -> Vector3` |  |
| `ToVector4` | `(source: string, allowMissingCoords?: boolean) -> Vector4` |  |
| `TorusGeometry` | `(radius?: number, tube?: number, radialSegments?: integer, tubularSegments?: integer, arc?: number) -> ProceduralGeometry` |  |
| `TorusKnotGeometry` | `(radius?: number, tube?: number, tubularSegments?: integer, radialSegments?: integer, p?: integer, q?: integer) -> ProceduralGeometry` |  |
| `TransportIsSupported` | `(protocol: TransportProtocol) -> boolean` |  |
| `TubeGeometry` | `(points: Vector3[], tubularSegments?: integer, radius?: number, radialSegments?: integer, closed?: boolean) -> ProceduralGeometry` |  |
| `UnsubscribeFromAllEvents` | `()` |  |
| `UnsubscribeFromAllEventsExcept` | `(exceptionNames: string[])` |  |
| `UnsubscribeFromEvent` | `(eventName: string)` |  |
| `UnsubscribeFromEvents` | `(sender: Object)` |  |
| `VectorCeil` | `(vec: Vector4) -> Vector4` |  |
| `VectorCeilToInt` | `(vec: Vector3) -> IntVector3` |  |
| `VectorFloor` | `(vec: Vector4) -> Vector4` |  |
| `VectorFloorToInt` | `(vec: Vector3) -> IntVector3` |  |
| `VectorLerp` | `(lhs: Vector4, rhs: Vector4, t: Vector4) -> Vector4` |  |
| `VectorMax` | `(lhs: Vector4, rhs: Vector4) -> Vector4` |  |
| `VectorMin` | `(lhs: Vector4, rhs: Vector4) -> Vector4` |  |
| `VectorRound` | `(vec: Vector4) -> Vector4` |  |
| `VectorRoundToInt` | `(vec: Vector3) -> IntVector3` |  |
| `WireframeGeometry` | `(geometry: ProceduralGeometry) -> ProceduralGeometry` |  |
| `YGConfigGetDefault` | `() -> YGConfigRef` | Get the default Yoga configuration. |
| `YGConfigGetPointScaleFactor` | `(config: YGConfigRef) -> number` | Get the current point scale factor. |
| `YGConfigSetPointScaleFactor` | `(config: YGConfigRef, pixelsInPoint: number)` | Set the point scale factor for layout rounding. This controls the dens |
| `YGGetUndefined` | `() -> number` | Get the YGUndefined value (NaN). Used to specify unconstrained dimensi |
| `YGNodeCalculateLayout` | `(node: YGNodeRef, availableWidth: number, availableHeight: number, direction?: integer)` | Calculate layout for the tree rooted at node. |
| `YGNodeClearBaselineValue` | `(node: YGNodeRef The Yoga node)` | Clear the baseline value for a node (disables baseline alignment). |
| `YGNodeFree` | `(node: YGNodeRef)` | Free a single Yoga node (does not free children). |
| `YGNodeFreeRecursive` | `(node: YGNodeRef)` | Free a Yoga node and all its children recursively. |
| `YGNodeGetChild` | `(node: YGNodeRef, index: integer) -> YGNodeRef` | Get child node at index. |
| `YGNodeGetChildCount` | `(node: YGNodeRef) -> integer` | Get the number of children. |
| `YGNodeGetLiveCount` | `() -> integer` | Get the number of live YGNode instances (for debugging). |
| `YGNodeGetParent` | `(node: YGNodeRef) -> YGNodeRef` | Get the parent of a node. |
| `YGNodeInsertChild` | `(node: YGNodeRef, child: YGNodeRef, index: integer)` | Insert a child node at the given index. |
| `YGNodeIsDirty` | `(node: YGNodeRef) -> boolean` | Check if node is dirty. |
| `YGNodeLayoutGetBorder` | `(node: YGNodeRef, edge: integer) -> number` | Get computed border for an edge. |
| `YGNodeLayoutGetBottom` | `(node: YGNodeRef) -> number` | Get computed bottom position. |
| `YGNodeLayoutGetHeight` | `(node: YGNodeRef) -> number` | Get computed height. |
| `YGNodeLayoutGetLeft` | `(node: YGNodeRef) -> number` | Get computed left position. |
| `YGNodeLayoutGetMargin` | `(node: YGNodeRef, edge: integer) -> number` | Get computed margin for an edge. |
| `YGNodeLayoutGetPadding` | `(node: YGNodeRef, edge: integer) -> number` | Get computed padding for an edge. |
| `YGNodeLayoutGetRight` | `(node: YGNodeRef) -> number` | Get computed right position. |
| `YGNodeLayoutGetTop` | `(node: YGNodeRef) -> number` | Get computed top position. |
| `YGNodeLayoutGetWidth` | `(node: YGNodeRef) -> number` | Get computed width. |
| `YGNodeMarkDirty` | `(node: YGNodeRef)` | Mark the node as dirty (needs recalculation). |
| `YGNodeNew` | `() -> YGNodeRef` | Create a new Yoga layout node. |
| `YGNodeRemoveAllChildren` | `(node: YGNodeRef)` | Remove all children from a node. |
| `YGNodeRemoveChild` | `(node: YGNodeRef, child: YGNodeRef)` | Remove a child node. |
| `YGNodeReset` | `(node: YGNodeRef)` | Reset node to default state. |
| `YGNodeSetBaselineValue` | `(node: YGNodeRef The Yoga node, baseline: number The baseline offset from the top of the node (paddingTop + ascender))` | Set a fixed baseline value for a node. Enables alignItems="baseline" a |
| `YGNodeStyleGetAlignItems` | `(node: YGNodeRef) -> integer` | Get align items. |
| `YGNodeStyleGetAlignSelf` | `(node: YGNodeRef) -> integer` | Get align self. |
| `YGNodeStyleGetFlexBasis` | `(node: YGNodeRef) -> {value:` | Get flex basis (returns table {value, unit}). |
| `YGNodeStyleGetFlexDirection` | `(node: YGNodeRef) -> integer` | Get flex direction. |
| `YGNodeStyleGetFlexGrow` | `(node: YGNodeRef) -> number` | Get flex grow. |
| `YGNodeStyleGetFlexShrink` | `(node: YGNodeRef) -> number` | Get flex shrink. |
| `YGNodeStyleGetFlexWrap` | `(node: YGNodeRef) -> integer` | Get flex wrap. |
| `YGNodeStyleGetGap` | `(node: YGNodeRef, gutter: integer) -> {value:` | Get gap (returns table {value, unit}). |
| `YGNodeStyleGetHeight` | `(node: YGNodeRef) -> {value:` | Get height (returns table {value, unit}). |
| `YGNodeStyleGetJustifyContent` | `(node: YGNodeRef) -> integer` | Get justify content. |
| `YGNodeStyleGetMargin` | `(node: YGNodeRef, edge: integer) -> {value:` | Get margin (returns table {value, unit}). |
| `YGNodeStyleGetMaxHeight` | `(node: YGNodeRef) -> {value:` | Get max height (returns table {value, unit}). |
| `YGNodeStyleGetMaxWidth` | `(node: YGNodeRef) -> {value:` | Get max width (returns table {value, unit}). |
| `YGNodeStyleGetMinHeight` | `(node: YGNodeRef) -> {value:` | Get min height (returns table {value, unit}). |
| `YGNodeStyleGetMinWidth` | `(node: YGNodeRef) -> {value:` | Get min width (returns table {value, unit}). |
| `YGNodeStyleGetPadding` | `(node: YGNodeRef, edge: integer) -> {value:` | Get padding (returns table {value, unit}). |
| `YGNodeStyleGetPosition` | `(node: YGNodeRef, edge: integer) -> {value:` | Get position (returns table {value, unit}). |
| `YGNodeStyleGetPositionType` | `(node: YGNodeRef) -> integer` | Get position type. |
| `YGNodeStyleGetWidth` | `(node: YGNodeRef) -> {value:` | Get width (returns table {value, unit}). |
| `YGNodeStyleSetAlignContent` | `(node: YGNodeRef, alignContent: integer)` | Set align content. |
| `YGNodeStyleSetAlignItems` | `(node: YGNodeRef, alignItems: integer)` | Set align items. |
| `YGNodeStyleSetAlignSelf` | `(node: YGNodeRef, alignSelf: integer)` | Set align self. |
| `YGNodeStyleSetAspectRatio` | `(node: YGNodeRef, aspectRatio: number)` | Set aspect ratio. |
| `YGNodeStyleSetBorder` | `(node: YGNodeRef, edge: integer, border: number)` | Set border width. |
| `YGNodeStyleSetDirection` | `(node: YGNodeRef, direction: integer)` | Set the direction. |
| `YGNodeStyleSetDisplay` | `(node: YGNodeRef, display: integer)` | Set display. |
| `YGNodeStyleSetFlex` | `(node: YGNodeRef, flex: number)` | Set flex value. |
| `YGNodeStyleSetFlexBasis` | `(node: YGNodeRef, flexBasis: number)` | Set flex basis (point value). |
| `YGNodeStyleSetFlexBasisAuto` | `(node: YGNodeRef)` | Set flex basis to auto. |
| `YGNodeStyleSetFlexBasisFitContent` | `(node: YGNodeRef)` | Set flex basis to fit-content. |
| `YGNodeStyleSetFlexBasisMaxContent` | `(node: YGNodeRef)` | Set flex basis to max-content. |
| `YGNodeStyleSetFlexBasisPercent` | `(node: YGNodeRef, flexBasis: number)` | Set flex basis (percent value). |
| `YGNodeStyleSetFlexBasisStretch` | `(node: YGNodeRef)` | Set flex basis to stretch. |
| `YGNodeStyleSetFlexDirection` | `(node: YGNodeRef, flexDirection: integer)` | Set the flex direction. |
| `YGNodeStyleSetFlexGrow` | `(node: YGNodeRef, flexGrow: number)` | Set flex grow. |
| `YGNodeStyleSetFlexShrink` | `(node: YGNodeRef, flexShrink: number)` | Set flex shrink. |
| `YGNodeStyleSetFlexWrap` | `(node: YGNodeRef, flexWrap: integer)` | Set flex wrap. |
| `YGNodeStyleSetGap` | `(node: YGNodeRef, gutter: integer, gapLength: number)` | Set gap (point value). |
| `YGNodeStyleSetGapPercent` | `(node: YGNodeRef, gutter: integer, gapLength: number)` | Set gap (percent value). |
| `YGNodeStyleSetHeight` | `(node: YGNodeRef, height: number)` | Set height (point value). |
| `YGNodeStyleSetHeightAuto` | `(node: YGNodeRef)` | Set height to auto. |
| `YGNodeStyleSetHeightPercent` | `(node: YGNodeRef, height: number)` | Set height (percent value). |
| `YGNodeStyleSetJustifyContent` | `(node: YGNodeRef, justifyContent: integer)` | Set justify content. |
| `YGNodeStyleSetMargin` | `(node: YGNodeRef, edge: integer, margin: number)` | Set margin (point value). |
| `YGNodeStyleSetMarginAuto` | `(node: YGNodeRef, edge: integer)` | Set margin to auto. |
| `YGNodeStyleSetMarginPercent` | `(node: YGNodeRef, edge: integer, margin: number)` | Set margin (percent value). |
| `YGNodeStyleSetMaxHeight` | `(node: YGNodeRef, maxHeight: number)` | Set max height. |
| `YGNodeStyleSetMaxHeightFitContent` | `(node: YGNodeRef)` | Set max height to fit-content. |
| `YGNodeStyleSetMaxHeightMaxContent` | `(node: YGNodeRef)` | Set max height to max-content. |
| `YGNodeStyleSetMaxHeightPercent` | `(node: YGNodeRef, maxHeight: number)` | Set max height (percent). |
| `YGNodeStyleSetMaxHeightStretch` | `(node: YGNodeRef)` | Set max height to stretch. |
| `YGNodeStyleSetMaxWidth` | `(node: YGNodeRef, maxWidth: number)` | Set max width. |
| `YGNodeStyleSetMaxWidthFitContent` | `(node: YGNodeRef)` | Set max width to fit-content. |
| `YGNodeStyleSetMaxWidthMaxContent` | `(node: YGNodeRef)` | Set max width to max-content. |
| `YGNodeStyleSetMaxWidthPercent` | `(node: YGNodeRef, maxWidth: number)` | Set max width (percent). |
| `YGNodeStyleSetMaxWidthStretch` | `(node: YGNodeRef)` | Set max width to stretch. |
| `YGNodeStyleSetMinHeight` | `(node: YGNodeRef, minHeight: number)` | Set min height. |
| `YGNodeStyleSetMinHeightFitContent` | `(node: YGNodeRef)` | Set min height to fit-content. |
| `YGNodeStyleSetMinHeightMaxContent` | `(node: YGNodeRef)` | Set min height to max-content. |
| `YGNodeStyleSetMinHeightPercent` | `(node: YGNodeRef, minHeight: number)` | Set min height (percent). |
| `YGNodeStyleSetMinHeightStretch` | `(node: YGNodeRef)` | Set min height to stretch. |
| `YGNodeStyleSetMinWidth` | `(node: YGNodeRef, minWidth: number)` | Set min width. |
| `YGNodeStyleSetMinWidthFitContent` | `(node: YGNodeRef)` | Set min width to fit-content. |
| `YGNodeStyleSetMinWidthMaxContent` | `(node: YGNodeRef)` | Set min width to max-content. |
| `YGNodeStyleSetMinWidthPercent` | `(node: YGNodeRef, minWidth: number)` | Set min width (percent). |
| `YGNodeStyleSetMinWidthStretch` | `(node: YGNodeRef)` | Set min width to stretch. |
| `YGNodeStyleSetOverflow` | `(node: YGNodeRef, overflow: integer)` | Set overflow. |
| `YGNodeStyleSetPadding` | `(node: YGNodeRef, edge: integer, padding: number)` | Set padding (point value). |
| `YGNodeStyleSetPaddingPercent` | `(node: YGNodeRef, edge: integer, padding: number)` | Set padding (percent value). |
| `YGNodeStyleSetPosition` | `(node: YGNodeRef, edge: integer, position: number)` | Set position (point value). |
| `YGNodeStyleSetPositionPercent` | `(node: YGNodeRef, edge: integer, position: number)` | Set position (percent value). |
| `YGNodeStyleSetPositionType` | `(node: YGNodeRef, positionType: integer)` | Set position type. |
| `YGNodeStyleSetWidth` | `(node: YGNodeRef, width: number)` | Set width (point value). |
| `YGNodeStyleSetWidthAuto` | `(node: YGNodeRef)` | Set width to auto. |
| `YGNodeStyleSetWidthPercent` | `(node: YGNodeRef, width: number)` | Set width (percent value). |
| `nvgAddFallbackFont` | `(ctx: NVGContextWrapper, baseFont: string, fallbackFont: string) -> integer` | Add a fallback font by name. |
| `nvgAddFallbackFontId` | `(ctx: NVGContextWrapper, baseFont: integer, fallbackFont: integer) -> integer` | Add a fallback font by handle. |
| `nvgArc` | `(ctx: NVGContextWrapper, cx: number, cy: number, r: number, a0: number, a1: number, dir: integer)` | Create new circle arc shaped sub-path. |
| `nvgArcTo` | `(ctx: NVGContextWrapper, x1: number, y1: number, x2: number, y2: number, radius: number)` | Add an arc segment at the corner defined by the last path point. |
| `nvgBeginFrame` | `(ctx: NVGContextWrapper NanoVG context, windowWidth: number Window width in pixels, windowHeight: number Window height in pixels, devicePixelRatio?: number Device pixel ratio; defaults to 1)` | Begin drawing a new frame (automatically sets ViewId from Graphics sub |
| `nvgBeginPath` | `(ctx: NVGContextWrapper)` | Clear the current path and sub-paths. |
| `nvgBezierTo` | `(ctx: NVGContextWrapper, c1x: number, c1y: number, c2x: number, c2y: number, x: number, y: number)` | Add cubic bezier segment from last point in the path. |
| `nvgBoxGradient` | `(ctx: NVGContextWrapper, x: number, y: number, w: number, h: number, r: number, f: number, icol: NVGcolor, ocol: NVGcolor) -> NVGpaint` | Create and return a box gradient. |
| `nvgBoxGradientGaussian` | `(ctx: NVGContextWrapper, x: number, y: number, w: number, h: number, r: number, f: number, icol: NVGcolor, ocol: NVGcolor) -> NVGpaint` | Create and return a box gradient with Gaussian (erf) falloff, matching |
| `nvgCancelFrame` | `(ctx: NVGContextWrapper NanoVG context)` | Cancel drawing the current frame. |
| `nvgCircle` | `(ctx: NVGContextWrapper, cx: number, cy: number, r: number)` | Create new circle shaped sub-path. |
| `nvgClosePath` | `(ctx: NVGContextWrapper)` | Close current sub-path with a line segment. |
| `nvgCreate` | `(edgeAntiAlias: integer Enable edge anti-aliasing (0=off, 1=on)) -> NVGContextWrapper` | Create NanoVG context (automatically manages BGFX ViewId). |
| `nvgCreateFont` | `(ctx: NVGContextWrapper, name: string Name used to identify the font, filename: string Resource path of the font file) -> integer` | Create font by loading it from the disk. Returns handle to the font. |
| `nvgCreateImage` | `(ctx: NVGContextWrapper NanoVG context, path: string File path to the image, imageFlags?: integer Defaults to 0 (no flags). Image flags (combination of NVGimageFlags: NVG_IMAGE_GENERATE_MIPMAPS, NVG_IMAGE_REPEATX, NVG_IMAGE_REPEATY, NVG_IMAGE_FLIPY, NVG_IMAGE_PREMULTIPLIED, NVG_IMAGE_NEAREST)) -> integer` | Creates image by loading it from disk. Supports all formats including  |
| `nvgCreateVideo` | `(ctx: NVGContextWrapper NanoVG context, texture: Texture2D Texture2D pointer to wrap as a NanoVG image) -> integer` | Creates image from a Texture2D for video playback or render-target sam |
| `nvgCurrentTransform` | `(ctx: NVGContextWrapper, xform: table)` | Store the top part (a-f) of the current transformation matrix. |
| `nvgDegToRad` | `(deg: number) -> number` | Convert degrees to radians. |
| `nvgDelete` | `(ctx: NVGContextWrapper NanoVG context)` | Delete NanoVG context. |
| `nvgDeleteFont` | `(ctx: NVGContextWrapper, font: integer Font handle to delete) -> integer` | Delete a loaded font by handle. Returns 1 when deleted, or 0 for an in |
| `nvgDeleteImage` | `(ctx: NVGContextWrapper, image: integer Image handle to delete)` | Deletes created image. |
| `nvgDeleteVideo` | `(ctx: NVGContextWrapper NanoVG context, image: integer Image handle to delete)` | Delete a video image created by nvgCreateVideo. |
| `nvgEllipse` | `(ctx: NVGContextWrapper, cx: number, cy: number, rx: number, ry: number)` | Create new ellipse shaped sub-path. |
| `nvgEllipseArc` | `(ctx: NVGContextWrapper, cx: number, cy: number, rx: number, ry: number, rotation: number, a0: number, a1: number, dir: integer)` | Create new ellipse arc shaped sub-path. |
| `nvgEndFrame` | `(ctx: NVGContextWrapper NanoVG context)` | End drawing flushing remaining render state. |
| `nvgFill` | `(ctx: NVGContextWrapper)` | Fill the current path with current fill style. |
| `nvgFillColor` | `(ctx: NVGContextWrapper, color: NVGcolor)` | Set current fill style to a solid color. |
| `nvgFillPaint` | `(ctx: NVGContextWrapper, paint: NVGpaint)` | Set current fill style to a paint. |
| `nvgFillThinDedup` | `(ctx: NVGContextWrapper, enabled: integer)` |  |
| `nvgFindFont` | `(ctx: NVGContextWrapper, name: string) -> integer` | Find a loaded font of specified name. Returns handle to it, or -1 if n |
| `nvgFontBlur` | `(ctx: NVGContextWrapper, blur: number)` | Set the blur of current text style. |
| `nvgFontFace` | `(ctx: NVGContextWrapper, font: string)` | Set the font face based on specified name of current text style. |
| `nvgFontFaceId` | `(ctx: NVGContextWrapper, font: integer)` | Set the font face based on specified id of current text style. |
| `nvgFontSize` | `(ctx: NVGContextWrapper, size: number)` | Set the font size of current text style. |
| `nvgFontSizeMethod` | `(ctx: NVGContextWrapper, method: integer)` | Set the font size method for FreeType. NVG_SIZE_PIXEL (0): Use FT_Set_ |
| `nvgForceAutoHint` | `(ctx: NVGContextWrapper, enabled: integer)` | Set whether to use FreeType's auto-hinter (FT_LOAD_FORCE_AUTOHINT). De |
| `nvgGetFontSize` | `(ctx: NVGContextWrapper) -> number` | Get the font size of current text style. |
| `nvgGetFontSizeMethod` | `(ctx: NVGContextWrapper) -> integer` | Get the current font size method. |
| `nvgGetForceAutoHint` | `(ctx: NVGContextWrapper) -> integer` | Get whether FreeType's auto-hinter is enabled. |
| `nvgGetRenderStats` | `(ctx: NVGContextWrapper) -> integer` | Get NanoVG render stats from last frame. |
| `nvgGlobalAlpha` | `(ctx: NVGContextWrapper, alpha: number)` | Set the transparency applied to all rendered shapes. |
| `nvgGlobalCompositeBlendFunc` | `(ctx: NVGContextWrapper, sfactor: integer, dfactor: integer)` | Set the composite operation with custom pixel arithmetic. |
| `nvgGlobalCompositeBlendFuncSeparate` | `(ctx: NVGContextWrapper, srcRGB: integer, dstRGB: integer, srcAlpha: integer, dstAlpha: integer)` | Set the composite operation with custom pixel arithmetic for RGB and a |
| `nvgGlobalCompositeOperation` | `(ctx: NVGContextWrapper, op: integer)` | Set the composite operation. |
| `nvgHSL` | `(h: number, s: number, l: number) -> NVGcolor` | Create color from HSL (0.0-1.0). Alpha will be set to 255. |
| `nvgHSLA` | `(h: number, s: number, l: number, a: number -- unsigned char) -> NVGcolor` | Create color from HSLA. HSL in range [0.0-1.0], alpha in range [0-255] |
| `nvgImagePattern` | `(ctx: NVGContextWrapper, ox: number, oy: number, ex: number, ey: number, angle: number, image: integer, alpha: number) -> NVGpaint` | Create and return an image pattern. |
| `nvgImagePatternTinted` | `(ctx: NVGContextWrapper, ox: number, oy: number, ex: number, ey: number, angle: number, image: integer, color: NVGcolor) -> NVGpaint` | Create and return a tinted image pattern. The color tints the image (m |
| `nvgImageSize` | `(ctx: NVGContextWrapper NanoVG context, image: integer Image handle) -> integer` | Returns the dimensions of a created image. |
| `nvgIntersectScissor` | `(ctx: NVGContextWrapper, x: number, y: number, w: number, h: number)` | Intersect current scissor rectangle with the specified rectangle. |
| `nvgLerpRGBA` | `(c0: NVGcolor, c1: NVGcolor, u: number) -> NVGcolor` | Linearly interpolate from color c0 to c1. |
| `nvgLineCap` | `(ctx: NVGContextWrapper, cap: integer)` | Set how the end of the line (cap) is drawn. |
| `nvgLineJoin` | `(ctx: NVGContextWrapper, join: integer)` | Set how sharp path corners are drawn. |
| `nvgLineTo` | `(ctx: NVGContextWrapper, x: number, y: number)` | Add line segment from the last point in the path to the specified poin |
| `nvgLinearGradient` | `(ctx: NVGContextWrapper, sx: number, sy: number, ex: number, ey: number, icol: NVGcolor, ocol: NVGcolor) -> NVGpaint` | Create and return a linear gradient. |
| `nvgMiterLimit` | `(ctx: NVGContextWrapper, limit: number)` | Set the miter limit of the stroke style. |
| `nvgMoveTo` | `(ctx: NVGContextWrapper, x: number, y: number)` | Start new sub-path with specified point as first point. |
| `nvgPathWinding` | `(ctx: NVGContextWrapper, dir: integer)` | Set the current sub-path winding. |
| `nvgQuadTo` | `(ctx: NVGContextWrapper, cx: number, cy: number, x: number, y: number)` | Add quadratic bezier segment from last point in the path. |
| `nvgRGB` | `(r: number -- unsigned char, g: number -- unsigned char, b: number -- unsigned char) -> NVGcolor` | Create color from RGB values (0-255). Alpha will be set to 255. |
| `nvgRGBA` | `(r: number -- unsigned char, g: number -- unsigned char, b: number -- unsigned char, a: number -- unsigned char) -> NVGcolor` | Create color from RGBA values (0-255). |
| `nvgRGBAf` | `(r: number, g: number, b: number, a: number) -> NVGcolor` | Create color from RGBA float values (0.0-1.0). |
| `nvgRGBf` | `(r: number, g: number, b: number) -> NVGcolor` | Create color from RGB float values (0.0-1.0). Alpha will be set to 1.0 |
| `nvgRadToDeg` | `(rad: number) -> number` | Convert radians to degrees. |
| `nvgRadialGradient` | `(ctx: NVGContextWrapper, cx: number, cy: number, inr: number, outr: number, icol: NVGcolor, ocol: NVGcolor) -> NVGpaint` | Create and return a radial gradient. |
| `nvgRect` | `(ctx: NVGContextWrapper, x: number, y: number, w: number, h: number)` | Create new rectangle shaped sub-path. |
| `nvgReset` | `(ctx: NVGContextWrapper)` | Reset current render state to default values. |
| `nvgResetScissor` | `(ctx: NVGContextWrapper)` | Reset and disable scissoring. |
| `nvgResetTransform` | `(ctx: NVGContextWrapper)` | Reset current transform to identity matrix. |
| `nvgRestore` | `(ctx: NVGContextWrapper)` | Pop and restore current render state. |
| `nvgRotate` | `(ctx: NVGContextWrapper, angle: number)` | Rotate current coordinate system (angle in radians). |
| `nvgRoundedRect` | `(ctx: NVGContextWrapper, x: number, y: number, w: number, h: number, r: number)` | Create new rounded rectangle shaped sub-path. |
| `nvgRoundedRectVarying` | `(ctx: NVGContextWrapper, x: number, y: number, w: number, h: number, radTopLeft: number, radTopRight: number, radBottomRight: number, radBottomLeft: number)` | Create new rounded rectangle shaped sub-path with varying radii for ea |
| `nvgSave` | `(ctx: NVGContextWrapper)` | Push and save the current render state into a state stack. |
| `nvgScale` | `(ctx: NVGContextWrapper, x: number, y: number)` | Scale the current coordinate system. |
| `nvgScissor` | `(ctx: NVGContextWrapper, x: number, y: number, w: number, h: number)` | Set the current scissor rectangle. |
| `nvgSetBloomEnabled` | `(wrapper: NVGContextWrapper Wrapped context, enable: boolean Whether bloom is enabled)` | Set NanoVG bloom enable. |
| `nvgSetColorSpace` | `(wrapper: NVGContextWrapper Wrapped context, colorSpace: NVGColorSpace Color space to use)` | Set NanoVG color space. |
| `nvgSetRenderOrder` | `(ctx: NVGContextWrapper Wrapped context, renderOrder: integer Render priority value)` | Set NanoVG render order (priority). Lower values render first (at bott |
| `nvgSetRenderTarget` | `(ctx: NVGContextWrapper Wrapped context, renderTarget: Texture2D Render texture; pass nil explicitly to clear it)` | Set NanoVG context render to texture. |
| `nvgShapeAntiAlias` | `(ctx: NVGContextWrapper, enabled: integer)` | Set whether to draw antialias for stroke and fill. |
| `nvgSkewX` | `(ctx: NVGContextWrapper, angle: number)` | Skew the current coordinate system along X axis (angle in radians). |
| `nvgSkewY` | `(ctx: NVGContextWrapper, angle: number)` | Skew the current coordinate system along Y axis (angle in radians). |
| `nvgSpineCreate` | `(ctx: NVGContextWrapper NanoVG context (used only for context acquisition, not stored)) -> SpineInstance` | Create a new SpineInstance. |
| `nvgSpineRender` | `(ctx: NVGContextWrapper NanoVG context, instance: SpineInstance SpineInstance to render)` | Render a SpineInstance into the NanoVG command queue. Must be called b |
| `nvgStroke` | `(ctx: NVGContextWrapper)` | Stroke the current path with current stroke style. |
| `nvgStrokeColor` | `(ctx: NVGContextWrapper, color: NVGcolor)` | Set current stroke style to a solid color. |
| `nvgStrokePaint` | `(ctx: NVGContextWrapper, paint: NVGpaint)` | Set current stroke style to a paint. |
| `nvgStrokeWidth` | `(ctx: NVGContextWrapper, size: number)` | Set the stroke width of the stroke style. |
| `nvgSvgCreate` | `(ctx: NVGContextWrapper) -> SvgInstance` | Create an independent SVG instance, registering its resource type in t |
| `nvgSvgRender` | `(ctx: NVGContextWrapper, instance: SvgInstance) -> boolean` | Draw into an active NanoVG frame, preserving state but not an unfinish |
| `nvgText` | `(ctx: NVGContextWrapper, x: number, y: number, string: string, end_?: string) -> number` | Draw text string at specified location. Returns horizontal advance. |
| `nvgTextAlign` | `(ctx: NVGContextWrapper, align: integer)` | Set the text align of current text style. |
| `nvgTextBounds` | `(ctx: NVGContextWrapper, x: number, y: number, string: string, bounds?: number[] Optional reusable bounds table) -> number  (+1 重载)` | Measure text string. If bounds table is passed, it is reused (no alloc |
| `nvgTextBox` | `(ctx: NVGContextWrapper, x: number, y: number, breakRowWidth: number, string: string, end_?: string)` | Draw multi-line text string at specified location wrapped at the speci |
| `nvgTextBoxBounds` | `(ctx: NVGContextWrapper, x: number, y: number, breakRowWidth: number, string: string, bounds?: number[] Optional reusable bounds table) -> number[]  (+1 重载)` | Measure multi-line text string. If bounds table is passed, it is reuse |
| `nvgTextLetterSpacing` | `(ctx: NVGContextWrapper, spacing: number)` | Set the letter spacing of current text style. |
| `nvgTextLineHeight` | `(ctx: NVGContextWrapper, lineHeight: number)` | Set the proportional line height of current text style. |
| `nvgTextMetrics` | `(ctx: NVGContextWrapper) -> number` | Returns the vertical metrics based on the current text style. |
| `nvgTextScaleMode` | `(ctx: NVGContextWrapper, mode: integer)` | Set the text scale mode. Controls how font size is computed when a wid |
| `nvgTransRGBA` | `(c0: NVGcolor, a: number -- unsigned char) -> NVGcolor` | Set transparency of a color (0-255). |
| `nvgTransRGBAf` | `(c0: NVGcolor, a: number) -> NVGcolor` | Set transparency of a color (0.0-1.0). |
| `nvgTransform` | `(ctx: NVGContextWrapper, a: number, b: number, c: number, d: number, e: number, f: number)` | Premultiply current coordinate system by specified matrix. |
| `nvgTransformIdentity` | `(dst: table)` | Set the transform to identity matrix. |
| `nvgTransformRotate` | `(dst: table, a: number)` | Set the transform to rotate matrix (angle in radians). |
| `nvgTransformScale` | `(dst: table, sx: number, sy: number)` | Set the transform to scale matrix. |
| `nvgTransformSkewX` | `(dst: table, a: number)` | Set the transform to skew-x matrix (angle in radians). |
| `nvgTransformSkewY` | `(dst: table, a: number)` | Set the transform to skew-y matrix (angle in radians). |
| `nvgTransformTranslate` | `(dst: table, tx: number, ty: number)` | Set the transform to translation matrix. |
| `nvgTranslate` | `(ctx: NVGContextWrapper, x: number, y: number)` | Translate current coordinate system. |

### 其它全局变量（定义中出现的 `xxx = {}`）

| 名称 | 定义文件 |
|------|---------|
| `score` | Score.d.lua |
| `sdk` | Achievement.d.lua |

---

## 二、枚举常量

共 **124** 组、**1091** 个常量。harness 需全部注入全局表。

### AmbientSource

| 常量 | 值 |
|------|-----|
| `AMBIENT_PREBAKED` | `0` |
| `AMBIENT_SKYBOX` | `1` |
| `AMBIENT_COLOR` | `2` |

### AnimParamType

| 常量 | 值 |
|------|-----|
| `ANIM_PARAM_FLOAT` | `0` |
| `ANIM_PARAM_INT` | `1` |
| `ANIM_PARAM_BOOL` | `2` |
| `ANIM_PARAM_TRIGGER` | `3` |

### AnimationBlendMode

| 常量 | 值 |
|------|-----|
| `ABM_LERP` | `0` |
| `ABM_ADDITIVE` | `1` |

### AutoRemoveMode

| 常量 | 值 |
|------|-----|
| `REMOVE_DISABLED` | `0` |
| `REMOVE_COMPONENT` | `1` |
| `REMOVE_NODE` | `2` |

### BlendMode

| 常量 | 值 |
|------|-----|
| `BLEND_REPLACE` | `0` |
| `BLEND_ADD` | `1` |
| `BLEND_MULTIPLY` | `2` |
| `BLEND_ALPHA` | `3` |
| `BLEND_ADDALPHA` | `4` |
| `BLEND_PREMULALPHA` | `5` |
| `BLEND_INVDESTALPHA` | `6` |
| `BLEND_SUBTRACT` | `7` |
| `BLEND_SUBTRACTALPHA` | `8` |
| `MAX_BLENDMODES` | `9` |

### BloomMode

| 常量 | 值 |
|------|-----|
| `BLOOM_MODE_LEGACY` | `0` |
| `BLOOM_MODE_PLUS` | `1` |
| `BLOOM_MODE_UE` | `2` |

### BodyType2D

| 常量 | 值 |
|------|-----|
| `BT_STATIC` | `BT_STATIC  -- Original C++ value: b2_staticBody` |
| `BT_KINEMATIC` | `BT_KINEMATIC  -- Original C++ value: b2_kinematicBody` |
| `BT_DYNAMIC` | `BT_DYNAMIC  -- Original C++ value: b2_dynamicBody` |

### ClearTarget

| 常量 | 值 |
|------|-----|
| `CLEAR_COLOR` | `0` |
| `CLEAR_DEPTH` | `1` |
| `CLEAR_STENCIL` | `2` |

### CollisionEventMode

| 常量 | 值 |
|------|-----|
| `COLLISION_NEVER` | `0` |
| `COLLISION_ACTIVE` | `1` |
| `COLLISION_ALWAYS` | `2` |

### ColorLUTFormat

| 常量 | 值 |
|------|-----|
| `COLORLUT_TEXTURE3D` | `0` |
| `COLORLUT_TEXTURE2DSTRIP` | `1` |

### CompareMode

| 常量 | 值 |
|------|-----|
| `CMP_ALWAYS` | `0` |
| `CMP_EQUAL` | `1` |
| `CMP_NOTEQUAL` | `2` |
| `CMP_LESS` | `3` |
| `CMP_LESSEQUAL` | `4` |
| `CMP_GREATER` | `5` |
| `CMP_GREATEREQUAL` | `6` |
| `MAX_COMPAREMODES` | `7` |

### CompressedFormat

| 常量 | 值 |
|------|-----|
| `CF_NONE` | `0` |
| `CF_RGBA` | `1` |
| `CF_DXT1` | `2` |
| `CF_DXT3` | `3` |
| `CF_DXT5` | `4` |
| `CF_ETC1` | `5` |
| `CF_PVRTC_RGB_2BPP` | `6` |
| `CF_PVRTC_RGBA_2BPP` | `7` |
| `CF_PVRTC_RGB_4BPP` | `8` |
| `CF_PVRTC_RGBA_4BPP` | `9` |

### ConstraintType

| 常量 | 值 |
|------|-----|
| `CONSTRAINT_POINT` | `0` |
| `CONSTRAINT_HINGE` | `1` |
| `CONSTRAINT_SLIDER` | `2` |
| `CONSTRAINT_CONETWIST` | `3` |

### ControllerAxis

| 常量 | 值 |
|------|-----|
| `CONTROLLER_AXIS_LEFTX` | `0` |
| `CONTROLLER_AXIS_LEFTY` | `1` |
| `CONTROLLER_AXIS_RIGHTX` | `2` |
| `CONTROLLER_AXIS_RIGHTY` | `3` |
| `CONTROLLER_AXIS_TRIGGERLEFT` | `4` |
| `CONTROLLER_AXIS_TRIGGERRIGHT` | `5` |

### ControllerButton

| 常量 | 值 |
|------|-----|
| `CONTROLLER_BUTTON_A` | `0` |
| `CONTROLLER_BUTTON_B` | `1` |
| `CONTROLLER_BUTTON_X` | `2` |
| `CONTROLLER_BUTTON_Y` | `3` |
| `CONTROLLER_BUTTON_BACK` | `4` |
| `CONTROLLER_BUTTON_GUIDE` | `5` |
| `CONTROLLER_BUTTON_START` | `6` |
| `CONTROLLER_BUTTON_LEFTSTICK` | `7` |
| `CONTROLLER_BUTTON_RIGHTSTICK` | `8` |
| `CONTROLLER_BUTTON_LEFTSHOULDER` | `9` |
| `CONTROLLER_BUTTON_RIGHTSHOULDER` | `10` |
| `CONTROLLER_BUTTON_DPAD_UP` | `11` |
| `CONTROLLER_BUTTON_DPAD_DOWN` | `12` |
| `CONTROLLER_BUTTON_DPAD_LEFT` | `13` |
| `CONTROLLER_BUTTON_DPAD_RIGHT` | `14` |

### Corner

| 常量 | 值 |
|------|-----|
| `C_TOPLEFT` | `0` |
| `C_TOPRIGHT` | `1` |
| `C_BOTTOMLEFT` | `2` |
| `C_BOTTOMRIGHT` | `3` |
| `MAX_UIELEMENT_CORNERS` | `4` |

### CreateMode

| 常量 | 值 |
|------|-----|
| `REPLICATED` | `0` |
| `LOCAL` | `1` |

### CrowdAgentRequestedTarget

| 常量 | 值 |
|------|-----|
| `CA_REQUESTEDTARGET_NONE` | `0` |
| `CA_REQUESTEDTARGET_POSITION` | `1` |
| `CA_REQUESTEDTARGET_VELOCITY` | `2` |

### CrowdAgentState

| 常量 | 值 |
|------|-----|
| `CA_STATE_INVALID` | `0` |
| `CA_STATE_WALKING` | `1` |
| `CA_STATE_OFFMESH` | `2` |

### CrowdAgentTargetState

| 常量 | 值 |
|------|-----|
| `CA_TARGET_NONE` | `0` |
| `CA_TARGET_FAILED` | `1` |
| `CA_TARGET_VALID` | `2` |
| `CA_TARGET_REQUESTING` | `3` |
| `CA_TARGET_WAITINGFORQUEUE` | `4` |
| `CA_TARGET_WAITINGFORPATH` | `5` |
| `CA_TARGET_VELOCITY` | `6` |

### CubeMapFace

| 常量 | 值 |
|------|-----|
| `FACE_POSITIVE_X` | `0` |
| `FACE_NEGATIVE_X` | `1` |
| `FACE_POSITIVE_Y` | `2` |
| `FACE_NEGATIVE_Y` | `3` |
| `FACE_POSITIVE_Z` | `4` |
| `FACE_NEGATIVE_Z` | `5` |
| `MAX_CUBEMAP_FACES` | `6` |

### CullMode

| 常量 | 值 |
|------|-----|
| `CULL_NONE` | `0` |
| `CULL_CCW` | `1` |
| `CULL_CW` | `2` |
| `MAX_CULLMODES` | `3` |

### CursorShape

| 常量 | 值 |
|------|-----|
| `CS_NORMAL` | `0` |
| `CS_IBEAM` | `1` |
| `CS_CROSS` | `2` |
| `CS_RESIZEVERTICAL` | `3` |
| `CS_RESIZEDIAGONAL_TOPRIGHT` | `4` |
| `CS_RESIZEHORIZONTAL` | `5` |
| `CS_RESIZEDIAGONAL_TOPLEFT` | `6` |
| `CS_RESIZE_ALL` | `7` |
| `CS_ACCEPTDROP` | `8` |
| `CS_REJECTDROP` | `9` |
| `CS_BUSY` | `10` |
| `CS_BUSY_ARROW` | `11` |
| `CS_MAX_SHAPES` | `12` |

### DBAPI

| 常量 | 值 |
|------|-----|
| `DBAPI_SQLITE` | `0` |
| `DBAPI_ODBC` | `1` |

### DOFQuality

| 常量 | 值 |
|------|-----|
| `DOF_QUALITY_LOW` | `0` |
| `DOF_QUALITY_MEDIUM` | `1` |
| `DOF_QUALITY_HIGH` | `2` |

### DownloadPriority

| 常量 | 值 |
|------|-----|
| `DOWNLOAD_PRIORITY_LOW` | `0` |
| `DOWNLOAD_PRIORITY_NORMAL` | `50` |
| `DOWNLOAD_PRIORITY_HIGH` | `100` |
| `DOWNLOAD_PRIORITY_CRITICAL` | `200` |

### DownloadTaskState

| 常量 | 值 |
|------|-----|
| `DOWNLOAD_PENDING` | `0` |
| `DOWNLOAD_DOWNLOADING` | `1` |
| `DOWNLOAD_COMPLETED` | `2` |
| `DOWNLOAD_FAILED` | `3` |
| `DOWNLOAD_CANCELLED` | `4` |

### EmitterType

| 常量 | 值 |
|------|-----|
| `EMITTER_SPHERE` | `0` |
| `EMITTER_BOX` | `1` |

### EmitterType2D

| 常量 | 值 |
|------|-----|
| `EMITTER_TYPE_GRAVITY` | `0` |
| `EMITTER_TYPE_RADIAL` | `1` |

### FaceCameraMode

| 常量 | 值 |
|------|-----|
| `FC_NONE` | `0` |
| `FC_ROTATE_XYZ` | `1` |
| `FC_ROTATE_Y` | `2` |
| `FC_LOOKAT_XYZ` | `3` |
| `FC_LOOKAT_Y` | `4` |
| `FC_LOOKAT_MIXED` | `5` |
| `FC_DIRECTION` | `6` |

### FileMode

| 常量 | 值 |
|------|-----|
| `FILE_READ` | `0` |
| `FILE_WRITE` | `1` |
| `FILE_READWRITE` | `2` |

### FillMode

| 常量 | 值 |
|------|-----|
| `FILL_SOLID` | `0` |
| `FILL_WIREFRAME` | `1` |
| `FILL_POINT` | `2` |

### FocusMode

| 常量 | 值 |
|------|-----|
| `FM_NOTFOCUSABLE` | `0` |
| `FM_RESETFOCUS` | `1` |
| `FM_FOCUSABLE` | `2` |
| `FM_FOCUSABLE_DEFOCUSABLE` | `3` |

### FontHintLevel

| 常量 | 值 |
|------|-----|
| `FONT_HINT_LEVEL_NONE` | `0` |
| `FONT_HINT_LEVEL_LIGHT` | `1` |
| `FONT_HINT_LEVEL_NORMAL` | `2` |

### FontType

| 常量 | 值 |
|------|-----|
| `FONT_NONE` | `0` |
| `FONT_FREETYPE` | `1` |
| `FONT_BITMAP` | `2` |
| `MAX_FONT_TYPES` | `3` |

### FrustumPlane

| 常量 | 值 |
|------|-----|
| `PLANE_NEAR` | `0` |
| `PLANE_LEFT` | `1` |
| `PLANE_RIGHT` | `2` |
| `PLANE_UP` | `3` |
| `PLANE_DOWN` | `4` |
| `PLANE_FAR` | `5` |

### GeometryType

| 常量 | 值 |
|------|-----|
| `GEOM_STATIC` | `0` |
| `GEOM_SKINNED` | `1` |
| `GEOM_INSTANCED` | `2` |
| `GEOM_BILLBOARD` | `3` |
| `GEOM_STATIC_NOINSTANCING` | `4` |
| `MAX_GEOMETRYTYPES` | `4` |

### Handedness

| 常量 | 值 |
|------|-----|
| `HANDEDNESS_LH` | `0` |
| `HANDEDNESS_RH` | `1` |

### HatPosition

| 常量 | 值 |
|------|-----|
| `HAT_CENTER` | `0` |
| `HAT_UP` | `1` |
| `HAT_RIGHT` | `2` |
| `HAT_DOWN` | `3` |
| `HAT_LEFT` | `4` |

### HighlightMode

| 常量 | 值 |
|------|-----|
| `HM_NEVER` | `0` |
| `HM_FOCUS` | `1` |
| `HM_ALWAYS` | `2` |

### HorizontalAlignment

| 常量 | 值 |
|------|-----|
| `HA_LEFT` | `0` |
| `HA_CENTER` | `1` |
| `HA_RIGHT` | `2` |
| `HA_CUSTOM` | `3` |

### HttpMethod

| 常量 | 值 |
|------|-----|
| `HTTP_GET` | `0` |
| `HTTP_POST` | `1` |
| `HTTP_PUT` | `2` |
| `HTTP_DELETE` | `3` |
| `HTTP_PATCH` | `4` |

### HttpRequestState

| 常量 | 值 |
|------|-----|
| `HTTP_INITIALIZING` | `0` |
| `HTTP_ERROR` | `1` |
| `HTTP_OPEN` | `2` |
| `HTTP_CLOSED` | `3` |

### InterpMethod

| 常量 | 值 |
|------|-----|
| `IM_NONE` | `0` |
| `IM_LINEAR` | `1` |
| `IM_SPLINE` | `2` |

### InterpolationMode

| 常量 | 值 |
|------|-----|
| `BEZIER_CURVE` | `0` |
| `CATMULL_ROM_CURVE` | `1` |
| `LINEAR_CURVE` | `2` |
| `CATMULL_ROM_FULL_CURVE` | `3` |

### Intersection

| 常量 | 值 |
|------|-----|
| `OUTSIDE` | `0` |
| `INTERSECTS` | `1` |
| `INSIDE` | `2` |
| `M_PI` | `nil` |
| `M_HALF_PI` | `nil` |
| `M_MIN_INT` | `nil` |
| `M_MAX_INT` | `nil` |
| `M_MIN_UNSIGNED` | `nil` |
| `M_MAX_UNSIGNED` | `nil` |
| `M_EPSILON` | `nil` |
| `M_LARGE_EPSILON` | `nil` |
| `M_MIN_NEARCLIP` | `nil` |
| `M_MAX_FOV` | `nil` |
| `M_LARGE_VALUE` | `nil` |
| `M_INFINITY` | `nil` |
| `M_DEGTORAD` | `nil` |
| `M_DEGTORAD_2` | `nil` |
| `M_RADTODEG` | `nil` |

### JSONNumberType

| 常量 | 值 |
|------|-----|
| `JSONNT_NAN` | `0` |
| `JSONNT_INT` | `1` |
| `JSONNT_UINT` | `2` |
| `JSONNT_FLOAT_DOUBLE` | `3` |

### JSONValueType

| 常量 | 值 |
|------|-----|
| `JSON_NULL` | `0` |
| `JSON_BOOL` | `1` |
| `JSON_NUMBER` | `2` |
| `JSON_STRING` | `3` |
| `JSON_ARRAY` | `4` |
| `JSON_OBJECT` | `5` |

### Key

| 常量 | 值 |
|------|-----|
| `KEY_UNKNOWN` | `0` |
| `KEY_A` | `1` |
| `KEY_B` | `2` |
| `KEY_C` | `3` |
| `KEY_D` | `4` |
| `KEY_E` | `5` |
| `KEY_F` | `6` |
| `KEY_G` | `7` |
| `KEY_H` | `8` |
| `KEY_I` | `9` |
| `KEY_J` | `10` |
| `KEY_K` | `11` |
| `KEY_L` | `12` |
| `KEY_M` | `13` |
| `KEY_N` | `14` |
| `KEY_O` | `15` |
| `KEY_P` | `16` |
| `KEY_Q` | `17` |
| `KEY_R` | `18` |
| `KEY_S` | `19` |
| `KEY_T` | `20` |
| `KEY_U` | `21` |
| `KEY_V` | `22` |
| `KEY_W` | `23` |
| `KEY_X` | `24` |
| `KEY_Y` | `25` |
| `KEY_Z` | `26` |
| `KEY_0` | `27` |
| `KEY_1` | `28` |
| `KEY_2` | `29` |
| `KEY_3` | `30` |
| `KEY_4` | `31` |
| `KEY_5` | `32` |
| `KEY_6` | `33` |
| `KEY_7` | `34` |
| `KEY_8` | `35` |
| `KEY_9` | `36` |
| `KEY_BACKSPACE` | `37` |
| `KEY_TAB` | `38` |
| `KEY_RETURN` | `39` |
| `KEY_RETURN2` | `40` |
| `KEY_KP_ENTER` | `41` |
| `KEY_SHIFT` | `42` |
| `KEY_CTRL` | `43` |
| `KEY_ALT` | `44` |
| `KEY_GUI` | `45` |
| `KEY_PAUSE` | `46` |
| `KEY_CAPSLOCK` | `47` |
| `KEY_ESCAPE` | `48` |
| `KEY_SPACE` | `49` |
| `KEY_PAGEUP` | `50` |
| `KEY_PAGEDOWN` | `51` |
| `KEY_END` | `52` |
| `KEY_HOME` | `53` |
| `KEY_LEFT` | `54` |
| `KEY_UP` | `55` |
| `KEY_RIGHT` | `56` |
| `KEY_DOWN` | `57` |
| `KEY_SELECT` | `58` |
| `KEY_PRINTSCREEN` | `59` |
| `KEY_INSERT` | `60` |
| `KEY_DELETE` | `61` |
| `KEY_LGUI` | `62` |
| `KEY_RGUI` | `63` |
| `KEY_APPLICATION` | `64` |
| `KEY_KP_0` | `65` |
| `KEY_KP_1` | `66` |
| `KEY_KP_2` | `67` |
| `KEY_KP_3` | `68` |
| `KEY_KP_4` | `69` |
| `KEY_KP_5` | `70` |
| `KEY_KP_6` | `71` |
| `KEY_KP_7` | `72` |
| `KEY_KP_8` | `73` |
| `KEY_KP_9` | `74` |
| `KEY_KP_MULTIPLY` | `75` |
| `KEY_KP_PLUS` | `76` |
| `KEY_KP_MINUS` | `77` |
| `KEY_KP_PERIOD` | `78` |
| `KEY_KP_DIVIDE` | `79` |
| `KEY_F1` | `80` |
| `KEY_F2` | `81` |
| `KEY_F3` | `82` |
| `KEY_F4` | `83` |
| `KEY_F5` | `84` |
| `KEY_F6` | `85` |
| `KEY_F7` | `86` |
| `KEY_F8` | `87` |
| `KEY_F9` | `88` |
| `KEY_F10` | `89` |
| `KEY_F11` | `90` |
| `KEY_F12` | `91` |
| `KEY_F13` | `92` |
| `KEY_F14` | `93` |
| `KEY_F15` | `94` |
| `KEY_F16` | `95` |
| `KEY_F17` | `96` |
| `KEY_F18` | `97` |
| `KEY_F19` | `98` |
| `KEY_F20` | `99` |
| `KEY_F21` | `100` |
| `KEY_F22` | `101` |
| `KEY_F23` | `102` |
| `KEY_F24` | `103` |
| `KEY_NUMLOCKCLEAR` | `104` |
| `KEY_SCROLLLOCK` | `105` |
| `KEY_LSHIFT` | `106` |
| `KEY_RSHIFT` | `107` |
| `KEY_LCTRL` | `108` |
| `KEY_RCTRL` | `109` |
| `KEY_LALT` | `110` |
| `KEY_RALT` | `111` |
| `KEY_AC_BACK` | `112` |
| `KEY_AC_BOOKMARKS` | `113` |
| `KEY_AC_FORWARD` | `114` |
| `KEY_AC_HOME` | `115` |
| `KEY_AC_REFRESH` | `116` |
| `KEY_AC_SEARCH` | `117` |
| `KEY_AC_STOP` | `118` |
| `KEY_AGAIN` | `119` |
| `KEY_ALTERASE` | `120` |
| `KEY_AMPERSAND` | `121` |
| `KEY_ASTERISK` | `122` |
| `KEY_AT` | `123` |
| `KEY_AUDIOMUTE` | `124` |
| `KEY_AUDIONEXT` | `125` |
| `KEY_AUDIOPLAY` | `126` |
| `KEY_AUDIOPREV` | `127` |
| `KEY_AUDIOSTOP` | `128` |
| `KEY_BACKQUOTE` | `129` |
| `KEY_BACKSLASH` | `130` |
| `KEY_BRIGHTNESSDOWN` | `131` |
| `KEY_BRIGHTNESSUP` | `132` |
| `KEY_CALCULATOR` | `133` |
| `KEY_CANCEL` | `134` |
| `KEY_CARET` | `135` |
| `KEY_CLEAR` | `136` |
| `KEY_CLEARAGAIN` | `137` |
| `KEY_COLON` | `138` |
| `KEY_COMMA` | `139` |
| `KEY_COMPUTER` | `140` |
| `KEY_COPY` | `141` |
| `KEY_CRSEL` | `142` |
| `KEY_CURRENCYSUBUNIT` | `143` |
| `KEY_CURRENCYUNIT` | `144` |
| `KEY_CUT` | `145` |
| `KEY_DECIMALSEPARATOR` | `146` |
| `KEY_DISPLAYSWITCH` | `147` |
| `KEY_DOLLAR` | `148` |
| `KEY_EJECT` | `149` |
| `KEY_EQUALS` | `150` |
| `KEY_EXCLAIM` | `151` |
| `KEY_EXSEL` | `152` |
| `KEY_FIND` | `153` |
| `KEY_GREATER` | `154` |
| `KEY_HASH` | `155` |
| `KEY_HELP` | `156` |
| `KEY_KBDILLUMDOWN` | `157` |
| `KEY_KBDILLUMTOGGLE` | `158` |
| `KEY_KBDILLUMUP` | `159` |
| `KEY_KP_00` | `160` |
| `KEY_KP_000` | `161` |
| `KEY_KP_A` | `162` |
| `KEY_KP_AMPERSAND` | `163` |
| `KEY_KP_AT` | `164` |
| `KEY_KP_B` | `165` |
| `KEY_KP_BACKSPACE` | `166` |
| `KEY_KP_BINARY` | `167` |
| `KEY_KP_C` | `168` |
| `KEY_KP_CLEAR` | `169` |
| `KEY_KP_CLEARENTRY` | `170` |
| `KEY_KP_COLON` | `171` |
| `KEY_KP_COMMA` | `172` |
| `KEY_KP_D` | `173` |
| `KEY_KP_DBLAMPERSAND` | `174` |
| `KEY_KP_DBLVERTICALBAR` | `175` |
| `KEY_KP_DECIMAL` | `176` |
| `KEY_KP_E` | `177` |
| `KEY_KP_EQUALS` | `178` |
| `KEY_KP_EQUALSAS400` | `179` |
| `KEY_KP_EXCLAM` | `180` |
| `KEY_KP_F` | `181` |
| `KEY_KP_GREATER` | `182` |
| `KEY_KP_HASH` | `183` |
| `KEY_KP_HEXADECIMAL` | `184` |
| `KEY_KP_LEFTBRACE` | `185` |
| `KEY_KP_LEFTPAREN` | `186` |
| `KEY_KP_LESS` | `187` |
| `KEY_KP_MEMADD` | `188` |
| `KEY_KP_MEMCLEAR` | `189` |
| `KEY_KP_MEMDIVIDE` | `190` |
| `KEY_KP_MEMMULTIPLY` | `191` |
| `KEY_KP_MEMRECALL` | `192` |
| `KEY_KP_MEMSTORE` | `193` |
| `KEY_KP_MEMSUBTRACT` | `194` |
| `KEY_KP_OCTAL` | `195` |
| `KEY_KP_PERCENT` | `196` |
| `KEY_KP_PLUSMINUS` | `197` |
| `KEY_KP_POWER` | `198` |
| `KEY_KP_RIGHTBRACE` | `199` |
| `KEY_KP_RIGHTPAREN` | `200` |
| `KEY_KP_SPACE` | `201` |
| `KEY_KP_TAB` | `202` |
| `KEY_KP_VERTICALBAR` | `203` |
| `KEY_KP_XOR` | `204` |
| `KEY_LEFTBRACKET` | `205` |
| `KEY_LEFTPAREN` | `206` |
| `KEY_LESS` | `207` |
| `KEY_MAIL` | `208` |
| `KEY_MEDIASELECT` | `209` |
| `KEY_MENU` | `210` |
| `KEY_MINUS` | `211` |
| `KEY_MODE` | `212` |
| `KEY_MUTE` | `213` |
| `KEY_OPER` | `214` |
| `KEY_OUT` | `215` |
| `KEY_PASTE` | `216` |
| `KEY_PERCENT` | `217` |
| `KEY_PERIOD` | `218` |
| `KEY_PLUS` | `219` |
| `KEY_POWER` | `220` |
| `KEY_PRIOR` | `221` |
| `KEY_QUESTION` | `222` |
| `KEY_QUOTE` | `223` |
| `KEY_QUOTEDBL` | `224` |
| `KEY_RIGHTBRACKET` | `225` |
| `KEY_RIGHTPAREN` | `226` |
| `KEY_SEMICOLON` | `227` |
| `KEY_SEPARATOR` | `228` |
| `KEY_SLASH` | `229` |
| `KEY_SLEEP` | `230` |
| `KEY_STOP` | `231` |
| `KEY_SYSREQ` | `232` |
| `KEY_THOUSANDSSEPARATOR` | `233` |
| `KEY_UNDERSCORE` | `234` |
| `KEY_UNDO` | `235` |
| `KEY_VOLUMEDOWN` | `236` |
| `KEY_VOLUMEUP` | `237` |
| `KEY_WWW` | `238` |

### LayoutMode

| 常量 | 值 |
|------|-----|
| `LM_FREE` | `0` |
| `LM_HORIZONTAL` | `1` |
| `LM_VERTICAL` | `2` |

### LegacyVertexElement

| 常量 | 值 |
|------|-----|
| `ELEMENT_POSITION` | `0` |
| `ELEMENT_NORMAL` | `1` |
| `ELEMENT_COLOR` | `2` |
| `ELEMENT_TEXCOORD1` | `3` |
| `ELEMENT_TEXCOORD2` | `4` |
| `ELEMENT_CUBETEXCOORD1` | `5` |
| `ELEMENT_CUBETEXCOORD2` | `6` |
| `ELEMENT_TANGENT` | `7` |
| `ELEMENT_BLENDWEIGHTS` | `8` |
| `ELEMENT_BLENDINDICES` | `9` |
| `ELEMENT_INSTANCEMATRIX1` | `10` |
| `ELEMENT_INSTANCEMATRIX2` | `11` |
| `ELEMENT_INSTANCEMATRIX3` | `12` |
| `ELEMENT_OBJECTINDEX` | `13` |
| `MAX_LEGACY_VERTEX_ELEMENTS` | `14` |

### LightType

| 常量 | 值 |
|------|-----|
| `LIGHT_DIRECTIONAL` | `0` |
| `LIGHT_SPOT` | `1` |
| `LIGHT_POINT` | `2` |
| `LIGHT_RECT` | `3` |

### LoadMode

| 常量 | 值 |
|------|-----|
| `LOAD_RESOURCES_ONLY` | `0` |
| `LOAD_SCENE` | `1` |
| `LOAD_SCENE_AND_RESOURCES` | `2` |

### LockState

| 常量 | 值 |
|------|-----|
| `LOCK_NONE` | `0` |
| `LOCK_HARDWARE` | `1` |
| `LOCK_SHADOW` | `2` |
| `LOCK_SCRATCH` | `3` |

### LoopMode2D

| 常量 | 值 |
|------|-----|
| `LM_DEFAULT` | `0` |
| `LM_FORCE_LOOPED` | `1` |
| `LM_FORCE_CLAMPED` | `2` |

### MaterialQuality

| 常量 | 值 |
|------|-----|
| `QUALITY_LOW` | `0` |
| `QUALITY_MEDIUM` | `1` |
| `QUALITY_HIGH` | `2` |
| `QUALITY_MAX` | `3` |

### MouseButton

| 常量 | 值 |
|------|-----|
| `MOUSEB_LEFT` | `0` |
| `MOUSEB_MIDDLE` | `1` |
| `MOUSEB_RIGHT` | `2` |

### MouseMode

| 常量 | 值 |
|------|-----|
| `MM_ABSOLUTE` | `0` |
| `MM_RELATIVE` | `1` |
| `MM_WRAP` | `2` |
| `MM_FREE` | `3` |

### NVGColorSpace

| 常量 | 值 |
|------|-----|
| `NVG_COLOR_GAMMA` | `0` |
| `NVG_COLOR_LINEAR` | `1` |

### NVGalign

| 常量 | 值 |
|------|-----|
| `NVG_ALIGN_LEFT` | `1<<0` |
| `NVG_ALIGN_CENTER` | `1<<1` |
| `NVG_ALIGN_RIGHT` | `1<<2` |
| `NVG_ALIGN_CENTER_VISUAL` | `1<<7` |
| `NVG_ALIGN_TOP` | `1<<3` |
| `NVG_ALIGN_MIDDLE` | `1<<4` |
| `NVG_ALIGN_BOTTOM` | `1<<5` |
| `NVG_ALIGN_BASELINE` | `1<<6` |

### NVGblendFactor

| 常量 | 值 |
|------|-----|
| `NVG_ZERO` | `1<<0` |
| `NVG_ONE` | `1<<1` |
| `NVG_SRC_COLOR` | `1<<2` |
| `NVG_ONE_MINUS_SRC_COLOR` | `1<<3` |
| `NVG_DST_COLOR` | `1<<4` |
| `NVG_ONE_MINUS_DST_COLOR` | `1<<5` |
| `NVG_SRC_ALPHA` | `1<<6` |
| `NVG_ONE_MINUS_SRC_ALPHA` | `1<<7` |
| `NVG_DST_ALPHA` | `1<<8` |
| `NVG_ONE_MINUS_DST_ALPHA` | `1<<9` |
| `NVG_SRC_ALPHA_SATURATE` | `1<<10` |

### NVGcompositeOperation

| 常量 | 值 |
|------|-----|
| `NVG_SOURCE_OVER` | `0` |
| `NVG_SOURCE_IN` | `1` |
| `NVG_SOURCE_OUT` | `2` |
| `NVG_ATOP` | `3` |
| `NVG_DESTINATION_OVER` | `4` |
| `NVG_DESTINATION_IN` | `5` |
| `NVG_DESTINATION_OUT` | `6` |
| `NVG_DESTINATION_ATOP` | `7` |
| `NVG_LIGHTER` | `8` |
| `NVG_COPY` | `9` |
| `NVG_XOR` | `10` |

### NVGimageFlags

| 常量 | 值 |
|------|-----|
| `NVG_IMAGE_GENERATE_MIPMAPS` | `1<<0` |
| `NVG_IMAGE_REPEATX` | `1<<1` |
| `NVG_IMAGE_REPEATY` | `1<<2` |
| `NVG_IMAGE_FLIPY` | `1<<3` |
| `NVG_IMAGE_PREMULTIPLIED` | `1<<4` |
| `NVG_IMAGE_NEAREST` | `1<<5` |

### NVGlineCap

| 常量 | 值 |
|------|-----|
| `NVG_BUTT` | `0` |
| `NVG_ROUND` | `1` |
| `NVG_SQUARE` | `2` |
| `NVG_BEVEL` | `3` |
| `NVG_MITER` | `4` |

### NVGsizeMethod

| 常量 | 值 |
|------|-----|
| `NVG_SIZE_PIXEL` | `0` |
| `NVG_SIZE_CHAR` | `1` |

### NVGsolidity

| 常量 | 值 |
|------|-----|
| `NVG_SOLID` | `1` |
| `NVG_HOLE` | `2` |

### NVGtextScaleMode

| 常量 | 值 |
|------|-----|
| `NVG_TEXT_SCALE_FULL` | `0` |
| `NVG_TEXT_SCALE_DPR_ONLY` | `1` |

### NVGwinding

| 常量 | 值 |
|------|-----|
| `NVG_CCW` | `1` |
| `NVG_CW` | `2` |

### NavigationPushiness

| 常量 | 值 |
|------|-----|
| `NAVIGATIONPUSHINESS_LOW` | `0` |
| `NAVIGATIONPUSHINESS_MEDIUM` | `1` |
| `NAVIGATIONPUSHINESS_HIGH` | `2` |
| `NAVIGATIONPUSHINESS_NONE` | `3` |

### NavigationQuality

| 常量 | 值 |
|------|-----|
| `NAVIGATIONQUALITY_LOW` | `0` |
| `NAVIGATIONQUALITY_MEDIUM` | `1` |
| `NAVIGATIONQUALITY_HIGH` | `2` |

### NavmeshPartitionType

| 常量 | 值 |
|------|-----|
| `NAVMESH_PARTITION_WATERSHED` | `0` |
| `NAVMESH_PARTITION_MONOTONE` | `1` |

### Orientation

| 常量 | 值 |
|------|-----|
| `O_HORIZONTAL` | `0` |
| `O_VERTICAL` | `1` |

### Orientation2D

| 常量 | 值 |
|------|-----|
| `O_ORTHOGONAL` | `0` |
| `O_ISOMETRIC` | `1` |
| `O_STAGGERED` | `2` |
| `O_HEXAGONAL` | `3` |

### PackageIOMode

| 常量 | 值 |
|------|-----|
| `PACKAGE_AUTO_CLOSE` | `0` |
| `PACKAGE_HOLDING` | `1` |
| `MAX_PACKAGE_IOMODE` | `2` |

### PaintBlendMode

| 常量 | 值 |
|------|-----|
| `PAINT_BLEND_REPLACE` | `0` |
| `PAINT_BLEND_ADD` | `1` |
| `PAINT_BLEND_ERASE` | `2` |

### PassLightingMode

| 常量 | 值 |
|------|-----|
| `LIGHTING_UNLIT` | `0` |
| `LIGHTING_PERVERTEX` | `1` |
| `LIGHTING_PERPIXEL` | `2` |

### PrimitiveType

| 常量 | 值 |
|------|-----|
| `TRIANGLE_LIST` | `0` |
| `LINE_LIST` | `1` |
| `POINT_LIST` | `2` |
| `TRIANGLE_STRIP` | `3` |
| `LINE_STRIP` | `4` |
| `TRIANGLE_FAN` | `5` |

### Qualifier

| 常量 | 值 |
|------|-----|
| `QUAL_SHIFT` | `0` |
| `QUAL_CTRL` | `1` |
| `QUAL_ALT` | `2` |
| `QUAL_ANY` | `3` |

### RayQueryLevel

| 常量 | 值 |
|------|-----|
| `RAY_AABB` | `0` |
| `RAY_OBB` | `1` |
| `RAY_TRIANGLE` | `2` |
| `RAY_TRIANGLE_UV` | `3` |
| `RAY_CONVEXHULL` | `4` |

### RenderCommandRole

| 常量 | 值 |
|------|-----|
| `RP_ROLE_NONE` | `0` |
| `RP_ROLE_TAA_RESOLVE` | `1` |
| `RP_ROLE_CAMERA_MOTION` | `2` |
| `RP_ROLE_OBJECT_MOTION` | `3` |
| `RP_ROLE_COMPUTE_SSAO` | `4` |
| `RP_ROLE_VDM_DEPTH` | `5` |
| `RP_ROLE_GBUFFER` | `6` |
| `RP_ROLE_SCENE_DEPTH_HISTORY` | `7` |

### RenderCommandSortMode

| 常量 | 值 |
|------|-----|
| `SORT_FRONTTOBACK` | `0` |
| `SORT_BACKTOFRONT` | `1` |

### RenderCommandType

| 常量 | 值 |
|------|-----|
| `CMD_NONE` | `0` |
| `CMD_CLEAR` | `1` |
| `CMD_SCENEPASS` | `2` |
| `CMD_QUAD` | `3` |
| `CMD_FORWARDLIGHTS` | `4` |
| `CMD_LIGHTVOLUMES` | `5` |
| `CMD_RENDERUI` | `6` |
| `CMD_SENDEVENT` | `9` |
| `CMD_GBUFFERPOSTPROCESS` | `21` |
| `CMD_VOLUMETRIC_CLOUD` | `22` |
| `CMD_VOLUMETRIC_CLOUD_SHADOW` | `23` |
| `CMD_VOLUMETRIC_CLOUD_TEMPORAL` | `24` |
| `CMD_VOLUMETRIC_CLOUD_SKY_AO` | `25` |
| `CMD_SKY_ATMOSPHERE` | `27` |
| `CMD_VOLUMETRIC_CLOUD_COMPOSE` | `26` |

### RenderPathInputType

| 常量 | 值 |
|------|-----|
| `RP_INPUT_TEXTURE` | `0` |
| `RP_INPUT_TEXTURE2D` | `1` |
| `RP_INPUT_TEXTURE3D` | `2` |
| `RP_INPUT_TEXTURECUBE` | `3` |
| `RP_INPUT_TEXTURE2DARRAY` | `4` |

### RenderSurfaceUpdateMode

| 常量 | 值 |
|------|-----|
| `SURFACE_MANUALUPDATE` | `0` |
| `SURFACE_UPDATEVISIBLE` | `1` |
| `SURFACE_UPDATEALWAYS` | `2` |

### RenderTargetSizeMode

| 常量 | 值 |
|------|-----|
| `SIZE_ABSOLUTE` | `0` |
| `SIZE_VIEWPORTDIVISOR` | `1` |
| `SIZE_VIEWPORTMULTIPLIER` | `2` |

### RootMotionChannel

| 常量 | 值 |
|------|-----|
| `ROOT_MOTION_POSITION_X` | `1` |
| `ROOT_MOTION_POSITION_Y` | `2` |
| `ROOT_MOTION_POSITION_Z` | `4` |
| `ROOT_MOTION_ROTATION` | `8` |
| `ROOT_MOTION_DEFAULT_CHANNELS` | `13` |
| `ROOT_MOTION_ALL_CHANNELS` | `15` |

### Scancode

| 常量 | 值 |
|------|-----|
| `SCANCODE_UNKNOWN` | `0` |
| `SCANCODE_CTRL` | `1` |
| `SCANCODE_SHIFT` | `2` |
| `SCANCODE_ALT` | `3` |
| `SCANCODE_GUI` | `4` |
| `SCANCODE_A` | `5` |
| `SCANCODE_B` | `6` |
| `SCANCODE_C` | `7` |
| `SCANCODE_D` | `8` |
| `SCANCODE_E` | `9` |
| `SCANCODE_F` | `10` |
| `SCANCODE_G` | `11` |
| `SCANCODE_H` | `12` |
| `SCANCODE_I` | `13` |
| `SCANCODE_J` | `14` |
| `SCANCODE_K` | `15` |
| `SCANCODE_L` | `16` |
| `SCANCODE_M` | `17` |
| `SCANCODE_N` | `18` |
| `SCANCODE_O` | `19` |
| `SCANCODE_P` | `20` |
| `SCANCODE_Q` | `21` |
| `SCANCODE_R` | `22` |
| `SCANCODE_S` | `23` |
| `SCANCODE_T` | `24` |
| `SCANCODE_U` | `25` |
| `SCANCODE_V` | `26` |
| `SCANCODE_W` | `27` |
| `SCANCODE_X` | `28` |
| `SCANCODE_Y` | `29` |
| `SCANCODE_Z` | `30` |
| `SCANCODE_1` | `31` |
| `SCANCODE_2` | `32` |
| `SCANCODE_3` | `33` |
| `SCANCODE_4` | `34` |
| `SCANCODE_5` | `35` |
| `SCANCODE_6` | `36` |
| `SCANCODE_7` | `37` |
| `SCANCODE_8` | `38` |
| `SCANCODE_9` | `39` |
| `SCANCODE_0` | `40` |
| `SCANCODE_RETURN` | `41` |
| `SCANCODE_ESCAPE` | `42` |
| `SCANCODE_BACKSPACE` | `43` |
| `SCANCODE_TAB` | `44` |
| `SCANCODE_SPACE` | `45` |
| `SCANCODE_MINUS` | `46` |
| `SCANCODE_EQUALS` | `47` |
| `SCANCODE_LEFTBRACKET` | `48` |
| `SCANCODE_RIGHTBRACKET` | `49` |
| `SCANCODE_BACKSLASH` | `50` |
| `SCANCODE_NONUSHASH` | `51` |
| `SCANCODE_SEMICOLON` | `52` |
| `SCANCODE_APOSTROPHE` | `53` |
| `SCANCODE_GRAVE` | `54` |
| `SCANCODE_COMMA` | `55` |
| `SCANCODE_PERIOD` | `56` |
| `SCANCODE_SLASH` | `57` |
| `SCANCODE_CAPSLOCK` | `58` |
| `SCANCODE_F1` | `59` |
| `SCANCODE_F2` | `60` |
| `SCANCODE_F3` | `61` |
| `SCANCODE_F4` | `62` |
| `SCANCODE_F5` | `63` |
| `SCANCODE_F6` | `64` |
| `SCANCODE_F7` | `65` |
| `SCANCODE_F8` | `66` |
| `SCANCODE_F9` | `67` |
| `SCANCODE_F10` | `68` |
| `SCANCODE_F11` | `69` |
| `SCANCODE_F12` | `70` |
| `SCANCODE_PRINTSCREEN` | `71` |
| `SCANCODE_SCROLLLOCK` | `72` |
| `SCANCODE_PAUSE` | `73` |
| `SCANCODE_INSERT` | `74` |
| `SCANCODE_HOME` | `75` |
| `SCANCODE_PAGEUP` | `76` |
| `SCANCODE_DELETE` | `77` |
| `SCANCODE_END` | `78` |
| `SCANCODE_PAGEDOWN` | `79` |
| `SCANCODE_RIGHT` | `80` |
| `SCANCODE_LEFT` | `81` |
| `SCANCODE_DOWN` | `82` |
| `SCANCODE_UP` | `83` |
| `SCANCODE_NUMLOCKCLEAR` | `84` |
| `SCANCODE_KP_DIVIDE` | `85` |
| `SCANCODE_KP_MULTIPLY` | `86` |
| `SCANCODE_KP_MINUS` | `87` |
| `SCANCODE_KP_PLUS` | `88` |
| `SCANCODE_KP_ENTER` | `89` |
| `SCANCODE_KP_1` | `90` |
| `SCANCODE_KP_2` | `91` |
| `SCANCODE_KP_3` | `92` |
| `SCANCODE_KP_4` | `93` |
| `SCANCODE_KP_5` | `94` |
| `SCANCODE_KP_6` | `95` |
| `SCANCODE_KP_7` | `96` |
| `SCANCODE_KP_8` | `97` |
| `SCANCODE_KP_9` | `98` |
| `SCANCODE_KP_0` | `99` |
| `SCANCODE_KP_PERIOD` | `100` |
| `SCANCODE_NONUSBACKSLASH` | `101` |
| `SCANCODE_APPLICATION` | `102` |
| `SCANCODE_POWER` | `103` |
| `SCANCODE_KP_EQUALS` | `104` |
| `SCANCODE_F13` | `105` |
| `SCANCODE_F14` | `106` |
| `SCANCODE_F15` | `107` |
| `SCANCODE_F16` | `108` |
| `SCANCODE_F17` | `109` |
| `SCANCODE_F18` | `110` |
| `SCANCODE_F19` | `111` |
| `SCANCODE_F20` | `112` |
| `SCANCODE_F21` | `113` |
| `SCANCODE_F22` | `114` |
| `SCANCODE_F23` | `115` |
| `SCANCODE_F24` | `116` |
| `SCANCODE_EXECUTE` | `117` |
| `SCANCODE_HELP` | `118` |
| `SCANCODE_MENU` | `119` |
| `SCANCODE_SELECT` | `120` |
| `SCANCODE_STOP` | `121` |
| `SCANCODE_AGAIN` | `122` |
| `SCANCODE_UNDO` | `123` |
| `SCANCODE_CUT` | `124` |
| `SCANCODE_COPY` | `125` |
| `SCANCODE_PASTE` | `126` |
| `SCANCODE_FIND` | `127` |
| `SCANCODE_MUTE` | `128` |
| `SCANCODE_VOLUMEUP` | `129` |
| `SCANCODE_VOLUMEDOWN` | `130` |
| `SCANCODE_KP_COMMA` | `131` |
| `SCANCODE_KP_EQUALSAS400` | `132` |
| `SCANCODE_INTERNATIONAL1` | `133` |
| `SCANCODE_INTERNATIONAL2` | `134` |
| `SCANCODE_INTERNATIONAL3` | `135` |
| `SCANCODE_INTERNATIONAL4` | `136` |
| `SCANCODE_INTERNATIONAL5` | `137` |
| `SCANCODE_INTERNATIONAL6` | `138` |
| `SCANCODE_INTERNATIONAL7` | `139` |
| `SCANCODE_INTERNATIONAL8` | `140` |
| `SCANCODE_INTERNATIONAL9` | `141` |
| `SCANCODE_LANG1` | `142` |
| `SCANCODE_LANG2` | `143` |
| `SCANCODE_LANG3` | `144` |
| `SCANCODE_LANG4` | `145` |
| `SCANCODE_LANG5` | `146` |
| `SCANCODE_LANG6` | `147` |
| `SCANCODE_LANG7` | `148` |
| `SCANCODE_LANG8` | `149` |
| `SCANCODE_LANG9` | `150` |
| `SCANCODE_ALTERASE` | `151` |
| `SCANCODE_SYSREQ` | `152` |
| `SCANCODE_CANCEL` | `153` |
| `SCANCODE_CLEAR` | `154` |
| `SCANCODE_PRIOR` | `155` |
| `SCANCODE_RETURN2` | `156` |
| `SCANCODE_SEPARATOR` | `157` |
| `SCANCODE_OUT` | `158` |
| `SCANCODE_OPER` | `159` |
| `SCANCODE_CLEARAGAIN` | `160` |
| `SCANCODE_CRSEL` | `161` |
| `SCANCODE_EXSEL` | `162` |
| `SCANCODE_KP_00` | `163` |
| `SCANCODE_KP_000` | `164` |
| `SCANCODE_THOUSANDSSEPARATOR` | `165` |
| `SCANCODE_DECIMALSEPARATOR` | `166` |
| `SCANCODE_CURRENCYUNIT` | `167` |
| `SCANCODE_CURRENCYSUBUNIT` | `168` |
| `SCANCODE_KP_LEFTPAREN` | `169` |
| `SCANCODE_KP_RIGHTPAREN` | `170` |
| `SCANCODE_KP_LEFTBRACE` | `171` |
| `SCANCODE_KP_RIGHTBRACE` | `172` |
| `SCANCODE_KP_TAB` | `173` |
| `SCANCODE_KP_BACKSPACE` | `174` |
| `SCANCODE_KP_A` | `175` |
| `SCANCODE_KP_B` | `176` |
| `SCANCODE_KP_C` | `177` |
| `SCANCODE_KP_D` | `178` |
| `SCANCODE_KP_E` | `179` |
| `SCANCODE_KP_F` | `180` |
| `SCANCODE_KP_XOR` | `181` |
| `SCANCODE_KP_POWER` | `182` |
| `SCANCODE_KP_PERCENT` | `183` |
| `SCANCODE_KP_LESS` | `184` |
| `SCANCODE_KP_GREATER` | `185` |
| `SCANCODE_KP_AMPERSAND` | `186` |
| `SCANCODE_KP_DBLAMPERSAND` | `187` |
| `SCANCODE_KP_VERTICALBAR` | `188` |
| `SCANCODE_KP_DBLVERTICALBAR` | `189` |
| `SCANCODE_KP_COLON` | `190` |
| `SCANCODE_KP_HASH` | `191` |
| `SCANCODE_KP_SPACE` | `192` |
| `SCANCODE_KP_AT` | `193` |
| `SCANCODE_KP_EXCLAM` | `194` |
| `SCANCODE_KP_MEMSTORE` | `195` |
| `SCANCODE_KP_MEMRECALL` | `196` |
| `SCANCODE_KP_MEMCLEAR` | `197` |
| `SCANCODE_KP_MEMADD` | `198` |
| `SCANCODE_KP_MEMSUBTRACT` | `199` |
| `SCANCODE_KP_MEMMULTIPLY` | `200` |
| `SCANCODE_KP_MEMDIVIDE` | `201` |
| `SCANCODE_KP_PLUSMINUS` | `202` |
| `SCANCODE_KP_CLEAR` | `203` |
| `SCANCODE_KP_CLEARENTRY` | `204` |
| `SCANCODE_KP_BINARY` | `205` |
| `SCANCODE_KP_OCTAL` | `206` |
| `SCANCODE_KP_DECIMAL` | `207` |
| `SCANCODE_KP_HEXADECIMAL` | `208` |
| `SCANCODE_LCTRL` | `209` |
| `SCANCODE_LSHIFT` | `210` |
| `SCANCODE_LALT` | `211` |
| `SCANCODE_LGUI` | `212` |
| `SCANCODE_RCTRL` | `213` |
| `SCANCODE_RSHIFT` | `214` |
| `SCANCODE_RALT` | `215` |
| `SCANCODE_RGUI` | `216` |
| `SCANCODE_MODE` | `217` |
| `SCANCODE_AUDIONEXT` | `218` |
| `SCANCODE_AUDIOPREV` | `219` |
| `SCANCODE_AUDIOSTOP` | `220` |
| `SCANCODE_AUDIOPLAY` | `221` |
| `SCANCODE_AUDIOMUTE` | `222` |
| `SCANCODE_MEDIASELECT` | `223` |
| `SCANCODE_WWW` | `224` |
| `SCANCODE_MAIL` | `225` |
| `SCANCODE_CALCULATOR` | `226` |
| `SCANCODE_COMPUTER` | `227` |
| `SCANCODE_AC_SEARCH` | `228` |
| `SCANCODE_AC_HOME` | `229` |
| `SCANCODE_AC_BACK` | `230` |
| `SCANCODE_AC_FORWARD` | `231` |
| `SCANCODE_AC_STOP` | `232` |
| `SCANCODE_AC_REFRESH` | `233` |
| `SCANCODE_AC_BOOKMARKS` | `234` |
| `SCANCODE_BRIGHTNESSDOWN` | `235` |
| `SCANCODE_BRIGHTNESSUP` | `236` |
| `SCANCODE_DISPLAYSWITCH` | `237` |
| `SCANCODE_KBDILLUMTOGGLE` | `238` |
| `SCANCODE_KBDILLUMDOWN` | `239` |
| `SCANCODE_KBDILLUMUP` | `240` |
| `SCANCODE_EJECT` | `241` |
| `SCANCODE_SLEEP` | `242` |
| `SCANCODE_APP1` | `243` |
| `SCANCODE_APP2` | `244` |

### SceneSyncMode

| 常量 | 值 |
|------|-----|
| `SCENE_SYNC_DEFAULT` | `0` |
| `SCENE_SYNC_SERVER_REPLICATED` | `1` |

### ShaderType

| 常量 | 值 |
|------|-----|
| `VS` | `0` |
| `PS` | `1` |

### ShadowQuality

| 常量 | 值 |
|------|-----|
| `SHADOWQUALITY_SIMPLE_16BIT` | `0` |
| `SHADOWQUALITY_SIMPLE_24BIT` | `1` |
| `SHADOWQUALITY_PCF_16BIT` | `2` |
| `SHADOWQUALITY_PCF_24BIT` | `3` |
| `SHADOWQUALITY_VSM` | `4` |
| `SHADOWQUALITY_BLUR_VSM` | `5` |

### ShapeType

| 常量 | 值 |
|------|-----|
| `SHAPE_BOX` | `0` |
| `SHAPE_SPHERE` | `1` |
| `SHAPE_STATICPLANE` | `2` |
| `SHAPE_CYLINDER` | `3` |
| `SHAPE_CAPSULE` | `4` |
| `SHAPE_CONE` | `5` |
| `SHAPE_TRIANGLEMESH` | `6` |
| `SHAPE_CONVEXHULL` | `7` |
| `SHAPE_TERRAIN` | `8` |

### SkyAtmosphereTransformMode

| 常量 | 值 |
|------|-----|
| `ATMOSPHERE_TOP_AT_WORLD_ORIGIN` | `0` |
| `ATMOSPHERE_TOP_AT_COMPONENT` | `1` |
| `ATMOSPHERE_CENTER_AT_COMPONENT` | `2` |

### SkyCaptureSource

| 常量 | 值 |
|------|-----|
| `SKY_CAPTURE_SKYBOX` | `0` |
| `SKY_CAPTURE_ATMOSPHERE` | `1` |

### SkyCaptureUpdateMode

| 常量 | 值 |
|------|-----|
| `SKY_CAPTURE_MANUAL` | `0` |
| `SKY_CAPTURE_ON_CHANGE` | `1` |
| `SKY_CAPTURE_CONTINUOUS` | `2` |

### StencilOp

| 常量 | 值 |
|------|-----|
| `OP_KEEP` | `0` |
| `OP_ZERO` | `1` |
| `OP_REF` | `2` |
| `OP_INCR` | `3` |
| `OP_DECR` | `4` |

### TemporalShadowContract

| 常量 | 值 |
|------|-----|
| `TEMPORAL_SHADOW_CONTRACT_NONE` | `0` |
| `TEMPORAL_SHADOW_CONTRACT_DEFERRED_V1` | `1` |

### TextEffect

| 常量 | 值 |
|------|-----|
| `TE_NONE` | `0` |
| `TE_SHADOW` | `1` |
| `TE_STROKE` | `2` |

### TextureAddressMode

| 常量 | 值 |
|------|-----|
| `ADDRESS_WRAP` | `0` |
| `ADDRESS_MIRROR` | `1` |
| `ADDRESS_CLAMP` | `2` |
| `ADDRESS_BORDER` | `3` |
| `MAX_ADDRESSMODES` | `4` |

### TextureCoordinate

| 常量 | 值 |
|------|-----|
| `COORD_U` | `0` |
| `COORD_V` | `1` |
| `COORD_W` | `2` |
| `MAX_COORDS` | `3` |

### TextureFilterMode

| 常量 | 值 |
|------|-----|
| `FILTER_NEAREST` | `0` |
| `FILTER_BILINEAR` | `1` |
| `FILTER_TRILINEAR` | `2` |
| `FILTER_ANISOTROPIC` | `3` |
| `FILTER_NEAREST_ANISOTROPIC` | `4` |
| `FILTER_DEFAULT` | `5` |
| `MAX_FILTERMODES` | `6` |

### TextureUnit

| 常量 | 值 |
|------|-----|
| `TU_DIFFUSE` | `0` |
| `TU_ALBEDOBUFFER` | `0` |
| `TU_NORMAL` | `1` |
| `TU_NORMALBUFFER` | `1` |
| `TU_SPECULAR` | `2` |
| `TU_EMISSIVE` | `3` |
| `TU_ENVIRONMENT` | `4` |

### TextureUsage

| 常量 | 值 |
|------|-----|
| `TEXTURE_STATIC` | `0` |
| `TEXTURE_DYNAMIC` | `1` |
| `TEXTURE_RENDERTARGET` | `2` |
| `TEXTURE_DEPTHSTENCIL` | `3` |

### TileMapLayerType2D

| 常量 | 值 |
|------|-----|
| `LT_TILE_LAYER` | `0` |
| `LT_OBJECT_GROUP` | `1` |
| `LT_IMAGE_LAYER` | `2` |
| `LT_INVALID` | `3` |

### TileMapObjectType2D

| 常量 | 值 |
|------|-----|
| `OT_RECTANGLE` | `0` |
| `OT_ELLIPSE` | `1` |
| `OT_POLYGON` | `2` |
| `OT_POLYLINE` | `3` |
| `OT_TILE` | `4` |
| `OT_INVALID` | `5` |

### TonemapMode

| 常量 | 值 |
|------|-----|
| `TONEMAP_MODE_NONE` | `0` |
| `TONEMAP_MODE_ACES` | `1` |
| `TONEMAP_MODE_LUT` | `2` |

### TrailType

| 常量 | 值 |
|------|-----|
| `TT_FACE_CAMERA` | `0` |
| `TT_BONE` | `1` |

### TransformSpace

| 常量 | 值 |
|------|-----|
| `TS_LOCAL` | `0` |
| `TS_PARENT` | `1` |
| `TS_WORLD` | `2` |

### TransportProtocol

| 常量 | 值 |
|------|-----|
| `TRANSPORT_SLIKENET` | `0` |
| `TRANSPORT_WEBSOCKET` | `1` |
| `TRANSPORT_KCP` | `2` |

### TraversalMode

| 常量 | 值 |
|------|-----|
| `TM_BREADTH_FIRST` | `0` |
| `TM_DEPTH_FIRST` | `1` |

### VariantType

| 常量 | 值 |
|------|-----|
| `VAR_NONE` | `0` |
| `VAR_INT` | `1` |
| `VAR_BOOL` | `2` |
| `VAR_FLOAT` | `3` |
| `VAR_VECTOR2` | `4` |
| `VAR_VECTOR3` | `5` |
| `VAR_VECTOR4` | `6` |
| `VAR_QUATERNION` | `7` |
| `VAR_COLOR` | `8` |
| `VAR_STRING` | `9` |
| `VAR_BUFFER` | `10` |
| `VAR_VOIDPTR` | `11` |
| `VAR_RESOURCEREF` | `12` |
| `VAR_RESOURCEREFLIST` | `13` |
| `VAR_VARIANTVECTOR` | `14` |
| `VAR_VARIANTMAP` | `15` |
| `VAR_INTRECT` | `16` |
| `VAR_INTVECTOR2` | `17` |
| `VAR_PTR` | `18` |
| `VAR_MATRIX3` | `19` |
| `VAR_MATRIX3X4` | `20` |
| `VAR_MATRIX4` | `21` |
| `VAR_DOUBLE` | `22` |
| `VAR_STRINGVECTOR` | `23` |
| `VAR_RECT` | `24` |
| `VAR_INTVECTOR3` | `25` |
| `VAR_INT64` | `26` |
| `MAX_VAR_TYPES` | `27` |

### VertexElementSemantic

| 常量 | 值 |
|------|-----|
| `SEM_POSITION` | `0` |
| `SEM_NORMAL` | `1` |
| `SEM_BINORMAL` | `2` |
| `SEM_TANGENT` | `3` |
| `SEM_TEXCOORD` | `4` |
| `SEM_COLOR` | `5` |
| `SEM_BLENDWEIGHTS` | `6` |
| `SEM_BLENDINDICES` | `7` |
| `SEM_OBJECTINDEX` | `8` |
| `MAX_VERTEX_ELEMENT_SEMANTICS` | `9` |

### VertexElementType

| 常量 | 值 |
|------|-----|
| `TYPE_INT` | `0` |
| `TYPE_FLOAT` | `1` |
| `TYPE_VECTOR2` | `2` |
| `TYPE_VECTOR3` | `3` |
| `TYPE_VECTOR4` | `4` |
| `TYPE_UBYTE4` | `5` |
| `TYPE_UBYTE4_NORM` | `6` |
| `MAX_VERTEX_ELEMENT_TYPES` | `7` |

### VertexMask

| 常量 | 值 |
|------|-----|
| `MASK_NONE` | `0` |
| `MASK_POSITION` | `1` |
| `MASK_NORMAL` | `2` |
| `MASK_COLOR` | `3` |
| `MASK_TEXCOORD1` | `4` |
| `MASK_TEXCOORD2` | `5` |
| `MASK_CUBETEXCOORD1` | `6` |
| `MASK_CUBETEXCOORD2` | `7` |
| `MASK_TANGENT` | `8` |
| `MASK_BLENDWEIGHTS` | `9` |
| `MASK_BLENDINDICES` | `10` |
| `MASK_INSTANCEMATRIX1` | `11` |
| `MASK_INSTANCEMATRIX2` | `12` |
| `MASK_INSTANCEMATRIX3` | `13` |
| `MASK_OBJECTINDEX` | `14` |

### VerticalAlignment

| 常量 | 值 |
|------|-----|
| `VA_TOP` | `0` |
| `VA_CENTER` | `1` |
| `VA_BOTTOM` | `2` |
| `VA_CUSTOM` | `3` |

### VideoLoadResult

| 常量 | 值 |
|------|-----|
| `VIDEO_LOAD_SUCCESS` | `0` |
| `VIDEO_LOAD_ERROR_NO_DECODER` | `1` |
| `VIDEO_LOAD_ERROR_SOURCE_NOT_FOUND` | `2` |
| `VIDEO_LOAD_ERROR_OPEN_FAILED` | `3` |
| `VIDEO_LOAD_ERROR_TEXTURE_FAILED` | `4` |
| `VIDEO_LOAD_ERROR_CANCELLED` | `5` |

### VideoState

| 常量 | 值 |
|------|-----|
| `VIDEO_STOPPED` | `0` |
| `VIDEO_PLAYING` | `1` |
| `VIDEO_PAUSED` | `2` |
| `VIDEO_ENDED` | `3` |

### VolumetricCloudSkyLightingMode

| 常量 | 值 |
|------|-----|
| `CLOUD_SKY_ZONE_CAPTURED` | `0` |
| `CLOUD_SKY_DIRECTIONAL_ONLY` | `1` |
| `CLOUD_SKY_AUTO` | `2` |

### VolumetricFogQuality

| 常量 | 值 |
|------|-----|
| `VOLUMETRIC_FOG_QUALITY_LOW` | `0` |
| `VOLUMETRIC_FOG_QUALITY_HIGH` | `1` |
| `VOLUMETRIC_FOG_QUALITY_ULTRA` | `2` |

### VoxelCharacterGroundState

| 常量 | 值 |
|------|-----|
| `VOXEL_CHARACTER_ON_GROUND` | `0` |
| `VOXEL_CHARACTER_ON_STEEP_GROUND` | `1` |
| `VOXEL_CHARACTER_NOT_SUPPORTED` | `2` |
| `VOXEL_CHARACTER_IN_AIR` | `3` |

### VoxelCollisionShapeType

| 常量 | 值 |
|------|-----|
| `VOXEL_COLLISION_SHAPE_AUTO` | `0` |
| `VOXEL_COLLISION_SHAPE_BOX` | `1` |
| `VOXEL_COLLISION_SHAPE_SPHERE` | `2` |
| `VOXEL_COLLISION_SHAPE_CAPSULE` | `3` |
| `VOXEL_COLLISION_SHAPE_CYLINDER` | `4` |

### VoxelConstraintType

| 常量 | 值 |
|------|-----|
| `VOXEL_CONSTRAINT_HINGE` | `0` |
| `VOXEL_CONSTRAINT_FIXED` | `1` |
| `VOXEL_CONSTRAINT_SLIDER` | `2` |
| `VOXEL_CONSTRAINT_BALL` | `3` |

### VoxelShadowVolumeQuery

| 常量 | 值 |
|------|-----|
| `VOXEL_SHADOW_QUERY_ACCURATE` | `0` |
| `VOXEL_SHADOW_QUERY_SPARSE` | `1` |
| `VOXEL_SHADOW_QUERY_SUPER_SPARSE` | `2` |

### WindowDragMode

| 常量 | 值 |
|------|-----|
| `DRAG_NONE` | `0` |
| `DRAG_MOVE` | `1` |
| `DRAG_RESIZE_TOPLEFT` | `2` |
| `DRAG_RESIZE_TOP` | `3` |
| `DRAG_RESIZE_TOPRIGHT` | `4` |
| `DRAG_RESIZE_RIGHT` | `5` |
| `DRAG_RESIZE_BOTTOMRIGHT` | `6` |
| `DRAG_RESIZE_BOTTOM` | `7` |
| `DRAG_RESIZE_BOTTOMLEFT` | `8` |
| `DRAG_RESIZE_LEFT` | `9` |

### WrapMode

| 常量 | 值 |
|------|-----|
| `WM_LOOP` | `0` |
| `WM_ONCE` | `1` |
| `WM_CLAMP` | `2` |

---

## 三、类与方法

按继承关系排序（基类在前）。签名格式：`方法名(参数): 返回类型`

> **harness 提示**：为每个类建一张表，把方法挂到 metatable 的 `__index`；
> 每个 stub 方法返回对应返回类型的零值（number→0、string→""、boolean→false、table→{}）。
> 属性字段用 `__index`/`__newindex` 兜底返回默认值，可消除 `attempt to index a nil value`。

### SDK

**方法（6）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetAchievementToastEnabled` | `(enabled: boolean)` | 控制宿主原生成就解锁提示。 |
| `ShowAchievements` | `()` | 打开当前登录用户的原生成就页面。 |
| `UnlockAchievement` | `(achievementId: string 长度 1..40，仅允许字母、数字、- 和 _)` | 解锁一个单步普通成就。 |
| `IncrementAchievement` | `(achievementId: string 长度 1..40，仅允许字母、数字、- 和 _, steps: integer 本次增加步数，范围 1..INT_MAX（客户端 Native 接口使用 int）)` | 增加普通进度成就的步数。 |
| `RegisterAchievementListener` | `(listener: AchievementCallbacks)` | 注册当前 Lua 状态的成就 listener；再次注册会替换已有 listener。 |
| `UnregisterAchievementListener` | `()` | 移除当前成就 listener。 |


### RefCounted

**方法（1）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `delete` | `()` | Manually delete the C++ object (tolua++ method) This is needed for obj |


### Object  `: RefCounted`

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `type` | StringHash|string |  |
| `typeName` | string |  |
| `category` | string |  |

**方法（8）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetType` | `() -> StringHash|string` |  |
| `GetTypeName` | `() -> string` |  |
| `GetCategory` | `() -> string` |  |
| `SetBlockEvents` | `(block: boolean)` |  |
| `GetBlockEvents` | `() -> boolean` |  |
| `Dispose` | `()` |  |
| `SendEvent` | `(eventName: string, eventData?: VariantMap)` |  |
| `HasSubscribedToEvent` | `(eventName: string) -> boolean` |  |


### Serializable  `: Object`

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `temporary` | boolean |  |

**方法（10）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetTemporary` | `(enable: boolean)` |  |
| `IsTemporary` | `() -> boolean` |  |
| `SetInterceptNetworkUpdate` | `(attributeName: string, enable: boolean)` |  |
| `GetInterceptNetworkUpdate` | `(attributeName: string) -> boolean` |  |
| `ApplyAttributes` | `()` |  |
| `GetAttributeInfo` | `(index: integer) -> AttributeInfo` |  |
| `SetAttribute` | `(index: integer, value: Variant) -> boolean` |  |
| `GetAttribute` | `(index: integer) -> Variant` |  |
| `GetAttributeDefault` | `(index: integer) -> Variant` |  |
| `GetNumAttributes` | `() -> integer` |  |


### Animatable  `: Serializable`

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `animationEnabled` | boolean |  |
| `objectAnimation` | ObjectAnimation |  |

**方法（15）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetAnimationEnabled` | `(enable: boolean)` |  |
| `SetAnimationTime` | `(time: number)` |  |
| `SetObjectAnimation` | `(objectAnimation: ObjectAnimation)` |  |
| `SetAttributeAnimation` | `(name: string, attributeAnimation: ValueAnimation, wrapMode?: WrapMode, speed?: number)` |  |
| `SetAttributeAnimationWrapMode` | `(name: string, wrapMode: WrapMode)` |  |
| `SetAttributeAnimationSpeed` | `(name: string, speed: number)` |  |
| `SetAttributeAnimationTime` | `(name: string, time: number)` |  |
| `RemoveObjectAnimation` | `()` |  |
| `RemoveAttributeAnimation` | `(name: string)` |  |
| `GetAnimationEnabled` | `() -> boolean` |  |
| `GetObjectAnimation` | `() -> ObjectAnimation` |  |
| `GetAttributeAnimation` | `(name: string) -> ValueAnimation` |  |
| `GetAttributeAnimationWrapMode` | `(name: string) -> WrapMode` |  |
| `GetAttributeAnimationSpeed` | `(name: string) -> number` |  |
| `GetAttributeAnimationTime` | `(name: string) -> number` |  |


### Component  `: Animatable`

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `ID` | integer |  |
| `replicated` | boolean |  |
| `enabled` | boolean |  |
| `enabledEffective` | boolean |  |
| `node` | Node |  |
| `scene` | Scene |  |
| `GetComponent` | __union_func__type_str__ret_ComponentT |  |

**方法（10）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetEnabled` | `(enable: boolean)` |  |
| `Remove` | `()` |  |
| `Dispose` | `()` |  |
| `DrawDebugGeometry` | `(debug: DebugRenderer, depthTest: boolean)` |  |
| `GetID` | `() -> integer` |  |
| `IsReplicated` | `() -> boolean` |  |
| `GetNode` | `() -> Node` |  |
| `GetScene` | `() -> Scene` |  |
| `IsEnabled` | `() -> boolean` |  |
| `IsEnabledEffective` | `() -> boolean` |  |


### AimOffset  `: Component`

**属性（10）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `numBones` | integer |  |
| `targetPitch` | number |  |
| `targetYaw` | number |  |
| `maxPitch` | number |  |
| `maxYaw` | number |  |
| `smoothSpeed` | number |  |
| `yawCompensation` | number |  |
| `stabilize` | boolean |  |
| `stabilizeParentCount` | integer |  |
| `enabled` | boolean |  |

**方法（24）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `AddBone` | `(boneName: string, pitchWeight: number, yawWeight: number)` |  |
| `RemoveBone` | `(boneName: string)` |  |
| `ClearBones` | `()` |  |
| `GetNumBones` | `() -> integer` |  |
| `SetTargetPitch` | `(pitch: number)` |  |
| `SetTargetYaw` | `(yaw: number)` |  |
| `SetTargetAngles` | `(pitch: number, yaw: number)` |  |
| `GetTargetPitch` | `() -> number` |  |
| `GetTargetYaw` | `() -> number` |  |
| `SetMaxPitch` | `(maxPitch: number)` |  |
| `SetMaxYaw` | `(maxYaw: number)` |  |
| `GetMaxPitch` | `() -> number` |  |
| `GetMaxYaw` | `() -> number` |  |
| `SetSmoothSpeed` | `(speed: number)` |  |
| `GetSmoothSpeed` | `() -> number` |  |
| `SetYawCompensation` | `(compensation: number)` |  |
| `GetYawCompensation` | `() -> number` |  |
| `SetStabilize` | `(stabilize: boolean)` |  |
| `IsStabilize` | `() -> boolean` |  |
| `SetStabilizeParentCount` | `(count: integer)` |  |
| `GetStabilizeParentCount` | `() -> integer` |  |
| `SetEnabled` | `(enabled: boolean)` |  |
| `IsEnabled` | `() -> boolean` |  |
| `DebugPrintBones` | `()` |  |


### Drawable  `: Component`

**属性（19）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `worldBoundingBox` | BoundingBox |  |
| `drawableFlags` | number -- unsigned char |  |
| `drawDistance` | number |  |
| `shadowDistance` | number |  |
| `lodBias` | number |  |
| `viewMask` | integer |  |
| `lightMask` | integer |  |
| `shadowMask` | integer |  |
| `zoneMask` | integer |  |
| `maxLights` | integer |  |
| `castShadows` | boolean |  |
| `outlineEnabled` | boolean |  |
| `outlineColor` | Color |  |
| `outlineThickness` | number |  |
| `outlineZBias` | number |  |
| `occluder` | boolean |  |
| `occludee` | boolean |  |
| `inView` | boolean |  |
| `zone` | Zone |  |

**方法（42）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetInstanceShaderParameter` | `(value: boolean|number|Vector2|Vector3|Vector4|Color|IntVector2|IntVector3, name: string)` | Set a shader parameter for this Drawable only. The name is case-sensit |
| `SetInstanceShaderParameters` | `(values: table<string, boolean|number|Vector2|Vector3|Vector4|Color|IntVector2|IntVector3>)` | Set multiple instance shader parameters; omitted parameters keep their |
| `GetInstanceShaderParameter` | `(name: string) -> Variant` | Return the explicitly set value, or an empty Variant if unset. |
| `ClearInstanceShaderParameter` | `(name: string)` | Remove one override, restoring the shader default. |
| `ClearInstanceShaderParameters` | `()` | Remove all overrides, restoring shader defaults. |
| `SetDrawDistance` | `(distance: number)` |  |
| `SetShadowDistance` | `(distance: number)` |  |
| `SetLodBias` | `(bias: number)` |  |
| `SetViewMask` | `(mask: integer)` |  |
| `SetLightMask` | `(mask: integer)` |  |
| `SetShadowMask` | `(mask: integer)` |  |
| `SetZoneMask` | `(mask: integer)` |  |
| `SetMaxLights` | `(num: integer)` |  |
| `SetCastShadows` | `(enable: boolean)` |  |
| `SetOutlineEnabled` | `(enable: boolean)` |  |
| `GetOutlineEnabled` | `() -> boolean` |  |
| `SetOutlineColor` | `(color: Color)` |  |
| `GetOutlineColor` | `() -> Color` |  |
| `SetOutlineThickness` | `(thickness: number)` |  |
| `GetOutlineThickness` | `() -> number` |  |
| `SetOutlineZBias` | `(zBias: number)` |  |
| `GetOutlineZBias` | `() -> number` |  |
| `SetOccluder` | `(enable: boolean)` |  |
| `SetOccludee` | `(enable: boolean)` |  |
| `MarkForUpdate` | `()` |  |
| `MarkShadowContentDirty` | `()` | Notify optional temporal shadows of procedural depth changes without f |
| `GetBoundingBox` | `() -> BoundingBox` |  |
| `GetWorldBoundingBox` | `() -> BoundingBox` |  |
| `GetDrawableFlags` | `() -> number` |  |
| `GetDrawDistance` | `() -> number` |  |
| `GetShadowDistance` | `() -> number` |  |
| `GetLodBias` | `() -> number` |  |
| `GetViewMask` | `() -> integer` |  |
| `GetLightMask` | `() -> integer` |  |
| `GetShadowMask` | `() -> integer` |  |
| `GetZoneMask` | `() -> integer` |  |
| `GetMaxLights` | `() -> integer` |  |
| `GetCastShadows` | `() -> boolean` |  |
| `IsOccluder` | `() -> boolean` |  |
| `IsOccludee` | `() -> boolean` |  |
| `IsInView` | `(param0: Camera) -> boolean` |  |
| `GetZone` | `() -> Zone` |  |


### StaticModel  `: Drawable`

**属性（9）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `model` | Model |  |
| `material` | Material |  |
| `boundingBox` | BoundingBox |  |
| `numGeometries` | integer |  |
| `occlusionLodLevel` | integer |  |
| `useInstanceColor` | boolean Enable the Surface Shader INSTANCE_COLOR input for StaticModel and AnimatedModel. |  |
| `instanceColor` | Color Surface Shader INSTANCE_COLOR input for StaticModel and AnimatedModel. |  |
| `useInstanceCustomData` | boolean Surface Shader INSTANCE_CUSTOM data for direct instances of StaticModel. |  |
| `instanceCustomData` | Vector4 Surface Shader INSTANCE_CUSTOM data for direct instances of StaticModel. |  |

**方法（14）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetModel` | `(model: Model)` |  |
| `SetMaterial` | `(material: Material)` |  |
| `SetOcclusionLodLevel` | `(level: integer)` |  |
| `ApplyMaterialList` | `(fileName?: string)` |  |
| `GetModel` | `() -> Model` |  |
| `GetNumGeometries` | `() -> integer` |  |
| `GetMaterial` | `(index: integer) -> Material` |  |
| `GetOcclusionLodLevel` | `() -> integer` |  |
| `IsInside` | `(point: Vector3) -> boolean` |  |
| `IsInsideLocal` | `(point: Vector3) -> boolean` |  |
| `SetInstanceColor` | `(color: Color)` | Surface Shader INSTANCE_COLOR input for StaticModel and AnimatedModel. |
| `GetInstanceColor` | `() -> Color` | Surface Shader INSTANCE_COLOR input for StaticModel and AnimatedModel. |
| `SetInstanceCustomData` | `(data: Vector4)` | Surface Shader INSTANCE_CUSTOM data for direct instances of StaticMode |
| `GetInstanceCustomData` | `() -> Vector4` | Surface Shader INSTANCE_CUSTOM data for direct instances of StaticMode |


### AnimatedModel  `: StaticModel`

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `model` | Model |  |
| `skeleton` | Skeleton |  |
| `numAnimationStates` | integer |  |
| `animationLodBias` | number |  |
| `updateInvisible` | boolean |  |
| `numMorphs` | integer |  |
| `master` | boolean |  |

**方法（17）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetModel` | `(model: Model)` |  |
| `AddAnimationState` | `(animation: Animation) -> AnimationState` |  |
| `RemoveAnimationState` | `(animation: Animation)` |  |
| `RemoveAllAnimationStates` | `()` |  |
| `SetAnimationLodBias` | `(bias: number)` |  |
| `SetUpdateInvisible` | `(enable: boolean)` |  |
| `SetMorphWeight` | `(name: string, weight: number)` |  |
| `ResetMorphWeights` | `()` |  |
| `GetSkeleton` | `() -> Skeleton` |  |
| `GetNumAnimationStates` | `() -> integer` |  |
| `GetAnimationState` | `(animation: Animation) -> AnimationState` |  |
| `GetAnimationLodBias` | `() -> number` |  |
| `GetUpdateInvisible` | `() -> boolean` |  |
| `GetNumMorphs` | `() -> integer` |  |
| `GetMorphWeight` | `(name: string) -> number` |  |
| `IsMaster` | `() -> boolean` |  |
| `UpdateBoneBoundingBox` | `()` |  |


### Drawable2D  `: Drawable`

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `layer` | integer |  |
| `orderInLayer` | integer |  |

**方法（4）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetLayer` | `(layer: integer)` |  |
| `SetOrderInLayer` | `(orderInLayer: integer)` |  |
| `GetLayer` | `() -> integer` |  |
| `GetOrderInLayer` | `() -> integer` |  |


### StaticSprite2D  `: Drawable2D`

**属性（14）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `sprite` | Sprite2D |  |
| `blendMode` | BlendMode |  |
| `flipX` | boolean |  |
| `flipY` | boolean |  |
| `swapXY` | boolean |  |
| `color` | Color |  |
| `alpha` | number |  |
| `useHotSpot` | boolean |  |
| `hotSpot` | Vector2 |  |
| `customMaterial` | Material |  |
| `drawRect` | Rect |  |
| `useDrawRect` | boolean |  |
| `textureRect` | Rect |  |
| `useTextureRect` | boolean |  |

**方法（29）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetSprite` | `(sprite: Sprite2D)` |  |
| `SetBlendMode` | `(mode: BlendMode)` |  |
| `SetFlip` | `(flipX: boolean, flipY: boolean, swapXY?: boolean)` |  |
| `SetFlipX` | `(flipX: boolean)` |  |
| `SetFlipY` | `(flipY: boolean)` |  |
| `SetSwapXY` | `(swapXY: boolean)` |  |
| `SetColor` | `(color: Color)` |  |
| `SetAlpha` | `(alpha: number)` |  |
| `SetUseHotSpot` | `(useHotSpot: boolean)` |  |
| `SetHotSpot` | `(hotspot: Vector2)` |  |
| `SetUseDrawRect` | `(useDrawRect: boolean)` |  |
| `SetDrawRect` | `(rect: Rect)` |  |
| `SetUseTextureRect` | `(useTextureRect: boolean)` |  |
| `SetTextureRect` | `(rect: Rect)` |  |
| `SetCustomMaterial` | `(customMaterial: Material)` |  |
| `GetSprite` | `() -> Sprite2D` |  |
| `GetBlendMode` | `() -> BlendMode` |  |
| `GetFlipX` | `() -> boolean` |  |
| `GetFlipY` | `() -> boolean` |  |
| `GetSwapXY` | `() -> boolean` |  |
| `GetColor` | `() -> Color` |  |
| `GetAlpha` | `() -> number` |  |
| `GetUseHotSpot` | `() -> boolean` |  |
| `GetHotSpot` | `() -> Vector2` |  |
| `GetUseDrawRect` | `() -> boolean` |  |
| `GetDrawRect` | `() -> Rect` |  |
| `GetUseTextureRect` | `() -> boolean` |  |
| `GetTextureRect` | `() -> Rect` |  |
| `GetCustomMaterial` | `() -> Material` |  |


### AnimatedSprite2D  `: StaticSprite2D`

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `speed` | number |  |
| `entity` | string |  |
| `animation` | string |  |
| `animationSet` | AnimationSet2D |  |
| `loopMode` | LoopMode2D |  |

**方法（10）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetAnimationSet` | `(animationSet: AnimationSet2D)` |  |
| `SetEntity` | `(entity: string)` |  |
| `SetAnimation` | `(name: string, loopMode?: LoopMode2D)` |  |
| `SetLoopMode` | `(loopMode: LoopMode2D)` |  |
| `SetSpeed` | `(speed: number)` |  |
| `GetAnimationSet` | `() -> AnimationSet2D` |  |
| `GetEntity` | `() -> string` |  |
| `GetAnimation` | `() -> string` |  |
| `GetLoopMode` | `() -> LoopMode2D` |  |
| `GetSpeed` | `() -> number` |  |


### AnimationKeyFrame

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `time` | number |  |
| `position` | Vector3 |  |
| `rotation` | Quaternion |  |
| `scale` | Vector3 |  |


### AnimationTrack

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | string |  |
| `nameHash` | StringHash|string |  |
| `channelMask` | number -- unsigned char |  |
| `keyFrames` | AnimationKeyFrame[] |  |
| `numKeyFrames` | integer |  |

**方法（7）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetKeyFrame` | `(index: integer, keyFrame: AnimationKeyFrame)` |  |
| `AddKeyFrame` | `(keyFrame: AnimationKeyFrame)` |  |
| `InsertKeyFrame` | `(index: integer, keyFrame: AnimationKeyFrame)` |  |
| `RemoveKeyFrame` | `(index: integer)` |  |
| `RemoveAllKeyFrames` | `()` |  |
| `GetKeyFrame` | `(index: integer) -> AnimationKeyFrame` |  |
| `GetNumKeyFrames` | `() -> integer` |  |


### AnimationTriggerPoint

**构造**

```lua
fun(): AnimationTriggerPoint
```

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `time` | number |  |
| `data` | Variant |  |


### Resource  `: Object`

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | string |  |
| `nameHash` | StringHash|string |  |
| `memoryUse` | integer |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Load` | `(source: Deserializer) -> boolean` |  |
| `Save` | `(dest: Serializer) -> boolean` |  |
| `GetName` | `() -> string` |  |
| `GetNameHash` | `() -> StringHash|string` |  |
| `GetMemoryUse` | `() -> integer` |  |


### ResourceWithMetadata  `: Resource`

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `AddMetadata` | `(name: string, value: Variant)` |  |
| `RemoveMetadata` | `(name: string)` |  |
| `RemoveAllMetadata` | `()` |  |
| `GetMetadata` | `(name: string) -> Variant` |  |
| `HasMetadata` | `() -> boolean` |  |


### Animation  `: ResourceWithMetadata`

**构造**

```lua
fun(): Animation
```

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `animationName` | string |  |
| `length` | number |  |
| `numTracks` | integer |  |
| `numTriggers` | integer |  |

**方法（16）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetAnimationName` | `(name: string)` |  |
| `SetLength` | `(length: number)` |  |
| `CreateTrack` | `(name: string) -> AnimationTrack` |  |
| `RemoveTrack` | `(name: string) -> boolean` |  |
| `RemoveAllTracks` | `()` |  |
| `SetTrigger` | `(index: integer, trigger: AnimationTriggerPoint)` |  |
| `AddTrigger` | `(trigger: AnimationTriggerPoint)` |  |
| `RemoveTrigger` | `(index: integer)` |  |
| `RemoveAllTriggers` | `()` |  |
| `Clone` | `(cloneName?: string) -> Animation` |  |
| `GetAnimationName` | `() -> string` |  |
| `GetLength` | `() -> number` |  |
| `GetNumTracks` | `() -> integer` |  |
| `GetTrack` | `(name: string) -> AnimationTrack` |  |
| `GetNumTriggers` | `() -> integer` |  |
| `GetTrigger` | `(index: integer) -> AnimationTriggerPoint` |  |


### AnimationControl

**构造**

```lua
fun(): AnimationControl
```

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | string |  |
| `hash` | StringHash|string |  |
| `speed` | number |  |
| `targetWeight` | number |  |
| `fadeTime` | number |  |
| `autoFadeTime` | number |  |
| `removeOnCompletion` | boolean |  |


### AnimationController  `: Component`

**方法（36）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Play` | `(name: string, layer: number -- unsigned char, looped: boolean, fadeInTime?: number) -> boolean` |  |
| `PlayExclusive` | `(name: string, layer: number -- unsigned char, looped: boolean, fadeTime?: number) -> boolean` |  |
| `Stop` | `(name: string, fadeOutTime?: number) -> boolean` |  |
| `StopLayer` | `(layer: number -- unsigned char, fadeOutTime?: number)` |  |
| `StopAll` | `(fadeTime?: number)` |  |
| `Fade` | `(name: string, targetWeight: number, fadeTime: number) -> boolean` |  |
| `FadeOthers` | `(name: string, targetWeight: number, fadeTime: number) -> boolean` |  |
| `SetLayer` | `(name: string, layer: number -- unsigned char) -> boolean` |  |
| `SetStartBone` | `(name: string, startBoneName: string) -> boolean` |  |
| `SetTime` | `(name: string, time: number) -> boolean` |  |
| `SetWeight` | `(name: string, weight: number) -> boolean` |  |
| `SetLooped` | `(name: string, enable: boolean) -> boolean` |  |
| `SetBlendMode` | `(name: string, mode: AnimationBlendMode) -> boolean` |  |
| `SetSpeed` | `(name: string, speed: number) -> boolean` |  |
| `SetAutoFade` | `(name: string, fadeOutTime: number) -> boolean` |  |
| `SetRemoveOnCompletion` | `(name: string, removeOnCompletion: boolean) -> boolean` |  |
| `IsPlaying` | `(name: string) -> boolean` |  |
| `IsFadingIn` | `(name: string) -> boolean` |  |
| `IsFadingOut` | `(name: string) -> boolean` |  |
| `IsAtEnd` | `(name: string) -> boolean` |  |
| `GetLayer` | `(name: string) -> number` |  |
| `GetStartBone` | `(name: string) -> Bone` |  |
| `GetStartBoneName` | `(name: string) -> string` |  |
| `GetTime` | `(name: string) -> number` |  |
| `GetWeight` | `(name: string) -> number` |  |
| `IsLooped` | `(name: string) -> boolean` |  |
| `GetBlendMode` | `(name: string) -> AnimationBlendMode` |  |
| `GetLength` | `(name: string) -> number` |  |
| `GetSpeed` | `(name: string) -> number` |  |
| `GetFadeTarget` | `(name: string) -> number` |  |
| `GetFadeTime` | `(name: string) -> number` |  |
| `GetAutoFade` | `(name: string) -> number` |  |
| `GetRemoveOnCompletion` | `(name: string) -> boolean` |  |
| `GetAnimationState` | `(name: string) -> AnimationState` |  |
| `GetAnimation` | `(index: integer) -> AnimationControl` |  |
| `GetNumAnimations` | `() -> integer` |  |


### AnimationSet2D  `: Resource`

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `numAnimations` | integer |  |

**方法（2）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetNumAnimations` | `() -> integer` |  |
| `GetAnimation` | `(index: integer) -> string` |  |


### AnimationState

**构造**

```lua
fun(model: AnimatedModel, animation: Animation): AnimationState
fun(node: Node, animation: Animation): AnimationState
fun(): AnimationState
fun(self: AnimationState, model: AnimatedModel, animation: Animation): AnimationState
fun(model: AnimatedModel, animation: Animation): AnimationState
fun(self: AnimationState, node: Node, animation: Animation): AnimationState
fun(node: Node, animation: Animation): AnimationState
```

**属性（9）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `animation` | Animation |  |
| `startBone` | Bone |  |
| `enabled` | boolean |  |
| `looped` | boolean |  |
| `weight` | number |  |
| `time` | number |  |
| `length` | number |  |
| `layer` | number -- unsigned char |  |
| `blendMode` | AnimationBlendMode |  |

**方法（20）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetStartBone` | `(bone: Bone)` |  |
| `SetLooped` | `(looped: boolean)` |  |
| `SetWeight` | `(weight: number)` |  |
| `SetTime` | `(time: number)` |  |
| `SetBoneWeight` | `(name: string, weight: number, recursive?: boolean)` |  |
| `AddWeight` | `(delta: number)` |  |
| `AddTime` | `(delta: number)` |  |
| `SetLayer` | `(layer: number -- unsigned char)` |  |
| `SetBlendMode` | `(mode: AnimationBlendMode)` |  |
| `GetAnimation` | `() -> Animation` |  |
| `GetStartBone` | `() -> Bone` |  |
| `GetBoneWeight` | `(name: string) -> number` |  |
| `GetTrackIndex` | `(name: string) -> integer` |  |
| `IsEnabled` | `() -> boolean` |  |
| `IsLooped` | `() -> boolean` |  |
| `GetWeight` | `() -> number` |  |
| `GetTime` | `() -> number` |  |
| `GetLength` | `() -> number` |  |
| `GetLayer` | `() -> number` |  |
| `GetBlendMode` | `() -> AnimationBlendMode` |  |


### RootMotionDelta

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `translation` | Vector3 |  |
| `rotation` | Quaternion |  |
| `positionWeights` | Vector3 |  |
| `rotationWeight` | number |  |
| `channels` | integer |  |
| `duration` | number |  |
| `sequence` | integer |  |

**方法（1）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `IsIdentity` | `() -> boolean` |  |


### AnimationStateMachine  `: Component`

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | string |  |
| `numLayers` | integer |  |
| `parameterContext` | ParameterContext |  |
| `rootMotionDelta` | boolean |  |

**方法（46）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `LoadFromJSON` | `(json: JSONValue) -> boolean` |  |
| `LoadFromJSONFile` | `(file: JSONFile) -> boolean` |  |
| `SetName` | `(name: string)` |  |
| `GetName` | `() -> string` |  |
| `SetDefaultState` | `(stateName: string)` |  |
| `SetDefaultBlendTime` | `(time: number)` |  |
| `Start` | `()` |  |
| `GetNumLayers` | `() -> integer` |  |
| `SetLayerWeight` | `(layerIndex: integer, weight: number)` |  |
| `GetLayerWeight` | `(layerIndex: integer) -> number` |  |
| `AddStateFromPath` | `(stateName: string, animationPath: string, loop?: boolean, speed?: number)` |  |
| `AddTransition` | `(fromState: string, toState: string, condition: string, priority?: integer, blendTime?: number)` |  |
| `AddTransitionSimple` | `(fromState: string, toState: string, condition: string)` |  |
| `DefineFloat` | `(name: string, defaultValue?: number, min?: number, max?: number)` |  |
| `DefineInt` | `(name: string, defaultValue?: integer, min?: number, max?: number)` |  |
| `DefineBool` | `(name: string, defaultValue?: boolean)` |  |
| `DefineTrigger` | `(name: string)` |  |
| `GetParameterContext` | `() -> ParameterContext` |  |
| `SetParameterContext` | `(context: ParameterContext)` |  |
| `SetFloat` | `(name: string, value: number)` |  |
| `SetInt` | `(name: string, value: integer)` |  |
| `SetBool` | `(name: string, value: boolean)` |  |
| `SetTrigger` | `(name: string)` |  |
| `GetFloat` | `(name: string) -> number` |  |
| `GetInt` | `(name: string) -> integer` |  |
| `GetBool` | `(name: string) -> boolean` |  |
| `GetCurrentState` | `(layerIndex?: integer) -> string` |  |
| `GetPreviousState` | `(layerIndex?: integer) -> string` |  |
| `IsInState` | `(stateName: string, layerIndex?: integer) -> boolean` |  |
| `GetStateTime` | `(layerIndex?: integer) -> number` |  |
| `GetNormalizedTime` | `(layerIndex?: integer) -> number` |  |
| `IsAnimationFinished` | `(layerIndex?: integer) -> boolean` |  |
| `ForceState` | `(stateName: string, layerIndex?: integer)` |  |
| `IsTransitioning` | `(layerIndex?: integer) -> boolean` |  |
| `Update` | `(timeStep: number)` |  |
| `HasRootMotionDelta` | `() -> boolean` |  |
| `PeekRootMotionDelta` | `(duration: number) -> RootMotionDelta` |  |
| `ConsumeRootMotionDelta` | `(duration: number) -> RootMotionDelta` |  |
| `ClearRootMotionDeltas` | `()` |  |
| `DebugPrintParameters` | `()` |  |
| `DebugPrintState` | `()` |  |
| `DebugPrintTransitions` | `()` |  |
| `DebugPrintLayers` | `()` |  |
| `DebugEvaluateCondition` | `(condition: string)` |  |
| `DebugPrintSkeleton` | `()` |  |
| `DebugPrintBlendSpaceTracks` | `()` |  |


### AttributeInfo

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `type` | VariantType |  |
| `name` | string |  |
| `mode` | integer |  |


### Audio  `: Object`

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `sampleSize` | integer |  |
| `mixRate` | integer |  |
| `interpolation` | boolean |  |
| `stereo` | boolean |  |
| `playing` | boolean |  |
| `initialized` | boolean |  |
| `listener` | SoundListener |  |

**方法（22）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetMode` | `(bufferLengthMSec: integer, mixRate: integer, stereo: boolean, interpolation?: boolean) -> boolean` |  |
| `Play` | `() -> boolean` |  |
| `Stop` | `()` |  |
| `SetMasterGain` | `(type: string, gain: number)` |  |
| `PauseSoundType` | `(type: string)` |  |
| `ResumeSoundType` | `(type: string)` |  |
| `ResumeAll` | `()` |  |
| `SetListener` | `(listener: SoundListener)` |  |
| `StopSound` | `(sound: Sound)` |  |
| `GetSampleSize` | `() -> integer` |  |
| `GetMixRate` | `() -> integer` |  |
| `GetInterpolation` | `() -> boolean` |  |
| `IsStereo` | `() -> boolean` |  |
| `IsPlaying` | `() -> boolean` |  |
| `IsInitialized` | `() -> boolean` |  |
| `HasMasterGain` | `(type: string) -> boolean` |  |
| `GetMasterGain` | `(type: string) -> number` |  |
| `IsSoundTypePaused` | `(type: string) -> boolean` |  |
| `GetListener` | `() -> SoundListener` |  |
| `GetSoundSources` | `() -> SoundSource[]` |  |
| `AddSoundSource` | `(soundSource: SoundSource)` |  |
| `RemoveSoundSource` | `(soundSource: SoundSource)` |  |


### Billboard

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `position` | Vector3 |  |
| `size` | Vector2 |  |
| `uv` | Rect |  |
| `color` | Color |  |
| `rotation` | number |  |
| `anchor` | Vector2 |  |
| `enabled` | boolean |  |


### BillboardSet  `: Drawable`

**属性（9）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `material` | Material |  |
| `numBillboards` | integer |  |
| `relative` | boolean |  |
| `scaled` | boolean |  |
| `sorted` | boolean |  |
| `fixedScreenSize` | boolean |  |
| `faceCameraMode` | FaceCameraMode |  |
| `minAngle` | number |  |
| `animationLodBias` | number |  |

**方法（20）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetMaterial` | `(material: Material)` |  |
| `SetNumBillboards` | `(num: integer)` |  |
| `SetRelative` | `(enable: boolean)` |  |
| `SetScaled` | `(enable: boolean)` |  |
| `SetSorted` | `(enable: boolean)` |  |
| `SetFixedScreenSize` | `(enable: boolean)` |  |
| `SetFaceCameraMode` | `(mode: FaceCameraMode)` |  |
| `SetMinAngle` | `(angle: number)` |  |
| `SetAnimationLodBias` | `(bias: number)` |  |
| `Commit` | `()` |  |
| `GetMaterial` | `() -> Material` |  |
| `GetNumBillboards` | `() -> integer` |  |
| `GetBillboard` | `(index: integer) -> Billboard` |  |
| `IsRelative` | `() -> boolean` |  |
| `IsScaled` | `() -> boolean` |  |
| `IsSorted` | `() -> boolean` |  |
| `IsFixedScreenSize` | `() -> boolean` |  |
| `GetFaceCameraMode` | `() -> FaceCameraMode` |  |
| `GetMinAngle` | `() -> number` |  |
| `GetAnimationLodBias` | `() -> number` |  |


### AnimationBlendWeight

**构造**

```lua
fun(path: string, w: number, s?: number): AnimationBlendWeight
fun(): AnimationBlendWeight
fun(self: AnimationBlendWeight, path: string, w: number, s?: number): AnimationBlendWeight
fun(path: string, w: number, s?: number): AnimationBlendWeight
```

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `animationPath` | string |  |
| `weight` | number |  |
| `speed` | number |  |


### BlendSpaceBase  `: Object`

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `blendSpaceName` | string |  |

**方法（2）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetBlendSpaceName` | `() -> string` |  |
| `GetBlendSpaceType` | `() -> string` |  |


### BlendSpaceResource  `: Resource`

**方法（1）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetBlendSpace` | `() -> BlendSpaceBase` |  |


### BlendSpace1D  `: BlendSpaceBase`

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `parameterName` | string |  |

**方法（3）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetParameterName` | `() -> string` |  |
| `AddPoint` | `(value: number, animation: string, speed?: number)` |  |
| `ClearPoints` | `()` |  |


### BlendSpace2D  `: BlendSpaceBase`

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `parameterNameX` | string |  |
| `parameterNameY` | string |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetParameterNameX` | `() -> string` |  |
| `GetParameterNameY` | `() -> string` |  |
| `AddPoint` | `(x: number, y: number, animation: string, speed?: number)` |  |
| `ClearPoints` | `()` |  |
| `BuildTriangulation` | `()` |  |


### UIElement  `: Animatable`

**构造**

```lua
fun(): UIElement
```

**属性（66）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `screenPosition` | IntVector2 |  |
| `name` | string |  |
| `position` | IntVector2 |  |
| `size` | IntVector2 |  |
| `width` | integer |  |
| `height` | integer |  |
| `minSize` | IntVector2 |  |
| `minWidth` | integer |  |
| `minHeight` | integer |  |
| `maxSize` | IntVector2 |  |
| `maxWidth` | integer |  |
| `maxHeight` | integer |  |
| `fixedSize` | boolean |  |
| `fixedWidth` | boolean |  |
| `fixedHeight` | boolean |  |
| `childOffset` | IntVector2 |  |
| `horizontalAlignment` | HorizontalAlignment |  |
| `verticalAlignment` | VerticalAlignment |  |
| `enableAnchor` | boolean |  |
| `minOffset` | IntVector2 |  |
| `maxOffset` | IntVector2 |  |
| `minAnchor` | Vector2 |  |
| `maxAnchor` | Vector2 |  |
| `pivot` | Vector2 |  |
| `scale` | Vector2 |  |
| `rotate` | number |  |
| `clipBorder` | IntRect |  |
| `color` | Color |  |
| `priority` | integer |  |
| `opacity` | number |  |
| `derivedOpacity` | number |  |
| `bringToFront` | boolean |  |
| `bringToBack` | boolean |  |
| `clipChildren` | boolean |  |
| `sortChildren` | boolean |  |
| `useDerivedOpacity` | boolean |  |
| `focus` | boolean |  |
| `enabled` | boolean |  |
| `enabledSelf` | boolean |  |
| `editable` | boolean |  |
| `selected` | boolean |  |
| `visible` | boolean |  |
| `visibleEffective` | boolean |  |
| `hovering` | boolean |  |
| `internal` | boolean |  |
| `colorGradient` | boolean |  |
| `focusMode` | FocusMode |  |
| `dragDropMode` | integer |  |
| `style` | string |  |
| `defaultStyle` | XMLFile |  |
| `layoutMode` | LayoutMode |  |
| `layoutSpacing` | integer |  |
| `layoutBorder` | IntRect |  |
| `layoutFlexScale` | Vector2 |  |
| `numChildren` | integer |  |
| `parent` | UIElement |  |
| `root` | UIElement |  |
| `derivedColor` | Color |  |
| `combinedScreenRect` | IntRect |  |
| `indent` | integer |  |
| `indentSpacing` | integer |  |
| `indentWidth` | integer |  |
| `traversalMode` | TraversalMode |  |
| `elementEventSender` | boolean |  |
| `CreateChild` | __union_func__type_str__name_str_opt__index_int_opt__ret_UIElementT |  |
| `SetVar` | fun(self: UIElement, key: StringHash|string, value: VariantInput) |  |

**方法（158）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetScreenPosition` | `() -> IntVector2` |  |
| `LoadXML` | `(source: Deserializer) -> boolean` |  |
| `SaveXML` | `(dest: Serializer, indentation?: string) -> boolean` |  |
| `FilterAttributes` | `(dest: XMLElement) -> boolean` |  |
| `SetName` | `(name: string)` |  |
| `SetPosition` | `(position: IntVector2)` |  |
| `SetSize` | `(size: IntVector2)` |  |
| `SetWidth` | `(width: integer)` |  |
| `SetHeight` | `(height: integer)` |  |
| `SetMinSize` | `(minSize: IntVector2)` |  |
| `SetMinWidth` | `(width: integer)` |  |
| `SetMinHeight` | `(height: integer)` |  |
| `SetMaxSize` | `(maxSize: IntVector2)` |  |
| `SetMaxWidth` | `(width: integer)` |  |
| `SetMaxHeight` | `(height: integer)` |  |
| `SetFixedSize` | `(size: IntVector2)` |  |
| `SetFixedWidth` | `(width: integer)` |  |
| `SetFixedHeight` | `(height: integer)` |  |
| `SetAlignment` | `(hAlign: HorizontalAlignment, vAlign: VerticalAlignment)` |  |
| `SetHorizontalAlignment` | `(align: HorizontalAlignment)` |  |
| `SetVerticalAlignment` | `(align: VerticalAlignment)` |  |
| `SetEnableAnchor` | `(enable: boolean)` |  |
| `SetMinAnchor` | `(anchor: Vector2)` |  |
| `SetMaxAnchor` | `(anchor: Vector2)` |  |
| `SetMinOffset` | `(offset: IntVector2)` |  |
| `SetMaxOffset` | `(offset: IntVector2)` |  |
| `SetPivot` | `(pivot: Vector2)` |  |
| `SetScale` | `(scale: Vector2)` |  |
| `GetScale` | `() -> Vector2` |  |
| `SetRotate` | `(angle: number)` |  |
| `GetRotate` | `() -> number` |  |
| `SetClipBorder` | `(rect: IntRect)` |  |
| `SetColor` | `(color: Color)` |  |
| `SetPriority` | `(priority: integer)` |  |
| `SetOpacity` | `(opacity: number)` |  |
| `SetBringToFront` | `(enable: boolean)` |  |
| `SetBringToBack` | `(enable: boolean)` |  |
| `SetClipChildren` | `(enable: boolean)` |  |
| `SetSortChildren` | `(enable: boolean)` |  |
| `SetUseDerivedOpacity` | `(enable: boolean)` |  |
| `SetEnabled` | `(enable: boolean)` |  |
| `SetDeepEnabled` | `(enable: boolean)` |  |
| `ResetDeepEnabled` | `()` |  |
| `SetEnabledRecursive` | `(enable: boolean)` |  |
| `SetEditable` | `(enable: boolean)` |  |
| `SetFocus` | `(enable: boolean)` |  |
| `SetSelected` | `(enable: boolean)` |  |
| `SetVisible` | `(enable: boolean)` |  |
| `SetFocusMode` | `(mode: FocusMode)` |  |
| `SetDragDropMode` | `(mode: DragAndDropMode)` |  |
| `SetStyle` | `(styleName: string, file?: XMLFile) -> boolean` |  |
| `SetStyleAuto` | `(file?: XMLFile) -> boolean` |  |
| `SetDefaultStyle` | `(style: XMLFile)` |  |
| `SetLayout` | `(mode: LayoutMode, spacing?: integer, border?: IntRect)` |  |
| `SetLayoutMode` | `(mode: LayoutMode)` |  |
| `SetLayoutSpacing` | `(spacing: integer)` |  |
| `SetLayoutBorder` | `(border: IntRect)` |  |
| `SetLayoutFlexScale` | `(scale: Vector2)` |  |
| `SetIndent` | `(indent: integer)` |  |
| `SetIndentSpacing` | `(indentSpacing: integer)` |  |
| `UpdateLayout` | `()` |  |
| `DisableLayoutUpdate` | `()` |  |
| `EnableLayoutUpdate` | `()` |  |
| `BringToFront` | `()` |  |
| `AddChild` | `(element: UIElement)` |  |
| `InsertChild` | `(index: integer, element: UIElement)` |  |
| `RemoveChild` | `(element: UIElement, index?: integer)` |  |
| `RemoveChildAtIndex` | `(index: integer)` |  |
| `RemoveAllChildren` | `()` |  |
| `Remove` | `()` |  |
| `FindChild` | `(element: UIElement) -> integer` |  |
| `SetParent` | `(parent: UIElement, index?: integer)` |  |
| `SetVar` | `(key: StringHash|string, value: Variant)` |  |
| `SetInternal` | `(enable: boolean)` |  |
| `SetTraversalMode` | `(traversalMode: TraversalMode)` |  |
| `SetElementEventSender` | `(flag: boolean)` |  |
| `AddTag` | `(tag: string)` |  |
| `AddTags` | `(tags: string, separator: string)` |  |
| `RemoveTag` | `(tag: string) -> boolean` |  |
| `RemoveAllTags` | `()` |  |
| `GetName` | `() -> string` |  |
| `GetPosition` | `() -> IntVector2` |  |
| `GetSize` | `() -> IntVector2` |  |
| `GetWidth` | `() -> integer` |  |
| `GetHeight` | `() -> integer` |  |
| `GetMinSize` | `() -> IntVector2` |  |
| `GetMinWidth` | `() -> integer` |  |
| `GetMinHeight` | `() -> integer` |  |
| `GetMaxSize` | `() -> IntVector2` |  |
| `GetMaxWidth` | `() -> integer` |  |
| `GetMaxHeight` | `() -> integer` |  |
| `IsFixedSize` | `() -> boolean` |  |
| `IsFixedWidth` | `() -> boolean` |  |
| `IsFixedHeight` | `() -> boolean` |  |
| `GetChildOffset` | `() -> IntVector2` |  |
| `GetHorizontalAlignment` | `() -> HorizontalAlignment` |  |
| `GetVerticalAlignment` | `() -> VerticalAlignment` |  |
| `GetEnableAnchor` | `() -> boolean` |  |
| `GetMinAnchor` | `() -> Vector2` |  |
| `GetMaxAnchor` | `() -> Vector2` |  |
| `GetMinOffset` | `() -> IntVector2` |  |
| `GetMaxOffset` | `() -> IntVector2` |  |
| `GetPivot` | `() -> Vector2` |  |
| `GetClipBorder` | `() -> IntRect` |  |
| `GetColor` | `(corner: Corner) -> Color` |  |
| `GetPriority` | `() -> integer` |  |
| `GetOpacity` | `() -> number` |  |
| `GetDerivedOpacity` | `() -> number` |  |
| `GetBringToFront` | `() -> boolean` |  |
| `GetBringToBack` | `() -> boolean` |  |
| `GetClipChildren` | `() -> boolean` |  |
| `GetSortChildren` | `() -> boolean` |  |
| `GetUseDerivedOpacity` | `() -> boolean` |  |
| `HasFocus` | `() -> boolean` |  |
| `IsEnabled` | `() -> boolean` |  |
| `IsEnabledSelf` | `() -> boolean` |  |
| `IsEditable` | `() -> boolean` |  |
| `IsSelected` | `() -> boolean` |  |
| `IsVisible` | `() -> boolean` |  |
| `IsVisibleEffective` | `() -> boolean` |  |
| `IsHovering` | `() -> boolean` |  |
| `IsInternal` | `() -> boolean` |  |
| `HasColorGradient` | `() -> boolean` |  |
| `GetFocusMode` | `() -> FocusMode` |  |
| `GetDragDropMode` | `() -> DragAndDropMode` |  |
| `GetAppliedStyle` | `() -> string` |  |
| `GetDefaultStyle` | `(recursiveUp?: boolean) -> XMLFile` |  |
| `GetLayoutMode` | `() -> LayoutMode` |  |
| `GetLayoutSpacing` | `() -> integer` |  |
| `GetLayoutBorder` | `() -> IntRect` |  |
| `GetLayoutFlexScale` | `() -> Vector2` |  |
| `GetNumChildren` | `(recursive?: boolean) -> integer` |  |
| `GetDragButtonCombo` | `() -> integer` |  |
| `GetDragButtonCount` | `() -> integer` |  |
| `GetChild` | `(name: string, recursive?: boolean) -> UIElement` |  |
| `IsChildOf` | `(element: UIElement) -> boolean` |  |
| `GetParent` | `() -> UIElement` |  |
| `GetRoot` | `() -> UIElement` |  |
| `GetDerivedColor` | `() -> Color` |  |
| `GetVar` | `(key: StringHash|string) -> Variant` |  |
| `GetVars` | `() -> VariantMap` |  |
| `HasTag` | `(tag: string) -> boolean` |  |
| `GetTags` | `() -> StringVector` |  |
| `GetChildrenWithTag` | `(tag: string, recursive?: boolean) -> UIElement[]` |  |
| `ScreenToElement` | `(screenPosition: IntVector2) -> IntVector2` |  |
| `ElementToScreen` | `(position: IntVector2) -> IntVector2` |  |
| `IsInside` | `(position: IntVector2, isScreen: boolean) -> boolean` |  |
| `IsInsideCombined` | `(position: IntVector2, isScreen: boolean) -> boolean` |  |
| `GetCombinedScreenRect` | `() -> IntRect` |  |
| `SortChildren` | `()` |  |
| `GetIndent` | `() -> integer` |  |
| `GetIndentSpacing` | `() -> integer` |  |
| `GetIndentWidth` | `() -> integer` |  |
| `SetChildOffset` | `(offset: IntVector2)` |  |
| `SetHovering` | `(enable: boolean)` |  |
| `GetTraversalMode` | `() -> TraversalMode` |  |
| `IsElementEventSender` | `() -> boolean` |  |
| `GetElementEventSender` | `() -> UIElement` |  |


### BorderImage  `: UIElement`

**构造**

```lua
fun(): BorderImage
```

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `texture` | Texture |  |
| `imageRect` | IntRect |  |
| `border` | IntRect |  |
| `imageBorder` | IntRect |  |
| `hoverOffset` | IntVector2 |  |
| `blendMode` | BlendMode |  |
| `tiled` | boolean |  |

**方法（15）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetTexture` | `(texture: Texture)` |  |
| `SetImageRect` | `(rect: IntRect)` |  |
| `SetFullImageRect` | `()` |  |
| `SetBorder` | `(rect: IntRect)` |  |
| `SetImageBorder` | `(rect: IntRect)` |  |
| `SetHoverOffset` | `(offset: IntVector2)` |  |
| `SetBlendMode` | `(mode: BlendMode)` |  |
| `SetTiled` | `(enable: boolean)` |  |
| `GetTexture` | `() -> Texture` |  |
| `GetImageRect` | `() -> IntRect` |  |
| `GetBorder` | `() -> IntRect` |  |
| `GetImageBorder` | `() -> IntRect` |  |
| `GetHoverOffset` | `() -> IntVector2` |  |
| `GetBlendMode` | `() -> BlendMode` |  |
| `IsTiled` | `() -> boolean` |  |


### BoundingBox

**构造**

```lua
fun(box: BoundingBox): BoundingBox
fun(rect: Rect): BoundingBox
fun(min: Vector3, max: Vector3): BoundingBox
fun(min: number, max: number): BoundingBox
fun(frustum: Frustum): BoundingBox
fun(poly: Polyhedron): BoundingBox
fun(sphere: Sphere): BoundingBox
fun(): BoundingBox
```

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `min` | Vector3 |  |
| `max` | Vector3 |  |
| `center` | Vector3 |  |
| `size` | Vector3 |  |
| `halfSize` | Vector3 |  |

**方法（15）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Define` | `(box: BoundingBox)` |  |
| `Merge` | `(point: Vector3)` |  |
| `Clip` | `(box: BoundingBox)` |  |
| `Transform` | `(transform: Matrix3)` |  |
| `Clear` | `()` |  |
| `Defined` | `() -> boolean` |  |
| `Center` | `() -> Vector3` |  |
| `Size` | `() -> Vector3` |  |
| `HalfSize` | `() -> Vector3` |  |
| `Transformed` | `(transform: Matrix3) -> BoundingBox` |  |
| `Projected` | `(projection: Matrix4) -> Rect` |  |
| `DistanceToPoint` | `(point: Vector3) -> number` |  |
| `IsInside` | `(point: Vector3) -> Intersection` |  |
| `IsInsideFast` | `(box: BoundingBox) -> Intersection` |  |
| `ToString` | `() -> string` |  |

**运算符**：`eq(BoundingBox): boolean`


### Button  `: BorderImage`

**构造**

```lua
fun(): Button
```

**属性（9）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `pressedOffset` | IntVector2 |  |
| `disabledOffset` | IntVector2 |  |
| `pressedChildOffset` | IntVector2 |  |
| `repeatDelay` | number |  |
| `repeatRate` | number |  |
| `pressed` | boolean |  |
| `text` | string |  |
| `showText` | boolean |  |
| `textElement` | Text |  |

**方法（17）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetPressedOffset` | `(offset: IntVector2)` |  |
| `SetDisabledOffset` | `(offset: IntVector2)` |  |
| `SetPressedChildOffset` | `(offset: IntVector2)` |  |
| `SetRepeat` | `(delay: number, rate: number)` |  |
| `SetRepeatDelay` | `(delay: number)` |  |
| `SetRepeatRate` | `(rate: number)` |  |
| `SetText` | `(text: string)` |  |
| `GetText` | `() -> string` |  |
| `GetTextElement` | `() -> Text` |  |
| `SetShowText` | `(enable: boolean)` |  |
| `GetShowText` | `() -> boolean` |  |
| `GetPressedOffset` | `() -> IntVector2` |  |
| `GetDisabledOffset` | `() -> IntVector2` |  |
| `GetPressedChildOffset` | `() -> IntVector2` |  |
| `GetRepeatDelay` | `() -> number` |  |
| `GetRepeatRate` | `() -> number` |  |
| `IsPressed` | `() -> boolean` |  |


### CPUTexture  `: Resource`

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `format` | integer |  |
| `width` | integer |  |
| `height` | integer |  |
| `numMips` | integer |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetFormat` | `() -> integer` | Return the format of the stored pixels. After a readback this is the G |
| `GetWidth` | `() -> integer` | Return the pixel width of mip zero. |
| `GetHeight` | `() -> integer` | Return the pixel height of mip zero. |
| `GetNumMips` | `() -> integer` | Return the number of stored mip levels. |
| `SaveNPY` | `(filePath: string, level?: integer) -> boolean` | Save R32F/RGBA16F/RGBA32F bits as NPY (height, width, channels), witho |


### Camera  `: Component`

**属性（27）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `farClip` | number |  |
| `nearClip` | number |  |
| `fov` | number |  |
| `orthoSize` | number |  |
| `aspectRatio` | number |  |
| `zoom` | number |  |
| `lodBias` | number |  |
| `viewMask` | integer |  |
| `viewOverrideFlags` | ViewOverride |  |
| `fillMode` | FillMode |  |
| `orthographic` | boolean |  |
| `autoAspectRatio` | boolean |  |
| `frustum` | Frustum |  |
| `projection` | Matrix4 |  |
| `gpuProjection` | Matrix4 |  |
| `view` | Matrix3x4 |  |
| `halfViewSize` | number |  |
| `viewSpaceFrustum` | Frustum |  |
| `projectionOffset` | Vector2 |  |
| `useReflection` | boolean |  |
| `reflectionPlane` | Plane |  |
| `useClipping` | boolean |  |
| `clipPlane` | Plane |  |
| `reverseZ` | boolean |  |
| `handedness` | Handedness |  |
| `projectionValid` | boolean |  |
| `effectiveWorldTransform` | Matrix3x4 |  |

**方法（58）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetNearClip` | `(nearClip: number)` |  |
| `SetFarClip` | `(farClip: number)` |  |
| `SetFov` | `(fov: number)` |  |
| `SetOrthoSize` | `(orthoSize: number)` |  |
| `SetAspectRatio` | `(aspectRatio: number)` |  |
| `SetFillMode` | `(mode: FillMode)` |  |
| `SetZoom` | `(zoom: number)` |  |
| `SetLodBias` | `(bias: number)` |  |
| `SetViewMask` | `(mask: integer)` |  |
| `SetViewOverrideFlags` | `(flags: ViewOverride)` |  |
| `SetOrthographic` | `(enable: boolean)` |  |
| `SetAutoAspectRatio` | `(enable: boolean)` |  |
| `SetProjectionOffset` | `(offset: Vector2)` |  |
| `SetUseReflection` | `(enable: boolean)` |  |
| `SetReflectionPlane` | `(reflectionPlane: Plane)` |  |
| `SetUseClipping` | `(enable: boolean)` |  |
| `SetClipPlane` | `(clipPlane: Plane)` |  |
| `SetProjection` | `(projection: Matrix4)` |  |
| `SetReverseZ` | `(enable: boolean)` |  |
| `SetHandedness` | `(handedness: Handedness)` |  |
| `GetHandedness` | `() -> Handedness` |  |
| `GetFarClip` | `() -> number` |  |
| `GetNearClip` | `() -> number` |  |
| `GetFov` | `() -> number` |  |
| `GetOrthoSize` | `() -> number` |  |
| `GetAspectRatio` | `() -> number` |  |
| `GetZoom` | `() -> number` |  |
| `GetLodBias` | `() -> number` |  |
| `GetViewMask` | `() -> integer` |  |
| `GetViewOverrideFlags` | `() -> ViewOverride` |  |
| `GetFillMode` | `() -> FillMode` |  |
| `IsOrthographic` | `() -> boolean` |  |
| `GetAutoAspectRatio` | `() -> boolean` |  |
| `GetFrustum` | `() -> Frustum` |  |
| `GetProjection` | `() -> Matrix4` |  |
| `GetGPUProjection` | `() -> Matrix4` |  |
| `GetView` | `() -> Matrix3x4` |  |
| `GetFrustumSize` | `(near: Vector3, far: Vector3)` |  |
| `GetHalfViewSize` | `() -> number` |  |
| `GetSplitFrustum` | `(nearClip: number, farClip: number) -> Frustum` |  |
| `GetViewSpaceFrustum` | `() -> Frustum` |  |
| `GetViewSpaceSplitFrustum` | `(nearClip: number, farClip: number) -> Frustum` |  |
| `GetScreenRay` | `(x: number, y: number) -> Ray` |  |
| `WorldToScreenPoint` | `(worldPos: Vector3) -> Vector2` |  |
| `ScreenToWorldPoint` | `(screenPos: Vector3) -> Vector3` |  |
| `GetProjectionOffset` | `() -> Vector2` |  |
| `GetUseReflection` | `() -> boolean` |  |
| `GetReflectionPlane` | `() -> Plane` |  |
| `GetUseClipping` | `() -> boolean` |  |
| `GetClipPlane` | `() -> Plane` |  |
| `GetReverseZ` | `() -> boolean` |  |
| `UseReverseZ` | `() -> boolean` |  |
| `GetFarthestDepthValue` | `() -> number` |  |
| `GetDistance` | `(worldPos: Vector3) -> number` |  |
| `GetDistanceSquared` | `(worldPos: Vector3) -> number` |  |
| `GetLodDistance` | `(distance: number, scale: number, bias: number) -> number` |  |
| `IsProjectionValid` | `() -> boolean` |  |
| `GetEffectiveWorldTransform` | `() -> Matrix3x4` |  |


### CharacterComponent  `: Component`

**构造**

```lua
fun(): CharacterComponent
```

**属性（20）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `controls` | Controls |  |
| `rotationSpeed` | number |  |
| `autoRotateToMoveDir` | boolean |  |
| `airControlFactor` | number |  |
| `airFriction` | number |  |
| `airSpeedRatio` | number |  |
| `walkSpeed` | number |  |
| `runSpeed` | number |  |
| `enableWalkMode` | boolean |  |
| `applyRootMotion` | boolean |  |
| `applyRootMotionChannels` | integer |  |
| `moveSpeed` | number |  |
| `moving` | boolean |  |
| `onGround` | boolean |  |
| `jumping` | boolean |  |
| `jumpStarted` | boolean |  |
| `localVelocityX` | number |  |
| `localVelocityY` | number |  |
| `smoothMoveSpeed` | number |  |
| `moveDirection` | number |  |

**方法（29）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetRotationSpeed` | `(speed: number)` |  |
| `GetRotationSpeed` | `() -> number` |  |
| `SetAutoRotateToMoveDir` | `(enable: boolean)` |  |
| `GetAutoRotateToMoveDir` | `() -> boolean` |  |
| `SetAirControlFactor` | `(factor: number)` |  |
| `GetAirControlFactor` | `() -> number` |  |
| `SetAirFriction` | `(friction: number)` |  |
| `GetAirFriction` | `() -> number` |  |
| `SetAirSpeedRatio` | `(ratio: number)` |  |
| `GetAirSpeedRatio` | `() -> number` |  |
| `SetWalkSpeed` | `(speed: number)` |  |
| `GetWalkSpeed` | `() -> number` |  |
| `SetRunSpeed` | `(speed: number)` |  |
| `GetRunSpeed` | `() -> number` |  |
| `SetEnableWalkMode` | `(enable: boolean)` |  |
| `GetEnableWalkMode` | `() -> boolean` |  |
| `SetApplyRootMotion` | `(enable: boolean)` |  |
| `GetApplyRootMotion` | `() -> boolean` |  |
| `SetApplyRootMotionChannels` | `(channels: integer)` |  |
| `GetApplyRootMotionChannels` | `() -> integer` |  |
| `GetMoveSpeed` | `() -> number` |  |
| `IsMoving` | `() -> boolean` |  |
| `IsOnGround` | `() -> boolean` |  |
| `IsJumping` | `() -> boolean` |  |
| `IsJumpStarted` | `() -> boolean` |  |
| `GetLocalVelocityX` | `() -> number` |  |
| `GetLocalVelocityY` | `() -> number` |  |
| `GetSmoothMoveSpeed` | `() -> number` |  |
| `GetMoveDirection` | `() -> number` |  |


### CheckBox  `: BorderImage`

**构造**

```lua
fun(): CheckBox
```

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `checked` | boolean |  |
| `checkedOffset` | IntVector2 |  |

**方法（4）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetChecked` | `(enable: boolean)` |  |
| `SetCheckedOffset` | `(rect: IntVector2)` |  |
| `IsChecked` | `() -> boolean` |  |
| `GetCheckedOffset` | `() -> IntVector2` |  |


### ClientCloudBatchGet

**方法（2）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Key` | `(key: string 云变量 key) -> ClientCloudBatchGet` |  |
| `Fetch` | `(events: ScoreEvents 回调表 { ok = function(values, iscores), error = function(code, reason) })` | 执行批量读取 |


### ClientCloudBatchSet

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Set` | `(key: string 云变量 key, value: any 任意类型值) -> ClientCloudBatchSet` | 设置任意类型值 (写入到 values 表) |
| `SetInt` | `(key: string 云变量 key, value: integer 整数值) -> ClientCloudBatchSet` | 设置整数值 (写入到 iscores 表，可参与排行榜排序) |
| `Add` | `(key: string 云变量 key, delta: integer 增量（可为负数）) -> ClientCloudBatchSet` | 整数增量操作 (写入到 iscores 表) |
| `Delete` | `(key: string 云变量 key) -> ClientCloudBatchSet` |  |
| `Save` | `(description: string 操作描述, events?: ScoreEvents 回调表)` |  |


### CloudSceneInfo

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `version` | string 不可变归档版本 |  |
| `totalBytes` | integer 压缩后的归档字节数 |  |
| `chunkCount` | integer 云分块数量 |  |


### CloudSceneSaveOptions

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `data?` | any 同场景一起采集的附加数据，cmsgpack 上限 1 MiB |  |
| `compress?` | boolean 默认 true，按归档内部块使用 LZ4 |  |
| `blockSize?` | integer 内部块大小，4096 至 262144 字节 |  |


### CloudSceneSaveEvents

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `ok?` | fun(info: CloudSceneInfo) 仅 head 已确认后调用 |  |
| `error?` | fun(code: string, reason: string) Failed 或 PublishUnknown；后者可能已发布 |  |


### CloudSceneLoadEvents


### ClientCloud

**方法（11）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SaveScene` | `(slot: string 1-32 个 ASCII 字母、数字或短横线, scene: Scene, options?: CloudSceneSaveOptions, events?: CloudSceneSaveEvents) -> string?` | 在帧末同步采集到磁盘，随后异步分块上传。完成/错误回调在主线程执行。 场景和 options.data 保持引用直到实际采集；项目切换取消任 |
| `LoadScene` | `(slot: string, options?: table 当前版本保留参数, events?: CloudSceneLoadEvents) -> string?` | 下载到磁盘并校验后，在主线程同步构建新场景，大场景加载可能暂停一帧。 |
| `Get` | `(key: string 云变量 key, events: ScoreEvents 回调表 { ok = function(values, iscores) })` | 单个读取 回调签名: ok = function(values, iscores) - values: 通过 Set 写入的任意类型值 -  |
| `Set` | `(key: string 云变量 key, value: any 任意类型值, events?: ScoreEvents 回调表)` | 单个写入任意类型值 (写入到 values 表) 支持 string, number, boolean, table 等任意 Lua 类型 |
| `SetInt` | `(key: string 云变量 key, value: integer 整数值, events?: ScoreEvents 回调表)` | 单个写入整数值 (写入到 iscores 表，可参与排行榜排序) |
| `Add` | `(key: string 云变量 key, delta: integer 增量（可为负数）, events?: ScoreEvents 回调表)` | 单个整数增量操作 (写入到 iscores 表) |
| `BatchGet` | `() -> ClientCloudBatchGet` | 批量读取（链式调用） |
| `BatchSet` | `() -> ClientCloudBatchSet` | 批量写入（链式调用） |
| `GetRankList` | `(key: string 排序 key (必须是 iscores 中的 key), start: number 起始位置（0 开始）, count: number 获取数量, orderAsc: boolean true 为升序排列，默认降序, events: ScoreEvents 回调表 { ok = function(rankList: ClientCloudRankItem[]) }, ...: string 可选的附加字段名)  (+1 重载)` | 获取排行榜 可选 orderAsc 参数控制排序方向（默认降序），events 之后可传入额外 key 名称 |
| `GetUserRank` | `(userId: number 用户 ID, key: string 排序 key (必须是 iscores 中的 key), events: ScoreEvents 回调表 { ok = function(rank: number|nil, scoreValue: number) })` | 获取用户排名 |
| `GetRankTotal` | `(key: string 排序 key (必须是 iscores 中的 key), events: ScoreEvents 回调表 { ok = function(total: number) })` | 获取排行榜总人数 |


### CollisionShape2D  `: Component`

**属性（10）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `trigger` | boolean |  |
| `categoryBits` | integer |  |
| `maskBits` | integer |  |
| `groupIndex` | integer |  |
| `density` | number |  |
| `friction` | number |  |
| `restitution` | number |  |
| `mass` | number |  |
| `inertia` | number |  |
| `massCenter` | Vector2 |  |

**方法（17）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetTrigger` | `(trigger: boolean)` |  |
| `SetCategoryBits` | `(categoryBits: integer)` |  |
| `SetMaskBits` | `(maskBits: integer)` |  |
| `SetGroupIndex` | `(groupIndex: integer)` |  |
| `SetDensity` | `(density: number)` |  |
| `SetFriction` | `(friction: number)` |  |
| `SetRestitution` | `(restitution: number)` |  |
| `IsTrigger` | `() -> boolean` |  |
| `GetCategoryBits` | `() -> integer` |  |
| `GetMaskBits` | `() -> integer` |  |
| `GetGroupIndex` | `() -> integer` |  |
| `GetDensity` | `() -> number` |  |
| `GetFriction` | `() -> number` |  |
| `GetRestitution` | `() -> number` |  |
| `GetMass` | `() -> number` |  |
| `GetInertia` | `() -> number` |  |
| `GetMassCenter` | `() -> Vector2` |  |


### CollisionBox2D  `: CollisionShape2D`

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `size` | Vector2 |  |
| `center` | Vector2 |  |
| `angle` | number |  |

**方法（6）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetSize` | `(size: Vector2)` |  |
| `SetCenter` | `(center: Vector2)` |  |
| `SetAngle` | `(angle: number)` |  |
| `GetSize` | `() -> Vector2` |  |
| `GetCenter` | `() -> Vector2` |  |
| `GetAngle` | `() -> number` |  |


### CollisionChain2D  `: CollisionShape2D`

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `loop` | boolean |  |
| `vertexCount` | integer |  |

**方法（7）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetLoop` | `(loop: boolean)` |  |
| `SetVertexCount` | `(count: integer)` |  |
| `SetVertex` | `(index: integer, vertex: Vector2)` |  |
| `SetVertices` | `(vertices: Vector2[])` |  |
| `GetLoop` | `() -> boolean` |  |
| `GetVertexCount` | `() -> integer` |  |
| `GetVertex` | `(index: integer) -> Vector2` |  |


### CollisionCircle2D  `: CollisionShape2D`

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `radius` | number |  |
| `center` | Vector2 |  |

**方法（4）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetRadius` | `(radius: number)` |  |
| `SetCenter` | `(center: Vector2)` |  |
| `GetRadius` | `() -> number` |  |
| `GetCenter` | `() -> Vector2` |  |


### CollisionEdge2D  `: CollisionShape2D`

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `vertex1` | Vector2 |  |
| `vertex2` | Vector2 |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetVertex1` | `(vertex: Vector2)` |  |
| `SetVertex2` | `(vertex: Vector2)` |  |
| `SetVertices` | `(vertex1: Vector2, vertex2: Vector2)` |  |
| `GetVertex1` | `() -> Vector2` |  |
| `GetVertex2` | `() -> Vector2` |  |


### CollisionPolygon2D  `: CollisionShape2D`

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `vertexCount` | integer |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetVertexCount` | `(count: integer)` |  |
| `SetVertex` | `(index: integer, vertex: Vector2)` |  |
| `SetVertices` | `(vertices: Vector2[])` |  |
| `GetVertexCount` | `() -> integer` |  |
| `GetVertex` | `(index: integer) -> Vector2` |  |


### CollisionShape  `: Component`

**构造**

```lua
fun(): CollisionShape
```

**属性（10）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `physicsWorld` | PhysicsWorld |  |
| `shapeType` | ShapeType |  |
| `size` | Vector3 |  |
| `position` | Vector3 |  |
| `rotation` | Quaternion |  |
| `margin` | number |  |
| `model` | Model |  |
| `lodLevel` | integer |  |
| `worldBoundingBox` | BoundingBox |  |
| `modelAttr` | ResourceRef |  |

**方法（28）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetBox` | `(size: Vector3, position?: Vector3, rotation?: Quaternion)` |  |
| `SetSphere` | `(diameter: number, position?: Vector3, rotation?: Quaternion)` |  |
| `SetStaticPlane` | `(position?: Vector3, rotation?: Quaternion)` |  |
| `SetCylinder` | `(diameter: number, height: number, position?: Vector3, rotation?: Quaternion)` |  |
| `SetCapsule` | `(diameter: number, height: number, position?: Vector3, rotation?: Quaternion)` |  |
| `SetCone` | `(diameter: number, height: number, position?: Vector3, rotation?: Quaternion)` |  |
| `SetTriangleMesh` | `(model: Model, lodLevel?: integer, scale?: Vector3, position?: Vector3, rotation?: Quaternion)` |  |
| `SetCustomTriangleMesh` | `(custom: CustomGeometry, scale?: Vector3, position?: Vector3, rotation?: Quaternion)` |  |
| `SetConvexHull` | `(model: Model, lodLevel?: integer, scale?: Vector3, position?: Vector3, rotation?: Quaternion)` |  |
| `SetCustomConvexHull` | `(custom: CustomGeometry, scale?: Vector3, position?: Vector3, rotation?: Quaternion)` |  |
| `SetTerrain` | `(lodLevel?: integer)` |  |
| `SetShapeType` | `(type: ShapeType)` |  |
| `SetSize` | `(size: Vector3)` |  |
| `SetPosition` | `(position: Vector3)` |  |
| `SetRotation` | `(rotation: Quaternion)` |  |
| `SetTransform` | `(position: Vector3, rotation: Quaternion)` |  |
| `SetMargin` | `(margin: number)` |  |
| `SetModel` | `(model: Model)` |  |
| `SetLodLevel` | `(lodLevel: integer)` |  |
| `GetPhysicsWorld` | `() -> PhysicsWorld` |  |
| `GetShapeType` | `() -> ShapeType` |  |
| `GetSize` | `() -> Vector3` |  |
| `GetPosition` | `() -> Vector3` |  |
| `GetRotation` | `() -> Quaternion` |  |
| `GetMargin` | `() -> number` |  |
| `GetModel` | `() -> Model` |  |
| `GetLodLevel` | `() -> integer` |  |
| `GetWorldBoundingBox` | `() -> BoundingBox` |  |


### Color

**构造**

```lua
fun(color: Color): Color
fun(color: Color, a: number): Color
fun(r: number, g: number, b: number): Color
fun(r: number, g: number, b: number, a: number): Color
fun(): Color
fun(self: Color, color: Color): Color
fun(color: Color): Color
fun(self: Color, color: Color, a: number): Color
```

**属性（27）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `r` | number |  |
| `g` | number |  |
| `b` | number |  |
| `a` | number |  |
| `sumRGB` | number |  |
| `average` | number |  |
| `luma` | number |  |
| `chroma` | number |  |
| `hue` | number |  |
| `saturationHSL` | number |  |
| `saturationHSV` | number |  |
| `value` | number |  |
| `lightness` | number |  |
| `maxRGB` | number |  |
| `minRGB` | number |  |
| `range` | number |  |
| `abs` | Color |  |
| `WHITE` | Color |  |
| `GRAY` | Color |  |
| `BLACK` | Color |  |
| `RED` | Color |  |
| `GREEN` | Color |  |
| `BLUE` | Color |  |
| `CYAN` | Color |  |
| `MAGENTA` | Color |  |
| `YELLOW` | Color |  |
| `TRANSPARENT_BLACK` | Color |  |

**方法（26）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `ToUInt` | `() -> integer` |  |
| `ToHSL` | `() -> Vector3` |  |
| `ToHSV` | `() -> Vector3` |  |
| `FromUInt` | `(color: integer)` |  |
| `FromHSL` | `(h: number, s: number, l: number, a: number)` |  |
| `FromHSV` | `(h: number, s: number, v: number, a: number)` |  |
| `ToVector3` | `() -> Vector3` |  |
| `ToVector4` | `() -> Vector4` |  |
| `SumRGB` | `() -> number` |  |
| `Average` | `() -> number` |  |
| `Luma` | `() -> number` |  |
| `Chroma` | `() -> number` |  |
| `Hue` | `() -> number` |  |
| `SaturationHSL` | `() -> number` |  |
| `SaturationHSV` | `() -> number` |  |
| `Value` | `() -> number` |  |
| `Lightness` | `() -> number` |  |
| `MaxRGB` | `() -> number` |  |
| `MinRGB` | `() -> number` |  |
| `Range` | `() -> number` |  |
| `Clip` | `(clipAlpha?: boolean)` |  |
| `Invert` | `(invertAlpha?: boolean)` |  |
| `Lerp` | `(rhs: Color, t: number) -> Color` |  |
| `Abs` | `() -> Color` |  |
| `Equals` | `(rhs: Color) -> boolean` |  |
| `ToString` | `() -> string` |  |

**运算符**：`eq(Color): boolean`、`mul(number): Color`、`add(Color): Color`、`unm: Color`、`sub(Color): Color`


### ColorGrading  `: Component`

**属性（36）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `LUT` | ColorLUT |  |
| `lutIntensity` | number |  |
| `secondaryLUT` | ColorLUT |  |
| `lutBlendFactor` | number |  |
| `exposure` | number |  |
| `temperature` | number |  |
| `tint` | number |  |
| `globalSaturation` | number |  |
| `globalContrast` | number |  |
| `globalGamma` | number |  |
| `globalGain` | number |  |
| `globalOffset` | number |  |
| `shadowsSaturation` | number |  |
| `shadowsContrast` | number |  |
| `shadowsGamma` | number |  |
| `shadowsGain` | number |  |
| `shadowsOffset` | number |  |
| `shadowsTint` | Color |  |
| `shadowsTintIntensity` | number |  |
| `midtonesSaturation` | number |  |
| `midtonesContrast` | number |  |
| `midtonesGamma` | number |  |
| `midtonesGain` | number |  |
| `midtonesOffset` | number |  |
| `midtonesTint` | Color |  |
| `midtonesTintIntensity` | number |  |
| `highlightsSaturation` | number |  |
| `highlightsContrast` | number |  |
| `highlightsGamma` | number |  |
| `highlightsGain` | number |  |
| `highlightsOffset` | number |  |
| `highlightsTint` | Color |  |
| `highlightsTintIntensity` | number |  |
| `shadowsMax` | number |  |
| `highlightsMin` | number |  |
| `colorGradingEnabled` | boolean |  |

**方法（76）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetLUT` | `(lut: ColorLUT)` |  |
| `GetLUT` | `() -> ColorLUT` |  |
| `SetLUTIntensity` | `(intensity: number)` |  |
| `GetLUTIntensity` | `() -> number` |  |
| `SetSecondaryLUT` | `(lut: ColorLUT)` |  |
| `GetSecondaryLUT` | `() -> ColorLUT` |  |
| `SetLUTBlendFactor` | `(factor: number)` |  |
| `GetLUTBlendFactor` | `() -> number` |  |
| `BlendToLUT` | `(target: ColorLUT, duration: number)` |  |
| `SetExposure` | `(exposure: number)` |  |
| `GetExposure` | `() -> number` |  |
| `SetTemperature` | `(temp: number)` |  |
| `GetTemperature` | `() -> number` |  |
| `SetTint` | `(tint: number)` |  |
| `GetTint` | `() -> number` |  |
| `SetGlobalSaturation` | `(value: number)` |  |
| `GetGlobalSaturation` | `() -> number` |  |
| `SetGlobalContrast` | `(value: number)` |  |
| `GetGlobalContrast` | `() -> number` |  |
| `SetGlobalGamma` | `(value: number)` |  |
| `GetGlobalGamma` | `() -> number` |  |
| `SetGlobalGain` | `(value: number)` |  |
| `GetGlobalGain` | `() -> number` |  |
| `SetGlobalOffset` | `(value: number)` |  |
| `GetGlobalOffset` | `() -> number` |  |
| `SetShadowsSaturation` | `(value: number)` |  |
| `GetShadowsSaturation` | `() -> number` |  |
| `SetShadowsContrast` | `(value: number)` |  |
| `GetShadowsContrast` | `() -> number` |  |
| `SetShadowsGamma` | `(value: number)` |  |
| `GetShadowsGamma` | `() -> number` |  |
| `SetShadowsGain` | `(value: number)` |  |
| `GetShadowsGain` | `() -> number` |  |
| `SetShadowsOffset` | `(value: number)` |  |
| `GetShadowsOffset` | `() -> number` |  |
| `SetShadowsTint` | `(tint: Color)` |  |
| `GetShadowsTint` | `() -> Color` |  |
| `SetShadowsTintIntensity` | `(value: number)` |  |
| `GetShadowsTintIntensity` | `() -> number` |  |
| `SetMidtonesSaturation` | `(value: number)` |  |
| `GetMidtonesSaturation` | `() -> number` |  |
| `SetMidtonesContrast` | `(value: number)` |  |
| `GetMidtonesContrast` | `() -> number` |  |
| `SetMidtonesGamma` | `(value: number)` |  |
| `GetMidtonesGamma` | `() -> number` |  |
| `SetMidtonesGain` | `(value: number)` |  |
| `GetMidtonesGain` | `() -> number` |  |
| `SetMidtonesOffset` | `(value: number)` |  |
| `GetMidtonesOffset` | `() -> number` |  |
| `SetMidtonesTint` | `(tint: Color)` |  |
| `GetMidtonesTint` | `() -> Color` |  |
| `SetMidtonesTintIntensity` | `(value: number)` |  |
| `GetMidtonesTintIntensity` | `() -> number` |  |
| `SetHighlightsSaturation` | `(value: number)` |  |
| `GetHighlightsSaturation` | `() -> number` |  |
| `SetHighlightsContrast` | `(value: number)` |  |
| `GetHighlightsContrast` | `() -> number` |  |
| `SetHighlightsGamma` | `(value: number)` |  |
| `GetHighlightsGamma` | `() -> number` |  |
| `SetHighlightsGain` | `(value: number)` |  |
| `GetHighlightsGain` | `() -> number` |  |
| `SetHighlightsOffset` | `(value: number)` |  |
| `GetHighlightsOffset` | `() -> number` |  |
| `SetHighlightsTint` | `(tint: Color)` |  |
| `GetHighlightsTint` | `() -> Color` |  |
| `SetHighlightsTintIntensity` | `(value: number)` |  |
| `GetHighlightsTintIntensity` | `() -> number` |  |
| `SetShadowsMax` | `(value: number)` |  |
| `GetShadowsMax` | `() -> number` |  |
| `SetHighlightsMin` | `(value: number)` |  |
| `GetHighlightsMin` | `() -> number` |  |
| `SetColorGradingEnabled` | `(enabled: boolean)` |  |
| `IsColorGradingEnabled` | `() -> boolean` |  |
| `SavePreset` | `(path: string) -> boolean` |  |
| `LoadPreset` | `(path: string) -> boolean` |  |
| `ResetToDefaults` | `()` |  |


### ColorLUT  `: Resource`

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `texture3D` | Texture3D |  |
| `texture2DStrip` | Texture2D |  |
| `size` | integer |  |
| `format` | ColorLUTFormat |  |
| `title` | string |  |

**方法（6）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetTexture3D` | `() -> Texture3D` |  |
| `GetTexture2DStrip` | `() -> Texture2D` |  |
| `GetSize` | `() -> integer` |  |
| `GetFormat` | `() -> ColorLUTFormat` |  |
| `GetTitle` | `() -> string` |  |
| `SampleCPU` | `(input: Color) -> Color` |  |


### ComputeReadback  `: Object`

**方法（4）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `IsReady` | `() -> boolean` | Return whether data or an error is available without waiting for the G |
| `HasError` | `() -> boolean` | Return whether the request failed or was cancelled. |
| `GetError` | `() -> string` | Return the failure diagnostic, or an empty string. |
| `GetData` | `() -> VectorBuffer` | Return a copy of the completed snapshot, or an empty buffer before suc |


### ComputeBuffer  `: Object`

**构造**

```lua
fun(): ComputeBuffer
```

**方法（7）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetSize` | `(elementType: string, count: integer) -> boolean` | Allocate zero-initialized storage with 1..2^24 elements; failure prese |
| `Release` | `()` | Release storage and invalidate queued bindings. |
| `GetElementType` | `() -> string` | Return the element spelling used by shader buffer declarations. |
| `GetCount` | `() -> integer` | Return the allocated element count. |
| `GetStride` | `() -> integer` | Return the element size in bytes. |
| `RequestReadback` | `() -> ComputeReadback` | Queue an asynchronous snapshot at this point in the compute queue. Lua |
| `GetLastError` | `() -> string` | Return the most recent allocation error; readback requests carry their |


### ComputeDispatch  `: Object`

**构造**

```lua
fun(): ComputeDispatch
```

**方法（11）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetShader` | `(resourceName: string) -> boolean` | Load and prepare a compute .shader for the active device; failure pres |
| `SetShaderParameter` | `(name: string, value: Variant) -> boolean` | Set a uniform by source name; dense Lua tables represent vectors, matr |
| `SetTexture` | `(name: string, texture: Texture) -> boolean` | Bind a single-sample Texture2D sampler input, or nil to clear it. |
| `SetImage` | `(name: string, texture: Texture, mip?: integer) -> boolean` | Bind a linear storage image with matching format, mip and compute-writ |
| `SetBuffer` | `(name: string, buffer: ComputeBuffer) -> boolean` | Bind independently created storage with matching element type, or nil  |
| `CreateImage2D` | `(name: string, width: integer, height: integer) -> Texture2D` | Create and bind a writable single-mip texture using the declared image |
| `CreateBuffer` | `(name: string, count: integer) -> ComputeBuffer` | Create and bind zero-initialized storage using the declared element ty |
| `GetWorkgroupSize` | `() -> IntVector3` | Return the declared local workgroup dimensions, or zero before success |
| `DispatchThreads` | `(x: number, y?: number, z?: number) -> boolean` | Queue logical threads; padded invocations are masked. Axes must be non |
| `DispatchGroups` | `(x: number, y?: number, z?: number) -> boolean` | Queue complete workgroups; the shader must guard its own data bounds. |
| `GetLastError` | `() -> string` | Return the most recent preparation, binding or submission error. |


### RemoteEvent

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `senderID` | integer |  |
| `eventType` | StringHash|string |  |
| `eventData` | VariantMap |  |
| `inOrder` | boolean |  |


### Connection  `: Object`

**属性（23）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `identity` | VariantMap |  |
| `scene` | Scene |  |
| `controls` | Controls |  |
| `timeStamp` | number -- unsigned char |  |
| `position` | Vector3 |  |
| `rotation` | Quaternion |  |
| `client` | boolean |  |
| `connected` | boolean |  |
| `connectPending` | boolean |  |
| `sceneLoaded` | boolean |  |
| `logStatistics` | boolean |  |
| `address` | string |  |
| `port` | integer -- unsigned short |  |
| `roundTripTime` | number |  |
| `lastHeardTime` | number |  |
| `bytesInPerSec` | number |  |
| `bytesOutPerSec` | number |  |
| `packetsInPerSec` | number |  |
| `packetsOutPerSec` | number |  |
| `numDownloads` | integer |  |
| `downloadName` | string |  |
| `downloadProgress` | number |  |
| `pulseButtonMask` | integer |  |

**方法（37）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SendMessage` | `(msgID: integer, reliable: boolean, inOrder: boolean, msg: VectorBuffer)` |  |
| `SendRemoteEvent` | `(eventType: StringHash|string, inOrder: boolean, eventData?: VariantMap)` |  |
| `SetScene` | `(newScene: Scene)` |  |
| `GetSceneSyncMode` | `() -> SceneSyncMode` |  |
| `SetIdentity` | `(identity: VariantMap)` |  |
| `SetControls` | `(newControls: Controls)` |  |
| `SetPosition` | `(position: Vector3)` |  |
| `SetRotation` | `(rotation: Quaternion)` |  |
| `SetConnectPending` | `(connectPending: boolean)` |  |
| `SetLogStatistics` | `(enable: boolean)` |  |
| `Disconnect` | `(waitMSec?: integer)` |  |
| `SendPackageToClient` | `(package: PackageFile)` |  |
| `SetPulseButtonMask` | `(mask: integer)` |  |
| `GetPulseButtonMask` | `() -> integer` |  |
| `GetIdentity` | `() -> VariantMap` |  |
| `GetScene` | `() -> Scene` |  |
| `GetControls` | `() -> Controls` |  |
| `GetTimeStamp` | `() -> number` |  |
| `GetPosition` | `() -> Vector3` |  |
| `GetRotation` | `() -> Quaternion` |  |
| `IsClient` | `() -> boolean` |  |
| `IsConnected` | `() -> boolean` |  |
| `IsConnectPending` | `() -> boolean` |  |
| `IsSceneLoaded` | `() -> boolean` |  |
| `GetLogStatistics` | `() -> boolean` |  |
| `GetAddress` | `() -> string` |  |
| `GetPort` | `() -> integer` |  |
| `GetRoundTripTime` | `() -> number` |  |
| `GetLastHeardTime` | `() -> number` |  |
| `GetBytesInPerSec` | `() -> number` |  |
| `GetBytesOutPerSec` | `() -> number` |  |
| `GetPacketsInPerSec` | `() -> number` |  |
| `GetPacketsOutPerSec` | `() -> number` |  |
| `ToString` | `() -> string` |  |
| `GetNumDownloads` | `() -> integer` |  |
| `GetDownloadName` | `() -> string` |  |
| `GetDownloadProgress` | `() -> number` |  |


### Console  `: Object`

**属性（12）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `defaultStyle` | XMLFile |  |
| `background` | BorderImage |  |
| `lineEdit` | LineEdit |  |
| `closeButton` | Button |  |
| `visible` | boolean |  |
| `autoVisibleOnError` | boolean |  |
| `commandInterpreter` | string |  |
| `numBufferedRows` | integer |  |
| `numRows` | integer |  |
| `numHistoryRows` | integer |  |
| `historyPosition` | integer |  |
| `focusOnShow` | boolean |  |

**方法（26）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetDefaultStyle` | `(style: XMLFile)` |  |
| `SetVisible` | `(enable: boolean)` |  |
| `Toggle` | `()` |  |
| `SetAutoVisibleOnError` | `(enable: boolean)` |  |
| `SetCommandInterpreter` | `(interpreter: string)` |  |
| `SetNumBufferedRows` | `(rows: integer)` |  |
| `SetNumRows` | `(rows: integer)` |  |
| `SetNumHistoryRows` | `(rows: integer)` |  |
| `SetFocusOnShow` | `(enable: boolean)` |  |
| `AddAutoComplete` | `(option: string)` |  |
| `RemoveAutoComplete` | `(option: string)` |  |
| `UpdateElements` | `()` |  |
| `GetDefaultStyle` | `() -> XMLFile` |  |
| `GetBackground` | `() -> BorderImage` |  |
| `GetLineEdit` | `() -> LineEdit` |  |
| `GetCloseButton` | `() -> Button` |  |
| `IsVisible` | `() -> boolean` |  |
| `IsAutoVisibleOnError` | `() -> boolean` |  |
| `GetCommandInterpreter` | `() -> string` |  |
| `GetNumBufferedRows` | `() -> integer` |  |
| `GetNumRows` | `() -> integer` |  |
| `CopySelectedRows` | `()` |  |
| `GetNumHistoryRows` | `() -> integer` |  |
| `GetHistoryPosition` | `() -> integer` |  |
| `GetHistoryRow` | `(index: integer) -> string` |  |
| `GetFocusOnShow` | `() -> boolean` |  |


### Constraint  `: Component`

**构造**

```lua
fun(): Constraint
```

**属性（16）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `physicsWorld` | PhysicsWorld |  |
| `constraintType` | ConstraintType |  |
| `ownBody` | RigidBody |  |
| `otherBody` | RigidBody |  |
| `position` | Vector3 |  |
| `rotation` | Quaternion |  |
| `axis` | Vector3 |  |
| `otherPosition` | Vector3 |  |
| `otherRotation` | Quaternion |  |
| `otherAxis` | Vector3 |  |
| `worldPosition` | Vector3 |  |
| `highLimit` | Vector2 |  |
| `lowLimit` | Vector2 |  |
| `ERP` | number |  |
| `CFM` | number |  |
| `disableCollision` | boolean |  |

**方法（28）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetConstraintType` | `(type: ConstraintType)` |  |
| `SetOtherBody` | `(body: RigidBody)` |  |
| `SetPosition` | `(position: Vector3)` |  |
| `SetRotation` | `(rotation: Quaternion)` |  |
| `SetAxis` | `(axis: Vector3)` |  |
| `SetOtherPosition` | `(position: Vector3)` |  |
| `SetOtherRotation` | `(rotation: Quaternion)` |  |
| `SetOtherAxis` | `(axis: Vector3)` |  |
| `SetWorldPosition` | `(position: Vector3)` |  |
| `SetHighLimit` | `(limit: Vector2)` |  |
| `SetLowLimit` | `(limit: Vector2)` |  |
| `SetERP` | `(erp: number)` |  |
| `SetCFM` | `(cfm: number)` |  |
| `SetDisableCollision` | `(disable: boolean)` |  |
| `GetPhysicsWorld` | `() -> PhysicsWorld` |  |
| `GetConstraintType` | `() -> ConstraintType` |  |
| `GetOwnBody` | `() -> RigidBody` |  |
| `GetOtherBody` | `() -> RigidBody` |  |
| `GetPosition` | `() -> Vector3` |  |
| `GetRotation` | `() -> Quaternion` |  |
| `GetOtherPosition` | `() -> Vector3` |  |
| `GetOtherRotation` | `() -> Quaternion` |  |
| `GetWorldPosition` | `() -> Vector3` |  |
| `GetHighLimit` | `() -> Vector2` |  |
| `GetLowLimit` | `() -> Vector2` |  |
| `GetERP` | `() -> number` |  |
| `GetCFM` | `() -> number` |  |
| `GetDisableCollision` | `() -> boolean` |  |


### Constraint2D  `: Component`

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `ownerBody` | RigidBody2D |  |
| `otherBody` | RigidBody2D |  |
| `collideConnected` | boolean |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetOtherBody` | `(body: RigidBody2D)` |  |
| `SetCollideConnected` | `(collideConnected: boolean)` |  |
| `GetOwnerBody` | `() -> RigidBody2D` |  |
| `GetOtherBody` | `() -> RigidBody2D` |  |
| `GetCollideConnected` | `() -> boolean` |  |


### ConstraintDistance2D  `: Constraint2D`

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `ownerBodyAnchor` | Vector2 |  |
| `otherBodyAnchor` | Vector2 |  |
| `frequencyHz` | number |  |
| `dampingRatio` | number |  |
| `length` | number |  |

**方法（10）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetOwnerBodyAnchor` | `(anchor: Vector2)` |  |
| `SetOtherBodyAnchor` | `(anchor: Vector2)` |  |
| `SetFrequencyHz` | `(frequencyHz: number)` |  |
| `SetDampingRatio` | `(dampingRatio: number)` |  |
| `SetLength` | `(length: number)` |  |
| `GetOwnerBodyAnchor` | `() -> Vector2` |  |
| `GetOtherBodyAnchor` | `() -> Vector2` |  |
| `GetFrequencyHz` | `() -> number` |  |
| `GetDampingRatio` | `() -> number` |  |
| `GetLength` | `() -> number` |  |


### ConstraintFriction2D  `: Constraint2D`

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `anchor` | Vector2 |  |
| `maxForce` | number |  |
| `maxTorque` | number |  |

**方法（6）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetAnchor` | `(anchor: Vector2)` |  |
| `SetMaxForce` | `(maxForce: number)` |  |
| `SetMaxTorque` | `(maxTorque: number)` |  |
| `GetAnchor` | `() -> Vector2` |  |
| `GetMaxForce` | `() -> number` |  |
| `GetMaxTorque` | `() -> number` |  |


### ConstraintGear2D  `: Constraint2D`

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `ownerConstraint` | Constraint2D |  |
| `otherConstraint` | Constraint2D |  |
| `ratio` | number |  |

**方法（6）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetOwnerConstraint` | `(constraint: Constraint2D)` |  |
| `SetOtherConstraint` | `(constraint: Constraint2D)` |  |
| `SetRatio` | `(ratio: number)` |  |
| `GetOwnerConstraint` | `() -> Constraint2D` |  |
| `GetOtherConstraint` | `() -> Constraint2D` |  |
| `GetRatio` | `() -> number` |  |


### ConstraintMotor2D  `: Constraint2D`

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `linearOffset` | Vector2 |  |
| `angularOffset` | number |  |
| `maxForce` | number |  |
| `maxTorque` | number |  |
| `correctionFactor` | number |  |

**方法（10）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetLinearOffset` | `(linearOffset: Vector2)` |  |
| `SetAngularOffset` | `(angularOffset: number)` |  |
| `SetMaxForce` | `(maxForce: number)` |  |
| `SetMaxTorque` | `(maxTorque: number)` |  |
| `SetCorrectionFactor` | `(correctionFactor: number)` |  |
| `GetLinearOffset` | `() -> Vector2` |  |
| `GetAngularOffset` | `() -> number` |  |
| `GetMaxForce` | `() -> number` |  |
| `GetMaxTorque` | `() -> number` |  |
| `GetCorrectionFactor` | `() -> number` |  |


### ConstraintMouse2D  `: Constraint2D`

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `target` | Vector2 |  |
| `maxForce` | number |  |
| `frequencyHz` | number |  |
| `dampingRatio` | number |  |

**方法（8）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetTarget` | `(target: Vector2)` |  |
| `SetMaxForce` | `(maxForce: number)` |  |
| `SetFrequencyHz` | `(frequencyHz: number)` |  |
| `SetDampingRatio` | `(dampingRatio: number)` |  |
| `GetTarget` | `() -> Vector2` |  |
| `GetMaxForce` | `() -> number` |  |
| `GetFrequencyHz` | `() -> number` |  |
| `GetDampingRatio` | `() -> number` |  |


### ConstraintPrismatic2D  `: Constraint2D`

**属性（8）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `anchor` | Vector2 |  |
| `axis` | Vector2 |  |
| `enableLimit` | boolean |  |
| `lowerTranslation` | number |  |
| `upperTranslation` | number |  |
| `enableMotor` | boolean |  |
| `maxMotorForce` | number |  |
| `motorSpeed` | number |  |

**方法（16）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetAnchor` | `(anchor: Vector2)` |  |
| `SetAxis` | `(axis: Vector2)` |  |
| `SetEnableLimit` | `(enableLimit: boolean)` |  |
| `SetLowerTranslation` | `(lowerTranslation: number)` |  |
| `SetUpperTranslation` | `(upperTranslation: number)` |  |
| `SetEnableMotor` | `(enableMotor: boolean)` |  |
| `SetMaxMotorForce` | `(maxMotorForce: number)` |  |
| `SetMotorSpeed` | `(motorSpeed: number)` |  |
| `GetAnchor` | `() -> Vector2` |  |
| `GetAxis` | `() -> Vector2` |  |
| `GetEnableLimit` | `() -> boolean` |  |
| `GetLowerTranslation` | `() -> number` |  |
| `GetUpperTranslation` | `() -> number` |  |
| `GetEnableMotor` | `() -> boolean` |  |
| `GetMaxMotorForce` | `() -> number` |  |
| `GetMotorSpeed` | `() -> number` |  |


### ConstraintPulley2D  `: Constraint2D`

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `ownerBodyGroundAnchor` | Vector2 |  |
| `otherBodyGroundAnchor` | Vector2 |  |
| `ownerBodyAnchor` | Vector2 |  |
| `otherBodyAnchor` | Vector2 |  |
| `ratio` | number |  |

**方法（10）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetOwnerBodyGroundAnchor` | `(groundAnchor: Vector2)` |  |
| `SetOtherBodyGroundAnchor` | `(groundAnchor: Vector2)` |  |
| `SetOwnerBodyAnchor` | `(anchor: Vector2)` |  |
| `SetOtherBodyAnchor` | `(anchor: Vector2)` |  |
| `SetRatio` | `(ratio: number)` |  |
| `GetOwnerBodyGroundAnchor` | `() -> Vector2` |  |
| `GetOtherBodyGroundAnchor` | `() -> Vector2` |  |
| `GetOwnerBodyAnchor` | `() -> Vector2` |  |
| `GetOtherBodyAnchor` | `() -> Vector2` |  |
| `GetRatio` | `() -> number` |  |


### ConstraintRevolute2D  `: Constraint2D`

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `anchor` | Vector2 |  |
| `enableLimit` | boolean |  |
| `lowerAngle` | number |  |
| `upperAngle` | number |  |
| `enableMotor` | boolean |  |
| `motorSpeed` | number |  |
| `maxMotorTorque` | number |  |

**方法（14）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetAnchor` | `(anchor: Vector2)` |  |
| `SetEnableLimit` | `(enableLimit: boolean)` |  |
| `SetLowerAngle` | `(lowerAngle: number)` |  |
| `SetUpperAngle` | `(upperAngle: number)` |  |
| `SetEnableMotor` | `(enableMotor: boolean)` |  |
| `SetMotorSpeed` | `(motorSpeed: number)` |  |
| `SetMaxMotorTorque` | `(maxMotorTorque: number)` |  |
| `GetAnchor` | `() -> Vector2` |  |
| `GetEnableLimit` | `() -> boolean` |  |
| `GetLowerAngle` | `() -> number` |  |
| `GetUpperAngle` | `() -> number` |  |
| `GetEnableMotor` | `() -> boolean` |  |
| `GetMotorSpeed` | `() -> number` |  |
| `GetMaxMotorTorque` | `() -> number` |  |


### ConstraintRope2D  `: Constraint2D`

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `ownerBodyAnchor` | Vector2 |  |
| `otherBodyAnchor` | Vector2 |  |
| `maxLength` | number |  |

**方法（6）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetOwnerBodyAnchor` | `(anchor: Vector2)` |  |
| `SetOtherBodyAnchor` | `(anchor: Vector2)` |  |
| `SetMaxLength` | `(maxLength: number)` |  |
| `GetOwnerBodyAnchor` | `() -> Vector2` |  |
| `GetOtherBodyAnchor` | `() -> Vector2` |  |
| `GetMaxLength` | `() -> number` |  |


### ConstraintWeld2D  `: Constraint2D`

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `anchor` | Vector2 |  |
| `frequencyHz` | number |  |
| `dampingRatio` | number |  |

**方法（6）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetAnchor` | `(anchor: Vector2)` |  |
| `SetFrequencyHz` | `(frequencyHz: number)` |  |
| `SetDampingRatio` | `(dampingRatio: number)` |  |
| `GetAnchor` | `() -> Vector2` |  |
| `GetFrequencyHz` | `() -> number` |  |
| `GetDampingRatio` | `() -> number` |  |


### ConstraintWheel2D  `: Constraint2D`

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `anchor` | Vector2 |  |
| `axis` | Vector2 |  |
| `enableMotor` | boolean |  |
| `maxMotorTorque` | number |  |
| `motorSpeed` | number |  |
| `frequencyHz` | number |  |
| `dampingRatio` | number |  |

**方法（14）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetAnchor` | `(anchor: Vector2)` |  |
| `SetAxis` | `(axis: Vector2)` |  |
| `SetEnableMotor` | `(enableMotor: boolean)` |  |
| `SetMaxMotorTorque` | `(maxMotorTorque: number)` |  |
| `SetMotorSpeed` | `(motorSpeed: number)` |  |
| `SetFrequencyHz` | `(frequencyHz: number)` |  |
| `SetDampingRatio` | `(dampingRatio: number)` |  |
| `GetAnchor` | `() -> Vector2` |  |
| `GetAxis` | `() -> Vector2` |  |
| `GetEnableMotor` | `() -> boolean` |  |
| `GetMaxMotorTorque` | `() -> number` |  |
| `GetMotorSpeed` | `() -> number` |  |
| `GetFrequencyHz` | `() -> number` |  |
| `GetDampingRatio` | `() -> number` |  |


### Context

**方法（3）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetEventSender` | `() -> Object` |  |
| `GetEventHandler` | `() -> EventHandler` |  |
| `GetTypeName` | `(objectType: StringHash|string) -> string` |  |


### Controls

**构造**

```lua
fun(): Controls
```

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `buttons` | integer |  |
| `yaw` | number |  |
| `pitch` | number |  |
| `extraData` | VariantMap |  |

**方法（4）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Reset` | `()` |  |
| `Set` | `(buttons: integer, down?: boolean)` |  |
| `IsDown` | `(button: integer) -> boolean` |  |
| `IsPressed` | `(button: integer, previousControls: Controls) -> boolean` |  |


### CrowdAgent  `: Component`

**属性（20）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `targetPosition` | Vector3 |  |
| `targetVelocity` | Vector3 |  |
| `updateNodePosition` | boolean |  |
| `maxAccel` | number |  |
| `maxSpeed` | number |  |
| `radius` | number |  |
| `height` | number |  |
| `queryFilterType` | integer |  |
| `obstacleAvoidanceType` | integer |  |
| `navigationQuality` | NavigationQuality |  |
| `navigationPushiness` | NavigationPushiness |  |
| `position` | Vector3 |  |
| `desiredVelocity` | Vector3 |  |
| `actualVelocity` | Vector3 |  |
| `requestedTargetType` | CrowdAgentRequestedTarget |  |
| `agentState` | CrowdAgentState |  |
| `targetState` | CrowdAgentTargetState |  |
| `requestedTarget` | boolean |  |
| `arrived` | boolean |  |
| `inCrowd` | boolean |  |

**方法（33）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `DrawDebugGeometry` | `(depthTest: boolean)` |  |
| `SetTargetPosition` | `(position: Vector3)` |  |
| `SetTargetVelocity` | `(velocity: Vector3)` |  |
| `ResetTarget` | `()` |  |
| `SetUpdateNodePosition` | `(unodepos: boolean)` |  |
| `SetMaxAccel` | `(maxAccel: number)` |  |
| `SetMaxSpeed` | `(maxSpeed: number)` |  |
| `SetRadius` | `(radius: number)` |  |
| `SetHeight` | `(height: number)` |  |
| `SetQueryFilterType` | `(queryFilterType: integer)` |  |
| `SetObstacleAvoidanceType` | `(obstacleOvoidanceType: integer)` |  |
| `SetNavigationQuality` | `(val: NavigationQuality)` |  |
| `SetNavigationPushiness` | `(val: NavigationPushiness)` |  |
| `GetPosition` | `() -> Vector3` |  |
| `GetDesiredVelocity` | `() -> Vector3` |  |
| `GetActualVelocity` | `() -> Vector3` |  |
| `GetTargetPosition` | `() -> Vector3` |  |
| `GetTargetVelocity` | `() -> Vector3` |  |
| `GetRequestedTargetType` | `() -> CrowdAgentRequestedTarget` |  |
| `GetAgentState` | `() -> CrowdAgentState` |  |
| `GetTargetState` | `() -> CrowdAgentTargetState` |  |
| `GetUpdateNodePosition` | `() -> boolean` |  |
| `GetMaxAccel` | `() -> number` |  |
| `GetMaxSpeed` | `() -> number` |  |
| `GetRadius` | `() -> number` |  |
| `GetHeight` | `() -> number` |  |
| `GetQueryFilterType` | `() -> integer` |  |
| `GetObstacleAvoidanceType` | `() -> integer` |  |
| `GetNavigationQuality` | `() -> NavigationQuality` |  |
| `GetNavigationPushiness` | `() -> NavigationPushiness` |  |
| `HasRequestedTarget` | `() -> boolean` |  |
| `HasArrived` | `() -> boolean` |  |
| `IsInCrowd` | `() -> boolean` |  |


### CrowdManager  `: Component`

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `maxAgents` | integer |  |
| `maxAgentRadius` | number |  |
| `navigationMesh` | NavigationMesh |  |

**方法（29）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `DrawDebugGeometry` | `(depthTest: boolean)` |  |
| `SetCrowdTarget` | `(position: Vector3, node?: Node)` |  |
| `SetCrowdVelocity` | `(velocity: Vector3, node?: Node)` |  |
| `ResetCrowdTarget` | `(node?: Node)` |  |
| `SetMaxAgents` | `(agentCt: integer)` |  |
| `SetMaxAgentRadius` | `(maxAgentRadius: number)` |  |
| `SetNavigationMesh` | `(navMesh: NavigationMesh)` |  |
| `SetIncludeFlags` | `(queryFilterType: integer, flags: integer -- unsigned short)` |  |
| `SetExcludeFlags` | `(queryFilterType: integer, flags: integer -- unsigned short)` |  |
| `SetAreaCost` | `(queryFilterType: integer, areaID: integer, cost: number)` |  |
| `SetObstacleAvoidanceParams` | `(obstacleAvoidanceType: integer, params: CrowdObstacleAvoidanceParams)` |  |
| `GetAgents` | `(node?: Node, inCrowdFilter?: boolean) -> CrowdAgent[]` |  |
| `FindNearestPoint` | `(point: Vector3, queryFilterType: integer) -> Vector3` |  |
| `MoveAlongSurface` | `(start: Vector3, end_: Vector3, queryFilterType: integer, maxVisited?: integer) -> Vector3` |  |
| `FindPath` | `(start: Vector3, end_: Vector3, queryFilterType: integer) -> Vector3[]` |  |
| `GetRandomPoint` | `(queryFilterType: integer) -> Vector3` |  |
| `GetRandomPointInCircle` | `(center: Vector3, radius: number, queryFilterType: integer) -> Vector3` |  |
| `GetDistanceToWall` | `(point: Vector3, radius: number, queryFilterType: integer, hitPos?: Vector3, hitNormal?: Vector3) -> number` |  |
| `Raycast` | `(start: Vector3, end_: Vector3, queryFilterType: integer, hitNormal?: Vector3) -> Vector3` |  |
| `GetMaxAgents` | `() -> integer` |  |
| `GetMaxAgentRadius` | `() -> number` |  |
| `GetNavigationMesh` | `() -> NavigationMesh` |  |
| `GetNumQueryFilterTypes` | `() -> integer` |  |
| `GetNumAreas` | `(queryFilterType: integer) -> integer` |  |
| `GetIncludeFlags` | `(queryFilterType: integer) -> integer` |  |
| `GetExcludeFlags` | `(queryFilterType: integer) -> integer` |  |
| `GetAreaCost` | `(queryFilterType: integer, areaID: integer) -> number` |  |
| `GetNumObstacleAvoidanceTypes` | `() -> integer` |  |
| `GetObstacleAvoidanceParams` | `(obstacleAvoidanceType: integer) -> CrowdObstacleAvoidanceParams` |  |


### Cursor  `: BorderImage`

**构造**

```lua
fun(): Cursor
```

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `shape` | string |  |
| `useSystemShapes` | boolean |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `DefineShape` | `(shape: string, image: Image, imageRect: IntRect, hotSpot: IntVector2)` |  |
| `SetShape` | `(shape: CursorShape)` |  |
| `SetUseSystemShapes` | `(enable: boolean)` |  |
| `GetShape` | `() -> string` |  |
| `GetUseSystemShapes` | `() -> boolean` |  |


### CustomGeometryVertex

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `position` | Vector3 |  |
| `normal` | Vector3 |  |
| `color` | integer |  |
| `texCoord` | Vector2 |  |
| `tangent` | Vector4 |  |


### CustomGeometry  `: Drawable`

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `material` | Material |  |
| `numGeometries` | integer |  |
| `dynamic` | boolean |  |
| `useInstanceColor` | boolean Enable the Surface Shader INSTANCE_COLOR input for CustomGeometry. |  |
| `instanceColor` | Color Surface Shader INSTANCE_COLOR input for CustomGeometry. |  |
| `useInstanceCustomData` | boolean |  |
| `instanceCustomData` | Vector4 |  |

**方法（23）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Clear` | `()` |  |
| `SetNumGeometries` | `(num: integer)` |  |
| `SetDynamic` | `(enable: boolean)` |  |
| `BeginGeometry` | `(index: integer, type: PrimitiveType)` |  |
| `DefineVertex` | `(position: Vector3)` | 绕序约定：三角形正面 = (v1-v0)×(v2-v0) 指向的一侧，正面须朝外，反了会被默认背面剔除。例：(0,0,0)→(0,0,1)→ |
| `DefineNormal` | `(normal: Vector3)` |  |
| `DefineTangent` | `(tangent: Vector4)` |  |
| `DefineColor` | `(color: Color)` |  |
| `DefineTexCoord` | `(texCoord: Vector2)` |  |
| `DefineGeometry` | `(index: integer, type: PrimitiveType, numVertices: integer, hasNormals: boolean, hasColors: boolean, hasTexCoords: boolean, hasTangents: boolean)` |  |
| `GenerateTangents` | `() -> boolean` | 从已定义的法线 + UV 一键生成切线（等价 Godot generate_tangents / Unity RecalculateTang |
| `Commit` | `()` |  |
| `SetMaterial` | `(material: Material)` |  |
| `GetNumGeometries` | `() -> integer` |  |
| `GetNumVertices` | `(index: integer) -> integer` |  |
| `FillModel` | `(model: Model) -> boolean` |  |
| `IsDynamic` | `() -> boolean` |  |
| `GetMaterial` | `(index?: integer) -> Material` |  |
| `GetVertex` | `(geometryIndex: integer, vertexNum: integer) -> CustomGeometryVertex` | 注意：经本函数写入的字段引擎无法记账（分不清"写过"和"未初始化"）。切线要生效，请走 DefineTangent / GenerateTa |
| `SetInstanceColor` | `(color: Color)` | Surface Shader INSTANCE_COLOR input for CustomGeometry. |
| `GetInstanceColor` | `() -> Color` | Surface Shader INSTANCE_COLOR input for CustomGeometry. |
| `SetInstanceCustomData` | `(data: Vector4)` | Surface Shader INSTANCE_CUSTOM data for CustomGeometry. |
| `GetInstanceCustomData` | `() -> Vector4` | Surface Shader INSTANCE_CUSTOM data for CustomGeometry. |


### Database  `: Object`

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `pooling` | boolean |  |
| `poolSize` | integer |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Connect` | `(connectionString: string) -> DbConnection` |  |
| `Disconnect` | `(connection: DbConnection)` |  |
| `IsPooling` | `() -> boolean` |  |
| `GetPoolSize` | `() -> integer` |  |
| `SetPoolSize` | `(poolSize: integer)` |  |


### DbConnection  `: Object`

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `connectionString` | string |  |
| `connected` | boolean |  |

**方法（4）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Finalize` | `()` |  |
| `Execute` | `(sql: string, useCursorEvent?: boolean) -> DbResult` |  |
| `GetConnectionString` | `() -> string` |  |
| `IsConnected` | `() -> boolean` |  |


### DbResult

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `numColumns` | integer |  |
| `numRows` | integer |  |
| `numAffectedRows` | integer |  |

**方法（3）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetNumColumns` | `() -> integer` |  |
| `GetNumRows` | `() -> integer` |  |
| `GetNumAffectedRows` | `() -> integer` |  |


### DebugHud  `: Object`

**属性（8）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `defaultStyle` | XMLFile |  |
| `statsText` | Text |  |
| `modeText` | Text |  |
| `profilerText` | Text |  |
| `mode` | integer |  |
| `profilerMaxDepth` | integer |  |
| `profilerInterval` | number |  |
| `useRendererStats` | boolean |  |

**方法（19）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Update` | `()` |  |
| `SetDefaultStyle` | `(style: XMLFile)` |  |
| `SetMode` | `(mode: integer)` |  |
| `SetProfilerMaxDepth` | `(depth: integer)` |  |
| `SetProfilerInterval` | `(interval: number)` |  |
| `SetUseRendererStats` | `(enable: boolean)` |  |
| `Toggle` | `(mode: integer)` |  |
| `ToggleAll` | `()` |  |
| `GetDefaultStyle` | `() -> XMLFile` |  |
| `GetStatsText` | `() -> Text` |  |
| `GetModeText` | `() -> Text` |  |
| `GetProfilerText` | `() -> Text` |  |
| `GetMode` | `() -> integer` |  |
| `GetProfilerMaxDepth` | `() -> integer` |  |
| `GetProfilerInterval` | `() -> number` |  |
| `GetUseRendererStats` | `() -> boolean` |  |
| `SetAppStats` | `(label: string, stats: Variant)` |  |
| `ResetAppStats` | `(label: string) -> boolean` |  |
| `ClearAppStats` | `()` |  |


### DebugRenderer  `: Component`

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `lineAntiAlias` | boolean |  |
| `view` | Matrix3x4 |  |
| `projection` | Matrix4 |  |
| `frustum` | Frustum |  |

**方法（21）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetLineAntiAlias` | `(enable: boolean)` |  |
| `SetView` | `(camera: Camera)` |  |
| `AddLine` | `(start: Vector3, end_: Vector3, color: Color, depthTest?: boolean)` |  |
| `AddTriangle` | `(v1: Vector3, v2: Vector3, v3: Vector3, color: Color, depthTest?: boolean)` |  |
| `AddPolygon` | `(v1: Vector3, v2: Vector3, v3: Vector3, v4: Vector3, color: Color, depthTest?: boolean)` |  |
| `AddNode` | `(node: Node, scale?: number, depthTest?: boolean)` |  |
| `AddBoundingBox` | `(box: BoundingBox, color: Color, depthTest?: boolean, solid?: boolean)` |  |
| `AddFrustum` | `(frustum: Frustum, color: Color, depthTest?: boolean)` |  |
| `AddPolyhedron` | `(poly: Polyhedron, color: Color, depthTest?: boolean)` |  |
| `AddSphere` | `(sphere: Sphere, color: Color, depthTest?: boolean)` |  |
| `AddSphereSector` | `(sphere: Sphere, rotation: Quaternion, angle: number, drawLines: boolean, color: Color, depthTest?: boolean)` |  |
| `AddSkeleton` | `(skeleton: Skeleton, color: Color, depthTest?: boolean)` |  |
| `AddCircle` | `(center: Vector3, normal: Vector3, radius: number, color: Color, steps?: integer, depthTest?: boolean)` |  |
| `AddCross` | `(center: Vector3, size: number, color: Color, depthTest?: boolean)` |  |
| `AddQuad` | `(center: Vector3, width: number, height: number, color: Color, depthTest?: boolean)` |  |
| `Render` | `()` |  |
| `GetLineAntiAlias` | `() -> boolean` |  |
| `GetView` | `() -> Matrix3x4` |  |
| `GetProjection` | `() -> Matrix4` |  |
| `GetFrustum` | `() -> Frustum` |  |
| `IsInside` | `(box: BoundingBox) -> boolean` |  |


### DecalSet  `: Drawable`

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `material` | Material |  |
| `numDecals` | integer |  |
| `numVertices` | integer |  |
| `numIndices` | integer |  |
| `maxVertices` | integer |  |
| `maxIndices` | integer |  |
| `optimizeBufferSize` | boolean |  |

**方法（14）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetMaterial` | `(material: Material)` |  |
| `SetMaxVertices` | `(num: integer)` |  |
| `SetMaxIndices` | `(num: integer)` |  |
| `SetOptimizeBufferSize` | `(enable: boolean)` |  |
| `AddDecal` | `(target: Drawable, worldPosition: Vector3, worldRotation: Quaternion, size: number, aspectRatio: number, depth: number, topLeftUV: Vector2, bottomRightUV: Vector2, timeToLive?: number, normalCutoff?: number, subGeometry?: integer) -> boolean` |  |
| `RemoveDecals` | `(num: integer)` |  |
| `RemoveAllDecals` | `()` |  |
| `GetMaterial` | `() -> Material` |  |
| `GetNumDecals` | `() -> integer` |  |
| `GetNumVertices` | `() -> integer` |  |
| `GetNumIndices` | `() -> integer` |  |
| `GetMaxVertices` | `() -> integer` |  |
| `GetMaxIndices` | `() -> integer` |  |
| `GetOptimizeBufferSize` | `() -> boolean` |  |


### DepthOfField  `: Component`

**属性（8）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `enabled` | boolean |  |
| `focalDistance` | number |  |
| `focalRange` | number |  |
| `maxBlur` | number |  |
| `quality` | integer |  |
| `nearBlurScale` | number |  |
| `farBlurScale` | number |  |
| `bokehBrightness` | number |  |

**方法（20）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetEnabled` | `(enabled: boolean)` |  |
| `IsEnabled` | `() -> boolean` |  |
| `SetFocalDistance` | `(distance: number)` |  |
| `GetFocalDistance` | `() -> number` |  |
| `SetFocalRange` | `(range: number)` |  |
| `GetFocalRange` | `() -> number` |  |
| `FocusOnPosition` | `(worldPos: Vector3)` |  |
| `FocusOnNode` | `(node: Node)` |  |
| `SetMaxBlur` | `(blur: number)` |  |
| `GetMaxBlur` | `() -> number` |  |
| `SetQuality` | `(quality: integer)` |  |
| `GetQuality` | `() -> integer` |  |
| `SetNearBlurScale` | `(scale: number)` |  |
| `GetNearBlurScale` | `() -> number` |  |
| `SetFarBlurScale` | `(scale: number)` |  |
| `GetFarBlurScale` | `() -> number` |  |
| `SetBokehBrightness` | `(brightness: number)` |  |
| `GetBokehBrightness` | `() -> number` |  |
| `TransitionFocalDistance` | `(targetDistance: number, duration: number)` |  |
| `ResetToDefaults` | `()` |  |


### Deserializer

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | string |  |
| `checksum` | integer |  |
| `position` | integer |  |
| `size` | integer |  |
| `eof` | boolean |  |

**方法（47）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Read` | `(size: integer) -> VectorBuffer` |  |
| `Seek` | `(position: integer) -> integer` |  |
| `SeekRelative` | `(delta: integer) -> integer` |  |
| `GetName` | `() -> string` |  |
| `GetChecksum` | `() -> integer` |  |
| `GetPosition` | `() -> integer` |  |
| `Tell` | `() -> integer` |  |
| `GetSize` | `() -> integer` |  |
| `IsEof` | `() -> boolean` |  |
| `ReadInt` | `() -> integer` |  |
| `ReadInt64` | `() -> integer` |  |
| `ReadShort` | `() -> integer` |  |
| `ReadByte` | `() -> integer` |  |
| `ReadUInt` | `() -> integer` |  |
| `ReadUInt64` | `() -> integer` |  |
| `ReadUShort` | `() -> integer` |  |
| `ReadUByte` | `() -> number` |  |
| `ReadBool` | `() -> boolean` |  |
| `ReadFloat` | `() -> number` |  |
| `ReadDouble` | `() -> number` |  |
| `ReadIntRect` | `() -> IntRect` |  |
| `ReadIntVector2` | `() -> IntVector2` |  |
| `ReadIntVector3` | `() -> IntVector3` |  |
| `ReadRect` | `() -> Rect` |  |
| `ReadVector2` | `() -> Vector2` |  |
| `ReadVector3` | `() -> Vector3` |  |
| `ReadPackedVector3` | `(maxAbsCoord: number) -> Vector3` |  |
| `ReadVector4` | `() -> Vector4` |  |
| `ReadQuaternion` | `() -> Quaternion` |  |
| `ReadPackedQuaternion` | `() -> Quaternion` |  |
| `ReadMatrix3` | `() -> Matrix3` |  |
| `ReadMatrix3x4` | `() -> Matrix3x4` |  |
| `ReadMatrix4` | `() -> Matrix4` |  |
| `ReadColor` | `() -> Color` |  |
| `ReadBoundingBox` | `() -> BoundingBox` |  |
| `ReadString` | `() -> string` |  |
| `ReadFileID` | `() -> string` |  |
| `ReadStringHash` | `() -> StringHash|string` |  |
| `ReadBuffer` | `() -> VectorBuffer` |  |
| `ReadResourceRef` | `() -> ResourceRef` |  |
| `ReadResourceRefList` | `() -> ResourceRefList` |  |
| `ReadVariant` | `(type: VariantType) -> Variant` |  |
| `ReadVariantVector` | `() -> VariantVector` |  |
| `ReadVariantMap` | `() -> VariantMap` |  |
| `ReadVLE` | `() -> integer` |  |
| `ReadNetID` | `() -> integer` |  |
| `ReadLine` | `() -> string` |  |


### DownloadTask  `: RefCounted`

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `state` | DownloadTaskState Current download state |  |
| `errorMessage` | string Error message (when failed) |  |
| `downloadedBytes` | integer Progress info for UI display |  |
| `totalBytes` | integer |  |

**方法（2）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `IsSuccess` | `() -> boolean` | Check if download succeeded |
| `IsFailed` | `() -> boolean` | Check if download failed |


### DownloadManager  `: Object`

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `concurrency` | integer |  |
| `maxRetry` | integer |  |
| `timeout` | integer |  |
| `defaultDirectory` | string |  |
| `compressionEnabled` | boolean |  |
| `activeCount` | integer |  |
| `pendingCount` | integer |  |

**方法（22）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetConcurrency` | `(count: integer)` | Set maximum concurrent downloads (default: 5) |
| `GetConcurrency` | `() -> integer` | Get maximum concurrent downloads |
| `SetMaxRetry` | `(count: integer)` | Set maximum retry count for failed downloads (default: 3) |
| `GetMaxRetry` | `() -> integer` | Get maximum retry count |
| `SetTimeout` | `(ms: integer)` | Set download timeout in milliseconds (default: 30000) |
| `GetTimeout` | `() -> integer` | Get download timeout in milliseconds |
| `GetDefaultDirectory` | `() -> string` | Get default download directory |
| `SetCompressionEnabled` | `(enabled: boolean)` | Enable/disable HTTP compression (gzip/deflate) When enabled, server co |
| `GetCompressionEnabled` | `() -> boolean` | Check if HTTP compression is enabled |
| `SetStreamThreshold` | `(bytes: integer)` | Set streaming download size threshold in bytes (default: 10MB) Resourc |
| `GetStreamThreshold` | `() -> integer` | Get streaming download size threshold |
| `CanResolve` | `(resourcePath: string Resource path (uuid://{uuid} or virtualPath)) -> boolean` | Check if any resolver can handle the resource path |
| `DownloadResource` | `(resourcePath: string Resource path (uuid://{uuid} or virtualPath))` | Download a single resource (via resolver) |
| `DownloadResources` | `(resourcePaths: StringVector Resource path list) -> integer` | Download multiple resources (via resolver) |
| `CancelResourceTask` | `(resourcePath: string Resource path (uuid://{uuid} or virtualPath)) -> boolean` | Cancel a resource download task (via resolver) |
| `CancelGroup` | `(groupId: integer)` | Cancel a download group by groupId |
| `CancelAll` | `()` | Cancel all downloads |
| `GetResourceTaskState` | `(resourcePath: string Resource path (uuid://{uuid} or virtualPath)) -> DownloadTaskState` | Get resource download state (via resolver) |
| `GetActiveCount` | `() -> integer` | Get number of active downloads |
| `GetPendingCount` | `() -> integer` | Get number of pending downloads |
| `SetDownloadObserver` | `()` | Set global download observer callback: function(activeCount, completed |
| `ClearDownloadObserver` | `()` | Clear global download observer |


### Menu  `: Button`

**构造**

```lua
fun(): Menu
```

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `popup` | UIElement |  |
| `popupOffset` | IntVector2 |  |
| `showPopup` | boolean |  |
| `acceleratorKey` | integer |  |
| `acceleratorQualifiers` | integer |  |

**方法（9）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetPopup` | `(element: UIElement)` |  |
| `SetPopupOffset` | `(offset: IntVector2)` |  |
| `ShowPopup` | `(enable: boolean)` |  |
| `SetAccelerator` | `(key: integer, qualifiers: integer)` |  |
| `GetPopup` | `() -> UIElement` |  |
| `GetPopupOffset` | `() -> IntVector2` |  |
| `GetShowPopup` | `() -> boolean` |  |
| `GetAcceleratorKey` | `() -> integer` |  |
| `GetAcceleratorQualifiers` | `() -> integer` |  |


### DropDownList  `: Menu`

**构造**

```lua
fun(): DropDownList
```

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `numItems` | integer |  |
| `selection` | integer |  |
| `selectedItem` | UIElement |  |
| `listView` | ListView |  |
| `placeholder` | UIElement |  |
| `placeholderText` | string |  |
| `resizePopup` | boolean |  |

**方法（16）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `AddItem` | `(item: UIElement)` |  |
| `InsertItem` | `(index: integer, item: UIElement)` |  |
| `RemoveItem` | `(item: UIElement)` |  |
| `RemoveAllItems` | `()` |  |
| `SetSelection` | `(index: integer)` |  |
| `SetPlaceholderText` | `(text: string)` |  |
| `SetResizePopup` | `(enable: boolean)` |  |
| `GetNumItems` | `() -> integer` |  |
| `GetItem` | `(index: integer) -> UIElement` |  |
| `GetItems` | `() -> UIElement[]` |  |
| `GetSelection` | `() -> integer` |  |
| `GetSelectedItem` | `() -> UIElement` |  |
| `GetListView` | `() -> ListView` |  |
| `GetPlaceholder` | `() -> UIElement` |  |
| `GetPlaceholderText` | `() -> string` |  |
| `GetResizePopup` | `() -> boolean` |  |


### NavigationMesh  `: Component`

**属性（21）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `tileSize` | integer |  |
| `cellSize` | number |  |
| `cellHeight` | number |  |
| `agentHeight` | number |  |
| `agentRadius` | number |  |
| `agentMaxClimb` | number |  |
| `agentMaxSlope` | number |  |
| `regionMinSize` | number |  |
| `regionMergeSize` | number |  |
| `edgeMaxLength` | number |  |
| `edgeMaxError` | number |  |
| `detailSampleDistance` | number |  |
| `detailSampleMaxError` | number |  |
| `padding` | Vector3 |  |
| `partitionType` | NavmeshPartitionType |  |
| `drawOffMeshConnections` | boolean |  |
| `drawNavAreas` | boolean |  |
| `initialized` | boolean |  |
| `boundingBox` | BoundingBox |  |
| `worldBoundingBox` | BoundingBox |  |
| `numTiles` | IntVector2 |  |

**方法（57）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetTileSize` | `(size: integer)` |  |
| `SetCellSize` | `(size: number)` |  |
| `SetCellHeight` | `(height: number)` |  |
| `SetAgentHeight` | `(height: number)` |  |
| `SetAgentRadius` | `(radius: number)` |  |
| `SetAgentMaxClimb` | `(maxClimb: number)` |  |
| `SetAgentMaxSlope` | `(maxSlope: number)` |  |
| `SetRegionMinSize` | `(size: number)` |  |
| `SetRegionMergeSize` | `(size: number)` |  |
| `SetEdgeMaxLength` | `(length: number)` |  |
| `SetEdgeMaxError` | `(error: number)` |  |
| `SetDetailSampleDistance` | `(distance: number)` |  |
| `SetDetailSampleMaxError` | `(error: number)` |  |
| `SetPadding` | `(padding: Vector3)` |  |
| `SetAreaCost` | `(areaID: integer, cost: number)` |  |
| `Allocate` | `(boundingBox: BoundingBox, maxTiles: integer) -> boolean` |  |
| `Build` | `(boundingBox: BoundingBox) -> boolean` |  |
| `GetTileData` | `(tile: IntVector2) -> VectorBuffer` |  |
| `AddTile` | `(tileData: VectorBuffer) -> boolean` |  |
| `RemoveTile` | `(tile: IntVector2)` |  |
| `RemoveAllTiles` | `()` |  |
| `HasTile` | `(tile: IntVector2) -> boolean` |  |
| `GetTileBoudningBox` | `(tile: IntVector2) -> BoundingBox` |  |
| `GetTileIndex` | `(position: Vector3) -> IntVector2` |  |
| `SetPartitionType` | `(aType: NavmeshPartitionType)` |  |
| `SetDrawOffMeshConnections` | `(enable: boolean)` |  |
| `SetDrawNavAreas` | `(enable: boolean)` |  |
| `FindNearestPoint` | `(point: Vector3, extents?: Vector3) -> Vector3` |  |
| `MoveAlongSurface` | `(start: Vector3, end_: Vector3, extents?: Vector3, maxVisited?: integer) -> Vector3` |  |
| `FindPath` | `(start: Vector3, end_: Vector3, extents?: Vector3) -> Vector3[]` |  |
| `GetRandomPoint` | `() -> Vector3` |  |
| `GetRandomPointInCircle` | `(center: Vector3, radius: number, extents?: Vector3) -> Vector3` |  |
| `GetDistanceToWall` | `(point: Vector3, radius: number, extents?: Vector3) -> number` |  |
| `Raycast` | `(start: Vector3, end_: Vector3, extents?: Vector3) -> Vector3` |  |
| `DrawDebugGeometry` | `(depthTest: boolean)` |  |
| `GetTileSize` | `() -> integer` |  |
| `GetCellSize` | `() -> number` |  |
| `GetCellHeight` | `() -> number` |  |
| `GetAgentHeight` | `() -> number` |  |
| `GetAgentRadius` | `() -> number` |  |
| `GetAgentMaxClimb` | `() -> number` |  |
| `GetAgentMaxSlope` | `() -> number` |  |
| `GetRegionMinSize` | `() -> number` |  |
| `GetRegionMergeSize` | `() -> number` |  |
| `GetEdgeMaxLength` | `() -> number` |  |
| `GetEdgeMaxError` | `() -> number` |  |
| `GetDetailSampleDistance` | `() -> number` |  |
| `GetDetailSampleMaxError` | `() -> number` |  |
| `GetPadding` | `() -> Vector3` |  |
| `GetAreaCost` | `(areaID: integer) -> number` |  |
| `IsInitialized` | `() -> boolean` |  |
| `GetBoundingBox` | `() -> BoundingBox` |  |
| `GetWorldBoundingBox` | `() -> BoundingBox` |  |
| `GetNumTiles` | `() -> IntVector2` |  |
| `GetPartitionType` | `() -> NavmeshPartitionType` |  |
| `GetDrawOffMeshConnections` | `() -> boolean` |  |
| `GetDrawNavAreas` | `() -> boolean` |  |


### DynamicNavigationMesh  `: NavigationMesh`

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `drawObstacles` | boolean |  |
| `maxObstacles` | integer |  |
| `maxLayers` | integer |  |

**方法（6）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetDrawObstacles` | `(enable: boolean)` |  |
| `SetMaxLayers` | `(maxLayers: integer)` |  |
| `SetMaxObstacles` | `(maxObstacles: integer)` |  |
| `GetDrawObstacles` | `() -> boolean` |  |
| `GetMaxLayers` | `() -> integer` |  |
| `GetMaxObstacles` | `() -> integer` |  |


### Engine  `: Object`

**属性（9）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `minFps` | integer |  |
| `maxFps` | integer |  |
| `maxInactiveFps` | integer |  |
| `timeStepSmoothing` | integer |  |
| `pauseMinimized` | boolean |  |
| `autoExit` | boolean |  |
| `initialized` | boolean |  |
| `exiting` | boolean |  |
| `headless` | boolean |  |

**方法（24）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `RunFrame` | `()` |  |
| `CreateConsole` | `() -> Console` |  |
| `CreateDebugHud` | `() -> DebugHud` |  |
| `SetMinFps` | `(fps: integer)` |  |
| `SetMaxFps` | `(fps: integer)` |  |
| `SetMaxInactiveFps` | `(fps: integer)` |  |
| `SetTimeStepSmoothing` | `(frames: integer)` |  |
| `SetPauseMinimized` | `(enable: boolean)` |  |
| `SetAutoExit` | `(enable: boolean)` |  |
| `Exit` | `()` |  |
| `DumpProfiler` | `()` |  |
| `DumpResources` | `(dumpFileName?: boolean)` |  |
| `DumpMemory` | `()` |  |
| `BeginLongTask` | `()` |  |
| `EndLongTask` | `()` |  |
| `GetMinFps` | `() -> integer` |  |
| `GetMaxFps` | `() -> integer` |  |
| `GetMaxInactiveFps` | `() -> integer` |  |
| `GetTimeStepSmoothing` | `() -> integer` |  |
| `GetPauseMinimized` | `() -> boolean` |  |
| `GetAutoExit` | `() -> boolean` |  |
| `IsInitialized` | `() -> boolean` |  |
| `IsExiting` | `() -> boolean` |  |
| `IsHeadless` | `() -> boolean` |  |


### EnvironmentBakeCache

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `gpuBakeEnabled` | boolean |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetGPUBakeEnabled` | `(enabled: boolean)` | Enable or disable GPU baking (on by default). When off, baking always  |
| `GetGPUBakeEnabled` | `() -> boolean` |  |
| `ClearCache` | `()` | Clear the cache; the next SetSourceTexture bakes again. |
| `InvalidateSource` | `(sourceTexture: Texture)` | Call after the source texture's content changed (e.g. a runtime sky cu |
| `RequestBake` | `(sourceTexture: Texture) -> boolean` | Request an IBL + SH bake of the source texture (panorama Texture2D or  |


### File  `: Object`

**构造**

```lua
fun(fileName: string, mode?: FileMode): File
fun(package: PackageFile, fileName: string): File
fun(): File
fun(self: File, fileName: string, mode?: FileMode): File
fun(fileName: string, mode?: FileMode): File
fun(self: File, package: PackageFile, fileName: string): File
fun(package: PackageFile, fileName: string): File
```

**属性（8）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `mode` | FileMode |  |
| `open` | boolean |  |
| `packaged` | boolean |  |
| `name` | string |  |
| `checksum` | integer |  |
| `position` | integer |  |
| `size` | integer |  |
| `eof` | boolean |  |

**方法（96）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Open` | `(fileName: string, mode?: FileMode) -> boolean` |  |
| `Close` | `()` |  |
| `Dispose` | `()` | 关闭文件句柄并释放 Lua 端引用 (相当于 Close() + 清空 userdata 一步到位)。 Dispose 后此 File 对象 |
| `Flush` | `()` |  |
| `SetName` | `(name: string)` |  |
| `GetMode` | `() -> FileMode` |  |
| `IsOpen` | `() -> boolean` |  |
| `GetHandle` | `() -> any` |  |
| `IsPackaged` | `() -> boolean` |  |
| `Read` | `(size: integer) -> VectorBuffer` |  |
| `Seek` | `(position: integer) -> integer` |  |
| `SeekRelative` | `(delta: integer) -> integer` |  |
| `GetName` | `() -> string` |  |
| `GetChecksum` | `() -> integer` |  |
| `GetPosition` | `() -> integer` |  |
| `Tell` | `() -> integer` |  |
| `GetSize` | `() -> integer` |  |
| `IsEof` | `() -> boolean` |  |
| `ReadInt` | `() -> integer` |  |
| `ReadInt64` | `() -> integer` |  |
| `ReadShort` | `() -> integer` |  |
| `ReadByte` | `() -> integer` |  |
| `ReadUInt` | `() -> integer` |  |
| `ReadUInt64` | `() -> integer` |  |
| `ReadUShort` | `() -> integer` |  |
| `ReadUByte` | `() -> number` |  |
| `ReadBool` | `() -> boolean` |  |
| `ReadFloat` | `() -> number` |  |
| `ReadDouble` | `() -> number` |  |
| `ReadIntRect` | `() -> IntRect` |  |
| `ReadIntVector2` | `() -> IntVector2` |  |
| `ReadIntVector3` | `() -> IntVector3` |  |
| `ReadRect` | `() -> Rect` |  |
| `ReadVector2` | `() -> Vector2` |  |
| `ReadVector3` | `() -> Vector3` |  |
| `ReadPackedVector3` | `(maxAbsCoord: number) -> Vector3` |  |
| `ReadVector4` | `() -> Vector4` |  |
| `ReadQuaternion` | `() -> Quaternion` |  |
| `ReadPackedQuaternion` | `() -> Quaternion` |  |
| `ReadMatrix3` | `() -> Matrix3` |  |
| `ReadMatrix3x4` | `() -> Matrix3x4` |  |
| `ReadMatrix4` | `() -> Matrix4` |  |
| `ReadColor` | `() -> Color` |  |
| `ReadBoundingBox` | `() -> BoundingBox` |  |
| `ReadString` | `() -> string` |  |
| `ReadFileID` | `() -> string` |  |
| `ReadStringHash` | `() -> StringHash|string` |  |
| `ReadBuffer` | `() -> VectorBuffer` |  |
| `ReadResourceRef` | `() -> ResourceRef` |  |
| `ReadResourceRefList` | `() -> ResourceRefList` |  |
| `ReadVariant` | `(type: VariantType) -> Variant` |  |
| `ReadVariantVector` | `() -> VariantVector` |  |
| `ReadVariantMap` | `() -> VariantMap` |  |
| `ReadVLE` | `() -> integer` |  |
| `ReadNetID` | `() -> integer` |  |
| `ReadLine` | `() -> string` |  |
| `Write` | `(buffer: VectorBuffer) -> integer` |  |
| `WriteInt` | `(value: integer) -> boolean` |  |
| `WriteInt64` | `(value: integer) -> boolean` |  |
| `WriteShort` | `(value: integer) -> boolean` |  |
| `WriteByte` | `(value: integer) -> boolean` |  |
| `WriteUInt` | `(value: integer) -> boolean` |  |
| `WriteUInt64` | `(value: integer) -> boolean` |  |
| `WriteUShort` | `(value: integer -- unsigned short) -> boolean` |  |
| `WriteUByte` | `(value: number -- unsigned char) -> boolean` |  |
| `WriteBool` | `(value: boolean) -> boolean` |  |
| `WriteFloat` | `(value: number) -> boolean` |  |
| `WriteDouble` | `(value: number) -> boolean` |  |
| `WriteIntRect` | `(value: IntRect) -> boolean` |  |
| `WriteIntVector2` | `(value: IntVector2) -> boolean` |  |
| `WriteIntVector3` | `(value: IntVector3) -> boolean` |  |
| `WriteRect` | `(value: Rect) -> boolean` |  |
| `WriteVector2` | `(value: Vector2) -> boolean` |  |
| `WriteVector3` | `(value: Vector3) -> boolean` |  |
| `WritePackedVector3` | `(value: Vector3, maxAbsCoord: number) -> boolean` |  |
| `WriteVector4` | `(value: Vector4) -> boolean` |  |
| `WriteQuaternion` | `(value: Quaternion) -> boolean` |  |
| `WritePackedQuaternion` | `(value: Quaternion) -> boolean` |  |
| `WriteMatrix3` | `(value: Matrix3) -> boolean` |  |
| `WriteMatrix3x4` | `(value: Matrix3x4) -> boolean` |  |
| `WriteMatrix4` | `(value: Matrix4) -> boolean` |  |
| `WriteColor` | `(value: Color) -> boolean` |  |
| `WriteBoundingBox` | `(value: BoundingBox) -> boolean` |  |
| `WriteString` | `(value: string) -> boolean` |  |
| `WriteFileID` | `(value: string) -> boolean` |  |
| `WriteStringHash` | `(value: StringHash|string) -> boolean` |  |
| `WriteBuffer` | `(buffer: VectorBuffer) -> boolean` |  |
| `WriteResourceRef` | `(value: ResourceRef) -> boolean` |  |
| `WriteResourceRefList` | `(value: ResourceRefList) -> boolean` |  |
| `WriteVariant` | `(value: Variant) -> boolean` |  |
| `WriteVariantData` | `(value: Variant) -> boolean` |  |
| `WriteVariantVector` | `(value: VariantVector) -> boolean` |  |
| `WriteVariantMap` | `(value: VariantMap) -> boolean` |  |
| `WriteVLE` | `(value: integer) -> boolean` |  |
| `WriteNetID` | `(value: integer) -> boolean` |  |
| `WriteLine` | `(value: string) -> boolean` |  |


### FileSelectorEntry

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | string |  |
| `directory` | boolean |  |


### FileSelector  `: Object`

**构造**

```lua
fun(): FileSelector
```

**属性（16）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `defaultStyle` | XMLFile |  |
| `window` | Window |  |
| `titleText` | Text |  |
| `fileList` | ListView |  |
| `pathEdit` | LineEdit |  |
| `fileNameEdit` | LineEdit |  |
| `filterList` | DropDownList |  |
| `okButton` | Button |  |
| `cancelButton` | Button |  |
| `closeButton` | Button |  |
| `title` | string |  |
| `path` | string |  |
| `fileName` | string |  |
| `filter` | string |  |
| `filterIndex` | integer |  |
| `directoryMode` | boolean |  |

**方法（24）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetDefaultStyle` | `(style: XMLFile)` |  |
| `SetTitle` | `(text: string)` |  |
| `SetButtonTexts` | `(okText: string, cancelText: string)` |  |
| `SetPath` | `(path: string)` |  |
| `SetFileName` | `(fileName: string)` |  |
| `SetFilters` | `(filters: string[], defaultIndex: integer)` |  |
| `SetDirectoryMode` | `(enable: boolean)` |  |
| `UpdateElements` | `()` |  |
| `GetDefaultStyle` | `() -> XMLFile` |  |
| `GetWindow` | `() -> Window` |  |
| `GetTitleText` | `() -> Text` |  |
| `GetFileList` | `() -> ListView` |  |
| `GetPathEdit` | `() -> LineEdit` |  |
| `GetFileNameEdit` | `() -> LineEdit` |  |
| `GetFilterList` | `() -> DropDownList` |  |
| `GetOKButton` | `() -> Button` |  |
| `GetCancelButton` | `() -> Button` |  |
| `GetCloseButton` | `() -> Button` |  |
| `GetTitle` | `() -> string` |  |
| `GetPath` | `() -> string` |  |
| `GetFileName` | `() -> string` |  |
| `GetFilter` | `() -> string` |  |
| `GetFilterIndex` | `() -> integer` |  |
| `GetDirectoryMode` | `() -> boolean` |  |


### FileSystem  `: Object`

**方法（25）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetCurrentDir` | `(pathName: string) -> boolean` |  |
| `CreateDir` | `(pathName: string) -> boolean` |  |
| `SetExecuteConsoleCommands` | `(enable: boolean)` |  |
| `SystemCommand` | `(commandLine: string, redirectStdOutToLog?: boolean) -> integer` |  |
| `SystemRun` | `(fileName: string, arguments: string[]) -> integer` |  |
| `SystemCommandAsync` | `(commandLine: string) -> integer` |  |
| `SystemRunAsync` | `(fileName: string, arguments: string[]) -> integer` |  |
| `SystemOpen` | `(fileName: string, mode?: string) -> boolean` |  |
| `Copy` | `(srcFileName: string, destFileName: string) -> boolean` |  |
| `Rename` | `(srcFileName: string, destFileName: string) -> boolean` |  |
| `Delete` | `(fileName: string) -> boolean` |  |
| `SetLastModifiedTime` | `(fileName: string, newTime: integer) -> boolean` |  |
| `GetCurrentDir` | `() -> string` |  |
| `GetExecuteConsoleCommands` | `() -> boolean` |  |
| `HasRegisteredPaths` | `() -> boolean` |  |
| `CheckAccess` | `(pathName: string) -> boolean` |  |
| `GetLastModifiedTime` | `(fileName: string) -> integer` |  |
| `FileExists` | `(fileName: string) -> boolean` |  |
| `DirExists` | `(pathName: string) -> boolean` |  |
| `ScanDir` | `(pathName: string, filter: string, flags: integer, recursive: boolean) -> string[]` |  |
| `GetProgramDir` | `() -> string` |  |
| `GetUserDocumentsDir` | `() -> string` |  |
| `GetAppPreferencesDir` | `(org: string, app: string) -> string` |  |
| `GetTemporaryDir` | `() -> string` |  |
| `HasPersistentFS` | `() -> boolean` |  |


### Font  `: Resource`

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `absoluteGlyphOffset` | IntVector2 |  |
| `scaledGlyphOffset` | Vector2 |  |
| `fontType` | FontType |  |

**方法（7）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetAbsoluteGlyphOffset` | `(offset: IntVector2)` |  |
| `SetScaledGlyphOffset` | `(offset: Vector2)` |  |
| `GetAbsoluteGlyphOffset` | `() -> IntVector2` |  |
| `GetScaledGlyphOffset` | `() -> Vector2` |  |
| `GetTotalGlyphOffset` | `(pointSize: number) -> IntVector2` |  |
| `GetFontType` | `() -> FontType` |  |
| `IsSDFFont` | `() -> boolean` |  |


### FontManager  `: Object`


### Frustum

**构造**

```lua
fun(frustum: Frustum): Frustum
fun(): Frustum
fun(self: Frustum, frustum: Frustum): Frustum
fun(frustum: Frustum): Frustum
```

**方法（10）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Define` | `(fov: number, aspectRatio: number, zoom: number, nearZ: number, farZ: number, transform?: Matrix3x4)` |  |
| `DefineOrtho` | `(orthoSize: number, aspectRatio: number, zoom: number, nearZ: number, farZ: number, transform?: Matrix3x4)` |  |
| `DefineSplit` | `(projection: Matrix4, near: number, far: number)` |  |
| `Transform` | `(transform: Matrix3)` |  |
| `IsInside` | `(point: Vector3) -> Intersection` |  |
| `IsInsideFast` | `(sphere: Sphere) -> Intersection` |  |
| `Distance` | `(point: Vector3) -> number` |  |
| `Transformed` | `(transform: Matrix3) -> Frustum` |  |
| `Projected` | `(transform: Matrix4) -> Rect` |  |
| `UpdatePlanes` | `()` |  |


### Geometry  `: Object`

**构造**

```lua
fun(): Geometry
```

**属性（9）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `numVertexBuffers` | integer |  |
| `indexBuffer` | IndexBuffer |  |
| `primitiveType` | PrimitiveType |  |
| `indexStart` | integer |  |
| `indexCount` | integer |  |
| `vertexStart` | integer |  |
| `vertexCount` | integer |  |
| `lodDistance` | number |  |
| `empty` | boolean |  |

**方法（15）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetNumVertexBuffers` | `(num: integer) -> boolean` |  |
| `SetVertexBuffer` | `(index: integer, buffer: VertexBuffer) -> boolean` |  |
| `SetIndexBuffer` | `(buffer: IndexBuffer)` |  |
| `SetDrawRange` | `(type: PrimitiveType, indexStart: integer, indexCount: integer, getUsedVertexRange?: boolean) -> boolean` |  |
| `SetLodDistance` | `(distance: number)` |  |
| `GetNumVertexBuffers` | `() -> integer` |  |
| `GetVertexBuffer` | `(index: integer) -> VertexBuffer` |  |
| `GetIndexBuffer` | `() -> IndexBuffer` |  |
| `GetPrimitiveType` | `() -> PrimitiveType` |  |
| `GetIndexStart` | `() -> integer` |  |
| `GetIndexCount` | `() -> integer` |  |
| `GetVertexStart` | `() -> integer` |  |
| `GetVertexCount` | `() -> integer` |  |
| `GetLodDistance` | `() -> number` |  |
| `IsEmpty` | `() -> boolean` |  |


### Graphics  `: Object`

**属性（37）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `initialized` | boolean |  |
| `windowTitle` | string |  |
| `apiName` | string |  |
| `windowPosition` | IntVector2 |  |
| `width` | integer |  |
| `height` | integer |  |
| `multiSample` | integer |  |
| `size` | IntVector2 |  |
| `fullscreen` | boolean |  |
| `resizable` | boolean |  |
| `borderless` | boolean |  |
| `vSync` | boolean |  |
| `refreshRate` | integer |  |
| `monitor` | integer |  |
| `tripleBuffer` | boolean |  |
| `sRGB` | boolean |  |
| `dither` | boolean |  |
| `flushGPU` | boolean |  |
| `orientations` | string Read-only. Use common.setDeviceOrientation({ value = "portrait"|"landscape" }). |  |
| `deviceLost` | boolean |  |
| `numPrimitives` | integer |  |
| `numBatches` | integer |  |
| `dummyColorFormat` | integer |  |
| `shadowMapFormat` | integer |  |
| `hiresShadowMapFormat` | integer |  |
| `instancingSupport` | boolean |  |
| `deferredSupport` | boolean |  |
| `hardwareShadowSupport` | boolean |  |
| `readableDepthSupport` | boolean |  |
| `sRGBSupport` | boolean |  |
| `sRGBWriteSupport` | boolean |  |
| `monitorCount` | integer |  |
| `shaderCacheDir` | string |  |
| `transparent` | boolean |  |
| `clickThrough` | boolean |  |
| `topmost` | boolean |  |
| `compositionBacked` | boolean |  |

**方法（87）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetComputeShaderSupport` | `() -> boolean` | Return whether the current graphics backend supports compute shaders. |
| `SetWindowTitle` | `(windowTitle: string)` |  |
| `SetWindowIcon` | `(windowIcon: Image)` |  |
| `SetWindowPosition` | `(position: IntVector2)` |  |
| `SetMode` | `(width: integer, height: integer, fullscreen: boolean, borderless: boolean, resizable: boolean, highDPI: boolean, vsync: boolean, tripleBuffer: boolean, multiSample: integer, monitor: integer, refreshRate: integer) -> boolean` |  |
| `SetTransparent` | `(enable: boolean)` |  |
| `SetClickThrough` | `(enable: boolean)` |  |
| `SetTopmost` | `(enable: boolean)` |  |
| `SetSRGB` | `(enable: boolean)` |  |
| `SetDither` | `(enable: boolean)` |  |
| `SetFlushGPU` | `(enable: boolean)` |  |
| `SetOrientations` | `(orientations: string)` | Disabled. Use common.setDeviceOrientation({ value = "portrait"\|"lands ⚠️废弃 |
| `ToggleFullscreen` | `() -> boolean` |  |
| `Maximize` | `()` |  |
| `Minimize` | `()` |  |
| `Raise` | `()` |  |
| `Close` | `()` |  |
| `TakeScreenShot` | `(destImage: Image) -> boolean` |  |
| `BeginDumpShaders` | `(fileName: string)` |  |
| `EndDumpShaders` | `()` |  |
| `PrecacheShaders` | `(source: Deserializer)` |  |
| `SetShaderCacheDir` | `(path: string)` |  |
| `ClearShaderCache` | `() -> boolean` |  |
| `IsInitialized` | `() -> boolean` |  |
| `GetExternalWindow` | `() -> any` |  |
| `GetWindowTitle` | `() -> string` |  |
| `GetApiName` | `() -> string` |  |
| `GetWindowPosition` | `() -> IntVector2` |  |
| `GetWidth` | `() -> integer` |  |
| `GetHeight` | `() -> integer` |  |
| `GetDPR` | `() -> number` |  |
| `GetMultiSample` | `() -> integer` |  |
| `GetSize` | `() -> IntVector2` |  |
| `GetFullscreen` | `() -> boolean` |  |
| `GetResizable` | `() -> boolean` |  |
| `GetBorderless` | `() -> boolean` |  |
| `IsTransparent` | `() -> boolean` |  |
| `IsClickThrough` | `() -> boolean` |  |
| `IsTopmost` | `() -> boolean` |  |
| `IsCompositionBacked` | `() -> boolean` |  |
| `SetVSync` | `(enable: boolean)` |  |
| `GetVSync` | `() -> boolean` |  |
| `GetMonitor` | `() -> integer` |  |
| `GetRefreshRate` | `() -> integer` |  |
| `GetTripleBuffer` | `() -> boolean` |  |
| `GetSRGB` | `() -> boolean` |  |
| `GetDither` | `() -> boolean` |  |
| `GetFlushGPU` | `() -> boolean` |  |
| `GetOrientations` | `() -> string` |  |
| `IsDeviceLost` | `() -> boolean` |  |
| `GetNumPrimitives` | `() -> integer` |  |
| `GetNumBatches` | `() -> integer` |  |
| `GetDummyColorFormat` | `() -> integer` |  |
| `GetShadowMapFormat` | `() -> integer` |  |
| `GetHiresShadowMapFormat` | `() -> integer` |  |
| `GetInstancingSupport` | `() -> boolean` |  |
| `GetDeferredSupport` | `() -> boolean` |  |
| `GetHardwareShadowSupport` | `() -> boolean` |  |
| `GetReadableDepthSupport` | `() -> boolean` |  |
| `GetSRGBSupport` | `() -> boolean` |  |
| `GetSRGBWriteSupport` | `() -> boolean` |  |
| `SetProfilerEnabled` | `(profilerEnabled: boolean)` | Enable optional per-view GPU timestamps and names in profiling builds. |
| `GetGpuTimingStatsString` | `() -> string` | Return the latest GPU frame and optional per-view timestamp report, in |
| `GetDesktopResolution` | `(monitor: integer) -> IntVector2` |  |
| `GetMonitorCount` | `() -> integer` |  |
| `GetShaderCacheDir` | `() -> string` |  |
| `GetCurrentMonitor` | `() -> integer` |  |
| `GetMaximized` | `() -> boolean` |  |
| `GetDisplayDPI` | `(monitor?: integer) -> Vector3` |  |
| `GetAlphaFormat` | `() -> integer` |  |
| `GetLuminanceFormat` | `() -> integer` |  |
| `GetLuminanceAlphaFormat` | `() -> integer` |  |
| `GetRGBFormat` | `() -> integer` |  |
| `GetRGBAFormat` | `() -> integer` |  |
| `GetRGBA16Format` | `() -> integer` |  |
| `GetRGBAFloat16Format` | `() -> integer` |  |
| `GetRGBAFloat32Format` | `() -> integer` |  |
| `GetRG16Format` | `() -> integer` |  |
| `GetRGFloat16Format` | `() -> integer` |  |
| `GetRGFloat32Format` | `() -> integer` |  |
| `GetFloat16Format` | `() -> integer` |  |
| `GetFloat32Format` | `() -> integer` |  |
| `GetLinearDepthFormat` | `() -> integer` |  |
| `GetDepthStencilFormat` | `() -> integer` |  |
| `GetReadableDepthFormat` | `() -> integer` |  |
| `GetFormat` | `(formatName: string) -> integer` |  |
| `GetMaxBones` | `() -> integer` |  |


### VertexElement

**构造**

```lua
fun(type: VertexElementType, semantic: VertexElementSemantic, index?: number, perInstance?: boolean): VertexElement
fun(): VertexElement
fun(self: VertexElement, type: VertexElementType, semantic: VertexElementSemantic, index?: number, perInstance?: boolean): VertexElement
fun(type: VertexElementType, semantic: VertexElementSemantic, index?: number, perInstance?: boolean): VertexElement
```

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `type` | VertexElementType |  |
| `semantic` | VertexElementSemantic |  |
| `index` | number -- unsigned char |  |
| `perInstance` | boolean |  |
| `offset` | integer |  |


### HttpClient  `: RefCounted`

**方法（13）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetUrl` | `(url: string) -> HttpClient` |  |
| `SetMethod` | `(method: HttpMethod) -> HttpClient` |  |
| `AddQuery` | `(key: string, value: string) -> HttpClient` |  |
| `AddHeader` | `(key: string, value: string) -> HttpClient` |  |
| `SetBody` | `(data: string) -> HttpClient` |  |
| `SetContentType` | `(contentType: string) -> HttpClient` |  |
| `SetTimeout` | `(msecs: integer) -> HttpClient` |  |
| `OnSuccess` | `(callback: fun(client: HttpClient, response: HttpResponse)) -> HttpClient` |  |
| `OnError` | `(callback: fun(client: HttpClient, statusCode: integer, error: string)) -> HttpClient` |  |
| `OnProgress` | `(callback: fun(client: HttpClient, downloaded: integer, total: integer)) -> HttpClient` |  |
| `Send` | `()` |  |
| `Cancel` | `()` |  |
| `GetContext` | `() -> Context` |  |


### HttpManager  `: Object`

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `activeRequestCount` | integer |  |

**方法（3）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Create` | `() -> HttpClient` |  |
| `CancelAllRequests` | `()` | 取消所有进行中的请求 |
| `GetActiveRequestCount` | `() -> integer` | 获取当前活动的请求数量 |


### HttpRequest  `: RefCounted`

**属性（6）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `URL` | string |  |
| `verb` | string |  |
| `error` | string |  |
| `state` | HttpRequestState |  |
| `availableSize` | integer |  |
| `open` | boolean |  |

**方法（44）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetURL` | `() -> string` |  |
| `GetVerb` | `() -> string` |  |
| `GetError` | `() -> string` |  |
| `GetState` | `() -> HttpRequestState` |  |
| `GetAvailableSize` | `() -> integer` |  |
| `IsOpen` | `() -> boolean` |  |
| `Read` | `(size: integer) -> VectorBuffer` |  |
| `IsEof` | `() -> boolean` |  |
| `ReadInt` | `() -> integer` |  |
| `ReadShort` | `() -> integer` |  |
| `ReadByte` | `() -> integer` |  |
| `ReadUInt` | `() -> integer` |  |
| `ReadUShort` | `() -> integer` |  |
| `ReadUByte` | `() -> number` |  |
| `ReadBool` | `() -> boolean` |  |
| `ReadFloat` | `() -> number` |  |
| `ReadDouble` | `() -> number` |  |
| `ReadIntRect` | `() -> IntRect` |  |
| `ReadIntVector2` | `() -> IntVector2` |  |
| `ReadIntVector3` | `() -> IntVector3` |  |
| `ReadRect` | `() -> Rect` |  |
| `ReadVector2` | `() -> Vector2` |  |
| `ReadVector3` | `() -> Vector3` |  |
| `ReadPackedVector3` | `(maxAbsCoord: number) -> Vector3` |  |
| `ReadVector4` | `() -> Vector4` |  |
| `ReadQuaternion` | `() -> Quaternion` |  |
| `ReadPackedQuaternion` | `() -> Quaternion` |  |
| `ReadMatrix3` | `() -> Matrix3` |  |
| `ReadMatrix3x4` | `() -> Matrix3x4` |  |
| `ReadMatrix4` | `() -> Matrix4` |  |
| `ReadColor` | `() -> Color` |  |
| `ReadBoundingBox` | `() -> BoundingBox` |  |
| `ReadString` | `() -> string` |  |
| `ReadFileID` | `() -> string` |  |
| `ReadStringHash` | `() -> StringHash|string` |  |
| `ReadBuffer` | `() -> VectorBuffer` |  |
| `ReadResourceRef` | `() -> ResourceRef` |  |
| `ReadResourceRefList` | `() -> ResourceRefList` |  |
| `ReadVariant` | `(type: VariantType) -> Variant` |  |
| `ReadVariantVector` | `() -> VariantVector` |  |
| `ReadVariantMap` | `() -> VariantMap` |  |
| `ReadVLE` | `() -> integer` |  |
| `ReadNetID` | `() -> integer` |  |
| `ReadLine` | `() -> string` |  |


### HttpResponse

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `statusCode` | integer 状态码 (等同于 GetStatusCode()) |  |
| `statusText` | string 状态文本 (等同于 GetStatusText()) |  |
| `success` | boolean 是否成功 (等同于 IsSuccess()) |  |
| `dataAsString` | string 响应数据字符串 (等同于 GetDataAsString()) |  |
| `downloadedBytes` | integer 已下载字节数 (等同于 GetDownloadedBytes()) |  |
| `totalBytes` | integer 总字节数 (等同于 GetTotalBytes()) |  |
| `progress` | number 进度 0.0-1.0 (等同于 GetProgress()) |  |

**方法（8）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetStatusCode` | `() -> integer` | 获取状态码 |
| `GetStatusText` | `() -> string` | 获取状态文本 |
| `IsSuccess` | `() -> boolean` | 判断请求是否成功（2xx） |
| `GetDataAsString` | `() -> string` | 获取响应数据（字符串形式） |
| `GetHeader` | `(name: string) -> string` | 获取指定响应头 |
| `GetDownloadedBytes` | `() -> integer` | 获取已下载字节数 |
| `GetTotalBytes` | `() -> integer` | 获取总字节数 |
| `GetProgress` | `() -> number` | 获取进度（0.0 - 1.0） |


### IKConstraint  `: Component`

**方法（6）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetStiffness` | `() -> number` |  |
| `SetStiffness` | `(stiffness: number)` |  |
| `GetStretchiness` | `() -> number` |  |
| `SetStretchiness` | `(stretchiness: number)` |  |
| `GetLengthConstraints` | `() -> Vector2` |  |
| `SetLengthConstraints` | `(lengthConstraints: Vector2)` |  |


### IKEffector  `: Component`

**属性（10）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `targetNode` | Node |  |
| `targetName` | string |  |
| `targetPosition` | Vector3 |  |
| `targetRotation` | Quaternion |  |
| `chainLength` | integer |  |
| `weight` | number |  |
| `rotationWeight` | number |  |
| `rotationDecay` | number |  |
| `WEIGHT_NLERP` | boolean |  |
| `INHERIT_PARENT_ROTATION` | boolean |  |

**方法（16）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetTargetNode` | `() -> Node` |  |
| `SetTargetNode` | `(targetNode: Node)` |  |
| `GetTargetName` | `() -> string` |  |
| `SetTargetName` | `(nodeName: string)` |  |
| `GetTargetPosition` | `() -> Vector3` |  |
| `SetTargetPosition` | `(targetPosition: Vector3)` |  |
| `GetTargetRotation` | `() -> Quaternion` |  |
| `SetTargetRotation` | `(targetRotation: Quaternion)` |  |
| `GetChainLength` | `() -> integer` |  |
| `SetChainLength` | `(chainLength: integer)` |  |
| `GetWeight` | `() -> number` |  |
| `SetWeight` | `(weight: number)` |  |
| `GetRotationWeight` | `() -> number` |  |
| `SetRotationWeight` | `(weight: number)` |  |
| `GetRotationDecay` | `() -> number` |  |
| `SetRotationDecay` | `(decay: number)` |  |


### IKSolver  `: Component`

**属性（13）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `algorithm` | Algorithm |  |
| `maximumIterations` | integer |  |
| `tolerance` | number |  |
| `JOINT_ROTATIONS` | boolean |  |
| `TARGET_ROTATIONS` | boolean |  |
| `UPDATE_ORIGINAL_POSE` | boolean |  |
| `UPDATE_ACTIVE_POSE` | boolean |  |
| `USE_ORIGINAL_POSE` | boolean |  |
| `CONSTRAINTS` | boolean |  |
| `AUTO_SOLVE` | boolean |  |
| `ONE_BONE` | integer | Algorithm enum value (static) |
| `TWO_BONE` | integer | Algorithm enum value (static) |
| `FABRIK` | integer | Algorithm enum value (static) |

**方法（10）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `RebuildChainTrees` | `()` |  |
| `RecalculateSegmentLengths` | `()` |  |
| `CalculateJointRotations` | `()` |  |
| `Solve` | `()` |  |
| `ApplyOriginalPoseToScene` | `()` |  |
| `ApplySceneToOriginalPose` | `()` |  |
| `ApplyActivePoseToScene` | `()` |  |
| `ApplySceneToActivePose` | `()` |  |
| `ApplyOriginalPoseToActivePose` | `()` |  |
| `DrawDebugGeometry` | `(depthTest: boolean)` |  |


### Image  `: Resource`

**构造**

```lua
fun(): Image
```

**属性（10）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `width` | integer |  |
| `height` | integer |  |
| `depth` | integer |  |
| `components` | integer |  |
| `compressed` | boolean |  |
| `compressedFormat` | CompressedFormat |  |
| `numCompressedLevels` | integer |  |
| `cubemap` | boolean |  |
| `array` | boolean |  |
| `sRGB` | boolean |  |

**方法（32）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetSize` | `(width: integer, height: integer, components: integer) -> boolean` |  |
| `SetPixel` | `(x: integer, y: integer, color: Color)` |  |
| `SetPixelInt` | `(x: integer, y: integer, uintColor: integer)` |  |
| `LoadColorLUT` | `(source: Deserializer) -> boolean` |  |
| `FlipHorizontal` | `() -> boolean` |  |
| `FlipVertical` | `() -> boolean` |  |
| `Resize` | `(width: integer, height: integer) -> boolean` |  |
| `Clear` | `(color: Color)` |  |
| `ClearInt` | `(uintColor: integer)` |  |
| `SaveBMP` | `(fileName: string) -> boolean` |  |
| `SavePNG` | `(fileName: string) -> boolean` |  |
| `SaveTGA` | `(fileName: string) -> boolean` |  |
| `SaveJPG` | `(fileName: string, quality: integer) -> boolean` |  |
| `SaveDDS` | `(fileName: string) -> boolean` |  |
| `SaveWEBP` | `(fileName: string, compression?: number) -> boolean` |  |
| `GetPixel` | `(x: integer, y: integer) -> Color` |  |
| `GetPixelInt` | `(x: integer, y: integer) -> integer` |  |
| `GetPixelBilinear` | `(x: number, y: number) -> Color` |  |
| `GetPixelTrilinear` | `(x: number, y: number, z: number) -> Color` |  |
| `GetWidth` | `() -> integer` |  |
| `GetHeight` | `() -> integer` |  |
| `GetDepth` | `() -> integer` |  |
| `GetComponents` | `() -> integer` |  |
| `IsCompressed` | `() -> boolean` |  |
| `GetCompressedFormat` | `() -> CompressedFormat` |  |
| `GetNumCompressedLevels` | `() -> integer` |  |
| `GetSubimage` | `(rect: IntRect) -> Image` |  |
| `SetSubimage` | `(image: Image, rect: IntRect) -> boolean` |  |
| `IsCubemap` | `() -> boolean` |  |
| `IsArray` | `() -> boolean` |  |
| `IsSRGB` | `() -> boolean` |  |
| `HasAlphaChannel` | `() -> boolean` |  |


### IndexBuffer  `: Object`

**构造**

```lua
fun(): IndexBuffer
```

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `shadowed` | boolean |  |
| `dynamic` | boolean |  |
| `indexCount` | integer |  |
| `indexSize` | integer |  |

**方法（9）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetShadowed` | `(enable: boolean)` |  |
| `SetSize` | `(indexCount: integer, largeIndices: boolean, dynamic?: boolean) -> boolean` |  |
| `SetData` | `(data: VectorBuffer) -> boolean` |  |
| `SetDataRange` | `(data: VectorBuffer, start: integer, count: integer, discard?: boolean) -> boolean` |  |
| `GetData` | `() -> VectorBuffer` |  |
| `IsShadowed` | `() -> boolean` |  |
| `IsDynamic` | `() -> boolean` |  |
| `GetIndexCount` | `() -> integer` |  |
| `GetIndexSize` | `() -> integer` |  |


### TouchState

**属性（6）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `touchID` | integer |  |
| `position` | IntVector2 |  |
| `lastPosition` | IntVector2 |  |
| `delta` | IntVector2 |  |
| `pressure` | number |  |
| `touchedElement` | UIElement |  |

**方法（1）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetTouchedElement` | `() -> UIElement` |  |


### JoystickState

**属性（6）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | string |  |
| `joystickID` | integer |  |
| `controller` | boolean |  |
| `numButtons` | integer |  |
| `numAxes` | integer |  |
| `numHats` | integer |  |

**方法（8）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `IsController` | `() -> boolean` |  |
| `GetNumButtons` | `() -> integer` |  |
| `GetNumAxes` | `() -> integer` |  |
| `GetNumHats` | `() -> integer` |  |
| `GetButtonDown` | `(index: integer) -> boolean` |  |
| `GetButtonPress` | `(index: integer) -> boolean` |  |
| `GetAxisPosition` | `(index: integer) -> number` |  |
| `GetHatPosition` | `(index: integer) -> integer` |  |


### Input  `: Object`

**属性（19）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `qualifiers` | integer |  |
| `mousePosition` | IntVector2 |  |
| `mouseMove` | IntVector2 |  |
| `mouseMoveX` | integer |  |
| `mouseMoveY` | integer |  |
| `mouseMoveWheel` | integer |  |
| `inputScale` | Vector2 |  |
| `numTouches` | integer |  |
| `numJoysticks` | integer |  |
| `toggleFullscreen` | boolean |  |
| `screenKeyboardSupport` | boolean |  |
| `mouseMode` | MouseMode |  |
| `screenKeyboardVisible` | boolean |  |
| `touchEmulation` | boolean |  |
| `mouseVisible` | boolean |  |
| `mouseGrabbed` | boolean |  |
| `mouseLocked` | boolean |  |
| `focus` | boolean |  |
| `minimized` | boolean |  |

**方法（65）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetToggleFullscreen` | `(enable: boolean)` |  |
| `SetMouseVisible` | `(enable: boolean, suppressEvent?: boolean)` |  |
| `ResetMouseVisible` | `()` |  |
| `SetMouseGrabbed` | `(grab: boolean, suppressEvent?: boolean)` |  |
| `ResetMouseGrabbed` | `()` |  |
| `SetMouseMode` | `(mode: MouseMode, suppressEvent?: boolean)` |  |
| `ResetMouseMode` | `()` |  |
| `IsMouseLocked` | `() -> boolean` |  |
| `AddScreenJoystick` | `(layoutFile?: XMLFile, styleFile?: XMLFile) -> integer` |  |
| `RemoveScreenJoystick` | `(id: integer) -> boolean` |  |
| `SetScreenJoystickVisible` | `(id: integer, enable: boolean)` |  |
| `SetScreenKeyboardVisible` | `(enable: boolean)` |  |
| `SetTouchEmulation` | `(enable: boolean)` |  |
| `EnableAccelerometer` | `()` |  |
| `DisableAccelerometer` | `()` |  |
| `IsAccelerometerEnabled` | `() -> boolean` |  |
| `RecordGesture` | `() -> boolean` |  |
| `SaveGestures` | `(dest: File) -> boolean` |  |
| `SaveGesture` | `(dest: File, gestureID: integer) -> boolean` |  |
| `LoadGestures` | `(source: File) -> integer` |  |
| `RemoveGesture` | `(gestureID: integer) -> boolean` |  |
| `RemoveAllGestures` | `()` |  |
| `SetMousePosition` | `(position: IntVector2)` |  |
| `CenterMousePosition` | `()` |  |
| `GetKeyFromName` | `(name: string) -> Key` |  |
| `GetKeyFromScancode` | `(scancode: Scancode) -> Key` |  |
| `GetKeyName` | `(key: Key) -> string` |  |
| `GetScancodeFromKey` | `(key: Key) -> Scancode` |  |
| `GetScancodeFromName` | `(name: string) -> Scancode` |  |
| `GetScancodeName` | `(scancode: Scancode) -> string` |  |
| `GetKeyDown` | `(key: Key) -> boolean` |  |
| `GetKeyPress` | `(key: Key) -> boolean` |  |
| `GetKeyRelease` | `(key: Key) -> boolean` |  |
| `GetScancodeDown` | `(scancode: Scancode) -> boolean` |  |
| `GetScancodePress` | `(scancode: Scancode) -> boolean` |  |
| `GetScancodeRelease` | `(scancode: Scancode) -> boolean` |  |
| `GetMouseButtonDown` | `(button: MouseButton) -> boolean` |  |
| `GetMouseButtonPress` | `(button: MouseButton) -> boolean` |  |
| `GetMouseButtonRelease` | `(button: MouseButton) -> boolean` |  |
| `GetQualifierDown` | `(qualifier: Qualifier) -> boolean` |  |
| `GetQualifierPress` | `(qualifier: Qualifier) -> boolean` |  |
| `GetQualifierRelease` | `(qualifier: Qualifier) -> boolean` |  |
| `GetQualifiers` | `() -> integer` |  |
| `GetMousePosition` | `() -> IntVector2` |  |
| `GetMouseMove` | `() -> IntVector2` |  |
| `GetMouseMoveX` | `() -> integer` |  |
| `GetMouseMoveY` | `() -> integer` |  |
| `GetMouseMoveWheel` | `() -> integer` |  |
| `GetInputScale` | `() -> Vector2` |  |
| `GetNumTouches` | `() -> integer` |  |
| `GetTouch` | `(index: integer) -> TouchState` |  |
| `GetNumJoysticks` | `() -> integer` |  |
| `GetJoystick` | `(id: integer) -> JoystickState` |  |
| `GetJoystickByIndex` | `(index: integer) -> JoystickState` |  |
| `GetJoystickByName` | `(name: string) -> JoystickState` |  |
| `GetToggleFullscreen` | `() -> boolean` |  |
| `GetScreenKeyboardSupport` | `() -> boolean` |  |
| `IsScreenJoystickVisible` | `(id: integer) -> boolean` |  |
| `IsScreenKeyboardVisible` | `() -> boolean` |  |
| `GetTouchEmulation` | `() -> boolean` |  |
| `IsMouseVisible` | `() -> boolean` |  |
| `IsMouseGrabbed` | `() -> boolean` |  |
| `GetMouseMode` | `() -> MouseMode` |  |
| `HasFocus` | `() -> boolean` |  |
| `IsMinimized` | `() -> boolean` |  |


### JSONFile  `: Resource`

**构造**

```lua
fun(): JSONFile
```

**方法（4）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `FromString` | `(source: string) -> boolean` |  |
| `ToString` | `(indendation?: string) -> string` |  |
| `GetRoot` | `() -> JSONValue` |  |
| `Save` | `(fileName: string, indentation?: string) -> boolean` |  |


### JSONObject


### JSONArray


### JSONValue

**构造**

```lua
fun(value: boolean): JSONValue
fun(value: string): JSONValue
fun(value: number): JSONValue
fun(value: JSONArray): JSONValue
fun(value: JSONObject): JSONValue
fun(value: JSONValue): JSONValue
fun(): JSONValue
fun(self: JSONValue, value: boolean): JSONValue
```

**属性（8）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `EMPTY` | JSONValue |  |
| `emptyArray` | JSONArray |  |
| `emptyObject` | JSONObject |  |
| `null` | boolean |  |
| `valueType` | JSONValueType |  |
| `numberType` | JSONNumberType |  |
| `valueTypeName` | string |  |
| `numberTypeName` | string |  |

**方法（40）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetBool` | `(value: boolean)` |  |
| `SetInt` | `(value: integer)` |  |
| `SetUint` | `(value: integer)` |  |
| `SetFloat` | `(value: number)` |  |
| `SetDouble` | `(value: number)` |  |
| `SetString` | `(value: string)` |  |
| `SetArray` | `(value: JSONArray)` |  |
| `SetObject` | `(value: JSONObject)` |  |
| `SetVariant` | `(value: Variant)` |  |
| `SetVariantMap` | `(value: VariantMap)` |  |
| `GetValueType` | `() -> JSONValueType` |  |
| `GetNumberType` | `() -> JSONNumberType` |  |
| `GetValueTypeName` | `() -> string` |  |
| `GetNumberTypeName` | `() -> string` |  |
| `IsNull` | `() -> boolean` |  |
| `IsBool` | `() -> boolean` |  |
| `IsNumber` | `() -> boolean` |  |
| `IsString` | `() -> boolean` |  |
| `IsArray` | `() -> boolean` |  |
| `IsObject` | `() -> boolean` |  |
| `GetBool` | `() -> boolean` |  |
| `GetInt` | `() -> integer` |  |
| `GetUInt` | `() -> integer` |  |
| `GetFloat` | `() -> number` |  |
| `GetDouble` | `() -> number` |  |
| `GetString` | `() -> string` |  |
| `GetArray` | `() -> JSONArray` |  |
| `GetObject` | `() -> JSONObject` |  |
| `GetVariant` | `() -> Variant` |  |
| `GetVariantMap` | `() -> VariantMap` |  |
| `Push` | `(value: JSONValue)` |  |
| `Pop` | `()` |  |
| `Insert` | `(pos: integer, value: JSONValue)` |  |
| `Erase` | `(pos: integer, length?: integer)` |  |
| `Resize` | `(newSize: integer)` |  |
| `Size` | `() -> integer` |  |
| `Set` | `(key: string, value: JSONValue)` |  |
| `Get` | `(key: string) -> JSONValue` |  |
| `Contains` | `(key: string) -> boolean` |  |
| `Clear` | `()` |  |


### KinematicCharacterController  `: Component`

**构造**

```lua
fun(): KinematicCharacterController
```

**属性（12）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `collisionLayer` | integer |  |
| `collisionMask` | integer |  |
| `gravityFactor` | number |  |
| `stepHeight` | number |  |
| `maxJumpHeight` | number |  |
| `jumpSpeed` | number |  |
| `fallSpeed` | number |  |
| `maxSlope` | number |  |
| `linearDamping` | number |  |
| `angularDamping` | number |  |
| `gravity` | Vector3 |  |
| `physicsWorld` | PhysicsWorld |  |

**方法（30）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetCollisionLayer` | `(layer: integer)` |  |
| `SetCollisionMask` | `(mask: integer)` |  |
| `SetCollisionLayerAndMask` | `(layer: integer, mask: integer)` |  |
| `SetGravity` | `(gravity: Vector3)` |  |
| `SetGravityFactor` | `(factor: number)` |  |
| `GetGravityFactor` | `() -> number` |  |
| `SetLinearDamping` | `(damping: number)` |  |
| `GetLinearDamping` | `() -> number` |  |
| `SetAngularDamping` | `(angularDamping: number)` |  |
| `GetAngularDamping` | `() -> number` |  |
| `SetStepHeight` | `(stepHeight: number)` |  |
| `GetStepHeight` | `() -> number` |  |
| `SetMaxJumpHeight` | `(maxJumpHeight: number)` |  |
| `GetMaxJumpHeight` | `() -> number` |  |
| `SetFallSpeed` | `(fallSpeed: number)` |  |
| `GetFallSpeed` | `() -> number` |  |
| `SetJumpSpeed` | `(jumpSpeed: number)` |  |
| `GetJumpSpeed` | `() -> number` |  |
| `SetMaxSlope` | `(maxSlope: number)` |  |
| `GetMaxSlope` | `() -> number` |  |
| `SetWalkDirection` | `(walkDir: Vector3)` |  |
| `OnGround` | `() -> boolean` |  |
| `Jump` | `(jump?: Vector3)` |  |
| `ApplyImpulse` | `(impulse: Vector3)` |  |
| `CanJump` | `() -> boolean` |  |
| `SetAngularVelocity` | `(velocity: Vector3)` |  |
| `GetAngularVelocity` | `() -> Vector3` |  |
| `SetLinearVelocity` | `(velocity: Vector3)` |  |
| `GetLinearVelocity` | `() -> Vector3` |  |
| `Warp` | `(position: Vector3)` |  |


### BiasParameters

**构造**

```lua
fun(constantBias: number, slopeScaledBias: number, normalOffset?: number): BiasParameters
fun(): BiasParameters
fun(self: BiasParameters, constantBias: number, slopeScaledBias: number, normalOffset?: number): BiasParameters
fun(constantBias: number, slopeScaledBias: number, normalOffset?: number): BiasParameters
```

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `constantBias` | number |  |
| `slopeScaledBias` | number |  |
| `normalOffset` | number |  |


### CascadeParameters

**构造**

```lua
fun(split1: number, split2: number, split3: number, split4: number, fadeStart: number, biasAutoAdjust?: number): CascadeParameters
fun(): CascadeParameters
fun(self: CascadeParameters, split1: number, split2: number, split3: number, split4: number, fadeStart: number, biasAutoAdjust?: number): CascadeParameters
fun(split1: number, split2: number, split3: number, split4: number, fadeStart: number, biasAutoAdjust?: number): CascadeParameters
```

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `fadeStart` | number |  |
| `biasAutoAdjust` | number |  |


### FocusParameters

**构造**

```lua
fun(focus: boolean, nonUniform: boolean, autoSize: boolean, quantize: number, minView: number): FocusParameters
fun(): FocusParameters
fun(self: FocusParameters, focus: boolean, nonUniform: boolean, autoSize: boolean, quantize: number, minView: number): FocusParameters
fun(focus: boolean, nonUniform: boolean, autoSize: boolean, quantize: number, minView: number): FocusParameters
```

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `focus` | boolean |  |
| `nonUniform` | boolean |  |
| `autoSize` | boolean |  |
| `quantize` | number |  |
| `minView` | number |  |


### Light  `: Drawable`

**属性（48）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `lightType` | LightType |  |
| `perVertex` | boolean |  |
| `color` | Color |  |
| `temperature` | number |  |
| `useTemperature` | boolean |  |
| `perPixelAtmosphereTransmittance` | boolean |  |
| `atmosphereSunDiskColorScale` | Color |  |
| `radius` | number |  |
| `softRadius` | number |  |
| `length` | number |  |
| `sourceAngle` | number |  |
| `sourceWidth` | number |  |
| `sourceHeight` | number |  |
| `barnDoorAngle` | number |  |
| `barnDoorLength` | number |  |
| `usePhysicalValues` | boolean |  |
| `specularIntensity` | number |  |
| `brightness` | number |  |
| `range` | number |  |
| `fov` | number |  |
| `aspectRatio` | number |  |
| `fadeDistance` | number |  |
| `shadowFadeDistance` | number |  |
| `shadowBias` | BiasParameters |  |
| `shadowCascade` | CascadeParameters |  |
| `temporalShadows` | boolean |  |
| `temporalShadowIntervals` | Vector4 |  |
| `temporalShadowPadding` | number |  |
| `temporalShadowBlend` | number |  |
| `temporalShadowDynamicDirty` | boolean |  |
| `affectVolumetricFog` | boolean |  |
| `volumetricFogIntensity` | number |  |
| `volumetricFogShadows` | boolean |  |
| `shadowFocus` | FocusParameters |  |
| `shadowIntensity` | number |  |
| `shadowResolution` | number |  |
| `shadowNearFarRatio` | number |  |
| `shadowMaxExtrusion` | number |  |
| `rampTexture` | Texture |  |
| `shapeTexture` | Texture |  |
| `frustum` | Frustum |  |
| `numShadowSplits` | integer |  |
| `negative` | boolean |  |
| `effectiveColor` | Color |  |
| `effectiveSpecularIntensity` | number |  |
| `punctualLight` | boolean |  |
| `innerConeAngle` | number |  |
| `outerConeAngle` | number |  |

**方法（94）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetLightType` | `(type: LightType)` |  |
| `SetPerVertex` | `(enable: boolean)` |  |
| `SetColor` | `(color: Color)` |  |
| `SetTemperature` | `(temperature: number)` |  |
| `SetUseTemperature` | `(enable: boolean)` |  |
| `SetPerPixelAtmosphereTransmittance` | `(enable: boolean)` | Enable per-pixel atmosphere sunlight for opaque deferred receivers; ot |
| `SetAtmosphereSunDiskColorScale` | `(color: Color)` | Set the linear atmosphere disk radiance multiplier, independent of sur |
| `SetRadius` | `(redius: number)` |  |
| `SetSoftRadius` | `(radius: number)` |  |
| `SetLength` | `(length: number)` |  |
| `SetSourceAngle` | `(angle: number)` | Set the directional source angular diameter in degrees [0, 20]. |
| `SetSourceWidth` | `(width: number)` |  |
| `SetSourceHeight` | `(height: number)` |  |
| `SetBarnDoorAngle` | `(angle: number)` |  |
| `SetBarnDoorLength` | `(length: number)` |  |
| `SetUsePhysicalValues` | `(enable: boolean)` |  |
| `SetSpecularIntensity` | `(intensity: number)` |  |
| `SetBrightness` | `(brightness: number)` |  |
| `SetRange` | `(range: number)` |  |
| `SetFov` | `(fov: number)` |  |
| `SetAspectRatio` | `(aspectRatio: number)` |  |
| `SetFadeDistance` | `(distance: number)` |  |
| `SetShadowFadeDistance` | `(distance: number)` |  |
| `SetShadowBias` | `(parameters: BiasParameters)` |  |
| `SetShadowCascade` | `(parameters: CascadeParameters)` |  |
| `SetTemporalShadows` | `(enable: boolean)` | Enable directional temporal shadows; unsupported views keep ordinary P |
| `GetTemporalShadows` | `() -> boolean` | Return the current temporal shadows setting. |
| `SetTemporalShadowIntervals` | `(intervals: Vector4)` | Set integer frame intervals in 1..64; the first cascade always updates |
| `GetTemporalShadowIntervals` | `() -> Vector4` | Return the current temporal shadow intervals setting. |
| `SetTemporalShadowPadding` | `(padding: number)` | Set far-cascade radius padding in 0..0.5; the default is 0.05. |
| `GetTemporalShadowPadding` | `() -> number` | Return the current temporal shadow padding setting. |
| `SetTemporalShadowBlend` | `(blend: number)` | Set total relative cascade blend width in 0..0.2; zero disables blendi |
| `GetTemporalShadowBlend` | `() -> number` | Return the current temporal shadow blend setting. |
| `SetTemporalShadowDynamicDirty` | `(enable: boolean)` | Enable budget-limited caster-change priority; disabled by default. |
| `GetTemporalShadowDynamicDirty` | `() -> boolean` | Return the current temporal shadow dynamic dirty setting. |
| `InvalidateTemporalShadows` | `()` | Force cached shadow invalidation at the next prepared view. |
| `SetAffectVolumetricFog` | `(enable: boolean)` | Set whether this light injects into volumetric fog (directional, point |
| `GetAffectVolumetricFog` | `() -> boolean` | Return whether this light injects into volumetric fog. |
| `SetVolumetricFogIntensity` | `(intensity: number)` | Set the volumetric fog in-scattering multiplier; the default is 1. |
| `GetVolumetricFogIntensity` | `() -> number` | Return the volumetric fog in-scattering multiplier. |
| `SetVolumetricFogShadows` | `(enable: boolean)` | Set whether the light's shadow map occludes its volumetric fog contrib |
| `GetVolumetricFogShadows` | `() -> boolean` | Return whether the light's shadow map occludes its volumetric fog cont |
| `SetShadowFocus` | `(parameters: FocusParameters)` |  |
| `SetShadowIntensity` | `(intensity: number)` |  |
| `SetShadowResolution` | `(resolution: number)` |  |
| `SetShadowNearFarRatio` | `(nearFarRatio: number)` |  |
| `SetShadowMaxExtrusion` | `(extrusion: number)` |  |
| `SetRampTexture` | `(texture: Texture)` |  |
| `SetShapeTexture` | `(texture: Texture)` |  |
| `GetLightType` | `() -> LightType` |  |
| `GetPerVertex` | `() -> boolean` |  |
| `GetColor` | `() -> Color` |  |
| `GetTemperature` | `() -> number` |  |
| `GetUseTemperature` | `() -> boolean` |  |
| `GetPerPixelAtmosphereTransmittance` | `() -> boolean` | Return the per-pixel atmospheric sunlight option. |
| `GetAtmosphereSunDiskColorScale` | `() -> Color` | Return the atmosphere disk radiance multiplier. |
| `GetRadius` | `() -> number` |  |
| `GetSoftRadius` | `() -> number` |  |
| `GetLength` | `() -> number` |  |
| `GetSourceAngle` | `() -> number` | Return the directional source angular diameter in degrees. |
| `GetSourceWidth` | `() -> number` |  |
| `GetSourceHeight` | `() -> number` |  |
| `GetBarnDoorAngle` | `() -> number` |  |
| `GetBarnDoorLength` | `() -> number` |  |
| `GetUsePhysicalValues` | `() -> boolean` |  |
| `GetSpecularIntensity` | `() -> number` |  |
| `GetBrightness` | `() -> number` |  |
| `GetEffectiveColor` | `() -> Color` |  |
| `GetColorFromTemperature` | `() -> Color` |  |
| `GetEffectiveSpecularIntensity` | `() -> number` |  |
| `GetRange` | `() -> number` |  |
| `GetFov` | `() -> number` |  |
| `GetAspectRatio` | `() -> number` |  |
| `GetFadeDistance` | `() -> number` |  |
| `GetShadowFadeDistance` | `() -> number` |  |
| `GetShadowBias` | `() -> BiasParameters` |  |
| `GetShadowCascade` | `() -> CascadeParameters` |  |
| `GetShadowFocus` | `() -> FocusParameters` |  |
| `GetShadowIntensity` | `() -> number` |  |
| `GetShadowResolution` | `() -> number` |  |
| `GetShadowNearFarRatio` | `() -> number` |  |
| `GetShadowMaxExtrusion` | `() -> number` |  |
| `GetRampTexture` | `() -> Texture` |  |
| `GetShapeTexture` | `() -> Texture` |  |
| `GetFrustum` | `() -> Frustum` |  |
| `GetNumShadowSplits` | `() -> integer` |  |
| `IsNegative` | `() -> boolean` |  |
| `SetStatic` | `(flag: boolean)` |  |
| `SetPunctualLight` | `(f: boolean)` |  |
| `GetPunctualLight` | `() -> boolean` |  |
| `SetInnerConeAngle` | `(angle: number)` |  |
| `SetOuterConeAngle` | `(angle: number)` |  |
| `GetInnerConeAngle` | `() -> number` |  |
| `GetOuterConeAngle` | `() -> number` |  |


### LineEdit  `: BorderImage`

**构造**

```lua
fun(): LineEdit
```

**属性（10）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `text` | string |  |
| `cursorPosition` | integer |  |
| `cursorBlinkRate` | number |  |
| `maxLength` | integer |  |
| `echoCharacter` | integer |  |
| `cursorMovable` | boolean |  |
| `textSelectable` | boolean |  |
| `textCopyable` | boolean |  |
| `textElement` | Text |  |
| `cursor` | BorderImage |  |

**方法（18）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetText` | `(text: string)` |  |
| `SetCursorPosition` | `(position: integer)` |  |
| `SetCursorBlinkRate` | `(rate: number)` |  |
| `SetMaxLength` | `(length: integer)` |  |
| `SetEchoCharacter` | `(c: integer)` |  |
| `SetCursorMovable` | `(enable: boolean)` |  |
| `SetTextSelectable` | `(enable: boolean)` |  |
| `SetTextCopyable` | `(enable: boolean)` |  |
| `GetText` | `() -> string` |  |
| `GetCursorPosition` | `() -> integer` |  |
| `GetCursorBlinkRate` | `() -> number` |  |
| `GetMaxLength` | `() -> integer` |  |
| `GetEchoCharacter` | `() -> integer` |  |
| `IsCursorMovable` | `() -> boolean` |  |
| `IsTextSelectable` | `() -> boolean` |  |
| `IsTextCopyable` | `() -> boolean` |  |
| `GetTextElement` | `() -> Text` |  |
| `GetCursor` | `() -> BorderImage` |  |


### HierarchyContainer  `: UIElement`


### ScrollView  `: UIElement`

**构造**

```lua
fun(): ScrollView
```

**属性（12）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `viewPosition` | IntVector2 |  |
| `contentElement` | UIElement |  |
| `horizontalScrollBar` | ScrollBar |  |
| `verticalScrollBar` | ScrollBar |  |
| `scrollPanel` | BorderImage |  |
| `scrollBarsAutoVisible` | boolean |  |
| `horizontalScrollBarVisible` | boolean |  |
| `verticalScrollBarVisible` | boolean |  |
| `scrollStep` | number |  |
| `pageStep` | number |  |
| `scrollDeceleration` | number |  |
| `scrollSnapEpsilon` | number |  |

**方法（22）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetContentElement` | `(element: UIElement)` |  |
| `SetViewPosition` | `(position: IntVector2)` |  |
| `SetScrollBarsVisible` | `(horizontal: boolean, vertical: boolean)` |  |
| `SetScrollBarsAutoVisible` | `(enable: boolean)` |  |
| `SetScrollStep` | `(step: number)` |  |
| `SetPageStep` | `(step: number)` |  |
| `SetScrollDeceleration` | `(deceleration: number)` |  |
| `SetScrollSnapEpsilon` | `(snap: number)` |  |
| `SetAutoDisableChildren` | `(disable: boolean)` |  |
| `SetAutoDisableThreshold` | `(amount: number)` |  |
| `GetViewPosition` | `() -> IntVector2` |  |
| `GetContentElement` | `() -> UIElement` |  |
| `GetHorizontalScrollBar` | `() -> ScrollBar` |  |
| `GetVerticalScrollBar` | `() -> ScrollBar` |  |
| `GetScrollPanel` | `() -> BorderImage` |  |
| `GetScrollBarsAutoVisible` | `() -> boolean` |  |
| `GetScrollStep` | `() -> number` |  |
| `GetPageStep` | `() -> number` |  |
| `GetScrollDeceleration` | `() -> number` |  |
| `GetScrollSnapEpsilon` | `() -> number` |  |
| `GetAutoDisableChildren` | `() -> boolean` |  |
| `GetAutoDisableThreshold` | `() -> number` |  |


### ListView  `: ScrollView`

**构造**

```lua
fun(): ListView
```

**属性（9）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `numItems` | integer |  |
| `selection` | integer |  |
| `selectedItem` | UIElement |  |
| `highlightMode` | HighlightMode |  |
| `multiselect` | boolean |  |
| `clearSelectionOnDefocus` | boolean |  |
| `selectOnClickEnd` | boolean |  |
| `hierarchyMode` | boolean |  |
| `baseIndent` | integer |  |

**方法（39）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `UpdateInternalLayout` | `()` |  |
| `DisableInternalLayoutUpdate` | `()` |  |
| `EnableInternalLayoutUpdate` | `()` |  |
| `AddItem` | `(item: UIElement)` |  |
| `InsertItem` | `(index: integer, item: UIElement, parentItem?: UIElement)` |  |
| `RemoveItem` | `(item: UIElement, index?: integer)` |  |
| `RemoveAllItems` | `()` |  |
| `SetSelection` | `(index: integer)` |  |
| `SetSelections` | `(indices: integer[])` |  |
| `AddSelection` | `(index: integer)` |  |
| `RemoveSelection` | `(index: integer)` |  |
| `ToggleSelection` | `(index: integer)` |  |
| `ChangeSelection` | `(delta: integer, additive?: boolean)` |  |
| `ClearSelection` | `()` |  |
| `SetHighlightMode` | `(mode: HighlightMode)` |  |
| `SetMultiselect` | `(enable: boolean)` |  |
| `SetHierarchyMode` | `(enable: boolean)` |  |
| `SetBaseIndent` | `(baseIndent: integer)` |  |
| `SetClearSelectionOnDefocus` | `(enable: boolean)` |  |
| `SetSelectOnClickEnd` | `(enable: boolean)` |  |
| `Expand` | `(index: integer, enable: boolean, recursive?: boolean)` |  |
| `ToggleExpand` | `(index: integer, recursive?: boolean)` |  |
| `GetNumItems` | `() -> integer` |  |
| `GetItem` | `(index: integer) -> UIElement` |  |
| `GetItems` | `() -> UIElement[]` |  |
| `FindItem` | `(item: UIElement) -> integer` |  |
| `GetSelection` | `() -> integer` |  |
| `GetSelections` | `() -> integer[]` |  |
| `CopySelectedItemsToClipboard` | `()` |  |
| `GetSelectedItem` | `() -> UIElement` |  |
| `GetSelectedItems` | `() -> UIElement[]` |  |
| `IsSelected` | `(index: integer) -> boolean` |  |
| `IsExpanded` | `(index: integer) -> boolean` |  |
| `GetHighlightMode` | `() -> HighlightMode` |  |
| `GetMultiselect` | `() -> boolean` |  |
| `GetClearSelectionOnDefocus` | `() -> boolean` |  |
| `GetSelectOnClickEnd` | `() -> boolean` |  |
| `GetHierarchyMode` | `() -> boolean` |  |
| `GetBaseIndent` | `() -> integer` |  |


### LocalFogVolume  `: Component`

**属性（8）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `albedo` | Color |  |
| `emissive` | Color |  |
| `radialExtinction` | number |  |
| `heightExtinction` | number |  |
| `heightFalloff` | number |  |
| `radialFalloff` | number |  |
| `phaseG` | number |  |
| `maxDrawDistance` | number |  |

**方法（16）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetAlbedo` | `(albedo: Color)` |  |
| `GetAlbedo` | `() -> Color` |  |
| `SetEmissive` | `(emissive: Color)` |  |
| `GetEmissive` | `() -> Color` |  |
| `SetRadialExtinction` | `(extinction: number)` |  |
| `GetRadialExtinction` | `() -> number` |  |
| `SetHeightExtinction` | `(extinction: number)` |  |
| `GetHeightExtinction` | `() -> number` |  |
| `SetHeightFalloff` | `(falloff: number)` |  |
| `GetHeightFalloff` | `() -> number` |  |
| `SetRadialFalloff` | `(falloff: number)` |  |
| `GetRadialFalloff` | `() -> number` |  |
| `SetPhaseG` | `(phaseG: number)` |  |
| `GetPhaseG` | `() -> number` |  |
| `SetMaxDrawDistance` | `(distance: number)` |  |
| `GetMaxDrawDistance` | `() -> number` |  |


### Localization  `: Object`

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `numLanguages` | integer |  |
| `languageIndex` | integer |  |
| `language` | string |  |

**方法（13）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetNumLanguages` | `() -> integer` |  |
| `GetLanguageIndex` | `(language: string) -> integer` |  |
| `GetLanguage` | `(index: integer) -> string` |  |
| `SetLanguage` | `(language: string)` |  |
| `Get` | `(id: string) -> string` |  |
| `Reset` | `()` |  |
| `LoadJSON` | `(source: JSONValue)` |  |
| `LoadJSONFile` | `(name: string)` |  |
| `SetUserPrefPath` | `(path: string)` |  |
| `ReadUserPrefLanguage` | `() -> string` |  |
| `SaveUserPrefLanguage` | `(language: string)` |  |
| `GetSystemLanguage` | `() -> string` |  |
| `MatchLanguage` | `(lang: string) -> string` |  |


### Log  `: Object`

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `level` | integer |  |
| `timeStamp` | boolean |  |
| `quiet` | boolean |  |

**方法（11）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Open` | `(fileName: string)` |  |
| `Close` | `()` |  |
| `SetLevel` | `(level: integer)` |  |
| `SetTimeStamp` | `(enable: boolean)` |  |
| `SetQuiet` | `(quiet: boolean)` |  |
| `GetLevel` | `() -> integer` |  |
| `GetTimeStamp` | `() -> boolean` |  |
| `GetLastMessage` | `() -> string` |  |
| `IsQuiet` | `() -> boolean` |  |
| `Write` | `(level: integer, message: string)` |  |
| `WriteRaw` | `(message: string, error?: boolean)` |  |


### LuaScriptInstance  `: Component`

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `scriptFile` | LuaFile |  |
| `scriptObjectType` | string |  |

**方法（10）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `CreateObject` | `(scriptObjectType: string) -> boolean` |  |
| `SetScriptFile` | `(scriptFile: LuaFile)` |  |
| `SetScriptObjectType` | `(scriptObjectType: string)` |  |
| `UnsubscribeFromEvent` | `(eventName: string)` |  |
| `UnsubscribeFromEvents` | `(sender: Object)` |  |
| `UnsubscribeFromAllEvents` | `()` |  |
| `UnsubscribeFromAllEventsExcept` | `(exceptionNames: string[])` |  |
| `HasSubscribedToEvent` | `(eventName: string) -> boolean` |  |
| `GetScriptFile` | `() -> LuaFile` |  |
| `GetScriptObjectType` | `() -> string` |  |


### LuaScriptObject

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `node` | Node | The scene node this script is attached to |
| `instance` | LuaScriptInstance | The LuaScriptInstance component |
| `[string]` | any | Custom fields |

**方法（7）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetNode` | `() -> Node` | Get the scene node this script is attached to |
| `SubscribeToEvent` | `(eventType: StringHash|string, callback: fun(self: LuaScriptObject, eventType: StringHash, eventData: VariantMap)|string)` | When using self:SubscribeToEvent(), the callback receives (self, event |
| `UnsubscribeFromEvent` | `(eventType: StringHash|string)` | Unsubscribe from a global event |
| `UnsubscribeFromEvents` | `(sender: Object)` | Unsubscribe from all events from a sender |
| `UnsubscribeFromAllEvents` | `()` | Unsubscribe from all events |
| `UnsubscribeFromAllEventsExcept` | `(exceptions: string[])` | Unsubscribe from all events except specified ones |
| `HasSubscribedToEvent` | `(eventType: StringHash|string) -> boolean` | Check if subscribed to a global event |


### SurfaceShader  `: Resource`


### Material  `: Resource`

**构造**

```lua
fun(): Material
```

**属性（12）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `vertexShaderDefines` | string |  |
| `pixelShaderDefines` | string |  |
| `cullMode` | CullMode |  |
| `shadowCullMode` | CullMode |  |
| `fillMode` | FillMode |  |
| `depthBias` | BiasParameters |  |
| `alphaToCoverage` | boolean |  |
| `lineAntiAlias` | boolean |  |
| `renderOrder` | number -- unsigned char |  |
| `occlusion` | boolean |  |
| `specular` | boolean |  |
| `scene` | Scene |  |

**方法（60）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetNumTechniques` | `(num: integer)` |  |
| `SetTechnique` | `(index: integer, tech: Technique, qualityLevel?: MaterialQuality, lodDistance?: number)` |  |
| `SetSurfaceShader` | `(shader: SurfaceShader) -> boolean` |  |
| `SetVertexShaderDefines` | `(defines: string)` |  |
| `SetPixelShaderDefines` | `(defines: string)` |  |
| `SetShaderParameter` | `(name: string, value: Variant)` |  |
| `GetShaderParameter` | `(name: string) -> Variant` |  |
| `SetShaderParameterAnimation` | `(name: string, animation: ValueAnimation, wrapMode?: WrapMode, speed?: number)` |  |
| `SetShaderParameterAnimationWrapMode` | `(name: string, wrapMode: WrapMode)` |  |
| `SetShaderParameterAnimationSpeed` | `(name: string, speed: number)` |  |
| `SetTexture` | `(unit: TextureUnit, texture: Texture)` |  |
| `SetSurfaceTexture` | `(sourceName: string, texture: Texture) -> boolean` |  |
| `SetUVTransform` | `(offset: Vector2, rotation: number, repeat_: Vector2)` |  |
| `SetUVTiling` | `(tiling: Vector2)` |  |
| `SetUVOffset` | `(offset: Vector2)` |  |
| `SetUVSpeed` | `(speed: Vector2)` |  |
| `SetTexRotation` | `(rotate: number)` |  |
| `GetUVTiling` | `() -> Vector2` |  |
| `GetUVOffset` | `() -> Vector2` |  |
| `GetUVSpeed` | `() -> Vector2` |  |
| `GetTexRotation` | `() -> number` |  |
| `SetCullMode` | `(mode: CullMode)` |  |
| `SetShadowCullMode` | `(mode: CullMode)` |  |
| `SetFillMode` | `(mode: FillMode)` |  |
| `SetDepthBias` | `(parameters: BiasParameters)` |  |
| `SetAlphaToCoverage` | `(enable: boolean)` |  |
| `SetLineAntiAlias` | `(enable: boolean)` |  |
| `SetRenderOrder` | `(renderOrder: number -- unsigned char)` |  |
| `SetOcclusion` | `(enable: boolean)` |  |
| `SetScene` | `(scene: Scene)` |  |
| `RemoveShaderParameter` | `(name: string)` |  |
| `ClearShaderParameters` | `()` |  |
| `ClearUnusedShaderParameters` | `()` |  |
| `SaveJSON` | `(dest: JSONValue) -> boolean` |  |
| `LoadJSON` | `(source: JSONValue) -> boolean` |  |
| `ReleaseShaders` | `()` |  |
| `Clone` | `(cloneName?: string) -> Material` |  |
| `SortTechniques` | `()` |  |
| `MarkForAuxView` | `(frameNumber: integer)` |  |
| `GetNumTechniques` | `() -> integer` |  |
| `GetTechnique` | `(index: integer) -> Technique` |  |
| `GetSurfaceShader` | `() -> SurfaceShader` |  |
| `GetPass` | `(index: integer, passName: string) -> Pass` |  |
| `GetTexture` | `(unit: TextureUnit) -> Texture` |  |
| `GetSurfaceTexture` | `(sourceName: string) -> Texture` |  |
| `GetVertexShaderDefines` | `() -> string` |  |
| `GetPixelShaderDefines` | `() -> string` |  |
| `GetShaderParameterAnimation` | `(name: string) -> ValueAnimation` |  |
| `GetShaderParameterAnimationWrapMode` | `(name: string) -> WrapMode` |  |
| `GetShaderParameterAnimationSpeed` | `(name: string) -> number` |  |
| `GetCullMode` | `() -> CullMode` |  |
| `GetShadowCullMode` | `() -> CullMode` |  |
| `GetFillMode` | `() -> FillMode` |  |
| `GetDepthBias` | `() -> BiasParameters` |  |
| `GetAlphaToCoverage` | `() -> boolean` |  |
| `GetLineAntiAlias` | `() -> boolean` |  |
| `GetRenderOrder` | `() -> number` |  |
| `GetOcclusion` | `() -> boolean` |  |
| `GetSpecular` | `() -> boolean` |  |
| `GetScene` | `() -> Scene` |  |


### Matrix2

**构造**

```lua
fun(matrix: Matrix2): Matrix2
fun(v00: number, v01: number, v02: number, v10: number, v11: number, v12: number, v20: number, v21: number, v22: number): Matrix2
fun(): Matrix2
fun(self: Matrix2, matrix: Matrix2): Matrix2
fun(matrix: Matrix2): Matrix2
fun(self: Matrix2, v00: number, v01: number, v02: number, v10: number, v11: number, v12: number, v20: number, v21: number, v22: number): Matrix2
fun(v00: number, v01: number, v02: number, v10: number, v11: number, v12: number, v20: number, v21: number, v22: number): Matrix2
```

**属性（6）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `m00` | number |  |
| `m01` | number |  |
| `m10` | number |  |
| `m11` | number |  |
| `ZERO` | Matrix2 |  |
| `IDENTITY` | Matrix2 |  |

**方法（7）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetScale` | `(scale: Vector2)` |  |
| `Scale` | `() -> Vector2` |  |
| `Transpose` | `() -> Matrix2` |  |
| `Scaled` | `(scale: Vector2) -> Matrix2` |  |
| `Equals` | `(rhs: Matrix2) -> boolean` |  |
| `Inverse` | `() -> Matrix2` |  |
| `ToString` | `() -> string` |  |

**运算符**：`eq(Matrix2): boolean`、`mul(Vector2): Vector2`、`add(Matrix2): Matrix2`、`sub(Matrix2): Matrix2`、`mul(number): Matrix2`、`mul(Matrix2): Matrix2`


### Matrix3

**构造**

```lua
fun(matrix: Matrix3): Matrix3
fun(v00: number, v01: number, v02: number, v10: number, v11: number, v12: number, v20: number, v21: number, v22: number): Matrix3
fun(): Matrix3
fun(self: Matrix3, matrix: Matrix3): Matrix3
fun(matrix: Matrix3): Matrix3
fun(self: Matrix3, v00: number, v01: number, v02: number, v10: number, v11: number, v12: number, v20: number, v21: number, v22: number): Matrix3
fun(v00: number, v01: number, v02: number, v10: number, v11: number, v12: number, v20: number, v21: number, v22: number): Matrix3
```

**属性（14）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `m00` | number |  |
| `m01` | number |  |
| `m02` | number |  |
| `m10` | number |  |
| `m11` | number |  |
| `m12` | number |  |
| `m20` | number |  |
| `m21` | number |  |
| `m22` | number |  |
| `scale` | Vector3 |  |
| `transpose` | Matrix3 |  |
| `inverse` | Matrix3 |  |
| `ZERO` | Matrix3 |  |
| `IDENTITY` | Matrix3 |  |

**方法（7）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetScale` | `(scale: Vector3)` |  |
| `Scale` | `() -> Vector3` |  |
| `Transpose` | `() -> Matrix3` |  |
| `Scaled` | `(scale: Vector3) -> Matrix3` |  |
| `Equals` | `(rhs: Matrix3) -> boolean` |  |
| `Inverse` | `() -> Matrix3` |  |
| `ToString` | `() -> string` |  |

**运算符**：`eq(Matrix3): boolean`、`mul(Vector3): Vector3`、`add(Matrix3): Matrix3`、`sub(Matrix3): Matrix3`、`mul(number): Matrix3`、`mul(Matrix3): Matrix3`


### Matrix3x4

**构造**

```lua
fun(matrix: Matrix3x4): Matrix3x4
fun(matrix: Matrix3): Matrix3x4
fun(matrix: Matrix4): Matrix3x4
fun(v00: number, v01: number, v02: number, v03: number, v10: number, v11: number, v12: number, v13: number, v20: number, v21: number, v22: number, v23: number): Matrix3x4
fun(translation: Vector3, rotation: Quaternion, scale: number): Matrix3x4
fun(translation: Vector3, rotation: Quaternion, scale: Vector3): Matrix3x4
fun(): Matrix3x4
fun(self: Matrix3x4, matrix: Matrix3x4): Matrix3x4
```

**属性（18）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `m00` | number |  |
| `m01` | number |  |
| `m02` | number |  |
| `m03` | number |  |
| `m10` | number |  |
| `m11` | number |  |
| `m12` | number |  |
| `m13` | number |  |
| `m20` | number |  |
| `m21` | number |  |
| `m22` | number |  |
| `m23` | number |  |
| `rotationMatrix` | Matrix3 |  |
| `translation` | Vector3 |  |
| `rotation` | Quaternion |  |
| `scale` | Vector3 |  |
| `ZERO` | Matrix3x4 |  |
| `IDENTITY` | Matrix3x4 |  |

**方法（13）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetTranslation` | `(translation: Vector3)` |  |
| `SetRotation` | `(rotation: Matrix3)` |  |
| `SetScale` | `(scale: Vector3)` |  |
| `ToMatrix3` | `() -> Matrix3` |  |
| `ToMatrix4` | `() -> Matrix4` |  |
| `RotationMatrix` | `() -> Matrix3` |  |
| `Translation` | `() -> Vector3` |  |
| `Rotation` | `() -> Quaternion` |  |
| `Scale` | `() -> Vector3` |  |
| `Equals` | `(rhs: Matrix3x4) -> boolean` |  |
| `Decompose` | `(translation: Vector3, rotation: Quaternion, scale: Vector3)` |  |
| `Inverse` | `() -> Matrix3x4` |  |
| `ToString` | `() -> string` |  |

**运算符**：`eq(Matrix3x4): boolean`、`mul(Vector3): Vector3`、`mul(Vector4): Vector3`、`add(number): Matrix3x4`、`add(Matrix3x4): Matrix3x4`、`sub(Matrix3x4): Matrix3x4`、`mul(number): Matrix3x4`、`mul(Matrix3x4): Matrix3x4`、`div(number): Matrix3x4`、`mul(Matrix4): Matrix4`


### Matrix4

**构造**

```lua
fun(matrix: Matrix4): Matrix4
fun(matrix: Matrix3): Matrix4
fun(v00: number, v01: number, v02: number, v03: number, v10: number, v11: number, v12: number, v13: number, v20: number, v21: number, v22: number, v23: number, v30: number, v31: number, v32: number, v33: number): Matrix4
fun(): Matrix4
fun(self: Matrix4, matrix: Matrix4): Matrix4
fun(matrix: Matrix4): Matrix4
fun(self: Matrix4, matrix: Matrix3): Matrix4
fun(matrix: Matrix3): Matrix4
```

**属性（24）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `m00` | number |  |
| `m01` | number |  |
| `m02` | number |  |
| `m03` | number |  |
| `m10` | number |  |
| `m11` | number |  |
| `m12` | number |  |
| `m13` | number |  |
| `m20` | number |  |
| `m21` | number |  |
| `m22` | number |  |
| `m23` | number |  |
| `m30` | number |  |
| `m31` | number |  |
| `m32` | number |  |
| `m33` | number |  |
| `rotationMatrix` | Matrix3 |  |
| `translation` | Vector3 |  |
| `rotation` | Quaternion |  |
| `scale` | Vector3 |  |
| `transpose` | Matrix4 |  |
| `inverse` | Matrix4 |  |
| `ZERO` | Matrix4 |  |
| `IDENTITY` | Matrix4 |  |

**方法（13）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetTranslation` | `(translation: Vector3)` |  |
| `SetRotation` | `(rotation: Matrix3)` |  |
| `SetScale` | `(scale: Vector3)` |  |
| `ToMatrix3` | `() -> Matrix3` |  |
| `RotationMatrix` | `() -> Matrix3` |  |
| `Translation` | `() -> Vector3` |  |
| `Rotation` | `() -> Quaternion` |  |
| `Scale` | `() -> Vector3` |  |
| `Transpose` | `() -> Matrix4` |  |
| `Equals` | `(rhs: Matrix4) -> boolean` |  |
| `Decompose` | `(translation: Vector3, rotation: Quaternion, scale: Vector3)` |  |
| `Inverse` | `() -> Matrix4` |  |
| `ToString` | `() -> string` |  |

**运算符**：`eq(Matrix4): boolean`、`mul(Vector3): Vector3`、`mul(Vector4): Vector4`、`add(Matrix4): Matrix4`、`sub(Matrix4): Matrix4`、`mul(number): Matrix4`、`mul(Matrix4): Matrix4`、`mul(Matrix3x4): Matrix4`


### MessageBox  `: Object`

**构造**

```lua
fun(messageString?: string, titleString?: string, layoutFile?: XMLFile, styleFile?: XMLFile): MessageBox
fun(): MessageBox
fun(self: MessageBox, messageString?: string, titleString?: string, layoutFile?: XMLFile, styleFile?: XMLFile): MessageBox
fun(messageString?: string, titleString?: string, layoutFile?: XMLFile, styleFile?: XMLFile): MessageBox
```

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `title` | string |  |
| `message` | string |  |
| `window` | UIElement |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetTitle` | `(text: string)` |  |
| `SetMessage` | `(text: string)` |  |
| `GetTitle` | `() -> string` |  |
| `GetMessage` | `() -> string` |  |
| `GetWindow` | `() -> UIElement` |  |


### ModelMorph

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | string Morph channel name. Instance weights are controlled through AnimatedModel. |  |
| `nameHash` | StringHash|string Hash of the morph channel name. |  |


### Model  `: ResourceWithMetadata`

**构造**

```lua
fun(): Model
```

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `boundingBox` | BoundingBox |  |
| `skeleton` | Skeleton |  |
| `numGeometries` | integer |  |
| `numMorphs` | integer |  |

**方法（18）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Clone` | `(cloneName?: string) -> Model` |  |
| `SetBoundingBox` | `(box: BoundingBox)` |  |
| `SetVertexBuffers` | `(buffers: VertexBuffer[], morphRangeStarts: integer[], morphRangeCounts: integer[]) -> boolean` |  |
| `SetIndexBuffers` | `(buffers: IndexBuffer[]) -> boolean` |  |
| `SetNumGeometries` | `(num: integer)` |  |
| `SetNumGeometryLodLevels` | `(index: integer, num: integer) -> boolean` |  |
| `SetGeometry` | `(index: integer, lodLevel: integer, geometry: Geometry) -> boolean` |  |
| `SetGeometryCenter` | `(index: integer, center: Vector3) -> boolean` |  |
| `GetBoundingBox` | `() -> BoundingBox` |  |
| `GetSkeleton` | `() -> Skeleton` |  |
| `GetNumGeometries` | `() -> integer` |  |
| `GetNumGeometryLodLevels` | `(index: integer) -> integer` |  |
| `GetGeometry` | `(index: integer, lodLevel: integer) -> Geometry` |  |
| `GetGeometryCenter` | `(index: integer) -> Vector3` |  |
| `GetNumMorphs` | `() -> integer` |  |
| `GetMorph` | `(name: string) -> ModelMorph` | Return model-owned morph metadata by name, or nil if not found. |
| `GetMorphRangeStart` | `(bufferIndex: integer) -> integer` |  |
| `GetMorphRangeCount` | `(bufferIndex: integer) -> integer` |  |


### NamedPipe  `: Object`

**构造**

```lua
fun(pipeName: string, isServer: boolean): NamedPipe
fun(): NamedPipe
fun(self: NamedPipe, pipeName: string, isServer: boolean): NamedPipe
fun(pipeName: string, isServer: boolean): NamedPipe
```

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | string |  |
| `eof` | boolean |  |
| `open` | boolean |  |

**方法（80）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Open` | `(pipeName: string, isServer: boolean) -> boolean` |  |
| `Close` | `()` |  |
| `IsOpen` | `() -> boolean` |  |
| `Read` | `(size: integer) -> VectorBuffer` |  |
| `GetName` | `() -> string` |  |
| `IsEof` | `() -> boolean` |  |
| `ReadInt` | `() -> integer` |  |
| `ReadShort` | `() -> integer` |  |
| `ReadByte` | `() -> integer` |  |
| `ReadUInt` | `() -> integer` |  |
| `ReadUShort` | `() -> integer` |  |
| `ReadUByte` | `() -> number` |  |
| `ReadBool` | `() -> boolean` |  |
| `ReadFloat` | `() -> number` |  |
| `ReadDouble` | `() -> number` |  |
| `ReadIntRect` | `() -> IntRect` |  |
| `ReadIntVector2` | `() -> IntVector2` |  |
| `ReadIntVector3` | `() -> IntVector3` |  |
| `ReadRect` | `() -> Rect` |  |
| `ReadVector2` | `() -> Vector2` |  |
| `ReadVector3` | `() -> Vector3` |  |
| `ReadPackedVector3` | `(maxAbsCoord: number) -> Vector3` |  |
| `ReadVector4` | `() -> Vector4` |  |
| `ReadQuaternion` | `() -> Quaternion` |  |
| `ReadPackedQuaternion` | `() -> Quaternion` |  |
| `ReadMatrix3` | `() -> Matrix3` |  |
| `ReadMatrix3x4` | `() -> Matrix3x4` |  |
| `ReadMatrix4` | `() -> Matrix4` |  |
| `ReadColor` | `() -> Color` |  |
| `ReadBoundingBox` | `() -> BoundingBox` |  |
| `ReadString` | `() -> string` |  |
| `ReadFileID` | `() -> string` |  |
| `ReadStringHash` | `() -> StringHash|string` |  |
| `ReadBuffer` | `() -> VectorBuffer` |  |
| `ReadResourceRef` | `() -> ResourceRef` |  |
| `ReadResourceRefList` | `() -> ResourceRefList` |  |
| `ReadVariant` | `(type: VariantType) -> Variant` |  |
| `ReadVariantVector` | `() -> VariantVector` |  |
| `ReadVariantMap` | `() -> VariantMap` |  |
| `ReadVLE` | `() -> integer` |  |
| `ReadNetID` | `() -> integer` |  |
| `ReadLine` | `() -> string` |  |
| `Write` | `(buffer: VectorBuffer) -> integer` |  |
| `WriteInt` | `(value: integer) -> boolean` |  |
| `WriteShort` | `(value: integer) -> boolean` |  |
| `WriteByte` | `(value: integer) -> boolean` |  |
| `WriteUInt` | `(value: integer) -> boolean` |  |
| `WriteUShort` | `(value: integer -- unsigned short) -> boolean` |  |
| `WriteUByte` | `(value: number -- unsigned char) -> boolean` |  |
| `WriteBool` | `(value: boolean) -> boolean` |  |
| `WriteFloat` | `(value: number) -> boolean` |  |
| `WriteDouble` | `(value: number) -> boolean` |  |
| `WriteIntRect` | `(value: IntRect) -> boolean` |  |
| `WriteIntVector2` | `(value: IntVector2) -> boolean` |  |
| `WriteIntVector3` | `(value: IntVector3) -> boolean` |  |
| `WriteRect` | `(value: Rect) -> boolean` |  |
| `WriteVector2` | `(value: Vector2) -> boolean` |  |
| `WriteVector3` | `(value: Vector3) -> boolean` |  |
| `WritePackedVector3` | `(value: Vector3, maxAbsCoord: number) -> boolean` |  |
| `WriteVector4` | `(value: Vector4) -> boolean` |  |
| `WriteQuaternion` | `(value: Quaternion) -> boolean` |  |
| `WritePackedQuaternion` | `(value: Quaternion) -> boolean` |  |
| `WriteMatrix3` | `(value: Matrix3) -> boolean` |  |
| `WriteMatrix3x4` | `(value: Matrix3x4) -> boolean` |  |
| `WriteMatrix4` | `(value: Matrix4) -> boolean` |  |
| `WriteColor` | `(value: Color) -> boolean` |  |
| `WriteBoundingBox` | `(value: BoundingBox) -> boolean` |  |
| `WriteString` | `(value: string) -> boolean` |  |
| `WriteFileID` | `(value: string) -> boolean` |  |
| `WriteStringHash` | `(value: StringHash|string) -> boolean` |  |
| `WriteBuffer` | `(buffer: VectorBuffer) -> boolean` |  |
| `WriteResourceRef` | `(value: ResourceRef) -> boolean` |  |
| `WriteResourceRefList` | `(value: ResourceRefList) -> boolean` |  |
| `WriteVariant` | `(value: Variant) -> boolean` |  |
| `WriteVariantData` | `(value: Variant) -> boolean` |  |
| `WriteVariantVector` | `(value: VariantVector) -> boolean` |  |
| `WriteVariantMap` | `(value: VariantMap) -> boolean` |  |
| `WriteVLE` | `(value: integer) -> boolean` |  |
| `WriteNetID` | `(value: integer) -> boolean` |  |
| `WriteLine` | `(value: string) -> boolean` |  |


### NVGContextWrapper  `: Object`


### NVGcolor

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `r` | number Red component (0.0-1.0) |  |
| `g` | number Green component (0.0-1.0) |  |
| `b` | number Blue component (0.0-1.0) |  |
| `a` | number Alpha component (0.0-1.0) |  |


### NVGpaint

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `xform` | number[] Transform matrix (6 floats) |  |
| `extent` | number[] Extent (2 floats: width, height) |  |
| `radius` | number Radius |  |
| `feather` | number Feather |  |
| `innerColor` | NVGcolor Inner color (for image pattern: tints the image via multiply in shader) |  |
| `outerColor` | NVGcolor Outer color |  |
| `image` | integer Image handle |  |


### NVGglyphPosition

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `str` | string Character position in string |  |
| `x` | number X position of the glyph |  |
| `minx` | number Left bound of the glyph |  |
| `maxx` | number Right bound of the glyph |  |


### NVGtextRow

**属性（6）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `start` | string Start of the row |  |
| `end` | string End of the row |  |
| `next` | string Next row start |  |
| `width` | number Logical width of the row |  |
| `minx` | number Actual left bound of the row |  |
| `maxx` | number Actual right bound of the row |  |


### NavArea  `: Component`

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `areaID` | integer |  |
| `boundingBox` | BoundingBox |  |
| `worldBoundingBox` | BoundingBox |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetAreaID` | `() -> integer` |  |
| `SetAreaID` | `(param0: integer)` |  |
| `GetBoundingBox` | `() -> BoundingBox` |  |
| `SetBoundingBox` | `(bnds: BoundingBox)` |  |
| `GetWorldBoundingBox` | `() -> BoundingBox` |  |


### Navigable  `: Component`

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `recursive` | boolean |  |

**方法（2）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetRecursive` | `(enable: boolean)` |  |
| `IsRecursive` | `() -> boolean` |  |


### NavigationGeometryInfo

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `component` | Component |  |
| `lodLevel` | integer |  |
| `transform` | Matrix3x4 |  |
| `boundingBox` | BoundingBox |  |


### Network

**属性（10）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `updateFps` | integer |  |
| `simulatedLatency` | integer |  |
| `simulatedPacketLoss` | number |  |
| `clientConnectionTimeout` | integer |  |
| `serverConnectionTimeout` | integer |  |
| `pausedTimeout` | integer |  |
| `replicateRemovalOnDetach` | boolean |  |
| `serverConnection` | Connection |  |
| `serverRunning` | boolean |  |
| `packageCacheDir` | string |  |

**方法（48）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Connect` | `(address: string, port: integer -- unsigned short, scene?: Scene, identity?: VariantMap) -> boolean` |  |
| `ConnectWithTransport` | `(address: string, port: integer -- unsigned short, scene: Scene, protocol: TransportProtocol, identity?: VariantMap) -> boolean` |  |
| `Disconnect` | `(waitMSec?: integer)` |  |
| `StartServer` | `(port: integer -- unsigned short) -> boolean` |  |
| `StartServerWithTransport` | `(port: integer -- unsigned short, protocol: TransportProtocol) -> boolean` |  |
| `AddServerTransport` | `(port: integer -- unsigned short, protocol: TransportProtocol) -> boolean` |  |
| `StopServerTransport` | `(protocol: TransportProtocol) -> boolean` |  |
| `StopServer` | `()` |  |
| `GetTransportProtocol` | `() -> TransportProtocol` |  |
| `GetServerTransportProtocols` | `() -> integer[]` |  |
| `IsServerTransportRunning` | `(protocol: TransportProtocol) -> boolean` |  |
| `SetPreferredTransport` | `(protocol: TransportProtocol)` |  |
| `BroadcastMessage` | `(msgID: integer, reliable: boolean, inOrder: boolean, msg: VectorBuffer, contentID?: integer)` |  |
| `BroadcastRemoteEvent` | `(eventType: StringHash|string, inOrder: boolean, eventData?: VariantMap)` |  |
| `SetUpdateFps` | `(fps: integer)` |  |
| `SetSimulatedLatency` | `(ms: integer)` |  |
| `SetSimulatedPacketLoss` | `(loss: number)` |  |
| `SetClientConnectionTimeout` | `(timeoutMs: integer)` |  |
| `GetClientConnectionTimeout` | `() -> integer` |  |
| `SetServerConnectionTimeout` | `(timeoutMs: integer)` |  |
| `GetServerConnectionTimeout` | `() -> integer` |  |
| `SetPausedTimeout` | `(timeoutMs: integer)` |  |
| `GetPausedTimeout` | `() -> integer` |  |
| `SetReplicateRemovalOnDetach` | `(enable: boolean)` | Replicate node/component removal as soon as the object leaves the scen |
| `GetReplicateRemovalOnDetach` | `() -> boolean` | Return whether node/component removal is replicated as soon as the obj |
| `RegisterRemoteEvent` | `(eventType: StringHash|string)` |  |
| `UnregisterRemoteEvent` | `(eventType: StringHash|string)` |  |
| `UnregisterAllRemoteEvents` | `()` |  |
| `SetPackageCacheDir` | `(path: string)` |  |
| `SendPackageToClients` | `(scene: Scene, package: PackageFile)` |  |
| `MakeHttpRequest` | `(url: string, verb?: string, headers?: string[]) -> HttpRequest` |  |
| `GetUpdateFps` | `() -> integer` |  |
| `GetSimulatedLatency` | `() -> integer` |  |
| `GetSimulatedPacketLoss` | `() -> number` |  |
| `GetServerConnection` | `() -> Connection` |  |
| `IsReconnectSession` | `() -> boolean` |  |
| `GetSessionId` | `() -> string` |  |
| `IsServerRunning` | `() -> boolean` |  |
| `CheckRemoteEvent` | `(eventType: StringHash|string) -> boolean` |  |
| `GetPackageCacheDir` | `() -> string` |  |
| `GetClientConnections` | `() -> Connection[]` |  |
| `SetPassword` | `(password: string)` |  |
| `StartNATClient` | `()` |  |
| `GetGUID` | `() -> string` |  |
| `DiscoverHosts` | `(port: integer)` |  |
| `SetDiscoveryBeacon` | `(data: VariantMap)` |  |
| `SetNATServerInfo` | `(address: string, port: integer -- unsigned short)` |  |
| `AttemptNATPunchtrough` | `(guid: string, scene?: Scene, identity?: VariantMap)` |  |


### NetworkPriority  `: Component`

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `basePriority` | number |  |
| `distanceFactor` | number |  |
| `minPriority` | number |  |
| `alwaysUpdateOwner` | boolean |  |

**方法（9）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetBasePriority` | `(priority: number)` |  |
| `SetDistanceFactor` | `(factor: number)` |  |
| `SetMinPriority` | `(priority: number)` |  |
| `SetAlwaysUpdateOwner` | `(enable: boolean)` |  |
| `GetBasePriority` | `() -> number` |  |
| `GetDistanceFactor` | `() -> number` |  |
| `GetMinPriority` | `() -> number` |  |
| `GetAlwaysUpdateOwner` | `() -> boolean` |  |
| `CheckUpdate` | `(distance: number, accumulator: number) -> boolean` |  |


### Node  `: Animatable`

**构造**

```lua
fun(): Node
```

**属性（40）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `ID` | integer |  |
| `replicated` | boolean |  |
| `name` | string |  |
| `nameHash` | StringHash|string |  |
| `parent` | Node |  |
| `scene` | Scene |  |
| `enabled` | boolean |  |
| `enabledSelf` | boolean |  |
| `owner` | Connection |  |
| `position` | Vector3 |  |
| `position2D` | Vector2 |  |
| `rotation` | Quaternion |  |
| `rotation2D` | number |  |
| `direction` | Vector3 |  |
| `up` | Vector3 |  |
| `right` | Vector3 |  |
| `scale` | Vector3 |  |
| `scale2D` | Vector2 |  |
| `transform` | Matrix3x4 |  |
| `worldPosition` | Vector3 |  |
| `worldPosition2D` | Vector2 |  |
| `worldRotation` | Quaternion |  |
| `worldRotation2D` | number |  |
| `worldDirection` | Vector3 |  |
| `worldUp` | Vector3 |  |
| `worldRight` | Vector3 |  |
| `worldScale` | Vector3 |  |
| `signedWorldScale` | Vector3 |  |
| `worldScale2D` | Vector2 |  |
| `worldTransform` | Matrix3x4 |  |
| `dirty` | boolean |  |
| `numChildren` | integer |  |
| `numComponents` | integer |  |
| `numNetworkComponents` | integer |  |
| `CreateComponent` | __union_func__type_str__mode_CreateMode_opt__id_int_opt__ret_ComponentT |  |
| `GetOrCreateComponent` | __union_func__type_str__mode_CreateMode_opt__id_int_opt__ret_ComponentT |  |
| `GetComponent` | __union_func__type_str__recursive_bool_opt__ret_ComponentT |  |
| `GetParentComponent` | __union_func__type_str__recursive_bool_opt__ret_ComponentT |  |
| `GetComponents` | __union_func__type_str__recursive_bool_opt__ret_ComponentT_arr |  |
| `SetVar` | fun(self: Node, key: StringHash|string, value: VariantInput) |  |

**方法（117）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SaveXML` | `(dest: File, indentation?: string) -> boolean` |  |
| `SaveJSON` | `(dest: File, indentation?: string) -> boolean` |  |
| `SetName` | `(name: string)` |  |
| `AddTag` | `(tag: string)` |  |
| `AddTags` | `(tags: string, separator: string)` |  |
| `RemoveTag` | `(tag: string) -> boolean` |  |
| `RemoveAllTags` | `()` |  |
| `SetPosition` | `(position: Vector3)` |  |
| `SetPosition2D` | `(position: Vector2)` |  |
| `SetRotation` | `(rotation: Quaternion)` |  |
| `SetRotation2D` | `(rotation: number)` |  |
| `SetDirection` | `(direction: Vector3)` |  |
| `SetScale` | `(scale: number)` |  |
| `SetScale2D` | `(scale: Vector2)` |  |
| `SetTransform` | `(position: Vector3, rotation: Quaternion)` |  |
| `SetTransform2D` | `(position: Vector2, rotation: number)` |  |
| `SetWorldPosition` | `(position: Vector3)` |  |
| `SetWorldPosition2D` | `(position: Vector2)` |  |
| `SetWorldRotation` | `(rotation: Quaternion)` |  |
| `SetWorldRotation2D` | `(rotation: number)` |  |
| `SetWorldDirection` | `(direction: Vector3)` |  |
| `SetWorldScale` | `(scale: number)` |  |
| `SetWorldScale2D` | `(scale: Vector2)` |  |
| `SetWorldTransform` | `(position: Vector3, rotation: Quaternion)` |  |
| `SetWorldTransform2D` | `(position: Vector2, rotation: number)` |  |
| `Translate` | `(delta: Vector3, space?: TransformSpace)` |  |
| `Translate2D` | `(delta: Vector2, space?: TransformSpace)` |  |
| `Rotate` | `(delta: Quaternion, space?: TransformSpace)` |  |
| `Rotate2D` | `(delta: number, space?: TransformSpace)` |  |
| `RotateAround` | `(point: Vector3, delta: Quaternion, space?: TransformSpace)` |  |
| `RotateAround2D` | `(point: Vector2, delta: number, space?: TransformSpace)` |  |
| `Pitch` | `(angle: number, space?: TransformSpace)` |  |
| `Yaw` | `(angle: number, space?: TransformSpace)` |  |
| `Roll` | `(angle: number, space?: TransformSpace)` |  |
| `LookAt` | `(target: Vector3, upAxis?: Vector3, space?: TransformSpace) -> boolean` |  |
| `Scale` | `(scale: number)` |  |
| `Scale2D` | `(scale: Vector2)` |  |
| `SetEnabled` | `(enable: boolean)` |  |
| `SetDeepEnabled` | `(enable: boolean)` |  |
| `ResetDeepEnabled` | `()` |  |
| `SetEnabledRecursive` | `(enable: boolean)` |  |
| `SetOwner` | `(owner: Connection)` |  |
| `MarkDirty` | `()` |  |
| `CreateChild` | `(name?: string, mode?: CreateMode, id?: integer, temporary?: boolean) -> Node` |  |
| `CreateTemporaryChild` | `(name?: string, mode?: CreateMode, id?: integer) -> Node` |  |
| `AddChild` | `(node: Node, index?: integer)` |  |
| `RemoveChild` | `(node: Node)` |  |
| `RemoveAllChildren` | `()` |  |
| `RemoveChildren` | `(removeReplicated: boolean, removeLocal: boolean, recursive: boolean)` |  |
| `RemoveComponent` | `(component: Component)` |  |
| `RemoveComponents` | `(removeReplicated: boolean, removeLocal: boolean)` |  |
| `RemoveAllComponents` | `()` |  |
| `ReorderComponent` | `(component: Component, index: integer)` |  |
| `Clone` | `(mode?: CreateMode) -> Node` |  |
| `Remove` | `()` |  |
| `Dispose` | `()` |  |
| `SetParent` | `(parent: Node)` |  |
| `SetVar` | `(key: StringHash|string, value: Variant)` |  |
| `AddListener` | `(component: Component)` |  |
| `RemoveListener` | `(component: Component)` |  |
| `CloneComponent` | `(component: Component, id?: integer) -> Component` |  |
| `CreateScriptObject` | `(scriptObjectType: string) -> LuaScriptObject?` |  |
| `GetScriptObject` | `(scriptObjectType: string) -> LuaScriptObject?` |  |
| `GetID` | `() -> integer` |  |
| `IsReplicated` | `() -> boolean` |  |
| `GetName` | `() -> string` |  |
| `GetNameHash` | `() -> StringHash|string` |  |
| `GetParent` | `() -> Node` |  |
| `GetScene` | `() -> Scene` |  |
| `IsChildOf` | `(node: Node) -> boolean` |  |
| `IsEnabled` | `() -> boolean` |  |
| `IsEnabledSelf` | `() -> boolean` |  |
| `GetOwner` | `() -> Connection` |  |
| `GetPosition` | `() -> Vector3` |  |
| `GetPosition2D` | `() -> Vector2` |  |
| `GetRotation` | `() -> Quaternion` |  |
| `GetRotation2D` | `() -> number` |  |
| `GetDirection` | `() -> Vector3` |  |
| `GetUp` | `() -> Vector3` |  |
| `GetRight` | `() -> Vector3` |  |
| `GetScale` | `() -> Vector3` |  |
| `GetScale2D` | `() -> Vector2` |  |
| `GetTransform` | `() -> Matrix3x4` |  |
| `GetWorldPosition` | `() -> Vector3` |  |
| `GetWorldPosition2D` | `() -> Vector2` |  |
| `GetWorldRotation` | `() -> Quaternion` |  |
| `GetWorldRotation2D` | `() -> number` |  |
| `GetWorldDirection` | `() -> Vector3` |  |
| `GetWorldUp` | `() -> Vector3` |  |
| `GetWorldRight` | `() -> Vector3` |  |
| `GetWorldScale` | `() -> Vector3` |  |
| `GetSignedWorldScale` | `() -> Vector3` |  |
| `GetWorldScale2D` | `() -> Vector2` |  |
| `GetWorldTransform` | `() -> Matrix3x4` |  |
| `LocalToWorld` | `(position: Vector3) -> Vector3` |  |
| `LocalToWorld2D` | `(vector: Vector2) -> Vector2` |  |
| `WorldToLocal` | `(position: Vector3) -> Vector3` |  |
| `WorldToLocal2D` | `(vector: Vector2) -> Vector2` |  |
| `IsDirty` | `() -> boolean` |  |
| `GetNumChildren` | `(recursive?: boolean) -> integer` |  |
| `GetChild` | `(name: string, recursive?: boolean) -> Node` |  |
| `GetNumComponents` | `() -> integer` |  |
| `GetNumNetworkComponents` | `() -> integer` |  |
| `HasComponent` | `(type: StringHash|string) -> boolean` |  |
| `GetVar` | `(key: StringHash|string) -> Variant` |  |
| `GetVars` | `() -> VariantMap` |  |
| `GetChildren` | `(recursive?: boolean) -> Node[]` |  |
| `GetChildrenWithComponent` | `(type: string, recursive?: boolean) -> Node[]` |  |
| `LoadXML` | `(source: XMLElement) -> boolean` |  |
| `LoadJSON` | `(source: JSONValue) -> boolean` |  |
| `Load` | `(source: Deserializer, resolver: SceneResolver, loadChildren?: boolean, rewriteIDs?: boolean, mode?: CreateMode) -> boolean` |  |
| `AddComponent` | `(component: Component, id: integer, mode: CreateMode)` |  |
| `HasTag` | `(tag: string) -> boolean` |  |
| `GetTags` | `() -> StringVector` |  |
| `GetChildrenWithTag` | `(tag: string, recursive?: boolean) -> Node[]` |  |
| `GetChildrenWithName` | `(tag: string, recursive?: boolean) -> Node[]` |  |
| `SetID` | `(id: integer)` |  |


### ObjectAnimation  `: Resource`

**构造**

```lua
fun(): ObjectAnimation
```

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `AddAttributeAnimation` | `(name: string, attributeAnimation: ValueAnimation, wrapMode?: WrapMode, speed?: number)` |  |
| `RemoveAttributeAnimation` | `(name: string)` |  |
| `GetAttributeAnimation` | `(name: string) -> ValueAnimation` |  |
| `GetAttributeAnimationWrapMode` | `(name: string) -> WrapMode` |  |
| `GetAttributeAnimationSpeed` | `(name: string) -> number` |  |


### Obstacle  `: Component`

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `radius` | number |  |
| `height` | number |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `DrawDebugGeometry` | `(depthTest: boolean)` |  |
| `SetRadius` | `(radius: number)` |  |
| `SetHeight` | `(height: number)` |  |
| `GetRadius` | `() -> number` |  |
| `GetHeight` | `() -> number` |  |


### Octree  `: Component`

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `numLevels` | integer |  |

**方法（10）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetSize` | `(box: BoundingBox, numLevels: integer)` |  |
| `AddManualDrawable` | `(drawable: Drawable)` |  |
| `RemoveManualDrawable` | `(drawable: Drawable)` |  |
| `GetDrawables` | `(point: Vector3, drawableFlags?: number -- unsigned char, viewMask?: integer) -> OctreeQueryResult[]` |  |
| `GetAllDrawables` | `(drawableFlags?: number -- unsigned char, viewMask?: integer) -> OctreeQueryResult[]` |  |
| `Raycast` | `(ray: Ray, level: RayQueryLevel, maxDistance: number, drawableFlags: number -- unsigned char, viewMask?: integer) -> RayQueryResult[]` |  |
| `RaycastSingle` | `(ray: Ray, level: RayQueryLevel, maxDistance: number, drawableFlags: number -- unsigned char, viewMask?: integer) -> RayQueryResult` |  |
| `GetNumLevels` | `() -> integer` |  |
| `QueueUpdate` | `(drawable: Drawable)` |  |
| `DrawDebugGeometry` | `(depthTest: boolean)` |  |


### OctreeQueryResult

**构造**

```lua
fun(): OctreeQueryResult
```

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `drawable` | Drawable |  |
| `node` | Node |  |


### RayQueryResult

**构造**

```lua
fun(): RayQueryResult
```

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `position` | Vector3 |  |
| `normal` | Vector3 |  |
| `textureUV` | Vector2 |  |
| `distance` | number |  |
| `drawable` | Drawable |  |
| `node` | Node |  |
| `subObject` | integer |  |


### OffMeshConnection  `: Component`

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `endPoint` | Node |  |
| `radius` | number |  |
| `bidirectional` | boolean |  |
| `mask` | integer |  |
| `areaID` | integer |  |

**方法（10）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetEndPoint` | `(node: Node)` |  |
| `SetRadius` | `(radius: number)` |  |
| `SetBidirectional` | `(enabled: boolean)` |  |
| `SetMask` | `(newMask: integer)` |  |
| `SetAreaID` | `(newAreaID: integer)` |  |
| `GetEndPoint` | `() -> Node` |  |
| `GetRadius` | `() -> number` |  |
| `IsBidirectional` | `() -> boolean` |  |
| `GetMask` | `() -> integer` |  |
| `GetAreaID` | `() -> integer` |  |


### PackageEntry

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `offset` | integer |  |
| `size` | integer |  |
| `checksum` | integer |  |


### PackageFile  `: Object`

**构造**

```lua
fun(fileName: string, mode?: PackageIOMode, startOffset?: integer): PackageFile
fun(): PackageFile
fun(self: PackageFile, fileName: string, mode?: PackageIOMode, startOffset?: integer): PackageFile
fun(fileName: string, mode?: PackageIOMode, startOffset?: integer): PackageFile
```

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | string |  |
| `nameHash` | StringHash|string |  |
| `numFiles` | integer |  |
| `totalSize` | integer |  |
| `totalDataSize` | integer |  |
| `checksum` | integer |  |
| `compressed` | boolean |  |

**方法（10）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Open` | `(fileName: string, mode?: PackageIOMode, startOffset?: integer) -> boolean` |  |
| `Exists` | `(fileName: string) -> boolean` |  |
| `GetEntry` | `(fileName: string) -> PackageEntry` |  |
| `GetName` | `() -> string` |  |
| `GetNameHash` | `() -> StringHash|string` |  |
| `GetNumFiles` | `() -> integer` |  |
| `GetTotalSize` | `() -> integer` |  |
| `GetTotalDataSize` | `() -> integer` |  |
| `GetChecksum` | `() -> integer` |  |
| `IsCompressed` | `() -> boolean` |  |


### PaintBrush

**构造**

```lua
fun(): PaintBrush
```

**属性（10）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `radiusUV` | number |  |
| `radiusWorld` | number |  |
| `strength` | number |  |
| `paintColor` | Color |  |
| `colorOpacity` | number |  |
| `metallic` | number |  |
| `roughness` | number |  |
| `metallicOpacity` | number |  |
| `roughnessOpacity` | number |  |
| `blendMode` | PaintBlendMode |  |


### PaintRaycastHit

**构造**

```lua
fun(): PaintRaycastHit
```

**属性（9）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `hit` | boolean |  |
| `position` | Vector3 |  |
| `normal` | Vector3 |  |
| `uv` | Vector2 |  |
| `barycentric` | Vector3 |  |
| `distance` | number |  |
| `geometryIndex` | integer |  |
| `primitiveIndex` | integer |  |
| `paintSurfaceIndex` | integer |  |


### Paintable  `: Component`

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `paintResolution` | integer |  |
| `targetDrawable` | Drawable |  |

**方法（9）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetPaintResolution` | `(resolution: integer)` |  |
| `GetPaintResolution` | `() -> integer` |  |
| `GetTargetDrawable` | `() -> Drawable` |  |
| `GetPaintMap` | `(paintSurfaceIndex?: integer) -> Texture2DArray` |  |
| `RaycastUV` | `(worldRay: Ray, maxDistance?: number) -> PaintRaycastHit` |  |
| `PaintAtUV` | `(paintSurfaceIndex: integer, uv: Vector2, brush: PaintBrush) -> boolean` |  |
| `PaintAtRay` | `(worldRay: Ray, brush: PaintBrush, maxDistance?: number) -> boolean` |  |
| `ClearPaint` | `(paintSurfaceIndex?: integer) -> boolean` |  |
| `CommitDirtyPaintMaps` | `() -> boolean` |  |


### ParameterContext  `: Object`

**方法（16）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `DefineParameter` | `(name: string, type: AnimParamType, defaultValue?: Variant, minValue?: number, maxValue?: number)` |  |
| `HasParameter` | `(name: string) -> boolean` |  |
| `SetFloat` | `(name: string, value: number)` |  |
| `SetInt` | `(name: string, value: integer)` |  |
| `SetBool` | `(name: string, value: boolean)` |  |
| `SetTrigger` | `(name: string)` |  |
| `GetFloat` | `(name: string) -> number` |  |
| `GetInt` | `(name: string) -> integer` |  |
| `GetBool` | `(name: string) -> boolean` |  |
| `IsTriggerActivated` | `(name: string) -> boolean` |  |
| `SetValue` | `(name: string, value: Variant)` |  |
| `GetValue` | `(name: string) -> Variant` |  |
| `Clear` | `()` |  |
| `ResetToDefaults` | `()` |  |
| `ResetTriggers` | `()` |  |
| `DebugPrint` | `()` |  |


### ColorFrame

**构造**

```lua
fun(color: Color): ColorFrame
fun(color: Color, time: number): ColorFrame
fun(): ColorFrame
fun(self: ColorFrame, color: Color): ColorFrame
fun(color: Color): ColorFrame
fun(self: ColorFrame, color: Color, time: number): ColorFrame
fun(color: Color, time: number): ColorFrame
```

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `color` | Color |  |
| `time` | number |  |

**方法（1）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Interpolate` | `(next: ColorFrame, time: number) -> Color` |  |


### TextureFrame

**构造**

```lua
fun(): TextureFrame
```

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `uv` | Rect |  |
| `time` | number |  |


### ParticleEffect  `: Resource`

**构造**

```lua
fun(): ParticleEffect
```

**属性（32）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `material` | Material |  |
| `numParticles` | integer |  |
| `updateInvisible` | boolean |  |
| `relative` | boolean |  |
| `scaled` | boolean |  |
| `sorted` | boolean |  |
| `fixedScreenSize` | boolean |  |
| `animationLodBias` | number |  |
| `emitterType` | EmitterType |  |
| `emitterSize` | Vector3 |  |
| `minDirection` | Vector3 |  |
| `maxDirection` | Vector3 |  |
| `constantForce` | Vector3 |  |
| `dampingForce` | number |  |
| `activeTime` | number |  |
| `inactiveTime` | number |  |
| `minEmissionRate` | number |  |
| `maxEmissionRate` | number |  |
| `minParticleSize` | Vector2 |  |
| `maxParticleSize` | Vector2 |  |
| `minTimeToLive` | number |  |
| `maxTimeToLive` | number |  |
| `minVelocity` | number |  |
| `maxVelocity` | number |  |
| `minRotation` | number |  |
| `maxRotation` | number |  |
| `minRotationSpeed` | number |  |
| `maxRotationSpeed` | number |  |
| `sizeAdd` | number |  |
| `sizeMul` | number |  |
| `numColorFrames` | integer |  |
| `numTextureFrames` | integer |  |

**方法（77）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetMaterial` | `(material: Material)` |  |
| `SetNumParticles` | `(num: integer)` |  |
| `SetUpdateInvisible` | `(enable: boolean)` |  |
| `SetRelative` | `(enable: boolean)` |  |
| `SetScaled` | `(enable: boolean)` |  |
| `SetSorted` | `(enable: boolean)` |  |
| `SetFixedScreenSize` | `(enable: boolean)` |  |
| `SetAnimationLodBias` | `(lodBias: number)` |  |
| `SetEmitterType` | `(type: EmitterType)` |  |
| `SetEmitterSize` | `(size: Vector3)` |  |
| `SetMinDirection` | `(direction: Vector3)` |  |
| `SetMaxDirection` | `(direction: Vector3)` |  |
| `SetConstantForce` | `(force: Vector3)` |  |
| `SetDampingForce` | `(force: number)` |  |
| `SetActiveTime` | `(time: number)` |  |
| `SetInactiveTime` | `(time: number)` |  |
| `SetMinEmissionRate` | `(rate: number)` |  |
| `SetMaxEmissionRate` | `(rate: number)` |  |
| `SetMinParticleSize` | `(size: Vector2)` |  |
| `SetMaxParticleSize` | `(size: Vector2)` |  |
| `SetMinTimeToLive` | `(time: number)` |  |
| `SetMaxTimeToLive` | `(time: number)` |  |
| `SetMinVelocity` | `(velocity: number)` |  |
| `SetMaxVelocity` | `(velocity: number)` |  |
| `SetMinRotation` | `(rotation: number)` |  |
| `SetMaxRotation` | `(rotation: number)` |  |
| `SetMinRotationSpeed` | `(speed: number)` |  |
| `SetMaxRotationSpeed` | `(speed: number)` |  |
| `SetSizeAdd` | `(sizeAdd: number)` |  |
| `SetSizeMul` | `(sizeMul: number)` |  |
| `AddColorTime` | `(color: Color, time: number)` |  |
| `AddColorFrame` | `(colorFrame: ColorFrame)` |  |
| `RemoveColorFrame` | `(index: integer)` |  |
| `SetColorFrame` | `(index: integer, colorFrame: ColorFrame)` |  |
| `SetNumColorFrames` | `(number: integer)` |  |
| `SortColorFrames` | `()` |  |
| `AddTextureTime` | `(uv: Rect, time: number)` |  |
| `AddTextureFrame` | `(textureFrame: TextureFrame)` |  |
| `RemoveTextureFrame` | `(index: integer)` |  |
| `SetTextureFrame` | `(index: integer, textureFrame: TextureFrame)` |  |
| `SetNumTextureFrames` | `(number: integer)` |  |
| `SortTextureFrames` | `()` |  |
| `Clone` | `(cloneName?: string) -> ParticleEffect` |  |
| `GetMaterial` | `() -> Material` |  |
| `GetNumParticles` | `() -> integer` |  |
| `GetUpdateInvisible` | `() -> boolean` |  |
| `IsRelative` | `() -> boolean` |  |
| `IsScaled` | `() -> boolean` |  |
| `IsSorted` | `() -> boolean` |  |
| `IsFixedScreenSize` | `() -> boolean` |  |
| `GetAnimationLodBias` | `() -> number` |  |
| `GetEmitterType` | `() -> EmitterType` |  |
| `GetEmitterSize` | `() -> Vector3` |  |
| `GetMinDirection` | `() -> Vector3` |  |
| `GetMaxDirection` | `() -> Vector3` |  |
| `GetConstantForce` | `() -> Vector3` |  |
| `GetDampingForce` | `() -> number` |  |
| `GetActiveTime` | `() -> number` |  |
| `GetInactiveTime` | `() -> number` |  |
| `GetMinEmissionRate` | `() -> number` |  |
| `GetMaxEmissionRate` | `() -> number` |  |
| `GetMinParticleSize` | `() -> Vector2` |  |
| `GetMaxParticleSize` | `() -> Vector2` |  |
| `GetMinTimeToLive` | `() -> number` |  |
| `GetMaxTimeToLive` | `() -> number` |  |
| `GetMinVelocity` | `() -> number` |  |
| `GetMaxVelocity` | `() -> number` |  |
| `GetMinRotation` | `() -> number` |  |
| `GetMaxRotation` | `() -> number` |  |
| `GetMinRotationSpeed` | `() -> number` |  |
| `GetMaxRotationSpeed` | `() -> number` |  |
| `GetSizeAdd` | `() -> number` |  |
| `GetSizeMul` | `() -> number` |  |
| `GetNumColorFrames` | `() -> integer` |  |
| `GetColorFrame` | `(index: integer) -> ColorFrame` |  |
| `GetNumTextureFrames` | `() -> integer` |  |
| `GetTextureFrame` | `(index: integer) -> TextureFrame` |  |


### ParticleEffect2D  `: Resource`

**方法（1）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Clone` | `(cloneName?: string) -> ParticleEffect2D` |  |


### ParticleEmitter  `: BillboardSet`

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `effect` | ParticleEffect |  |
| `numParticles` | integer |  |
| `emitting` | boolean |  |
| `serializeParticles` | boolean |  |
| `autoRemoveMode` | AutoRemoveMode |  |

**方法（14）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetEffect` | `(effect: ParticleEffect)` |  |
| `SetNumParticles` | `(num: integer)` |  |
| `SetEmitting` | `(enable: boolean)` |  |
| `SetSerializeParticles` | `(enable: boolean)` |  |
| `SetAutoRemoveMode` | `(mode: AutoRemoveMode)` |  |
| `ResetEmissionTimer` | `()` |  |
| `RemoveAllParticles` | `()` |  |
| `Reset` | `()` |  |
| `ApplyEffect` | `()` |  |
| `GetEffect` | `() -> ParticleEffect` |  |
| `GetNumParticles` | `() -> integer` |  |
| `IsEmitting` | `() -> boolean` |  |
| `GetSerializeParticles` | `() -> boolean` |  |
| `GetAutoRemoveMode` | `() -> AutoRemoveMode` |  |


### ParticleEmitter2D  `: Drawable2D`

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `effect` | ParticleEffect2D |  |
| `sprite` | Sprite2D |  |
| `blendMode` | BlendMode |  |
| `emitting` | boolean |  |

**方法（8）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetEffect` | `(effect: ParticleEffect2D)` |  |
| `SetSprite` | `(sprite: Sprite2D)` |  |
| `SetBlendMode` | `(blendMode: BlendMode)` |  |
| `SetEmitting` | `(emitting: boolean)` |  |
| `GetEffect` | `() -> ParticleEffect2D` |  |
| `GetSprite` | `() -> Sprite2D` |  |
| `GetBlendMode` | `() -> BlendMode` |  |
| `IsEmitting` | `() -> boolean` |  |


### PhysicsRaycastResult

**构造**

```lua
fun(): PhysicsRaycastResult
```

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `position` | Vector3 |  |
| `normal` | Vector3 |  |
| `distance` | number |  |
| `hitFraction` | number |  |
| `body` | RigidBody |  |


### PhysicsWorld  `: Component`

**构造**

```lua
fun(): PhysicsWorld
```

**属性（9）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `gravity` | Vector3 |  |
| `maxSubSteps` | integer |  |
| `numIterations` | integer |  |
| `updateEnabled` | boolean |  |
| `interpolation` | boolean |  |
| `internalEdge` | boolean |  |
| `splitImpulse` | boolean |  |
| `fps` | integer |  |
| `maxNetworkAngularVelocity` | number |  |

**方法（29）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Update` | `(timeStep: number)` |  |
| `UpdateCollisions` | `()` |  |
| `SetFps` | `(fps: integer)` |  |
| `SetGravity` | `(gravity: Vector3)` |  |
| `SetMaxSubSteps` | `(num: integer)` |  |
| `SetNumIterations` | `(num: integer)` |  |
| `SetUpdateEnabled` | `(enable: boolean)` |  |
| `SetInterpolation` | `(enable: boolean)` |  |
| `SetInternalEdge` | `(enable: boolean)` |  |
| `SetSplitImpulse` | `(enable: boolean)` |  |
| `SetMaxNetworkAngularVelocity` | `(velocity: number)` |  |
| `Raycast` | `(ray: Ray, maxDistance: number, collisionMask?: integer) -> PhysicsRaycastResult[]` |  |
| `RaycastSingle` | `(ray: Ray, maxDistance: number, collisionMask?: integer) -> PhysicsRaycastResult` |  |
| `RaycastSingleSegmented` | `(ray: Ray, maxDistance: number, segmentDistance: number, collisionMask?: integer, overlapDistance?: number) -> PhysicsRaycastResult` |  |
| `SphereCast` | `(ray: Ray, radius: number, maxDistance: number, collisionMask?: integer) -> PhysicsRaycastResult` |  |
| `ConvexCast` | `(shape: CollisionShape, startPos: Vector3, startRot: Quaternion, endPos: Vector3, endRot: Quaternion, collisionMask?: integer) -> PhysicsRaycastResult` |  |
| `GetRigidBodies` | `(sphere: Sphere, collisionMask?: integer) -> RigidBody[]` |  |
| `GetCollidingBodies` | `(body: RigidBody) -> RigidBody[]` |  |
| `DrawDebugGeometry` | `(depthTest: boolean)` |  |
| `RemoveCachedGeometry` | `(model: Model)` |  |
| `GetGravity` | `() -> Vector3` |  |
| `GetMaxSubSteps` | `() -> integer` |  |
| `GetNumIterations` | `() -> integer` |  |
| `IsUpdateEnabled` | `() -> boolean` |  |
| `GetInterpolation` | `() -> boolean` |  |
| `GetInternalEdge` | `() -> boolean` |  |
| `GetSplitImpulse` | `() -> boolean` |  |
| `GetFps` | `() -> integer` |  |
| `GetMaxNetworkAngularVelocity` | `() -> number` |  |


### PhysicsRaycastResult2D

**构造**

```lua
fun(): PhysicsRaycastResult2D
```

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `position` | Vector2 |  |
| `normal` | Vector2 |  |
| `distance` | number |  |
| `body` | RigidBody2D |  |


### PhysicsWorld2D  `: Component`

**属性（14）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `updateEnabled` | boolean |  |
| `drawShape` | boolean |  |
| `drawJoint` | boolean |  |
| `drawAabb` | boolean |  |
| `drawPair` | boolean |  |
| `drawCenterOfMass` | boolean |  |
| `allowSleeping` | boolean |  |
| `warmStarting` | boolean |  |
| `continuousPhysics` | boolean |  |
| `subStepping` | boolean |  |
| `autoClearForces` | boolean |  |
| `gravity` | Vector2 |  |
| `velocityIterations` | integer |  |
| `positionIterations` | integer |  |

**方法（33）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `DrawDebugGeometry` | `()` |  |
| `SetUpdateEnabled` | `(enable: boolean)` |  |
| `SetDrawShape` | `(drawShape: boolean)` |  |
| `SetDrawJoint` | `(drawJoint: boolean)` |  |
| `SetDrawAabb` | `(drawAabb: boolean)` |  |
| `SetDrawPair` | `(drawPair: boolean)` |  |
| `SetDrawCenterOfMass` | `(drawCenterOfMass: boolean)` |  |
| `SetAllowSleeping` | `(enable: boolean)` |  |
| `SetWarmStarting` | `(enable: boolean)` |  |
| `SetContinuousPhysics` | `(enable: boolean)` |  |
| `SetSubStepping` | `(enable: boolean)` |  |
| `SetGravity` | `(gravity: Vector2)` |  |
| `SetAutoClearForces` | `(enable: boolean)` |  |
| `SetVelocityIterations` | `(velocityIterations: integer)` |  |
| `SetPositionIterations` | `(positionIterations: integer)` |  |
| `Raycast` | `(startPoint: Vector2, endPoint: Vector2, collisionMask?: integer) -> PhysicsRaycastResult2D[]` |  |
| `RaycastSingle` | `(startPoint: Vector2, endPoint: Vector2, collisionMask?: integer) -> PhysicsRaycastResult2D` |  |
| `GetRigidBody` | `(point: Vector2, collisionMask?: integer) -> RigidBody2D` |  |
| `GetRigidBodies` | `(aabb: Rect, collisionMask?: integer) -> RigidBody2D[]` |  |
| `IsUpdateEnabled` | `() -> boolean` |  |
| `GetDrawShape` | `() -> boolean` |  |
| `GetDrawJoint` | `() -> boolean` |  |
| `GetDrawAabb` | `() -> boolean` |  |
| `GetDrawPair` | `() -> boolean` |  |
| `GetDrawCenterOfMass` | `() -> boolean` |  |
| `GetAllowSleeping` | `() -> boolean` |  |
| `GetWarmStarting` | `() -> boolean` |  |
| `GetContinuousPhysics` | `() -> boolean` |  |
| `GetSubStepping` | `() -> boolean` |  |
| `GetAutoClearForces` | `() -> boolean` |  |
| `GetGravity` | `() -> Vector2` |  |
| `GetVelocityIterations` | `() -> integer` |  |
| `GetPositionIterations` | `() -> integer` |  |


### Plane

**构造**

```lua
fun(plane: Plane): Plane
fun(v0: Vector3, v1: Vector3, v2: Vector3): Plane
fun(normal: Vector3, point: Vector3): Plane
fun(plane: Vector4): Plane
fun(): Plane
fun(self: Plane, plane: Plane): Plane
fun(plane: Plane): Plane
fun(self: Plane, v0: Vector3, v1: Vector3, v2: Vector3): Plane
```

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `normal` | Vector3 |  |
| `absNormal` | Vector3 |  |
| `d` | number |  |
| `reflectionMatrix` | Matrix3x4 |  |
| `UP` | Plane |  |

**方法（8）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Define` | `(v0: Vector3, v1: Vector3, v2: Vector3)` |  |
| `Transform` | `(transform: Matrix3)` |  |
| `Project` | `(point: Vector3) -> Vector3` |  |
| `Distance` | `(point: Vector3) -> number` |  |
| `Reflect` | `(direction: Vector3) -> Vector3` |  |
| `ReflectionMatrix` | `() -> Matrix3x4` |  |
| `Transformed` | `(transform: Matrix3) -> Plane` |  |
| `ToVector4` | `() -> Vector4` |  |


### Polyhedron

**构造**

```lua
fun(polyhedron: Polyhedron): Polyhedron
fun(box: BoundingBox): Polyhedron
fun(frustum: Frustum): Polyhedron
fun(): Polyhedron
fun(self: Polyhedron, polyhedron: Polyhedron): Polyhedron
fun(polyhedron: Polyhedron): Polyhedron
fun(self: Polyhedron, box: BoundingBox): Polyhedron
fun(box: BoundingBox): Polyhedron
```

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `empty` | boolean |  |

**方法（7）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Define` | `(box: BoundingBox)` |  |
| `AddFace` | `(v0: Vector3, v1: Vector3, v2: Vector3)` |  |
| `Clip` | `(plane: Plane)` |  |
| `Clear` | `()` |  |
| `Transform` | `(transform: Matrix3)` |  |
| `Transformed` | `(transform: Matrix3) -> Polyhedron` |  |
| `Empty` | `() -> boolean` |  |


### ProceduralGeometry  `: RefCounted`

**方法（10）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetConvertHandedness` | `(enable: boolean)` |  |
| `SetDynamic` | `(enable: boolean)` |  |
| `SetShadowed` | `(enable: boolean)` |  |
| `SetGenerateTangents` | `(enable: boolean)` |  |
| `ToModel` | `() -> Model` |  |
| `FillCustomGeometry` | `(geometry: CustomGeometry) -> boolean` |  |
| `GetVertexCount` | `() -> integer` |  |
| `GetIndexCount` | `() -> integer` |  |
| `GetGroupCount` | `() -> integer` |  |
| `GetBoundingBox` | `() -> BoundingBox` |  |


### ProceduralSky  `: Component`

**属性（16）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `skyTopColor` | Color |  |
| `skyHorizonColor` | Color |  |
| `skyCurve` | number |  |
| `skyEnergy` | number |  |
| `groundBottomColor` | Color |  |
| `groundHorizonColor` | Color |  |
| `groundCurve` | number |  |
| `groundEnergy` | number |  |
| `sunAngleMax` | number |  |
| `sunCurve` | number |  |
| `sunDiskSize` | number |  |
| `sunEnergy` | number |  |
| `exposure` | number |  |
| `sunLight` | Light |  |
| `skybox` | Skybox |  |
| `material` | Material |  |

**方法（30）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetSkyTopColor` | `(color: Color Zenith color (sRGB))` |  |
| `SetSkyHorizonColor` | `(color: Color Sky color at the horizon (sRGB))` |  |
| `SetSkyCurve` | `(curve: number Horizon-to-top blend curve, > 0 (default 0.15))` |  |
| `SetSkyEnergy` | `(energy: number Multiplier of the sky colors (default 1))` |  |
| `SetGroundBottomColor` | `(color: Color Color straight down (sRGB))` |  |
| `SetGroundHorizonColor` | `(color: Color Ground color at the horizon (sRGB))` |  |
| `SetGroundCurve` | `(curve: number Horizon-to-bottom blend curve, > 0 (default 0.02))` |  |
| `SetGroundEnergy` | `(energy: number Multiplier of the ground colors (default 1))` |  |
| `SetSunAngleMax` | `(degrees: number Angular radius where the sun glow ends (default 30))` |  |
| `SetSunCurve` | `(curve: number Sun glow falloff curve, > 0 (default 0.15))` |  |
| `SetSunDiskSize` | `(degrees: number Apparent sun disc diameter (default 0.5))` |  |
| `SetSunEnergy` | `(energy: number Sun radiance relative to the light's color * brightness (default 1))` |  |
| `SetExposure` | `(exposure: number Multiplier of the final sky color (default 1))` |  |
| `SetSunLight` | `(light: Light|nil Directional light)` | Follow this directional light's direction, color and brightness as the |
| `GetSkyTopColor` | `() -> Color` |  |
| `GetSkyHorizonColor` | `() -> Color` |  |
| `GetSkyCurve` | `() -> number` |  |
| `GetSkyEnergy` | `() -> number` |  |
| `GetGroundBottomColor` | `() -> Color` |  |
| `GetGroundHorizonColor` | `() -> Color` |  |
| `GetGroundCurve` | `() -> number` |  |
| `GetGroundEnergy` | `() -> number` |  |
| `GetSunAngleMax` | `() -> number` |  |
| `GetSunCurve` | `() -> number` |  |
| `GetSunDiskSize` | `() -> number` |  |
| `GetSunEnergy` | `() -> number` |  |
| `GetExposure` | `() -> number` |  |
| `GetSunLight` | `() -> Light` |  |
| `GetSkybox` | `() -> Skybox` | Skybox this component renders through. |
| `GetMaterial` | `() -> Material` | Built-in sky material; tweak other uniforms here only if you know the  |


### ProgressBar  `: BorderImage`

**构造**

```lua
fun(): ProgressBar
```

**属性（6）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `orientation` | Orientation |  |
| `range` | number |  |
| `value` | number |  |
| `knob` | BorderImage |  |
| `loadingPercentStyle` | string |  |
| `showPercentText` | boolean |  |

**方法（12）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetOrientation` | `(orientation: Orientation)` |  |
| `SetRange` | `(range: number)` |  |
| `SetValue` | `(value: number)` |  |
| `ChangeValue` | `(delta: number)` |  |
| `SetLoadingPercentStyle` | `(style: string)` |  |
| `SetShowPercentText` | `(showPercentText: boolean)` |  |
| `GetOrientation` | `() -> Orientation` |  |
| `GetRange` | `() -> number` |  |
| `GetValue` | `() -> number` |  |
| `GetKnob` | `() -> BorderImage` |  |
| `GetLoadingPercentStyle` | `() -> string` |  |
| `GetShowPercentText` | `() -> boolean` |  |


### Quaternion

**构造**

```lua
fun(quat: Quaternion): Quaternion
fun(w: number, x: number, y: number, z: number): Quaternion
fun(angle: number, axis: Vector3): Quaternion
fun(angle: number): Quaternion
fun(x: number, y: number, z: number): Quaternion
fun(start: Vector3, end: Vector3): Quaternion
fun(xAxis: Vector3, yAxis: Vector3, zAxis: Vector3): Quaternion
fun(matrix: Matrix3): Quaternion
```

**属性（15）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `w` | number |  |
| `x` | number |  |
| `y` | number |  |
| `z` | number |  |
| `lengthSquared` | number |  |
| `normalized` | Quaternion |  |
| `conjugate` | Quaternion |  |
| `eulerAngles` | Vector3 |  |
| `yawAngle` | number |  |
| `pitchAngle` | number |  |
| `rollAngle` | number |  |
| `axis` | Vector3 |  |
| `angle` | number |  |
| `rotationMatrix` | Matrix3 |  |
| `IDENTITY` | Quaternion |  |

**方法（24）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `FromAngleAxis` | `(angle: number, axis: Vector3)` |  |
| `FromEulerAngles` | `(x: number, y: number, z: number)` |  |
| `FromRotationTo` | `(start: Vector3, end_: Vector3)` |  |
| `FromAxes` | `(xAxis: Vector3, yAxis: Vector3, zAxis: Vector3)` |  |
| `FromRotationMatrix` | `(matrix: Matrix3)` |  |
| `FromLookRotation` | `(direction: Vector3, up?: Vector3) -> boolean` |  |
| `Normalize` | `()` |  |
| `Normalized` | `() -> Quaternion` |  |
| `Inverse` | `() -> Quaternion` |  |
| `LengthSquared` | `() -> number` |  |
| `DotProduct` | `(rhs: Quaternion) -> number` |  |
| `Equals` | `(rhs: Quaternion) -> boolean` |  |
| `IsNaN` | `() -> boolean` |  |
| `Conjugate` | `() -> Quaternion` |  |
| `EulerAngles` | `() -> Vector3` |  |
| `YawAngle` | `() -> number` |  |
| `PitchAngle` | `() -> number` |  |
| `RollAngle` | `() -> number` |  |
| `Axis` | `() -> Vector3` |  |
| `Angle` | `() -> number` |  |
| `RotationMatrix` | `() -> Matrix3` |  |
| `Slerp` | `(rhs: Quaternion, t: number) -> Quaternion` |  |
| `Nlerp` | `(rhs: Quaternion, t: number, shortestPath: boolean) -> Quaternion` |  |
| `ToString` | `() -> string` |  |

**运算符**：`eq(Quaternion): boolean`、`add(Quaternion): Quaternion`、`unm: Quaternion`、`sub(Quaternion): Quaternion`、`mul(number): Quaternion`、`mul(Quaternion): Quaternion`、`mul(Vector3): Vector3`


### Ray

**构造**

```lua
fun(origin: Vector3, direction: Vector3): Ray
fun(ray: Ray): Ray
fun(): Ray
fun(self: Ray, origin: Vector3, direction: Vector3): Ray
fun(origin: Vector3, direction: Vector3): Ray
fun(self: Ray, ray: Ray): Ray
fun(ray: Ray): Ray
```

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `origin` | Vector3 |  |
| `direction` | Vector3 |  |

**方法（6）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Define` | `(origin: Vector3, direction: Vector3)` |  |
| `Project` | `(point: Vector3) -> Vector3` |  |
| `Distance` | `(point: Vector3) -> number` |  |
| `ClosestPoint` | `(ray: Ray) -> Vector3` |  |
| `HitDistance` | `(plane: Plane) -> number` |  |
| `Transformed` | `(transform: Matrix3x4) -> Ray` |  |

**运算符**：`eq(Ray): boolean`


### LogicComponent  `: Component`


### RaycastVehicle  `: LogicComponent`

**构造**

```lua
fun(): RaycastVehicle
```

**属性（6）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `RIGHT_UP_FORWARD` | IntVector3 |  |
| `RIGHT_FORWARD_UP` | IntVector3 |  |
| `UP_FORWARD_RIGHT` | IntVector3 |  |
| `UP_RIGHT_FORWARD` | IntVector3 |  |
| `FORWARD_RIGHT_UP` | IntVector3 |  |
| `FORWARD_UP_RIGHT` | IntVector3 |  |

**方法（52）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `RegisterObject` | `(context: Context)` |  |
| `ApplyAttributes` | `()` |  |
| `AddWheel` | `(wheelNode: Node, wheelDirection: Vector3, wheelAxle: Vector3, restLength: number, wheelRadius: number, frontWheel: boolean)` |  |
| `ResetSuspension` | `()` |  |
| `UpdateWheelTransform` | `(wheel: integer, interpolated: boolean)` |  |
| `SetSteeringValue` | `(wheel: integer, steeringValue: number)` |  |
| `SetWheelSuspensionStiffness` | `(wheel: integer, stiffness: number)` |  |
| `SetWheelDampingRelaxation` | `(wheel: integer, damping: number)` |  |
| `SetWheelDampingCompression` | `(wheel: integer, compression: number)` |  |
| `SetWheelFrictionSlip` | `(wheel: integer, slip: number)` |  |
| `SetWheelRollInfluence` | `(wheel: integer, rollInfluence: number)` |  |
| `SetEngineForce` | `(wheel: integer, force: number)` |  |
| `SetBrake` | `(wheel: integer, force: number)` |  |
| `SetWheelRadius` | `(wheel: integer, wheelRadius: number)` |  |
| `ResetWheels` | `()` |  |
| `SetWheelRestLength` | `(wheel: integer, length: number)` |  |
| `SetWheelSkidInfo` | `(wheel: integer, factor: number)` |  |
| `WheelIsGrounded` | `(wheel: integer) -> boolean` |  |
| `SetMaxSuspensionTravel` | `(wheel: integer, maxSuspensionTravel: number)` |  |
| `SetWheelDirection` | `(wheel: integer, direction: Vector3)` |  |
| `SetWheelAxle` | `(wheel: integer, axle: Vector3)` |  |
| `SetMaxSideSlipSpeed` | `(speed: number)` |  |
| `SetWheelSkidInfoCumulative` | `(wheel: integer, skid: number)` |  |
| `SetInAirRPM` | `(rpm: number)` |  |
| `SetCoordinateSystem` | `(coordinateSystem?: IntVector3)` |  |
| `Init` | `()` |  |
| `GetWheelPosition` | `(wheel: integer) -> Vector3` |  |
| `GetWheelRotation` | `(wheel: integer) -> Quaternion` |  |
| `GetWheelConnectionPoint` | `(wheel: integer) -> Vector3` |  |
| `GetNumWheels` | `() -> integer` |  |
| `GetSteeringValue` | `(wheel: integer) -> number` |  |
| `GetWheelSuspensionStiffness` | `(wheel: integer) -> number` |  |
| `GetWheelDampingRelaxation` | `(wheel: integer) -> number` |  |
| `GetWheelDampingCompression` | `(wheel: integer) -> number` |  |
| `GetWheelFrictionSlip` | `(wheel: integer) -> number` |  |
| `GetWheelRollInfluence` | `(wheel: integer) -> number` |  |
| `GetEngineForce` | `(wheel: integer) -> number` |  |
| `GetBrake` | `(wheel: integer) -> number` |  |
| `GetWheelRadius` | `(wheel: integer) -> number` |  |
| `GetWheelRestLength` | `(wheel: integer) -> number` |  |
| `GetWheelSkidInfo` | `(wheel: integer) -> number` |  |
| `GetMaxSuspensionTravel` | `(wheel: integer) -> number` |  |
| `GetWheelSideSlipSpeed` | `(wheel: integer) -> number` |  |
| `GetMaxSideSlipSpeed` | `() -> number` |  |
| `GetWheelSkidInfoCumulative` | `(wheel: integer) -> number` |  |
| `GetWheelDirection` | `(wheel: integer) -> Vector3` |  |
| `IsFrontWheel` | `(wheel: integer) -> boolean` |  |
| `GetWheelAxle` | `(wheel: integer) -> Vector3` |  |
| `GetContactPosition` | `(wheel: integer) -> Vector3` |  |
| `GetContactNormal` | `(wheel: integer) -> Vector3` |  |
| `GetInAirRPM` | `() -> number` |  |
| `GetCoordinateSystem` | `() -> IntVector3` |  |


### Rect

**构造**

```lua
fun(rect: Rect): Rect
fun(min: Vector2, max: Vector2): Rect
fun(left: number, top: number, right: number, bottom: number): Rect
fun(vector: Vector4): Rect
fun(): Rect
fun(self: Rect, rect: Rect): Rect
fun(rect: Rect): Rect
fun(self: Rect, min: Vector2, max: Vector2): Rect
```

**属性（8）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `min` | Vector2 |  |
| `max` | Vector2 |  |
| `FULL` | Rect |  |
| `POSITIVE` | Rect |  |
| `ZERO` | Rect |  |
| `center` | Vector2 |  |
| `size` | Vector2 |  |
| `halfSize` | Vector2 |  |

**方法（12）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Define` | `(rect: Rect)` |  |
| `Merge` | `(point: Vector2)` |  |
| `Clear` | `()` |  |
| `Clip` | `(rect: Rect)` |  |
| `Defined` | `() -> boolean` |  |
| `Center` | `() -> Vector2` |  |
| `Size` | `() -> Vector2` |  |
| `HalfSize` | `() -> Vector2` |  |
| `Equals` | `(rhs: Rect) -> boolean` |  |
| `IsInside` | `(point: Vector2) -> Intersection` |  |
| `ToVector4` | `() -> Vector4` |  |
| `ToString` | `() -> string` |  |

**运算符**：`eq(Rect): boolean`


### IntRect

**构造**

```lua
fun(left: integer, top: integer, right: integer, bottom: integer): IntRect
fun(min: IntVector2, max: IntVector2): IntRect
fun(): IntRect
fun(self: IntRect, left: integer, top: integer, right: integer, bottom: integer): IntRect
fun(left: integer, top: integer, right: integer, bottom: integer): IntRect
fun(self: IntRect, min: IntVector2, max: IntVector2): IntRect
fun(min: IntVector2, max: IntVector2): IntRect
```

**属性（8）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `left` | integer |  |
| `top` | integer |  |
| `right` | integer |  |
| `bottom` | integer |  |
| `ZERO` | IntRect |  |
| `size` | IntVector2 |  |
| `width` | integer |  |
| `height` | integer |  |

**方法（6）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Size` | `() -> IntVector2` |  |
| `Width` | `() -> integer` |  |
| `Height` | `() -> integer` |  |
| `IsInside` | `(point: IntVector2) -> Intersection` |  |
| `Clip` | `(rect: IntRect)` |  |
| `Merge` | `(rect: IntRect)` |  |

**运算符**：`eq(IntRect): boolean`


### RenderTargetInfo

**构造**

```lua
fun(): RenderTargetInfo
```

**属性（13）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | string |  |
| `tag` | string |  |
| `format` | integer |  |
| `size` | Vector2 |  |
| `sizeMode` | RenderTargetSizeMode |  |
| `multiSample` | integer |  |
| `autoResolve` | boolean |  |
| `enabled` | boolean |  |
| `cubemap` | boolean |  |
| `filtered` | boolean |  |
| `sRGB` | boolean |  |
| `persistent` | boolean |  |
| `roundUpSize` | boolean |  |

**方法（1）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Load` | `(element: XMLElement)` |  |


### RenderPathCommand

**构造**

```lua
fun(): RenderPathCommand
```

**属性（23）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `tag` | string |  |
| `type` | RenderCommandType |  |
| `role` | RenderCommandRole |  |
| `temporalShadowContract` | TemporalShadowContract |  |
| `resolveDepth` | boolean |  |
| `sortMode` | RenderCommandSortMode |  |
| `pass` | string |  |
| `metadata` | string |  |
| `vertexShaderName` | string |  |
| `pixelShaderName` | string |  |
| `vertexShaderDefines` | string |  |
| `pixelShaderDefines` | string |  |
| `clearFlags` | integer |  |
| `clearColor` | Color |  |
| `clearDepth` | number |  |
| `clearStencil` | integer |  |
| `blendMode` | BlendMode |  |
| `enabled` | boolean |  |
| `useFogColor` | boolean |  |
| `markToStencil` | boolean |  |
| `useLitBase` | boolean |  |
| `vertexLights` | boolean |  |
| `eventName` | string |  |

**方法（18）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Load` | `(element: XMLElement)` |  |
| `SetTextureName` | `(unit: TextureUnit, name: string)` |  |
| `SetInput` | `(semantic: string, name: string, type?: RenderPathInputType, optional?: boolean)` |  |
| `RemoveInput` | `(semantic: string)` |  |
| `SetConditionalShaderDefines` | `(condition: string, vsDefines: string, psDefines: string)` |  |
| `SetShaderParameter` | `(name: string, value: Variant)` |  |
| `RemoveShaderParameter` | `(name: string)` |  |
| `SetNumOutputs` | `(num: integer)` |  |
| `SetOutput` | `(index: integer, name: string, face: CubeMapFace)` |  |
| `SetOutputName` | `(index: integer, name: string)` |  |
| `SetOutputFace` | `(index: integer, face: CubeMapFace)` |  |
| `SetDepthStencilName` | `(name: string)` |  |
| `GetTextureName` | `(unit: TextureUnit) -> string` |  |
| `GetShaderParameter` | `(name: string) -> Variant` |  |
| `GetNumOutputs` | `() -> integer` |  |
| `GetOutputName` | `(index: integer) -> string` |  |
| `GetOutputFace` | `(index: integer) -> CubeMapFace` |  |
| `GetDepthStencilName` | `() -> string` |  |


### RenderPath

**方法（21）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Clone` | `() -> RenderPath` |  |
| `Load` | `(file: XMLFile) -> boolean` |  |
| `Append` | `(file: XMLFile) -> boolean` |  |
| `SetEnabled` | `(tag: string, active: boolean)` |  |
| `IsEnabled` | `(tag: string) -> boolean` |  |
| `IsAdded` | `(tag: string) -> boolean` |  |
| `ToggleEnabled` | `(tag: string)` |  |
| `SetRenderTarget` | `(index: integer, info: RenderTargetInfo)` |  |
| `AddRenderTarget` | `(info: RenderTargetInfo)` |  |
| `RemoveRenderTarget` | `(name: string)` |  |
| `RemoveRenderTargets` | `(tag: string)` |  |
| `SetCommand` | `(index: integer, command: RenderPathCommand)` |  |
| `AddCommand` | `(command: RenderPathCommand)` |  |
| `InsertCommand` | `(index: integer, command: RenderPathCommand)` |  |
| `RemoveCommand` | `(index: integer)` |  |
| `RemoveCommands` | `(tag: string)` |  |
| `SetShaderParameter` | `(name: string, value: Variant)` |  |
| `GetNumRenderTargets` | `() -> integer` |  |
| `GetNumCommands` | `() -> integer` |  |
| `GetCommand` | `(index: integer) -> RenderPathCommand` |  |
| `GetShaderParameter` | `(name: string) -> Variant` |  |


### RenderSurface

**构造**

```lua
fun(parentTexture: Texture): RenderSurface
fun(): RenderSurface
fun(self: RenderSurface, parentTexture: Texture): RenderSurface
fun(parentTexture: Texture): RenderSurface
```

**属性（9）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `parentTexture` | Texture |  |
| `width` | integer |  |
| `height` | integer |  |
| `usage` | TextureUsage |  |
| `numViewports` | integer |  |
| `updateMode` | RenderSurfaceUpdateMode |  |
| `linkedRenderTarget` | RenderSurface |  |
| `linkedDepthStencil` | RenderSurface |  |
| `resolveDirty` | boolean |  |

**方法（17）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetNumViewports` | `(num: integer)` |  |
| `SetViewport` | `(index: integer, viewport: Viewport)` |  |
| `SetUpdateMode` | `(mode: RenderSurfaceUpdateMode)` |  |
| `SetLinkedRenderTarget` | `(renderTarget: RenderSurface)` |  |
| `SetLinkedDepthStencil` | `(depthStencil: RenderSurface)` |  |
| `QueueUpdate` | `()` |  |
| `Release` | `()` |  |
| `GetParentTexture` | `() -> Texture` |  |
| `GetWidth` | `() -> integer` |  |
| `GetHeight` | `() -> integer` |  |
| `GetUsage` | `() -> TextureUsage` |  |
| `GetNumViewports` | `() -> integer` |  |
| `GetViewport` | `(index: integer) -> Viewport` |  |
| `GetUpdateMode` | `() -> RenderSurfaceUpdateMode` |  |
| `GetLinkedRenderTarget` | `() -> RenderSurface` |  |
| `GetLinkedDepthStencil` | `() -> RenderSurface` |  |
| `IsResolveDirty` | `() -> boolean` |  |


### Renderer

**属性（38）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `numViewports` | integer |  |
| `defaultRenderPath` | RenderPath |  |
| `defaultTechnique` | Technique |  |
| `hdrRendering` | boolean |  |
| `specularLighting` | boolean |  |
| `drawShadows` | boolean |  |
| `textureAnisotropy` | integer |  |
| `textureFilterMode` | TextureFilterMode |  |
| `textureQuality` | MaterialQuality |  |
| `materialQuality` | MaterialQuality |  |
| `shadowMapSize` | integer |  |
| `shadowQuality` | ShadowQuality |  |
| `shadowSoftness` | number |  |
| `vsmMultiSample` | integer |  |
| `reuseShadowMaps` | boolean |  |
| `temporalShadows` | boolean |  |
| `temporalShadowMaxAtlases` | integer |  |
| `temporalShadowMaxBytes` | integer |  |
| `temporalShadowFarUpdates` | integer |  |
| `maxShadowMaps` | integer |  |
| `dynamicInstancing` | boolean |  |
| `numExtraInstancingBufferElements` | integer |  |
| `minInstances` | integer |  |
| `maxSortedInstances` | integer |  |
| `maxOccluderTriangles` | integer |  |
| `occlusionBufferSize` | integer |  |
| `occluderSizeThreshold` | number |  |
| `threadedOcclusion` | boolean |  |
| `mobileShadowBiasMul` | number |  |
| `mobileShadowBiasAdd` | number |  |
| `mobileNormalOffsetMul` | number |  |
| `numViews` | integer |  |
| `numPrimitives` | integer |  |
| `numBatches` | integer |  |
| `defaultZone` | Zone |  |
| `defaultMaterial` | Material |  |
| `defaultLightRamp` | Texture2D |  |
| `defaultLightSpot` | Texture2D |  |

**方法（114）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `DumpSkyAtmosphereLuts` | `(scene: Scene, pathPrefix: string) -> boolean` | Dump ready atmosphere LUTs as raw float DDS files asynchronously; the  |
| `SetNumViewports` | `(num: integer)` |  |
| `SetViewport` | `(index: integer, viewport: Viewport)` |  |
| `SetDefaultRenderPath` | `(renderPath: RenderPath)` |  |
| `SetDefaultTechnique` | `(technique: Technique)` |  |
| `SetHDRRendering` | `(enable: boolean)` |  |
| `SetSpecularLighting` | `(enable: boolean)` |  |
| `SetTextureAnisotropy` | `(level: integer)` |  |
| `SetTextureFilterMode` | `(mode: TextureFilterMode)` |  |
| `SetTextureQuality` | `(quality: MaterialQuality)` |  |
| `SetMaterialQuality` | `(quality: MaterialQuality)` |  |
| `SetDrawShadows` | `(enable: boolean)` |  |
| `SetClusterLocalShadowsEnabled` | `(enable: boolean)` | Enable clustered spot/point shadows for surfaces and froxel fog. Defau |
| `SetClusterLocalShadowCacheEnabled` | `(enable: boolean)` | Enable reuse of unchanged clustered local shadow maps. Defaults to tru |
| `SetClusterLocalShadowMaxLights` | `(maxLights: integer)` | Set the per-View clustered local shadow light limit. Defaults to 8 on  |
| `SetClusterLocalShadowMaxFaces` | `(maxFaces: integer)` | Set the per-View clustered local shadow face limit. Defaults to 48 on  |
| `SetShadowMapSize` | `(size: integer)` |  |
| `SetShadowQuality` | `(quality: ShadowQuality)` |  |
| `SetShadowSoftness` | `(shadowSoftness: number)` |  |
| `SetVSMShadowParameters` | `(minVariance: number, lightBleedingReduction: number)` |  |
| `SetVSMMultiSample` | `(multiSample: integer)` |  |
| `SetReuseShadowMaps` | `(enable: boolean)` |  |
| `SetTemporalShadows` | `(enable: boolean)` | Set the global temporal-shadow kill switch; lights remain opt-in. |
| `GetTemporalShadows` | `() -> boolean` | Return the current temporal shadows setting. |
| `SetTemporalShadowMaxAtlases` | `(count: integer)` | Set the persistent atlas limit in 0..2, effective at the next frame bo |
| `GetTemporalShadowMaxAtlases` | `() -> integer` | Return the current temporal shadow max atlases setting. |
| `SetTemporalShadowMaxBytes` | `(bytes: integer)` | Set the persistent atlas budget in 0..268435456 bytes. Defaults to 134 |
| `GetTemporalShadowMaxBytes` | `() -> integer` | Return the current temporal shadow max bytes setting. |
| `GetNumTemporalShadowAtlases` | `() -> integer` | Return the resident persistent directional atlas count. |
| `GetTemporalShadowMemoryUse` | `() -> integer` | Return accounted persistent atlas bytes, excluding ordinary maps and s |
| `GetTemporalShadowStatistics` | `() -> Vector4` | Return scheduled, reused, hard-required tile counts and executed caste |
| `GetTemporalShadowDirtyStatistics` | `() -> Vector4` | Return examined dirty regions per atlas, marked cascades, dirty-priori |
| `SetTemporalShadowFarUpdates` | `(count: integer)` | Set the shared normal far-cascade update budget per prepared view in 0 |
| `GetTemporalShadowFarUpdates` | `() -> integer` | Return the current temporal shadow far updates setting. |
| `SetTemporalShadowFilter` | `(enable: boolean)` | Enable independent full-resolution temporal PCF visibility for each el |
| `GetTemporalShadowFilter` | `() -> boolean` | Return whether the independent deferred visibility filter is requested |
| `SetTemporalShadowHistoryBytes` | `(bytes: integer)` | Set the total screen-history budget shared by all Views in 0..26843545 |
| `GetTemporalShadowHistoryBytes` | `() -> integer` | Return the total full-resolution screen-history byte budget shared by  |
| `GetTemporalShadowFilterStatistics` | `() -> Vector4` | Return total allocated bytes, successful resolves, resets and fallback |
| `SetMaxShadowMaps` | `(shadowMaps: integer)` |  |
| `SetDynamicInstancing` | `(enable: boolean)` |  |
| `SetNumExtraInstancingBufferElements` | `(elements: integer)` |  |
| `SetMinInstances` | `(instances: integer)` |  |
| `SetMaxSortedInstances` | `(instances: integer)` |  |
| `SetMaxOccluderTriangles` | `(triangles: integer)` |  |
| `SetOcclusionBufferSize` | `(size: integer)` |  |
| `SetOccluderSizeThreshold` | `(screenSize: number)` |  |
| `SetThreadedOcclusion` | `(enable: boolean)` |  |
| `SetMobileShadowBiasMul` | `(mul: number)` |  |
| `SetMobileShadowBiasAdd` | `(add: number)` |  |
| `SetMobileNormalOffsetMul` | `(mul: number)` |  |
| `SetVolumetricFogFroxelEnabled` | `(enable: boolean)` |  |
| `SetVolumetricFogConservativeDepthEnabled` | `(enable: boolean)` |  |
| `SetVolumetricFogDebugMode` | `(mode: integer)` |  |
| `SetVolumetricFogGridPixelSize` | `(pixels: integer)` |  |
| `SetVolumetricFogGridSizeZ` | `(slices: integer)` |  |
| `SetVolumetricFogQuality` | `(quality: VolumetricFogQuality)` |  |
| `SetVolumetricFogHistoryWeight` | `(weight: number)` |  |
| `SetVolumetricFogLightSoftFading` | `(value: number)` |  |
| `ReloadShaders` | `()` |  |
| `GetNumViewports` | `() -> integer` |  |
| `GetViewport` | `(index: integer) -> Viewport` |  |
| `GetViewportForScene` | `(scene: Scene, index: integer) -> Viewport` |  |
| `GetDefaultRenderPath` | `() -> RenderPath` |  |
| `GetDefaultTechnique` | `() -> Technique` |  |
| `GetHDRRendering` | `() -> boolean` |  |
| `GetSpecularLighting` | `() -> boolean` |  |
| `GetDrawShadows` | `() -> boolean` |  |
| `GetClusterLocalShadowsEnabled` | `() -> boolean` | Return the requested clustered local shadow setting, before global and |
| `GetClusterLocalShadowCacheEnabled` | `() -> boolean` | Return whether reuse of unchanged clustered local shadow maps is enabl |
| `GetClusterLocalShadowMaxLights` | `() -> integer` | Return the requested per-View clustered local shadow light limit, befo |
| `GetClusterLocalShadowMaxFaces` | `() -> integer` | Return the requested per-View clustered local shadow face limit, inclu |
| `GetTextureAnisotropy` | `() -> integer` |  |
| `GetTextureFilterMode` | `() -> TextureFilterMode` |  |
| `GetTextureQuality` | `() -> MaterialQuality` |  |
| `GetMaterialQuality` | `() -> MaterialQuality` |  |
| `GetShadowMapSize` | `() -> integer` |  |
| `GetShadowQuality` | `() -> ShadowQuality` |  |
| `GetVolumetricFogFroxelEnabled` | `() -> boolean` |  |
| `GetVolumetricFogConservativeDepthEnabled` | `() -> boolean` |  |
| `GetVolumetricFogDebugMode` | `() -> integer` |  |
| `GetVolumetricFogGridPixelSize` | `() -> integer` |  |
| `GetVolumetricFogGridSizeZ` | `() -> integer` |  |
| `GetVolumetricFogQuality` | `() -> VolumetricFogQuality` |  |
| `GetVolumetricFogHistoryWeight` | `() -> number` |  |
| `GetVolumetricFogLightSoftFading` | `() -> number` |  |
| `GetShadowSoftness` | `() -> number` |  |
| `GetVSMShadowParameters` | `() -> Vector2` |  |
| `GetVSMMultiSample` | `() -> integer` |  |
| `GetReuseShadowMaps` | `() -> boolean` |  |
| `GetMaxShadowMaps` | `() -> integer` |  |
| `GetDynamicInstancing` | `() -> boolean` |  |
| `GetNumExtraInstancingBufferElements` | `() -> integer` |  |
| `GetMinInstances` | `() -> integer` |  |
| `GetMaxSortedInstances` | `() -> integer` |  |
| `GetMaxOccluderTriangles` | `() -> integer` |  |
| `GetOcclusionBufferSize` | `() -> integer` |  |
| `GetOccluderSizeThreshold` | `() -> number` |  |
| `GetThreadedOcclusion` | `() -> boolean` |  |
| `GetMobileShadowBiasMul` | `() -> number` |  |
| `GetMobileShadowBiasAdd` | `() -> number` |  |
| `GetMobileNormalOffsetMul` | `() -> number` |  |
| `GetNumViews` | `() -> integer` |  |
| `GetNumPrimitives` | `() -> integer` |  |
| `GetNumBatches` | `() -> integer` |  |
| `GetNumGeometries` | `(allViews?: boolean) -> integer` |  |
| `GetNumLights` | `(allViews?: boolean) -> integer` |  |
| `GetNumShadowMaps` | `(allViews?: boolean) -> integer` |  |
| `GetNumOccluders` | `(allViews?: boolean) -> integer` |  |
| `GetDefaultZone` | `() -> Zone` |  |
| `GetDefaultMaterial` | `() -> Material` |  |
| `GetDefaultLightRamp` | `() -> Texture2D` |  |
| `GetDefaultLightSpot` | `() -> Texture2D` |  |
| `DrawDebugGeometry` | `(depthTest: boolean)` |  |


### Renderer2D  `: Drawable`

**方法（3）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `AddDrawable` | `(drawable: Drawable2D)` |  |
| `RemoveDrawable` | `(drawable: Drawable2D)` |  |
| `GetMaterial` | `(texture: Texture2D, blendMode: BlendMode) -> Material` |  |


### ResourceCache

**属性（8）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `totalMemoryUse` | integer |  |
| `autoReloadResources` | boolean |  |
| `returnFailedResources` | boolean |  |
| `searchPackagesFirst` | boolean |  |
| `numBackgroundLoadResources` | integer |  |
| `resourceDirs` | string[] |  |
| `finishBackgroundResourcesMs` | integer |  |
| `GetResource` | __union_func__type_str__name_str__sendEventOnFailure_bool_opt__ret_ResourceT |  |

**方法（41）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `AddResourceDir` | `(pathName: string, append?: boolean) -> boolean` |  |
| `ReleaseAllResources` | `(force?: boolean)` |  |
| `ReloadResource` | `(resource: Resource) -> boolean` |  |
| `ReloadResourceWithDependencies` | `(fileName: string)` |  |
| `SetMemoryBudget` | `(type: StringHash|string, budget: integer)` |  |
| `SetAutoReloadResources` | `(enable: boolean)` |  |
| `SetReturnFailedResources` | `(enable: boolean)` |  |
| `SetSearchPackagesFirst` | `(value: boolean)` |  |
| `SetFinishBackgroundResourcesMs` | `(ms: integer)` |  |
| `GetFile` | `(name: string) -> File` |  |
| `GetResourceAsyncEx` | `(type: string, name: string, sendEventOnFailure?: boolean) -> Resource` |  |
| `GetExistingResource` | `(type: string, name: string) -> Resource` |  |
| `BackgroundLoadResource` | `(type: string, name: string, sendEventOnFailure?: boolean) -> boolean` |  |
| `GetNumBackgroundLoadResources` | `() -> integer` |  |
| `GetResourceDirs` | `() -> string[]` |  |
| `Exists` | `(name: string) -> boolean` |  |
| `GetMemoryBudget` | `(type: StringHash|string) -> integer` |  |
| `GetMemoryUse` | `(type: StringHash|string) -> integer` |  |
| `GetTotalMemoryUse` | `() -> integer` |  |
| `GetResourceFileName` | `(name: string) -> string` |  |
| `GetAutoReloadResources` | `() -> boolean` |  |
| `GetReturnFailedResources` | `() -> boolean` |  |
| `GetSearchPackagesFirst` | `() -> boolean` |  |
| `GetFinishBackgroundResourcesMs` | `() -> integer` |  |
| `GetPreferredResourceDir` | `(path: string) -> string` |  |
| `SanitateResourceName` | `(name: string) -> string` |  |
| `SanitateResourceDirName` | `(name: string) -> string` |  |
| `ReleaseResource` | `(type: string, name: string, force?: boolean)` |  |
| `GetResRefs` | `(uri: string Resource URI (uuid://, alias://, fs_path), includeSelf?: boolean Include the input URI(s) themselves (default false)) -> string[]  (+1 重载)` | Get recursive refs for a resource URI or array of URIs (merged, dedupl |
| `GetResInfo` | `(uri: string Resource URI) -> ResInfo|nil` | Get resource metadata |
| `GetResVirtualPath` | `(uri: string Resource URI) -> string` | Get fs_path (virtual path) for a resource URI |
| `GetResUuid` | `(uri: string Resource URI (fs_path, alias://, uuid://)) -> string` | Get raw UUID for a resource |
| `GetResUuidPath` | `(uri: string Resource URI (fs_path, alias://, uuid://)) -> string` | Get uuid:// path for a resource |
| `DownloadResource` | `(uri: string Resource URI (uuid://, alias://, fs_path), onComplete?: fun(success: boolean, errorMessage: string) Completion callback)` | Download a single resource |
| `DownloadResources` | `(uris: string[] Array of resource URIs, onComplete?: fun(success: boolean, failedCount: integer) Completion callback, onProgress?: fun(completed: integer, total: integer, downloadedBytes: number, totalBytes: number) Progress callback) -> integer` | Download multiple resources |
| `CancelDownload` | `(uri: string Resource URI) -> boolean` | Cancel a resource download |
| `CancelDownloadGroup` | `(groupId: integer Group ID from DownloadResources)` | Cancel a download group (returned by DownloadResources) |
| `GetDownloadState` | `(uri: string Resource URI) -> DownloadTaskState` | Get download state of a resource |
| `GetResourceAsync` | `(typeName: string Resource type name (e.g. "JSONFile", "XMLFile", "BinaryFile"), uri: string Resource URI (uuid://, alias://, fs_path), callback: fun(resource: Resource|nil) Completion callback)` | Async load a resource (download if needed, clear null-cache, then load |
| `ObserveDownloads` | `(onProgress: fun(completedCount: integer, totalCount: integer, completedBytes: number) Progress callback, onComplete?: fun(completedBytes: number) Called when activeCount reaches 0 (enables auto-end)) -> integer` | Start observing background download activity. Monitors activeCount cha |
| `StopObservingDownloads` | `(observerId: integer ID returned by ObserveDownloads)` | Stop observing downloads early (before activeCount reaches 0). |


### ResInfo


### RibbonTrail  `: Drawable`

**属性（15）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `material` | Material |  |
| `vertexDistance` | number |  |
| `width` | number |  |
| `startColor` | Color |  |
| `endColor` | Color |  |
| `startScale` | number |  |
| `endScale` | number |  |
| `trailType` | TrailType |  |
| `baseVelocity` | Vector3 |  |
| `sorted` | boolean |  |
| `lifetime` | number |  |
| `tailColumn` | integer |  |
| `emitting` | boolean |  |
| `updateInvisible` | boolean |  |
| `animationLodBias` | number |  |

**方法（31）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetMaterial` | `(material: Material)` |  |
| `SetVertexDistance` | `(length: number)` |  |
| `SetWidth` | `(width: number)` |  |
| `SetStartColor` | `(c: Color)` |  |
| `SetEndColor` | `(c: Color)` |  |
| `SetStartScale` | `(startScale: number)` |  |
| `SetEndScale` | `(endScale: number)` |  |
| `SetTrailType` | `(type: TrailType)` |  |
| `SetBaseVelocity` | `(baseVelocity: Vector3)` |  |
| `SetSorted` | `(enable: boolean)` |  |
| `SetLifetime` | `(time: number)` |  |
| `SetEmitting` | `(emitting: boolean)` |  |
| `SetUpdateInvisible` | `(updateInvisible: boolean)` |  |
| `SetTailColumn` | `(tailColumn: integer)` |  |
| `SetAnimationLodBias` | `(bias: number)` |  |
| `Commit` | `()` |  |
| `GetMaterial` | `() -> Material` |  |
| `GetVertexDistance` | `() -> number` |  |
| `GetWidth` | `() -> number` |  |
| `GetStartColor` | `() -> Color` |  |
| `GetEndColor` | `() -> Color` |  |
| `GetStartScale` | `() -> number` |  |
| `GetEndScale` | `() -> number` |  |
| `GetTrailType` | `() -> TrailType` |  |
| `GetBaseVelocity` | `() -> Vector3` |  |
| `IsSorted` | `() -> boolean` |  |
| `GetLifetime` | `() -> number` |  |
| `GetTailColumn` | `() -> integer` |  |
| `IsEmitting` | `() -> boolean` |  |
| `GetUpdateInvisible` | `() -> boolean` |  |
| `GetAnimationLodBias` | `() -> number` |  |


### RigidBody  `: Component`

**构造**

```lua
fun(): RigidBody
```

**属性（28）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `physicsWorld` | PhysicsWorld |  |
| `mass` | number |  |
| `position` | Vector3 |  |
| `rotation` | Quaternion |  |
| `linearVelocity` | Vector3 |  |
| `linearFactor` | Vector3 |  |
| `linearRestThreshold` | number |  |
| `linearDamping` | number |  |
| `angularVelocity` | Vector3 |  |
| `angularFactor` | Vector3 |  |
| `angularRestThreshold` | number |  |
| `angularDamping` | number |  |
| `friction` | number |  |
| `anisotropicFriction` | Vector3 |  |
| `rollingFriction` | number |  |
| `restitution` | number |  |
| `contactProcessingThreshold` | number |  |
| `ccdRadius` | number |  |
| `ccdMotionThreshold` | number |  |
| `useGravity` | boolean |  |
| `gravityOverride` | Vector3 |  |
| `centerOfMass` | Vector3 |  |
| `kinematic` | boolean |  |
| `trigger` | boolean |  |
| `active` | boolean |  |
| `collisionLayer` | integer |  |
| `collisionMask` | integer |  |
| `collisionEventMode` | CollisionEventMode |  |

**方法（65）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetMass` | `(mass: number)` |  |
| `SetPosition` | `(position: Vector3)` |  |
| `SetRotation` | `(rotation: Quaternion)` |  |
| `SetTransform` | `(position: Vector3, rotation: Quaternion)` |  |
| `SetLinearVelocity` | `(velocity: Vector3)` |  |
| `SetLinearFactor` | `(factor: Vector3)` |  |
| `SetLinearRestThreshold` | `(threshold: number)` |  |
| `SetLinearDamping` | `(damping: number)` |  |
| `SetAngularVelocity` | `(angularVelocity: Vector3)` |  |
| `SetAngularFactor` | `(factor: Vector3)` |  |
| `SetAngularRestThreshold` | `(threshold: number)` |  |
| `SetAngularDamping` | `(factor: number)` |  |
| `SetFriction` | `(friction: number)` |  |
| `SetAnisotropicFriction` | `(friction: Vector3)` |  |
| `SetRollingFriction` | `(friction: number)` |  |
| `SetRestitution` | `(restitution: number)` |  |
| `SetContactProcessingThreshold` | `(threshold: number)` |  |
| `SetCcdRadius` | `(radius: number)` |  |
| `SetCcdMotionThreshold` | `(threshold: number)` |  |
| `SetUseGravity` | `(enable: boolean)` |  |
| `SetGravityOverride` | `(gravity: Vector3)` |  |
| `SetKinematic` | `(enable: boolean)` |  |
| `SetTrigger` | `(enable: boolean)` |  |
| `SetCollisionLayer` | `(layer: integer)` |  |
| `SetCollisionMask` | `(mask: integer)` |  |
| `SetCollisionLayerAndMask` | `(layer: integer, mask: integer)` |  |
| `SetCollisionEventMode` | `(mode: CollisionEventMode)` |  |
| `DisableMassUpdate` | `()` |  |
| `EnableMassUpdate` | `()` |  |
| `ApplyForce` | `(force: Vector3)` |  |
| `ApplyTorque` | `(torque: Vector3)` |  |
| `ApplyImpulse` | `(impulse: Vector3)` |  |
| `ApplyTorqueImpulse` | `(torque: Vector3)` |  |
| `ResetForces` | `()` |  |
| `Activate` | `()` |  |
| `ReAddBodyToWorld` | `()` |  |
| `GetPhysicsWorld` | `() -> PhysicsWorld` |  |
| `GetMass` | `() -> number` |  |
| `GetPosition` | `() -> Vector3` |  |
| `GetRotation` | `() -> Quaternion` |  |
| `GetLinearVelocity` | `() -> Vector3` |  |
| `GetLinearFactor` | `() -> Vector3` |  |
| `GetVelocityAtPoint` | `(position: Vector3) -> Vector3` |  |
| `GetLinearRestThreshold` | `() -> number` |  |
| `GetLinearDamping` | `() -> number` |  |
| `GetAngularVelocity` | `() -> Vector3` |  |
| `GetAngularFactor` | `() -> Vector3` |  |
| `GetAngularRestThreshold` | `() -> number` |  |
| `GetAngularDamping` | `() -> number` |  |
| `GetFriction` | `() -> number` |  |
| `GetAnisotropicFriction` | `() -> Vector3` |  |
| `GetRollingFriction` | `() -> number` |  |
| `GetRestitution` | `() -> number` |  |
| `GetContactProcessingThreshold` | `() -> number` |  |
| `GetCcdRadius` | `() -> number` |  |
| `GetCcdMotionThreshold` | `() -> number` |  |
| `GetUseGravity` | `() -> boolean` |  |
| `GetGravityOverride` | `() -> Vector3` |  |
| `GetCenterOfMass` | `() -> Vector3` |  |
| `IsKinematic` | `() -> boolean` |  |
| `IsTrigger` | `() -> boolean` |  |
| `IsActive` | `() -> boolean` |  |
| `GetCollisionLayer` | `() -> integer` |  |
| `GetCollisionMask` | `() -> integer` |  |
| `GetCollisionEventMode` | `() -> CollisionEventMode` |  |


### RigidBody2D  `: Component`

**属性（14）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `bodyType` | BodyType2D |  |
| `mass` | number |  |
| `inertia` | number |  |
| `massCenter` | Vector2 |  |
| `useFixtureMass` | boolean |  |
| `linearDamping` | number |  |
| `angularDamping` | number |  |
| `allowSleep` | boolean |  |
| `fixedRotation` | boolean |  |
| `bullet` | boolean |  |
| `gravityScale` | number |  |
| `awake` | boolean |  |
| `linearVelocity` | Vector2 |  |
| `angularVelocity` | number |  |

**方法（34）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetBodyType` | `(bodyType: BodyType2D)` |  |
| `SetMass` | `(mass: number)` |  |
| `SetInertia` | `(inertia: number)` |  |
| `SetMassCenter` | `(center: Vector2)` |  |
| `SetUseFixtureMass` | `(useFixtureMass: boolean)` |  |
| `SetLinearDamping` | `(linearDamping: number)` |  |
| `SetAngularDamping` | `(angularDamping: number)` |  |
| `SetAllowSleep` | `(allowSleep: boolean)` |  |
| `SetFixedRotation` | `(fixedRotation: boolean)` |  |
| `SetBullet` | `(bullet: boolean)` |  |
| `SetGravityScale` | `(gravityScale: number)` |  |
| `SetAwake` | `(awake: boolean)` |  |
| `SetLinearVelocity` | `(linearVelocity: Vector2)` |  |
| `SetAngularVelocity` | `(angularVelocity: number)` |  |
| `ApplyForce` | `(force: Vector2, point: Vector2, wake: boolean)` |  |
| `ApplyForceToCenter` | `(force: Vector2, wake: boolean)` |  |
| `ApplyTorque` | `(torque: number, wake: boolean)` |  |
| `ApplyLinearImpulse` | `(impulse: Vector2, point: Vector2, wake: boolean)` |  |
| `ApplyLinearImpulseToCenter` | `(impulse: Vector2, wake: boolean)` |  |
| `ApplyAngularImpulse` | `(impulse: number, wake: boolean)` |  |
| `GetBodyType` | `() -> BodyType2D` |  |
| `GetMass` | `() -> number` |  |
| `GetInertia` | `() -> number` |  |
| `GetMassCenter` | `() -> Vector2` |  |
| `GetUseFixtureMass` | `() -> boolean` |  |
| `GetLinearDamping` | `() -> number` |  |
| `GetAngularDamping` | `() -> number` |  |
| `IsAllowSleep` | `() -> boolean` |  |
| `IsFixedRotation` | `() -> boolean` |  |
| `IsBullet` | `() -> boolean` |  |
| `GetGravityScale` | `() -> number` |  |
| `IsAwake` | `() -> boolean` |  |
| `GetLinearVelocity` | `() -> Vector2` |  |
| `GetAngularVelocity` | `() -> number` |  |


### RuntimeDebugger  `: Object`

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `visible` | boolean |  |
| `paused` | boolean |  |

**方法（13）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Show` | `()` |  |
| `Hide` | `()` |  |
| `Toggle` | `()` |  |
| `IsVisible` | `() -> boolean` |  |
| `Pause` | `()` |  |
| `Resume` | `()` |  |
| `TogglePause` | `()` |  |
| `Step` | `()` |  |
| `IsPaused` | `() -> boolean` |  |
| `GetSelectedNode` | `() -> Node` |  |
| `GetSelectedComponent` | `() -> Component` |  |
| `SetSelectedNode` | `(node: Node)` |  |
| `SetSelectedComponent` | `(component: Component)` |  |


### Scene  `: Node`

**构造**

```lua
fun(): Scene
```

**属性（14）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `updateEnabled` | boolean |  |
| `asyncLoading` | boolean |  |
| `asyncProgress` | number |  |
| `asyncLoadMode` | LoadMode |  |
| `fileName` | string |  |
| `checksum` | integer |  |
| `timeScale` | number |  |
| `elapsedTime` | number |  |
| `smoothingConstant` | number |  |
| `snapThreshold` | number |  |
| `asyncLoadingMs` | integer |  |
| `threadedUpdate` | boolean |  |
| `varNamesAttr` | string |  |
| `GetComponent` | __union_func__type_str__recursive_bool_opt__ret_ComponentT |  |

**方法（51）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Load` | `(source: File) -> boolean` |  |
| `Save` | `(dest: File) -> boolean` |  |
| `LoadXML` | `(source: File) -> boolean` |  |
| `SaveXML` | `(dest: File, indentation?: string) -> boolean` |  |
| `LoadJSON` | `(source: File) -> boolean` |  |
| `SaveJSON` | `(dest: File, indentation?: string) -> boolean` |  |
| `Instantiate` | `(source: File, position: Vector3, rotation: Quaternion, mode?: CreateMode) -> Node` |  |
| `InstantiateXML` | `(source: File, position: Vector3, rotation: Quaternion, mode?: CreateMode) -> Node` |  |
| `InstantiateJSON` | `(source: File, position: Vector3, rotation: Quaternion, mode?: CreateMode) -> Node` |  |
| `LoadAsync` | `(file: File, mode?: LoadMode) -> boolean` |  |
| `LoadAsyncXML` | `(file: File, mode?: LoadMode) -> boolean` |  |
| `StopAsyncLoading` | `()` |  |
| `Clear` | `(clearReplicated?: boolean, clearLocal?: boolean)` |  |
| `SetUpdateEnabled` | `(enable: boolean)` |  |
| `SetTimeScale` | `(scale: number)` |  |
| `SetElapsedTime` | `(time: number)` |  |
| `SetSmoothingConstant` | `(constant: number)` |  |
| `SetSnapThreshold` | `(threshold: number)` |  |
| `SetAsyncLoadingMs` | `(ms: integer)` |  |
| `GetNode` | `(id: integer) -> Node` |  |
| `IsReplicatedID` | `(id: integer) -> boolean` |  |
| `IsUpdateEnabled` | `() -> boolean` |  |
| `IsAsyncLoading` | `() -> boolean` |  |
| `GetAsyncProgress` | `() -> number` |  |
| `GetAsyncLoadMode` | `() -> LoadMode` |  |
| `GetFileName` | `() -> string` |  |
| `GetChecksum` | `() -> integer` |  |
| `GetTimeScale` | `() -> number` |  |
| `GetElapsedTime` | `() -> number` |  |
| `GetSmoothingConstant` | `() -> number` |  |
| `GetSnapThreshold` | `() -> number` |  |
| `GetAsyncLoadingMs` | `() -> integer` |  |
| `GetVarName` | `(hash: StringHash|string) -> string` |  |
| `Update` | `(timeStep: number)` |  |
| `BeginThreadedUpdate` | `()` |  |
| `EndThreadedUpdate` | `()` |  |
| `DelayedMarkedDirty` | `(component: Component)` |  |
| `IsThreadedUpdate` | `() -> boolean` |  |
| `GetFreeNodeID` | `(mode: CreateMode) -> integer` |  |
| `GetFreeComponentID` | `(mode: CreateMode) -> integer` |  |
| `NodeAdded` | `(node: Node)` |  |
| `NodeRemoved` | `(node: Node)` |  |
| `ComponentAdded` | `(component: Component)` |  |
| `ComponentRemoved` | `(component: Component)` |  |
| `SetVarNamesAttr` | `(value: string)` |  |
| `GetVarNamesAttr` | `() -> string` |  |
| `PrepareNetworkUpdate` | `()` |  |
| `CleanupConnection` | `(connection: Connection)` |  |
| `MarkNetworkUpdate` | `(node: Node)` |  |
| `MarkReplicationDirty` | `(node: Node)` |  |
| `GetNodesWithTag` | `(tag: string) -> Node[]` |  |


### SceneArchive

**方法（2）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Save` | `(destination: File|VectorBuffer, scene: Scene, options) -> boolean` | Return success and an error string. options.data is bounded cmsgpack d |
| `Load` | `(source: File|VectorBuffer, options) -> Scene?` | Return a new Scene and auxiliary data, or nil and an error string. |


### ScoreCommit

**方法（31）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `commit` | `(description: string Operation description, events?: ScoreEvents Callback table)` | Commit all changes |
| `client_score_set` | `(key: string Score key, value: ScoreValue Score value)` | Set any type client score (client only, no player_id needed) |
| `client_score_seti` | `(key: string Score key, value: integer Score value)` | Set integer client score (client only, no player_id needed) |
| `client_score_addi` | `(key: string Score key, delta: integer Delta value)` | Add integer client score (client only, no player_id needed) |
| `client_score_delete` | `(key: string Score key)` | Delete any type client score (client only, no player_id needed) |
| `client_score_deletei` | `(key: string Score key)` | Delete integer client score (client only, no player_id needed) |
| `score_set` | `(player_id: integer Player ID, key: string Score key, value: ScoreValue Score value)` | Set any type server score (server only) |
| `score_seti` | `(player_id: integer Player ID, key: string Score key, value: integer Score value)` | Set integer server score (server only) |
| `score_addi` | `(player_id: integer Player ID, key: string Score key, delta: integer Delta value, target_map?: string Target map name)` | Add integer server score (server only) |
| `score_sets` | `(player_id: integer Player ID, key: string Score key, value: string Score value)` | Set string server score (server only) |
| `score_delete` | `(player_id: integer Player ID, key: string Score key)` | Delete any type server score (server only) |
| `score_deletei` | `(player_id: integer Player ID, key: string Score key)` | Delete integer server score (server only) |
| `score_deletes` | `(player_id: integer Player ID, key: string Score key)` | Delete string server score (server only) |
| `money_add` | `(player_id: integer Player ID, key: string Currency key, amount: number Amount to add)` | Add money (server only) |
| `money_cost` | `(player_id: integer Player ID, key: string Currency key, amount: number Amount to cost)` | Cost money (server only, amount must > 0) |
| `platform_money_cost` | `(player_id: integer Player ID, order: any Order data)` | Platform money cost (server only) |
| `list_add` | `(player_id: integer Player ID, key: string List key, value: any Item value) -> integer` | Add list item (server only) |
| `list_modify` | `(_: any Placeholder (ignored), _: any Placeholder (ignored), list_id: integer List ID, value: any New value)` | Modify list item (server only, first two params are placeholders) |
| `list_delete` | `(_: any Placeholder (ignored), _: any Placeholder (ignored), list_id: integer List ID)` | Delete list item (server only, first two params are placeholders) |
| `list_modify_key` | `(list_id: integer List ID, key: string New key)` | Modify list item key (server only) |
| `item_add` | `(player_id: integer Player ID, key: string Item key, item_name: string Item name, count: integer Item count, value: any Extra data, expire_type: integer Expire type: 0=permanent, 1=deadline, 2=duration, expire_time?: integer|string Expire time)` | Add item (server only) |
| `item_use` | `(player_id: integer Player ID, item_id: integer Item ID, count: integer Use count)` | Use item (server only) |
| `name_new` | `(key: string Score key, name: string Name, value: any Value)` | Create named score (server only) |
| `name_delete` | `(key: string Score key, name: string Name)` | Delete named score (server only) |
| `withlimit_add` | `(player_id: integer Player ID, key: string Score key, value: number Value to add, limit: number Max limit, refresh_type?: string Refresh type, refresh_count?: integer Refresh count)` | Add score with limit (server only) |
| `withlimit_reset` | `(player_id: integer Player ID, key: string Score key)` | Reset score with limit (server only) |
| `world_data_set` | `(player_id: integer Player ID, key: string Data key, world_id: integer World ID, value: any Data value)` | Set world data (server only) |
| `world_data_delete` | `(player_id: integer Player ID, key: string Data key, world_id: integer World ID)` | Delete world data (server only) |
| `world_list_add` | `(player_id: integer Player ID, key: string List key, world_id: integer World ID, value: any Item value)` | Add world list item (server only) |
| `world_list_modify` | `(list_id: integer List ID, value: any New value)` | Modify world list item (server only) |
| `world_list_delete` | `(list_id: integer List ID)` | Delete world list item (server only) |


### score

**静态方法（35）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `client_score_init` | `(player_id: integer|nil Player ID, nil for current player, events?: ScoreEvents Callback table, ...: string Score keys to query)  (+1 重载)` | Query client score data |
| `client_get_rank_list` | `(key: string Rank key, start: integer Start rank (0-based), count: integer Number of items to get, type?: string Score type, default "iscore", events: ScoreEvents Callback table, ...: string Additional score keys to return)` | Get client score rank list |
| `client_get_user_rank` | `(player_id: integer Player ID, key: string Rank key, type?: string Score type, default "iscore", events?: ScoreEvents Callback table)` | Get player's rank in client score leaderboard |
| `client_get_rank_total` | `(key: string Rank key, type?: string Score type, default "iscore", events: ScoreEvents Callback table)` | Get total count of client score leaderboard |
| `get_commit` | `() -> ScoreCommit` | Get a commit object for batch operations (client version) |
| `score_init` | `(map_name?: string Map name, nil for current map, player_id: integer|integer[]|nil Player ID, array for multi-player query, nil for current player, events?: ScoreEvents Callback table, ...: string Score keys to query)` | Query server score data (server only) |
| `money_init` | `(map_name?: string Map name, player_id: integer|integer[]|nil Player ID, supports array for multi-player query, events?: ScoreEvents Callback table, ...: string|table Currency keys)` | Query money data (server only) |
| `message_query` | `(player_id: integer|nil Player ID, key: string Message type key, read: boolean|nil Filter by read status, nil for all, events: ScoreEvents Callback table)` | Query message list (server only) |
| `message_send` | `(player_id: integer Sender player ID, key: string Message type key, target_user_id: integer Receiver user ID, value: any Message content, events?: ScoreEvents Callback table) -> integer` | Send message (server only) |
| `message_modify_read` | `(_: any Placeholder (ignored), message_id: integer Message ID, read: boolean Read status, events?: ScoreEvents Callback table)` | Modify message read status (server only) |
| `message_delete` | `(_: any Placeholder (ignored), message_id: integer Message ID, events?: ScoreEvents Callback table)` | Delete message (server only) |
| `subscribe_channel` | `(player_id: integer Player ID, channel_name: string Channel name, events: ScoreEvents Callback table) -> boolean` | Subscribe to channel (server only) |
| `subscribe_message` | `(channel_name: string Channel name, events: ScoreEvents Callback table) -> boolean` | Subscribe to channel message without user ID (server only) |
| `unsubscribe_message` | `(channel_name: string Channel name) -> boolean` | Unsubscribe from channel message (server only) |
| `publish_message` | `(channel_name: string Channel name, value: any Message content)` | Publish message to channel (server only) |
| `unsubscribe_channel` | `(player_id: integer Player ID, channel_name: string Channel name)` | Unsubscribe from channel (server only) |
| `list_query` | `(map_name?: string Map name, player_id: integer|nil Player ID, key: string List key, limit?: integer Number limit, events: ScoreEvents Callback table, timetype?: string Time type)` | Query list data (server only) |
| `list_query_by_listid` | `(map_name?: string Map name, list_id: integer List ID, events: ScoreEvents Callback table, timetype?: string Time type)` | Query list item by list_id (server only) |
| `query_item` | `(player_id: integer Player ID, events: ScoreEvents Callback table, key?: string Item key filter)` | Query items (server only) |
| `name_search` | `(map_name?: string Map name, key: string Score key, name_substr: string Name substring to search, events?: ScoreEvents Callback table)` | Search by name (server only) |
| `name_exist` | `(map_name?: string Map name, key: string Score key, name: string Name to check, events?: ScoreEvents Callback table)` | Check if name exists (server only) |
| `get_user_status` | `(player_id: integer Player ID) -> any` | Get user status synchronously (server only) |
| `async_get_user_status` | `(player_or_players: integer|integer[] Player ID or array of IDs, events: ScoreEvents Callback table)` | Get user status asynchronously (server only) |
| `async_set_user_status` | `(player_id: integer Player ID, status: any Status data)` | Set user status asynchronously (server only) |
| `world_data_init` | `(map_name?: string Map name, world_id: integer World ID, player_id: integer|nil Player ID, events?: ScoreEvents Callback table, ...: string Data keys to query)` | Query world data (server only) |
| `world_list_query` | `(map_name?: string Map name, world_id: integer World ID, player_id: integer|nil Player ID, key: string List key, limit?: integer Number limit, events: ScoreEvents Callback table, timetype?: string Time type)` | Query world list data (server only) |
| `world_list_query_by_listid` | `(map_name?: string Map name, list_id: integer List ID, events: ScoreEvents Callback table, timetype?: string Time type)` | Query world list item by list_id (server only) |
| `withlimit_query` | `(map_name?: string Map name, player_id: integer|nil Player ID, key: string Score key, events: ScoreEvents Callback table)` | Query score with limit (server only) |
| `async_hset` | `(key: string Redis key, field: string Hash field, value: any Value)` | Async Redis HSET operation (server only) |
| `async_hdel` | `(key: string Redis key, field: string Hash field)` | Async Redis HDEL operation (server only) |
| `channel_push` | `(channel: string Channel name, value: any Value to push)` | Redis channel push (server only) |
| `stat_upload` | `(player_id: integer Player ID, key: string Stat key, value: any Stat value, events?: ScoreEvents Callback table)` | Upload statistics data (server only) |
| `rollback_score` | `(map_name: string Map name, player_id: integer|nil Player ID, req_id: string Request ID to rollback, events?: ScoreEvents Callback table)` | Rollback score operation (server only) |
| `is_old_player` | `(player_id: integer Player ID, events: ScoreEvents Callback table)` | Check if player is an old player (server only) |
| `test_cloud_value` | `(value: any Value to test, events: ScoreEvents Callback table)` | Test cloud value serialization size (server only) |


### ScrollBar  `: BorderImage`

**构造**

```lua
fun(): ScrollBar
```

**属性（9）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `orientation` | Orientation |  |
| `range` | number |  |
| `value` | number |  |
| `scrollStep` | number |  |
| `stepFactor` | number |  |
| `effectiveScrollStep` | number |  |
| `backButton` | Button |  |
| `forwardButton` | Button |  |
| `slider` | Slider |  |

**方法（17）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetOrientation` | `(orientation: Orientation)` |  |
| `SetRange` | `(range: number)` |  |
| `SetValue` | `(value: number)` |  |
| `ChangeValue` | `(delta: number)` |  |
| `SetScrollStep` | `(step: number)` |  |
| `SetStepFactor` | `(factor: number)` |  |
| `StepBack` | `()` |  |
| `StepForward` | `()` |  |
| `GetOrientation` | `() -> Orientation` |  |
| `GetRange` | `() -> number` |  |
| `GetValue` | `() -> number` |  |
| `GetScrollStep` | `() -> number` |  |
| `GetStepFactor` | `() -> number` |  |
| `GetEffectiveScrollStep` | `() -> number` |  |
| `GetBackButton` | `() -> Button` |  |
| `GetForwardButton` | `() -> Button` |  |
| `GetSlider` | `() -> Slider` |  |


### Serializer

**方法（40）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Write` | `(buffer: VectorBuffer) -> integer` |  |
| `WriteInt` | `(value: integer) -> boolean` |  |
| `WriteInt64` | `(value: integer) -> boolean` |  |
| `WriteShort` | `(value: integer) -> boolean` |  |
| `WriteByte` | `(value: integer) -> boolean` |  |
| `WriteUInt` | `(value: integer) -> boolean` |  |
| `WriteUInt64` | `(value: integer) -> boolean` |  |
| `WriteUShort` | `(value: integer -- unsigned short) -> boolean` |  |
| `WriteUByte` | `(value: number -- unsigned char) -> boolean` |  |
| `WriteBool` | `(value: boolean) -> boolean` |  |
| `WriteFloat` | `(value: number) -> boolean` |  |
| `WriteDouble` | `(value: number) -> boolean` |  |
| `WriteIntRect` | `(value: IntRect) -> boolean` |  |
| `WriteIntVector2` | `(value: IntVector2) -> boolean` |  |
| `WriteIntVector3` | `(value: IntVector3) -> boolean` |  |
| `WriteRect` | `(value: Rect) -> boolean` |  |
| `WriteVector2` | `(value: Vector2) -> boolean` |  |
| `WriteVector3` | `(value: Vector3) -> boolean` |  |
| `WritePackedVector3` | `(value: Vector3, maxAbsCoord: number) -> boolean` |  |
| `WriteVector4` | `(value: Vector4) -> boolean` |  |
| `WriteQuaternion` | `(value: Quaternion) -> boolean` |  |
| `WritePackedQuaternion` | `(value: Quaternion) -> boolean` |  |
| `WriteMatrix3` | `(value: Matrix3) -> boolean` |  |
| `WriteMatrix3x4` | `(value: Matrix3x4) -> boolean` |  |
| `WriteMatrix4` | `(value: Matrix4) -> boolean` |  |
| `WriteColor` | `(value: Color) -> boolean` |  |
| `WriteBoundingBox` | `(value: BoundingBox) -> boolean` |  |
| `WriteString` | `(value: string) -> boolean` |  |
| `WriteFileID` | `(value: string) -> boolean` |  |
| `WriteStringHash` | `(value: StringHash|string) -> boolean` |  |
| `WriteBuffer` | `(buffer: VectorBuffer) -> boolean` |  |
| `WriteResourceRef` | `(value: ResourceRef) -> boolean` |  |
| `WriteResourceRefList` | `(value: ResourceRefList) -> boolean` |  |
| `WriteVariant` | `(value: Variant) -> boolean` |  |
| `WriteVariantData` | `(value: Variant) -> boolean` |  |
| `WriteVariantVector` | `(value: VariantVector) -> boolean` |  |
| `WriteVariantMap` | `(value: VariantMap) -> boolean` |  |
| `WriteVLE` | `(value: integer) -> boolean` |  |
| `WriteNetID` | `(value: integer) -> boolean` |  |
| `WriteLine` | `(value: string) -> boolean` |  |


### ServerCloudBatchGet

**方法（3）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Player` | `(userId: integer 用户 ID) -> ServerCloudBatchGet` | 添加查询玩家（多玩家模式） 调用 :Player() 后进入多玩家模式，Fetch 回调变为数组格式 用法: serverCloud:Bat |
| `Key` | `(key: string 云变量 key) -> ServerCloudBatchGet` | 添加要查询的 key |
| `Fetch` | `(events: ScoreEvents 回调表)` | 执行批量读取 单人模式 (BatchGet(uid)):  ok = function(scores, iscores, sscores)  |


### ServerCloudBatchSet

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Set` | `(key: string 云变量 key, value: any 任意类型值) -> ServerCloudBatchSet` | 设置任意类型值 |
| `SetInt` | `(key: string 云变量 key, value: integer 整数值) -> ServerCloudBatchSet` | 设置整数值 |
| `Add` | `(key: string 云变量 key, delta: integer 增量) -> ServerCloudBatchSet` | 整数增量操作 |
| `Delete` | `(key: string 云变量 key) -> ServerCloudBatchSet` | 删除 key |
| `Save` | `(description: string 操作描述, events?: ScoreEvents 回调表)` | 提交批量写入 |


### ServerCloudCommit

**方法（18）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Commit` | `(events?: ScoreEvents 回调表)` | 提交所有操作 |
| `ScoreSet` | `(userId: integer 用户 ID, key: string 云变量 key, value: any 值) -> ServerCloudCommit` | 设置任意类型云变量 |
| `ScoreSetInt` | `(userId: integer 用户 ID, key: string 云变量 key, value: integer 整数值) -> ServerCloudCommit` | 设置整数云变量 |
| `ScoreAddInt` | `(userId: integer 用户 ID, key: string 云变量 key, delta: integer 增量) -> ServerCloudCommit` | 整数增量 |
| `ScoreSetStr` | `(userId: integer 用户 ID, key: string 云变量 key, value: string 字符串值) -> ServerCloudCommit` | 设置字符串云变量 |
| `ScoreDelete` | `(userId: integer 用户 ID, key: string 云变量 key) -> ServerCloudCommit` | 删除任意类型云变量 |
| `ScoreDeleteInt` | `(userId: integer 用户 ID, key: string 云变量 key) -> ServerCloudCommit` | 删除整数云变量 |
| `ScoreDeleteStr` | `(userId: integer 用户 ID, key: string 云变量 key) -> ServerCloudCommit` | 删除字符串云变量 |
| `MoneyAdd` | `(userId: integer 用户 ID, key: string 货币 key, amount: number 金额) -> ServerCloudCommit` | 增加货币 |
| `MoneyCost` | `(userId: integer 用户 ID, key: string 货币 key, amount: number 金额（必须 > 0）) -> ServerCloudCommit` | 扣除货币 |
| `ListAdd` | `(userId: integer 用户 ID, key: string 列表 key, value: any 值) -> ServerCloudCommit,` | 添加列表项 |
| `ListModify` | `(listId: integer 列表项 ID, value: any 新值) -> ServerCloudCommit` | 修改列表项 |
| `ListModifyKey` | `(listId: integer 列表项 ID, key: string 新 key) -> ServerCloudCommit` | 修改列表项 key |
| `ListDelete` | `(listId: integer 列表项 ID) -> ServerCloudCommit` | 删除列表项 |
| `QuotaAdd` | `(userId: integer 用户 ID, key: string 云变量 key, value: integer 增加的值, limit: integer 上限, refreshType?: string 刷新类型 ("hour"/"day"/"week_monday"/etc.), refreshCount?: integer 刷新周期) -> ServerCloudCommit` | 添加配额计数器（有限次云变量） |
| `QuotaReset` | `(userId: integer 用户 ID, key: string 云变量 key) -> ServerCloudCommit` | 重置配额计数器 |
| `NameNew` | `(key: string key, name: string 名字, value: any 值) -> ServerCloudCommit` | 创建命名积分（已废弃） |
| `NameDelete` | `(key: string key, name: string 名字) -> ServerCloudCommit` | 删除命名积分（已废弃） |


### ServerCloudMoney

**方法（3）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Get` | `(userId: integer 用户 ID, events: ScoreEvents 回调表)` | 查询货币余额 回调签名: ok = function(moneys) 其中 moneys = {key = amount, ...} |
| `Add` | `(userId: integer 用户 ID, key: string 货币 key, amount: integer 金额, events?: ScoreEvents 回调表)` | 增加货币 |
| `Cost` | `(userId: integer 用户 ID, key: string 货币 key, amount: integer 金额（必须 > 0）, events?: ScoreEvents 回调表)` | 扣除货币 |


### ServerCloudList

**方法（6）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Get` | `(userId: integer 用户 ID, key: string 列表 key, events: ScoreEvents 回调表)` | 查询列表 回调签名: ok = function(list) 其中 list = {{user_id, key, value, list_i |
| `GetById` | `(listId: integer 列表项 ID, events: ScoreEvents 回调表)` | 通过 list_id 查询列表项 |
| `Add` | `(userId: integer 用户 ID, key: string 列表 key, value: any 值, events?: ScoreEvents 回调表) -> integer` | 添加列表项 |
| `Modify` | `(listId: integer 列表项 ID, value: any 新值, events?: ScoreEvents 回调表)` | 修改列表项 |
| `ModifyKey` | `(listId: integer 列表项 ID, key: string 新 key, events?: ScoreEvents 回调表)` | 修改列表项 key |
| `Delete` | `(listId: integer 列表项 ID, events?: ScoreEvents 回调表)` | 删除列表项 |


### ServerCloudItem

**方法（3）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Get` | `(userId: integer 用户 ID, key?: string 道具 key 过滤, events: ScoreEvents 回调表)` | 查询道具 |
| `Add` | `(userId: integer 用户 ID, key: string 道具 key, name: string 道具名称, count: integer 数量, value: any 道具数据, expireType?: integer 过期类型, expireTime?: string 过期时间, events?: ScoreEvents 回调表) -> integer` | 添加道具 |
| `Use` | `(userId: integer 用户 ID, itemId: integer 道具 ID, count?: integer 使用数量（默认 1）, events?: ScoreEvents 回调表)` | 使用道具 |


### ServerCloudMessage

**方法（4）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Send` | `(userId: integer 发送者 ID, key: string 消息类型 key, targetUserId: integer 接收者 ID, value: any 消息内容, events?: ScoreEvents 回调表 { ok = function(errorCode, errorDesc) })` | 发送消息 |
| `Get` | `(userId: integer 用户 ID, key: string 消息类型 key, read: boolean|false 是否只查已读, events: ScoreEvents 回调表 { ok = function(messages: ServerCloudMessageItem[]) })` | 查询消息 |
| `MarkRead` | `(messageId: integer 消息 ID, events?: ScoreEvents 回调表)` | 标记消息已读 |
| `Delete` | `(messageId: integer 消息 ID, events?: ScoreEvents 回调表)` | 删除消息 |


### ServerCloudQuota

**方法（3）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Get` | `(userId: integer 用户 ID, key: string 云变量 key, events: ScoreEvents 回调表 { ok = function(datas) })` | 查询配额计数器 |
| `Add` | `(userId: integer 用户 ID, key: string 云变量 key, value: integer 增加的值, limit: integer 上限, refreshType?: string 刷新类型 ("hour"/"day"/"week_monday"/etc.), refreshCount?: integer 刷新周期, events?: ScoreEvents 回调表)` | 增加配额计数 |
| `Reset` | `(userId: integer 用户 ID, key: string 云变量 key, events?: ScoreEvents 回调表)` | 重置配额计数器 |


### CloudSceneTarget


### ServerCloud

**方法（16）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SaveScene` | `(target: CloudSceneTarget, slot: string 1-32 个 ASCII 字母、数字或短横线, scene: Scene, options?: CloudSceneSaveOptions, events?: CloudSceneSaveEvents) -> string?` | 服务端场景归档，与普通云变量共用房间预算。需设置 URHOX_SCENE_ARCHIVE_ROOT 为可写绝对磁盘目录。 在主线程帧末采集到 |
| `LoadScene` | `(target: CloudSceneTarget, slot: string, options?: table 当前版本保留参数, events?: CloudSceneLoadEvents) -> string?` | 从磁盘归档构建新场景；业务负责替换旧场景及清理引用。 |
| `Get` | `(userId: integer 用户 ID, key: string 云变量 key, events: ScoreEvents 回调表)` | 单个读取 回调签名: ok = function(scores, iscores, sscores) |
| `Set` | `(userId: integer 用户 ID, key: string 云变量 key, value: any 任意类型值, events?: ScoreEvents 回调表)` | 单个写入任意类型值 |
| `SetInt` | `(userId: integer 用户 ID, key: string 云变量 key, value: integer 整数值, events?: ScoreEvents 回调表)` | 单个写入整数值 |
| `Add` | `(userId: integer 用户 ID, key: string 云变量 key, delta: integer 增量, events?: ScoreEvents 回调表)` | 单个整数增量 |
| `Delete` | `(userId: integer 用户 ID, key: string 云变量 key, events?: ScoreEvents 回调表)` | 单个删除 |
| `BatchGet` | `(userId?: integer 用户 ID（传入则为单人模式，不传则需调用 :Player()）) -> ServerCloudBatchGet` | 批量读取（链式调用） 单人: serverCloud:BatchGet(uid):Key("k1"):Key("k2"):Fetch(eve |
| `BatchSet` | `(userId: integer 用户 ID) -> ServerCloudBatchSet` | 批量写入（链式调用） 用法: serverCloud:BatchSet(uid):Set("k",v):SetInt("k",n):Save |
| `BatchCommit` | `(description: string 操作描述) -> ServerCloudCommit` | 创建事务提交对象（可混合多用户、多类型操作） 用法: serverCloud:BatchCommit("desc"):ScoreSet(ui |
| `GetRankList` | `(key: string 排序 key, start: integer 起始位置（1 开始）, count: integer 获取数量, orderAsc: boolean true 为升序排列，默认降序, events: ScoreEvents 回调表)  (+1 重载)` | 获取排行榜 回调签名: ok = function(rankList) 其中 rankList = ServerCloudRankItem[ |
| `GetUserRank` | `(userId: integer 用户 ID, key: string 排序 key, events: ScoreEvents 回调表 { ok = function(rank, score) })` | 获取用户排名 |
| `GetRankTotal` | `(key: string 排序 key, events: ScoreEvents 回调表 { ok = function(total) })` | 获取排行榜总人数 |
| `IsOldPlayer` | `(userId: integer 用户 ID, events: ScoreEvents 回调表 { ok = function(isOld: boolean) })` | 查询是否为老玩家 |
| `NameSearch` | `(key: string key, nameSubstr: string 名字子串, events?: ScoreEvents 回调表)` | 搜索命名积分（已废弃） |
| `NameExist` | `(key: string key, name: string 名字, events?: ScoreEvents 回调表)` | 检查名字是否存在（已废弃） |


### ServerShop


### ShopUserOrdersCursor

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `createdAt` | string Database timestamp returned by the previous page; pass it back unchanged |  |
| `orderId` | string Order ID returned by the previous page |  |


### ShopUserOrdersOptions

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `startTime?` | integer Inclusive created-at Unix timestamp in seconds; must be paired with endTime |  |
| `endTime?` | integer Exclusive created-at Unix timestamp in seconds; must be paired with startTime |  |
| `pageSize?` | integer Page size from 1 to 100; defaults to 20 |  |
| `cursor?` | ShopUserOrdersCursor Cursor returned by the previous page |  |


### ShopUserOrder

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `orderId` | string Platform Maker order ID |  |
| `productId` | string Merchant SKU ID; use this stable field to identify the product |  |
| `product` | table|nil Product snapshot captured when the order was created; its shape follows the historical product configuration and may contain id, name, price, tag, and delivery. Numeric values larger than Lua's exact integer range should be stored as strings by the producer. |  |
| `amount` | string Paid amount in CNY yuan, represented as an exact decimal string such as "6.00" |  |
| `deliveryStatus` | ShopDeliveryStatus|nil Delivery state |  |
| `createdAt` | number Order creation Unix timestamp in seconds |  |
| `deliveredAt` | number|nil Delivery completion Unix timestamp in seconds; nil before delivery |  |


### ShopUserOrdersResult


### Shop

**静态方法（2）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `getUserOrders` | `(userId: integer Maker user ID, options: ShopUserOrdersOptions|nil, callback: fun(result: ShopUserOrdersResult))  (+1 重载)` | Query verified orders for a player in the current game and environment |
| `onDeliver` | `(callback: fun(context: ShopDeliveryContext))` | Register the server-side delivery handler. |


### ShopDeliveryContext


### Bone

**构造**

```lua
fun(): Bone
```

**属性（12）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | string |  |
| `nameHash` | StringHash|string |  |
| `parentIndex` | integer |  |
| `initialPosition` | Vector3 |  |
| `initialRotation` | Quaternion |  |
| `initialScale` | Vector3 |  |
| `offsetMatrix` | Matrix3x4 |  |
| `animated` | boolean |  |
| `collisionMask` | number -- unsigned char |  |
| `radius` | number |  |
| `boundingBox` | BoundingBox |  |
| `node` | Node |  |

**方法（1）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetFinalWorldTransform` | `() -> Matrix3x4` |  |


### Skeleton

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `numBones` | integer |  |
| `rootBone` | Bone |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetNumBones` | `() -> integer` |  |
| `GetRootBone` | `() -> Bone` |  |
| `GetBone` | `(name: string) -> Bone` |  |
| `GetBoneIndex` | `(boneName: string) -> integer` |  |
| `GetBoneParent` | `(bone: Bone) -> Bone` |  |


### SkinTextureBuffer  `: Component`

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `skinTexture` | Texture2D |  |

**方法（1）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetSkinTexture` | `() -> Texture2D` |  |


### SkyAtmosphere  `: Component`

**属性（29）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `renderSky` | boolean |  |
| `bottomRadius` | number |  |
| `atmosphereHeight` | number |  |
| `groundAlbedo` | Color |  |
| `rayleighScattering` | Color |  |
| `rayleighScatteringScale` | number |  |
| `rayleighScaleHeight` | number |  |
| `mieScattering` | Color |  |
| `mieScatteringScale` | number |  |
| `mieAbsorption` | Color |  |
| `mieAbsorptionScale` | number |  |
| `mieScaleHeight` | number |  |
| `mieAnisotropy` | number |  |
| `absorption` | Color |  |
| `absorptionScale` | number |  |
| `absorptionTipAltitude` | number |  |
| `absorptionTipValue` | number |  |
| `absorptionWidth` | number |  |
| `multiScatteringFactor` | number |  |
| `skyLuminanceFactor` | Color |  |
| `aerialPerspectiveDistanceScale` | number |  |
| `aerialPerspectiveStartDepth` | number |  |
| `traceSampleCountScale` | number |  |
| `transmittanceMinLightElevation` | number |  |
| `transformMode` | SkyAtmosphereTransformMode |  |
| `sunLight` | Light |  |
| `secondLight` | Light |  |
| `planetCenter` | Vector3 |  |
| `parameterRevision` | integer |  |

**方法（56）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetRenderSky` | `(enable: boolean)` | Enable physical background rendering independently of atmosphere light |
| `GetRenderSky` | `() -> boolean` | Return the physical background request. |
| `SetBottomRadius` | `(value: number)` | Set the planet ground radius in meters, at least 100. |
| `GetBottomRadius` | `() -> number` | Return the planet ground radius in meters, at least 100. |
| `SetAtmosphereHeight` | `(value: number)` | Set the atmosphere thickness in meters, at least 100. |
| `GetAtmosphereHeight` | `() -> number` | Return the atmosphere thickness in meters, at least 100. |
| `SetGroundAlbedo` | `(value: Color)` | Set the linear RGB ground albedo in [0, 1]. |
| `GetGroundAlbedo` | `() -> Color` | Return the linear RGB ground albedo in [0, 1]. |
| `SetRayleighScattering` | `(value: Color)` | Set the nonnegative linear RGB Rayleigh coefficient shape. |
| `GetRayleighScattering` | `() -> Color` | Return the nonnegative linear RGB Rayleigh coefficient shape. |
| `SetRayleighScatteringScale` | `(value: number)` | Set the Rayleigh coefficient scale in inverse kilometers. |
| `GetRayleighScatteringScale` | `() -> number` | Return the Rayleigh coefficient scale in inverse kilometers. |
| `SetRayleighScaleHeight` | `(value: number)` | Set the Rayleigh exponential scale height in meters, at least 1. |
| `GetRayleighScaleHeight` | `() -> number` | Return the Rayleigh exponential scale height in meters, at least 1. |
| `SetMieScattering` | `(value: Color)` | Set the nonnegative linear RGB Mie scattering coefficient shape. |
| `GetMieScattering` | `() -> Color` | Return the nonnegative linear RGB Mie scattering coefficient shape. |
| `SetMieScatteringScale` | `(value: number)` | Set the Mie scattering scale in inverse kilometers. |
| `GetMieScatteringScale` | `() -> number` | Return the Mie scattering scale in inverse kilometers. |
| `SetMieAbsorption` | `(value: Color)` | Set the nonnegative linear RGB Mie absorption coefficient shape. |
| `GetMieAbsorption` | `() -> Color` | Return the nonnegative linear RGB Mie absorption coefficient shape. |
| `SetMieAbsorptionScale` | `(value: number)` | Set the Mie absorption scale in inverse kilometers. |
| `GetMieAbsorptionScale` | `() -> number` | Return the Mie absorption scale in inverse kilometers. |
| `SetMieScaleHeight` | `(value: number)` | Set the Mie exponential scale height in meters, at least 1. |
| `GetMieScaleHeight` | `() -> number` | Return the Mie exponential scale height in meters, at least 1. |
| `SetMieAnisotropy` | `(value: number)` | Set the Mie Henyey-Greenstein anisotropy in [-0.99, 0.99]. |
| `GetMieAnisotropy` | `() -> number` | Return the Mie Henyey-Greenstein anisotropy in [-0.99, 0.99]. |
| `SetAbsorption` | `(value: Color)` | Set the nonnegative linear RGB absorption coefficient shape. |
| `GetAbsorption` | `() -> Color` | Return the nonnegative linear RGB absorption coefficient shape. |
| `SetAbsorptionScale` | `(value: number)` | Set the absorption scale in inverse kilometers. |
| `GetAbsorptionScale` | `() -> number` | Return the absorption scale in inverse kilometers. |
| `SetAbsorptionTipAltitude` | `(value: number)` | Set the absorption tent peak altitude in meters. |
| `GetAbsorptionTipAltitude` | `() -> number` | Return the absorption tent peak altitude in meters. |
| `SetAbsorptionTipValue` | `(value: number)` | Set the absorption tent peak density; each layer is saturated to [0, 1 |
| `GetAbsorptionTipValue` | `() -> number` | Return the absorption tent peak density; each layer is saturated to [0 |
| `SetAbsorptionWidth` | `(value: number)` | Set the absorption tent half-width in meters; zero disables this layer |
| `GetAbsorptionWidth` | `() -> number` | Return the absorption tent half-width in meters; zero disables this la |
| `SetMultiScatteringFactor` | `(value: number)` | Set the atmosphere multiple-scattering multiplier in [0, 100]. |
| `GetMultiScatteringFactor` | `() -> number` | Return the atmosphere multiple-scattering multiplier in [0, 100]. |
| `SetSkyLuminanceFactor` | `(value: Color)` | Set the nonnegative linear RGB sky luminance multiplier. |
| `GetSkyLuminanceFactor` | `() -> Color` | Return the nonnegative linear RGB sky luminance multiplier. |
| `SetAerialPerspectiveDistanceScale` | `(value: number)` | Set the nonnegative optical-depth distance multiplier for aerial persp |
| `GetAerialPerspectiveDistanceScale` | `() -> number` | Return the nonnegative optical-depth distance multiplier for aerial pe |
| `SetAerialPerspectiveStartDepth` | `(value: number)` | Set the aerial-perspective start distance in meters. |
| `GetAerialPerspectiveStartDepth` | `() -> number` | Return the aerial-perspective start distance in meters. |
| `SetTraceSampleCountScale` | `(value: number)` | Set the view integration sample-count scale in [0.1, 8]. |
| `GetTraceSampleCountScale` | `() -> number` | Return the view integration sample-count scale in [0.1, 8]. |
| `SetTransmittanceMinLightElevation` | `(value: number)` | Set the minimum elevation in degrees for the UE ground-light transmitt |
| `GetTransmittanceMinLightElevation` | `() -> number` | Return the minimum elevation in degrees for the UE ground-light transm |
| `SetTransformMode` | `(mode: SkyAtmosphereTransformMode)` | Set the planet placement policy. |
| `GetTransformMode` | `() -> SkyAtmosphereTransformMode` | Return the planet placement policy. |
| `GetPlanetCenter` | `() -> Vector3` | Return the resolved planet center in world meters. |
| `SetSunLight` | `(light: Light)` | Bind the primary directional light; nil disables it. |
| `GetSunLight` | `() -> Light` | Return the primary light. |
| `SetSecondLight` | `(light: Light)` | Bind an optional second directional light; nil disables it. |
| `GetSecondLight` | `() -> Light` | Return the second light. |
| `GetParameterRevision` | `() -> integer` | Return the nonzero parameter revision. |


### SkyLightCapture  `: Component`

**属性（13）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `includeClouds` | boolean |  |
| `skybox` | Skybox |  |
| `captureSource` | SkyCaptureSource |  |
| `resolution` | integer |  |
| `timeSliced` | boolean |  |
| `updateMode` | SkyCaptureUpdateMode |  |
| `minCaptureInterval` | number |  |
| `viewMask` | integer |  |
| `capturedCubemap` | TextureCube |  |
| `ready` | boolean |  |
| `capturing` | boolean |  |
| `completedCaptures` | integer |  |
| `supported` | boolean |  |

**方法（23）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetIncludeClouds` | `(enable: boolean)` | Include frozen scene clouds in atmosphere-source sky captures; default |
| `GetIncludeClouds` | `() -> boolean` | Return whether atmosphere-source captures include clouds. |
| `SetCaptureSource` | `(source: SkyCaptureSource Radiance source)` | Select skybox (default) or active atmosphere. Atmosphere freezes its p |
| `GetCaptureSource` | `() -> SkyCaptureSource` | Return the explicit radiance source. |
| `SetSkybox` | `(skybox: Skybox|nil Skybox to capture)` | Set the skybox to capture; nil captures the enabled Skybox in the scen |
| `SetResolution` | `(resolution: integer Face size in pixels)` | Set the capture face size: a power of two in 16..256, rounded up and c |
| `SetTimeSliced` | `(enable: boolean Whether captures are time-sliced)` | Spread a capture over several frames (default true) or finish it as so |
| `SetUpdateMode` | `(mode: SkyCaptureUpdateMode Update mode)` | Set when captures start. Default SKY_CAPTURE_ON_CHANGE: captures when  |
| `SetMinCaptureInterval` | `(seconds: number Minimum interval in seconds)` | Set the minimum seconds between capture starts in ON_CHANGE mode (>= 0 |
| `SetViewMask` | `(mask: integer View mask)` | Set the view mask of the capture cameras (default all bits). Only skyb |
| `RequestCapture` | `()` | Request a capture, e.g. after rewriting a sky texture with SetData. Ig |
| `GetSkybox` | `() -> Skybox` |  |
| `GetResolution` | `() -> integer` |  |
| `GetTimeSliced` | `() -> boolean` |  |
| `GetUpdateMode` | `() -> SkyCaptureUpdateMode` |  |
| `GetMinCaptureInterval` | `() -> number` |  |
| `GetViewMask` | `() -> integer` |  |
| `GetCapturedCubemap` | `() -> TextureCube|nil` | Latest published prefiltered cubemap, or nil before the first capture  |
| `HasCapturedSH` | `() -> boolean` | Whether the diffuse SH comes from the capture (false when the device c |
| `IsReady` | `() -> boolean` |  |
| `IsCapturing` | `() -> boolean` |  |
| `GetCompletedCaptures` | `() -> integer` |  |
| `IsSupported` | `() -> boolean` |  |


### Skybox  `: StaticModel`


### Slider  `: BorderImage`

**构造**

```lua
fun(): Slider
```

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `orientation` | Orientation |  |
| `range` | number |  |
| `value` | number |  |
| `knob` | BorderImage |  |
| `repeatRate` | number |  |

**方法（10）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetOrientation` | `(orientation: Orientation)` |  |
| `SetRange` | `(range: number)` |  |
| `SetValue` | `(value: number)` |  |
| `ChangeValue` | `(delta: number)` |  |
| `SetRepeatRate` | `(rate: number)` |  |
| `GetOrientation` | `() -> Orientation` |  |
| `GetRange` | `() -> number` |  |
| `GetValue` | `() -> number` |  |
| `GetKnob` | `() -> BorderImage` |  |
| `GetRepeatRate` | `() -> number` |  |


### Sound  `: ResourceWithMetadata`

**构造**

```lua
fun(): Sound
```

**属性（9）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `length` | number |  |
| `dataSize` | integer |  |
| `sampleSize` | integer |  |
| `frequency` | number Default sample rate in Hz as a float. |  |
| `intFrequency` | integer Default sample rate in Hz as an integer. |  |
| `looped` | boolean |  |
| `sixteenBit` | boolean |  |
| `stereo` | boolean |  |
| `compressed` | boolean |  |

**方法（18）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `LoadRaw` | `(source: Deserializer) -> boolean` |  |
| `LoadWav` | `(source: Deserializer) -> boolean` |  |
| `LoadOggVorbis` | `(source: Deserializer) -> boolean` |  |
| `LoadMp3` | `(source: Deserializer) -> boolean` |  |
| `SetSize` | `(dataSize: integer)` |  |
| `SetFormat` | `(frequency: integer Sample rate in Hz, sixteenBit: boolean Whether samples use 16-bit encoding, stereo: boolean Whether samples have two channels)` | Set uncompressed sound data format. |
| `SetLooped` | `(enable: boolean)` |  |
| `SetLoop` | `(repeatOffset: integer, endOffset: integer)` |  |
| `FixInterpolation` | `()` |  |
| `GetLength` | `() -> number` |  |
| `GetDataSize` | `() -> integer` |  |
| `GetSampleSize` | `() -> integer` |  |
| `GetFrequency` | `() -> number` | Return the sound resource's default sample rate without changing it. |
| `GetIntFrequency` | `() -> integer` | Return the sound resource's default sample rate as an integer without  |
| `IsLooped` | `() -> boolean` |  |
| `IsSixteenBit` | `() -> boolean` |  |
| `IsStereo` | `() -> boolean` |  |
| `IsCompressed` | `() -> boolean` |  |


### SoundListener  `: Component`


### SoundSource  `: Component`

**属性（12）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `sound` | Sound |  |
| `soundType` | string |  |
| `timePosition` | number |  |
| `frequency` | number Current absolute playback frequency in Hz, not a pitch multiplier. Set 0 before Play(sound) to use the sound's sample rate. |  |
| `gain` | number |  |
| `attenuation` | number |  |
| `panning` | number |  |
| `autoRemoveMode` | AutoRemoveMode |  |
| `playing` | boolean |  |
| `fadingIn` | boolean |  |
| `fadingOut` | boolean |  |
| `declickEnabled` | boolean |  |

**方法（23）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Seek` | `(seekTime: number)` |  |
| `Play` | `(sound: Sound Sound resource to play)` | Play a sound. A zero source frequency is initialized from the sound's  |
| `Stop` | `()` |  |
| `StopImmediate` | `()` |  |
| `SetDeclickEnabled` | `(enable: boolean)` |  |
| `GetDeclickEnabled` | `() -> boolean` |  |
| `SetSoundType` | `(type: string)` |  |
| `SetFrequency` | `(frequency: number Playback frequency in Hz, not a pitch multiplier; 0 is resolved by the next Play(Sound*) call)` | Set the absolute playback frequency. This changes the SoundSource, not |
| `SetGain` | `(gain: number)` |  |
| `SetAttenuation` | `(attenuation: number)` |  |
| `SetPanning` | `(panning: number)` |  |
| `SetAutoRemoveMode` | `(mode: AutoRemoveMode)` |  |
| `GetSound` | `() -> Sound` |  |
| `GetSoundType` | `() -> string` |  |
| `GetTimePosition` | `() -> number` |  |
| `GetFrequency` | `() -> number` | Return the current absolute playback frequency of this SoundSource. |
| `GetGain` | `() -> number` |  |
| `GetAttenuation` | `() -> number` |  |
| `GetPanning` | `() -> number` |  |
| `GetAutoRemoveMode` | `() -> AutoRemoveMode` |  |
| `IsPlaying` | `() -> boolean` | Return whether is playing. Returns true during fade-in, false during f |
| `IsFadingIn` | `() -> boolean` | Return whether a fade-in is in progress. |
| `IsFadingOut` | `() -> boolean` | Return whether a fade-out is in progress. |


### SoundSource3D  `: SoundSource`

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `nearDistance` | number |  |
| `farDistance` | number |  |
| `innerAngle` | number |  |
| `outerAngle` | number |  |
| `rolloffFactor` | number |  |

**方法（13）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetDistanceAttenuation` | `(nearDistance: number, farDistance: number, rolloffFactor: number)` |  |
| `SetAngleAttenuation` | `(innerAngle: number, outerAngle: number)` |  |
| `SetNearDistance` | `(distance: number)` |  |
| `SetFarDistance` | `(distance: number)` |  |
| `SetInnerAngle` | `(angle: number)` |  |
| `SetOuterAngle` | `(angle: number)` |  |
| `SetRolloffFactor` | `(factor: number)` |  |
| `CalculateAttenuation` | `()` |  |
| `GetNearDistance` | `() -> number` |  |
| `GetFarDistance` | `() -> number` |  |
| `GetInnerAngle` | `() -> number` |  |
| `GetOuterAngle` | `() -> number` |  |
| `RollAngleoffFactor` | `() -> number` |  |


### Sphere

**构造**

```lua
fun(sphere: Sphere): Sphere
fun(center: Vector3, radius: number): Sphere
fun(box: BoundingBox): Sphere
fun(frustum: Frustum): Sphere
fun(poly: Polyhedron): Sphere
fun(): Sphere
fun(self: Sphere, sphere: Sphere): Sphere
fun(sphere: Sphere): Sphere
```

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `center` | Vector3 |  |
| `radius` | number |  |

**方法（9）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Define` | `(sphere: Sphere)` |  |
| `Merge` | `(point: Vector3)` |  |
| `Clear` | `()` |  |
| `Defined` | `() -> boolean` |  |
| `IsInside` | `(point: Vector3) -> Intersection` |  |
| `IsInsideFast` | `(sphere: Sphere) -> Intersection` |  |
| `Distance` | `(point: Vector3) -> number` |  |
| `GetLocalPoint` | `(theta: number, phi: number) -> Vector3` |  |
| `GetPoint` | `(theta: number, phi: number) -> Vector3` |  |

**运算符**：`eq(Sphere): boolean`


### SpineBone  `: RefCounted`

**方法（22）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `IsValid` | `() -> boolean` |  |
| `GetName` | `() -> string` |  |
| `GetX` | `() -> number` |  |
| `GetY` | `() -> number` |  |
| `SetX` | `(x: number)` |  |
| `SetY` | `(y: number)` |  |
| `GetRotation` | `() -> number` |  |
| `SetRotation` | `(degrees: number)` |  |
| `GetScaleX` | `() -> number` |  |
| `GetScaleY` | `() -> number` |  |
| `SetScaleX` | `(sx: number)` |  |
| `SetScaleY` | `(sy: number)` |  |
| `GetWorldX` | `() -> number` |  |
| `GetWorldY` | `() -> number` |  |
| `GetWorldRotation` | `() -> number` |  |
| `GetWorldScaleX` | `() -> number` |  |
| `GetWorldScaleY` | `() -> number` |  |
| `SetAppliedValid` | `(valid: boolean)` |  |
| `IsActive` | `() -> boolean` |  |
| `GetParent` | `() -> SpineBone` |  |
| `WorldToLocal` | `(worldX: number, worldY: number)` | local lx, ly = bone:WorldToLocal(worldX, worldY) |
| `LocalToWorld` | `(localX: number, localY: number)` | local wx, wy = bone:LocalToWorld(localX, localY) |


### SpineSlot  `: RefCounted`

**方法（9）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `IsValid` | `() -> boolean` |  |
| `GetName` | `() -> string` |  |
| `GetBone` | `() -> SpineBone` |  |
| `HasDarkColor` | `() -> boolean` |  |
| `GetColor` | `()` | local r, g, b, a = slot:GetColor() |
| `SetColor` | `(r: number, g: number, b: number, a: number)` | slot:SetColor(r, g, b, a) — values 0.0-1.0 |
| `GetDarkColor` | `()` | local r, g, b = slot:GetDarkColor() |
| `SetDarkColor` | `(r: number, g: number, b: number)` | slot:SetDarkColor(r, g, b) — values 0.0-1.0 |
| `SetToSetupPose` | `()` |  |


### SpineInstance  `: Object`

**方法（50）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Load` | `(skeletonPath: string) -> boolean` |  |
| `Unload` | `()` |  |
| `Update` | `(dt: number)` |  |
| `UpdateWorldTransform` | `()` |  |
| `SetAnimation` | `(trackIndex: integer, name: string, loop: boolean) -> boolean` |  |
| `AddAnimation` | `(trackIndex: integer, name: string, loop: boolean, delay: number) -> boolean` |  |
| `SetEmptyAnimation` | `(trackIndex: integer, mixDuration: number)` |  |
| `AddEmptyAnimation` | `(trackIndex: integer, mixDuration: number, delay: number)` |  |
| `ClearTrack` | `(trackIndex: integer)` |  |
| `ClearTracks` | `()` |  |
| `SetDefaultMix` | `(duration: number)` |  |
| `SetSpeed` | `(speed: number)` |  |
| `GetSpeed` | `() -> number` |  |
| `SetTimeScale` | `(timeScale: number)` |  |
| `GetTimeScale` | `() -> number` |  |
| `SetFlipX` | `(flip: boolean)` |  |
| `SetFlipY` | `(flip: boolean)` |  |
| `SetSkin` | `(skinName: string)` |  |
| `SetToSetupPose` | `()` |  |
| `SetBonesToSetupPose` | `()` |  |
| `SetSlotsToSetupPose` | `()` |  |
| `SetPosition` | `(x: number, y: number)` |  |
| `SetScale` | `(scaleX: number, scaleY: number)` |  |
| `FindBone` | `(name: string) -> SpineBone` |  |
| `FindSlot` | `(name: string) -> SpineSlot` |  |
| `SetColor` | `(r: number, g: number, b: number, a?: number Alpha; defaults to 1 (fully opaque))` | instance:SetColor(r, g, b, a) — values 0.0-1.0 |
| `GetColor` | `()` | local r, g, b, a = instance:GetColor() |
| `GetDataWidth` | `() -> number` |  |
| `GetDataHeight` | `() -> number` |  |
| `GetDataX` | `() -> number` |  |
| `GetDataY` | `() -> number` |  |
| `IsLoaded` | `() -> boolean` |  |
| `IsAnimationComplete` | `(trackIndex: integer) -> boolean` |  |
| `GetTrackTime` | `(trackIndex: integer) -> number` |  |
| `GetAnimationDuration` | `(trackIndex: integer) -> number` |  |
| `GetTrackAlpha` | `(trackIndex: integer) -> number` |  |
| `SetTrackAlpha` | `(trackIndex: integer, alpha: number)` |  |
| `SetPremultipliedAlpha` | `(pma: boolean)` |  |
| `IsPremultipliedAlpha` | `() -> boolean` |  |
| `GetAnimationNames` | `() -> string[]` |  |
| `GetSkinNames` | `() -> string[]` |  |
| `GetBoneNames` | `() -> string[]` |  |
| `GetSlotNames` | `() -> string[]` |  |
| `SetAttachment` | `(slotName: string, attachmentName: string)` |  |
| `SetMix` | `(fromAnim: string, toAnim: string, duration: number)` |  |
| `SetCompleteListener` | `(fn: lua_Function)` | instance:SetCompleteListener(function(trackIndex, animName) end) |
| `SetStartListener` | `(fn: lua_Function)` | instance:SetStartListener(function(trackIndex, animName) end) |
| `SetEndListener` | `(fn: lua_Function)` | instance:SetEndListener(function(trackIndex, animName) end) |
| `SetDisposeListener` | `(fn: lua_Function)` | instance:SetDisposeListener(function(trackIndex, animName) end) |
| `SetEventListener` | `(fn: lua_Function)` | instance:SetEventListener(function(trackIndex, eventName, intVal, floa |


### Spline

**构造**

```lua
fun(mode: InterpolationMode): Spline
fun(rhs: Spline): Spline
fun(): Spline
fun(self: Spline, mode: InterpolationMode): Spline
fun(mode: InterpolationMode): Spline
fun(self: Spline, rhs: Spline): Spline
fun(rhs: Spline): Spline
```

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `interpolationMode` | InterpolationMode |  |

**方法（6）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetPoint` | `(f: number) -> Variant` |  |
| `GetKnot` | `(index: integer) -> Variant` |  |
| `SetKnot` | `(knot: Variant, param1: integer)` |  |
| `AddKnot` | `(knot: Variant)` |  |
| `RemoveKnot` | `(index: integer)` |  |
| `Clear` | `()` |  |

**运算符**：`eq(Spline): boolean`


### SplinePath  `: Component`

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `interpolationMode` | InterpolationMode |  |
| `speed` | number |  |
| `length` | number |  |
| `controlledNode` | Node |  |

**方法（15）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `AddControlPoint` | `(point: Node, index?: integer)` |  |
| `RemoveControlPoint` | `(point: Node)` |  |
| `ClearControlPoints` | `()` |  |
| `SetInterpolationMode` | `(mode: InterpolationMode)` |  |
| `SetPosition` | `(factor: number)` |  |
| `SetControlledNode` | `(controlled: Node)` |  |
| `GetInterpolationMode` | `() -> InterpolationMode` |  |
| `GetSpeed` | `() -> number` |  |
| `GetLength` | `() -> number` |  |
| `GetPosition` | `() -> Vector3` |  |
| `GetControlledNode` | `() -> Node` |  |
| `GetPoint` | `(factor: number) -> Vector3` |  |
| `Move` | `(timeStep: number)` |  |
| `Reset` | `()` |  |
| `IsFinished` | `() -> boolean` |  |


### Sprite  `: UIElement`

**构造**

```lua
fun(): Sprite
```

**属性（8）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `position` | Vector2 |  |
| `hotSpot` | IntVector2 |  |
| `scale` | Vector2 |  |
| `rotation` | number |  |
| `texture` | Texture |  |
| `imageRect` | IntRect |  |
| `blendMode` | BlendMode |  |
| `transform` | Matrix3x4 |  |

**方法（16）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetPosition` | `(position: Vector2)` |  |
| `SetHotSpot` | `(hotSpot: IntVector2)` |  |
| `SetScale` | `(scale: Vector2)` |  |
| `SetRotation` | `(angle: number)` |  |
| `SetTexture` | `(texture: Texture)` |  |
| `SetImageRect` | `(rect: IntRect)` |  |
| `SetFullImageRect` | `()` |  |
| `SetBlendMode` | `(mode: BlendMode)` |  |
| `GetPosition` | `() -> Vector2` |  |
| `GetHotSpot` | `() -> IntVector2` |  |
| `GetScale` | `() -> Vector2` |  |
| `GetRotation` | `() -> number` |  |
| `GetTexture` | `() -> Texture` |  |
| `GetImageRect` | `() -> IntRect` |  |
| `GetBlendMode` | `() -> BlendMode` |  |
| `GetTransform` | `() -> Matrix3x4` |  |


### Sprite2D  `: Resource`

**属性（6）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `texture` | Texture2D |  |
| `rectangle` | IntRect |  |
| `hotSpot` | Vector2 |  |
| `offset` | IntVector2 |  |
| `textureEdgeOffset` | number |  |
| `spriteSheet` | SpriteSheet2D |  |

**方法（12）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetTexture` | `(texture: Texture2D)` |  |
| `SetRectangle` | `(rectangle: IntRect)` |  |
| `SetHotSpot` | `(hotSpot: Vector2)` |  |
| `SetOffset` | `(offset: IntVector2)` |  |
| `SetTextureEdgeOffset` | `(offset: number)` |  |
| `SetSpriteSheet` | `(spriteSheet: SpriteSheet2D)` |  |
| `GetTexture` | `() -> Texture2D` |  |
| `GetRectangle` | `() -> IntRect` |  |
| `GetHotSpot` | `() -> Vector2` |  |
| `GetOffset` | `() -> IntVector2` |  |
| `GetTextureEdgeOffset` | `() -> number` |  |
| `GetSpriteSheet` | `() -> SpriteSheet2D` |  |


### SpriteSheet2D  `: Resource`

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `texture` | Texture2D |  |

**方法（4）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetTexture` | `(texture: Texture2D)` |  |
| `GetTexture` | `() -> Texture2D` |  |
| `GetSprite` | `(name: string) -> Sprite2D` |  |
| `DefineSprite` | `(name: string, rectangle: IntRect, hotSpot?: Vector2)` |  |


### StaticModelGroup  `: StaticModel`

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `numInstanceNodes` | integer |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `AddInstanceNode` | `(node: Node)` |  |
| `RemoveInstanceNode` | `(node: Node)` |  |
| `RemoveAllInstanceNodes` | `()` |  |
| `GetNumInstanceNodes` | `() -> integer` |  |
| `GetInstanceNode` | `(index: integer) -> Node` |  |


### StretchableSprite2D  `: StaticSprite2D`

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `border` | IntRect |  |

**方法（2）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetBorder` | `(border: IntRect)` |  |
| `GetBorder` | `() -> IntRect` |  |


### StringHash

**构造**

```lua
fun(rhs: StringHash|string): StringHash
fun(str: string): StringHash
fun(): StringHash
fun(self: StringHash, rhs: StringHash|string): StringHash
fun(rhs: StringHash|string): StringHash
fun(self: StringHash, str: string): StringHash
fun(str: string): StringHash
```

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `ZERO` | StringHash|string |  |
| `value` | integer |  |

**方法（4）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Value` | `() -> integer` |  |
| `ToString` | `() -> string` |  |
| `ToHash` | `() -> integer` |  |
| `Calculate` | `(str: string, hash?: integer) -> integer` |  |

**运算符**：`add(StringHash|string): StringHash|string`、`eq(StringHash|string): boolean`、`lt(StringHash|string): boolean`


### SvgResource  `: Resource`


### SvgElement  `: RefCounted`

**属性（33）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `valid` | boolean Whether the instance still owns this element generation. |  |
| `id` | string Original SVG id; empty for anonymous or invalid elements. |  |
| `tagName` | string Parsed SVG tag name; empty after invalidation. |  |
| `localName` | string Local SVG tag name; empty after invalidation. |  |
| `parentElement` | SvgElement Parent instance element; nil at the root or after invalidation. |  |
| `transformOrigin` | Vector2 Local script origin, excluding authored transforms; writes use SetTransformOrigin. |  |
| `translate` | Vector2 Local script translation, excluding authored transforms; writes use SetTranslate. |  |
| `rotate` | number Script rotation in degrees, excluding authored transforms; writes use SetRotate. |  |
| `scale` | Vector2 Script scale, excluding authored transforms; writes use SetScale. |  |
| `fill` | string Evaluated CSS paint string; accepts colors, none, currentColor and local url( | id) with fallback. For Color use SetFill. |
| `stroke` | string Evaluated CSS stroke paint string; same syntax as fill. For Color use SetStroke. |  |
| `color` | Color Evaluated currentColor value copied as Color; writes use SetColor. Use SetColor(string) for CSS colors. |  |
| `stopColor` | string CSS color or currentColor string; for Color use SetStopColor. Other paint syntax is unsupported. |  |
| `stopOpacity` | number Finite stop opacity in [0,1]; invalid writes are ignored. |  |
| `colorInterpolation` | "sRGB"|"linearRGB"|"auto"|"" Gradient interpolation only; auto reads as sRGB, empty after invalidation. Invalid writes are ignored. |  |
| `opacity` | number Evaluated element opacity; writes use SetOpacity. |  |
| `display` | string Evaluated inline/none display eligibility; writes use SetDisplay. |  |
| `visibility` | string Evaluated visibility, independent of display; writes use SetVisibility. |  |
| `pointerEvents` | "none"|"auto"|"visiblePainted"|"visibleFill"|"visibleStroke"|"visible"|"painted"|"fill"|"stroke"|"all"|"" Hit-test eligibility; bounding-box is unsupported. Writes use SetPointerEvents; invalid writes are ignored. |  |
| `strokeLinecap` | "butt"|"round"|"square"|"" Stroke endpoint shape. Writes use SetStrokeLinecap; invalid writes are ignored. |  |
| `strokeLinejoin` | "miter"|"round"|"bevel"|"" Stroke corner shape; arcs and miter-clip are unsupported. Writes use SetStrokeLinejoin; invalid writes are ignored. |  |
| `fillRule` | "nonzero"|"evenodd"|"" Fill winding rule. Writes use SetFillRule; invalid writes are ignored. |  |
| `clipRule` | "nonzero"|"evenodd"|"" Winding rule for geometry inside a clipPath. Writes use SetClipRule; invalid writes are ignored. |  |
| `paintOrder` | "normal"|"fill"|"stroke"|"markers"|"fill stroke"|"fill markers"|"stroke fill"|"stroke markers"|"markers fill"|"markers stroke"|"fill stroke markers"|"fill markers stroke"|"stroke fill markers"|"stroke markers fill"|"markers fill stroke"|"markers stroke fill"|"" Paint order; markers tokens are accepted but markers are not rendered. Reads normalize to fill stroke or stroke fill. Writes use SetPaintOrder; invalid writes are ignored. |  |
| `fillOpacity` | number Fill opacity in [0,1], excluding group compositing. Writes use SetFillOpacity; invalid writes are ignored. |  |
| `strokeOpacity` | number Stroke opacity in [0,1], excluding group compositing. Writes use SetStrokeOpacity; invalid writes are ignored. |  |
| `strokeMiterlimit` | number Stroke miter limit, at least 1. Writes use SetStrokeMiterlimit; invalid writes are ignored. |  |
| `clipPath` | string Evaluated none/url( | id); writes accept local references and resolve missing/wrong-type targets to none. |
| `strokeWidth` | number Evaluated nonnegative user-unit width; use SetStrokeWidth(string) for units and percentages. |  |
| `strokeDashoffset` | number Evaluated signed user-unit dash offset; use SetStrokeDashoffset(string) for units and percentages. |  |
| `strokeDasharray` | number[] Copied user-unit lengths (at most 256 nonnegative values); empty means none. Use SetStrokeDasharray(string) for units. |  |
| `overflow` | "visible"|"hidden"|"scroll"|"auto"|"" Viewport overflow; scroll reads as hidden and auto reads as visible. Empty after invalidation; invalid writes are ignored. |  |
| `cubicPathPoints` | Vector2[] Normalized cubic points copied into a Lua array; writes use SetCubicPathPoints with fixed topology. |  |

**方法（68）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `IsValid` | `() -> boolean` | Return false after the owning instance is destroyed, unloaded or reloa |
| `GetId` | `() -> string` | Return the original SVG id. |
| `GetTagName` | `() -> string` | Return the parsed SVG tag name; empty after invalidation. |
| `GetLocalName` | `() -> string` | Return the local tag name; supported SVG element names have no prefix. |
| `GetParentElement` | `() -> SvgElement` | Return the containing instance node, or nil at the root. |
| `GetElementById` | `(id: string) -> SvgElement` | Find a descendant within this group or use instance. |
| `SetTransformOrigin` | `(x: number, y: number) -> boolean` | Set the local script rotation/scale pivot. |
| `GetTransformOrigin` | `() -> Vector2` | Return the local script rotation/scale origin, excluding authored tran |
| `SetTranslate` | `(x: number, y: number) -> boolean` | Set the local script translation modifier. |
| `GetTranslate` | `() -> Vector2` | Return the local script translation modifier, excluding authored trans |
| `SetRotate` | `(degrees: number) -> boolean` | Set clockwise script rotation in degrees. |
| `GetRotate` | `() -> number` | Return script rotation in degrees, excluding authored transforms; zero |
| `SetScale` | `(x: number, y: number) -> boolean` | Set the local script scale modifier. |
| `GetScale` | `() -> Vector2` | Return the local script scale modifier, excluding authored transforms; |
| `SetTransformOverride` | `(a: number, b: number, c: number, d: number, e: number, f: number) -> boolean` | Override the complete local matrix, preserving underlying animation. |
| `ClearTransformOverride` | `() -> boolean` | Restore the animated matrix times the script modifier. |
| `SetFill` | `(color: Color) -> boolean` | Override fill with a solid Color, including descendants that inherit f |
| `GetFill` | `() -> string` | Return evaluated paint with symbolic values and fallback preserved; em |
| `SetStroke` | `(color: Color) -> boolean` | Override stroke with a finite solid color; invalid input or handles re |
| `GetStroke` | `() -> string` | Return evaluated stroke paint; empty after invalidation. |
| `SetColor` | `(color: Color) -> boolean` | Override inherited currentColor with a finite solid color; return fals |
| `GetColor` | `() -> Color` | Return evaluated currentColor, excluding paint opacity; transparent bl |
| `SetStopColor` | `(color: Color) -> boolean` | Override stop-color with a finite solid color, clearing currentColor;  |
| `GetStopColor` | `() -> string` | Return evaluated stop-color, preserving currentColor; empty after inva |
| `SetStopOpacity` | `(value: number) -> boolean` | Override stop opacity with a finite value in [0,1]; return false witho |
| `GetStopOpacity` | `() -> number` | Return evaluated stop opacity, excluding the color's alpha; zero after |
| `SetColorInterpolation` | `(value: "sRGB"|"linearRGB"|"auto") -> boolean` | Override inherited gradient interpolation with sRGB, linearRGB or auto |
| `GetColorInterpolation` | `() -> "sRGB"|"linearRGB"|""` | Return evaluated sRGB/linearRGB gradient interpolation; empty after in |
| `ClearFillOverride` | `() -> boolean` | Remove fill override and restore the current animated/inherited value. |
| `SetOpacity` | `(opacity: number) -> boolean` | Set element/group opacity in [0,1]. |
| `GetOpacity` | `() -> number` | Return evaluated element opacity, excluding ancestor group compositing |
| `SetDisplay` | `(display: string) -> boolean` | Set subtree display eligibility with inline or none; reject invalid va |
| `GetDisplay` | `() -> string` | Return evaluated subtree display eligibility as inline or none; empty  |
| `GetVisibility` | `() -> string` | Return evaluated visible/hidden, normalizing collapse to hidden; empty |
| `SetVisibility` | `(visibility: string) -> boolean` | Override inherited/animated visibility with visible, hidden or collaps |
| `SetPointerEvents` | `(value: "none"|"auto"|"visiblePainted"|"visibleFill"|"visibleStroke"|"visible"|"painted"|"fill"|"stroke"|"all") -> boolean` | Hit-test eligibility; bounding-box is unsupported. Override this insta |
| `GetPointerEvents` | `() -> "none"|"auto"|"visiblePainted"|"visibleFill"|"visibleStroke"|"visible"|"painted"|"fill"|"stroke"|"all"|""` | Return the evaluated value; empty after invalidation. |
| `SetStrokeLinecap` | `(value: "butt"|"round"|"square") -> boolean` | Stroke endpoint shape. Override this instance; invalid input/handles r |
| `GetStrokeLinecap` | `() -> "butt"|"round"|"square"|""` | Return the evaluated value; empty after invalidation. |
| `SetStrokeLinejoin` | `(value: "miter"|"round"|"bevel") -> boolean` | Stroke corner shape; arcs and miter-clip are unsupported. Override thi |
| `GetStrokeLinejoin` | `() -> "miter"|"round"|"bevel"|""` | Return the evaluated value; empty after invalidation. |
| `SetFillRule` | `(value: "nonzero"|"evenodd") -> boolean` | Fill winding rule. Override this instance; invalid input/handles retur |
| `GetFillRule` | `() -> "nonzero"|"evenodd"|""` | Return the evaluated value; empty after invalidation. |
| `SetClipRule` | `(value: "nonzero"|"evenodd") -> boolean` | Winding rule for geometry inside a clipPath. Override this instance; i |
| `GetClipRule` | `() -> "nonzero"|"evenodd"|""` | Return the evaluated value; empty after invalidation. |
| `SetPaintOrder` | `(value: "normal"|"fill"|"stroke"|"markers"|"fill stroke"|"fill markers"|"stroke fill"|"stroke markers"|"markers fill"|"markers stroke"|"fill stroke markers"|"fill markers stroke"|"stroke fill markers"|"stroke markers fill"|"markers fill stroke"|"markers stroke fill") -> boolean` | Paint order; markers tokens are accepted but markers are not rendered. |
| `GetPaintOrder` | `() -> "fill` | Return the evaluated value; empty after invalidation. |
| `SetFillOpacity` | `(value: number) -> boolean` | Fill opacity in [0,1], excluding group compositing. Override this inst |
| `GetFillOpacity` | `() -> number` | Return the evaluated value; zero after invalidation. |
| `SetStrokeOpacity` | `(value: number) -> boolean` | Stroke opacity in [0,1], excluding group compositing. Override this in |
| `GetStrokeOpacity` | `() -> number` | Return the evaluated value; zero after invalidation. |
| `SetStrokeMiterlimit` | `(value: number) -> boolean` | Stroke miter limit, at least 1. Override this instance; invalid input/ |
| `GetStrokeMiterlimit` | `() -> number` | Return the evaluated value; zero after invalidation. |
| `SetClipPath` | `(value: string) -> boolean` | Override clipping with none or a local url(#id), accepting optional qu |
| `GetClipPath` | `() -> string` | Return evaluated none/url(#id), or empty after invalidation; clip-path |
| `SetStrokeWidth` | `(value: string) -> boolean` | Override stroke width with a nonnegative length. Supports unitless, px |
| `GetStrokeWidth` | `() -> number` | Return evaluated stroke width in SVG user units; zero after invalidati |
| `SetStrokeDashoffset` | `(value: string) -> boolean` | Override dash offset with the same length syntax as stroke width, incl |
| `GetStrokeDashoffset` | `() -> number` | Return evaluated dash offset in SVG user units; zero after invalidatio |
| `SetStrokeDasharray` | `(value: string) -> boolean` | Override dashes with none or up to 256 comma/space-separated lengths u |
| `GetStrokeDasharray` | `() -> number[]` | Return a copy of evaluated dash lengths in user units; empty for none  |
| `SetOverflow` | `(value: "visible"|"hidden"|"scroll"|"auto") -> boolean` | Override viewport overflow; scroll clips like hidden and auto resolves |
| `GetOverflow` | `() -> "visible"|"hidden"|""` | Return evaluated visible/hidden overflow; empty after invalidation. |
| `ClearStyleOverride` | `(property: "fill"|"stroke"|"color"|"opacity"|"fill-opacity"|"stroke-opacity"|"stroke-width"|"stroke-miterlimit"|"stroke-dasharray"|"stroke-dashoffset"|"paint-order"|"stroke-linecap"|"stroke-linejoin"|"fill-rule"|"clip-rule"|"visibility"|"display"|"clip-path"|"pointer-events"|"stop-color"|"stop-opacity"|"overflow"|"color-interpolation") -> boolean` | Remove one script override by its SVG property name, restoring authore |
| `SetLine` | `(x1: number, y1: number, x2: number, y2: number) -> boolean` | Replace instance line geometry without changing the shared resource. |
| `GetCubicPathPoints` | `() -> Vector2[]` | Return normalized cubic control points in subpath order. |
| `SetCubicPathPoints` | `(points: Vector2[]) -> boolean` | Set points using exactly the current normalized subpath layout. |
| `BindKeyframes` | `(property: string, values: string, keyTimes: string, duration: number, loop: boolean, transformType?: string) -> boolean` | Bind SVG values/keyTimes lists once for native sampling; no per-frame  |


### SvgInstance  `: Object`

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `currentTime` | number Non-wrapped time in seconds; writes use SetCurrentTime without changing playback state. |  |
| `playbackRate` | number Nonnegative timeline multiplier; writes use SetPlaybackRate. |  |
| `animationsPaused` | boolean Whether timeline advancement is paused; use PauseAnimations/UnpauseAnimations to change it. |  |
| `loaded` | boolean Whether a document is loaded. |  |
| `error` | string Most recent load or rendering error. |  |
| `width` | number Root viewport width in SVG logical units. |  |
| `height` | number Root viewport height in SVG logical units. |  |

**方法（17）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Load` | `(path: string) -> boolean` | Load a .svg resource; failure preserves the previous document and node |
| `Unload` | `()` | Unload and invalidate all existing node handles. |
| `Update` | `(dt: number)` | Advance the playing clock by nonnegative seconds. |
| `SetCurrentTime` | `(seconds: number) -> boolean` | Evaluate an absolute nonnegative time without changing playback state. |
| `UnpauseAnimations` | `()` | Resume Update-driven playback. |
| `PauseAnimations` | `()` | PauseAnimations clock advancement. |
| `SetPlaybackRate` | `(speed: number) -> boolean` | Set a finite nonnegative playback multiplier. |
| `GetPlaybackRate` | `() -> number` | Return the nonnegative timeline multiplier. |
| `GetCurrentTime` | `() -> number` | Return the unwrapped time in seconds. |
| `AnimationsPaused` | `() -> boolean` | Return whether timeline advancement is paused. |
| `IsLoaded` | `() -> boolean` | Return whether a document is loaded. |
| `GetError` | `() -> string` | Return the most recent error. |
| `GetWidth` | `() -> number` | Return the SVG viewport width. |
| `GetHeight` | `() -> number` | Return the SVG viewport height. |
| `GetElementById` | `(id: string) -> SvgElement` | Find an instance node by SVG id. |
| `ElementFromPoint` | `(x: number, y: number, tolerance?: number) -> SvgElement` | Pick in SVG viewport coordinates; tolerance is in viewport units and s |
| `ElementsFromPoint` | `(x: number, y: number, tolerance?: number) -> SvgElement[]` | Return all eligible elements, topmost first and without duplicates, us |


### Pass  `: RefCounted`

**属性（15）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | string |  |
| `index` | integer |  |
| `blendMode` | BlendMode |  |
| `cullMode` | CullMode |  |
| `depthTestMode` | CompareMode |  |
| `lightingMode` | PassLightingMode |  |
| `depthWrite` | boolean |  |
| `alphaToCoverage` | boolean |  |
| `desktop` | boolean |  |
| `vertexShader` | string |  |
| `pixelShader` | string |  |
| `vertexShaderDefines` | string |  |
| `pixelShaderDefines` | string |  |
| `vertexShaderDefineExcludes` | string |  |
| `pixelShaderDefineExcludes` | string |  |

**方法（29）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetBlendMode` | `(mode: BlendMode)` |  |
| `SetCullMode` | `(mode: CullMode)` |  |
| `SetDepthTestMode` | `(mode: CompareMode)` |  |
| `SetLightingMode` | `(mode: PassLightingMode)` |  |
| `SetDepthWrite` | `(enable: boolean)` |  |
| `SetAlphaToCoverage` | `(enable: boolean)` |  |
| `SetIsDesktop` | `(enable: boolean)` |  |
| `SetVertexShader` | `(name: string)` |  |
| `SetPixelShader` | `(name: string)` |  |
| `SetVertexShaderDefines` | `(defines: string)` |  |
| `SetPixelShaderDefines` | `(defines: string)` |  |
| `SetVertexShaderDefineExcludes` | `(excludes: string)` |  |
| `SetPixelShaderDefineExcludes` | `(excludes: string)` |  |
| `ReleaseShaders` | `()` |  |
| `GetName` | `() -> string` |  |
| `GetIndex` | `() -> integer` |  |
| `GetCullMode` | `() -> CullMode` |  |
| `GetBlendMode` | `() -> BlendMode` |  |
| `GetDepthTestMode` | `() -> CompareMode` |  |
| `GetLightingMode` | `() -> PassLightingMode` |  |
| `GetDepthWrite` | `() -> boolean` |  |
| `GetAlphaToCoverage` | `() -> boolean` |  |
| `IsDesktop` | `() -> boolean` |  |
| `GetVertexShader` | `() -> string` |  |
| `GetPixelShader` | `() -> string` |  |
| `GetVertexShaderDefines` | `() -> string` |  |
| `GetPixelShaderDefines` | `() -> string` |  |
| `GetVertexShaderDefineExcludes` | `() -> string` |  |
| `GetPixelShaderDefineExcludes` | `() -> string` |  |


### Technique  `: Resource`

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `supported` | boolean |  |
| `desktop` | boolean |  |
| `numPasses` | integer |  |

**方法（13）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetIsDesktop` | `(enable: boolean)` |  |
| `CreatePass` | `(passName: string) -> Pass` |  |
| `RemovePass` | `(passName: string)` |  |
| `ReleaseShaders` | `()` |  |
| `Clone` | `(cloneName?: string) -> Technique` |  |
| `HasPass` | `(type: string) -> boolean` |  |
| `GetPass` | `(type: string) -> Pass` |  |
| `GetSupportedPass` | `(type: string) -> Pass` |  |
| `IsSupported` | `() -> boolean` |  |
| `IsDesktop` | `() -> boolean` |  |
| `GetNumPasses` | `() -> integer` |  |
| `GetPassTypes` | `() -> string[]` |  |
| `GetPasses` | `() -> Pass[]` |  |


### Terrain  `: Component`

**属性（25）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `patchSize` | integer |  |
| `spacing` | Vector3 |  |
| `numVertices` | IntVector2 |  |
| `numPatches` | IntVector2 |  |
| `maxLodLevels` | integer |  |
| `occlusionLodLevel` | integer |  |
| `smoothing` | boolean |  |
| `heightMap` | Image |  |
| `material` | Material |  |
| `northNeighbor` | Terrain |  |
| `southNeighbor` | Terrain |  |
| `westNeighbor` | Terrain |  |
| `eastNeighbor` | Terrain |  |
| `drawDistance` | number |  |
| `shadowDistance` | number |  |
| `lodBias` | number |  |
| `viewMask` | integer |  |
| `lightMask` | integer |  |
| `shadowMask` | integer |  |
| `zoneMask` | integer |  |
| `maxLights` | integer |  |
| `visible` | boolean |  |
| `castShadows` | boolean |  |
| `occluder` | boolean |  |
| `occludee` | boolean |  |

**方法（56）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetPatchSize` | `(size: integer)` |  |
| `SetSpacing` | `(spacing: Vector3)` |  |
| `SetMaxLodLevels` | `(levels: integer)` |  |
| `SetOcclusionLodLevel` | `(level: integer)` |  |
| `SetSmoothing` | `(enable: boolean)` |  |
| `SetHeightMap` | `(image: Image) -> boolean` |  |
| `SetMaterial` | `(material: Material)` |  |
| `SetNorthNeighbor` | `(north: Terrain)` |  |
| `SetSouthNeighbor` | `(south: Terrain)` |  |
| `SetWestNeighbor` | `(west: Terrain)` |  |
| `SetEastNeighbor` | `(east: Terrain)` |  |
| `SetNeighbors` | `(north: Terrain, south: Terrain, west: Terrain, east: Terrain)` |  |
| `SetDrawDistance` | `(distance: number)` |  |
| `SetShadowDistance` | `(distance: number)` |  |
| `SetLodBias` | `(bias: number)` |  |
| `SetViewMask` | `(mask: integer)` |  |
| `SetLightMask` | `(mask: integer)` |  |
| `SetShadowMask` | `(mask: integer)` |  |
| `SetZoneMask` | `(mask: integer)` |  |
| `SetMaxLights` | `(num: integer)` |  |
| `SetCastShadows` | `(enable: boolean)` |  |
| `SetOccluder` | `(enable: boolean)` |  |
| `SetOccludee` | `(enable: boolean)` |  |
| `ApplyHeightMap` | `()` |  |
| `GetPatchSize` | `() -> integer` |  |
| `GetSpacing` | `() -> Vector3` |  |
| `GetNumVertices` | `() -> IntVector2` |  |
| `GetNumPatches` | `() -> IntVector2` |  |
| `GetMaxLodLevels` | `() -> integer` |  |
| `GetOcclusionLodLevel` | `() -> integer` |  |
| `GetSmoothing` | `() -> boolean` |  |
| `GetHeightMap` | `() -> Image` |  |
| `GetMaterial` | `() -> Material` |  |
| `GetNorthNeighbor` | `() -> Terrain` |  |
| `GetSouthNeighbor` | `() -> Terrain` |  |
| `GetWestNeighbor` | `() -> Terrain` |  |
| `GetEastNeighbor` | `() -> Terrain` |  |
| `GetPatch` | `(index: integer) -> TerrainPatch` |  |
| `GetNeighborPatch` | `(x: integer, z: integer) -> TerrainPatch` |  |
| `GetHeight` | `(worldPosition: Vector3) -> number` |  |
| `GetNormal` | `(worldPosition: Vector3) -> Vector3` |  |
| `WorldToHeightMap` | `(worldPosition: Vector3) -> IntVector2` |  |
| `HeightMapToWorld` | `(pixelPosition: IntVector2) -> Vector3` |  |
| `GetHeightData` | `() -> number[]` |  |
| `GetDrawDistance` | `() -> number` |  |
| `GetShadowDistance` | `() -> number` |  |
| `GetLodBias` | `() -> number` |  |
| `GetViewMask` | `() -> integer` |  |
| `GetLightMask` | `() -> integer` |  |
| `GetShadowMask` | `() -> integer` |  |
| `GetZoneMask` | `() -> integer` |  |
| `GetMaxLights` | `() -> integer` |  |
| `IsVisible` | `() -> boolean` |  |
| `GetCastShadows` | `() -> boolean` |  |
| `IsOccluder` | `() -> boolean` |  |
| `IsOccludee` | `() -> boolean` |  |


### TerrainPatch  `: Drawable`

**属性（12）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `geometry` | Geometry |  |
| `maxLodGeometry` | Geometry |  |
| `occlusionGeometry` | Geometry |  |
| `vertexBuffer` | VertexBuffer |  |
| `owner` | Terrain |  |
| `northPatch` | TerrainPatch |  |
| `southPatch` | TerrainPatch |  |
| `westPatch` | TerrainPatch |  |
| `eastPatch` | TerrainPatch |  |
| `boundingBox` | BoundingBox |  |
| `coordinates` | IntVector2 |  |
| `lodLevel` | integer |  |

**方法（17）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetOwner` | `(terrain: Terrain)` |  |
| `SetNeighbors` | `(north: TerrainPatch, south: TerrainPatch, west: TerrainPatch, east: TerrainPatch)` |  |
| `SetMaterial` | `(material: Material)` |  |
| `SetBoundingBox` | `(box: BoundingBox)` |  |
| `SetCoordinates` | `(coordinates: IntVector2)` |  |
| `ResetLod` | `()` |  |
| `GetGeometry` | `() -> Geometry` |  |
| `GetMaxLodGeometry` | `() -> Geometry` |  |
| `GetOcclusionGeometry` | `() -> Geometry` |  |
| `GetVertexBuffer` | `() -> VertexBuffer` |  |
| `GetOwner` | `() -> Terrain` |  |
| `GetNorthPatch` | `() -> TerrainPatch` |  |
| `GetSouthPatch` | `() -> TerrainPatch` |  |
| `GetWestPatch` | `() -> TerrainPatch` |  |
| `GetEastPatch` | `() -> TerrainPatch` |  |
| `GetCoordinates` | `() -> IntVector2` |  |
| `GetLodLevel` | `() -> integer` |  |


### UISelectable  `: UIElement`

**构造**

```lua
fun(): UISelectable
```

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `selectionColor` | Color |  |
| `hoverColor` | Color |  |

**方法（4）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetSelectionColor` | `(color: Color)` |  |
| `SetHoverColor` | `(color: Color)` |  |
| `GetSelectionColor` | `() -> Color` |  |
| `GetHoverColor` | `() -> Color` |  |


### Text  `: UISelectable`

**构造**

```lua
fun(): Text
```

**属性（17）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `font` | Font |  |
| `fontSize` | number |  |
| `text` | string |  |
| `textAlignment` | HorizontalAlignment |  |
| `rowSpacing` | number |  |
| `wordwrap` | boolean |  |
| `autoLocalizable` | boolean |  |
| `selectionStart` | integer |  |
| `selectionLength` | integer |  |
| `textEffect` | TextEffect |  |
| `effectShadowOffset` | IntVector2 |  |
| `effectStrokeThickness` | integer |  |
| `effectRoundStroke` | boolean |  |
| `effectColor` | Color |  |
| `rowHeight` | number |  |
| `numRows` | integer |  |
| `numChars` | integer |  |

**方法（36）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetFont` | `(fontName: string, size?: number) -> boolean` |  |
| `SetFontSize` | `(size: number) -> boolean` |  |
| `SetText` | `(text: string)` |  |
| `SetTextAlignment` | `(align: HorizontalAlignment)` |  |
| `SetRowSpacing` | `(spacing: number)` |  |
| `SetWordwrap` | `(enable: boolean)` |  |
| `SetSelection` | `(start: integer, length?: integer)` |  |
| `ClearSelection` | `()` |  |
| `SetTextEffect` | `(textEffect: TextEffect)` |  |
| `SetEffectShadowOffset` | `(offset: IntVector2)` |  |
| `SetEffectStrokeThickness` | `(thickness: integer)` |  |
| `SetEffectRoundStroke` | `(roundStroke: boolean)` |  |
| `SetEffectColor` | `(effectColor: Color)` |  |
| `GetAutoLocalizable` | `() -> boolean` |  |
| `SetAutoLocalizable` | `(enable: boolean)` |  |
| `GetFont` | `() -> Font` |  |
| `GetFontSize` | `() -> number` |  |
| `GetText` | `() -> string` |  |
| `GetTextAlignment` | `() -> HorizontalAlignment` |  |
| `GetRowSpacing` | `() -> number` |  |
| `GetWordwrap` | `() -> boolean` |  |
| `GetSelectionStart` | `() -> integer` |  |
| `GetSelectionLength` | `() -> integer` |  |
| `GetTextEffect` | `() -> TextEffect` |  |
| `GetEffectShadowOffset` | `() -> IntVector2` |  |
| `GetEffectStrokeThickness` | `() -> integer` |  |
| `GetEffectRoundStroke` | `() -> boolean` |  |
| `GetEffectColor` | `() -> Color` |  |
| `GetRowHeight` | `() -> number` |  |
| `GetNumRows` | `() -> integer` |  |
| `GetNumChars` | `() -> integer` |  |
| `GetRowWidth` | `(index: integer) -> number` |  |
| `GetCharPosition` | `(index: integer) -> Vector2` |  |
| `GetCharSize` | `(index: integer) -> Vector2` |  |
| `SetEffectDepthBias` | `(bias: number)` |  |
| `GetEffectDepthBias` | `() -> number` |  |


### Text3D  `: Drawable`

**构造**

```lua
fun(): Text3D
```

**属性（24）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `font` | Font |  |
| `material` | Material |  |
| `fontSize` | number |  |
| `text` | string |  |
| `textAlignment` | HorizontalAlignment |  |
| `horizontalAlignment` | HorizontalAlignment |  |
| `verticalAlignment` | VerticalAlignment |  |
| `rowSpacing` | number |  |
| `wordwrap` | boolean |  |
| `textEffect` | TextEffect |  |
| `effectShadowOffset` | IntVector2 |  |
| `effectStrokeThickness` | integer |  |
| `effectRoundStroke` | boolean |  |
| `effectColor` | Color |  |
| `effectDepthBias` | number |  |
| `width` | integer |  |
| `color` | Color |  |
| `height` | integer |  |
| `rowHeight` | number |  |
| `numRows` | integer |  |
| `numChars` | integer |  |
| `opacity` | number |  |
| `fixedScreenSize` | boolean |  |
| `faceCameraMode` | FaceCameraMode |  |

**方法（48）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetFont` | `(fontName: string, size?: number) -> boolean` |  |
| `SetFontSize` | `(size: number) -> boolean` |  |
| `SetMaterial` | `(material: Material)` |  |
| `SetText` | `(text: string)` |  |
| `SetAlignment` | `(hAlign: HorizontalAlignment, vAlign: VerticalAlignment)` |  |
| `SetHorizontalAlignment` | `(align: HorizontalAlignment)` |  |
| `SetVerticalAlignment` | `(align: VerticalAlignment)` |  |
| `SetTextAlignment` | `(align: HorizontalAlignment)` |  |
| `SetRowSpacing` | `(spacing: number)` |  |
| `SetWordwrap` | `(enable: boolean)` |  |
| `SetTextEffect` | `(textEffect: TextEffect)` |  |
| `SetEffectShadowOffset` | `(offset: IntVector2)` |  |
| `SetEffectStrokeThickness` | `(thickness: integer)` |  |
| `SetEffectRoundStroke` | `(roundStroke: boolean)` |  |
| `SetEffectColor` | `(effectColor: Color)` |  |
| `SetEffectDepthBias` | `(bias: number)` |  |
| `SetWidth` | `(width: integer)` |  |
| `SetColor` | `(color: Color)` |  |
| `SetOpacity` | `(opacity: number)` |  |
| `SetFixedScreenSize` | `(enable: boolean)` |  |
| `SetFaceCameraMode` | `(mode: FaceCameraMode)` |  |
| `GetFont` | `() -> Font` |  |
| `GetMaterial` | `() -> Material` |  |
| `GetFontSize` | `() -> number` |  |
| `GetText` | `() -> string` |  |
| `GetTextAlignment` | `() -> HorizontalAlignment` |  |
| `GetHorizontalAlignment` | `() -> HorizontalAlignment` |  |
| `GetVerticalAlignment` | `() -> VerticalAlignment` |  |
| `GetRowSpacing` | `() -> number` |  |
| `GetWordwrap` | `() -> boolean` |  |
| `GetTextEffect` | `() -> TextEffect` |  |
| `GetEffectShadowOffset` | `() -> IntVector2` |  |
| `GetEffectStrokeThickness` | `() -> integer` |  |
| `GetEffectRoundStroke` | `() -> boolean` |  |
| `GetEffectColor` | `() -> Color` |  |
| `GetEffectDepthBias` | `() -> number` |  |
| `GetWidth` | `() -> integer` |  |
| `GetHeight` | `() -> integer` |  |
| `GetRowHeight` | `() -> number` |  |
| `GetNumRows` | `() -> integer` |  |
| `GetNumChars` | `() -> integer` |  |
| `GetRowWidth` | `(index: integer) -> number` |  |
| `GetCharPosition` | `(index: integer) -> Vector2` |  |
| `GetCharSize` | `(index: integer) -> Vector2` |  |
| `GetColor` | `(corner: Corner) -> Color` |  |
| `GetOpacity` | `() -> number` |  |
| `IsFixedScreenSize` | `() -> boolean` |  |
| `GetFaceCameraMode` | `() -> FaceCameraMode` |  |


### Texture  `: ResourceWithMetadata`

**属性（16）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `format` | integer |  |
| `compressed` | boolean |  |
| `levels` | integer |  |
| `width` | integer |  |
| `height` | integer |  |
| `components` | integer |  |
| `filterMode` | TextureFilterMode |  |
| `anisotropy` | integer |  |
| `borderColor` | Color |  |
| `sRGB` | boolean |  |
| `multiSample` | integer |  |
| `autoResolve` | boolean |  |
| `resolveDirty` | boolean |  |
| `levelsDirty` | boolean |  |
| `backupTexture` | Texture |  |
| `usage` | TextureUsage |  |

**方法（36）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetComputeWrite` | `(enabled: boolean)` | Enable storage-image writes before allocating the texture. |
| `IsComputeWrite` | `() -> boolean` | Return the requested allocation flag; set it before SetSize to enable  |
| `SetNumLevels` | `(levels: integer)` |  |
| `SetFilterMode` | `(filter: TextureFilterMode)` |  |
| `SetAddressMode` | `(coord: TextureCoordinate, address: TextureAddressMode)` |  |
| `SetAnisotropy` | `(level: integer)` |  |
| `SetBorderColor` | `(color: Color)` |  |
| `SetShadowCompare` | `(enable: boolean)` | Enable depth comparison sampling for a shadow texture. |
| `SetSRGB` | `(enable: boolean)` |  |
| `SetBackupTexture` | `(texture: Texture)` |  |
| `SetMipsToSkip` | `(quality: MaterialQuality, toSkip: integer)` |  |
| `GetFormat` | `() -> integer` |  |
| `IsCompressed` | `() -> boolean` |  |
| `GetLevels` | `() -> integer` |  |
| `GetWidth` | `() -> integer` |  |
| `GetHeight` | `() -> integer` |  |
| `GetFilterMode` | `() -> TextureFilterMode` |  |
| `GetAddressMode` | `(coord: TextureCoordinate) -> TextureAddressMode` |  |
| `GetAnisotropy` | `() -> integer` |  |
| `GetBorderColor` | `() -> Color` |  |
| `GetShadowCompare` | `() -> boolean` | Return whether depth comparison sampling is enabled. |
| `GetSRGB` | `() -> boolean` |  |
| `GetMultiSample` | `() -> integer` |  |
| `GetAutoResolve` | `() -> boolean` |  |
| `IsResolveDirty` | `() -> boolean` |  |
| `GetLevelsDirty` | `() -> boolean` |  |
| `GetBackupTexture` | `() -> Texture` |  |
| `GetMipsToSkip` | `(quality: MaterialQuality) -> integer` |  |
| `GetLevelWidth` | `(level: integer) -> integer` |  |
| `GetLevelHeight` | `(level: integer) -> integer` |  |
| `GetUsage` | `() -> TextureUsage` |  |
| `GetDataSize` | `(width: integer, height: integer) -> integer` |  |
| `GetRowDataSize` | `(width: integer) -> integer` |  |
| `GetComponents` | `() -> integer` |  |
| `GetDataAsync` | `(level: integer Mip level, starting at zero, callback: fun(success: boolean, image: Image):nil RGBA8 pixels, valid only during callback and raises an error if used afterwards; nil on failure)` | Read a mip asynchronously as an RGBA8 Image. Texture types without asy |
| `GetDataAsyncCPU` | `(level: integer Mip level, starting at zero, callback: fun(success: boolean, texture: CPUTexture):nil Storage-format pixels, valid only during callback and raises an error if used afterwards; nil on failure)` | Read a mip asynchronously in the GPU storage format, without conversio |


### Texture2D  `: Texture`

**构造**

```lua
fun(): Texture2D
```

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `renderSurface` | RenderSurface |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetSize` | `(width: integer, height: integer, format: integer, usage?: TextureUsage, multiSample?: integer, autoResolve?: boolean) -> boolean` |  |
| `SetData` | `(image: Image, useAlpha?: boolean) -> boolean` |  |
| `GetImage` | `() -> Image|nil` | Read mip zero synchronously. Renderers without synchronous texture rea |
| `GetImageAsync` | `(callback: fun(image: Image|nil):nil Image owned by the caller like GetImage(); may be kept or disposed. nil on readback failure.)` | Asynchronous counterpart of GetImage(): the callback receives the Imag |
| `GetRenderSurface` | `() -> RenderSurface` |  |


### Texture2DArray  `: Texture`

**构造**

```lua
fun(): Texture2DArray
```

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `layers` | integer |  |
| `renderSurface` | RenderSurface |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetLayers` | `(layers: integer)` |  |
| `SetSize` | `(layers: integer, width: integer, height: integer, format: integer, usage?: TextureUsage) -> boolean` | Set layers, size in pixels, format and usage. Zero layers preserves th |
| `SetData` | `(layer: integer, image: Image, useAlpha?: boolean) -> boolean` |  |
| `GetLayers` | `() -> integer` |  |
| `GetRenderSurface` | `(layer?: integer) -> RenderSurface` | Return a layer render surface, or null for an invalid layer or non-ren |


### Texture3D  `: Texture`

**构造**

```lua
fun(): Texture3D
```

**方法（2）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetSize` | `(width: integer, height: integer, depth: integer, format: integer, usage?: TextureUsage) -> boolean` |  |
| `SetData` | `(image: Image, useAlpha?: boolean) -> boolean` |  |


### TextureCube  `: Texture`

**构造**

```lua
fun(): TextureCube
```

**方法（4）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetSize` | `(size: integer, format: integer, usage?: TextureUsage, multiSample?: integer) -> boolean` |  |
| `SetData` | `(face: CubeMapFace, image: Image, useAlpha?: boolean) -> boolean` |  |
| `GetImage` | `(face: CubeMapFace) -> Image` |  |
| `GetRenderSurface` | `(face: CubeMapFace) -> RenderSurface` |  |


### TileMap2D  `: Component`

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `tmxFile` | TmxFile2D |  |
| `info` | TileMapInfo2D |  |
| `numLayers` | integer |  |

**方法（7）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetTmxFile` | `(tmxFile: TmxFile2D)` |  |
| `GetTmxFile` | `() -> TmxFile2D` |  |
| `GetInfo` | `() -> TileMapInfo2D` |  |
| `GetNumLayers` | `() -> integer` |  |
| `GetLayer` | `(index: integer) -> TileMapLayer2D` |  |
| `TileIndexToPosition` | `(x: integer, y: integer) -> Vector2` |  |
| `PositionToTileIndex` | `(position: Vector2, x?: integer, y?: integer) -> boolean` |  |


### TileMapInfo2D

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `orientation` | Orientation2D |  |
| `width` | integer |  |
| `height` | integer |  |
| `tileWidth` | number |  |
| `tileHeight` | number |  |
| `mapWidth` | number |  |
| `mapHeight` | number |  |

**方法（2）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetMapWidth` | `() -> number` |  |
| `GetMapHeight` | `() -> number` |  |


### PropertySet2D

**方法（2）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `HasProperty` | `(name: string) -> boolean` |  |
| `GetProperty` | `(name: string) -> string` |  |


### Tile2D

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `gid` | integer |  |
| `sprite` | Sprite2D |  |

**方法（7）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetGid` | `() -> integer` |  |
| `GetFlipX` | `() -> boolean` |  |
| `GetFlipY` | `() -> boolean` |  |
| `GetSwapXY` | `() -> boolean` |  |
| `GetSprite` | `() -> Sprite2D` |  |
| `HasProperty` | `(name: string) -> boolean` |  |
| `GetProperty` | `(name: string) -> string` |  |


### TileMapObject2D

**属性（8）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `objectType` | TileMapObjectType2D |  |
| `name` | string |  |
| `type` | string |  |
| `position` | Vector2 |  |
| `size` | Vector2 |  |
| `numPoints` | integer |  |
| `tileGid` | integer |  |
| `tileSprite` | Sprite2D |  |

**方法（14）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetObjectType` | `() -> TileMapObjectType2D` |  |
| `GetName` | `() -> string` |  |
| `GetType` | `() -> string` |  |
| `GetPosition` | `() -> Vector2` |  |
| `GetSize` | `() -> Vector2` |  |
| `GetNumPoints` | `() -> integer` |  |
| `GetPoint` | `(index: integer) -> Vector2` |  |
| `GetTileGid` | `() -> integer` |  |
| `GetTileFlipX` | `() -> boolean` |  |
| `GetTileFlipY` | `() -> boolean` |  |
| `GetTileSwapXY` | `() -> boolean` |  |
| `GetTileSprite` | `() -> Sprite2D` |  |
| `HasProperty` | `(name: string) -> boolean` |  |
| `GetProperty` | `(name: string) -> string` |  |


### TileMapLayer2D  `: Component`

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `drawOrder` | integer |  |
| `visible` | boolean |  |
| `layerType` | TileMapLayerType2D |  |
| `width` | integer |  |
| `height` | integer |  |
| `numObjects` | integer |  |
| `imageNode` | Node |  |

**方法（15）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetDrawOrder` | `(drawOrder: integer)` |  |
| `SetVisible` | `(visible: boolean)` |  |
| `GetDrawOrder` | `() -> integer` |  |
| `IsVisible` | `() -> boolean` |  |
| `HasProperty` | `(name: string) -> boolean` |  |
| `GetProperty` | `(name: string) -> string` |  |
| `GetLayerType` | `() -> TileMapLayerType2D` |  |
| `GetWidth` | `() -> integer` |  |
| `GetHeight` | `() -> integer` |  |
| `GetTileNode` | `(x: integer, y: integer) -> Node` |  |
| `GetTile` | `(x: integer, y: integer) -> Tile2D` |  |
| `GetNumObjects` | `() -> integer` |  |
| `GetObject` | `(index: integer) -> TileMapObject2D` |  |
| `GetObjectNode` | `(index: integer) -> Node` |  |
| `GetImageNode` | `() -> Node` |  |


### Time  `: Object`

**属性（4）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `frameNumber` | integer |  |
| `timeStep` | number |  |
| `timerPeriod` | integer |  |
| `elapsedTime` | number |  |

**方法（10）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetFrameNumber` | `() -> integer` |  |
| `GetTimeStep` | `() -> number` |  |
| `GetTimerPeriod` | `() -> integer` |  |
| `GetElapsedTime` | `() -> number` |  |
| `GetFramesPerSecond` | `() -> number` |  |
| `GetSystemTime` | `() -> integer` |  |
| `GetTimeSinceEpoch` | `() -> integer` |  |
| `GetTimeSinceEpochMs` | `() -> integer` |  |
| `GetTimeStamp` | `() -> string` |  |
| `Sleep` | `(mSec: integer)` |  |


### TmxFile2D  `: Resource`

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `edgeOffset` | number |  |

**方法（2）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetSpriteTextureEdgeOffset` | `(offset: number)` |  |
| `GetSpriteTextureEdgeOffset` | `() -> number` |  |


### ToolTip  `: UIElement`

**构造**

```lua
fun(): ToolTip
```

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `delay` | number |  |

**方法（2）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetDelay` | `(delay: number)` |  |
| `GetDelay` | `() -> number` |  |


### UI  `: Object`

**属性（23）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `root` | UIElement |  |
| `rootModalElement` | UIElement |  |
| `cursor` | Cursor |  |
| `cursorPosition` | IntVector2 |  |
| `focusElement` | UIElement |  |
| `frontElement` | UIElement |  |
| `clipboardText` | string |  |
| `doubleClickInterval` | number |  |
| `dragBeginInterval` | number |  |
| `dragBeginDistance` | integer |  |
| `defaultToolTipDelay` | number |  |
| `maxFontTextureSize` | integer |  |
| `nonFocusedMouseWheel` | boolean |  |
| `useSystemClipboard` | boolean |  |
| `useScreenKeyboard` | boolean |  |
| `useMutableGlyphs` | boolean |  |
| `forceAutoHint` | boolean |  |
| `fontHintLevel` | FontHintLevel |  |
| `fontSubpixelThreshold` | number |  |
| `fontOversampling` | integer |  |
| `modalElement` | boolean |  |
| `scale` | Vector2 |  |
| `customSize` | IntVector2 |  |

**方法（53）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetCursor` | `(cursor: Cursor)` |  |
| `SetFocusElement` | `(element: UIElement, byKey?: boolean)` |  |
| `SetModalElement` | `(modalElement: UIElement, enable: boolean) -> boolean` |  |
| `Clear` | `()` |  |
| `DebugDraw` | `(element: UIElement)` |  |
| `LoadLayout` | `(source: File, styleFile?: XMLFile) -> UIElement` |  |
| `SaveLayout` | `(dest: Serializer, element: UIElement) -> boolean` |  |
| `SetClipboardText` | `(text: string)` |  |
| `SetDoubleClickInterval` | `(interval: number)` |  |
| `SetMaxDoubleClickDistance` | `(pixels: number)` |  |
| `SetDragBeginInterval` | `(interval: number)` |  |
| `SetDragBeginDistance` | `(pixels: integer)` |  |
| `SetDefaultToolTipDelay` | `(delay: number)` |  |
| `SetMaxFontTextureSize` | `(size: integer)` |  |
| `SetNonFocusedMouseWheel` | `(nonFocusedMouseWheel: boolean)` |  |
| `SetUseSystemClipboard` | `(enable: boolean)` |  |
| `SetUseScreenKeyboard` | `(enable: boolean)` |  |
| `SetUseMutableGlyphs` | `(enable: boolean)` |  |
| `SetForceAutoHint` | `(enable: boolean)` |  |
| `SetFontHintLevel` | `(level: FontHintLevel)` |  |
| `SetFontSubpixelThreshold` | `(threshold: number)` |  |
| `SetFontOversampling` | `(limit: integer)` |  |
| `SetScale` | `(scale: Vector2)` |  |
| `SetWidth` | `(width: number)` |  |
| `SetHeight` | `(height: number)` |  |
| `SetCustomSize` | `(size: IntVector2)` |  |
| `GetRoot` | `() -> UIElement` |  |
| `GetRootModalElement` | `() -> UIElement` |  |
| `GetCursor` | `() -> Cursor` |  |
| `GetCursorPosition` | `() -> IntVector2` |  |
| `GetElementAt` | `(position: IntVector2, enabledOnly?: boolean) -> UIElement` |  |
| `GetFocusElement` | `() -> UIElement` |  |
| `GetFrontElement` | `() -> UIElement` |  |
| `GetDragElement` | `(index: integer) -> UIElement` |  |
| `GetClipboardText` | `() -> string` |  |
| `GetDoubleClickInterval` | `() -> number` |  |
| `GetMaxDoubleClickDistance` | `() -> number` |  |
| `GetDragBeginInterval` | `() -> number` |  |
| `GetDragBeginDistance` | `() -> integer` |  |
| `GetDefaultToolTipDelay` | `() -> number` |  |
| `GetMaxFontTextureSize` | `() -> integer` |  |
| `IsNonFocusedMouseWheel` | `() -> boolean` |  |
| `GetUseSystemClipboard` | `() -> boolean` |  |
| `GetUseScreenKeyboard` | `() -> boolean` |  |
| `GetUseMutableGlyphs` | `() -> boolean` |  |
| `GetForceAutoHint` | `() -> boolean` |  |
| `GetFontHintLevel` | `() -> FontHintLevel` |  |
| `GetFontSubpixelThreshold` | `() -> number` |  |
| `GetFontOversampling` | `() -> integer` |  |
| `HasModalElement` | `() -> boolean` |  |
| `IsDragging` | `() -> boolean` |  |
| `GetScale` | `() -> Vector2` |  |
| `GetCustomSize` | `() -> IntVector2` |  |


### UIComponent  `: Component`

**构造**

```lua
fun(): UIComponent
```

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `root` | UIElement |  |
| `material` | Material |  |
| `texture` | Texture2D |  |

**方法（3）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetRoot` | `() -> UIElement` |  |
| `GetMaterial` | `() -> Material` |  |
| `GetTexture` | `() -> Texture2D` |  |


### ValueAnimation  `: Resource`

**构造**

```lua
fun(): ValueAnimation
```

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `interpolationMethod` | InterpMethod |  |
| `splineTension` | number |  |
| `valueType` | VariantType |  |

**方法（8）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetInterpolationMethod` | `(method: InterpMethod)` |  |
| `SetSplineTension` | `(tension: number)` |  |
| `SetValueType` | `(valueType: VariantType)` |  |
| `SetKeyFrame` | `(time: number, value: Variant) -> boolean` |  |
| `SetEventFrame` | `(time: number, eventType: StringHash|string, eventData?: VariantMap)` |  |
| `GetInterpolationMethod` | `() -> InterpMethod` |  |
| `GetSplineTension` | `() -> number` |  |
| `GetValueType` | `() -> VariantType` |  |


### ResourceRef

**构造**

```lua
fun(type: StringHash|string): ResourceRef
fun(type: StringHash|string, name: string): ResourceRef
fun(type: string, name: string): ResourceRef
fun(rhs: ResourceRef): ResourceRef
fun(): ResourceRef
fun(self: ResourceRef, type: StringHash|string): ResourceRef
fun(type: StringHash|string): ResourceRef
fun(self: ResourceRef, type: StringHash|string, name: string): ResourceRef
```

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `type` | StringHash|string |  |
| `name` | string |  |

**运算符**：`eq(ResourceRef): boolean`


### ResourceRefList

**构造**

```lua
fun(type: StringHash|string): ResourceRefList
fun(): ResourceRefList
fun(self: ResourceRefList, type: StringHash|string): ResourceRefList
fun(type: StringHash|string): ResourceRefList
```

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `type` | StringHash|string |  |

**运算符**：`eq(ResourceRefList): boolean`


### Variant

**构造**

```lua
fun(value: boolean): Variant
fun(value: number): Variant
fun(value: string): Variant
fun(value: Vector2): Variant
fun(value: Vector3): Variant
fun(value: Vector4): Variant
fun(value: Quaternion): Variant
fun(value: Color): Variant
```

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `type` | VariantType |  |
| `typeName` | string |  |
| `zero` | boolean |  |
| `empty` | boolean |  |
| `GetPtr` | __union_func__type_str__ret_RefCountedT |  |
| `GetPtr` | fun(self: Variant): RefCounted |  |
| `GetVariantMap` | fun(self: Variant): VariantMap|nil |  |

**方法（38）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `_Setup` | `(type: string)` |  |
| `Clear` | `()` |  |
| `Set` | `(rhs: Variant)` |  |
| `Get` | `(type?: string) -> any` |  |
| `GetInt` | `() -> integer` |  |
| `GetUInt` | `() -> integer` |  |
| `GetInt64` | `() -> integer` |  |
| `GetUInt64` | `() -> integer` |  |
| `GetStringHash` | `() -> StringHash|string` |  |
| `GetBool` | `() -> boolean` |  |
| `GetFloat` | `() -> number` |  |
| `GetDouble` | `() -> number` |  |
| `GetVector2` | `() -> Vector2` |  |
| `GetVector3` | `() -> Vector3` |  |
| `GetVector4` | `() -> Vector4` |  |
| `GetQuaternion` | `() -> Quaternion` |  |
| `GetColor` | `() -> Color` |  |
| `GetString` | `() -> string` |  |
| `GetRawBuffer` | `() -> number[]` |  |
| `GetBuffer` | `() -> VectorBuffer` |  |
| `GetVoidPtr` | `(type: string) -> any` |  |
| `GetResourceRef` | `() -> ResourceRef` |  |
| `GetResourceRefList` | `() -> ResourceRefList` |  |
| `GetVariantVector` | `() -> Variant[]` |  |
| `GetVariantMap` | `() -> VariantMap` |  |
| `GetStringVector` | `() -> string[]` |  |
| `GetRect` | `() -> Rect` |  |
| `GetIntRect` | `() -> IntRect` |  |
| `GetIntVector2` | `() -> IntVector2` |  |
| `GetIntVector3` | `() -> IntVector3` |  |
| `GetMatrix3` | `() -> Matrix3` |  |
| `GetMatrix3x4` | `() -> Matrix3x4` |  |
| `GetMatrix4` | `() -> Matrix4` |  |
| `GetType` | `() -> VariantType` |  |
| `GetTypeName` | `() -> string` |  |
| `ToString` | `() -> string` |  |
| `IsZero` | `() -> boolean` |  |
| `IsEmpty` | `() -> boolean` |  |

**运算符**：`eq(Variant): boolean`


### VariantMap

**构造**

```lua
fun(): VariantMap
```

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `[string]` | Variant | Vector3 | Quaternion | Color | StringHash | IntRect | IntVector2 | IntVector3 | Matrix3 | Matrix3x4 | Matrix4 | VariantVector | VariantMap | StringVector | ResourceRef | ResourceRefList | RefCounted | VariantWithInt | VariantWithInt64 | VariantWithBool | VariantWithFloat | VariantWithString | VariantWithStringHash | VariantWithVector2 | VariantWithVector3 | VariantWithVector4 | VariantWithQuaternion | VariantWithColor | VariantWithRect | VariantWithIntRect | VariantWithIntVector2 | VariantWithIntVector3 | VariantWithMatrix3 | VariantWithMatrix3x4 | VariantWithMatrix4 | VariantWithResourceRef | VariantWithResourceRefList | VariantWithVariantVector | VariantWithStringVector | VariantWithVariantMap | VariantWithPtr | VariantWithBuffer |  |

**方法（20）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `_Setup` | `(type: string)` |  |
| `GetInt` | `(key: string) -> integer` | Get an integer value from the VariantMap by key |
| `GetString` | `(key: string) -> string` | Get a string value from the VariantMap by key |
| `GetBool` | `(key: string) -> boolean` | Get a boolean value from the VariantMap by key |
| `GetFloat` | `(key: string) -> number` | Get a float value from the VariantMap by key |
| `GetVector2` | `(key: string) -> Vector2` | Get a Vector2 value from the VariantMap by key |
| `GetVector3` | `(key: string) -> Vector3` | Get a Vector3 value from the VariantMap by key |
| `GetQuaternion` | `(key: string) -> Quaternion` | Get a Quaternion value from the VariantMap by key |
| `GetColor` | `(key: string) -> Color` | Get a Color value from the VariantMap by key |
| `GetStringHash` | `(key: string) -> StringHash` | Get a StringHash value from the VariantMap by key |
| `GetBuffer` | `(key: string) -> VectorBuffer` | Get a pointer value from the VariantMap by key (returns various object |
| `GetVariantVector` | `(key: string) -> Variant[]` | Get a variant vector value from the VariantMap by key (returns a Lua t |
| `GetStringVector` | `(key: string) -> string[]` | Get a string vector value from the VariantMap by key (returns a Lua ta |
| `GetVariantMap` | `(key: string) -> VariantMap|nil` | Get a nested variant map by key; nil when the value is not a VariantMa |
| `GetIntRect` | `(key: string) -> IntRect` | Get an IntRect value from the VariantMap by key |
| `GetIntVector2` | `(key: string) -> IntVector2` | Get an IntVector2 value from the VariantMap by key |
| `GetIntVector3` | `(key: string) -> IntVector3` | Get an IntVector3 value from the VariantMap by key |
| `GetMatrix3` | `(key: string) -> Matrix3` | Get a Matrix3 value from the VariantMap by key |
| `GetMatrix3x4` | `(key: string) -> Matrix3x4` | Get a Matrix3x4 value from the VariantMap by key |
| `GetMatrix4` | `(key: string) -> Matrix4` | Get a Matrix4 value from the VariantMap by key |


### VariantWithInt

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetInt` | fun(self: VariantWithInt): integer |  |
| `GetUInt` | fun(self: VariantWithInt): integer |  |


### VariantWithInt64

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetInt64` | fun(self: VariantWithInt64): integer |  |
| `GetUInt64` | fun(self: VariantWithInt64): integer |  |


### VariantWithBool

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetBool` | fun(self: VariantWithBool): boolean |  |


### VariantWithFloat

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetFloat` | fun(self: VariantWithFloat): number |  |
| `GetDouble` | fun(self: VariantWithFloat): number |  |


### VariantWithString

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetString` | fun(self: VariantWithString): string |  |


### VariantWithStringHash

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetStringHash` | fun(self: VariantWithStringHash): StringHash|string |  |


### VariantWithVector2

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetVector2` | fun(self: VariantWithVector2): Vector2 |  |


### VariantWithVector3

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetVector3` | fun(self: VariantWithVector3): Vector3 |  |


### VariantWithVector4

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetVector4` | fun(self: VariantWithVector4): Vector4 |  |


### VariantWithQuaternion

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetQuaternion` | fun(self: VariantWithQuaternion): Quaternion |  |


### VariantWithColor

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetColor` | fun(self: VariantWithColor): Color |  |


### VariantWithRect

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetRect` | fun(self: VariantWithRect): Rect |  |


### VariantWithIntRect

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetIntRect` | fun(self: VariantWithIntRect): IntRect |  |


### VariantWithIntVector2

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetIntVector2` | fun(self: VariantWithIntVector2): IntVector2 |  |


### VariantWithIntVector3

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetIntVector3` | fun(self: VariantWithIntVector3): IntVector3 |  |


### VariantWithMatrix3

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetMatrix3` | fun(self: VariantWithMatrix3): Matrix3 |  |


### VariantWithMatrix3x4

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetMatrix3x4` | fun(self: VariantWithMatrix3x4): Matrix3x4 |  |


### VariantWithMatrix4

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetMatrix4` | fun(self: VariantWithMatrix4): Matrix4 |  |


### VariantWithResourceRef

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetResourceRef` | fun(self: VariantWithResourceRef): ResourceRef |  |


### VariantWithResourceRefList

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetResourceRefList` | fun(self: VariantWithResourceRefList): ResourceRefList |  |


### VariantWithVariantVector

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetVariantVector` | fun(self: VariantWithVariantVector): Variant[] |  |


### VariantWithStringVector

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetStringVector` | fun(self: VariantWithStringVector): string[] |  |


### VariantWithVariantMap

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetVariantMap` | fun(self: VariantWithVariantMap): VariantMap|nil |  |


### VariantWithPtr

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetPtr` | __union_func__type_str__ret_RefCountedT |  |
| `GetPtr` | fun(self: VariantWithPtr): RefCounted |  |
| `GetVoidPtr` | fun(self: VariantWithPtr, type: string): any |  |


### VariantWithBuffer

**属性（1）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `GetBuffer` | fun(self: VariantWithBuffer): VectorBuffer |  |


### Vector2

**构造**

```lua
fun(vector: Vector2): Vector2
fun(x: number, y: number): Vector2
fun(): Vector2
fun(self: Vector2, vector: Vector2): Vector2
fun(vector: Vector2): Vector2
fun(self: Vector2, x: number, y: number): Vector2
fun(x: number, y: number): Vector2
```

**属性（12）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `x` | number |  |
| `y` | number |  |
| `length` | number |  |
| `lengthSquared` | number |  |
| `normalized` | Vector2 |  |
| `abs` | Vector2 |  |
| `ZERO` | Vector2 |  |
| `LEFT` | Vector2 |  |
| `RIGHT` | Vector2 |  |
| `UP` | Vector2 |  |
| `DOWN` | Vector2 |  |
| `ONE` | Vector2 |  |

**方法（12）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Length` | `() -> number` |  |
| `LengthSquared` | `() -> number` |  |
| `DotProduct` | `(rhs: Vector2) -> number` |  |
| `AbsDotProduct` | `(rhs: Vector2) -> number` |  |
| `ProjectOntoAxis` | `(axis: Vector2) -> number` |  |
| `Angle` | `(rhs: Vector2) -> number` |  |
| `Abs` | `() -> Vector2` |  |
| `Lerp` | `(rhs: Vector2, t: number) -> Vector2` |  |
| `Equals` | `(rhs: Vector2) -> boolean` |  |
| `IsNaN` | `() -> boolean` |  |
| `Normalized` | `() -> Vector2` |  |
| `ToString` | `() -> string` |  |

**运算符**：`eq(Vector2): boolean`、`add(number): Vector2`、`add(Vector2): Vector2`、`unm: Vector2`、`sub(Vector2): Vector2`、`mul(number): Vector2`、`mul(Vector2): Vector2`、`div(number): Vector2`、`div(Vector2): Vector2`


### IntVector2

**构造**

```lua
fun(x: integer, y: integer): IntVector2
fun(rhs: IntVector2): IntVector2
fun(): IntVector2
fun(self: IntVector2, x: integer, y: integer): IntVector2
fun(x: integer, y: integer): IntVector2
fun(self: IntVector2, rhs: IntVector2): IntVector2
fun(rhs: IntVector2): IntVector2
```

**属性（8）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `x` | integer |  |
| `y` | integer |  |
| `ZERO` | IntVector2 |  |
| `LEFT` | IntVector2 |  |
| `RIGHT` | IntVector2 |  |
| `UP` | IntVector2 |  |
| `DOWN` | IntVector2 |  |
| `ONE` | IntVector2 |  |

**方法（3）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `ToString` | `() -> string` |  |
| `ToHash` | `() -> integer` |  |
| `Length` | `() -> number` |  |

**运算符**：`eq(IntVector2): boolean`、`add(IntVector2): IntVector2`、`unm: IntVector2`、`sub(IntVector2): IntVector2`、`mul(integer): IntVector2`、`mul(IntVector2): IntVector2`、`div(integer): IntVector2`、`div(IntVector2): IntVector2`


### Vector3

**构造**

```lua
fun(vector: Vector3): Vector3
fun(vector: Vector2, z: number): Vector3
fun(vector: Vector2): Vector3
fun(x: number, y: number, z: number): Vector3
fun(x: number, y: number): Vector3
fun(): Vector3
fun(self: Vector3, vector: Vector3): Vector3
fun(vector: Vector3): Vector3
```

**属性（15）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `x` | number |  |
| `y` | number |  |
| `z` | number |  |
| `length` | number |  |
| `lengthSquared` | number |  |
| `normalized` | Vector3 |  |
| `abs` | Vector3 |  |
| `ZERO` | Vector3 |  |
| `LEFT` | Vector3 |  |
| `RIGHT` | Vector3 |  |
| `UP` | Vector3 |  |
| `DOWN` | Vector3 |  |
| `FORWARD` | Vector3 |  |
| `BACK` | Vector3 |  |
| `ONE` | Vector3 |  |

**方法（18）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Length` | `() -> number` |  |
| `LengthSquared` | `() -> number` |  |
| `DotProduct` | `(rhs: Vector3) -> number` |  |
| `AbsDotProduct` | `(rhs: Vector3) -> number` |  |
| `ProjectOntoAxis` | `(axis: Vector3) -> number` |  |
| `ProjectOntoPlane` | `(origin: Vector3, normal: Vector3) -> Vector3` |  |
| `ProjectOntoLine` | `(from: Vector3, to: Vector3, clamped?: boolean) -> Vector3` |  |
| `DistanceToPoint` | `(point: Vector3) -> number` |  |
| `DistanceToPlane` | `(origin: Vector3, normal: Vector3) -> number` |  |
| `Orthogonalize` | `(axis: Vector3) -> Vector3` |  |
| `CrossProduct` | `(rhs: Vector3) -> Vector3` |  |
| `Abs` | `() -> Vector3` |  |
| `Lerp` | `(rhs: Vector3, t: number) -> Vector3` |  |
| `Equals` | `(rhs: Vector3) -> boolean` |  |
| `IsNaN` | `() -> boolean` |  |
| `Angle` | `(rhs: Vector3) -> number` |  |
| `Normalized` | `() -> Vector3` |  |
| `ToString` | `() -> string` |  |

**运算符**：`eq(Vector3): boolean`、`add(number): Vector3`、`add(Vector3): Vector3`、`unm: Vector3`、`sub(Vector3): Vector3`、`mul(number): Vector3`、`mul(Vector3): Vector3`、`div(number): Vector3`、`div(Vector3): Vector3`


### IntVector3

**构造**

```lua
fun(x: integer, y: integer, z: integer): IntVector3
fun(rhs: IntVector3): IntVector3
fun(): IntVector3
fun(self: IntVector3, x: integer, y: integer, z: integer): IntVector3
fun(x: integer, y: integer, z: integer): IntVector3
fun(self: IntVector3, rhs: IntVector3): IntVector3
fun(rhs: IntVector3): IntVector3
```

**属性（11）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `x` | integer |  |
| `y` | integer |  |
| `z` | integer |  |
| `ZERO` | IntVector3 |  |
| `LEFT` | IntVector3 |  |
| `RIGHT` | IntVector3 |  |
| `UP` | IntVector3 |  |
| `DOWN` | IntVector3 |  |
| `FORWARD` | IntVector3 |  |
| `BACK` | IntVector3 |  |
| `ONE` | IntVector3 |  |

**方法（3）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `ToString` | `() -> string` |  |
| `ToHash` | `() -> integer` |  |
| `Length` | `() -> number` |  |

**运算符**：`eq(IntVector3): boolean`、`add(IntVector3): IntVector3`、`unm: IntVector3`、`sub(IntVector3): IntVector3`、`mul(integer): IntVector3`、`mul(IntVector3): IntVector3`、`div(integer): IntVector3`、`div(IntVector3): IntVector3`


### Vector4

**构造**

```lua
fun(vector: Vector4): Vector4
fun(vector: Vector3, w: number): Vector4
fun(x: number, y: number, z: number, w: number): Vector4
fun(): Vector4
fun(self: Vector4, vector: Vector4): Vector4
fun(vector: Vector4): Vector4
fun(self: Vector4, vector: Vector3, w: number): Vector4
fun(vector: Vector3, w: number): Vector4
```

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `x` | number |  |
| `y` | number |  |
| `z` | number |  |
| `w` | number |  |
| `abs` | Vector4 |  |
| `ZERO` | Vector4 |  |
| `ONE` | Vector4 |  |

**方法（8）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `DotProduct` | `(rhs: Vector4) -> number` |  |
| `AbsDotProduct` | `(rhs: Vector4) -> number` |  |
| `ProjectOntoAxis` | `(axis: Vector3) -> number` |  |
| `Abs` | `() -> Vector4` |  |
| `Lerp` | `(rhs: Vector4, t: number) -> Vector4` |  |
| `Equals` | `(rhs: Vector4) -> boolean` |  |
| `IsNaN` | `() -> boolean` |  |
| `ToString` | `() -> string` |  |

**运算符**：`eq(Vector4): boolean`、`add(Vector4): Vector4`、`unm: Vector4`、`sub(Vector4): Vector4`、`mul(number): Vector4`、`mul(Vector4): Vector4`、`div(number): Vector4`、`div(Vector4): Vector4`


### VectorBuffer

**构造**

```lua
fun(source: Deserializer, size: integer): VectorBuffer
fun(): VectorBuffer
fun(self: VectorBuffer, source: Deserializer, size: integer): VectorBuffer
fun(source: Deserializer, size: integer): VectorBuffer
```

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `name` | string |  |
| `checksum` | integer |  |
| `position` | integer |  |
| `size` | integer |  |
| `eof` | boolean |  |

**方法（92）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetData` | `(source: Deserializer, size: integer)` |  |
| `Clear` | `()` |  |
| `Resize` | `(size: integer)` |  |
| `GetData` | `() -> any` |  |
| `GetModifiableData` | `() -> any` |  |
| `Read` | `(size: integer) -> VectorBuffer` |  |
| `Seek` | `(position: integer) -> integer` |  |
| `SeekRelative` | `(delta: integer) -> integer` |  |
| `GetName` | `() -> string` |  |
| `GetChecksum` | `() -> integer` |  |
| `GetPosition` | `() -> integer` |  |
| `Tell` | `() -> integer` |  |
| `GetSize` | `() -> integer` |  |
| `IsEof` | `() -> boolean` |  |
| `ReadInt` | `() -> integer` |  |
| `ReadInt64` | `() -> integer` |  |
| `ReadShort` | `() -> integer` |  |
| `ReadByte` | `() -> integer` |  |
| `ReadUInt` | `() -> integer` |  |
| `ReadUInt64` | `() -> integer` |  |
| `ReadUShort` | `() -> integer` |  |
| `ReadUByte` | `() -> number` |  |
| `ReadBool` | `() -> boolean` |  |
| `ReadFloat` | `() -> number` |  |
| `ReadDouble` | `() -> number` |  |
| `ReadIntRect` | `() -> IntRect` |  |
| `ReadIntVector2` | `() -> IntVector2` |  |
| `ReadIntVector3` | `() -> IntVector3` |  |
| `ReadRect` | `() -> Rect` |  |
| `ReadVector2` | `() -> Vector2` |  |
| `ReadVector3` | `() -> Vector3` |  |
| `ReadPackedVector3` | `(maxAbsCoord: number) -> Vector3` |  |
| `ReadVector4` | `() -> Vector4` |  |
| `ReadQuaternion` | `() -> Quaternion` |  |
| `ReadPackedQuaternion` | `() -> Quaternion` |  |
| `ReadMatrix3` | `() -> Matrix3` |  |
| `ReadMatrix3x4` | `() -> Matrix3x4` |  |
| `ReadMatrix4` | `() -> Matrix4` |  |
| `ReadColor` | `() -> Color` |  |
| `ReadBoundingBox` | `() -> BoundingBox` |  |
| `ReadString` | `() -> string` |  |
| `ReadFileID` | `() -> string` |  |
| `ReadStringHash` | `() -> StringHash|string` |  |
| `ReadBuffer` | `() -> VectorBuffer` |  |
| `ReadResourceRef` | `() -> ResourceRef` |  |
| `ReadResourceRefList` | `() -> ResourceRefList` |  |
| `ReadVariant` | `(type: VariantType) -> Variant` |  |
| `ReadVariantVector` | `() -> VariantVector` |  |
| `ReadVariantMap` | `() -> VariantMap` |  |
| `ReadVLE` | `() -> integer` |  |
| `ReadNetID` | `() -> integer` |  |
| `ReadLine` | `() -> string` |  |
| `Write` | `(buffer: VectorBuffer) -> integer` |  |
| `WriteInt` | `(value: integer) -> boolean` |  |
| `WriteInt64` | `(value: integer) -> boolean` |  |
| `WriteShort` | `(value: integer) -> boolean` |  |
| `WriteByte` | `(value: integer) -> boolean` |  |
| `WriteUInt` | `(value: integer) -> boolean` |  |
| `WriteUInt64` | `(value: integer) -> boolean` |  |
| `WriteUShort` | `(value: integer -- unsigned short) -> boolean` |  |
| `WriteUByte` | `(value: number -- unsigned char) -> boolean` |  |
| `WriteBool` | `(value: boolean) -> boolean` |  |
| `WriteFloat` | `(value: number) -> boolean` |  |
| `WriteDouble` | `(value: number) -> boolean` |  |
| `WriteIntRect` | `(value: IntRect) -> boolean` |  |
| `WriteIntVector2` | `(value: IntVector2) -> boolean` |  |
| `WriteIntVector3` | `(value: IntVector3) -> boolean` |  |
| `WriteRect` | `(value: Rect) -> boolean` |  |
| `WriteVector2` | `(value: Vector2) -> boolean` |  |
| `WriteVector3` | `(value: Vector3) -> boolean` |  |
| `WritePackedVector3` | `(value: Vector3, maxAbsCoord: number) -> boolean` |  |
| `WriteVector4` | `(value: Vector4) -> boolean` |  |
| `WriteQuaternion` | `(value: Quaternion) -> boolean` |  |
| `WritePackedQuaternion` | `(value: Quaternion) -> boolean` |  |
| `WriteMatrix3` | `(value: Matrix3) -> boolean` |  |
| `WriteMatrix3x4` | `(value: Matrix3x4) -> boolean` |  |
| `WriteMatrix4` | `(value: Matrix4) -> boolean` |  |
| `WriteColor` | `(value: Color) -> boolean` |  |
| `WriteBoundingBox` | `(value: BoundingBox) -> boolean` |  |
| `WriteString` | `(value: string) -> boolean` |  |
| `WriteFileID` | `(value: string) -> boolean` |  |
| `WriteStringHash` | `(value: StringHash|string) -> boolean` |  |
| `WriteBuffer` | `(buffer: VectorBuffer) -> boolean` |  |
| `WriteResourceRef` | `(value: ResourceRef) -> boolean` |  |
| `WriteResourceRefList` | `(value: ResourceRefList) -> boolean` |  |
| `WriteVariant` | `(value: Variant) -> boolean` |  |
| `WriteVariantData` | `(value: Variant) -> boolean` |  |
| `WriteVariantVector` | `(value: VariantVector) -> boolean` |  |
| `WriteVariantMap` | `(value: VariantMap) -> boolean` |  |
| `WriteVLE` | `(value: integer) -> boolean` |  |
| `WriteNetID` | `(value: integer) -> boolean` |  |
| `WriteLine` | `(value: string) -> boolean` |  |


### VertexBuffer  `: Object`

**构造**

```lua
fun(): VertexBuffer
```

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `shadowed` | boolean |  |
| `dynamic` | boolean |  |
| `vertexCount` | integer |  |
| `vertexSize` | integer |  |
| `elementMask` | integer |  |

**方法（13）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetShadowed` | `(enable: boolean)` |  |
| `SetSize` | `(vertexCount: integer, elements: VertexElement[], dynamic?: boolean) -> boolean` |  |
| `SetData` | `(data: VectorBuffer) -> boolean` |  |
| `SetDataRange` | `(data: VectorBuffer, start: integer, count: integer, discard?: boolean) -> boolean` |  |
| `GetData` | `() -> VectorBuffer` |  |
| `IsShadowed` | `() -> boolean` |  |
| `IsDynamic` | `() -> boolean` |  |
| `GetVertexCount` | `() -> integer` |  |
| `GetVertexSize` | `() -> integer` |  |
| `GetElements` | `() -> VertexElement[]` |  |
| `HasElement` | `(semantic: VertexElementSemantic, index?: number -- unsigned char) -> boolean` |  |
| `GetElementOffset` | `(semantic: VertexElementSemantic, index?: number -- unsigned char) -> integer` |  |
| `GetElementMask` | `() -> integer` |  |


### VideoTexture  `: Texture2D`

**构造**

```lua
fun(): VideoTexture
```

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `videoWidth` | integer |  |
| `videoHeight` | integer |  |

**方法（4）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Initialize` | `(width: integer, height: integer) -> boolean` |  |
| `NotifyUpdate` | `()` |  |
| `GetVideoWidth` | `() -> integer` |  |
| `GetVideoHeight` | `() -> integer` |  |


### VideoPlayer  `: Object`

**构造**

```lua
fun(): VideoPlayer
```

**属性（13）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `asyncLoading` | boolean |  |
| `volume` | number |  |
| `playbackRate` | number |  |
| `muted` | boolean |  |
| `looping` | boolean |  |
| `currentTime` | number |  |
| `duration` | number |  |
| `state` | VideoState |  |
| `playing` | boolean |  |
| `ready` | boolean |  |
| `texture` | VideoTexture |  |
| `videoWidth` | integer |  |
| `videoHeight` | integer |  |

**方法（24）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Load` | `(source: string Video source: virtual path (e.g. "videos/intro.mp4"), uuid reference (e.g. "uuid://..."), or https URL, width?: integer, height?: integer) -> boolean` |  |
| `Play` | `()` |  |
| `Pause` | `()` |  |
| `Stop` | `()` |  |
| `Seek` | `(time: number)` |  |
| `SetVolume` | `(volume: number)` |  |
| `SetMuted` | `(muted: boolean)` |  |
| `SetLoop` | `(loop: boolean)` |  |
| `SetPlaybackRate` | `(rate: number Playback rate (0.25 to 4.0, default 1.0))` |  |
| `GetVolume` | `() -> number` |  |
| `IsMuted` | `() -> boolean` |  |
| `IsLooping` | `() -> boolean` |  |
| `GetPlaybackRate` | `() -> number` |  |
| `GetCurrentTime` | `() -> number` |  |
| `GetDuration` | `() -> number` |  |
| `GetState` | `() -> VideoState` |  |
| `IsPlaying` | `() -> boolean` |  |
| `IsReady` | `() -> boolean` |  |
| `GetTexture` | `() -> VideoTexture` |  |
| `GetVideoWidth` | `() -> integer` |  |
| `GetVideoHeight` | `() -> integer` |  |
| `Update` | `()` |  |
| `AsyncLoad` | `(source: string Video URL or path, width?: integer Texture width (default 1920), height?: integer Texture height (default 1080), callback?: fun(result: integer) Completion callback with VideoLoadResult error code (0=success)) -> boolean` | Asynchronously load video from URL/path (non-blocking). Loading happen |
| `IsAsyncLoading` | `() -> boolean` |  |


### Window  `: BorderImage`

**构造**

```lua
fun(): Window
```

**属性（10）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `movable` | boolean |  |
| `resizable` | boolean |  |
| `fixedWidthResizing` | boolean |  |
| `fixedHeightResizing` | boolean |  |
| `resizeBorder` | IntRect |  |
| `modal` | boolean |  |
| `modalShadeColor` | Color |  |
| `modalFrameColor` | Color |  |
| `modalFrameSize` | IntVector2 |  |
| `modalAutoDismiss` | boolean |  |

**方法（20）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetMovable` | `(enable: boolean)` |  |
| `SetResizable` | `(enable: boolean)` |  |
| `SetFixedWidthResizing` | `(enable: boolean)` |  |
| `SetFixedHeightResizing` | `(enable: boolean)` |  |
| `SetResizeBorder` | `(rect: IntRect)` |  |
| `SetModal` | `(modal: boolean)` |  |
| `SetModalShadeColor` | `(color: Color)` |  |
| `SetModalFrameColor` | `(color: Color)` |  |
| `SetModalFrameSize` | `(size: IntVector2)` |  |
| `SetModalAutoDismiss` | `(enable: boolean)` |  |
| `IsMovable` | `() -> boolean` |  |
| `IsResizable` | `() -> boolean` |  |
| `GetFixedWidthResizing` | `() -> boolean` |  |
| `GetFixedHeightResizing` | `() -> boolean` |  |
| `GetResizeBorder` | `() -> IntRect` |  |
| `IsModal` | `() -> boolean` |  |
| `GetModalShadeColor` | `() -> Color` |  |
| `GetModalFrameColor` | `() -> Color` |  |
| `GetModalFrameSize` | `() -> IntVector2` |  |
| `GetModalAutoDismiss` | `() -> boolean` |  |


### View3D  `: Window`

**构造**

```lua
fun(): View3D
```

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `format` | integer |  |
| `autoUpdate` | boolean |  |

**方法（11）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetView` | `(scene: Scene, camera: Camera, ownScene?: boolean)` |  |
| `SetFormat` | `(format: integer)` |  |
| `SetAutoUpdate` | `(enable: boolean)` |  |
| `QueueUpdate` | `()` |  |
| `GetFormat` | `() -> integer` |  |
| `GetAutoUpdate` | `() -> boolean` |  |
| `GetScene` | `() -> Scene` |  |
| `GetCameraNode` | `() -> Node` |  |
| `GetRenderTexture` | `() -> Texture2D` |  |
| `GetDepthTexture` | `() -> Texture2D` |  |
| `GetViewport` | `() -> Viewport` |  |


### Viewport

**构造**

```lua
fun(scene: Scene, camera: Camera, renderPath?: RenderPath): Viewport
fun(scene: Scene, camera: Camera, rect: IntRect, renderPath?: RenderPath): Viewport
fun(): Viewport
fun(self: Viewport, scene: Scene, camera: Camera, renderPath?: RenderPath): Viewport
fun(scene: Scene, camera: Camera, renderPath?: RenderPath): Viewport
fun(self: Viewport, scene: Scene, camera: Camera, rect: IntRect, renderPath?: RenderPath): Viewport
fun(scene: Scene, camera: Camera, rect: IntRect, renderPath?: RenderPath): Viewport
```

**属性（6）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `scene` | Scene |  |
| `camera` | Camera |  |
| `cullCamera` | Camera |  |
| `rect` | IntRect |  |
| `renderPath` | RenderPath |  |
| `drawDebug` | boolean |  |

**方法（20）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetScene` | `(scene: Scene)` |  |
| `SetCamera` | `(camera: Camera)` |  |
| `SetCullCamera` | `(camera: Camera)` |  |
| `SetRect` | `(rect: IntRect)` |  |
| `SetRenderPath` | `(path: RenderPath)` |  |
| `SetDrawDebug` | `(enable: boolean)` |  |
| `SetViewClusterEnabled` | `(enable: boolean)` |  |
| `IsViewClusterEnabled` | `() -> boolean` |  |
| `ResetView` | `()` | Discard the view and all temporal histories after an explicit camera c |
| `GetScene` | `() -> Scene` |  |
| `GetCamera` | `() -> Camera` |  |
| `GetCullCamera` | `() -> Camera` |  |
| `GetRect` | `() -> IntRect` |  |
| `GetRenderPath` | `() -> RenderPath` |  |
| `GetDrawDebug` | `() -> boolean` |  |
| `GetScreenRay` | `(x: integer, y: integer) -> Ray` |  |
| `WorldToScreenPoint` | `(worldPos: Vector3) -> IntVector2` |  |
| `ScreenToWorldPoint` | `(x: integer, y: integer, depth: number) -> Vector3` |  |
| `CaptureRenderTarget` | `(targetName: string, callback: fun(success: boolean, image: Image):nil Data-ready callback; image is valid only during callback and raises an error if used afterwards, nil on failure)` |  |
| `CaptureRenderTargetCPU` | `(targetName: string Named render target, captured after this view renders, callback: fun(success: boolean, texture: CPUTexture):nil Original-format pixels, valid only during callback and raises an error if used afterwards; nil on failure or format fallback)` |  |


### VolumetricCloud  `: Component`

**属性（41）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `layerBottomAltitude` | number |  |
| `layerHeight` | number |  |
| `planetRadius` | number |  |
| `planetCenter` | Vector3 |  |
| `tracingStartDistance` | number |  |
| `tracingMaxDistance` | number |  |
| `groundAlbedo` | Color |  |
| `skyLightBottomOcclusion` | number |  |
| `densityScale` | number |  |
| `albedo` | Color |  |
| `emissive` | Color |  |
| `phaseG` | number |  |
| `phaseG2` | number |  |
| `phaseBlend` | number |  |
| `multiScattering` | number |  |
| `multiScatteringOcclusion` | number |  |
| `multiScatteringEccentricity` | number |  |
| `multiScatteringOctaves` | integer |  |
| `groundContribution` | boolean |  |
| `cloudGlobalScale` | number |  |
| `cloudGlobalCoverage` | number |  |
| `viewSampleCountScale` | number |  |
| `shadowSampleCountScale` | number |  |
| `shadowTracingDistance` | number |  |
| `tracingStartMaxDistance` | number |  |
| `tracingMaxDistanceFromCamera` | boolean |  |
| `conservativeDensity` | number |  |
| `grayscaleLighting` | boolean |  |
| `windVelocity` | Vector2 |  |
| `weatherTime` | number |  |
| `perSampleAtmosphereTransmittance` | boolean |  |
| `aerialPerspectiveEnabled` | boolean |  |
| `cloudShadowEnabled` | boolean |  |
| `cloudShadowExtent` | number UE CloudShadowExtent in meters for the primary sun (default 150000). |  |
| `skyAOEnabled` | boolean |  |
| `renderInMainPass` | boolean |  |
| `stopTracingTransmittance` | number |  |
| `skyLightingMode` | VolumetricCloudSkyLightingMode |  |
| `heightProfile` | Texture2D |  |
| `weatherMap` | Texture2D |  |
| `shapeNoise` | Texture3D |  |

**方法（82）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetLayerBottomAltitude` | `(altitude: number)` |  |
| `GetLayerBottomAltitude` | `() -> number` |  |
| `SetLayerHeight` | `(height: number)` |  |
| `GetLayerHeight` | `() -> number` |  |
| `SetPlanetRadius` | `(radius: number)` |  |
| `GetPlanetRadius` | `() -> number` |  |
| `SetPlanetCenter` | `(center: Vector3)` |  |
| `GetPlanetCenter` | `() -> Vector3` |  |
| `SetTracingStartDistance` | `(distance: number)` |  |
| `GetTracingStartDistance` | `() -> number` |  |
| `SetTracingMaxDistance` | `(distance: number)` |  |
| `GetTracingMaxDistance` | `() -> number` |  |
| `SetGroundAlbedo` | `(color: Color)` |  |
| `GetGroundAlbedo` | `() -> Color` |  |
| `SetSkyLightBottomOcclusion` | `(value: number)` |  |
| `GetSkyLightBottomOcclusion` | `() -> number` |  |
| `SetDensityScale` | `(value: number)` |  |
| `GetDensityScale` | `() -> number` |  |
| `SetAlbedo` | `(color: Color)` |  |
| `GetAlbedo` | `() -> Color` |  |
| `SetEmissive` | `(color: Color)` |  |
| `GetEmissive` | `() -> Color` |  |
| `SetPhaseG` | `(value: number)` |  |
| `GetPhaseG` | `() -> number` |  |
| `SetPhaseG2` | `(value: number)` |  |
| `GetPhaseG2` | `() -> number` |  |
| `SetPhaseBlend` | `(value: number)` |  |
| `GetPhaseBlend` | `() -> number` |  |
| `SetMultiScattering` | `(value: number)` |  |
| `GetMultiScattering` | `() -> number` |  |
| `SetMultiScatteringOcclusion` | `(value: number)` |  |
| `GetMultiScatteringOcclusion` | `() -> number` |  |
| `SetMultiScatteringEccentricity` | `(value: number)` |  |
| `GetMultiScatteringEccentricity` | `() -> number` |  |
| `SetMultiScatteringOctaves` | `(value: integer)` |  |
| `GetMultiScatteringOctaves` | `() -> integer` |  |
| `SetGroundContribution` | `(value: boolean)` |  |
| `GetGroundContribution` | `() -> boolean` |  |
| `SetCloudGlobalScale` | `(value: number)` |  |
| `GetCloudGlobalScale` | `() -> number` |  |
| `SetCloudGlobalCoverage` | `(value: number)` |  |
| `GetCloudGlobalCoverage` | `() -> number` |  |
| `SetViewSampleCountScale` | `(value: number)` |  |
| `GetViewSampleCountScale` | `() -> number` |  |
| `SetShadowSampleCountScale` | `(value: number)` |  |
| `GetShadowSampleCountScale` | `() -> number` |  |
| `SetShadowTracingDistance` | `(value: number)` |  |
| `GetShadowTracingDistance` | `() -> number` |  |
| `SetTracingStartMaxDistance` | `(value: number)` |  |
| `GetTracingStartMaxDistance` | `() -> number` |  |
| `SetTracingMaxDistanceFromCamera` | `(value: boolean)` |  |
| `GetTracingMaxDistanceFromCamera` | `() -> boolean` |  |
| `SetConservativeDensity` | `(value: number)` |  |
| `GetConservativeDensity` | `() -> number` |  |
| `SetGrayscaleLighting` | `(enable: boolean)` |  |
| `GetGrayscaleLighting` | `() -> boolean` |  |
| `SetWindVelocity` | `(velocity: Vector2)` |  |
| `GetWindVelocity` | `() -> Vector2` |  |
| `SetWeatherTime` | `(time: number)` |  |
| `GetWeatherTime` | `() -> number` |  |
| `SetPerSampleAtmosphereTransmittance` | `(enable: boolean)` |  |
| `GetPerSampleAtmosphereTransmittance` | `() -> boolean` |  |
| `SetAerialPerspectiveEnabled` | `(enable: boolean)` |  |
| `GetAerialPerspectiveEnabled` | `() -> boolean` |  |
| `SetCloudShadowEnabled` | `(enable: boolean)` |  |
| `GetCloudShadowEnabled` | `() -> boolean` |  |
| `SetCloudShadowExtent` | `(extent: number)` | Set the primary sun shadow extent in meters, clamped to at least 1000  |
| `GetCloudShadowExtent` | `() -> number` | Return the primary sun shadow extent in meters; smaller values improve |
| `SetSkyAOEnabled` | `(enable: boolean)` |  |
| `GetSkyAOEnabled` | `() -> boolean` |  |
| `SetRenderInMainPass` | `(enable: boolean)` |  |
| `GetRenderInMainPass` | `() -> boolean` |  |
| `SetStopTracingTransmittance` | `(value: number)` |  |
| `GetStopTracingTransmittance` | `() -> number` |  |
| `SetSkyLightingMode` | `(mode: VolumetricCloudSkyLightingMode)` |  |
| `GetSkyLightingMode` | `() -> VolumetricCloudSkyLightingMode` |  |
| `SetHeightProfile` | `(texture: Texture2D)` |  |
| `GetHeightProfile` | `() -> Texture2D` |  |
| `SetWeatherMap` | `(texture: Texture2D)` |  |
| `GetWeatherMap` | `() -> Texture2D` |  |
| `SetShapeNoise` | `(texture: Texture3D)` |  |
| `GetShapeNoise` | `() -> Texture3D` |  |


### VoxelMemberStress

**构造**

```lua
fun(): VoxelMemberStress
```

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `force` | Vector3 |  |
| `torque` | Vector3 |  |
| `forceFactor` | number |  |
| `torqueFactor` | number |  |
| `breakFactor` | number |  |


### VoxelAssembly  `: Component`

**属性（10）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `volumeCount` | integer |  |
| `mass` | number |  |
| `rootVolume` | VoxelVolume |  |
| `linearVelocity` | Vector3 |  |
| `angularVelocity` | Vector3 |  |
| `linearDamping` | number |  |
| `angularDamping` | number |  |
| `gravityFactor` | number |  |
| `useGravity` | boolean |  |
| `ccdEnabled` | boolean |  |

**方法（35）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `AddVolume` | `(volume: VoxelVolume) -> boolean` | Add a finalized standalone dynamic volume. Repeated additions share on |
| `RemoveVolume` | `(volume: VoxelVolume, newRoot?: VoxelVolume) -> boolean` | Detach a member as a standalone body. newRoot is required only when th |
| `ContainsVolume` | `(volume: VoxelVolume) -> boolean` | Return true if the volume belongs to this assembly. |
| `GetVolumeCount` | `() -> integer` | Return volume count. |
| `GetVolume` | `(index: integer) -> VoxelVolume` | Return volume. |
| `SetRootVolume` | `(volume: VoxelVolume)` | Select the member Node that defines the stable gameplay transform of t |
| `GetRootVolume` | `() -> VoxelVolume` | Return root volume. |
| `Dissolve` | `()` | Replace the shared body with one standalone dynamic body per member. |
| `ApplyForce` | `(force: Vector3)` | Rigid-body façade. All values are world-space and operate on the share |
| `ApplyImpulse` | `(impulse: Vector3)` | Apply impulse in newton-seconds. |
| `ApplyTorque` | `(torque: Vector3)` | Apply torque in newton-metres. |
| `ApplyTorqueImpulse` | `(impulse: Vector3)` | Apply angular impulse in newton-metre-seconds. |
| `ResetForces` | `()` | Clear accumulated force and torque without clearing velocity. |
| `GetVelocityAtPoint` | `(worldPosition: Vector3) -> Vector3` | Return world-space velocity at the specified world-space point. |
| `GetMass` | `() -> number` | Density-derived mass summed over all current members. There is intenti |
| `GetLinearVelocity` | `() -> Vector3` | Return linear velocity in world space, in metres per second. |
| `SetLinearVelocity` | `(velocity: Vector3)` | Set linear velocity in world space, in metres per second. |
| `GetAngularVelocity` | `() -> Vector3` | Return angular velocity in world space, in radians per second. |
| `SetAngularVelocity` | `(velocity: Vector3)` | Set angular velocity in world space, in radians per second. |
| `SetLinearDamping` | `(damping: number)` | Set linear damping. |
| `GetLinearDamping` | `() -> number` | Return linear damping. |
| `SetAngularDamping` | `(damping: number)` | Set angular damping. |
| `GetAngularDamping` | `() -> number` | Return angular damping. |
| `SetGravityFactor` | `(factor: number)` | Set gravity factor. |
| `GetGravityFactor` | `() -> number` | Return gravity factor. |
| `SetUseGravity` | `(enable: boolean)` | Set use gravity. |
| `GetUseGravity` | `() -> boolean` | Return true if gravity affects the shared body. |
| `SetCcdEnabled` | `(enable: boolean)` | Set ccd enabled. |
| `IsCcdEnabled` | `() -> boolean` | Return true if continuous collision detection is enabled. |
| `Activate` | `()` | Wake the solver body. |
| `IsActive` | `() -> boolean` | Return whether the assembly's shared rigid body is active (not sleepin |
| `SetMemberBreakThreshold` | `(volume: VoxelVolume, breakForce: number, breakTorque: number)` | Configure the intact reaction force and torque thresholds used by auto |
| `ClearMemberBreakThreshold` | `(volume: VoxelVolume)` | Make both break channels infinitely strong again. |
| `IsMemberBreakable` | `(volume: VoxelVolume) -> boolean` | Whether at least one finite positive force or torque threshold is conf |
| `GetMemberStress` | `(volume: VoxelVolume) -> VoxelMemberStress` | Return the latest post-step reaction estimate and normalized break fac |


### VoxelCharacterController  `: Component`

**属性（24）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `collisionLayer` | integer Character collision category bits; default 1. With mask 0xffffffff, defaults bypass volume layer/mask checks. |  |
| `collisionMask` | integer Accepted VoxelVolume layers; default 0xffffffff. Zero disables body contacts, including ground support. Custom filtering is enabled only while layer or mask differs from its default. |  |
| `height` | number |  |
| `radius` | number |  |
| `supportRadius` | number |  |
| `gravityFactor` | number |  |
| `mass` | number |  |
| `maxStrength` | number |  |
| `jumpSpeed` | number |  |
| `maxSlopeAngle` | number |  |
| `stepHeight` | number |  |
| `stickToFloorDistance` | number |  |
| `penetrationRecoverySpeed` | number |  |
| `enhancedInternalEdgeRemoval` | boolean |  |
| `maxNumHits` | integer |  |
| `desiredVelocity` | Vector3 |  |
| `linearVelocity` | Vector3 |  |
| `onGround` | boolean |  |
| `groundState` | VoxelCharacterGroundState |  |
| `groundNormal` | Vector3 |  |
| `groundVelocity` | Vector3 |  |
| `swimming` | boolean |  |
| `maxHitsExceeded` | boolean |  |
| `created` | boolean |  |

**方法（43）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Jump` | `(speed: number)` | Queue a jump using the configured jump speed. |
| `Teleport` | `(worldPosition: Vector3)` | Teleport both the virtual character and its Node. Position is at the f |
| `SetCollisionLayer` | `(layer: integer)` | Set the character's collision category bits. Default is 1. When layer  |
| `GetCollisionLayer` | `() -> integer` | Return the character's collision category bits. |
| `SetCollisionMask` | `(mask: integer)` | Set accepted VoxelVolume collision layers. Default is M_MAX_UNSIGNED;  |
| `GetCollisionMask` | `() -> integer` | Return the accepted VoxelVolume collision layers. |
| `SetHeight` | `(height: number)` | Set height. |
| `GetHeight` | `() -> number` | Return height. |
| `SetRadius` | `(radius: number)` | Set radius. |
| `GetRadius` | `() -> number` | Return radius. |
| `SetSupportRadius` | `(radius: number)` | Horizontal radius of the lower capsule region that may count as suppor |
| `GetSupportRadius` | `() -> number` | Return support radius. |
| `SetGravityFactor` | `(factor: number)` | Set gravity factor. |
| `GetGravityFactor` | `() -> number` | Return gravity factor. |
| `SetMass` | `(mass: number)` | Set mass. |
| `GetMass` | `() -> number` | Return mass. |
| `SetMaxStrength` | `(strength: number)` | Set max strength. |
| `GetMaxStrength` | `() -> number` | Return max strength. |
| `SetJumpSpeed` | `(speed: number)` | Set jump speed. |
| `GetJumpSpeed` | `() -> number` | Return jump speed. |
| `SetMaxSlopeAngle` | `(degrees: number)` | Set maximum walkable slope angle in degrees. |
| `GetMaxSlopeAngle` | `() -> number` | Return maximum walkable slope angle in degrees. |
| `SetStepHeight` | `(height: number)` | Set step height. |
| `GetStepHeight` | `() -> number` | Return step height. |
| `SetStickToFloorDistance` | `(distance: number)` | Set stick to floor distance. |
| `GetStickToFloorDistance` | `() -> number` | Return stick to floor distance. |
| `SetPenetrationRecoverySpeed` | `(speed: number)` | Set penetration recovery speed. |
| `GetPenetrationRecoverySpeed` | `() -> number` | Return penetration recovery speed. |
| `SetEnhancedInternalEdgeRemoval` | `(enable: boolean)` | Set enhanced internal edge removal. |
| `GetEnhancedInternalEdgeRemoval` | `() -> boolean` | Return true if enhanced internal edge removal is enabled. |
| `SetMaxNumHits` | `(maxHits: integer)` | Set max num hits. |
| `GetMaxNumHits` | `() -> integer` | Return max num hits. |
| `SetDesiredVelocity` | `(velocity: Vector3)` | Persistent movement intent consumed on every VoxelPhysicsWorld update. |
| `GetDesiredVelocity` | `() -> Vector3` | Return movement intent; remote replicas read the latest server value. |
| `GetLinearVelocity` | `() -> Vector3` | Return actual world-space velocity in m/s; remote replicas read the la |
| `SetLinearVelocity` | `(velocity: Vector3)` | Set linear velocity in world space, in metres per second. |
| `IsOnGround` | `() -> boolean` | Return walkable support state; remote replicas read the latest server  |
| `GetGroundState` | `() -> VoxelCharacterGroundState` | Return ground state; remote replicas read the latest server value. |
| `GetGroundNormal` | `() -> Vector3` | Return stable support normal; remote replicas read the latest server v |
| `GetGroundVelocity` | `() -> Vector3` | Return stable support velocity; remote replicas read the latest server |
| `IsSwimming` | `() -> boolean` | Return swimming state; remote replicas read the latest server value. |
| `GetMaxHitsExceeded` | `() -> boolean` | Return contact-limit state; remote replicas read the latest server val |
| `IsCreated` | `() -> boolean` | Return whether a local solver exists. Remote replicas remain false eve |


### VoxelConstraint  `: Component`

**属性（29）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `constraintType` | VoxelConstraintType |  |
| `otherVolume` | VoxelVolume |  |
| `ownVolume` | VoxelVolume |  |
| `position` | Vector3 |  |
| `rotation` | Quaternion |  |
| `otherPosition` | Vector3 |  |
| `otherRotation` | Quaternion |  |
| `worldPosition` | Vector3 |  |
| `disableCollision` | boolean |  |
| `maxFrictionForce` | number |  |
| `maxFrictionTorque` | number |  |
| `axisAngularDamping` | number |  |
| `axisAngularDampingMaxTorque` | number |  |
| `solverVelocitySteps` | integer |  |
| `solverPositionSteps` | integer |  |
| `angularLimitMin` | number |  |
| `angularLimitMax` | number |  |
| `linearLimitMin` | number |  |
| `linearLimitMax` | number |  |
| `linearSpring` | boolean |  |
| `linearSpringRestPosition` | number |  |
| `linearSpringStiffness` | number |  |
| `linearSpringDamping` | number |  |
| `built` | boolean |  |
| `suspended` | boolean |  |
| `reactionForce` | Vector3 |  |
| `reactionTorque` | Vector3 |  |
| `hingeAngle` | number |  |
| `sliderPosition` | number |  |

**方法（51）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `SetConstraintType` | `(type: VoxelConstraintType)` | Set constraint type. |
| `GetConstraintType` | `() -> VoxelConstraintType` | Return constraint type. |
| `SetOtherVolume` | `(volume: VoxelVolume)` | Set endpoint B. Endpoint A is the VoxelVolume on this component's Node |
| `GetOwnVolume` | `() -> VoxelVolume` | Return own volume. |
| `GetOtherVolume` | `() -> VoxelVolume` | Return other volume. |
| `SetPosition` | `(position: Vector3)` | Endpoint A frame in volume-local space. Hinge uses local Z; slider use |
| `GetPosition` | `() -> Vector3` | Return the constraint anchor in the owning volume's local space. |
| `SetRotation` | `(rotation: Quaternion)` | Set rotation. |
| `GetRotation` | `() -> Quaternion` | Return the constraint frame rotation in the owning volume's local spac |
| `SetOtherPosition` | `(position: Vector3)` | Endpoint B frame in the other volume's local space. |
| `GetOtherPosition` | `() -> Vector3` | Return the constraint anchor in the other volume's local space. |
| `SetOtherRotation` | `(rotation: Quaternion)` | Set other rotation. |
| `GetOtherRotation` | `() -> Quaternion` | Return the constraint frame rotation in the other volume's local space |
| `SetWorldPosition` | `(position: Vector3)` | Move both local frame origins to the same world-space point without ch |
| `GetWorldPosition` | `() -> Vector3` | Return the constraint anchor in world space. |
| `SetDisableCollision` | `(disable: boolean)` | Disable contacts between the two endpoint members while this constrain |
| `GetDisableCollision` | `() -> boolean` | Return true if contacts between the endpoint volumes are disabled. |
| `SetAngularMotorVelocity` | `(targetDegreesPerSecond: number, maxTorque: number)` | Drive a hinge at degrees per second. maxTorque <= 0 disables the motor |
| `SetLinearMotorVelocity` | `(targetMetersPerSecond: number, maxForce: number)` | Drive a slider at metres per second. maxForce <= 0 disables the motor. |
| `SetServo` | `(targetAngleDegrees: number, maxTorque: number, maxSpeedDegreesPerSecond: number)` | Drive a hinge toward a periodic angle in degrees, normalized before ap |
| `DisableMotor` | `()` | Disable the explicit motor. An enabled slider spring remains active. |
| `SetMaxFrictionForce` | `(force: number)` | Set max friction force. |
| `GetMaxFrictionForce` | `() -> number` | Return max friction force. |
| `SetMaxFrictionTorque` | `(torque: number)` | Set max friction torque. |
| `GetMaxFrictionTorque` | `() -> number` | Return max friction torque. |
| `SetAngularLimits` | `(minimumDegrees: number, maximumDegrees: number)` | Set hinge stops in degrees. minimum >= maximum removes the limits. |
| `SetLinearLimits` | `(minimumMeters: number, maximumMeters: number)` | Set slider stops in metres. minimum >= maximum removes the limits. |
| `SetLinearSpring` | `(restPositionMeters: number, stiffnessNewtonsPerMeter: number, dampingNewtonSecondsPerMeter: number)` | Configure a slider spring in physical units. This setting is retained  |
| `ClearLinearSpring` | `()` | Disable the slider spring without changing the authored spring values. |
| `HasLinearSpring` | `() -> boolean` | Return true if the slider spring is enabled. |
| `GetLinearSpringRestPosition` | `() -> number` | Return the slider spring rest position in metres. |
| `GetLinearSpringStiffness` | `() -> number` | Return the slider spring stiffness in newtons per metre. |
| `GetLinearSpringDamping` | `() -> number` | Return the slider spring damping in newton-seconds per metre. |
| `SetAxisAngularDamping` | `(damping: number, maxTorque?: number)` | Apply damping around the constraint axis without damping the other ang |
| `GetAxisAngularDamping` | `() -> number` | Return axis angular damping. |
| `GetAxisAngularDampingMaxTorque` | `() -> number` | Return axis angular damping max torque. |
| `SetSolverVelocitySteps` | `(steps: integer)` | Override solver velocity steps for this constraint's physics island. V |
| `GetSolverVelocitySteps` | `() -> integer` | Return the solver velocity-step override. Zero uses the world default. |
| `SetSolverPositionSteps` | `(steps: integer)` | Override solver position steps for this constraint's physics island. V |
| `GetSolverPositionSteps` | `() -> integer` | Return the solver position-step override. Zero uses the world default. |
| `GetAngularLimitMin` | `() -> number` | Return angular limit min. |
| `GetAngularLimitMax` | `() -> number` | Return angular limit max. |
| `GetLinearLimitMin` | `() -> number` | Return linear limit min. |
| `GetLinearLimitMax` | `() -> number` | Return linear limit max. |
| `Rebuild` | `() -> boolean` | (Re)create the solver joint from current settings. Returns false when  |
| `IsBuilt` | `() -> boolean` | Return true if the runtime constraint has been created. |
| `IsSuspended` | `() -> boolean` | True while both endpoints resolve to the same assembly body. The persi |
| `GetHingeAngle` | `() -> number` | Live joint state for gameplay (arm angle readouts). |
| `GetSliderPosition` | `() -> number` | Return slider position. |
| `GetReactionForce` | `() -> Vector3` | Return the average world-space force applied to endpoint A during the  |
| `GetReactionTorque` | `() -> Vector3` | Return the average pure world-space torque applied to endpoint A durin |


### VoxelGrid

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `dimensions` | IntVector3 |  |
| `solidCount` | integer |  |

**方法（10）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `IsSolid` | `(x: integer, y: integer, z: integer) -> boolean` |  |
| `SetSolid` | `(x: integer, y: integer, z: integer, solid: boolean)` |  |
| `GetVoxelMaterial` | `(x: integer, y: integer, z: integer) -> number` |  |
| `SetVoxelMaterial` | `(x: integer, y: integer, z: integer, material: number -- unsigned char)` |  |
| `PaintBox` | `(x0: integer, y0: integer, z0: integer, x1: integer, y1: integer, z1: integer, material: number -- unsigned char)` |  |
| `FillBox` | `(x0: integer, y0: integer, z0: integer, x1: integer, y1: integer, z1: integer, solid: boolean)` |  |
| `Clear` | `()` |  |
| `IsFaceExposed` | `(x: integer, y: integer, z: integer, face: integer) -> boolean` |  |
| `GetDimensions` | `() -> IntVector3` |  |
| `GetSolidCount` | `() -> integer` |  |


### VoxelModel  `: Resource`

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `dimensions` | IntVector3 |  |
| `voxelCount` | integer |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetDimensions` | `() -> IntVector3` |  |
| `GetIndexAt` | `(x: integer, y: integer, z: integer) -> number` |  |
| `GetPaletteColor` | `(index: integer) -> Color` |  |
| `IsPaletteIndexUsed` | `(index: integer) -> boolean` |  |
| `GetVoxelCount` | `() -> integer` |  |


### VoxelRaycastResult

**构造**

```lua
fun(): VoxelRaycastResult
```

**属性（10）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `hit` | boolean |  |
| `position` | Vector3 |  |
| `normal` | Vector3 |  |
| `distance` | number |  |
| `volume` | VoxelVolume |  |
| `assembly` | VoxelAssembly |  |
| `voxel` | IntVector3 |  |
| `material` | integer |  |
| `paletteDomain` | integer Domain in which the material index is interpreted. |  |
| `volumeId` | integer |  |


### VoxelPaletteSlotStats

**构造**

```lua
fun(): VoxelPaletteSlotStats
```

**属性（6）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `capacity` | integer Slots in the palette atlas (256 with the Legacy layout). |  |
| `resident` | integer Slots currently holding a bank, referenced or cached. |  |
| `pinned` | integer Slots referenced by at least one attached volume. |  |
| `peakPinned` | integer Highest pinned count observed. |  |
| `overflows` | integer Requests that found no free slot and rendered with bank 0 instead. |  |
| `evictions` | integer Cached banks evicted to make room for another bank. |  |


### VoxelPhysicsWorld  `: Component`

**属性（21）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `ddaRenderingEnabled` | boolean |  |
| `bodyCount` | integer |  |
| `gravity` | Vector3 |  |
| `volumeCount` | integer |  |
| `minFragmentVoxels` | integer |  |
| `maxFrozenFragments` | integer |  |
| `frozenFragmentCount` | integer |  |
| `spallChunkVoxels` | integer |  |
| `spallSpeed` | number |  |
| `maxSpallChunks` | integer |  |
| `damageNoise` | number |  |
| `stressBreakFactor` | number |  |
| `contactEventThreshold` | number |  |
| `minDamageableVoxels` | integer |  |
| `debrisMaxAge` | number |  |
| `defaultFriction` | number |  |
| `lastSpawnedFragmentCount` | integer |  |
| `waterEnabled` | boolean |  |
| `waterLevel` | number |  |
| `updateEnabled` | boolean |  |
| `collisionSteps` | integer |  |

**方法（143）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `Update` | `(timeStep: number, collisionSteps?: integer)` | Step the simulation. collisionSteps is the solver's substep count. Cal |
| `GetBodyCount` | `() -> integer` | Number of bodies currently in the world. Present so callers can observ |
| `SetGravity` | `(gravity: Vector3)` | Gravity shared by dynamic voxel bodies, vehicles, debris and character |
| `GetGravity` | `() -> Vector3` | Return gravity acceleration in world space, in metres per second squar |
| `CreateVolume` | `(dimX: integer, dimY: integer, dimZ: integer, voxelSize: number, position: Vector3, rotation?: Quaternion, mode?: integer) -> VoxelVolume` | Create volume. |
| `CreateAssembly` | `(rootVolume: VoxelVolume) -> VoxelAssembly` | Create a Scene-owned assembly and immediately adopt rootVolume as its  |
| `SetUpdateEnabled` | `(enable: boolean)` | Whether the component steps itself on the scene subsystem update (defa |
| `SetDerivedRenderingEnabled` | `(enable: boolean)` | Disable derived voxel rendering while retaining CPU data, physics and  |
| `IsDerivedRenderingEnabled` | `() -> boolean` |  |
| `IsUpdateEnabled` | `() -> boolean` | Return true if fixed-step simulation updates are enabled. |
| `SetSimulationPaused` | `(paused: boolean)` | Freeze solver stepping while continuing rendering, residency and backg |
| `IsSimulationPaused` | `() -> boolean` | Return true if solver stepping is paused for editor or tool use. |
| `SetCollisionSteps` | `(steps: integer)` | Solver substep count used by the automatic step. |
| `GetCollisionSteps` | `() -> integer` | Return collision steps. |
| `CreateVolumeFromModel` | `(model: VoxelModel, voxelSize: number, position: Vector3, rotation?: Quaternion, mode?: integer) -> VoxelVolume` | Create an empty volume as a child of this world's Node, and fill it th |
| `CreateCharacter` | `(height: number, radius: number, position: Vector3) -> integer` | Create a kinematic character backed by Jolt CharacterVirtual. height i |
| `RemoveCharacter` | `(handle: integer)` | Remove the character referenced by the handle. |
| `MoveCharacter` | `(handle: integer, desiredVelocity: Vector3, jumpSpeed: number, timeStep: number)` | Drive one frame of movement. desiredVelocity is walk intent in the XZ  |
| `GetCharacterPosition` | `(handle: integer) -> Vector3` | World position of the feet. |
| `SetCharacterPosition` | `(handle: integer, position: Vector3)` | Set character position. |
| `GetCharacterLinearVelocity` | `(handle: integer) -> Vector3` | Return character linear velocity. |
| `SetCharacterLinearVelocity` | `(handle: integer, velocity: Vector3)` | Set character linear velocity. |
| `IsCharacterOnGround` | `(handle: integer) -> boolean` | Return true if the character has walkable support. |
| `GetCharacterGroundState` | `(handle: integer) -> VoxelCharacterGroundState` | Return character ground state. |
| `GetCharacterGroundNormal` | `(handle: integer) -> Vector3` | Return character ground normal. |
| `GetCharacterGroundVelocity` | `(handle: integer) -> Vector3` | Return character ground velocity. |
| `IsCharacterSwimming` | `(handle: integer) -> boolean` | True while MoveCharacter is in swim mode (water enabled and past chest |
| `SetCharacterGravityFactor` | `(handle: integer, factor: number)` | Set character gravity factor. |
| `GetCharacterGravityFactor` | `(handle: integer) -> number` | Return character gravity factor. |
| `SetCharacterMass` | `(handle: integer, mass: number)` | Set character mass. |
| `GetCharacterMass` | `(handle: integer) -> number` | Return character mass. |
| `SetCharacterMaxStrength` | `(handle: integer, strength: number)` | Set character max strength. |
| `GetCharacterMaxStrength` | `(handle: integer) -> number` | Return character max strength. |
| `SetCharacterMaxSlopeAngle` | `(handle: integer, degrees: number)` | Set character max slope angle. |
| `GetCharacterMaxSlopeAngle` | `(handle: integer) -> number` | Return character max slope angle. |
| `SetCharacterStepHeight` | `(handle: integer, height: number)` | Set character step height. |
| `GetCharacterStepHeight` | `(handle: integer) -> number` | Return character step height. |
| `SetCharacterStickToFloorDistance` | `(handle: integer, distance: number)` | Set character stick to floor distance. |
| `GetCharacterStickToFloorDistance` | `(handle: integer) -> number` | Return character stick to floor distance. |
| `SetCharacterPenetrationRecoverySpeed` | `(handle: integer, speed: number)` | Set character penetration recovery speed. |
| `GetCharacterPenetrationRecoverySpeed` | `(handle: integer) -> number` | Return character penetration recovery speed. |
| `SetCharacterEnhancedInternalEdgeRemoval` | `(handle: integer, enable: boolean)` | Set character enhanced internal edge removal. |
| `GetCharacterEnhancedInternalEdgeRemoval` | `(handle: integer) -> boolean` | Return true if enhanced internal edge removal is enabled for the chara |
| `SetCharacterMaxNumHits` | `(handle: integer, maxHits: integer)` | Set character max num hits. |
| `GetCharacterMaxNumHits` | `(handle: integer) -> integer` | Return character max num hits. |
| `GetCharacterMaxHitsExceeded` | `(handle: integer) -> boolean` | Return true if the character's last update exceeded its contact limit. |
| `SetCharacterShape` | `(handle: integer, height: number, radius: number) -> boolean` | Change capsule dimensions without moving its feet. Returns false when  |
| `BeginGrab` | `(volume: VoxelVolume, worldPoint: Vector3) -> integer` | Begin a generic constraint-solver grab using a kinematic anchor and co |
| `UpdateGrab` | `(handle: integer, target: Vector3, timeStep: number, maxSpeed?: number, breakDistance?: number) -> boolean` | Steer the anchor toward target (the hand), speed-clamped to maxSpeed.  |
| `EndGrab` | `(handle: integer)` | End the grab and retire its runtime handle. |
| `GetGrabbedVolume` | `(handle: integer) -> VoxelVolume` | Return the volume referenced by a live grab handle, or null. |
| `FinalizeVolume` | `(volume: VoxelVolume)` | Publish a volume's collision to the simulation as immovable world geom |
| `FinalizeVolumeAsDynamic` | `(volume: VoxelVolume)` | Same, but as a movable body: a vehicle chassis, a wheel, a pushable cr |
| `RebuildDynamicProxy` | `(volume: VoxelVolume)` | Rebuild a dynamic volume's collision from its current voxels after edi |
| `SetMinFragmentVoxels` | `(voxels: integer)` | Components smaller than this are deleted rather than released as fragm |
| `GetMinFragmentVoxels` | `() -> integer` | Return min fragment voxels. |
| `SetMaxFrozenFragments` | `(count: integer)` | Cap on simultaneously existing frozen fragments. Exceeding it evicts t |
| `GetMaxFrozenFragments` | `() -> integer` | Return max frozen fragments. |
| `GetFrozenFragmentCount` | `() -> integer` | Return frozen fragment count. |
| `SetSpallChunkVoxels` | `(voxelsPerSide: integer)` | Side length, in voxels, of the lattice that removed material is groupe |
| `GetSpallChunkVoxels` | `() -> integer` | Return spall chunk voxels. |
| `SetSpallSpeed` | `(speed: number)` | Speed, in m/s, that debris is thrown away from the point of impact. |
| `GetSpallSpeed` | `() -> number` | Return spall speed. |
| `SetMaxSpallChunks` | `(count: integer)` | Upper bound on debris chunks thrown by one damage event. Default 12. R |
| `GetMaxSpallChunks` | `() -> integer` | Return max spall chunks. |
| `SetDamageNoise` | `(amount: number)` | Raggedness of the damage boundary, 0 (off, default) to 1. Fine voxels  |
| `SetStressBreakFactor` | `(factor: number)` | Stress-break heuristic: after damage, a nearly-severed structure snaps |
| `GetStressBreakFactor` | `() -> number` | Return stress break factor. |
| `SetContactEventThreshold` | `(minClosingSpeed: number)` | Contact events (E_VOXELCONTACT): bodies hitting each other harder than |
| `GetContactEventThreshold` | `() -> number` | Return contact event threshold. |
| `GetDamageNoise` | `() -> number` | Return damage noise. |
| `SetMinDamageableVoxels` | `(voxels: integer)` | Rubble at or below this many voxels ignores further damage (Teardown-s |
| `GetMinDamageableVoxels` | `() -> integer` | Return min damageable voxels. |
| `SetDebrisMaxAge` | `(seconds: number)` | Seconds a frozen piece of rubble may exist before being quietly remove |
| `GetDebrisMaxAge` | `() -> number` | Return debris max age. |
| `RemoveVolume` | `(volume: VoxelVolume)` | Destroy a volume: its Node, its component and its solver body. |
| `ApplyRadialImpulse` | `(worldCenter: Vector3, radius: number, impulse: number)` | Push everything dynamic within radius away from a point, waking frozen |
| `ApplyDamage` | `(volume: VoxelVolume, worldCenter: Vector3, radius: number, power?: number, scorchMaterial?: integer, onlyMaterial?: integer) -> integer` | Remove every voxel whose centre falls inside a world-space sphere, the |
| `ApplyDamageAtWorldPoint` | `(worldCenter: Vector3, radius: number, power?: number, scorchMaterial?: integer, onlyMaterial?: integer) -> integer` | Damage whatever is at a world position, without the caller having to k |
| `ApplyDamageCapsule` | `(worldA: Vector3, worldB: Vector3, radius: number, power?: number, scorchMaterial?: integer, onlyMaterial?: integer) -> integer` | Segment-swept damage: everything within `radius` of the segment [world |
| `ApplyDamageBox` | `(worldCenter: Vector3, halfExtent: Vector3, rotation: Quaternion, power?: number, scorchMaterial?: integer, onlyMaterial?: integer) -> integer` | Oriented-box damage. A thin box is the plane-cut primitive. |
| `ApplyDamageCone` | `(apex: Vector3, direction: Vector3, halfAngleDeg: number, range: number, power?: number, scorchMaterial?: integer, onlyMaterial?: integer) -> integer` | Directional cone damage: apex at `apex`, opening `halfAngleDeg` around |
| `GetMaterialAtWorldPoint` | `(worldPos: Vector3) -> integer` | Palette index of the solid voxel at a world position, or -1 if the poi |
| `ApplyFillAtWorldPoint` | `(worldCenter: Vector3, radius: number, material: integer) -> integer` | The build counterpart of ApplyDamageAtWorldPoint: fill EMPTY voxels wi |
| `GetVolumeCount` | `() -> integer` | Volumes this world is simulating, in creation order. Entries can be nu |
| `GetVolume` | `(index: integer) -> VoxelVolume` | Return volume. |
| `GetLastSpawnedFragmentCount` | `() -> integer` | Indexed view of the same list. Scripts cannot hand over a caller-owned |
| `GetLastSpawnedFragment` | `(index: integer) -> VoxelVolume` | Return last spawned fragment. |
| `OptimizeBroadPhase` | `()` | Rebuild the broad phase. Worth one call after the initial batch of sta |
| `SetMeshStreamingEnabled` | `(enable: boolean)` | Enable distance-based mesh streaming. The render mesh is a discardable |
| `IsMeshStreamingEnabled` | `() -> boolean` | Return true if distance-based mesh streaming is enabled. |
| `SetMeshStreamingDistance` | `(distance: number)` | Distance (meters, from the streaming reference position to the volume' |
| `GetMeshStreamingDistance` | `() -> number` | Return mesh streaming distance. |
| `SetMeshStreamingReferencePosition` | `(position: Vector3)` | Where "the camera" is for streaming decisions. Auto-follows viewport 0 |
| `ClearMeshStreamingReferencePosition` | `()` | Back to auto-following viewport 0. |
| `SetDdaResidencySourcePosition` | `(sourceId: integer, position: Vector3) -> boolean` | Add or update a scene-scoped secondary DDA residency source. It forms  |
| `RemoveDdaResidencySource` | `(sourceId: integer) -> boolean` | Remove one secondary source without changing the primary source. Lua c |
| `ClearDdaResidencySources` | `()` | Remove every secondary source. The primary pin/camera is unchanged. |
| `GetPendingMeshJobCount` | `() -> integer` | Background mesh jobs submitted but not yet landed. "Volume not dirty"  |
| `GetDdaStatsString` | `() -> string` | Stable key=value Dense DDA atlas/upload/job telemetry. The query never |
| `GetNetworkStatsString` | `() -> string` | Read current voxel content synchronization diagnostics without changin |
| `SetMeshLodDistance` | `(distance: number)` | Distance (meters) of the first LOD ring boundary: volumes closer than  |
| `GetMeshLodDistance` | `() -> number` | Return mesh lod distance. |
| `SetMeshScreenCullSize` | `(pixels: number)` | Screen-size cull: a volume whose world bounds project smaller than thi |
| `GetMeshScreenCullSize` | `() -> number` | Return mesh screen cull size. |
| `SetPaletteEntry` | `(index: integer, color: Color, hardness: number, debrisStyle?: integer, domain?: integer)` | Define a palette entry: the flat colour its voxels render with, and th |
| `GetPaletteBankCount` | `(domain?: integer) -> integer` | Banks allocated so far (>= 1; bank 0 always exists). |
| `GetPaletteBankLimit` | `() -> integer` | Highest bank count this world may allocate per palette domain: 256 wit |
| `GetPaletteSlotStats` | `(domain?: integer) -> VoxelPaletteSlotStats` | GPU palette slot occupancy for a domain; use it to tune engine.json vo |
| `GetPaletteDebrisStyle` | `(index: integer, domain?: integer) -> integer` | Return palette debris style. |
| `GetPaletteColor` | `(index: integer, domain?: integer) -> Color` | Return a color from the selected domain. |
| `GetPaletteHardness` | `(index: integer, domain?: integer) -> number` | Return palette hardness. |
| `SetPaletteEntryPBR` | `(index: integer, roughness: number, metallic: number, specular: number, emissive?: Color, domain?: integer)` | PBR surface parameters of an entry: how its voxels respond to light, o |
| `GetPaletteRoughness` | `(index: integer, domain?: integer) -> number` | Return palette roughness. |
| `GetPaletteMetallic` | `(index: integer, domain?: integer) -> number` | Return palette metallic. |
| `GetPaletteSpecular` | `(index: integer, domain?: integer) -> number` | Return palette specular. |
| `GetPaletteEmissive` | `(index: integer, domain?: integer) -> Color` | Return palette emissive. |
| `SetPaletteCutColor` | `(index: integer, color: Color, domain?: integer)` | Colour freshly exposed cross-sections of this entry render with (the i |
| `GetPaletteCutColor` | `(index: integer, domain?: integer) -> Color` | Return palette cut color. |
| `GetPaletteTexture` | `(domain?: integer) -> Texture2D` | The palette atlas the voxel shaders sample, one per domain. Each resid |
| `GetPaletteMaterial` | `(bank?: integer, domain?: integer) -> Material` | This world's default voxel material for a bank: Materials/VoxelPalette |
| `SetDdaRenderingEnabled` | `(enable: boolean)` | World-palette volumes use DDA when this is on and the render path has  |
| `IsDdaRenderingEnabled` | `() -> boolean` | Return true if DDA rendering is enabled for eligible volumes. |
| `InitializeShadowVolume` | `(boundsMin: Vector3, boundsMax: Vector3, texelSize: number) -> boolean` | Fixed world-space shadow volume for Teardown-style voxel shadow render |
| `InitializeShadowVolumeFromCurrentVolumes` | `(texelSize: number, sunExtend?: number) -> boolean` | One-shot bounds from current volumes, padded by sunExtend on every axi |
| `ShutdownShadowVolume` | `()` | Destroy the optional voxel shadow volume. |
| `IsShadowVolumeEnabled` | `() -> boolean` | Return true if the optional voxel shadow volume is initialized. |
| `SetShadowVolumeQuery` | `(query: VoxelShadowVolumeQuery)` | Switch Teardown query: Accurate / Sparse (default) / SuperSparse. Take |
| `GetShadowVolumeQuery` | `() -> VoxelShadowVolumeQuery` | Return shadow volume query. |
| `SetShadowVolumeJitter` | `(scale: number)` | 0 = no random tangent jitter. 1 = full Teardown jitterPosition (defaul |
| `GetShadowVolumeJitter` | `() -> number` | Return shadow volume jitter. |
| `Raycast` | `(ray: Ray, maxDistance: number, collisionMask?: integer) -> VoxelRaycastResult[]` |  |
| `RaycastSingle` | `(ray: Ray, maxDistance: number, collisionMask?: integer) -> VoxelRaycastResult` |  |
| `RaycastGrid` | `(ray: Ray, maxDistance: number, layerMask?: integer, ignoreVolume?: VoxelVolume) -> VoxelRaycastResult[]` |  |
| `RaycastGridSingle` | `(ray: Ray, maxDistance: number, layerMask?: integer, ignoreVolume?: VoxelVolume) -> VoxelRaycastResult` |  |
| `SphereCast` | `(sphere: Sphere, direction: Vector3, maxDistance: number, collisionMask?: integer) -> VoxelRaycastResult` |  |
| `SetDefaultFriction` | `(friction: number)` | Coulomb friction given to every body created from now on. Existing bod |
| `GetDefaultFriction` | `() -> number` | Return default friction. |
| `SetWaterEnabled` | `(enable: boolean)` | Enable the global water plane. Dynamic volumes below it receive buoyan |
| `IsWaterEnabled` | `() -> boolean` | Return true if the global water plane is enabled. |
| `SetWaterLevel` | `(level: number)` | Set the world-space height of the water plane. |
| `GetWaterLevel` | `() -> number` | Return the world-space height of the water plane. |
| `SetWaterDrag` | `(linearDrag: number, angularDrag: number)` | Drag factors for submerged bodies (Jolt linear/angular drag, defaults  |


### VoxelRollingContact  `: Component`

**属性（15）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `volume` | VoxelVolume |  |
| `active` | boolean |  |
| `sidewallFriction` | number |  |
| `nonSupportFriction` | number |  |
| `rollingResistance` | number |  |
| `supportContactCount` | integer |  |
| `nonSupportContactCount` | integer |  |
| `sidewallContactCount` | integer |  |
| `normalLoad` | number |  |
| `longitudinalSlipRatio` | number |  |
| `lateralSlipAngle` | number |  |
| `longitudinalForce` | number |  |
| `lateralForce` | number |  |
| `combinedGripUsage` | number |  |
| `supportNormalDot` | number |  |

**方法（34）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `GetVolume` | `() -> VoxelVolume` | Return the sibling volume whose contacts are decorated. |
| `IsActive` | `() -> boolean` | Return true while an enabled component has a live cylindrical volume b |
| `SetLongitudinalGrip` | `(peakSlipRatio: number, peakFriction: number, slideSlipRatio: number, slideFriction: number)` | Set longitudinal grip: static/peak capacity through peak slip, then hi |
| `GetLongitudinalPeakSlipRatio` | `() -> number` |  |
| `GetLongitudinalPeakFriction` | `() -> number` |  |
| `GetLongitudinalSlideSlipRatio` | `() -> number` |  |
| `GetLongitudinalSlideFriction` | `() -> number` |  |
| `SetLateralGrip` | `(peakSlipAngleDegrees: number, peakFriction: number, slideSlipAngleDegrees: number, slideFriction: number)` | Set lateral grip in degrees: static/peak capacity through peak angle,  |
| `GetLateralPeakSlipAngle` | `() -> number` |  |
| `GetLateralPeakFriction` | `() -> number` |  |
| `GetLateralSlideSlipAngle` | `() -> number` |  |
| `GetLateralSlideFriction` | `() -> number` |  |
| `SetSidewallFriction` | `(friction: number)` | Override sidewall friction, or reset it to inherit ordinary volume fri |
| `ResetSidewallFriction` | `()` |  |
| `GetSidewallFriction` | `() -> number` |  |
| `SetNonSupportFriction` | `(friction: number)` | Override non-support friction, or reset it to inherit ordinary volume  |
| `ResetNonSupportFriction` | `()` |  |
| `GetNonSupportFriction` | `() -> number` |  |
| `SetSupportRange` | `(noGripDot: number, fullGripDot: number)` | Set support-normal blend range as dot products against gravity-up. |
| `GetNoGripDot` | `() -> number` |  |
| `GetFullGripDot` | `() -> number` |  |
| `SetRollingResistance` | `(coefficient: number)` | Set dimensionless rolling-resistance coefficient. |
| `GetRollingResistance` | `() -> number` |  |
| `HasSupport` | `() -> boolean` | Previous completed physics-step telemetry. |
| `GetSupportContactCount` | `() -> integer` |  |
| `GetNonSupportContactCount` | `() -> integer` |  |
| `GetSidewallContactCount` | `() -> integer` |  |
| `GetNormalLoad` | `() -> number` |  |
| `GetLongitudinalSlipRatio` | `() -> number` |  |
| `GetLateralSlipAngle` | `() -> number` |  |
| `GetLongitudinalForce` | `() -> number` |  |
| `GetLateralForce` | `() -> number` |  |
| `GetCombinedGripUsage` | `() -> number` |  |
| `GetSupportNormalDot` | `() -> number` |  |


### VoxelVehicle  `: Component`

**属性（9）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `maxDriveForce` | number |  |
| `maxSteerAngle` | number |  |
| `steerSpeedFalloff` | number |  |
| `maxSpeed` | number |  |
| `grip` | number |  |
| `rollingResistance` | number |  |
| `skidSteer` | boolean |  |
| `forwardSpeed` | number |  |
| `wheelCount` | integer |  |

**方法（25）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `AddWheel` | `(attachLocal: Vector3, radius: number, restLength: number, stiffness: number, damping: number, steers: boolean, drives: boolean)` | Add a suspension corner (chassis-local attach point). Wheels are usual |
| `ClearWheels` | `()` | Clear wheels. |
| `GetWheelCount` | `() -> integer` | Return wheel count. |
| `SetInput` | `(throttle: number, steer: number, brake: number)` | Driver intent for the coming steps: throttle and steer in [-1, 1], bra |
| `SetMaxDriveForce` | `(force: number)` | Peak drive force per driven wheel (N) and max steering lock (degrees). |
| `GetMaxDriveForce` | `() -> number` | Return max drive force. |
| `SetMaxSteerAngle` | `(degrees: number)` | Set maximum steering angle in degrees. |
| `GetMaxSteerAngle` | `() -> number` | Return maximum steering angle in degrees. |
| `SetSteerSpeedFalloff` | `(perMs: number)` | Speed-sensitive steering falloff (per m/s): the effective steer angle  |
| `GetSteerSpeedFalloff` | `() -> number` | Return steer speed falloff. |
| `SetMaxSpeed` | `(metersPerSecond: number)` | Top speed (m/s): drive force fades linearly to zero as forward speed a |
| `GetMaxSpeed` | `() -> number` | Return max speed. |
| `SetGrip` | `(grip: number)` | Tyre grip: lateral slip is cancelled up to this fraction per step (0-1 |
| `GetGrip` | `() -> number` | Return grip. |
| `SetRollingResistance` | `(perStep: number)` | Rolling resistance on coasting wheels: this fraction of the roll speed |
| `GetRollingResistance` | `() -> number` | Return rolling resistance. |
| `GetForwardSpeed` | `() -> number` | Ground speed along the chassis forward axis, m/s (telemetry). |
| `GetWheelCompression` | `(index: integer) -> number` | Per-wheel suspension state, refreshed every solver step. What wheel VI |
| `IsWheelGrounded` | `(index: integer) -> boolean` | Return true if the wheel suspension ray is supported. |
| `SetSkidSteer` | `(enable: boolean)` | Tank-style differential steering for tracked vehicles. Steer input sca |
| `IsSkidSteer` | `() -> boolean` | Return true if differential skid steering is enabled. |
| `SetWheelSteerFactor` | `(index: integer, factor: number)` | Per-wheel steering authority in [-1, 1]; negative counter-steers (fork |
| `GetWheelSteerFactor` | `(index: integer) -> number` | Return wheel steer factor. |
| `GetWheelContactPoint` | `(index: integer) -> Vector3` | World-space ground contact of the wheel's ray (valid while grounded).  |
| `GetWheelSteerAngle` | `(index: integer) -> number` | Last solver-step steer angle in degrees for this wheel (0 if skid-stee |


### VoxelVolume  `: Component`

**属性（40）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `clientBodyMode` | integer |  |
| `contentReady` | boolean |  |
| `remoteReplica` | boolean |  |
| `voxelSize` | number |  |
| `destructible` | boolean |  |
| `evictable` | boolean |  |
| `density` | number |  |
| `mass` | number |  |
| `solidVolume` | number |  |
| `buoyancy` | number |  |
| `comOffset` | Vector3 |  |
| `linearVelocity` | Vector3 |  |
| `angularVelocity` | Vector3 |  |
| `linearDamping` | number |  |
| `angularDamping` | number |  |
| `gravityFactor` | number |  |
| `useGravity` | boolean |  |
| `friction` | number |  |
| `restitution` | number |  |
| `collisionLayer` | integer |  |
| `collisionMask` | integer |  |
| `collisionGroup` | integer |  |
| `volumeId` | integer |  |
| `collisionShapeType` | VoxelCollisionShapeType |  |
| `collisionShapeSize` | Vector3 |  |
| `collisionShapeOffset` | Vector3 |  |
| `collisionShapeRotation` | Quaternion |  |
| `assembly` | VoxelAssembly |  |
| `assemblyRootVolume` | VoxelVolume |  |
| `assemblyRoot` | boolean |  |
| `ccdEnabled` | boolean |  |
| `grid` | VoxelGrid |  |
| `voxelModel` | VoxelModel Writable: assignment swaps the model and re-bakes in place. |  |
| `voxelModelName` | string |  |
| `material` | Material |  |
| `vertexCount` | integer |  |
| `geometryDirty` | boolean |  |
| `static` | boolean |  |
| `tumbling` | boolean |  |
| `reSettling` | boolean |  |

**方法（95）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `IsContentReady` | `() -> boolean` | True once complete authoritative content has been installed; later dif |
| `IsRemoteReplica` | `() -> boolean` |  |
| `SetClientBodyMode` | `(mode: integer)` | CollisionProxy is the default. Simulated is reserved and rejected in P |
| `GetClientBodyMode` | `() -> integer` |  |
| `SetDimensions` | `(dimX: integer, dimY: integer, dimZ: integer)` | Allocate the grid. Voxels start empty; fill them and then call MarkGeo |
| `SetVoxelSize` | `(size: number)` | Set the voxel edge length in world units. |
| `GetVoxelSize` | `() -> number` | Return the voxel edge length in world units. |
| `GetGrid` | `() -> VoxelGrid` | Mutable access so damage and fragment extraction can write voxels. Vox |
| `MarkGeometryDirty` | `()` | Request a surface rebuild. Coalesced: several hits in one frame cost o |
| `MarkRegionDirty` | `(x0: integer, y0: integer, z0: integer, x1: integer, y1: integer, z1: integer)` | Mark only the chunks overlapping an inclusive voxel region (plus one v |
| `IsGeometryDirty` | `() -> boolean` | Return true if render geometry is waiting to be rebuilt. |
| `RebuildGeometry` | `()` | Rebuild the render surface now. Normally driven by the world once per  |
| `SetMaterial` | `(material: Material)` | Set material. |
| `GetMaterial` | `() -> Material` | Return material. |
| `GetPaletteDomain` | `() -> integer` | Which palette bank this volume's grid bytes index (see the bank sectio |
| `GetPaletteBank` | `() -> integer` |  |
| `GetPaletteSlot` | `() -> integer` | GPU palette atlas slot currently holding this volume's bank (equal to  |
| `SetPaletteBank` | `(bank: integer)` | Set palette bank. |
| `GetVertexCount` | `() -> integer` | Vertices in the current surface mesh. Zero means nothing has been buil |
| `GetMeshLodLevel` | `() -> integer` | The level the current chunk table meshes at: level L covers cells of 2 |
| `IsStatic` | `() -> boolean` | Predicates alongside GetState because the Lua bindings cannot express  |
| `IsTumbling` | `() -> boolean` | Return true if the volume is in the tumbling state. |
| `IsReSettling` | `() -> boolean` | Return true if the volume is settling on its exact proxy before freezi |
| `SetDestructible` | `(destructible: boolean)` | Set whether damage may modify this volume. Terrain usually clears this |
| `IsDestructible` | `() -> boolean` | Whether damage may remove voxels from this volume. True by default. |
| `SetEvictable` | `(evictable: boolean)` | Set whether the debris budget may delete this volume. Spall rubble sta |
| `IsEvictable` | `() -> boolean` | Whether the debris budget may delete this volume to make room. False b |
| `SetCollidable` | `(collidable: boolean)` | Set whether scene-load adoption builds a solver body. False creates a  |
| `IsCollidable` | `() -> boolean` | Whether scene-load adoption gives this volume a solver body. True for  |
| `SetDensity` | `(density: number)` | Set density in kilograms per cubic metre for dynamic mass calculation. |
| `GetDensity` | `() -> number` | Density in kg/m^3, used for this volume's own mass when dynamic and in |
| `GetMass` | `() -> number` | Derived from density and current solid voxel volume. There is intentio |
| `GetSolidVolume` | `() -> number` | Return occupied voxel volume in cubic metres. |
| `SetBuoyancy` | `(buoyancy: number)` | Buoyancy factor override for the world's water plane. 0 (default) = au |
| `GetBuoyancy` | `() -> number` | Return buoyancy. |
| `SetComOffset` | `(offset: Vector3)` | Centre-of-mass offset in volume-local metres. Boats push it below the  |
| `GetComOffset` | `() -> Vector3` | Return the centre-of-mass offset in volume-local space. |
| `GetLinearVelocity` | `() -> Vector3` | World-space velocity of the simulation body. Zero for static or body-l |
| `SetLinearVelocity` | `(velocity: Vector3)` | Set linear velocity in world space, in metres per second. |
| `GetAngularVelocity` | `() -> Vector3` | Return angular velocity in world space, in radians per second. |
| `SetAngularVelocity` | `(velocity: Vector3)` | Set angular velocity in world space, in radians per second. |
| `SetLinearDamping` | `(damping: number)` | Motion damping, Jolt semantics (roughly the fraction of velocity shed  |
| `GetLinearDamping` | `() -> number` | Return linear damping. |
| `SetAngularDamping` | `(damping: number)` | Set angular damping. |
| `GetAngularDamping` | `() -> number` | Return angular damping. |
| `SetGravityFactor` | `(factor: number)` | Gravity multiplier for this body: 1 = normal (default), 0 = weightless |
| `GetGravityFactor` | `() -> number` | Return gravity factor. |
| `SetUseGravity` | `(enable: boolean)` | Set use gravity. |
| `GetUseGravity` | `() -> boolean` | Return true if world gravity affects the volume. |
| `SetCcdEnabled` | `(enable: boolean)` | Continuous collision detection (Jolt LinearCast), off by default. A fa |
| `IsCcdEnabled` | `() -> boolean` | Return true if continuous collision detection is enabled. |
| `SetDirectionalAngularDamping` | `(localAxis: Vector3, damping: number, maxTorque?: number)` | Damp only one volume-local angular axis. For an assembly member the ax |
| `ClearDirectionalAngularDamping` | `(localAxis: Vector3)` | Clear directional angular damping. |
| `ApplyForce` | `(force: Vector3)` | RigidBody-style force API, always world-space and automatically waking |
| `ApplyImpulse` | `(impulse: Vector3)` | Apply impulse in newton-seconds. |
| `ApplyTorque` | `(torque: Vector3)` | Apply torque in newton-metres. |
| `ApplyTorqueImpulse` | `(torqueImpulse: Vector3)` | Apply angular impulse in newton-metre-seconds. |
| `ResetForces` | `()` | Clear accumulated force and torque without clearing velocity. |
| `GetVelocityAtPoint` | `(worldPosition: Vector3) -> Vector3` | Return world-space velocity at the specified world-space point. |
| `Activate` | `()` | Wake the solver body. |
| `IsActive` | `() -> boolean` | Return whether the underlying shared rigid body is active (not sleepin |
| `SetFriction` | `(friction: number)` | Per-volume contact material. Negative serialized values mean inherit t |
| `GetFriction` | `() -> number` | Return friction. |
| `ResetFrictionToWorldDefault` | `()` | Reset friction to world default. |
| `HasFrictionOverride` | `() -> boolean` | Return true if friction overrides the world default. |
| `SetRestitution` | `(restitution: number)` | Set restitution. |
| `GetRestitution` | `() -> number` | Return restitution. |
| `ResetRestitutionToWorldDefault` | `()` | Reset restitution to world default. |
| `HasRestitutionOverride` | `() -> boolean` | Return true if restitution overrides the world default. |
| `SetCollisionLayer` | `(layer: integer)` | Member-level collision filtering. Layer is this volume's category; mas |
| `GetCollisionLayer` | `() -> integer` | Return collision layer. |
| `SetCollisionMask` | `(mask: integer)` | Set collision mask. |
| `GetCollisionMask` | `() -> integer` | Return collision mask. |
| `SetCollisionLayerAndMask` | `(layer: integer, mask: integer)` | Set collision layer and mask. |
| `SetCollisionGroup` | `(group: integer)` | Set collision group. |
| `GetCollisionGroup` | `() -> integer` | Return collision group. |
| `GetVolumeId` | `() -> integer` | Return volume id. |
| `SetCollisionShapeAuto` | `()` | Analytic proxies affect physics only and never duplicate or replace th |
| `SetCollisionBox` | `(size: Vector3, localOffset?: Vector3, localRotation?: Quaternion)` | Use a box proxy with full local size. localOffset is relative to the o |
| `SetCollisionSphere` | `(diameter: number, localOffset?: Vector3)` | Use a sphere proxy. diameter is the full diameter and localOffset is r |
| `SetCollisionCapsule` | `(diameter: number, height: number, localOffset?: Vector3, localRotation?: Quaternion)` | Use a capsule whose height is the total end-to-end height including bo |
| `SetCollisionCylinder` | `(diameter?: number, height?: number, localOffset?: Vector3, localRotation?: Quaternion)` | Use a cylinder proxy. Zero diameter and height derive both dimensions  |
| `SetCollisionCylinderAuto` | `(localAxis: Vector3)` | Derive cylinder dimensions from occupied bounds and orient its main ax |
| `GetCollisionShapeType` | `() -> VoxelCollisionShapeType` | Return collision shape type. |
| `GetCollisionShapeSize` | `() -> Vector3` | Return collision shape size. |
| `GetCollisionShapeOffset` | `() -> Vector3` | Return collision shape offset. |
| `GetCollisionShapeRotation` | `() -> Quaternion` | Return collision shape rotation. |
| `GetAssembly` | `() -> VoxelAssembly` | Assembly membership is introduced by VoxelAssembly; standalone volumes |
| `GetAssemblyRootVolume` | `() -> VoxelVolume` | Return assembly root volume. |
| `IsAssemblyRoot` | `() -> boolean` | Return true if this volume owns its assembly's shared body. |
| `SetVoxelModel` | `(model: VoxelModel)` | Bind a different source .vox and re-bake the grid from it in place (bo |
| `GetVoxelModel` | `() -> VoxelModel` | Resolve the source model through the resource cache (loading it if nee |
| `GetVoxelModelName` | `() -> string` | Return voxel model name. |
| `HasVoxelModel` | `() -> boolean` | Return true if a source voxel model is assigned. |
| `DetachFromVoxelModel` | `()` | Sever the link to the source .vox so the current grid serializes as bl |


### WorldPartitionComponent  `: Component`

**属性（8）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `numGridLevels` | integer |  |
| `debugDrawEnabled` | boolean |  |
| `maxLoadingCells` | integer |  |
| `activationBudgetUsec` | integer |  |
| `initialLoadComplete` | boolean |  |
| `loadingProgress` | number |  |
| `totalCellsInRange` | integer |  |
| `activatedCellsInRange` | integer |  |

**方法（13）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `AddGridLevel` | `(level: integer, cellSize: number, loadingRange: number, unloadMargin?: number)` |  |
| `LoadWorldData` | `(worldPartitionJsonPath: string) -> boolean` |  |
| `GetNumGridLevels` | `() -> integer` |  |
| `SetDebugDrawEnabled` | `(enabled: boolean)` |  |
| `GetDebugDrawEnabled` | `() -> boolean` |  |
| `SetMaxLoadingCells` | `(maxCells: integer)` |  |
| `GetMaxLoadingCells` | `() -> integer` |  |
| `SetActivationBudgetUsec` | `(usec: integer)` |  |
| `GetActivationBudgetUsec` | `() -> integer` |  |
| `IsInitialLoadComplete` | `() -> boolean` |  |
| `GetLoadingProgress` | `() -> number` |  |
| `GetTotalCellsInRange` | `() -> integer` |  |
| `GetActivatedCellsInRange` | `() -> integer` |  |


### WorldPartitionCell  `: Component`

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `pendingCount` | integer |  |
| `ready` | boolean |  |

**方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `IncrementPending` | `()` |  |
| `DecrementPending` | `()` |  |
| `GetPendingCount` | `() -> integer` |  |
| `IsReady` | `() -> boolean` |  |
| `FindInParents` | `(node: Node) -> WorldPartitionCell` |  |


### XMLElement

**属性（7）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `EMPTY` | XMLElement |  |
| `null` | boolean |  |
| `name` | string |  |
| `parent` | XMLElement |  |
| `value` | string |  |
| `numAttributes` | integer |  |
| `file` | XMLFile |  |

**方法（76）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `AppendChild` | `(element: XMLElement, asCopy: boolean) -> boolean` |  |
| `CreateChild` | `(name: string) -> XMLElement` |  |
| `GetOrCreateChild` | `(name: string) -> XMLElement` |  |
| `RemoveChild` | `(element: XMLElement) -> boolean` |  |
| `RemoveChildren` | `(name?: string) -> boolean` |  |
| `RemoveAttribute` | `(name?: string) -> boolean` |  |
| `Remove` | `() -> boolean` |  |
| `SetValue` | `(value: string) -> boolean` |  |
| `SetAttribute` | `(name: string, value: string) -> boolean` |  |
| `SetBool` | `(name: string, value: boolean) -> boolean` |  |
| `SetBoundingBox` | `(value: BoundingBox) -> boolean` |  |
| `SetColor` | `(name: string, value: Color) -> boolean` |  |
| `SetFloat` | `(name: string, value: number) -> boolean` |  |
| `SetDouble` | `(name: string, value: number) -> boolean` |  |
| `SetUInt` | `(name: string, value: integer) -> boolean` |  |
| `SetInt` | `(name: string, value: integer) -> boolean` |  |
| `SetUInt64` | `(name: string, value: integer) -> boolean` |  |
| `SetInt64` | `(name: string, value: integer) -> boolean` |  |
| `SetIntRect` | `(name: string, value: IntRect) -> boolean` |  |
| `SetIntVector2` | `(name: string, value: IntVector2) -> boolean` |  |
| `SetIntVector3` | `(name: string, value: IntVector3) -> boolean` |  |
| `SetRect` | `(name: string, value: Rect) -> boolean` |  |
| `SetQuaternion` | `(name: string, value: Quaternion) -> boolean` |  |
| `SetString` | `(name: string, value: string) -> boolean` |  |
| `SetVariant` | `(value: Variant) -> boolean` |  |
| `SetVariantValue` | `(value: Variant) -> boolean` |  |
| `SetResourceRef` | `(value: ResourceRef) -> boolean` |  |
| `SetResourceRefList` | `(value: ResourceRefList) -> boolean` |  |
| `SetVector2` | `(name: string, value: Vector2) -> boolean` |  |
| `SetVector3` | `(name: string, value: Vector3) -> boolean` |  |
| `SetVector4` | `(name: string, value: Vector4) -> boolean` |  |
| `SetVectorVariant` | `(name: string, value: Variant) -> boolean` |  |
| `SetMatrix3` | `(name: string, value: Matrix3) -> boolean` |  |
| `SetMatrix3x4` | `(name: string, value: Matrix3x4) -> boolean` |  |
| `SetMatrix4` | `(name: string, value: Matrix4) -> boolean` |  |
| `IsNull` | `() -> boolean` |  |
| `NotNull` | `() -> boolean` |  |
| `GetName` | `() -> string` |  |
| `HasChild` | `(name: string) -> boolean` |  |
| `GetChild` | `(name?: string) -> XMLElement` |  |
| `GetNext` | `(name?: string) -> XMLElement` |  |
| `GetParent` | `() -> XMLElement` |  |
| `GetNumAttributes` | `() -> integer` |  |
| `HasAttribute` | `(name: string) -> boolean` |  |
| `GetValue` | `() -> string` |  |
| `GetAttribute` | `(name?: string) -> string` |  |
| `GetAttributeLower` | `(name: string) -> string` |  |
| `GetAttributeUpper` | `(name: string) -> string` |  |
| `GetAttributeNames` | `() -> string[]` |  |
| `GetBool` | `(name: string) -> boolean` |  |
| `GetBoundingBox` | `() -> BoundingBox` |  |
| `GetColor` | `(name: string) -> Color` |  |
| `GetFloat` | `(name: string) -> number` |  |
| `GetDouble` | `(name: string) -> number` |  |
| `GetUInt` | `(name: string) -> integer` |  |
| `GetInt` | `(name: string) -> integer` |  |
| `GetUInt64` | `(name: string) -> integer` |  |
| `GetInt64` | `(name: string) -> integer` |  |
| `GetIntRect` | `(name: string) -> IntRect` |  |
| `GetIntVector2` | `(name: string) -> IntVector2` |  |
| `GetIntVector3` | `(name: string) -> IntVector3` |  |
| `GetRect` | `(name: string) -> Rect` |  |
| `GetQuaternion` | `(name: string) -> Quaternion` |  |
| `GetVariant` | `() -> Variant` |  |
| `GetVariantValue` | `(type: VariantType) -> Variant` |  |
| `GetResourceRef` | `() -> ResourceRef` |  |
| `GetResourceRefList` | `() -> ResourceRefList` |  |
| `GetVariantMap` | `() -> VariantMap` |  |
| `GetVector2` | `(name: string) -> Vector2` |  |
| `GetVector3` | `(name: string) -> Vector3` |  |
| `GetVector4` | `(name: string) -> Vector4` |  |
| `GetVector` | `(name: string) -> Vector4` |  |
| `GetMatrix3` | `(name: string) -> Matrix3` |  |
| `GetMatrix3x4` | `(name: string) -> Matrix3x4` |  |
| `GetMatrix4` | `(name: string) -> Matrix4` |  |
| `GetFile` | `() -> XMLFile` |  |


### XMLFile  `: Resource`

**构造**

```lua
fun(): XMLFile
```

**方法（7）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `FromString` | `(source: string) -> boolean` |  |
| `CreateRoot` | `(name?: string) -> XMLElement` |  |
| `GetOrCreateRoot` | `(name?: string) -> XMLElement` |  |
| `GetRoot` | `(name?: string) -> XMLElement` |  |
| `ToString` | `(indentation?: string) -> string` |  |
| `Patch` | `(patchFile: XMLFile)` |  |
| `Save` | `(fileName: string, indentation?: string) -> boolean` |  |


### ToonShadingParams

**构造**

```lua
fun(): ToonShadingParams
```

**属性（13）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `shadowHSV` | Vector3 |  |
| `skinShadowTint` | Color |  |
| `mainLightMaxContribution` | Color |  |
| `mainLightMultiplier` | Color |  |
| `rimTint` | Color |  |
| `rimIntensity` | number |  |
| `depthEffectsSimpleOffset` | number |  |
| `rimDepthThreshold` | number |  |
| `rimDepthFadeRange` | number |  |
| `faceDepthEffectsSimpleOffsetMultiplier` | number |  |
| `depthShadowInfluence` | number |  |
| `depthShadowThreshold` | number |  |
| `depthShadowFadeRange` | number |  |


### Zone  `: Drawable`

**属性（88）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `boundingBox` | BoundingBox |  |
| `inverseWorldTransform` | Matrix3x4 |  |
| `ambientColor` | Color |  |
| `ambientStartColor` | Color |  |
| `ambientEndColor` | Color |  |
| `fogColor` | Color |  |
| `fogDensity` | number Deprecated: use depthFogDensity (same value). |  |
| `fogStart` | number Deprecated: use depthFogStart (same value). |  |
| `fogEnd` | number Deprecated: use depthFogEnd (same value). |  |
| `fogHeight` | number Deprecated: use heightFogHeight (same value). |  |
| `fogHeightScale` | number Deprecated: use heightFogFalloff = fogHeightScale * 100. |  |
| `priority` | integer |  |
| `heightFog` | boolean Deprecated: use heightFogEnable (same value). |  |
| `skyFogIntensity` | number |  |
| `override` | boolean |  |
| `ambientGradient` | boolean |  |
| `zoneTexture` | Texture |  |
| `ambientSource` | AmbientSource |  |
| `sourceTexture` | Texture |  |
| `ambientIntensity` | number |  |
| `autoExposureEnabled` | boolean |  |
| `autoExposurePlusEnabled` | boolean |  |
| `autoExposureMinBrightness` | number |  |
| `autoExposureMaxBrightness` | number |  |
| `autoExposureBias` | number |  |
| `autoExposureSpeedUp` | number |  |
| `autoExposureSpeedDown` | number |  |
| `autoExposureForceTarget` | boolean |  |
| `ssrEnabled` | boolean |  |
| `ssrUsePrevFrameColor` | boolean |  |
| `ssgiEnabled` | boolean |  |
| `ssgiQuality` | integer |  |
| `ssgiIntensity` | number |  |
| `ssaoRadius` | number |  |
| `ssaoIntensity` | number |  |
| `motionBlurEnabled` | boolean |  |
| `motionBlurAmount` | number |  |
| `motionBlurMaxDistortion` | number |  |
| `tonemapLUTEnabled` | boolean |  |
| `tonemapMode` | TonemapMode |  |
| `toonShadingParams` | ToonShadingParams |  |
| `bloomPlusEnabled` | boolean |  |
| `bloomThreshold` | number |  |
| `bloomWeight` | number |  |
| `bloomPlusIntensity` | number |  |
| `bloomMode` | BloomMode |  |
| `bloomUEIntensity` | number |  |
| `bloomUEThreshold` | number |  |
| `bloomUESizeScale` | number |  |
| `volumetricFogEnabled` | boolean |  |
| `volumetricFogOverrideLightColors` | boolean |  |
| `volumetricFogDirectionalInscatteringColor` | Color |  |
| `skyLightVolumetricScatteringIntensity` | number |  |
| `depthFogDensity` | number |  |
| `depthFogStart` | number |  |
| `depthFogEnd` | number |  |
| `depthFogEnable` | boolean |  |
| `heightFogDensity` | number |  |
| `heightFogEnable` | boolean |  |
| `heightFogFalloff` | number |  |
| `heightFogHeight` | number |  |
| `volumetricFogDensity` | number |  |
| `volumetricFogHeight` | number |  |
| `volumetricFogHeightFalloff` | number |  |
| `volumetricFogScatteringColor` | Color |  |
| `volumetricFogAbsorptionColor` | Color |  |
| `volumetricFogAbsorptionIntensity` | number |  |
| `volumetricFogPhaseG` | number |  |
| `volumetricFogViewDistance` | number |  |
| `volumetricFogStartDistance` | number |  |
| `volumetricFogMaxOpacity` | number |  |
| `volumetricFogShaftContrast` | number |  |
| `volumetricFogShaftEdgeThreshold` | number |  |
| `volumetricFogShaftEdgeSoftness` | number |  |
| `volumetricFogShaftOcclusionThreshold` | number |  |
| `volumetricFogShaftGroundFadeHeight` | number |  |
| `volumetricFogShaftGroundFadeRange` | number |  |
| `volumetricFogShaftDistanceFadeLength` | number |  |
| `volumetricFogShaftSurfaceFadeRange` | number |  |
| `envSpecTexture` | Texture |  |
| `envTextureDiffIntensity` | number |  |
| `envTextureSpecIntensity` | number |  |
| `envCubeAngle` | number |  |
| `envCubeFollowAngle` | number |  |
| `fxaaEnabled` | boolean |  |
| `vignetteEnabled` | boolean |  |
| `vignetteIntensity` | number |  |
| `vignetteTexture` | Texture |  |

**方法（185）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `AddGBufferPostProcess` | `(material: Material Material using render_mode gbuffer_postprocess) -> integer` | Append a GBuffer effect; the zone retains the Material. |
| `RemoveGBufferPostProcess` | `(handle: integer Registration handle) -> boolean` | Remove the effect identified by handle. |
| `SetGBufferPostProcessEnabled` | `(handle: integer Registration handle, enabled: boolean Whether the effect executes) -> boolean` | Enable or disable an effect while preserving its order. |
| `MoveGBufferPostProcess` | `(handle: integer Registration handle, index: integer New zero-based index, less than the number of registrations) -> boolean` | Move an effect to a zero-based position in the chain. |
| `ClearGBufferPostProcesses` | `()` | Remove all effects and release the zone's Material references. |
| `SetBoundingBox` | `(box: BoundingBox)` |  |
| `SetAmbientColor` | `(color: Color)` |  |
| `SetFogColor` | `(color: Color)` |  |
| `SetFogDensity` | `(density: number)` | Deprecated. Use SetDepthFogDensity (same value). ⚠️废弃 |
| `SetFogStart` | `(start: number)` | Deprecated. Use SetDepthFogStart (same value). ⚠️废弃 |
| `SetFogEnd` | `(end_: number)` | Deprecated. Use SetDepthFogEnd (same value). ⚠️废弃 |
| `SetFogHeight` | `(height: number)` | Deprecated. Use SetHeightFogHeight (same value). ⚠️废弃 |
| `SetFogHeightScale` | `(scale: number)` | Deprecated. Use SetHeightFogFalloff(scale * 100): heightFogFalloff is  ⚠️废弃 |
| `SetPriority` | `(priority: integer)` |  |
| `SetHeightFog` | `(enable: boolean)` | Deprecated. Use SetHeightFogEnable (same value). ⚠️废弃 |
| `SetSkyFogIntensity` | `(value: number)` |  |
| `SetOverride` | `(enable: boolean)` |  |
| `SetAmbientGradient` | `(enable: boolean)` |  |
| `SetZoneTexture` | `(texture: Texture)` |  |
| `SetAmbientSource` | `(source: AmbientSource)` |  |
| `SetSourceTexture` | `(texture: Texture)` |  |
| `SetSourceTextureFromBakeCache` | `(texture: Texture)` |  |
| `ClearCapturedEnvironment` | `()` | Drop the environment captured by SkyLightCapture and fall back to the  |
| `SetAmbientIntensity` | `(intensity: number)` |  |
| `SetAutoExposureEnabled` | `(value: boolean)` |  |
| `SetAutoExposurePlusEnabled` | `(value: boolean)` | Select the UE-style histogram auto exposure path. Requires autoExposur |
| `SetAutoExposureMinBrightness` | `(value: number)` | Set the auto exposure white point lower limit (EV when extended lumina |
| `SetAutoExposureMaxBrightness` | `(value: number)` | Set the auto exposure white point upper limit (EV when extended lumina |
| `SetAutoExposureBias` | `(value: number)` | Set exposure compensation in EV; positive values brighten the image. P |
| `SetAutoExposureSpeedUp` | `(value: number)` | Set the adaptation speed when the scene gets brighter; negative values |
| `SetAutoExposureSpeedDown` | `(value: number)` | Set the adaptation speed when the scene gets darker; negative values f |
| `SetAutoExposureForceTarget` | `(enable: boolean)` | Skip temporal adaptation and use the target exposure every frame (usef |
| `SetSSREnabled` | `(enable: boolean)` |  |
| `SetSSRUsePrevFrameColor` | `(enable: boolean)` |  |
| `SetSSGIEnabled` | `(enable: boolean)` |  |
| `SetSSGIQuality` | `(quality: integer)` |  |
| `SetSSGIIntensity` | `(intensity: number)` |  |
| `SetSSAORadius` | `(radius: number)` |  |
| `SetSSAOIntensity` | `(intensity: number)` |  |
| `SetMotionBlurEnabled` | `(enable: boolean)` |  |
| `SetMotionBlurAmount` | `(amount: number)` |  |
| `SetMotionBlurMaxDistortion` | `(percent: number)` |  |
| `SetTonemapLUTEnabled` | `(enable: boolean)` |  |
| `SetTonemapMode` | `(mode: TonemapMode)` |  |
| `SetToonShadingParams` | `(params: ToonShadingParams)` |  |
| `SetBloomPlusEnabled` | `(value: boolean)` |  |
| `SetBloomThreshold` | `(value: number)` |  |
| `SetBloomWeight` | `(value: number)` |  |
| `SetBloomPlusIntensity` | `(value: number)` |  |
| `SetBloomMode` | `(mode: BloomMode)` |  |
| `SetBloomUEIntensity` | `(value: number)` |  |
| `SetBloomUEThreshold` | `(value: number)` |  |
| `SetBloomUESizeScale` | `(value: number)` |  |
| `SetBloomUESize` | `(stage: integer, size: number)` |  |
| `SetBloomUETint` | `(stage: integer, tint: Color)` |  |
| `SetVolumetricFogEnabled` | `(enable: boolean)` |  |
| `SetVolumetricFogOverrideLightColors` | `(enable: boolean)` |  |
| `SetVolumetricFogDirectionalInscatteringColor` | `(color: Color)` |  |
| `SetSkyLightVolumetricScatteringIntensity` | `(intensity: number)` |  |
| `SetDepthFogDensity` | `(value: number)` | Set depth (distance) fog density multiplier. |
| `SetDepthFogStart` | `(value: number)` | Set the distance where depth fog starts. |
| `SetDepthFogEnd` | `(value: number)` | Set the distance where depth fog reaches full density. |
| `SetDepthFogEnable` | `(enable: boolean)` | Enable or disable depth fog. |
| `SetHeightFogDensity` | `(value: number)` | Set height fog density. |
| `SetHeightFogEnable` | `(enable: boolean)` | Enable or disable height fog. |
| `SetHeightFogFalloff` | `(value: number)` | Set height fog falloff; larger values thin the fog faster above the fo |
| `SetHeightFogHeight` | `(value: number)` | Set the world height where height fog is densest. |
| `SetVolumetricFogDensity` | `(value: number)` | Set volumetric fog extinction density at the fog height. Typical range |
| `SetVolumetricFogHeight` | `(value: number)` | Set the world height where volumetric fog has its base density. |
| `SetVolumetricFogHeightFalloff` | `(value: number)` | Set how quickly volumetric fog thins with height. Small values keep me |
| `SetVolumetricFogScatteringColor` | `(color: Color)` | Set volumetric fog scattering colour. |
| `SetVolumetricFogAbsorptionColor` | `(color: Color)` | Set volumetric fog absorption colour. |
| `SetVolumetricFogAbsorptionIntensity` | `(value: number)` | Set volumetric fog absorption intensity; clamped to >= 0. |
| `SetVolumetricFogPhaseG` | `(value: number)` | Set the Henyey-Greenstein phase g; positive values scatter forward (br |
| `SetVolumetricFogViewDistance` | `(value: number)` | Set the distance covered by the volumetric fog grid; clamped to >= 0. |
| `SetVolumetricFogStartDistance` | `(value: number)` | Set the camera distance where volumetric fog starts; clamped to >= 0. |
| `SetVolumetricFogMaxOpacity` | `(value: number)` | Set the maximum volumetric fog opacity; clamped to [0, 1]. |
| `SetVolumetricFogShaftContrast` | `(value: number)` | Set light shaft contrast; 0 disables shaft enhancement. Clamped to [0, |
| `SetVolumetricFogShaftEdgeThreshold` | `(value: number)` | Set the shadow edge threshold used by shaft enhancement; clamped to [0 |
| `SetVolumetricFogShaftEdgeSoftness` | `(value: number)` | Set the shadow edge softness used by shaft enhancement; clamped to [0, |
| `SetVolumetricFogShaftOcclusionThreshold` | `(value: number)` | Set the occlusion threshold used by shaft enhancement; clamped to [0,  |
| `SetVolumetricFogShaftGroundFadeHeight` | `(value: number)` | Set the world height below which shaft enhancement fades out. |
| `SetVolumetricFogShaftGroundFadeRange` | `(value: number)` | Set the height range of the shaft ground fade; clamped to >= 0. |
| `SetVolumetricFogShaftDistanceFadeLength` | `(value: number)` | Set the camera distance over which shaft enhancement fades out; clampe |
| `SetVolumetricFogShaftSurfaceFadeRange` | `(value: number)` | Set the distance near surfaces where shaft enhancement fades out; clam |
| `SetEnvSpecTexture` | `(texture: Texture)` | Set the prefiltered specular IBL cubemap directly. Use SetSourceTextur |
| `SetEnvTextureDiffIntensity` | `(intensity: number)` | Set the diffuse (SH) environment lighting intensity. |
| `SetEnvTextureSpecIntensity` | `(intensity: number)` | Set the specular (IBL) environment lighting intensity. |
| `SetEnvCubeAngle` | `(value: number)` | Set the environment cubemap rotation around the Y axis, in degrees. Th |
| `SetEnvCubeFollowAngle` | `(value: number)` | Set the additional environment cubemap rotation that follows the main  |
| `SetFXAAEnabled` | `(value: boolean)` |  |
| `SetVignetteEnabled` | `(enable: boolean)` |  |
| `SetVignetteIntensity` | `(intensity: number)` |  |
| `SetVignetteTexture` | `(vignetteTexture: Texture)` |  |
| `GetInverseWorldTransform` | `() -> Matrix3x4` |  |
| `GetAmbientColor` | `() -> Color` |  |
| `GetAmbientStartColor` | `() -> Color` |  |
| `GetAmbientEndColor` | `() -> Color` |  |
| `GetFogColor` | `() -> Color` |  |
| `GetFogDensity` | `() -> number` | Deprecated. Use GetDepthFogDensity (same value). ⚠️废弃 |
| `GetFogStart` | `() -> number` | Deprecated. Use GetDepthFogStart (same value). ⚠️废弃 |
| `GetFogEnd` | `() -> number` | Deprecated. Use GetDepthFogEnd (same value). ⚠️废弃 |
| `GetFogHeight` | `() -> number` | Deprecated. Use GetHeightFogHeight (same value). ⚠️废弃 |
| `GetFogHeightScale` | `() -> number` | Deprecated. Use GetHeightFogFalloff() / 100: heightFogFalloff is 100x  ⚠️废弃 |
| `GetPriority` | `() -> integer` |  |
| `GetHeightFog` | `() -> boolean` | Deprecated. Use GetHeightFogEnable (same value). ⚠️废弃 |
| `GetSkyFogIntensity` | `() -> number` |  |
| `GetOverride` | `() -> boolean` |  |
| `GetAmbientGradient` | `() -> boolean` |  |
| `GetZoneTexture` | `() -> Texture` |  |
| `GetAmbientSource` | `() -> AmbientSource` |  |
| `GetSourceTexture` | `() -> Texture` |  |
| `HasCapturedEnvironment` | `() -> boolean` | Return whether the zone currently uses an environment captured from th |
| `GetAmbientIntensity` | `() -> number` |  |
| `GetAutoExposureEnabled` | `() -> boolean` |  |
| `GetAutoExposurePlusEnabled` | `() -> boolean` |  |
| `GetAutoExposureMinBrightness` | `() -> number` |  |
| `GetAutoExposureMaxBrightness` | `() -> number` |  |
| `GetAutoExposureBias` | `() -> number` |  |
| `GetAutoExposureSpeedUp` | `() -> number` |  |
| `GetAutoExposureSpeedDown` | `() -> number` |  |
| `GetAutoExposureForceTarget` | `() -> boolean` |  |
| `GetSSREnabled` | `() -> boolean` |  |
| `GetSSRUsePrevFrameColor` | `() -> boolean` |  |
| `GetSSGIEnabled` | `() -> boolean` |  |
| `GetSSGIQuality` | `() -> integer` |  |
| `GetSSGIIntensity` | `() -> number` |  |
| `GetSSAORadius` | `() -> number` |  |
| `GetSSAOIntensity` | `() -> number` |  |
| `GetMotionBlurEnabled` | `() -> boolean` |  |
| `GetMotionBlurAmount` | `() -> number` |  |
| `GetMotionBlurMaxDistortion` | `() -> number` |  |
| `GetTonemapLUTEnabled` | `() -> boolean` |  |
| `GetTonemapMode` | `() -> TonemapMode` |  |
| `GetToonShadingParams` | `() -> ToonShadingParams` |  |
| `GetBloomPlusEnabled` | `() -> boolean` |  |
| `GetBloomThreshold` | `() -> number` |  |
| `GetBloomWeight` | `() -> number` |  |
| `GetBloomPlusIntensity` | `() -> number` |  |
| `GetBloomMode` | `() -> BloomMode` |  |
| `GetBloomUEIntensity` | `() -> number` |  |
| `GetBloomUEThreshold` | `() -> number` |  |
| `GetBloomUESizeScale` | `() -> number` |  |
| `GetBloomUESize` | `(stage: integer) -> number` |  |
| `GetBloomUETint` | `(stage: integer) -> Color` |  |
| `GetVolumetricFogEnabled` | `() -> boolean` |  |
| `GetVolumetricFogOverrideLightColors` | `() -> boolean` |  |
| `GetVolumetricFogDirectionalInscatteringColor` | `() -> Color` |  |
| `GetSkyLightVolumetricScatteringIntensity` | `() -> number` |  |
| `GetDepthFogDensity` | `() -> number` |  |
| `GetDepthFogStart` | `() -> number` |  |
| `GetDepthFogEnd` | `() -> number` |  |
| `GetDepthFogEnable` | `() -> boolean` |  |
| `GetHeightFogDensity` | `() -> number` |  |
| `GetHeightFogEnable` | `() -> boolean` |  |
| `GetHeightFogFalloff` | `() -> number` |  |
| `GetHeightFogHeight` | `() -> number` |  |
| `GetVolumetricFogDensity` | `() -> number` |  |
| `GetVolumetricFogHeight` | `() -> number` |  |
| `GetVolumetricFogHeightFalloff` | `() -> number` |  |
| `GetVolumetricFogScatteringColor` | `() -> Color` |  |
| `GetVolumetricFogAbsorptionColor` | `() -> Color` |  |
| `GetVolumetricFogAbsorptionIntensity` | `() -> number` |  |
| `GetVolumetricFogPhaseG` | `() -> number` |  |
| `GetVolumetricFogViewDistance` | `() -> number` |  |
| `GetVolumetricFogStartDistance` | `() -> number` |  |
| `GetVolumetricFogMaxOpacity` | `() -> number` |  |
| `GetVolumetricFogShaftContrast` | `() -> number` |  |
| `GetVolumetricFogShaftEdgeThreshold` | `() -> number` |  |
| `GetVolumetricFogShaftEdgeSoftness` | `() -> number` |  |
| `GetVolumetricFogShaftOcclusionThreshold` | `() -> number` |  |
| `GetVolumetricFogShaftGroundFadeHeight` | `() -> number` |  |
| `GetVolumetricFogShaftGroundFadeRange` | `() -> number` |  |
| `GetVolumetricFogShaftDistanceFadeLength` | `() -> number` |  |
| `GetVolumetricFogShaftSurfaceFadeRange` | `() -> number` |  |
| `GetEnvSpecTexture` | `() -> Texture` |  |
| `GetEnvTextureDiffIntensity` | `() -> number` |  |
| `GetEnvTextureSpecIntensity` | `() -> number` |  |
| `GetEnvCubeAngle` | `() -> number` |  |
| `GetEnvCubeFollowAngle` | `() -> number` |  |
| `GetFXAAEnabled` | `() -> boolean` |  |
| `GetVignetteEnabled` | `() -> boolean` |  |
| `GetVignetteIntensity` | `() -> number` |  |
| `GetVignetteTexture` | `() -> Texture` |  |
| `IsInside` | `(point: Vector3) -> boolean` |  |


### CrowdObstacleAvoidanceParams

**属性（10）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `velBias` | number | Velocity bias |
| `weightDesVel` | number | Desired velocity weight |
| `weightCurVel` | number | Current velocity weight |
| `weightSide` | number | Side bias weight |
| `weightToi` | number | Time of impact weight |
| `horizTime` | number | Horizon time |
| `gridSize` | integer | Grid size |
| `adaptiveDivs` | integer | Adaptive divisions |
| `adaptiveRings` | integer | Adaptive rings |
| `adaptiveDepth` | integer | Adaptive depth |


### EventHandler


### LuaFile  `: Resource`


### SceneResolver


### tolua

**静态方法（2）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `cast` | `(object, typeName: string) -> any` | Cast an object to a specific type |
| `type` | `(object) -> string` | Get the type name of an object |


### coroutine  `: table`

**属性（5）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `start` | fun(func: function): boolean, any |  |
| `sleep` | fun(time: number): any |  |
| `update` | fun(steptime: number) |  |
| `waitevent` | fun(event: string): any |  |
| `sendevent` | fun(event: string) |  |

**静态方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `start` | `(func: function) -> boolean` | Start a new coroutine immediately |
| `sleep` | `(time: number) -> any` | Suspend the current coroutine for a specified time |
| `update` | `(steptime: number)` | Update all sleeping coroutines (internal use, called by the engine) |
| `waitevent` | `(event: string) -> any` | Wait for a specific event in the current coroutine |
| `sendevent` | `(event: string)` | Send an event to wake up all coroutines waiting for it |


### View


### SDL_Event


### common

**静态方法（5）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `get_map_name` | `() -> string` | Get the current map/game name |
| `get_user_id` | `() -> integer` | Get the current user's ID |
| `get_env_extra` | `() -> string` | Get the opaque JSON payload supplied by the host runtime environment |
| `setDeviceOrientation` | `(options: DeviceOrientationRequest)` | Request a host orientation change. onSuccess means the request was acc |
| `onDeviceOrientationChange` | `(listener: fun(res: DeviceOrientationChangeResult)|nil)` | Listen for device orientation changes. A new listener replaces the pre |


### DeviceOrientationRequest

**属性（3）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `value` | "portrait"|"landscape" |  |
| `onSuccess?` | fun() |  |
| `onError?` | fun(err: { errMsg: string }) |  |


### DeviceOrientationChangeResult


### UserNicknameInfo

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `userId` | integer |  |
| `nickname` | string |  |


### GetUserNicknameOptions


### cjson

**属性（2）**

| 字段 | 类型 | 说明 |
|------|------|------|
| `_NAME` | string | Module name ("cjson") |
| `_VERSION` | string | Module version ("1.1.0") |

**静态方法（3）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `encode` | `(value) -> string` | Encode a Lua value to a JSON string. Tables with consecutive integer k |
| `decode` | `(json: string) -> any` | Decode a JSON string into a Lua value. JSON objects become Lua tables  |
| `null` | `()` | Return a JSON null sentinel value (currently returns nil). |


### math

**静态方法（8）**

| 方法 | 签名 | 说明 |
|------|------|------|
| `pow` | `(x: number, y: number) -> number` |  |
| `atan2` | `(y: number, x?: number) -> number` |  |
| `cosh` | `(x: number) -> number` |  |
| `sinh` | `(x: number) -> number` |  |
| `tanh` | `(x: number) -> number` |  |
| `frexp` | `(x: number) -> number,` |  |
| `ldexp` | `(x: number, e: integer) -> number` |  |
| `log10` | `(x: number) -> number` |  |


---

## 四、事件系统

共 **260** 个事件，通过 `SubscribeToEvent("事件名", handler)` 订阅。

harness 中 `SubscribeToEvent` / `SendEvent` 可做成 no-op（记录即可，不真正触发）。
回调签名统一为 `function(eventType, eventData)`。

### 事件名列表

| `AnimationAllStoppingEventEventData` | `AnimationControllerPostUpdateEventData` | `AnimationControllerPreUpdateEventData` |
| `AnimationFinishedEventData` | `AnimationFinishedEventExEventData` | `AnimationSuppressedEventEventData` |
| `AnimationTriggerEventData` | `AnimationUpdateEventData` | `AppDidEnterBackgroundEventData` |
| `AppDidEnterForebackgroundEventData` | `AppLowMemoryEventData` | `AppTerminatingEventData` |
| `AppWillEnterBackgroundEventData` | `AppWillEnterForegroundEventData` | `AsyncExecFinishedEventData` |
| `AsyncLoadFinishedEventData` | `AsyncLoadProgressEventData` | `AttributeAnimationAddedEventData` |
| `AttributeAnimationRemovedEventData` | `AttributeAnimationUpdateEventData` | `BeforeBeginFrameEventData` |
| `BeforeRestartGameEventData` | `BeginAllViewRenderEventData` | `BeginFrameEventData` |
| `BeginRenderingEventData` | `BeginReplayFrameEventData` | `BeginViewRenderEventData` |
| `BeginViewUpdateEventData` | `BoneHierarchyCreatedEventData` | `ChangeLanguageEventData` |
| `ClickEndEventData` | `ClickEventData` | `ClientConnectedEventData` |
| `ClientDisconnectedEventData` | `ClientIdentityAcceptedEventData` | `ClientIdentityEventData` |
| `ClientSceneLoadedEventData` | `ComponentAddedEventData` | `ComponentClonedEventData` |
| `ComponentEnabledChangedEventData` | `ComponentRemovedEventData` | `ComputeDispatchFailedEventData` |
| `ConnectFailedEventData` | `ConsoleCommandEventData` | `CrowdAgentFailureEventData` |
| `CrowdAgentFormationEventData` | `CrowdAgentNodeFailureEventData` | `CrowdAgentNodeFormationEventData` |
| `CrowdAgentNodeRepositionEventData` | `CrowdAgentNodeStateChangedEventData` | `CrowdAgentRepositionEventData` |
| `CrowdAgentStateChangedEventData` | `CustomValueEventData` | `DbCursorEventData` |
| `DefocusedEventData` | `DeviceLostEventData` | `DeviceResetEventData` |
| `DiskQuotaExceededEventData` | `DoubleClickEventData` | `DragBeginEventData` |
| `DragCancelEventData` | `DragDropFinishEventData` | `DragDropTestEventData` |
| `DragEndEventData` | `DragMoveEventData` | `DrawableBatchesChangedEventData` |
| `DropFileEventData` | `DumpTestEventData` | `ElementAddedEventData` |
| `ElementRemovedEventData` | `EndAllViewsRenderEventData` | `EndFrameEventData` |
| `EndRenderingEventData` | `EndViewRenderEventData` | `EndViewUpdateEventData` |
| `ExitRequestedEventData` | `FileChangedEventData` | `FileSelectedEventData` |
| `FinishResourcesEventData` | `FocusChangedEventData` | `FocusedEventData` |
| `GPUHandleChangedEventData` | `GameSessionStartedEventData` | `GestureInputEventData` |
| `GestureRecordedEventData` | `HoverBeginEventData` | `HoverEndEventData` |
| `IKEffectorTargetChangedEventData` | `InputBeginEventData` | `InputEndEventData` |
| `InputFocusEventData` | `InterceptNetworkUpdateEventData` | `ItemClickedEventData` |
| `ItemDeselectedEventData` | `ItemDoubleClickedEventData` | `ItemSelectedEventData` |
| `JoystickAxisMoveEventData` | `JoystickButtonDownEventData` | `JoystickButtonUpEventData` |
| `JoystickConnectedEventData` | `JoystickDisconnectedEventData` | `JoystickHatMoveEventData` |
| `KeyDownEventData` | `KeyUpEventData` | `LayoutUpdatedEventData` |
| `LoadFailedEventData` | `LogMessageEventData` | `MenuSelectedEventData` |
| `MergeLightEventData` | `MessageACKEventData` | `ModalChangedEventData` |
| `MouseButtonDownEventData` | `MouseButtonUpEventData` | `MouseModeChangedEventData` |
| `MouseMoveEventData` | `MouseVisibleChangedEventData` | `MouseWheelEventData` |
| `MultiGestureEventData` | `NameChangedEventData` | `NanoVGRenderEventData` |
| `NavigationAllTilesRemovedEventData` | `NavigationAreaRebuiltEventData` | `NavigationMeshRebuiltEventData` |
| `NavigationObstacleAddedEventData` | `NavigationObstacleRemovedEventData` | `NavigationTileAddedEventData` |
| `NavigationTileRemovedEventData` | `NetworkBannedEventData` | `NetworkHostDiscoveredEventData` |
| `NetworkInvalidPasswordEventData` | `NetworkMessageEventData` | `NetworkNatMasterConnectionFailedEventData` |
| `NetworkNatMasterConnectionSucceededEventData` | `NetworkNatPunchtroughFailedEventData` | `NetworkNatPunchtroughSucceededEventData` |
| `NetworkReconnectedEventData` | `NetworkReconnectingEventData` | `NetworkSceneLoadFailedEventData` |
| `NetworkUpdateEventData` | `NetworkUpdateSentEventData` | `NodeAddedEventData` |
| `NodeBeginContact2DEventData` | `NodeClonedEventData` | `NodeCollisionEndEventData` |
| `NodeCollisionEventData` | `NodeCollisionStartEventData` | `NodeEnabledChangedEventData` |
| `NodeEndContact2DEventData` | `NodeNameChangedEventData` | `NodeRemovedEventData` |
| `NodeTagAddedEventData` | `NodeTagRemovedEventData` | `NodeUpdateContact2DEventData` |
| `OrientationChangedEventData` | `ParticleEffectFinishedEventData` | `ParticlesDurationEventData` |
| `ParticlesEndEventData` | `PhysicsBeginContact2DEventData` | `PhysicsCollisionEndEventData` |
| `PhysicsCollisionEventData` | `PhysicsCollisionStartEventData` | `PhysicsEndContact2DEventData` |
| `PhysicsMotionStatesEventData` | `PhysicsPostStepEventData` | `PhysicsPreStepEventData` |
| `PhysicsUpdateContact2DEventData` | `PlayerSessionDisconnectedEventData` | `PlayerSessionJoinedEventData` |
| `PlayerSessionLeftEventData` | `PlayerSessionReconnectedEventData` | `PositionedEventData` |
| `PostPreRenderUIEventData` | `PostRenderUIEventData` | `PostRenderUpdateEventData` |
| `PostUpdateEventData` | `PreEndFrameEventData` | `PreRenderUIEventData` |
| `PreRenderUpdateEventData` | `PressedEventData` | `ProgressBarChangedEventData` |
| `ReleasedEventData` | `ReloadFailedEventData` | `ReloadFinishedEventData` |
| `ReloadStartedEventData` | `RemoteEventDataEventData` | `RenderPathEventEventData` |
| `RenderQualityApplyEventData` | `RenderSurfaceUpdateEventData` | `RenderUpdateEventData` |
| `ResizedEventData` | `ResourceBackgroundLoadedEventData` | `ResourceNotFoundEventData` |
| `RuntimeDebuggerSelectionChangedEventData` | `SDLRawInputEventData` | `SceneDrawableUpdateFinishedEventData` |
| `SceneLoadFinishedEventData` | `ScenePostUpdateEventData` | `SceneSubsystemUpdateEventData` |
| `SceneUpdateEventData` | `ScreenModeEventData` | `ScrollBarChangedEventData` |
| `SelectionChangedEventData` | `ServerConnectedEventData` | `ServerDisconnectedEventData` |
| `ShaderCompileEventData` | `ShaderUncompressEventData` | `SliderChangedEventData` |
| `SliderPagedEventData` | `SoundFinishedEventData` | `TargetPositionChangedEventData` |
| `TargetRotationChangedEventData` | `TemporaryChangedEventData` | `TerrainCreatedEventData` |
| `TextChangedEventData` | `TextEditingEventData` | `TextEntryEventData` |
| `TextFinishedEventData` | `TextInputEventData` | `TextureFroamtWarnEventData` |
| `ToggledEventData` | `TouchBeginEventData` | `TouchEndEventData` |
| `TouchEventData` | `TouchMoveEventData` | `TransportConnectFailedEventData` |
| `TransportConnectedEventData` | `TransportDataEventData` | `TransportDisconnectedEventData` |
| `UIDropFileEventData` | `UIMouseClickEndEventData` | `UIMouseClickEventData` |
| `UIMouseClickReplayEventData` | `UIMouseClickReplayPlayEventData` | `UIMouseClickedEventData` |
| `UIMouseDoubleClickEventData` | `UIMouseEnterEventData` | `UIMouseLeaveEventData` |
| `UIMouseRealClickEventData` | `UnhandledKeyEventData` | `UnknownResourceTypeEventData` |
| `UpdateEventData` | `UpdateSmoothingEventData` | `UserStatEventData` |
| `ViewBakeShadowMapEventData` | `ViewBuffersReadyEventData` | `ViewChangedEventData` |
| `ViewGlobalShaderParametersEventData` | `VisibleChangedEventData` | `VoxelAssemblyMemberDetachedEventData` |
| `VoxelAssemblyRootChangedEventData` | `VoxelContactEventData` | `VoxelContentReadyEventData` |
| `VoxelDamagedEventData` | `VoxelFragmentFrozenEventData` | `VoxelInitialSyncFinishedEventData` |
| `VoxelSeveredEventData` | `VoxelSyncFailedEventData` | `WindowClosedEventData` |
| `WindowPosEventData` | `WorldPartitionReadyEventData` |

### 事件数据结构

回调中 `eventData["字段"]` 返回 `Variant`，需再调 `:GetInt()` / `:GetFloat()` / `:GetString()` 取值。

#### AnimationAllStoppingEventEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `GetPtr` | fun(self: AnimationAllStoppingEventEventData, field: "Node"): AnimationState |

#### AnimationControllerPostUpdateEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `TimeStep` | VariantWithFloat |
| `GetFloat` | fun(self: AnimationControllerPostUpdateEventData, field: "TimeStep"): number |
| `GetPtr` | fun(self: AnimationControllerPostUpdateEventData, field: "Node"): Node |

#### AnimationControllerPreUpdateEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `TimeStep` | VariantWithFloat |
| `GetFloat` | fun(self: AnimationControllerPreUpdateEventData, field: "TimeStep"): number |
| `GetPtr` | fun(self: AnimationControllerPreUpdateEventData, field: "Node"): Node |

#### AnimationFinishedEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `Animation` | VariantWithPtr |
| `Name` | VariantWithString |
| `Looped` | VariantWithBool |
| `GetBool` | fun(self: AnimationFinishedEventData, field: "Looped"): boolean |
| `GetPtr` | fun(self: AnimationFinishedEventData, field: "Node"): Node |
| `GetPtr` | fun(self: AnimationFinishedEventData, field: "Animation"): Animation |
| `GetString` | fun(self: AnimationFinishedEventData, field: "Name"): string |

#### AnimationFinishedEventExEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `State` | VariantWithPtr |
| `HandleHash` | VariantWithStringHash |
| `NameHash` | VariantWithStringHash |
| `Completed` | VariantWithBool |
| `Animation` | VariantWithPtr |
| `Name` | VariantWithString |
| `Looped` | VariantWithBool |
| `GetBool` | fun(self: AnimationFinishedEventExEventData, field: "Completed"): boolean |
| `GetBool` | fun(self: AnimationFinishedEventExEventData, field: "Looped"): boolean |
| `GetPtr` | fun(self: AnimationFinishedEventExEventData, field: "Node"): Node |
| `GetPtr` | fun(self: AnimationFinishedEventExEventData, field: "State"): AnimationState |
| `GetPtr` | fun(self: AnimationFinishedEventExEventData, field: "Animation"): Animation |
| `GetString` | fun(self: AnimationFinishedEventExEventData, field: "Name"): string |
| `GetStringHash` | fun(self: AnimationFinishedEventExEventData, field: "HandleHash"): StringHash |
| `GetStringHash` | fun(self: AnimationFinishedEventExEventData, field: "NameHash"): StringHash |

#### AnimationSuppressedEventEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `HandleHash` | VariantWithStringHash |
| `NameHash` | VariantWithStringHash |
| `Occluded` | VariantWithBool |
| `GetBool` | fun(self: AnimationSuppressedEventEventData, field: "Occluded"): boolean |
| `GetPtr` | fun(self: AnimationSuppressedEventEventData, field: "Node"): Node |
| `GetStringHash` | fun(self: AnimationSuppressedEventEventData, field: "HandleHash"): StringHash |
| `GetStringHash` | fun(self: AnimationSuppressedEventEventData, field: "NameHash"): StringHash |

#### AnimationTriggerEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `Animation` | VariantWithPtr |
| `Name` | VariantWithString |
| `Time` | VariantWithFloat |
| `Data` | Variant |
| `GetFloat` | fun(self: AnimationTriggerEventData, field: "Time"): number |
| `GetPtr` | fun(self: AnimationTriggerEventData, field: "Node"): Node |
| `GetPtr` | fun(self: AnimationTriggerEventData, field: "Animation"): Animation |
| `GetString` | fun(self: AnimationTriggerEventData, field: "Name"): string |

#### AnimationUpdateEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `TimeStep` | VariantWithFloat |
| `GetFloat` | fun(self: AnimationUpdateEventData, field: "TimeStep"): number |
| `GetPtr` | fun(self: AnimationUpdateEventData, field: "Scene"): Scene |

#### AsyncExecFinishedEventData

| 字段 | 类型 |
|------|------|
| `RequestID` | VariantWithInt |
| `ExitCode` | VariantWithInt |
| `GetInt` | fun(self: AsyncExecFinishedEventData, field: "RequestID"): integer |
| `GetInt` | fun(self: AsyncExecFinishedEventData, field: "ExitCode"): integer |

#### AsyncLoadFinishedEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `GetPtr` | fun(self: AsyncLoadFinishedEventData, field: "Scene"): Scene |

#### AsyncLoadProgressEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `Progress` | VariantWithFloat |
| `LoadedNodes` | VariantWithInt |
| `TotalNodes` | VariantWithInt |
| `LoadedResources` | VariantWithInt |
| `TotalResources` | VariantWithInt |
| `GetFloat` | fun(self: AsyncLoadProgressEventData, field: "Progress"): number |
| `GetInt` | fun(self: AsyncLoadProgressEventData, field: "LoadedNodes"): integer |
| `GetInt` | fun(self: AsyncLoadProgressEventData, field: "TotalNodes"): integer |
| `GetInt` | fun(self: AsyncLoadProgressEventData, field: "LoadedResources"): integer |
| `GetInt` | fun(self: AsyncLoadProgressEventData, field: "TotalResources"): integer |
| `GetPtr` | fun(self: AsyncLoadProgressEventData, field: "Scene"): Scene |

#### AttributeAnimationAddedEventData

| 字段 | 类型 |
|------|------|
| `ObjectAnimation` | VariantWithPtr |
| `AttributeAnimationName` | VariantWithString |
| `GetPtr` | fun(self: AttributeAnimationAddedEventData, field: "ObjectAnimation"): ObjectAnimation |
| `GetString` | fun(self: AttributeAnimationAddedEventData, field: "AttributeAnimationName"): string |

#### AttributeAnimationRemovedEventData

| 字段 | 类型 |
|------|------|
| `ObjectAnimation` | VariantWithPtr |
| `AttributeAnimationName` | VariantWithString |
| `GetPtr` | fun(self: AttributeAnimationRemovedEventData, field: "ObjectAnimation"): ObjectAnimation |
| `GetString` | fun(self: AttributeAnimationRemovedEventData, field: "AttributeAnimationName"): string |

#### AttributeAnimationUpdateEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `TimeStep` | VariantWithFloat |
| `GetFloat` | fun(self: AttributeAnimationUpdateEventData, field: "TimeStep"): number |
| `GetPtr` | fun(self: AttributeAnimationUpdateEventData, field: "Scene"): Scene |

#### BeforeBeginFrameEventData

| 字段 | 类型 |
|------|------|
| `FrameNumber` | VariantWithInt |
| `TimeStep` | VariantWithFloat |
| `GetFloat` | fun(self: BeforeBeginFrameEventData, field: "TimeStep"): number |
| `GetInt` | fun(self: BeforeBeginFrameEventData, field: "FrameNumber"): integer |

#### BeginFrameEventData

| 字段 | 类型 |
|------|------|
| `FrameNumber` | VariantWithInt |
| `TimeStep` | VariantWithFloat |
| `GetFloat` | fun(self: BeginFrameEventData, field: "TimeStep"): number |
| `GetInt` | fun(self: BeginFrameEventData, field: "FrameNumber"): integer |

#### BeginReplayFrameEventData

| 字段 | 类型 |
|------|------|
| `FrameNumber` | VariantWithInt |
| `TimeStep` | VariantWithFloat |
| `GetFloat` | fun(self: BeginReplayFrameEventData, field: "TimeStep"): number |
| `GetInt` | fun(self: BeginReplayFrameEventData, field: "FrameNumber"): integer |

#### BeginViewRenderEventData

| 字段 | 类型 |
|------|------|
| `View` | VariantWithPtr |
| `Texture` | VariantWithPtr |
| `Surface` | VariantWithPtr |
| `Scene` | VariantWithPtr |
| `Camera` | VariantWithPtr |
| `GetPtr` | fun(self: BeginViewRenderEventData, field: "View"): View |
| `GetPtr` | fun(self: BeginViewRenderEventData, field: "Texture"): Texture |
| `GetPtr` | fun(self: BeginViewRenderEventData, field: "Surface"): RenderSurface |
| `GetPtr` | fun(self: BeginViewRenderEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: BeginViewRenderEventData, field: "Camera"): Camera |

#### BeginViewUpdateEventData

| 字段 | 类型 |
|------|------|
| `View` | VariantWithPtr |
| `Texture` | VariantWithPtr |
| `Surface` | VariantWithPtr |
| `Scene` | VariantWithPtr |
| `Camera` | VariantWithPtr |
| `GetPtr` | fun(self: BeginViewUpdateEventData, field: "View"): View |
| `GetPtr` | fun(self: BeginViewUpdateEventData, field: "Texture"): Texture |
| `GetPtr` | fun(self: BeginViewUpdateEventData, field: "Surface"): RenderSurface |
| `GetPtr` | fun(self: BeginViewUpdateEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: BeginViewUpdateEventData, field: "Camera"): Camera |

#### BoneHierarchyCreatedEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `GetPtr` | fun(self: BoneHierarchyCreatedEventData, field: "Node"): Node |

#### ClickEndEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `BeginElement` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `Button` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: ClickEndEventData, field: "X"): integer |
| `GetInt` | fun(self: ClickEndEventData, field: "Y"): integer |
| `GetInt` | fun(self: ClickEndEventData, field: "Button"): integer |
| `GetInt` | fun(self: ClickEndEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: ClickEndEventData, field: "Qualifiers"): integer |
| `GetPtr` | fun(self: ClickEndEventData, field: "Element"): UIElement |
| `GetPtr` | fun(self: ClickEndEventData, field: "BeginElement"): UIElement |

#### ClickEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `Button` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: ClickEventData, field: "X"): integer |
| `GetInt` | fun(self: ClickEventData, field: "Y"): integer |
| `GetInt` | fun(self: ClickEventData, field: "Button"): integer |
| `GetInt` | fun(self: ClickEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: ClickEventData, field: "Qualifiers"): integer |
| `GetPtr` | fun(self: ClickEventData, field: "Element"): UIElement |

#### ClientConnectedEventData

| 字段 | 类型 |
|------|------|
| `Connection` | VariantWithPtr |
| `GetPtr` | fun(self: ClientConnectedEventData, field: "Connection"): Connection |

#### ClientDisconnectedEventData

| 字段 | 类型 |
|------|------|
| `Connection` | VariantWithPtr |
| `GetPtr` | fun(self: ClientDisconnectedEventData, field: "Connection"): Connection |

#### ClientIdentityAcceptedEventData

| 字段 | 类型 |
|------|------|
| `Connection` | VariantWithPtr |
| `GetPtr` | fun(self: ClientIdentityAcceptedEventData, field: "Connection"): Connection |

#### ClientIdentityEventData

| 字段 | 类型 |
|------|------|
| `Connection` | VariantWithPtr |
| `Allow` | VariantWithBool |
| `GetBool` | fun(self: ClientIdentityEventData, field: "Allow"): boolean |
| `GetPtr` | fun(self: ClientIdentityEventData, field: "Connection"): Connection |

#### ClientSceneLoadedEventData

| 字段 | 类型 |
|------|------|
| `Connection` | VariantWithPtr |
| `GetPtr` | fun(self: ClientSceneLoadedEventData, field: "Connection"): Connection |

#### ComponentAddedEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `Node` | VariantWithPtr |
| `Component` | VariantWithPtr |
| `GetPtr` | fun(self: ComponentAddedEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: ComponentAddedEventData, field: "Node"): Node |
| `GetPtr` | fun(self: ComponentAddedEventData, field: "Component"): Component |

#### ComponentClonedEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `Component` | VariantWithPtr |
| `CloneComponent` | VariantWithPtr |
| `GetPtr` | fun(self: ComponentClonedEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: ComponentClonedEventData, field: "Component"): Component |
| `GetPtr` | fun(self: ComponentClonedEventData, field: "CloneComponent"): Component |

#### ComponentEnabledChangedEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `Node` | VariantWithPtr |
| `Component` | VariantWithPtr |
| `GetPtr` | fun(self: ComponentEnabledChangedEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: ComponentEnabledChangedEventData, field: "Node"): Node |
| `GetPtr` | fun(self: ComponentEnabledChangedEventData, field: "Component"): Component |

#### ComponentRemovedEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `Node` | VariantWithPtr |
| `Component` | VariantWithPtr |
| `GetPtr` | fun(self: ComponentRemovedEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: ComponentRemovedEventData, field: "Node"): Node |
| `GetPtr` | fun(self: ComponentRemovedEventData, field: "Component"): Component |

#### ComputeDispatchFailedEventData

| 字段 | 类型 |
|------|------|
| `Shader` | VariantWithString |
| `Sequence` | VariantWithInt |
| `Error` | VariantWithString |
| `GetInt` | fun(self: ComputeDispatchFailedEventData, field: "Sequence"): integer |
| `GetString` | fun(self: ComputeDispatchFailedEventData, field: "Shader"): string |
| `GetString` | fun(self: ComputeDispatchFailedEventData, field: "Error"): string |

#### ConsoleCommandEventData

| 字段 | 类型 |
|------|------|
| `Command` | VariantWithString |
| `Id` | VariantWithString |
| `GetString` | fun(self: ConsoleCommandEventData, field: "Command"): string |
| `GetString` | fun(self: ConsoleCommandEventData, field: "Id"): string |

#### CrowdAgentFailureEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `CrowdAgent` | VariantWithPtr |
| `Position` | VariantWithVector3 |
| `Velocity` | VariantWithVector3 |
| `CrowdAgentState` | VariantWithInt |
| `CrowdTargetState` | VariantWithInt |
| `GetInt` | fun(self: CrowdAgentFailureEventData, field: "CrowdAgentState"): integer |
| `GetInt` | fun(self: CrowdAgentFailureEventData, field: "CrowdTargetState"): integer |
| `GetPtr` | fun(self: CrowdAgentFailureEventData, field: "Node"): Node |
| `GetPtr` | fun(self: CrowdAgentFailureEventData, field: "CrowdAgent"): CrowdAgent |
| `GetVector3` | fun(self: CrowdAgentFailureEventData, field: "Position"): Vector3 |
| `GetVector3` | fun(self: CrowdAgentFailureEventData, field: "Velocity"): Vector3 |

#### CrowdAgentFormationEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `CrowdAgent` | VariantWithPtr |
| `Index` | VariantWithInt |
| `Size` | VariantWithInt |
| `Position` | VariantWithVector3 |
| `GetInt` | fun(self: CrowdAgentFormationEventData, field: "Index"): integer |
| `GetInt` | fun(self: CrowdAgentFormationEventData, field: "Size"): integer |
| `GetPtr` | fun(self: CrowdAgentFormationEventData, field: "Node"): Node |
| `GetPtr` | fun(self: CrowdAgentFormationEventData, field: "CrowdAgent"): CrowdAgent |
| `GetVector3` | fun(self: CrowdAgentFormationEventData, field: "Position"): Vector3 |

#### CrowdAgentNodeFailureEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `CrowdAgent` | VariantWithPtr |
| `Position` | VariantWithVector3 |
| `Velocity` | VariantWithVector3 |
| `CrowdAgentState` | VariantWithInt |
| `CrowdTargetState` | VariantWithInt |
| `GetInt` | fun(self: CrowdAgentNodeFailureEventData, field: "CrowdAgentState"): integer |
| `GetInt` | fun(self: CrowdAgentNodeFailureEventData, field: "CrowdTargetState"): integer |
| `GetPtr` | fun(self: CrowdAgentNodeFailureEventData, field: "Node"): Node |
| `GetPtr` | fun(self: CrowdAgentNodeFailureEventData, field: "CrowdAgent"): CrowdAgent |
| `GetVector3` | fun(self: CrowdAgentNodeFailureEventData, field: "Position"): Vector3 |
| `GetVector3` | fun(self: CrowdAgentNodeFailureEventData, field: "Velocity"): Vector3 |

#### CrowdAgentNodeFormationEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `CrowdAgent` | VariantWithPtr |
| `Index` | VariantWithInt |
| `Size` | VariantWithInt |
| `Position` | VariantWithVector3 |
| `GetInt` | fun(self: CrowdAgentNodeFormationEventData, field: "Index"): integer |
| `GetInt` | fun(self: CrowdAgentNodeFormationEventData, field: "Size"): integer |
| `GetPtr` | fun(self: CrowdAgentNodeFormationEventData, field: "Node"): Node |
| `GetPtr` | fun(self: CrowdAgentNodeFormationEventData, field: "CrowdAgent"): CrowdAgent |
| `GetVector3` | fun(self: CrowdAgentNodeFormationEventData, field: "Position"): Vector3 |

#### CrowdAgentNodeRepositionEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `CrowdAgent` | VariantWithPtr |
| `Position` | VariantWithVector3 |
| `Velocity` | VariantWithVector3 |
| `Arrived` | VariantWithBool |
| `TimeStep` | VariantWithFloat |
| `GetBool` | fun(self: CrowdAgentNodeRepositionEventData, field: "Arrived"): boolean |
| `GetFloat` | fun(self: CrowdAgentNodeRepositionEventData, field: "TimeStep"): number |
| `GetPtr` | fun(self: CrowdAgentNodeRepositionEventData, field: "Node"): Node |
| `GetPtr` | fun(self: CrowdAgentNodeRepositionEventData, field: "CrowdAgent"): CrowdAgent |
| `GetVector3` | fun(self: CrowdAgentNodeRepositionEventData, field: "Position"): Vector3 |
| `GetVector3` | fun(self: CrowdAgentNodeRepositionEventData, field: "Velocity"): Vector3 |

#### CrowdAgentNodeStateChangedEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `CrowdAgent` | VariantWithPtr |
| `Position` | VariantWithVector3 |
| `Velocity` | VariantWithVector3 |
| `CrowdAgentState` | VariantWithInt |
| `CrowdTargetState` | VariantWithInt |
| `GetInt` | fun(self: CrowdAgentNodeStateChangedEventData, field: "CrowdAgentState"): integer |
| `GetInt` | fun(self: CrowdAgentNodeStateChangedEventData, field: "CrowdTargetState"): integer |
| `GetPtr` | fun(self: CrowdAgentNodeStateChangedEventData, field: "Node"): Node |
| `GetPtr` | fun(self: CrowdAgentNodeStateChangedEventData, field: "CrowdAgent"): CrowdAgent |
| `GetVector3` | fun(self: CrowdAgentNodeStateChangedEventData, field: "Position"): Vector3 |
| `GetVector3` | fun(self: CrowdAgentNodeStateChangedEventData, field: "Velocity"): Vector3 |

#### CrowdAgentRepositionEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `CrowdAgent` | VariantWithPtr |
| `Position` | VariantWithVector3 |
| `Velocity` | VariantWithVector3 |
| `Arrived` | VariantWithBool |
| `TimeStep` | VariantWithFloat |
| `GetBool` | fun(self: CrowdAgentRepositionEventData, field: "Arrived"): boolean |
| `GetFloat` | fun(self: CrowdAgentRepositionEventData, field: "TimeStep"): number |
| `GetPtr` | fun(self: CrowdAgentRepositionEventData, field: "Node"): Node |
| `GetPtr` | fun(self: CrowdAgentRepositionEventData, field: "CrowdAgent"): CrowdAgent |
| `GetVector3` | fun(self: CrowdAgentRepositionEventData, field: "Position"): Vector3 |
| `GetVector3` | fun(self: CrowdAgentRepositionEventData, field: "Velocity"): Vector3 |

#### CrowdAgentStateChangedEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `CrowdAgent` | VariantWithPtr |
| `Position` | VariantWithVector3 |
| `Velocity` | VariantWithVector3 |
| `CrowdAgentState` | VariantWithInt |
| `CrowdTargetState` | VariantWithInt |
| `GetInt` | fun(self: CrowdAgentStateChangedEventData, field: "CrowdAgentState"): integer |
| `GetInt` | fun(self: CrowdAgentStateChangedEventData, field: "CrowdTargetState"): integer |
| `GetPtr` | fun(self: CrowdAgentStateChangedEventData, field: "Node"): Node |
| `GetPtr` | fun(self: CrowdAgentStateChangedEventData, field: "CrowdAgent"): CrowdAgent |
| `GetVector3` | fun(self: CrowdAgentStateChangedEventData, field: "Position"): Vector3 |
| `GetVector3` | fun(self: CrowdAgentStateChangedEventData, field: "Velocity"): Vector3 |

#### DbCursorEventData

| 字段 | 类型 |
|------|------|
| `DbConnection` | VariantWithPtr |
| `SQL` | VariantWithString |
| `NumCols` | VariantWithInt |
| `ColValues` | VariantWithVariantVector |
| `ColHeaders` | VariantWithStringVector |
| `Filter` | VariantWithBool |
| `Abort` | VariantWithBool |
| `GetBool` | fun(self: DbCursorEventData, field: "Filter"): boolean |
| `GetBool` | fun(self: DbCursorEventData, field: "Abort"): boolean |
| `GetInt` | fun(self: DbCursorEventData, field: "NumCols"): integer |
| `GetPtr` | fun(self: DbCursorEventData, field: "DbConnection"): DbConnection |
| `GetString` | fun(self: DbCursorEventData, field: "SQL"): string |
| `GetStringVector` | fun(self: DbCursorEventData, field: "ColHeaders"): string[] |
| `GetVariantVector` | fun(self: DbCursorEventData, field: "ColValues"): Variant[] |

#### DefocusedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `GetPtr` | fun(self: DefocusedEventData, field: "Element"): UIElement |

#### DiskQuotaExceededEventData

| 字段 | 类型 |
|------|------|
| `Path` | VariantWithString |
| `GetString` | fun(self: DiskQuotaExceededEventData, field: "Path"): string |

#### DoubleClickEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `XBegin` | VariantWithInt |
| `YBegin` | VariantWithInt |
| `Button` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: DoubleClickEventData, field: "X"): integer |
| `GetInt` | fun(self: DoubleClickEventData, field: "Y"): integer |
| `GetInt` | fun(self: DoubleClickEventData, field: "XBegin"): integer |
| `GetInt` | fun(self: DoubleClickEventData, field: "YBegin"): integer |
| `GetInt` | fun(self: DoubleClickEventData, field: "Button"): integer |
| `GetInt` | fun(self: DoubleClickEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: DoubleClickEventData, field: "Qualifiers"): integer |
| `GetPtr` | fun(self: DoubleClickEventData, field: "Element"): UIElement |

#### DragBeginEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `ElementX` | VariantWithInt |
| `ElementY` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `NumButtons` | VariantWithInt |
| `GetInt` | fun(self: DragBeginEventData, field: "X"): integer |
| `GetInt` | fun(self: DragBeginEventData, field: "Y"): integer |
| `GetInt` | fun(self: DragBeginEventData, field: "ElementX"): integer |
| `GetInt` | fun(self: DragBeginEventData, field: "ElementY"): integer |
| `GetInt` | fun(self: DragBeginEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: DragBeginEventData, field: "NumButtons"): integer |
| `GetPtr` | fun(self: DragBeginEventData, field: "Element"): UIElement |

#### DragCancelEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `ElementX` | VariantWithInt |
| `ElementY` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `NumButtons` | VariantWithInt |
| `GetInt` | fun(self: DragCancelEventData, field: "X"): integer |
| `GetInt` | fun(self: DragCancelEventData, field: "Y"): integer |
| `GetInt` | fun(self: DragCancelEventData, field: "ElementX"): integer |
| `GetInt` | fun(self: DragCancelEventData, field: "ElementY"): integer |
| `GetInt` | fun(self: DragCancelEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: DragCancelEventData, field: "NumButtons"): integer |
| `GetPtr` | fun(self: DragCancelEventData, field: "Element"): UIElement |

#### DragDropFinishEventData

| 字段 | 类型 |
|------|------|
| `Source` | VariantWithPtr |
| `Target` | VariantWithPtr |
| `Accept` | VariantWithBool |
| `GetBool` | fun(self: DragDropFinishEventData, field: "Accept"): boolean |
| `GetPtr` | fun(self: DragDropFinishEventData, field: "Source"): UIElement |
| `GetPtr` | fun(self: DragDropFinishEventData, field: "Target"): UIElement |

#### DragDropTestEventData

| 字段 | 类型 |
|------|------|
| `Source` | VariantWithPtr |
| `Target` | VariantWithPtr |
| `Accept` | VariantWithBool |
| `GetBool` | fun(self: DragDropTestEventData, field: "Accept"): boolean |
| `GetPtr` | fun(self: DragDropTestEventData, field: "Source"): UIElement |
| `GetPtr` | fun(self: DragDropTestEventData, field: "Target"): UIElement |

#### DragEndEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `ElementX` | VariantWithInt |
| `ElementY` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `NumButtons` | VariantWithInt |
| `GetInt` | fun(self: DragEndEventData, field: "X"): integer |
| `GetInt` | fun(self: DragEndEventData, field: "Y"): integer |
| `GetInt` | fun(self: DragEndEventData, field: "ElementX"): integer |
| `GetInt` | fun(self: DragEndEventData, field: "ElementY"): integer |
| `GetInt` | fun(self: DragEndEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: DragEndEventData, field: "NumButtons"): integer |
| `GetPtr` | fun(self: DragEndEventData, field: "Element"): UIElement |

#### DragMoveEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `DX` | VariantWithInt |
| `DY` | VariantWithInt |
| `ElementX` | VariantWithInt |
| `ElementY` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `NumButtons` | VariantWithInt |
| `GetInt` | fun(self: DragMoveEventData, field: "X"): integer |
| `GetInt` | fun(self: DragMoveEventData, field: "Y"): integer |
| `GetInt` | fun(self: DragMoveEventData, field: "DX"): integer |
| `GetInt` | fun(self: DragMoveEventData, field: "DY"): integer |
| `GetInt` | fun(self: DragMoveEventData, field: "ElementX"): integer |
| `GetInt` | fun(self: DragMoveEventData, field: "ElementY"): integer |
| `GetInt` | fun(self: DragMoveEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: DragMoveEventData, field: "NumButtons"): integer |
| `GetPtr` | fun(self: DragMoveEventData, field: "Element"): UIElement |

#### DrawableBatchesChangedEventData

| 字段 | 类型 |
|------|------|
| `Drawable` | VariantWithPtr |
| `GetPtr` | fun(self: DrawableBatchesChangedEventData, field: "Drawable"): Drawable |

#### DropFileEventData

| 字段 | 类型 |
|------|------|
| `FileName` | VariantWithString |
| `GetString` | fun(self: DropFileEventData, field: "FileName"): string |

#### ElementAddedEventData

| 字段 | 类型 |
|------|------|
| `Root` | VariantWithPtr |
| `Parent` | VariantWithPtr |
| `Element` | VariantWithPtr |
| `GetPtr` | fun(self: ElementAddedEventData, field: "Root"): UIElement |
| `GetPtr` | fun(self: ElementAddedEventData, field: "Parent"): UIElement |
| `GetPtr` | fun(self: ElementAddedEventData, field: "Element"): UIElement |

#### ElementRemovedEventData

| 字段 | 类型 |
|------|------|
| `Root` | VariantWithPtr |
| `Parent` | VariantWithPtr |
| `Element` | VariantWithPtr |
| `GetPtr` | fun(self: ElementRemovedEventData, field: "Root"): UIElement |
| `GetPtr` | fun(self: ElementRemovedEventData, field: "Parent"): UIElement |
| `GetPtr` | fun(self: ElementRemovedEventData, field: "Element"): UIElement |

#### EndViewRenderEventData

| 字段 | 类型 |
|------|------|
| `View` | VariantWithPtr |
| `Texture` | VariantWithPtr |
| `Surface` | VariantWithPtr |
| `Scene` | VariantWithPtr |
| `Camera` | VariantWithPtr |
| `GetPtr` | fun(self: EndViewRenderEventData, field: "View"): View |
| `GetPtr` | fun(self: EndViewRenderEventData, field: "Texture"): Texture |
| `GetPtr` | fun(self: EndViewRenderEventData, field: "Surface"): RenderSurface |
| `GetPtr` | fun(self: EndViewRenderEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: EndViewRenderEventData, field: "Camera"): Camera |

#### EndViewUpdateEventData

| 字段 | 类型 |
|------|------|
| `View` | VariantWithPtr |
| `Texture` | VariantWithPtr |
| `Surface` | VariantWithPtr |
| `Scene` | VariantWithPtr |
| `Camera` | VariantWithPtr |
| `GetPtr` | fun(self: EndViewUpdateEventData, field: "View"): View |
| `GetPtr` | fun(self: EndViewUpdateEventData, field: "Texture"): Texture |
| `GetPtr` | fun(self: EndViewUpdateEventData, field: "Surface"): RenderSurface |
| `GetPtr` | fun(self: EndViewUpdateEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: EndViewUpdateEventData, field: "Camera"): Camera |

#### FileChangedEventData

| 字段 | 类型 |
|------|------|
| `FileName` | VariantWithString |
| `ResourceName` | VariantWithString |
| `GetString` | fun(self: FileChangedEventData, field: "FileName"): string |
| `GetString` | fun(self: FileChangedEventData, field: "ResourceName"): string |

#### FileSelectedEventData

| 字段 | 类型 |
|------|------|
| `FileName` | VariantWithString |
| `Filter` | VariantWithString |
| `OK` | VariantWithBool |
| `GetBool` | fun(self: FileSelectedEventData, field: "OK"): boolean |
| `GetString` | fun(self: FileSelectedEventData, field: "FileName"): string |
| `GetString` | fun(self: FileSelectedEventData, field: "Filter"): string |

#### FocusChangedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `ClickedElement` | VariantWithPtr |
| `GetPtr` | fun(self: FocusChangedEventData, field: "Element"): UIElement |
| `GetPtr` | fun(self: FocusChangedEventData, field: "ClickedElement"): UIElement |

#### FocusedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `ByKey` | VariantWithBool |
| `GetBool` | fun(self: FocusedEventData, field: "ByKey"): boolean |
| `GetPtr` | fun(self: FocusedEventData, field: "Element"): UIElement |

#### GameSessionStartedEventData

| 字段 | 类型 |
|------|------|
| `IsReconnect` | VariantWithBool |
| `SessionId` | VariantWithString |
| `GetBool` | fun(self: GameSessionStartedEventData, field: "IsReconnect"): boolean |
| `GetString` | fun(self: GameSessionStartedEventData, field: "SessionId"): string |

#### GestureInputEventData

| 字段 | 类型 |
|------|------|
| `GestureID` | VariantWithInt |
| `CenterX` | VariantWithInt |
| `CenterY` | VariantWithInt |
| `NumFingers` | VariantWithInt |
| `Error` | VariantWithFloat |
| `GetFloat` | fun(self: GestureInputEventData, field: "Error"): number |
| `GetInt` | fun(self: GestureInputEventData, field: "GestureID"): integer |
| `GetInt` | fun(self: GestureInputEventData, field: "CenterX"): integer |
| `GetInt` | fun(self: GestureInputEventData, field: "CenterY"): integer |
| `GetInt` | fun(self: GestureInputEventData, field: "NumFingers"): integer |

#### GestureRecordedEventData

| 字段 | 类型 |
|------|------|
| `GestureID` | VariantWithInt |
| `GetInt` | fun(self: GestureRecordedEventData, field: "GestureID"): integer |

#### HoverBeginEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `ElementX` | VariantWithInt |
| `ElementY` | VariantWithInt |
| `GetInt` | fun(self: HoverBeginEventData, field: "X"): integer |
| `GetInt` | fun(self: HoverBeginEventData, field: "Y"): integer |
| `GetInt` | fun(self: HoverBeginEventData, field: "ElementX"): integer |
| `GetInt` | fun(self: HoverBeginEventData, field: "ElementY"): integer |
| `GetPtr` | fun(self: HoverBeginEventData, field: "Element"): UIElement |

#### HoverEndEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `GetPtr` | fun(self: HoverEndEventData, field: "Element"): UIElement |

#### IKEffectorTargetChangedEventData

| 字段 | 类型 |
|------|------|
| `EffectorNode` | VariantWithPtr |
| `TargetNode` | VariantWithPtr |
| `GetPtr` | fun(self: IKEffectorTargetChangedEventData, field: "EffectorNode"): Node |
| `GetPtr` | fun(self: IKEffectorTargetChangedEventData, field: "TargetNode"): Node |

#### InputFocusEventData

| 字段 | 类型 |
|------|------|
| `Focus` | VariantWithBool |
| `Minimized` | VariantWithBool |
| `GetBool` | fun(self: InputFocusEventData, field: "Focus"): boolean |
| `GetBool` | fun(self: InputFocusEventData, field: "Minimized"): boolean |

#### InterceptNetworkUpdateEventData

| 字段 | 类型 |
|------|------|
| `Serializable` | VariantWithPtr |
| `TimeStamp` | VariantWithInt |
| `Index` | VariantWithInt |
| `Name` | VariantWithString |
| `Value` | Variant |
| `GetInt` | fun(self: InterceptNetworkUpdateEventData, field: "TimeStamp"): integer |
| `GetInt` | fun(self: InterceptNetworkUpdateEventData, field: "Index"): integer |
| `GetPtr` | fun(self: InterceptNetworkUpdateEventData, field: "Serializable"): Serializable |
| `GetString` | fun(self: InterceptNetworkUpdateEventData, field: "Name"): string |

#### ItemClickedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `Item` | VariantWithPtr |
| `Selection` | VariantWithInt |
| `Button` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: ItemClickedEventData, field: "Selection"): integer |
| `GetInt` | fun(self: ItemClickedEventData, field: "Button"): integer |
| `GetInt` | fun(self: ItemClickedEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: ItemClickedEventData, field: "Qualifiers"): integer |
| `GetPtr` | fun(self: ItemClickedEventData, field: "Element"): UIElement |
| `GetPtr` | fun(self: ItemClickedEventData, field: "Item"): UIElement |

#### ItemDeselectedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `Selection` | VariantWithInt |
| `GetInt` | fun(self: ItemDeselectedEventData, field: "Selection"): integer |
| `GetPtr` | fun(self: ItemDeselectedEventData, field: "Element"): UIElement |

#### ItemDoubleClickedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `Item` | VariantWithPtr |
| `Selection` | VariantWithInt |
| `Button` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: ItemDoubleClickedEventData, field: "Selection"): integer |
| `GetInt` | fun(self: ItemDoubleClickedEventData, field: "Button"): integer |
| `GetInt` | fun(self: ItemDoubleClickedEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: ItemDoubleClickedEventData, field: "Qualifiers"): integer |
| `GetPtr` | fun(self: ItemDoubleClickedEventData, field: "Element"): UIElement |
| `GetPtr` | fun(self: ItemDoubleClickedEventData, field: "Item"): UIElement |

#### ItemSelectedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `Selection` | VariantWithInt |
| `GetInt` | fun(self: ItemSelectedEventData, field: "Selection"): integer |
| `GetPtr` | fun(self: ItemSelectedEventData, field: "Element"): UIElement |

#### JoystickAxisMoveEventData

| 字段 | 类型 |
|------|------|
| `JoystickID` | VariantWithInt |
| `Button` | VariantWithInt |
| `Position` | VariantWithFloat |
| `GetFloat` | fun(self: JoystickAxisMoveEventData, field: "Position"): number |
| `GetInt` | fun(self: JoystickAxisMoveEventData, field: "JoystickID"): integer |
| `GetInt` | fun(self: JoystickAxisMoveEventData, field: "Button"): integer |

#### JoystickButtonDownEventData

| 字段 | 类型 |
|------|------|
| `JoystickID` | VariantWithInt |
| `Button` | VariantWithInt |
| `GetInt` | fun(self: JoystickButtonDownEventData, field: "JoystickID"): integer |
| `GetInt` | fun(self: JoystickButtonDownEventData, field: "Button"): integer |

#### JoystickButtonUpEventData

| 字段 | 类型 |
|------|------|
| `JoystickID` | VariantWithInt |
| `Button` | VariantWithInt |
| `GetInt` | fun(self: JoystickButtonUpEventData, field: "JoystickID"): integer |
| `GetInt` | fun(self: JoystickButtonUpEventData, field: "Button"): integer |

#### JoystickConnectedEventData

| 字段 | 类型 |
|------|------|
| `JoystickID` | VariantWithInt |
| `GetInt` | fun(self: JoystickConnectedEventData, field: "JoystickID"): integer |

#### JoystickDisconnectedEventData

| 字段 | 类型 |
|------|------|
| `JoystickID` | VariantWithInt |
| `GetInt` | fun(self: JoystickDisconnectedEventData, field: "JoystickID"): integer |

#### JoystickHatMoveEventData

| 字段 | 类型 |
|------|------|
| `JoystickID` | VariantWithInt |
| `Button` | VariantWithInt |
| `Position` | VariantWithInt |
| `GetInt` | fun(self: JoystickHatMoveEventData, field: "JoystickID"): integer |
| `GetInt` | fun(self: JoystickHatMoveEventData, field: "Button"): integer |
| `GetInt` | fun(self: JoystickHatMoveEventData, field: "Position"): integer |

#### KeyDownEventData

| 字段 | 类型 |
|------|------|
| `Key` | VariantWithInt |
| `Scancode` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `Repeat` | VariantWithBool |
| `GetBool` | fun(self: KeyDownEventData, field: "Repeat"): boolean |
| `GetInt` | fun(self: KeyDownEventData, field: "Key"): integer |
| `GetInt` | fun(self: KeyDownEventData, field: "Scancode"): integer |
| `GetInt` | fun(self: KeyDownEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: KeyDownEventData, field: "Qualifiers"): integer |

#### KeyUpEventData

| 字段 | 类型 |
|------|------|
| `Key` | VariantWithInt |
| `Scancode` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: KeyUpEventData, field: "Key"): integer |
| `GetInt` | fun(self: KeyUpEventData, field: "Scancode"): integer |
| `GetInt` | fun(self: KeyUpEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: KeyUpEventData, field: "Qualifiers"): integer |

#### LayoutUpdatedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `GetPtr` | fun(self: LayoutUpdatedEventData, field: "Element"): UIElement |

#### LoadFailedEventData

| 字段 | 类型 |
|------|------|
| `ResourceName` | VariantWithString |
| `GetString` | fun(self: LoadFailedEventData, field: "ResourceName"): string |

#### LogMessageEventData

| 字段 | 类型 |
|------|------|
| `Message` | VariantWithString |
| `Level` | VariantWithInt |
| `CustomLog` | VariantWithString |
| `GetInt` | fun(self: LogMessageEventData, field: "Level"): integer |
| `GetString` | fun(self: LogMessageEventData, field: "Message"): string |
| `GetString` | fun(self: LogMessageEventData, field: "CustomLog"): string |

#### MenuSelectedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `GetPtr` | fun(self: MenuSelectedEventData, field: "Element"): UIElement |

#### MessageACKEventData

| 字段 | 类型 |
|------|------|
| `OK` | VariantWithBool |
| `GetBool` | fun(self: MessageACKEventData, field: "OK"): boolean |

#### ModalChangedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `Modal` | VariantWithBool |
| `GetBool` | fun(self: ModalChangedEventData, field: "Modal"): boolean |
| `GetPtr` | fun(self: ModalChangedEventData, field: "Element"): UIElement |

#### MouseButtonDownEventData

| 字段 | 类型 |
|------|------|
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `Button` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: MouseButtonDownEventData, field: "X"): integer |
| `GetInt` | fun(self: MouseButtonDownEventData, field: "Y"): integer |
| `GetInt` | fun(self: MouseButtonDownEventData, field: "Button"): integer |
| `GetInt` | fun(self: MouseButtonDownEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: MouseButtonDownEventData, field: "Qualifiers"): integer |

#### MouseButtonUpEventData

| 字段 | 类型 |
|------|------|
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `Button` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: MouseButtonUpEventData, field: "X"): integer |
| `GetInt` | fun(self: MouseButtonUpEventData, field: "Y"): integer |
| `GetInt` | fun(self: MouseButtonUpEventData, field: "Button"): integer |
| `GetInt` | fun(self: MouseButtonUpEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: MouseButtonUpEventData, field: "Qualifiers"): integer |

#### MouseModeChangedEventData

| 字段 | 类型 |
|------|------|
| `Mode` | VariantWithInt |
| `MouseLocked` | VariantWithBool |
| `GetBool` | fun(self: MouseModeChangedEventData, field: "MouseLocked"): boolean |
| `GetInt` | fun(self: MouseModeChangedEventData, field: "Mode"): integer |

#### MouseMoveEventData

| 字段 | 类型 |
|------|------|
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `DX` | VariantWithInt |
| `DY` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: MouseMoveEventData, field: "X"): integer |
| `GetInt` | fun(self: MouseMoveEventData, field: "Y"): integer |
| `GetInt` | fun(self: MouseMoveEventData, field: "DX"): integer |
| `GetInt` | fun(self: MouseMoveEventData, field: "DY"): integer |
| `GetInt` | fun(self: MouseMoveEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: MouseMoveEventData, field: "Qualifiers"): integer |

#### MouseVisibleChangedEventData

| 字段 | 类型 |
|------|------|
| `Visible` | VariantWithBool |
| `GetBool` | fun(self: MouseVisibleChangedEventData, field: "Visible"): boolean |

#### MouseWheelEventData

| 字段 | 类型 |
|------|------|
| `Wheel` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: MouseWheelEventData, field: "Wheel"): integer |
| `GetInt` | fun(self: MouseWheelEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: MouseWheelEventData, field: "Qualifiers"): integer |

#### MultiGestureEventData

| 字段 | 类型 |
|------|------|
| `CenterX` | VariantWithInt |
| `CenterY` | VariantWithInt |
| `NumFingers` | VariantWithInt |
| `DTheta` | VariantWithFloat |
| `DDist` | VariantWithFloat |
| `GetFloat` | fun(self: MultiGestureEventData, field: "DTheta"): number |
| `GetFloat` | fun(self: MultiGestureEventData, field: "DDist"): number |
| `GetInt` | fun(self: MultiGestureEventData, field: "CenterX"): integer |
| `GetInt` | fun(self: MultiGestureEventData, field: "CenterY"): integer |
| `GetInt` | fun(self: MultiGestureEventData, field: "NumFingers"): integer |

#### NameChangedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `GetPtr` | fun(self: NameChangedEventData, field: "Element"): UIElement |

#### NavigationAllTilesRemovedEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `Mesh` | VariantWithPtr |
| `GetPtr` | fun(self: NavigationAllTilesRemovedEventData, field: "Node"): Node |
| `GetPtr` | fun(self: NavigationAllTilesRemovedEventData, field: "Mesh"): NavigationMesh |

#### NavigationAreaRebuiltEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `Mesh` | VariantWithPtr |
| `BoundsMin` | VariantWithVector3 |
| `BoundsMax` | VariantWithVector3 |
| `GetPtr` | fun(self: NavigationAreaRebuiltEventData, field: "Node"): Node |
| `GetPtr` | fun(self: NavigationAreaRebuiltEventData, field: "Mesh"): NavigationMesh |
| `GetVector3` | fun(self: NavigationAreaRebuiltEventData, field: "BoundsMin"): Vector3 |
| `GetVector3` | fun(self: NavigationAreaRebuiltEventData, field: "BoundsMax"): Vector3 |

#### NavigationMeshRebuiltEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `Mesh` | VariantWithPtr |
| `GetPtr` | fun(self: NavigationMeshRebuiltEventData, field: "Node"): Node |
| `GetPtr` | fun(self: NavigationMeshRebuiltEventData, field: "Mesh"): NavigationMesh |

#### NavigationObstacleAddedEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `Obstacle` | VariantWithPtr |
| `Position` | VariantWithVector3 |
| `Radius` | VariantWithFloat |
| `Height` | VariantWithFloat |
| `GetFloat` | fun(self: NavigationObstacleAddedEventData, field: "Radius"): number |
| `GetFloat` | fun(self: NavigationObstacleAddedEventData, field: "Height"): number |
| `GetPtr` | fun(self: NavigationObstacleAddedEventData, field: "Node"): Node |
| `GetPtr` | fun(self: NavigationObstacleAddedEventData, field: "Obstacle"): Obstacle |
| `GetVector3` | fun(self: NavigationObstacleAddedEventData, field: "Position"): Vector3 |

#### NavigationObstacleRemovedEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `Obstacle` | VariantWithPtr |
| `Position` | VariantWithVector3 |
| `Radius` | VariantWithFloat |
| `Height` | VariantWithFloat |
| `GetFloat` | fun(self: NavigationObstacleRemovedEventData, field: "Radius"): number |
| `GetFloat` | fun(self: NavigationObstacleRemovedEventData, field: "Height"): number |
| `GetPtr` | fun(self: NavigationObstacleRemovedEventData, field: "Node"): Node |
| `GetPtr` | fun(self: NavigationObstacleRemovedEventData, field: "Obstacle"): Obstacle |
| `GetVector3` | fun(self: NavigationObstacleRemovedEventData, field: "Position"): Vector3 |

#### NavigationTileAddedEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `Mesh` | VariantWithPtr |
| `Tile` | VariantWithIntVector2 |
| `GetIntVector2` | fun(self: NavigationTileAddedEventData, field: "Tile"): IntVector2 |
| `GetPtr` | fun(self: NavigationTileAddedEventData, field: "Node"): Node |
| `GetPtr` | fun(self: NavigationTileAddedEventData, field: "Mesh"): NavigationMesh |

#### NavigationTileRemovedEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `Mesh` | VariantWithPtr |
| `Tile` | VariantWithIntVector2 |
| `GetIntVector2` | fun(self: NavigationTileRemovedEventData, field: "Tile"): IntVector2 |
| `GetPtr` | fun(self: NavigationTileRemovedEventData, field: "Node"): Node |
| `GetPtr` | fun(self: NavigationTileRemovedEventData, field: "Mesh"): NavigationMesh |

#### NetworkHostDiscoveredEventData

| 字段 | 类型 |
|------|------|
| `Address` | VariantWithString |
| `Port` | VariantWithInt |
| `Beacon` | VariantWithVariantMap |
| `GetInt` | fun(self: NetworkHostDiscoveredEventData, field: "Port"): integer |
| `GetString` | fun(self: NetworkHostDiscoveredEventData, field: "Address"): string |
| `GetVariantMap` | fun(self: NetworkHostDiscoveredEventData, field: "Beacon"): VariantMap|nil |

#### NetworkMessageEventData

| 字段 | 类型 |
|------|------|
| `Connection` | VariantWithPtr |
| `MessageID` | VariantWithInt |
| `Data` | VariantWithBuffer |
| `GetBuffer` | fun(self: NetworkMessageEventData, field: "Data"): VectorBuffer |
| `GetInt` | fun(self: NetworkMessageEventData, field: "MessageID"): integer |
| `GetPtr` | fun(self: NetworkMessageEventData, field: "Connection"): Connection |

#### NetworkNatMasterConnectionFailedEventData

| 字段 | 类型 |
|------|------|
| `Address` | VariantWithString |
| `Port` | VariantWithInt |
| `GetInt` | fun(self: NetworkNatMasterConnectionFailedEventData, field: "Port"): integer |
| `GetString` | fun(self: NetworkNatMasterConnectionFailedEventData, field: "Address"): string |

#### NetworkNatMasterConnectionSucceededEventData

| 字段 | 类型 |
|------|------|
| `Address` | VariantWithString |
| `Port` | VariantWithInt |
| `GetInt` | fun(self: NetworkNatMasterConnectionSucceededEventData, field: "Port"): integer |
| `GetString` | fun(self: NetworkNatMasterConnectionSucceededEventData, field: "Address"): string |

#### NetworkNatPunchtroughFailedEventData

| 字段 | 类型 |
|------|------|
| `Address` | VariantWithString |
| `Port` | VariantWithInt |
| `GetInt` | fun(self: NetworkNatPunchtroughFailedEventData, field: "Port"): integer |
| `GetString` | fun(self: NetworkNatPunchtroughFailedEventData, field: "Address"): string |

#### NetworkNatPunchtroughSucceededEventData

| 字段 | 类型 |
|------|------|
| `Address` | VariantWithString |
| `Port` | VariantWithInt |
| `GetInt` | fun(self: NetworkNatPunchtroughSucceededEventData, field: "Port"): integer |
| `GetString` | fun(self: NetworkNatPunchtroughSucceededEventData, field: "Address"): string |

#### NetworkSceneLoadFailedEventData

| 字段 | 类型 |
|------|------|
| `Connection` | VariantWithPtr |
| `GetPtr` | fun(self: NetworkSceneLoadFailedEventData, field: "Connection"): Connection |

#### NodeAddedEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `Parent` | VariantWithPtr |
| `Node` | VariantWithPtr |
| `GetPtr` | fun(self: NodeAddedEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: NodeAddedEventData, field: "Parent"): Node |
| `GetPtr` | fun(self: NodeAddedEventData, field: "Node"): Node |

#### NodeBeginContact2DEventData

| 字段 | 类型 |
|------|------|
| `Body` | VariantWithPtr |
| `OtherNode` | VariantWithPtr |
| `OtherBody` | VariantWithPtr |
| `Contacts` | VariantWithBuffer |
| `Shape` | VariantWithPtr |
| `OtherShape` | VariantWithPtr |
| `GetBuffer` | fun(self: NodeBeginContact2DEventData, field: "Contacts"): VectorBuffer |
| `GetPtr` | fun(self: NodeBeginContact2DEventData, field: "Body"): RigidBody2D |
| `GetPtr` | fun(self: NodeBeginContact2DEventData, field: "OtherNode"): Node |
| `GetPtr` | fun(self: NodeBeginContact2DEventData, field: "OtherBody"): RigidBody2D |
| `GetPtr` | fun(self: NodeBeginContact2DEventData, field: "Shape"): CollisionShape2D |
| `GetPtr` | fun(self: NodeBeginContact2DEventData, field: "OtherShape"): CollisionShape2D |

#### NodeClonedEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `Node` | VariantWithPtr |
| `CloneNode` | VariantWithPtr |
| `GetPtr` | fun(self: NodeClonedEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: NodeClonedEventData, field: "Node"): Node |
| `GetPtr` | fun(self: NodeClonedEventData, field: "CloneNode"): Node |

#### NodeCollisionEndEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `Body` | VariantWithPtr |
| `OtherNode` | VariantWithPtr |
| `OtherBody` | VariantWithPtr |
| `Trigger` | VariantWithBool |
| `GetBool` | fun(self: NodeCollisionEndEventData, field: "Trigger"): boolean |
| `GetPtr` | fun(self: NodeCollisionEndEventData, field: "Node"): Node |
| `GetPtr` | fun(self: NodeCollisionEndEventData, field: "Body"): RigidBody |
| `GetPtr` | fun(self: NodeCollisionEndEventData, field: "OtherNode"): Node |
| `GetPtr` | fun(self: NodeCollisionEndEventData, field: "OtherBody"): RigidBody |

#### NodeCollisionEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `Body` | VariantWithPtr |
| `OtherNode` | VariantWithPtr |
| `OtherBody` | VariantWithPtr |
| `Trigger` | VariantWithBool |
| `Contacts` | VariantWithBuffer |
| `GetBool` | fun(self: NodeCollisionEventData, field: "Trigger"): boolean |
| `GetBuffer` | fun(self: NodeCollisionEventData, field: "Contacts"): VectorBuffer |
| `GetPtr` | fun(self: NodeCollisionEventData, field: "Node"): Node |
| `GetPtr` | fun(self: NodeCollisionEventData, field: "Body"): RigidBody |
| `GetPtr` | fun(self: NodeCollisionEventData, field: "OtherNode"): Node |
| `GetPtr` | fun(self: NodeCollisionEventData, field: "OtherBody"): RigidBody |

#### NodeCollisionStartEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `Body` | VariantWithPtr |
| `OtherNode` | VariantWithPtr |
| `OtherBody` | VariantWithPtr |
| `Trigger` | VariantWithBool |
| `Contacts` | VariantWithBuffer |
| `GetBool` | fun(self: NodeCollisionStartEventData, field: "Trigger"): boolean |
| `GetBuffer` | fun(self: NodeCollisionStartEventData, field: "Contacts"): VectorBuffer |
| `GetPtr` | fun(self: NodeCollisionStartEventData, field: "Node"): Node |
| `GetPtr` | fun(self: NodeCollisionStartEventData, field: "Body"): RigidBody |
| `GetPtr` | fun(self: NodeCollisionStartEventData, field: "OtherNode"): Node |
| `GetPtr` | fun(self: NodeCollisionStartEventData, field: "OtherBody"): RigidBody |

#### NodeEnabledChangedEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `Node` | VariantWithPtr |
| `GetPtr` | fun(self: NodeEnabledChangedEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: NodeEnabledChangedEventData, field: "Node"): Node |

#### NodeEndContact2DEventData

| 字段 | 类型 |
|------|------|
| `Body` | VariantWithPtr |
| `OtherNode` | VariantWithPtr |
| `OtherBody` | VariantWithPtr |
| `Contacts` | VariantWithBuffer |
| `Shape` | VariantWithPtr |
| `OtherShape` | VariantWithPtr |
| `GetBuffer` | fun(self: NodeEndContact2DEventData, field: "Contacts"): VectorBuffer |
| `GetPtr` | fun(self: NodeEndContact2DEventData, field: "Body"): RigidBody2D |
| `GetPtr` | fun(self: NodeEndContact2DEventData, field: "OtherNode"): Node |
| `GetPtr` | fun(self: NodeEndContact2DEventData, field: "OtherBody"): RigidBody2D |
| `GetPtr` | fun(self: NodeEndContact2DEventData, field: "Shape"): CollisionShape2D |
| `GetPtr` | fun(self: NodeEndContact2DEventData, field: "OtherShape"): CollisionShape2D |

#### NodeNameChangedEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `Node` | VariantWithPtr |
| `GetPtr` | fun(self: NodeNameChangedEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: NodeNameChangedEventData, field: "Node"): Node |

#### NodeRemovedEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `Parent` | VariantWithPtr |
| `Node` | VariantWithPtr |
| `GetPtr` | fun(self: NodeRemovedEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: NodeRemovedEventData, field: "Parent"): Node |
| `GetPtr` | fun(self: NodeRemovedEventData, field: "Node"): Node |

#### NodeTagAddedEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `Node` | VariantWithPtr |
| `Tag` | VariantWithString |
| `GetPtr` | fun(self: NodeTagAddedEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: NodeTagAddedEventData, field: "Node"): Node |
| `GetString` | fun(self: NodeTagAddedEventData, field: "Tag"): string |

#### NodeTagRemovedEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `Node` | VariantWithPtr |
| `Tag` | VariantWithString |
| `GetPtr` | fun(self: NodeTagRemovedEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: NodeTagRemovedEventData, field: "Node"): Node |
| `GetString` | fun(self: NodeTagRemovedEventData, field: "Tag"): string |

#### NodeUpdateContact2DEventData

| 字段 | 类型 |
|------|------|
| `Body` | VariantWithPtr |
| `OtherNode` | VariantWithPtr |
| `OtherBody` | VariantWithPtr |
| `Contacts` | VariantWithBuffer |
| `Shape` | VariantWithPtr |
| `OtherShape` | VariantWithPtr |
| `Enabled` | VariantWithBool |
| `GetBool` | fun(self: NodeUpdateContact2DEventData, field: "Enabled"): boolean |
| `GetBuffer` | fun(self: NodeUpdateContact2DEventData, field: "Contacts"): VectorBuffer |
| `GetPtr` | fun(self: NodeUpdateContact2DEventData, field: "Body"): RigidBody2D |
| `GetPtr` | fun(self: NodeUpdateContact2DEventData, field: "OtherNode"): Node |
| `GetPtr` | fun(self: NodeUpdateContact2DEventData, field: "OtherBody"): RigidBody2D |
| `GetPtr` | fun(self: NodeUpdateContact2DEventData, field: "Shape"): CollisionShape2D |
| `GetPtr` | fun(self: NodeUpdateContact2DEventData, field: "OtherShape"): CollisionShape2D |

#### OrientationChangedEventData

| 字段 | 类型 |
|------|------|
| `Orientation` | VariantWithInt |
| `GetInt` | fun(self: OrientationChangedEventData, field: "Orientation"): integer |

#### ParticleEffectFinishedEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `Effect` | VariantWithPtr |
| `GetPtr` | fun(self: ParticleEffectFinishedEventData, field: "Node"): Node |
| `GetPtr` | fun(self: ParticleEffectFinishedEventData, field: "Effect"): ParticleEffect |

#### ParticlesDurationEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `Effect` | VariantWithPtr |
| `GetPtr` | fun(self: ParticlesDurationEventData, field: "Node"): Node |
| `GetPtr` | fun(self: ParticlesDurationEventData, field: "Effect"): ParticleEffect2D |

#### ParticlesEndEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `Effect` | VariantWithPtr |
| `GetPtr` | fun(self: ParticlesEndEventData, field: "Node"): Node |
| `GetPtr` | fun(self: ParticlesEndEventData, field: "Effect"): ParticleEffect2D |

#### PhysicsBeginContact2DEventData

| 字段 | 类型 |
|------|------|
| `World` | VariantWithPtr |
| `BodyA` | VariantWithPtr |
| `BodyB` | VariantWithPtr |
| `NodeA` | VariantWithPtr |
| `NodeB` | VariantWithPtr |
| `Contacts` | VariantWithBuffer |
| `ShapeA` | VariantWithPtr |
| `ShapeB` | VariantWithPtr |
| `GetBuffer` | fun(self: PhysicsBeginContact2DEventData, field: "Contacts"): VectorBuffer |
| `GetPtr` | fun(self: PhysicsBeginContact2DEventData, field: "World"): PhysicsWorld2D |
| `GetPtr` | fun(self: PhysicsBeginContact2DEventData, field: "BodyA"): RigidBody2D |
| `GetPtr` | fun(self: PhysicsBeginContact2DEventData, field: "BodyB"): RigidBody2D |
| `GetPtr` | fun(self: PhysicsBeginContact2DEventData, field: "NodeA"): Node |
| `GetPtr` | fun(self: PhysicsBeginContact2DEventData, field: "NodeB"): Node |
| `GetPtr` | fun(self: PhysicsBeginContact2DEventData, field: "ShapeA"): CollisionShape2D |
| `GetPtr` | fun(self: PhysicsBeginContact2DEventData, field: "ShapeB"): CollisionShape2D |

#### PhysicsCollisionEndEventData

| 字段 | 类型 |
|------|------|
| `World` | VariantWithPtr |
| `NodeA` | VariantWithPtr |
| `NodeB` | VariantWithPtr |
| `BodyA` | VariantWithPtr |
| `BodyB` | VariantWithPtr |
| `Trigger` | VariantWithBool |
| `GetBool` | fun(self: PhysicsCollisionEndEventData, field: "Trigger"): boolean |
| `GetPtr` | fun(self: PhysicsCollisionEndEventData, field: "World"): PhysicsWorld |
| `GetPtr` | fun(self: PhysicsCollisionEndEventData, field: "NodeA"): Node |
| `GetPtr` | fun(self: PhysicsCollisionEndEventData, field: "NodeB"): Node |
| `GetPtr` | fun(self: PhysicsCollisionEndEventData, field: "BodyA"): RigidBody |
| `GetPtr` | fun(self: PhysicsCollisionEndEventData, field: "BodyB"): RigidBody |

#### PhysicsCollisionEventData

| 字段 | 类型 |
|------|------|
| `World` | VariantWithPtr |
| `NodeA` | VariantWithPtr |
| `NodeB` | VariantWithPtr |
| `BodyA` | VariantWithPtr |
| `BodyB` | VariantWithPtr |
| `Trigger` | VariantWithBool |
| `Contacts` | VariantWithBuffer |
| `GetBool` | fun(self: PhysicsCollisionEventData, field: "Trigger"): boolean |
| `GetBuffer` | fun(self: PhysicsCollisionEventData, field: "Contacts"): VectorBuffer |
| `GetPtr` | fun(self: PhysicsCollisionEventData, field: "World"): PhysicsWorld |
| `GetPtr` | fun(self: PhysicsCollisionEventData, field: "NodeA"): Node |
| `GetPtr` | fun(self: PhysicsCollisionEventData, field: "NodeB"): Node |
| `GetPtr` | fun(self: PhysicsCollisionEventData, field: "BodyA"): RigidBody |
| `GetPtr` | fun(self: PhysicsCollisionEventData, field: "BodyB"): RigidBody |

#### PhysicsCollisionStartEventData

| 字段 | 类型 |
|------|------|
| `World` | VariantWithPtr |
| `NodeA` | VariantWithPtr |
| `NodeB` | VariantWithPtr |
| `BodyA` | VariantWithPtr |
| `BodyB` | VariantWithPtr |
| `Trigger` | VariantWithBool |
| `Contacts` | VariantWithBuffer |
| `GetBool` | fun(self: PhysicsCollisionStartEventData, field: "Trigger"): boolean |
| `GetBuffer` | fun(self: PhysicsCollisionStartEventData, field: "Contacts"): VectorBuffer |
| `GetPtr` | fun(self: PhysicsCollisionStartEventData, field: "World"): PhysicsWorld |
| `GetPtr` | fun(self: PhysicsCollisionStartEventData, field: "NodeA"): Node |
| `GetPtr` | fun(self: PhysicsCollisionStartEventData, field: "NodeB"): Node |
| `GetPtr` | fun(self: PhysicsCollisionStartEventData, field: "BodyA"): RigidBody |
| `GetPtr` | fun(self: PhysicsCollisionStartEventData, field: "BodyB"): RigidBody |

#### PhysicsEndContact2DEventData

| 字段 | 类型 |
|------|------|
| `World` | VariantWithPtr |
| `BodyA` | VariantWithPtr |
| `BodyB` | VariantWithPtr |
| `NodeA` | VariantWithPtr |
| `NodeB` | VariantWithPtr |
| `Contacts` | VariantWithBuffer |
| `ShapeA` | VariantWithPtr |
| `ShapeB` | VariantWithPtr |
| `GetBuffer` | fun(self: PhysicsEndContact2DEventData, field: "Contacts"): VectorBuffer |
| `GetPtr` | fun(self: PhysicsEndContact2DEventData, field: "World"): PhysicsWorld2D |
| `GetPtr` | fun(self: PhysicsEndContact2DEventData, field: "BodyA"): RigidBody2D |
| `GetPtr` | fun(self: PhysicsEndContact2DEventData, field: "BodyB"): RigidBody2D |
| `GetPtr` | fun(self: PhysicsEndContact2DEventData, field: "NodeA"): Node |
| `GetPtr` | fun(self: PhysicsEndContact2DEventData, field: "NodeB"): Node |
| `GetPtr` | fun(self: PhysicsEndContact2DEventData, field: "ShapeA"): CollisionShape2D |
| `GetPtr` | fun(self: PhysicsEndContact2DEventData, field: "ShapeB"): CollisionShape2D |

#### PhysicsMotionStatesEventData

| 字段 | 类型 |
|------|------|
| `World` | VariantWithPtr |
| `TimeStep` | VariantWithFloat |
| `FrameNumber` | VariantWithInt |
| `GetFloat` | fun(self: PhysicsMotionStatesEventData, field: "TimeStep"): number |
| `GetInt` | fun(self: PhysicsMotionStatesEventData, field: "FrameNumber"): integer |
| `GetPtr` | fun(self: PhysicsMotionStatesEventData, field: "World"): PhysicsWorld |

#### PhysicsPostStepEventData

| 字段 | 类型 |
|------|------|
| `World` | VariantWithPtr |
| `TimeStep` | VariantWithFloat |
| `FrameNumber` | VariantWithInt |
| `GetFloat` | fun(self: PhysicsPostStepEventData, field: "TimeStep"): number |
| `GetInt` | fun(self: PhysicsPostStepEventData, field: "FrameNumber"): integer |
| `GetPtr` | fun(self: PhysicsPostStepEventData, field: "World"): PhysicsWorld |

#### PhysicsPreStepEventData

| 字段 | 类型 |
|------|------|
| `World` | VariantWithPtr |
| `TimeStep` | VariantWithFloat |
| `FrameNumber` | VariantWithInt |
| `GetFloat` | fun(self: PhysicsPreStepEventData, field: "TimeStep"): number |
| `GetInt` | fun(self: PhysicsPreStepEventData, field: "FrameNumber"): integer |
| `GetPtr` | fun(self: PhysicsPreStepEventData, field: "World"): PhysicsWorld |

#### PhysicsUpdateContact2DEventData

| 字段 | 类型 |
|------|------|
| `World` | VariantWithPtr |
| `BodyA` | VariantWithPtr |
| `BodyB` | VariantWithPtr |
| `NodeA` | VariantWithPtr |
| `NodeB` | VariantWithPtr |
| `Contacts` | VariantWithBuffer |
| `ShapeA` | VariantWithPtr |
| `ShapeB` | VariantWithPtr |
| `Enabled` | VariantWithBool |
| `GetBool` | fun(self: PhysicsUpdateContact2DEventData, field: "Enabled"): boolean |
| `GetBuffer` | fun(self: PhysicsUpdateContact2DEventData, field: "Contacts"): VectorBuffer |
| `GetPtr` | fun(self: PhysicsUpdateContact2DEventData, field: "World"): PhysicsWorld2D |
| `GetPtr` | fun(self: PhysicsUpdateContact2DEventData, field: "BodyA"): RigidBody2D |
| `GetPtr` | fun(self: PhysicsUpdateContact2DEventData, field: "BodyB"): RigidBody2D |
| `GetPtr` | fun(self: PhysicsUpdateContact2DEventData, field: "NodeA"): Node |
| `GetPtr` | fun(self: PhysicsUpdateContact2DEventData, field: "NodeB"): Node |
| `GetPtr` | fun(self: PhysicsUpdateContact2DEventData, field: "ShapeA"): CollisionShape2D |
| `GetPtr` | fun(self: PhysicsUpdateContact2DEventData, field: "ShapeB"): CollisionShape2D |

#### PlayerSessionDisconnectedEventData

| 字段 | 类型 |
|------|------|
| `Connection` | VariantWithPtr |
| `UserId` | VariantWithInt64 |
| `ReconnectTimeout` | VariantWithFloat |
| `GetFloat` | fun(self: PlayerSessionDisconnectedEventData, field: "ReconnectTimeout"): number |
| `GetInt64` | fun(self: PlayerSessionDisconnectedEventData, field: "UserId"): integer |
| `GetPtr` | fun(self: PlayerSessionDisconnectedEventData, field: "Connection"): Connection |

#### PlayerSessionJoinedEventData

| 字段 | 类型 |
|------|------|
| `Connection` | VariantWithPtr |
| `UserId` | VariantWithInt64 |
| `GetInt64` | fun(self: PlayerSessionJoinedEventData, field: "UserId"): integer |
| `GetPtr` | fun(self: PlayerSessionJoinedEventData, field: "Connection"): Connection |

#### PlayerSessionLeftEventData

| 字段 | 类型 |
|------|------|
| `UserId` | VariantWithInt64 |
| `Reason` | VariantWithString |
| `GetInt64` | fun(self: PlayerSessionLeftEventData, field: "UserId"): integer |
| `GetString` | fun(self: PlayerSessionLeftEventData, field: "Reason"): string |

#### PlayerSessionReconnectedEventData

| 字段 | 类型 |
|------|------|
| `Connection` | VariantWithPtr |
| `UserId` | VariantWithInt64 |
| `GetInt64` | fun(self: PlayerSessionReconnectedEventData, field: "UserId"): integer |
| `GetPtr` | fun(self: PlayerSessionReconnectedEventData, field: "Connection"): Connection |

#### PositionedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `GetInt` | fun(self: PositionedEventData, field: "X"): integer |
| `GetInt` | fun(self: PositionedEventData, field: "Y"): integer |
| `GetPtr` | fun(self: PositionedEventData, field: "Element"): UIElement |

#### PostRenderUpdateEventData

| 字段 | 类型 |
|------|------|
| `TimeStep` | VariantWithFloat |
| `GetFloat` | fun(self: PostRenderUpdateEventData, field: "TimeStep"): number |

#### PostUpdateEventData

| 字段 | 类型 |
|------|------|
| `TimeStep` | VariantWithFloat |
| `GetFloat` | fun(self: PostUpdateEventData, field: "TimeStep"): number |

#### PressedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `GetPtr` | fun(self: PressedEventData, field: "Element"): UIElement |

#### ProgressBarChangedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `Value` | VariantWithFloat |
| `GetFloat` | fun(self: ProgressBarChangedEventData, field: "Value"): number |
| `GetPtr` | fun(self: ProgressBarChangedEventData, field: "Element"): UIElement |

#### ReleasedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `GetPtr` | fun(self: ReleasedEventData, field: "Element"): UIElement |

#### RemoteEventDataEventData

| 字段 | 类型 |
|------|------|
| `Connection` | VariantWithPtr |
| `GetPtr` | fun(self: RemoteEventDataEventData, field: "Connection"): Connection |

#### RenderPathEventEventData

| 字段 | 类型 |
|------|------|
| `Name` | VariantWithString |
| `Scene` | VariantWithPtr |
| `RenderTarget` | VariantWithPtr |
| `GetPtr` | fun(self: RenderPathEventEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: RenderPathEventEventData, field: "RenderTarget"): Texture2D |
| `GetString` | fun(self: RenderPathEventEventData, field: "Name"): string |

#### RenderUpdateEventData

| 字段 | 类型 |
|------|------|
| `TimeStep` | VariantWithFloat |
| `GetFloat` | fun(self: RenderUpdateEventData, field: "TimeStep"): number |

#### ResizedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `Width` | VariantWithInt |
| `Height` | VariantWithInt |
| `DX` | VariantWithInt |
| `DY` | VariantWithInt |
| `GetInt` | fun(self: ResizedEventData, field: "Width"): integer |
| `GetInt` | fun(self: ResizedEventData, field: "Height"): integer |
| `GetInt` | fun(self: ResizedEventData, field: "DX"): integer |
| `GetInt` | fun(self: ResizedEventData, field: "DY"): integer |
| `GetPtr` | fun(self: ResizedEventData, field: "Element"): UIElement |

#### ResourceBackgroundLoadedEventData

| 字段 | 类型 |
|------|------|
| `ResourceName` | VariantWithString |
| `Success` | VariantWithBool |
| `Resource` | VariantWithPtr |
| `GetBool` | fun(self: ResourceBackgroundLoadedEventData, field: "Success"): boolean |
| `GetPtr` | fun(self: ResourceBackgroundLoadedEventData, field: "Resource"): Resource |
| `GetString` | fun(self: ResourceBackgroundLoadedEventData, field: "ResourceName"): string |

#### ResourceNotFoundEventData

| 字段 | 类型 |
|------|------|
| `ResourceName` | VariantWithString |
| `GetString` | fun(self: ResourceNotFoundEventData, field: "ResourceName"): string |

#### RuntimeDebuggerSelectionChangedEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `Component` | VariantWithPtr |
| `GetPtr` | fun(self: RuntimeDebuggerSelectionChangedEventData, field: "Node"): Node |
| `GetPtr` | fun(self: RuntimeDebuggerSelectionChangedEventData, field: "Component"): Component |

#### SDLRawInputEventData

| 字段 | 类型 |
|------|------|
| `SDLEvent` | VariantWithPtr |
| `Consumed` | VariantWithBool |
| `GetBool` | fun(self: SDLRawInputEventData, field: "Consumed"): boolean |
| `GetPtr` | fun(self: SDLRawInputEventData, field: "SDLEvent"): SDL_Event |

#### SceneDrawableUpdateFinishedEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `TimeStep` | VariantWithFloat |
| `GetFloat` | fun(self: SceneDrawableUpdateFinishedEventData, field: "TimeStep"): number |
| `GetPtr` | fun(self: SceneDrawableUpdateFinishedEventData, field: "Scene"): Scene |

#### SceneLoadFinishedEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `GetPtr` | fun(self: SceneLoadFinishedEventData, field: "Scene"): Scene |

#### ScenePostUpdateEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `TimeStep` | VariantWithFloat |
| `GetFloat` | fun(self: ScenePostUpdateEventData, field: "TimeStep"): number |
| `GetPtr` | fun(self: ScenePostUpdateEventData, field: "Scene"): Scene |

#### SceneSubsystemUpdateEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `TimeStep` | VariantWithFloat |
| `GetFloat` | fun(self: SceneSubsystemUpdateEventData, field: "TimeStep"): number |
| `GetPtr` | fun(self: SceneSubsystemUpdateEventData, field: "Scene"): Scene |

#### SceneUpdateEventData

| 字段 | 类型 |
|------|------|
| `Scene` | VariantWithPtr |
| `TimeStep` | VariantWithFloat |
| `GetFloat` | fun(self: SceneUpdateEventData, field: "TimeStep"): number |
| `GetPtr` | fun(self: SceneUpdateEventData, field: "Scene"): Scene |

#### ScreenModeEventData

| 字段 | 类型 |
|------|------|
| `Width` | VariantWithInt |
| `Height` | VariantWithInt |
| `Fullscreen` | VariantWithBool |
| `Borderless` | VariantWithBool |
| `Resizable` | VariantWithBool |
| `HighDPI` | VariantWithBool |
| `Monitor` | VariantWithInt |
| `RefreshRate` | VariantWithInt |
| `GetBool` | fun(self: ScreenModeEventData, field: "Fullscreen"): boolean |
| `GetBool` | fun(self: ScreenModeEventData, field: "Borderless"): boolean |
| `GetBool` | fun(self: ScreenModeEventData, field: "Resizable"): boolean |
| `GetBool` | fun(self: ScreenModeEventData, field: "HighDPI"): boolean |
| `GetInt` | fun(self: ScreenModeEventData, field: "Width"): integer |
| `GetInt` | fun(self: ScreenModeEventData, field: "Height"): integer |
| `GetInt` | fun(self: ScreenModeEventData, field: "Monitor"): integer |
| `GetInt` | fun(self: ScreenModeEventData, field: "RefreshRate"): integer |

#### ScrollBarChangedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `Value` | VariantWithFloat |
| `GetFloat` | fun(self: ScrollBarChangedEventData, field: "Value"): number |
| `GetPtr` | fun(self: ScrollBarChangedEventData, field: "Element"): UIElement |

#### SelectionChangedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `GetPtr` | fun(self: SelectionChangedEventData, field: "Element"): UIElement |

#### ShaderCompileEventData

| 字段 | 类型 |
|------|------|
| `Name` | VariantWithString |
| `ShortName` | VariantWithString |
| `Status` | VariantWithInt |
| `GetInt` | fun(self: ShaderCompileEventData, field: "Status"): integer |
| `GetString` | fun(self: ShaderCompileEventData, field: "Name"): string |
| `GetString` | fun(self: ShaderCompileEventData, field: "ShortName"): string |

#### ShaderUncompressEventData

| 字段 | 类型 |
|------|------|
| `Name` | VariantWithString |
| `GetString` | fun(self: ShaderUncompressEventData, field: "Name"): string |

#### SliderChangedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `Value` | VariantWithFloat |
| `GetFloat` | fun(self: SliderChangedEventData, field: "Value"): number |
| `GetPtr` | fun(self: SliderChangedEventData, field: "Element"): UIElement |

#### SliderPagedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `Offset` | VariantWithInt |
| `Pressed` | VariantWithBool |
| `GetBool` | fun(self: SliderPagedEventData, field: "Pressed"): boolean |
| `GetInt` | fun(self: SliderPagedEventData, field: "Offset"): integer |
| `GetPtr` | fun(self: SliderPagedEventData, field: "Element"): UIElement |

#### SoundFinishedEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `SoundSource` | VariantWithPtr |
| `Sound` | VariantWithPtr |
| `GetPtr` | fun(self: SoundFinishedEventData, field: "Node"): Node |
| `GetPtr` | fun(self: SoundFinishedEventData, field: "SoundSource"): SoundSource |
| `GetPtr` | fun(self: SoundFinishedEventData, field: "Sound"): Sound |

#### TemporaryChangedEventData

| 字段 | 类型 |
|------|------|
| `Serializable` | VariantWithPtr |
| `GetPtr` | fun(self: TemporaryChangedEventData, field: "Serializable"): Serializable |

#### TerrainCreatedEventData

| 字段 | 类型 |
|------|------|
| `Node` | VariantWithPtr |
| `GetPtr` | fun(self: TerrainCreatedEventData, field: "Node"): Node |

#### TextChangedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `Text` | VariantWithString |
| `GetPtr` | fun(self: TextChangedEventData, field: "Element"): UIElement |
| `GetString` | fun(self: TextChangedEventData, field: "Text"): string |

#### TextEditingEventData

| 字段 | 类型 |
|------|------|
| `Composition` | VariantWithString |
| `Cursor` | VariantWithInt |
| `SelectionLength` | VariantWithInt |
| `GetInt` | fun(self: TextEditingEventData, field: "Cursor"): integer |
| `GetInt` | fun(self: TextEditingEventData, field: "SelectionLength"): integer |
| `GetString` | fun(self: TextEditingEventData, field: "Composition"): string |

#### TextEntryEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `Text` | VariantWithString |
| `GetPtr` | fun(self: TextEntryEventData, field: "Element"): UIElement |
| `GetString` | fun(self: TextEntryEventData, field: "Text"): string |

#### TextFinishedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `Text` | VariantWithString |
| `Value` | VariantWithFloat |
| `GetFloat` | fun(self: TextFinishedEventData, field: "Value"): number |
| `GetPtr` | fun(self: TextFinishedEventData, field: "Element"): UIElement |
| `GetString` | fun(self: TextFinishedEventData, field: "Text"): string |

#### TextInputEventData

| 字段 | 类型 |
|------|------|
| `Text` | VariantWithString |
| `GetString` | fun(self: TextInputEventData, field: "Text"): string |

#### ToggledEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `State` | VariantWithBool |
| `GetBool` | fun(self: ToggledEventData, field: "State"): boolean |
| `GetPtr` | fun(self: ToggledEventData, field: "Element"): UIElement |

#### TouchBeginEventData

| 字段 | 类型 |
|------|------|
| `TouchID` | VariantWithInt |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `Pressure` | VariantWithFloat |
| `GetFloat` | fun(self: TouchBeginEventData, field: "Pressure"): number |
| `GetInt` | fun(self: TouchBeginEventData, field: "TouchID"): integer |
| `GetInt` | fun(self: TouchBeginEventData, field: "X"): integer |
| `GetInt` | fun(self: TouchBeginEventData, field: "Y"): integer |

#### TouchEndEventData

| 字段 | 类型 |
|------|------|
| `TouchID` | VariantWithInt |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `GetInt` | fun(self: TouchEndEventData, field: "TouchID"): integer |
| `GetInt` | fun(self: TouchEndEventData, field: "X"): integer |
| `GetInt` | fun(self: TouchEndEventData, field: "Y"): integer |

#### TouchEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `GetInt` | fun(self: TouchEventData, field: "X"): integer |
| `GetInt` | fun(self: TouchEventData, field: "Y"): integer |
| `GetPtr` | fun(self: TouchEventData, field: "Element"): UIElement |

#### TouchMoveEventData

| 字段 | 类型 |
|------|------|
| `TouchID` | VariantWithInt |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `DX` | VariantWithInt |
| `DY` | VariantWithInt |
| `Pressure` | VariantWithFloat |
| `GetFloat` | fun(self: TouchMoveEventData, field: "Pressure"): number |
| `GetInt` | fun(self: TouchMoveEventData, field: "TouchID"): integer |
| `GetInt` | fun(self: TouchMoveEventData, field: "X"): integer |
| `GetInt` | fun(self: TouchMoveEventData, field: "Y"): integer |
| `GetInt` | fun(self: TouchMoveEventData, field: "DX"): integer |
| `GetInt` | fun(self: TouchMoveEventData, field: "DY"): integer |

#### TransportConnectFailedEventData

| 字段 | 类型 |
|------|------|
| `Address` | VariantWithString |
| `Port` | VariantWithInt |
| `Protocol` | VariantWithString |
| `Error` | VariantWithString |
| `GetInt` | fun(self: TransportConnectFailedEventData, field: "Port"): integer |
| `GetString` | fun(self: TransportConnectFailedEventData, field: "Address"): string |
| `GetString` | fun(self: TransportConnectFailedEventData, field: "Protocol"): string |
| `GetString` | fun(self: TransportConnectFailedEventData, field: "Error"): string |

#### TransportConnectedEventData

| 字段 | 类型 |
|------|------|
| `Address` | VariantWithString |
| `Port` | VariantWithInt |
| `Protocol` | VariantWithString |
| `GetInt` | fun(self: TransportConnectedEventData, field: "Port"): integer |
| `GetString` | fun(self: TransportConnectedEventData, field: "Address"): string |
| `GetString` | fun(self: TransportConnectedEventData, field: "Protocol"): string |

#### TransportDataEventData

| 字段 | 类型 |
|------|------|
| `Address` | VariantWithString |
| `Port` | VariantWithInt |
| `Protocol` | VariantWithString |
| `Data` | VariantWithBuffer |
| `GetBuffer` | fun(self: TransportDataEventData, field: "Data"): VectorBuffer |
| `GetInt` | fun(self: TransportDataEventData, field: "Port"): integer |
| `GetString` | fun(self: TransportDataEventData, field: "Address"): string |
| `GetString` | fun(self: TransportDataEventData, field: "Protocol"): string |

#### TransportDisconnectedEventData

| 字段 | 类型 |
|------|------|
| `Address` | VariantWithString |
| `Port` | VariantWithInt |
| `Protocol` | VariantWithString |
| `Reason` | VariantWithString |
| `GetInt` | fun(self: TransportDisconnectedEventData, field: "Port"): integer |
| `GetString` | fun(self: TransportDisconnectedEventData, field: "Address"): string |
| `GetString` | fun(self: TransportDisconnectedEventData, field: "Protocol"): string |
| `GetString` | fun(self: TransportDisconnectedEventData, field: "Reason"): string |

#### UIDropFileEventData

| 字段 | 类型 |
|------|------|
| `FileName` | VariantWithString |
| `Element` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `ElementX` | VariantWithInt |
| `ElementY` | VariantWithInt |
| `GetInt` | fun(self: UIDropFileEventData, field: "X"): integer |
| `GetInt` | fun(self: UIDropFileEventData, field: "Y"): integer |
| `GetInt` | fun(self: UIDropFileEventData, field: "ElementX"): integer |
| `GetInt` | fun(self: UIDropFileEventData, field: "ElementY"): integer |
| `GetPtr` | fun(self: UIDropFileEventData, field: "Element"): UIElement |
| `GetString` | fun(self: UIDropFileEventData, field: "FileName"): string |

#### UIMouseClickEndEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `BeginElement` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `Button` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: UIMouseClickEndEventData, field: "X"): integer |
| `GetInt` | fun(self: UIMouseClickEndEventData, field: "Y"): integer |
| `GetInt` | fun(self: UIMouseClickEndEventData, field: "Button"): integer |
| `GetInt` | fun(self: UIMouseClickEndEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: UIMouseClickEndEventData, field: "Qualifiers"): integer |
| `GetPtr` | fun(self: UIMouseClickEndEventData, field: "Element"): UIElement |
| `GetPtr` | fun(self: UIMouseClickEndEventData, field: "BeginElement"): UIElement |

#### UIMouseClickEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `Button` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: UIMouseClickEventData, field: "X"): integer |
| `GetInt` | fun(self: UIMouseClickEventData, field: "Y"): integer |
| `GetInt` | fun(self: UIMouseClickEventData, field: "Button"): integer |
| `GetInt` | fun(self: UIMouseClickEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: UIMouseClickEventData, field: "Qualifiers"): integer |
| `GetPtr` | fun(self: UIMouseClickEventData, field: "Element"): UIElement |

#### UIMouseClickReplayEventData

| 字段 | 类型 |
|------|------|
| `Control` | VariantWithString |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `Button` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: UIMouseClickReplayEventData, field: "X"): integer |
| `GetInt` | fun(self: UIMouseClickReplayEventData, field: "Y"): integer |
| `GetInt` | fun(self: UIMouseClickReplayEventData, field: "Button"): integer |
| `GetInt` | fun(self: UIMouseClickReplayEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: UIMouseClickReplayEventData, field: "Qualifiers"): integer |
| `GetString` | fun(self: UIMouseClickReplayEventData, field: "Control"): string |

#### UIMouseClickReplayPlayEventData

| 字段 | 类型 |
|------|------|
| `Control` | VariantWithString |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `Button` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: UIMouseClickReplayPlayEventData, field: "X"): integer |
| `GetInt` | fun(self: UIMouseClickReplayPlayEventData, field: "Y"): integer |
| `GetInt` | fun(self: UIMouseClickReplayPlayEventData, field: "Button"): integer |
| `GetInt` | fun(self: UIMouseClickReplayPlayEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: UIMouseClickReplayPlayEventData, field: "Qualifiers"): integer |
| `GetString` | fun(self: UIMouseClickReplayPlayEventData, field: "Control"): string |

#### UIMouseClickedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `BeginElement` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `Button` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: UIMouseClickedEventData, field: "X"): integer |
| `GetInt` | fun(self: UIMouseClickedEventData, field: "Y"): integer |
| `GetInt` | fun(self: UIMouseClickedEventData, field: "Button"): integer |
| `GetInt` | fun(self: UIMouseClickedEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: UIMouseClickedEventData, field: "Qualifiers"): integer |
| `GetPtr` | fun(self: UIMouseClickedEventData, field: "Element"): UIElement |
| `GetPtr` | fun(self: UIMouseClickedEventData, field: "BeginElement"): UIElement |

#### UIMouseDoubleClickEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `XBegin` | VariantWithInt |
| `YBegin` | VariantWithInt |
| `Button` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: UIMouseDoubleClickEventData, field: "X"): integer |
| `GetInt` | fun(self: UIMouseDoubleClickEventData, field: "Y"): integer |
| `GetInt` | fun(self: UIMouseDoubleClickEventData, field: "XBegin"): integer |
| `GetInt` | fun(self: UIMouseDoubleClickEventData, field: "YBegin"): integer |
| `GetInt` | fun(self: UIMouseDoubleClickEventData, field: "Button"): integer |
| `GetInt` | fun(self: UIMouseDoubleClickEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: UIMouseDoubleClickEventData, field: "Qualifiers"): integer |
| `GetPtr` | fun(self: UIMouseDoubleClickEventData, field: "Element"): UIElement |

#### UIMouseEnterEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `GetPtr` | fun(self: UIMouseEnterEventData, field: "Element"): UIElement |

#### UIMouseLeaveEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `GetPtr` | fun(self: UIMouseLeaveEventData, field: "Element"): UIElement |

#### UIMouseRealClickEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `Button` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: UIMouseRealClickEventData, field: "X"): integer |
| `GetInt` | fun(self: UIMouseRealClickEventData, field: "Y"): integer |
| `GetInt` | fun(self: UIMouseRealClickEventData, field: "Button"): integer |
| `GetInt` | fun(self: UIMouseRealClickEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: UIMouseRealClickEventData, field: "Qualifiers"): integer |
| `GetPtr` | fun(self: UIMouseRealClickEventData, field: "Element"): UIElement |

#### UnhandledKeyEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `Key` | VariantWithInt |
| `Buttons` | VariantWithInt |
| `Qualifiers` | VariantWithInt |
| `GetInt` | fun(self: UnhandledKeyEventData, field: "Key"): integer |
| `GetInt` | fun(self: UnhandledKeyEventData, field: "Buttons"): integer |
| `GetInt` | fun(self: UnhandledKeyEventData, field: "Qualifiers"): integer |
| `GetPtr` | fun(self: UnhandledKeyEventData, field: "Element"): UIElement |

#### UnknownResourceTypeEventData

| 字段 | 类型 |
|------|------|
| `ResourceType` | VariantWithStringHash |
| `GetStringHash` | fun(self: UnknownResourceTypeEventData, field: "ResourceType"): StringHash |

#### UpdateEventData

| 字段 | 类型 |
|------|------|
| `TimeStep` | VariantWithFloat |
| `GetFloat` | fun(self: UpdateEventData, field: "TimeStep"): number |

#### UpdateSmoothingEventData

| 字段 | 类型 |
|------|------|
| `Constant` | VariantWithFloat |
| `SquaredSnapThreshold` | VariantWithFloat |
| `GetFloat` | fun(self: UpdateSmoothingEventData, field: "Constant"): number |
| `GetFloat` | fun(self: UpdateSmoothingEventData, field: "SquaredSnapThreshold"): number |

#### UserStatEventData

| 字段 | 类型 |
|------|------|
| `Type` | VariantWithString |
| `Arg` | VariantWithString |
| `GetString` | fun(self: UserStatEventData, field: "Type"): string |
| `GetString` | fun(self: UserStatEventData, field: "Arg"): string |

#### ViewBuffersReadyEventData

| 字段 | 类型 |
|------|------|
| `View` | VariantWithPtr |
| `Texture` | VariantWithPtr |
| `Surface` | VariantWithPtr |
| `Scene` | VariantWithPtr |
| `Camera` | VariantWithPtr |
| `GetPtr` | fun(self: ViewBuffersReadyEventData, field: "View"): View |
| `GetPtr` | fun(self: ViewBuffersReadyEventData, field: "Texture"): Texture |
| `GetPtr` | fun(self: ViewBuffersReadyEventData, field: "Surface"): RenderSurface |
| `GetPtr` | fun(self: ViewBuffersReadyEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: ViewBuffersReadyEventData, field: "Camera"): Camera |

#### ViewChangedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `GetInt` | fun(self: ViewChangedEventData, field: "X"): integer |
| `GetInt` | fun(self: ViewChangedEventData, field: "Y"): integer |
| `GetPtr` | fun(self: ViewChangedEventData, field: "Element"): UIElement |

#### ViewGlobalShaderParametersEventData

| 字段 | 类型 |
|------|------|
| `View` | VariantWithPtr |
| `Texture` | VariantWithPtr |
| `Surface` | VariantWithPtr |
| `Scene` | VariantWithPtr |
| `Camera` | VariantWithPtr |
| `GetPtr` | fun(self: ViewGlobalShaderParametersEventData, field: "View"): View |
| `GetPtr` | fun(self: ViewGlobalShaderParametersEventData, field: "Texture"): Texture |
| `GetPtr` | fun(self: ViewGlobalShaderParametersEventData, field: "Surface"): RenderSurface |
| `GetPtr` | fun(self: ViewGlobalShaderParametersEventData, field: "Scene"): Scene |
| `GetPtr` | fun(self: ViewGlobalShaderParametersEventData, field: "Camera"): Camera |

#### VisibleChangedEventData

| 字段 | 类型 |
|------|------|
| `Element` | VariantWithPtr |
| `Visible` | VariantWithBool |
| `GetBool` | fun(self: VisibleChangedEventData, field: "Visible"): boolean |
| `GetPtr` | fun(self: VisibleChangedEventData, field: "Element"): UIElement |

#### VoxelAssemblyMemberDetachedEventData

| 字段 | 类型 |
|------|------|
| `Assembly` | VariantWithPtr |
| `Volume` | VariantWithPtr |
| `Force` | VariantWithVector3 |
| `Torque` | VariantWithVector3 |
| `BreakFactor` | VariantWithFloat |
| `Reason` | Variant |
| `GetFloat` | fun(self: VoxelAssemblyMemberDetachedEventData, field: "BreakFactor"): number |
| `GetPtr` | fun(self: VoxelAssemblyMemberDetachedEventData, field: "Assembly"): VoxelAssembly |
| `GetPtr` | fun(self: VoxelAssemblyMemberDetachedEventData, field: "Volume"): VoxelVolume |
| `GetVector3` | fun(self: VoxelAssemblyMemberDetachedEventData, field: "Force"): Vector3 |
| `GetVector3` | fun(self: VoxelAssemblyMemberDetachedEventData, field: "Torque"): Vector3 |

#### VoxelAssemblyRootChangedEventData

| 字段 | 类型 |
|------|------|
| `Assembly` | VariantWithPtr |
| `OldRoot` | VariantWithPtr |
| `NewRoot` | VariantWithPtr |
| `GetPtr` | fun(self: VoxelAssemblyRootChangedEventData, field: "Assembly"): VoxelAssembly |
| `GetPtr` | fun(self: VoxelAssemblyRootChangedEventData, field: "OldRoot"): VoxelVolume |
| `GetPtr` | fun(self: VoxelAssemblyRootChangedEventData, field: "NewRoot"): VoxelVolume |

#### VoxelContactEventData

| 字段 | 类型 |
|------|------|
| `VolumeA` | VariantWithPtr |
| `VolumeB` | VariantWithPtr |
| `Position` | VariantWithVector3 |
| `Velocity` | VariantWithFloat |
| `GetFloat` | fun(self: VoxelContactEventData, field: "Velocity"): number |
| `GetPtr` | fun(self: VoxelContactEventData, field: "VolumeA"): VoxelVolume |
| `GetPtr` | fun(self: VoxelContactEventData, field: "VolumeB"): VoxelVolume |
| `GetVector3` | fun(self: VoxelContactEventData, field: "Position"): Vector3 |

#### VoxelContentReadyEventData

| 字段 | 类型 |
|------|------|
| `Volume` | VariantWithPtr |
| `CollisionReady` | VariantWithBool |
| `GetBool` | fun(self: VoxelContentReadyEventData, field: "CollisionReady"): boolean |
| `GetPtr` | fun(self: VoxelContentReadyEventData, field: "Volume"): VoxelVolume |

#### VoxelDamagedEventData

| 字段 | 类型 |
|------|------|
| `Volume` | VariantWithPtr |
| `Position` | VariantWithVector3 |
| `Radius` | VariantWithFloat |
| `Removed` | VariantWithInt |
| `Material` | VariantWithInt |
| `GetFloat` | fun(self: VoxelDamagedEventData, field: "Radius"): number |
| `GetInt` | fun(self: VoxelDamagedEventData, field: "Removed"): integer |
| `GetInt` | fun(self: VoxelDamagedEventData, field: "Material"): integer |
| `GetPtr` | fun(self: VoxelDamagedEventData, field: "Volume"): VoxelVolume |
| `GetVector3` | fun(self: VoxelDamagedEventData, field: "Position"): Vector3 |

#### VoxelFragmentFrozenEventData

| 字段 | 类型 |
|------|------|
| `Volume` | VariantWithPtr |
| `Position` | VariantWithVector3 |
| `GetPtr` | fun(self: VoxelFragmentFrozenEventData, field: "Volume"): VoxelVolume |
| `GetVector3` | fun(self: VoxelFragmentFrozenEventData, field: "Position"): Vector3 |

#### VoxelInitialSyncFinishedEventData

| 字段 | 类型 |
|------|------|
| `World` | VariantWithPtr |
| `GetPtr` | fun(self: VoxelInitialSyncFinishedEventData, field: "World"): VoxelPhysicsWorld |

#### VoxelSeveredEventData

| 字段 | 类型 |
|------|------|
| `Volume` | VariantWithPtr |
| `Fragment` | VariantWithPtr |
| `Voxels` | VariantWithInt |
| `Anchored` | VariantWithBool |
| `GetBool` | fun(self: VoxelSeveredEventData, field: "Anchored"): boolean |
| `GetInt` | fun(self: VoxelSeveredEventData, field: "Voxels"): integer |
| `GetPtr` | fun(self: VoxelSeveredEventData, field: "Volume"): VoxelVolume |
| `GetPtr` | fun(self: VoxelSeveredEventData, field: "Fragment"): VoxelVolume |

#### VoxelSyncFailedEventData

| 字段 | 类型 |
|------|------|
| `Reason` | VariantWithString |
| `GetString` | fun(self: VoxelSyncFailedEventData, field: "Reason"): string |

#### WindowPosEventData

| 字段 | 类型 |
|------|------|
| `X` | VariantWithInt |
| `Y` | VariantWithInt |
| `GetInt` | fun(self: WindowPosEventData, field: "X"): integer |
| `GetInt` | fun(self: WindowPosEventData, field: "Y"): integer |

#### WorldPartitionReadyEventData

| 字段 | 类型 |
|------|------|
| `Component` | VariantWithPtr |
| `GetPtr` | fun(self: WorldPartitionReadyEventData, field: "Component"): WorldPartitionComponent |

---

## 五、harness 实现建议

### 常见报错与缺失 API

| 报错 | 缺失的 API | 处理建议 |
|------|-----------|---------|
| `module 'LuaScripts/Utilities/Sample' not found` | 引擎自带工具库 | 打包时带上 `LuaScripts/Utilities/` 同名文件，或提供空 stub |
| `attempt to call a nil value (global 'ScriptObject')` | `ScriptObject()` | 返回带 `SubscribeToEvent`/`UnsubscribeFromEvent` 的空表 |
| `attempt to call a nil value (method 'DownloadResources')` | `cache:DownloadResource(s)` | 本地资源直接回调 success |
| `graphics:SetWindowXXX` | Graphics 窗口方法 | 空实现 no-op |
| `input:GetNumJoysticks` | Input 手柄方法 | 返回 0 |

### 通用兜底策略

给每个类的 metatable 加 `__index` 兜底：未实现的方法返回**一个返回默认值的函数**
（而非 nil），可一次性消除绝大多数 `attempt to call a nil value`。

```lua
local function make_stub(class_name, known_methods)
    local t = {}
    return setmetatable(t, {
        __index = function(_, k)
            local fn = known_methods[k]
            if fn then return fn end
            -- 未知成员:返回一个返回默认值的函数
            return function(...) return 0 end
        end,
        __newindex = function() end,  -- 属性写入忽略
    })
end
```
