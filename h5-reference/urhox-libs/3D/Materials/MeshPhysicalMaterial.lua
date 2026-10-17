-- ============================================================================
-- urhox-libs/3D · MeshPhysicalMaterial
-- three.js MeshPhysicalMaterial extends MeshStandardMaterial。
-- 引擎 PBR 无 sheen/clearcoat/transmission shader → 降级复用 MeshStandardMaterial 实现：
--   color/roughness/metalness/map/normalMap/ORM/emissive 等全部生效；
--   physical-only(sheen/clearcoat/transmission/ior/...) 接口暴露但 warn no-op（见 §6.3）。
--   isMeshPhysicalMaterial 与 isMeshStandardMaterial 同时为 true（与 three.js 一致）。
-- ============================================================================

local Standard = require("urhox-libs/3D/Materials/MeshStandardMaterial")

local M = {}

function M.new(opts)
    return Standard.new(opts, true)
end

return M
