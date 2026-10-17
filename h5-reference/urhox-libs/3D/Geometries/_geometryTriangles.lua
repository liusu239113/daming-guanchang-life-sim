-- ============================================================================
-- urhox-libs/3D · _geometryTriangles（内部）
-- 从任意本库几何取三角形顶点，供 EdgesGeometry / WireframeGeometry 等用。
--   - BufferGeometry：直读 attributes.position + index（扁平 0-based 数组或 nil）
--   - build-once 几何（Box/Sphere…）：临时 CustomGeometry + GetVertex（三角列、非索引）
-- 统一返回 { count, index, getX/getY/getZ(i) }，让上层无视几何来源。
-- ============================================================================

local T = {}

-- 把 BufferAttribute 包装成统一访问器
local function fromAttribute(attr, index)
    return {
        count = attr.count,
        index = index, -- 扁平 0-based 数组或 nil
        getX = function(_, i) return attr:getX(i) end,
        getY = function(_, i) return attr:getY(i) end,
        getZ = function(_, i) return attr:getZ(i) end,
    }
end

function T.readTriangles(geometry)
    -- BufferGeometry 路径
    if geometry.attributes and geometry.attributes.position then
        return fromAttribute(geometry.attributes.position, geometry:getIndex())
    end

    -- build-once 几何：建临时 CustomGeometry 读回三角列顶点（非索引）
    if not geometry.build then return nil end
    local node = Node()
    local cg = geometry:build(node, nil)
    local xs, ys, zs = {}, {}, {}
    local n = 0
    if cg and cg.GetNumGeometries then
        for gi = 0, cg:GetNumGeometries() - 1 do
            local nv = cg:GetNumVertices(gi)
            for v = 0, nv - 1 do
                local vert = cg:GetVertex(gi, v)
                local p = vert.position
                n = n + 1; xs[n] = p.x; ys[n] = p.y; zs[n] = p.z
            end
        end
    end
    node:Remove()
    return {
        count = n,
        index = nil, -- 三角列，顺序即三角形
        getX = function(_, i) return xs[i + 1] end, -- i 为 0-based
        getY = function(_, i) return ys[i + 1] end,
        getZ = function(_, i) return zs[i + 1] end,
    }
end

return T
