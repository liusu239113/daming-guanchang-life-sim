---@meta

--- Auto-generated from Graphics/RenderPath

---@alias RenderCommandType
---| integer # RenderCommandType enum values

---@type RenderCommandType
CMD_NONE = 0
---@type RenderCommandType
CMD_CLEAR = 1
---@type RenderCommandType
CMD_SCENEPASS = 2
---@type RenderCommandType
CMD_QUAD = 3
---@type RenderCommandType
CMD_FORWARDLIGHTS = 4
---@type RenderCommandType
CMD_LIGHTVOLUMES = 5
---@type RenderCommandType
CMD_RENDERUI = 6
---@type RenderCommandType
CMD_SENDEVENT = 9
---@type RenderCommandType
CMD_GBUFFERPOSTPROCESS = 21
---@type RenderCommandType
CMD_VOLUMETRIC_CLOUD = 22
---@type RenderCommandType
CMD_VOLUMETRIC_CLOUD_SHADOW = 23
---@type RenderCommandType
CMD_VOLUMETRIC_CLOUD_TEMPORAL = 24
---@type RenderCommandType
CMD_VOLUMETRIC_CLOUD_SKY_AO = 25
---@type RenderCommandType
CMD_SKY_ATMOSPHERE = 27
---@type RenderCommandType
CMD_VOLUMETRIC_CLOUD_COMPOSE = 26

---@alias RenderCommandSortMode
---| integer # RenderCommandSortMode enum values

---@type RenderCommandSortMode
SORT_FRONTTOBACK = 0
---@type RenderCommandSortMode
SORT_BACKTOFRONT = 1

---@alias RenderCommandRole
---| integer # RenderCommandRole enum values

---@type RenderCommandRole
RP_ROLE_NONE = 0
---@type RenderCommandRole
RP_ROLE_TAA_RESOLVE = 1
---@type RenderCommandRole
RP_ROLE_CAMERA_MOTION = 2
---@type RenderCommandRole
RP_ROLE_OBJECT_MOTION = 3
---@type RenderCommandRole
RP_ROLE_COMPUTE_SSAO = 4
---@type RenderCommandRole
RP_ROLE_VDM_DEPTH = 5
---@type RenderCommandRole
RP_ROLE_GBUFFER = 6
---@type RenderCommandRole
RP_ROLE_SCENE_DEPTH_HISTORY = 7

---@alias TemporalShadowContract
---| integer # TemporalShadowContract enum values

---@type TemporalShadowContract
TEMPORAL_SHADOW_CONTRACT_NONE = 0
---@type TemporalShadowContract
TEMPORAL_SHADOW_CONTRACT_DEFERRED_V1 = 1

---@alias RenderPathInputType
---| integer # RenderPathInputType enum values

---@type RenderPathInputType
RP_INPUT_TEXTURE = 0
---@type RenderPathInputType
RP_INPUT_TEXTURE2D = 1
---@type RenderPathInputType
RP_INPUT_TEXTURE3D = 2
---@type RenderPathInputType
RP_INPUT_TEXTURECUBE = 3
---@type RenderPathInputType
RP_INPUT_TEXTURE2DARRAY = 4

---@alias RenderTargetSizeMode
---| integer # RenderTargetSizeMode enum values

---@type RenderTargetSizeMode
SIZE_ABSOLUTE = 0
---@type RenderTargetSizeMode
SIZE_VIEWPORTDIVISOR = 1
---@type RenderTargetSizeMode
SIZE_VIEWPORTMULTIPLIER = 2

---@class RenderTargetInfo
---@overload fun(): RenderTargetInfo
---@field name string
---@field tag string
---@field format integer
---@field size Vector2
---@field sizeMode RenderTargetSizeMode
---@field multiSample integer
---@field autoResolve boolean
---@field enabled boolean
---@field cubemap boolean
---@field filtered boolean
---@field sRGB boolean
---@field persistent boolean
---@field roundUpSize boolean
RenderTargetInfo = {}

---@return RenderTargetInfo
function RenderTargetInfo.new() end

---@param element XMLElement
---@return nil
function RenderTargetInfo:Load(element) end


---@class RenderPathCommand
---@overload fun(): RenderPathCommand
---@field tag string
---@field type RenderCommandType
---@field role RenderCommandRole
---@field temporalShadowContract TemporalShadowContract
---@field resolveDepth boolean
---@field sortMode RenderCommandSortMode
---@field pass string
---@field metadata string
---@field vertexShaderName string
---@field pixelShaderName string
---@field vertexShaderDefines string
---@field pixelShaderDefines string
---@field clearFlags integer
---@field clearColor Color
---@field clearDepth number
---@field clearStencil integer
---@field blendMode BlendMode
---@field enabled boolean
---@field useFogColor boolean
---@field markToStencil boolean
---@field useLitBase boolean
---@field vertexLights boolean
---@field eventName string
RenderPathCommand = {}

---@return RenderPathCommand
function RenderPathCommand.new() end

---@param element XMLElement
---@return nil
function RenderPathCommand:Load(element) end

---@param unit TextureUnit
---@param name string
---@return nil
function RenderPathCommand:SetTextureName(unit, name) end

---@param semantic string
---@param name string
---@param type? RenderPathInputType
---@param optional? boolean
---@return nil
function RenderPathCommand:SetInput(semantic, name, type, optional) end

---@param semantic string
---@return nil
function RenderPathCommand:RemoveInput(semantic) end

---@param condition string
---@param vsDefines string
---@param psDefines string
---@return nil
function RenderPathCommand:SetConditionalShaderDefines(condition, vsDefines, psDefines) end

---@param name string
---@param value Variant
---@return nil
function RenderPathCommand:SetShaderParameter(name, value) end

---@param name string
---@return nil
function RenderPathCommand:RemoveShaderParameter(name) end

---@param num integer
---@return nil
function RenderPathCommand:SetNumOutputs(num) end

---@param index integer
---@param name string
---@param face CubeMapFace
---@return nil
function RenderPathCommand:SetOutput(index, name, face) end

---@param index integer
---@param name string
---@return nil
function RenderPathCommand:SetOutputName(index, name) end

---@param index integer
---@param face CubeMapFace
---@return nil
function RenderPathCommand:SetOutputFace(index, face) end

---@param name string
---@return nil
function RenderPathCommand:SetDepthStencilName(name) end

---@param unit TextureUnit
---@return string
function RenderPathCommand:GetTextureName(unit) end

---@param name string
---@return Variant
function RenderPathCommand:GetShaderParameter(name) end

---@return integer
function RenderPathCommand:GetNumOutputs() end

---@param index integer
---@return string
function RenderPathCommand:GetOutputName(index) end

---@param index integer
---@return CubeMapFace
function RenderPathCommand:GetOutputFace(index) end

---@return string
function RenderPathCommand:GetDepthStencilName() end


---@class RenderPath
RenderPath = {}

---@return RenderPath
function RenderPath:Clone() end

---@param file XMLFile
---@return boolean
function RenderPath:Load(file) end

---@param file XMLFile
---@return boolean
function RenderPath:Append(file) end

---@param tag string
---@param active boolean
---@return nil
function RenderPath:SetEnabled(tag, active) end

---@param tag string
---@return boolean
function RenderPath:IsEnabled(tag) end

---@param tag string
---@return boolean
function RenderPath:IsAdded(tag) end

---@param tag string
---@return nil
function RenderPath:ToggleEnabled(tag) end

---@param index integer
---@param info RenderTargetInfo
---@return nil
function RenderPath:SetRenderTarget(index, info) end

---@param info RenderTargetInfo
---@return nil
function RenderPath:AddRenderTarget(info) end

---@param name string
---@return nil
function RenderPath:RemoveRenderTarget(name) end

---@param index integer
---@return nil
function RenderPath:RemoveRenderTarget(index) end

---@param tag string
---@return nil
function RenderPath:RemoveRenderTargets(tag) end

---@param index integer
---@param command RenderPathCommand
---@return nil
function RenderPath:SetCommand(index, command) end

---@param command RenderPathCommand
---@return nil
function RenderPath:AddCommand(command) end

---@param index integer
---@param command RenderPathCommand
---@return nil
function RenderPath:InsertCommand(index, command) end

---@param index integer
---@return nil
function RenderPath:RemoveCommand(index) end

---@param tag string
---@return nil
function RenderPath:RemoveCommands(tag) end

---@param name string
---@param value Variant
---@return nil
function RenderPath:SetShaderParameter(name, value) end

---@return integer
function RenderPath:GetNumRenderTargets() end

---@return integer
function RenderPath:GetNumCommands() end

---@param index integer
---@return RenderPathCommand
function RenderPath:GetCommand(index) end

---@param name string
---@return Variant
function RenderPath:GetShaderParameter(name) end

