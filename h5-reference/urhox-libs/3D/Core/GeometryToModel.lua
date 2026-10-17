-- ============================================================================
-- urhox-libs/3D · GeometryToModel
-- 把本库几何（CustomGeometry 后端）转成原生 Model 资源，供 InstancedMesh
-- （StaticModelGroup 需要 Model）等使用。
--
-- 转换在 C++ 侧零拷贝完成（CustomGeometry:FillModel 复用其 committed vertexBuffer/geometries），
-- 避免 Lua 手工打包 buffer。Model 由 Lua 创建（Lua 持有生命周期），C++ 填充；
-- Model 与 buffer 共享所有权，故临时 CustomGeometry 节点删除后 Model 仍自洽。
-- ============================================================================

local GeometryToModel = {}

-- geometry：含 :build(node, nativeMat) 的本库几何（BufferGeometry 或 build-once 包装）
-- 返回原生 Model（失败返回 nil）
function GeometryToModel.toModel(geometry)
    if not geometry or not geometry.build then return nil end

    -- BufferGeometry:build 会 rawset(self,"_component"/"_nativeMat")。临时节点销毁后这些会变悬空，
    -- 后续触发 emit（addGroup/applyMatrix4/...）会崩。先存旧值，转换后还原，使 geometry 不受影响。
    local savedComponent = rawget(geometry, "_component")
    local savedNativeMat = rawget(geometry, "_nativeMat")

    local holder = Node()                 -- detached 临时节点，建出 CustomGeometry
    local cg = geometry:build(holder, nil)
    local model = Model:new()             -- Lua 持有生命周期
    local ok = cg and cg.FillModel and cg:FillModel(model)
    holder:Remove()                       -- cg 删除；model 与共享的 buffer/geometry 仍存活

    -- 还原 geometry 内部状态（无 _component 字段的 build-once 几何此处为 nil→nil，无副作用）
    rawset(geometry, "_component", savedComponent)
    rawset(geometry, "_nativeMat", savedNativeMat)

    if not ok then return nil end
    return model
end

return GeometryToModel
