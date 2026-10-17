-- Windows 10 OS Simulator
-- A complete Windows 10 desktop environment simulation using UrhoX

require "LuaScripts/Utilities/Sample"

-- ============================================================================
-- Constants & Colors (Windows 10 Fluent Design)
-- ============================================================================
local TASKBAR_HEIGHT = 40
local WINDOW_TITLE_HEIGHT = 30
local DESKTOP_ICON_SIZE = 80
local DESKTOP_ICON_SPACING = 90
local START_MENU_WIDTH = 560
local START_MENU_HEIGHT = 560

-- Windows 10 Color Palette
local Colors = {
    -- Desktop background - Windows 10 default blue gradient
    Desktop = Color(0.0, 0.47, 0.84, 1.0),
    DesktopDark = Color(0.0, 0.25, 0.50, 1.0),

    -- Taskbar
    Taskbar = Color(0.0, 0.0, 0.0, 0.90),
    TaskbarHover = Color(1.0, 1.0, 1.0, 0.1),

    -- Windows
    WindowTitle = Color(1.0, 1.0, 1.0, 1.0),
    WindowTitleInactive = Color(0.96, 0.96, 0.96, 1.0),
    WindowBody = Color(1.0, 1.0, 1.0, 1.0),
    WindowBorder = Color(0.85, 0.85, 0.85, 1.0),

    -- Buttons
    CloseHover = Color(0.90, 0.18, 0.18, 1.0),
    ButtonHover = Color(0.92, 0.92, 0.92, 1.0),

    -- Start Menu
    StartMenu = Color(0.09, 0.09, 0.09, 0.96),

    -- App Tiles
    TileBlue = Color(0.0, 0.47, 0.84, 1.0),
    TileGreen = Color(0.10, 0.59, 0.32, 1.0),
    TileOrange = Color(0.85, 0.52, 0.10, 1.0),
    TilePurple = Color(0.55, 0.23, 0.67, 1.0),
    TileCyan = Color(0.0, 0.59, 0.78, 1.0),
    TileYellow = Color(0.95, 0.77, 0.06, 1.0),
    TileGray = Color(0.45, 0.45, 0.45, 1.0),
    TileRed = Color(0.85, 0.25, 0.25, 1.0),

    -- Text
    TextDark = Color(0.1, 0.1, 0.1, 1.0),
    TextLight = Color(1.0, 1.0, 1.0, 1.0),
    TextGray = Color(0.55, 0.55, 0.55, 1.0),

    -- Accent
    Accent = Color(0.0, 0.47, 0.84, 1.0),
}

-- ============================================================================
-- Global State
-- ============================================================================
local desktop = nil
local taskbar = nil
local startMenu = nil
local isStartMenuOpen = false
local windows = {}
local activeWindow = nil
local nextWindowId = 1
local clockText = nil

-- Window dragging state (global for mouse event handling)
local draggingWindow = nil
local dragOffsetX = 0
local dragOffsetY = 0

-- Calculator state
local calcDisplay = nil
local calcValue = "0"
local calcOperator = nil
local calcPrevValue = nil
local calcNewInput = true

-- ============================================================================
-- Utility Functions
-- ============================================================================
local function CreateFont(size)
    return cache:GetResource("Font", "Fonts/MiSans-Regular.ttf"), size
end

local function BringToFront(element)
    if element and desktop then
        local parent = element:GetParent()
        if parent then
            parent:RemoveChild(element)
            parent:AddChild(element)
        end
    end
end

-- ============================================================================
-- Icon Drawing Functions - Draw Windows 10 style icons
-- ============================================================================
local function DrawFolderIcon(parent, size)
    local container = parent:CreateChild("UIElement")
    container:SetSize(size, size)
    container:SetAlignment(HA_CENTER, VA_CENTER)

    -- Folder back
    local back = container:CreateChild("BorderImage")
    back:SetSize(size * 0.85, size * 0.6)
    back:SetPosition(size * 0.075, size * 0.25)
    back.color = Color(0.95, 0.75, 0.25, 1.0)

    -- Folder tab
    local tab = container:CreateChild("BorderImage")
    tab:SetSize(size * 0.35, size * 0.15)
    tab:SetPosition(size * 0.075, size * 0.12)
    tab.color = Color(0.95, 0.75, 0.25, 1.0)

    -- Folder front (slightly lighter)
    local front = container:CreateChild("BorderImage")
    front:SetSize(size * 0.85, size * 0.5)
    front:SetPosition(size * 0.075, size * 0.35)
    front.color = Color(1.0, 0.85, 0.40, 1.0)

    return container
end

local function DrawNotepadIcon(parent, size)
    local container = parent:CreateChild("UIElement")
    container:SetSize(size, size)
    container:SetAlignment(HA_CENTER, VA_CENTER)

    -- Paper background
    local paper = container:CreateChild("BorderImage")
    paper:SetSize(size * 0.7, size * 0.85)
    paper:SetPosition(size * 0.15, size * 0.075)
    paper.color = Color(1.0, 1.0, 1.0, 1.0)

    -- Blue header bar
    local header = container:CreateChild("BorderImage")
    header:SetSize(size * 0.7, size * 0.12)
    header:SetPosition(size * 0.15, size * 0.075)
    header.color = Color(0.0, 0.47, 0.84, 1.0)

    -- Text lines
    for i = 0, 3 do
        local line = container:CreateChild("BorderImage")
        line:SetSize(size * 0.5, size * 0.04)
        line:SetPosition(size * 0.25, size * 0.28 + i * size * 0.12)
        line.color = Color(0.7, 0.7, 0.7, 1.0)
    end

    return container
end

local function DrawCalculatorIcon(parent, size)
    local container = parent:CreateChild("UIElement")
    container:SetSize(size, size)
    container:SetAlignment(HA_CENTER, VA_CENTER)

    -- Calculator body
    local body = container:CreateChild("BorderImage")
    body:SetSize(size * 0.7, size * 0.85)
    body:SetPosition(size * 0.15, size * 0.075)
    body.color = Color(0.15, 0.15, 0.15, 1.0)

    -- Display
    local display = container:CreateChild("BorderImage")
    display:SetSize(size * 0.55, size * 0.18)
    display:SetPosition(size * 0.225, size * 0.14)
    display.color = Color(0.75, 0.85, 0.75, 1.0)

    -- Button grid (3x3)
    for row = 0, 2 do
        for col = 0, 2 do
            local btn = container:CreateChild("BorderImage")
            btn:SetSize(size * 0.14, size * 0.12)
            btn:SetPosition(size * 0.225 + col * size * 0.17, size * 0.38 + row * size * 0.16)
            btn.color = Color(0.35, 0.35, 0.35, 1.0)
        end
    end

    return container
end

local function DrawBrowserIcon(parent, size)
    local container = parent:CreateChild("UIElement")
    container:SetSize(size, size)
    container:SetAlignment(HA_CENTER, VA_CENTER)

    -- Outer circle (blue)
    local outer = container:CreateChild("BorderImage")
    outer:SetSize(size * 0.85, size * 0.85)
    outer:SetPosition(size * 0.075, size * 0.075)
    outer.color = Color(0.0, 0.47, 0.84, 1.0)

    -- Inner wave shape (simplified as lighter blue arc)
    local wave = container:CreateChild("BorderImage")
    wave:SetSize(size * 0.55, size * 0.55)
    wave:SetPosition(size * 0.15, size * 0.15)
    wave.color = Color(0.2, 0.6, 0.95, 1.0)

    -- Center dot
    local center = container:CreateChild("BorderImage")
    center:SetSize(size * 0.25, size * 0.25)
    center:SetPosition(size * 0.375, size * 0.375)
    center.color = Color(0.0, 0.35, 0.70, 1.0)

    return container
end

local function DrawRecycleBinIcon(parent, size)
    local container = parent:CreateChild("UIElement")
    container:SetSize(size, size)
    container:SetAlignment(HA_CENTER, VA_CENTER)

    -- Bin body
    local body = container:CreateChild("BorderImage")
    body:SetSize(size * 0.6, size * 0.65)
    body:SetPosition(size * 0.2, size * 0.28)
    body.color = Color(0.55, 0.55, 0.55, 1.0)

    -- Bin lid
    local lid = container:CreateChild("BorderImage")
    lid:SetSize(size * 0.7, size * 0.1)
    lid:SetPosition(size * 0.15, size * 0.15)
    lid.color = Color(0.65, 0.65, 0.65, 1.0)

    -- Lid handle
    local handle = container:CreateChild("BorderImage")
    handle:SetSize(size * 0.2, size * 0.08)
    handle:SetPosition(size * 0.4, size * 0.08)
    handle.color = Color(0.65, 0.65, 0.65, 1.0)

    -- Vertical lines on bin
    for i = 0, 2 do
        local line = container:CreateChild("BorderImage")
        line:SetSize(size * 0.04, size * 0.45)
        line:SetPosition(size * 0.3 + i * size * 0.15, size * 0.38)
        line.color = Color(0.45, 0.45, 0.45, 1.0)
    end

    return container
end

local function DrawSettingsIcon(parent, size)
    local container = parent:CreateChild("UIElement")
    container:SetSize(size, size)
    container:SetAlignment(HA_CENTER, VA_CENTER)

    -- Gear outer
    local outer = container:CreateChild("BorderImage")
    outer:SetSize(size * 0.8, size * 0.8)
    outer:SetPosition(size * 0.1, size * 0.1)
    outer.color = Color(0.5, 0.5, 0.5, 1.0)

    -- Gear inner (hollow effect)
    local inner = container:CreateChild("BorderImage")
    inner:SetSize(size * 0.4, size * 0.4)
    inner:SetPosition(size * 0.3, size * 0.3)
    inner.color = Color(0.3, 0.3, 0.3, 1.0)

    return container
end

local function DrawInfoIcon(parent, size)
    local container = parent:CreateChild("UIElement")
    container:SetSize(size, size)
    container:SetAlignment(HA_CENTER, VA_CENTER)

    -- Circle
    local circle = container:CreateChild("BorderImage")
    circle:SetSize(size * 0.8, size * 0.8)
    circle:SetPosition(size * 0.1, size * 0.1)
    circle.color = Color(0.55, 0.23, 0.67, 1.0)

    -- "i" letter using Text
    local iText = container:CreateChild("Text")
    iText:SetFont(CreateFont(math.floor(size * 0.5)))
    iText.text = "i"
    iText.color = Colors.TextLight
    iText:SetAlignment(HA_CENTER, VA_CENTER)

    return container
end

-- ============================================================================
-- Window Class
-- ============================================================================
local Window = {}
Window.__index = Window

function Window.new(title, x, y, width, height, options)
    local self = setmetatable({}, Window)
    self.id = nextWindowId
    nextWindowId = nextWindowId + 1
    self.title = title
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.savedX = x
    self.savedY = y
    self.savedWidth = width
    self.savedHeight = height
    self.isMaximized = false
    self.isMinimized = false
    self.isDragging = false
    self.dragOffsetX = 0
    self.dragOffsetY = 0
    self.element = nil
    self.titleBar = nil
    self.contentArea = nil
    self.taskbarButton = nil
    self.options = options or {}
    self.onResize = nil  -- Callback for content resize
    return self
end

function Window:create(parent)
    -- Main window container with Vertical Layout (Pattern 1: titleBar + contentArea)
    self.element = parent:CreateChild("Window")
    self.element:SetSize(self.width, self.height)
    self.element:SetPosition(self.x, self.y)
    self.element:SetMovable(false)
    self.element:SetResizable(false)
    self.element.color = Colors.WindowBody
    self.element:SetName("Window_" .. self.id)

    -- ✅ 关键：给窗口设置 Layout，启用自动约束
    self.element:SetLayout(LM_VERTICAL, 0, IntRect(0, 0, 0, 0))

    -- Title bar with horizontal layout (fixed height)
    self.titleBar = self.element:CreateChild("Button")
    self.titleBar:SetFixedHeight(WINDOW_TITLE_HEIGHT)  -- ✅ 使用 SetFixedHeight 代替手动 SetSize
    self.titleBar:SetLayout(LM_HORIZONTAL, 0, IntRect(0, 0, 0, 0))
    self.titleBar.color = Colors.WindowTitle
    self.titleBar:SetName("TitleBg")

    -- Left section: icon + title (flexible width)
    local leftSection = self.titleBar:CreateChild("UIElement")
    leftSection:SetMinWidth(50)  -- Minimum width for proper layout
    leftSection:SetLayout(LM_HORIZONTAL, 0, IntRect(8, 0, 0, 0))
    leftSection:SetLayoutFlexScale(Vector2(1, 0))  -- Take remaining space

    -- Window icon
    local iconColor = self.options.iconColor or Colors.TileBlue
    local windowIcon = leftSection:CreateChild("BorderImage")
    windowIcon:SetFixedSize(16, 16)
    windowIcon:SetAlignment(HA_LEFT, VA_CENTER)
    windowIcon.color = iconColor

    -- Title text
    local titleText = leftSection:CreateChild("Text")
    titleText:SetFont(CreateFont(11))
    titleText.text = self.title
    titleText.color = Colors.TextDark
    titleText:SetAlignment(HA_LEFT, VA_CENTER)

    local buttonSize = 46

    -- Right section: window buttons (fixed width = 3 buttons)
    local rightSection = self.titleBar:CreateChild("UIElement")
    rightSection:SetFixedWidth(buttonSize * 3)
    rightSection:SetLayout(LM_HORIZONTAL, 0, IntRect(0, 0, 0, 0))

    -- Minimize button
    local minBtn = rightSection:CreateChild("Button")
    minBtn:SetFixedSize(buttonSize, WINDOW_TITLE_HEIGHT)
    minBtn.color = Color(0, 0, 0, 0)
    minBtn:SetName("MinBtn")

    local minLine = minBtn:CreateChild("BorderImage")
    minLine:SetSize(10, 1)
    minLine:SetAlignment(HA_CENTER, VA_CENTER)
    minLine:SetPosition(0, 3)
    minLine.color = Colors.TextDark

    SubscribeToEvent(minBtn, "HoverBegin", function()
        minBtn.color = Colors.ButtonHover
    end)
    SubscribeToEvent(minBtn, "HoverEnd", function()
        minBtn.color = Color(0, 0, 0, 0)
    end)
    SubscribeToEvent(minBtn, "Released", function()
        self:minimize()
    end)

    -- Maximize button
    local maxBtn = rightSection:CreateChild("Button")
    maxBtn:SetFixedSize(buttonSize, WINDOW_TITLE_HEIGHT)
    maxBtn.color = Color(0, 0, 0, 0)
    maxBtn:SetName("MaxBtn")

    local maxIcon = maxBtn:CreateChild("BorderImage")
    maxIcon:SetSize(10, 10)
    maxIcon:SetAlignment(HA_CENTER, VA_CENTER)
    maxIcon.color = Color(0, 0, 0, 0)

    -- Draw square outline for maximize
    local maxBorder = maxBtn:CreateChild("BorderImage")
    maxBorder:SetSize(10, 10)
    maxBorder:SetAlignment(HA_CENTER, VA_CENTER)
    maxBorder.color = Colors.TextDark

    local maxInner = maxBtn:CreateChild("BorderImage")
    maxInner:SetSize(6, 6)
    maxInner:SetAlignment(HA_CENTER, VA_CENTER)
    maxInner.color = Colors.WindowTitle

    SubscribeToEvent(maxBtn, "HoverBegin", function()
        maxBtn.color = Colors.ButtonHover
    end)
    SubscribeToEvent(maxBtn, "HoverEnd", function()
        maxBtn.color = Color(0, 0, 0, 0)
    end)
    SubscribeToEvent(maxBtn, "Released", function()
        self:toggleMaximize()
    end)

    -- Close button
    local closeBtn = rightSection:CreateChild("Button")
    closeBtn:SetFixedSize(buttonSize, WINDOW_TITLE_HEIGHT)
    closeBtn.color = Color(0, 0, 0, 0)
    closeBtn:SetName("CloseBtn")

    local closeX = closeBtn:CreateChild("Text")
    closeX:SetFont(CreateFont(14))
    closeX.text = "x"
    closeX.color = Colors.TextDark
    closeX:SetAlignment(HA_CENTER, VA_CENTER)
    closeX:SetName("CloseX")

    SubscribeToEvent(closeBtn, "HoverBegin", function()
        closeBtn.color = Colors.CloseHover
        closeX.color = Colors.TextLight
    end)
    SubscribeToEvent(closeBtn, "HoverEnd", function()
        closeBtn.color = Color(0, 0, 0, 0)
        closeX.color = Colors.TextDark
    end)
    SubscribeToEvent(closeBtn, "Released", function()
        self:close()
    end)

    -- Content area (flexible, fills remaining space)
    self.contentArea = self.element:CreateChild("UIElement")
    self.contentArea:SetMinSize(0, 100)  -- ✅ 最小高度 100，宽度不限
    self.contentArea:SetLayoutFlexScale(Vector2(1, 1))  -- ✅ 弹性元素
    self.contentArea:SetClipChildren(true)

    -- Drag handling using Pressed/Released events
    local thisWindow = self
    SubscribeToEvent(self.titleBar, "Pressed", function()
        thisWindow:activate()
        if not thisWindow.isMaximized then
            draggingWindow = thisWindow
            local mousePos = input.mousePosition
            dragOffsetX = mousePos.x - thisWindow.x
            dragOffsetY = mousePos.y - thisWindow.y
        end
    end)

    SubscribeToEvent(self.titleBar, "Released", function()
        if draggingWindow == thisWindow then
            draggingWindow = nil
        end
    end)

    SubscribeToEvent(self.element, "Click", function()
        thisWindow:activate()
    end)

    table.insert(windows, self)
    self:activate()
    self:createTaskbarButton()

    -- ✅ 保持用户指定的初始尺寸，不让 Layout 自动压缩窗口
    -- 强制设置回用户期望的尺寸（覆盖 Layout 可能的自动调整）
    self.element:SetSize(self.width, self.height)

    -- 保存这个尺寸用于最大化-恢复
    self.savedWidth = self.width
    self.savedHeight = self.height

    return self
end

function Window:activate()
    if activeWindow and activeWindow ~= self then
        activeWindow:deactivate()
    end
    activeWindow = self
    BringToFront(self.element)

    -- titleBar itself is the background
    self.titleBar.color = Colors.WindowTitle

    self:updateTaskbarButton()
end

function Window:deactivate()
    -- titleBar itself is the background
    self.titleBar.color = Colors.WindowTitleInactive
    self:updateTaskbarButton()
end

function Window:minimize()
    self.isMinimized = true
    self.element.visible = false
    self:updateTaskbarButton()

    for i = #windows, 1, -1 do
        if windows[i] ~= self and not windows[i].isMinimized then
            windows[i]:activate()
            return
        end
    end
    activeWindow = nil
end

function Window:restore()
    self.isMinimized = false
    self.element.visible = true
    self:activate()
    self:updateTaskbarButton()
end

function Window:toggleMaximize()
    local graphics = GetGraphics()

    if self.isMaximized then
        self.isMaximized = false
        self.x = self.savedX
        self.y = self.savedY
        self.width = self.savedWidth
        self.height = self.savedHeight
    else
        self.savedX = self.x
        self.savedY = self.y
        self.savedWidth = self.width
        self.savedHeight = self.height
        self.isMaximized = true
        self.x = 0
        self.y = 0
        self.width = graphics.width
        self.height = graphics.height - TASKBAR_HEIGHT
    end

    self.element:SetPosition(self.x, self.y)
    self.element:SetSize(self.width, self.height)
    self:updateLayout()
end

function Window:updateLayout()
    -- Layout 会自动管理 titleBar 和 contentArea 的尺寸
    -- 设置窗口整体尺寸并强制触发 Layout 更新
    self.element:SetSize(self.width, self.height)
    self.element:UpdateLayout()

    -- 注意：不读取 element.size，保持用户指定的 width/height
    -- 这样可以防止 Layout 自动压缩窗口到最小尺寸

    -- Call resize callback if set (for apps that need custom content layout)
    if self.onResize then
        local contentWidth = self.width
        local contentHeight = self.height - WINDOW_TITLE_HEIGHT
        self.onResize(contentWidth, contentHeight)
    end
end

function Window:close()
    for i, w in ipairs(windows) do
        if w == self then
            table.remove(windows, i)
            break
        end
    end

    if self.taskbarButton then
        self.taskbarButton:Remove()
    end

    if self.element then
        self.element:Remove()
    end

    if activeWindow == self then
        activeWindow = nil
        for i = #windows, 1, -1 do
            if not windows[i].isMinimized then
                windows[i]:activate()
                break
            end
        end
    end
end

function Window:createTaskbarButton()
    if not taskbar then return end

    local buttonsArea = taskbar:GetChild("WindowButtons", false)
    if not buttonsArea then return end

    self.taskbarButton = buttonsArea:CreateChild("Button")
    self.taskbarButton:SetMinSize(140, TASKBAR_HEIGHT - 6)
    self.taskbarButton:SetMaxSize(180, TASKBAR_HEIGHT - 6)
    self.taskbarButton.color = Color(0, 0, 0, 0)
    self.taskbarButton:SetName("TaskBtn_" .. self.id)

    local iconColor = self.options.iconColor or Colors.TileBlue
    local btnIcon = self.taskbarButton:CreateChild("BorderImage")
    btnIcon:SetSize(16, 16)
    btnIcon:SetPosition(8, (TASKBAR_HEIGHT - 6 - 16) / 2)
    btnIcon.color = iconColor

    local btnText = self.taskbarButton:CreateChild("Text")
    btnText:SetFont(CreateFont(11))
    btnText.text = self.title
    btnText.color = Colors.TextLight
    btnText:SetPosition(30, (TASKBAR_HEIGHT - 6 - 14) / 2)

    local indicator = self.taskbarButton:CreateChild("BorderImage")
    indicator:SetSize(self.taskbarButton.minWidth - 8, 2)
    indicator:SetPosition(4, TASKBAR_HEIGHT - 9)
    indicator.color = Colors.Accent
    indicator:SetName("Indicator")

    SubscribeToEvent(self.taskbarButton, "HoverBegin", function()
        if activeWindow ~= self or self.isMinimized then
            self.taskbarButton.color = Colors.TaskbarHover
        end
    end)
    SubscribeToEvent(self.taskbarButton, "HoverEnd", function()
        if activeWindow ~= self or self.isMinimized then
            self.taskbarButton.color = Color(0, 0, 0, 0)
        end
    end)
    SubscribeToEvent(self.taskbarButton, "Released", function()
        if self.isMinimized then
            self:restore()
        elseif activeWindow == self then
            self:minimize()
        else
            self:activate()
        end
    end)

    self:updateTaskbarButton()
end

function Window:updateTaskbarButton()
    if not self.taskbarButton then return end

    local indicator = self.taskbarButton:GetChild("Indicator", false)
    if indicator then
        if activeWindow == self and not self.isMinimized then
            indicator.visible = true
            self.taskbarButton.color = Color(1, 1, 1, 0.15)
        else
            indicator.visible = false
            self.taskbarButton.color = Color(0, 0, 0, 0)
        end
    end
end

-- ============================================================================
-- Desktop Icons
-- ============================================================================
local function CreateDesktopIcon(name, x, y, iconColor, iconType, onClick)
    local icon = desktop:CreateChild("Button")
    icon:SetSize(DESKTOP_ICON_SIZE, DESKTOP_ICON_SIZE + 18)
    icon:SetPosition(x, y)
    icon.color = Color(0, 0, 0, 0)

    -- Icon container
    local iconContainer = icon:CreateChild("UIElement")
    iconContainer:SetSize(48, 48)
    iconContainer:SetPosition((DESKTOP_ICON_SIZE - 48) / 2, 4)

    -- Draw appropriate icon based on type
    if iconType == "folder" then
        DrawFolderIcon(iconContainer, 48)
    elseif iconType == "notepad" then
        DrawNotepadIcon(iconContainer, 48)
    elseif iconType == "calculator" then
        DrawCalculatorIcon(iconContainer, 48)
    elseif iconType == "browser" then
        DrawBrowserIcon(iconContainer, 48)
    elseif iconType == "recycle" then
        DrawRecycleBinIcon(iconContainer, 48)
    elseif iconType == "settings" then
        DrawSettingsIcon(iconContainer, 48)
    elseif iconType == "info" then
        DrawInfoIcon(iconContainer, 48)
    else
        -- Default colored square
        local defaultIcon = iconContainer:CreateChild("BorderImage")
        defaultIcon:SetSize(44, 44)
        defaultIcon:SetPosition(2, 2)
        defaultIcon.color = iconColor
    end

    -- Icon label with shadow effect
    local labelShadow = icon:CreateChild("Text")
    labelShadow:SetFont(CreateFont(11))
    labelShadow.text = name
    labelShadow.color = Color(0, 0, 0, 0.5)
    labelShadow:SetAlignment(HA_CENTER, VA_TOP)
    labelShadow:SetPosition(1, 57)

    local iconText = icon:CreateChild("Text")
    iconText:SetFont(CreateFont(11))
    iconText.text = name
    iconText.color = Colors.TextLight
    iconText:SetAlignment(HA_CENTER, VA_TOP)
    iconText:SetPosition(0, 56)

    SubscribeToEvent(icon, "HoverBegin", function()
        icon.color = Color(1, 1, 1, 0.15)
    end)
    SubscribeToEvent(icon, "HoverEnd", function()
        icon.color = Color(0, 0, 0, 0)
    end)
    SubscribeToEvent(icon, "Released", function()
        if onClick then onClick() end
    end)

    return icon
end

-- ============================================================================
-- Start Menu
-- ============================================================================
local function CreateStartMenu()
    local graphics = GetGraphics()

    startMenu = desktop:CreateChild("Window")
    startMenu:SetSize(START_MENU_WIDTH, START_MENU_HEIGHT)
    startMenu:SetPosition(0, graphics.height - TASKBAR_HEIGHT - START_MENU_HEIGHT)
    startMenu.color = Colors.StartMenu
    startMenu:SetMovable(false)
    startMenu.visible = false

    -- User section at top
    local userSection = startMenu:CreateChild("UIElement")
    userSection:SetSize(START_MENU_WIDTH, 50)
    userSection:SetPosition(0, 0)

    local userBg = userSection:CreateChild("BorderImage")
    userBg:SetSize(START_MENU_WIDTH, 50)
    userBg.color = Color(0.12, 0.12, 0.12, 1.0)

    -- User avatar
    local avatar = userSection:CreateChild("BorderImage")
    avatar:SetSize(32, 32)
    avatar:SetPosition(12, 9)
    avatar.color = Colors.TileBlue

    local avatarInner = avatar:CreateChild("BorderImage")
    avatarInner:SetSize(16, 16)
    avatarInner:SetAlignment(HA_CENTER, VA_CENTER)
    avatarInner.color = Colors.TextLight

    local userName = userSection:CreateChild("Text")
    userName:SetFont(CreateFont(13))
    userName.text = "User"
    userName.color = Colors.TextLight
    userName:SetPosition(52, 16)

    -- "Pinned" section title
    local tilesTitle = startMenu:CreateChild("Text")
    tilesTitle:SetFont(CreateFont(12))
    tilesTitle.text = "Pinned"
    tilesTitle.color = Colors.TextLight
    tilesTitle:SetPosition(16, 65)

    -- App tiles
    local tiles = {
        {name = "Notepad", color = Colors.TileBlue, action = "notepad", iconType = "notepad"},
        {name = "Calculator", color = Colors.TileGreen, action = "calculator", iconType = "calculator"},
        {name = "Files", color = Colors.TileOrange, action = "files", iconType = "folder"},
        {name = "Edge", color = Colors.TileCyan, action = "browser", iconType = "browser"},
        {name = "Settings", color = Colors.TileGray, action = "settings", iconType = "settings"},
        {name = "About", color = Colors.TilePurple, action = "about", iconType = "info"},
    }

    local tileSize = 88
    local tileMargin = 6
    local tilesPerRow = 6

    for i, tile in ipairs(tiles) do
        local row = math.floor((i - 1) / tilesPerRow)
        local col = (i - 1) % tilesPerRow

        local tileBtn = startMenu:CreateChild("Button")
        tileBtn:SetSize(tileSize, tileSize)
        tileBtn:SetPosition(16 + col * (tileSize + tileMargin), 90 + row * (tileSize + tileMargin))
        tileBtn.color = tile.color

        -- Draw icon on tile
        local tileIconContainer = tileBtn:CreateChild("UIElement")
        tileIconContainer:SetSize(36, 36)
        tileIconContainer:SetAlignment(HA_CENTER, VA_CENTER)
        tileIconContainer:SetPosition(0, -8)

        local tileIconBg = tileIconContainer:CreateChild("BorderImage")
        tileIconBg:SetSize(36, 36)
        tileIconBg.color = Color(1, 1, 1, 0.9)

        -- Tile name at bottom
        local tileName = tileBtn:CreateChild("Text")
        tileName:SetFont(CreateFont(10))
        tileName.text = tile.name
        tileName.color = Colors.TextLight
        tileName:SetAlignment(HA_LEFT, VA_BOTTOM)
        tileName:SetPosition(6, -6)

        local originalColor = tile.color
        SubscribeToEvent(tileBtn, "HoverBegin", function()
            tileBtn.color = Color(originalColor.r * 1.15, originalColor.g * 1.15, originalColor.b * 1.15, 1.0)
        end)
        SubscribeToEvent(tileBtn, "HoverEnd", function()
            tileBtn.color = originalColor
        end)
        SubscribeToEvent(tileBtn, "Released", function()
            ToggleStartMenu()
            LaunchApp(tile.action)
        end)
    end

    -- Power section at bottom
    local powerSection = startMenu:CreateChild("UIElement")
    powerSection:SetSize(START_MENU_WIDTH, 48)
    powerSection:SetPosition(0, START_MENU_HEIGHT - 48)

    local powerBg = powerSection:CreateChild("BorderImage")
    powerBg:SetSize(START_MENU_WIDTH, 48)
    powerBg.color = Color(0.08, 0.08, 0.08, 1.0)

    -- Power button
    local powerBtn = powerSection:CreateChild("Button")
    powerBtn:SetSize(40, 40)
    powerBtn:SetPosition(START_MENU_WIDTH - 48, 4)
    powerBtn.color = Color(0, 0, 0, 0)

    -- Power icon (circle with line)
    local powerCircle = powerBtn:CreateChild("BorderImage")
    powerCircle:SetSize(20, 20)
    powerCircle:SetAlignment(HA_CENTER, VA_CENTER)
    powerCircle.color = Colors.TextLight

    local powerInner = powerBtn:CreateChild("BorderImage")
    powerInner:SetSize(12, 12)
    powerInner:SetAlignment(HA_CENTER, VA_CENTER)
    powerInner.color = Color(0.08, 0.08, 0.08, 1.0)

    local powerLine = powerBtn:CreateChild("BorderImage")
    powerLine:SetSize(2, 8)
    powerLine:SetAlignment(HA_CENTER, VA_CENTER)
    powerLine:SetPosition(0, -4)
    powerLine.color = Colors.TextLight

    SubscribeToEvent(powerBtn, "HoverBegin", function()
        powerBtn.color = Color(1, 1, 1, 0.1)
    end)
    SubscribeToEvent(powerBtn, "HoverEnd", function()
        powerBtn.color = Color(0, 0, 0, 0)
    end)
    SubscribeToEvent(powerBtn, "Released", function()
        engine:Exit()
    end)
end

function ToggleStartMenu()
    isStartMenuOpen = not isStartMenuOpen
    if startMenu then
        startMenu.visible = isStartMenuOpen
        if isStartMenuOpen then
            BringToFront(startMenu)
        end
    end
end

-- ============================================================================
-- Taskbar
-- ============================================================================
local function CreateTaskbar()
    local graphics = GetGraphics()

    -- Taskbar container (no layout - use manual positioning for fixed screen-width element)
    taskbar = desktop:CreateChild("UIElement")
    taskbar:SetSize(graphics.width, TASKBAR_HEIGHT)
    taskbar:SetPosition(0, graphics.height - TASKBAR_HEIGHT)
    taskbar.priority = 100

    -- Background
    local taskbarBg = taskbar:CreateChild("BorderImage")
    taskbarBg:SetSize(graphics.width, TASKBAR_HEIGHT)
    taskbarBg.color = Colors.Taskbar

    -- Start button
    local startBtn = taskbar:CreateChild("Button")
    startBtn:SetSize(48, TASKBAR_HEIGHT)
    startBtn:SetPosition(0, 0)
    startBtn.color = Color(0, 0, 0, 0)

    -- Windows logo (4 squares in 2x2 grid)
    local logoContainer = startBtn:CreateChild("UIElement")
    logoContainer:SetSize(18, 18)
    logoContainer:SetAlignment(HA_CENTER, VA_CENTER)

    local logoSize = 7
    local logoGap = 2
    for i = 0, 1 do
        for j = 0, 1 do
            local square = logoContainer:CreateChild("BorderImage")
            square:SetSize(logoSize, logoSize)
            square:SetPosition(j * (logoSize + logoGap), i * (logoSize + logoGap))
            square.color = Colors.TextLight
        end
    end

    SubscribeToEvent(startBtn, "HoverBegin", function()
        startBtn.color = Colors.TaskbarHover
    end)
    SubscribeToEvent(startBtn, "HoverEnd", function()
        startBtn.color = Color(0, 0, 0, 0)
    end)
    SubscribeToEvent(startBtn, "Released", function()
        ToggleStartMenu()
    end)

    -- Search box
    local searchBox = taskbar:CreateChild("BorderImage")
    searchBox:SetSize(240, TASKBAR_HEIGHT - 10)
    searchBox:SetPosition(52, 5)
    searchBox.color = Color(1, 1, 1, 0.08)

    -- Search icon
    local searchIcon = searchBox:CreateChild("BorderImage")
    searchIcon:SetSize(14, 14)
    searchIcon:SetPosition(8, (TASKBAR_HEIGHT - 10 - 14) / 2)
    searchIcon.color = Color(1, 1, 1, 0.5)

    local searchText = searchBox:CreateChild("Text")
    searchText:SetFont(CreateFont(11))
    searchText.text = "Type here to search"
    searchText.color = Color(1, 1, 1, 0.5)
    searchText:SetPosition(28, 7)

    -- Window buttons area (uses Layout for dynamic window buttons)
    local windowButtons = taskbar:CreateChild("UIElement")
    windowButtons:SetSize(graphics.width - 480, TASKBAR_HEIGHT - 6)
    windowButtons:SetPosition(300, 3)
    windowButtons:SetLayout(LM_HORIZONTAL, 2)
    windowButtons:SetName("WindowButtons")

    -- System tray area (right side, fixed position)
    local systrayWidth = 140
    local systray = taskbar:CreateChild("UIElement")
    systray:SetSize(systrayWidth, TASKBAR_HEIGHT)
    systray:SetPosition(graphics.width - systrayWidth - 10, 0)

    -- System icons
    local iconContainer = systray:CreateChild("UIElement")
    iconContainer:SetSize(45, TASKBAR_HEIGHT)
    iconContainer:SetPosition(0, 0)

    local iconX = 4
    local icons = {"^", "~", "#"}  -- notification, wifi, volume symbols
    for _, iconSymbol in ipairs(icons) do
        local sysIcon = iconContainer:CreateChild("Text")
        sysIcon:SetFont(CreateFont(10))
        sysIcon.text = iconSymbol
        sysIcon.color = Colors.TextLight
        sysIcon:SetPosition(iconX, 12)
        iconX = iconX + 14
    end

    -- Clock
    local clockContainer = systray:CreateChild("UIElement")
    clockContainer:SetSize(80, TASKBAR_HEIGHT)
    clockContainer:SetPosition(50, 0)

    clockText = clockContainer:CreateChild("Text")
    clockText:SetFont(CreateFont(10))
    clockText.color = Colors.TextLight
    clockText:SetAlignment(HA_CENTER, VA_CENTER)

    UpdateClock()
end

function UpdateClock()
    if clockText then
        local timeStr = os.date("%H:%M")
        local dateStr = os.date("%Y/%m/%d")
        clockText.text = timeStr .. "\n" .. dateStr
    end
end

-- ============================================================================
-- Applications
-- ============================================================================
function LaunchApp(appName)
    if appName == "notepad" then
        LaunchNotepad()
    elseif appName == "calculator" then
        LaunchCalculator()
    elseif appName == "files" then
        LaunchFileExplorer()
    elseif appName == "browser" then
        LaunchBrowser()
    elseif appName == "settings" then
        LaunchSettings()
    elseif appName == "about" then
        LaunchAbout()
    end
end

function LaunchNotepad()
    local win = Window.new("Notepad", 150, 60, 620, 450, {iconColor = Colors.TileBlue})
    win:create(desktop)

    local MENU_HEIGHT = 24
    local STATUS_HEIGHT = 22

    -- Content area uses vertical layout (Pattern 1: Header, Content, Footer)
    win.contentArea:SetLayout(LM_VERTICAL, 0, IntRect(0, 0, 0, 0))

    -- Menu bar (fixed height)
    local menuBar = win.contentArea:CreateChild("BorderImage")
    menuBar:SetFixedHeight(MENU_HEIGHT)
    menuBar:SetLayout(LM_HORIZONTAL, 0, IntRect(8, 0, 0, 0))
    menuBar.color = Color(0.96, 0.96, 0.96, 1.0)

    local menus = {"File", "Edit", "Format", "View", "Help"}
    for _, menuName in ipairs(menus) do
        local menuItem = menuBar:CreateChild("Button")
        menuItem:SetFixedSize(44, MENU_HEIGHT)
        menuItem.color = Color(0, 0, 0, 0)

        local menuText = menuItem:CreateChild("Text")
        menuText:SetFont(CreateFont(10))
        menuText.text = menuName
        menuText.color = Colors.TextDark
        menuText:SetAlignment(HA_CENTER, VA_CENTER)

        SubscribeToEvent(menuItem, "HoverBegin", function()
            menuItem.color = Color(0.9, 0.9, 0.9, 1.0)
        end)
        SubscribeToEvent(menuItem, "HoverEnd", function()
            menuItem.color = Color(0, 0, 0, 0)
        end)
    end

    -- Text area (flexible, fills remaining space)
    local textArea = win.contentArea:CreateChild("BorderImage")
    textArea:SetMinSize(0, 200)  -- ✅ 宽度不限，高度至少 200
    textArea:SetLayoutFlexScale(Vector2(1, 1))
    textArea.color = Color(1, 1, 1, 1.0)

    local text = textArea:CreateChild("Text")
    text:SetFont(CreateFont(12))
    text.text = "Welcome to Notepad\n\nThis is a Windows 10 style text editor.\n\nFeatures:\n  - Clean, modern Fluent Design interface\n  - Simple and intuitive layout\n  - Professional appearance\n\nStart typing your notes here..."
    text.color = Colors.TextDark
    text:SetPosition(8, 8)
    text:SetWordwrap(true)

    -- Status bar (fixed height at bottom)
    local statusBar = win.contentArea:CreateChild("BorderImage")
    statusBar:SetFixedHeight(STATUS_HEIGHT)
    statusBar:SetLayout(LM_HORIZONTAL, 0, IntRect(8, 0, 0, 0))
    statusBar.color = Color(0.96, 0.96, 0.96, 1.0)

    local statusText = statusBar:CreateChild("Text")
    statusText:SetFont(CreateFont(9))
    statusText.text = "Ln 1, Col 1        100%        Windows (CRLF)        UTF-8"
    statusText.color = Colors.TextGray
    statusText:SetAlignment(HA_LEFT, VA_CENTER)
end

function LaunchCalculator()
    local win = Window.new("Calculator", 300, 100, 320, 480, {iconColor = Colors.TileGreen})
    win:create(desktop)

    local DISPLAY_HEIGHT = 90
    local BTN_SPACING = 2
    local PADDING = 6

    -- Content area uses vertical layout
    win.contentArea:SetLayout(LM_VERTICAL, 0, IntRect(0, 0, 0, 0))

    -- Display area (fixed height)
    local displayArea = win.contentArea:CreateChild("BorderImage")
    displayArea:SetFixedHeight(DISPLAY_HEIGHT)
    displayArea.color = Color(0.96, 0.96, 0.96, 1.0)

    -- Mode label
    local modeLabel = displayArea:CreateChild("Text")
    modeLabel:SetFont(CreateFont(11))
    modeLabel.text = "Standard"
    modeLabel.color = Colors.TextDark
    modeLabel:SetPosition(12, 8)

    calcDisplay = displayArea:CreateChild("Text")
    calcDisplay:SetFont(CreateFont(42))
    calcDisplay.text = "0"
    calcDisplay.color = Colors.TextDark
    calcDisplay:SetAlignment(HA_RIGHT, VA_BOTTOM)
    calcDisplay:SetPosition(-16, -8)

    calcValue = "0"
    calcOperator = nil
    calcPrevValue = nil
    calcNewInput = true

    -- Button area (flexible, fills remaining space)
    local btnArea = win.contentArea:CreateChild("UIElement")
    btnArea:SetMinSize(0, 300)  -- ✅ 宽度不限，高度至少 300（6 行 × 50px）
    btnArea:SetLayoutFlexScale(Vector2(1, 1))
    btnArea:SetLayout(LM_VERTICAL, BTN_SPACING, IntRect(PADDING, 0, PADDING, PADDING))

    -- Calculator buttons
    local buttons = {
        {"%", "CE", "C", "<-"},
        {"1/x", "x2", "sqrt", "/"},
        {"7", "8", "9", "*"},
        {"4", "5", "6", "-"},
        {"1", "2", "3", "+"},
        {"+/-", "0", ".", "="},
    }

    for row, rowBtns in ipairs(buttons) do
        -- Each row is a horizontal layout
        local rowElement = btnArea:CreateChild("UIElement")
        rowElement:SetMinHeight(50)  -- Minimum height for each row
        rowElement:SetLayoutFlexScale(Vector2(1, 1))  -- Equal height distribution
        rowElement:SetLayout(LM_HORIZONTAL, BTN_SPACING, IntRect(0, 0, 0, 0))

        for col, btnText in ipairs(rowBtns) do
            local btn = rowElement:CreateChild("Button")
            btn:SetMinSize(50, 50)  -- Minimum size for each button
            btn:SetLayoutFlexScale(Vector2(1, 1))  -- Equal width distribution

            -- Different colors for different button types
            local isNumber = (btnText >= "0" and btnText <= "9") or btnText == "." or btnText == "+/-"
            local isOperator = btnText == "/" or btnText == "*" or btnText == "-" or btnText == "+"
            local isEquals = btnText == "="

            if isEquals then
                btn.color = Colors.Accent
            elseif isNumber then
                btn.color = Color(0.98, 0.98, 0.98, 1.0)
            else
                btn.color = Color(0.94, 0.94, 0.94, 1.0)
            end

            local originalColor = Color(btn.color)

            local text = btn:CreateChild("Text")
            text:SetFont(CreateFont(16))

            -- Display friendly symbols
            local displayText = btnText
            if btnText == "*" then displayText = "x"
            elseif btnText == "/" then displayText = "/"
            elseif btnText == "<-" then displayText = "<"
            elseif btnText == "sqrt" then displayText = "sqrt"
            elseif btnText == "x2" then displayText = "x2"
            elseif btnText == "1/x" then displayText = "1/x"
            end

            text.text = displayText
            text.color = isEquals and Colors.TextLight or Colors.TextDark
            text:SetAlignment(HA_CENTER, VA_CENTER)

            SubscribeToEvent(btn, "HoverBegin", function()
                btn.color = Color(originalColor.r * 0.94, originalColor.g * 0.94, originalColor.b * 0.94, 1.0)
            end)
            SubscribeToEvent(btn, "HoverEnd", function()
                btn.color = originalColor
            end)
            SubscribeToEvent(btn, "Released", function()
                HandleCalculatorButton(btnText)
            end)
        end
    end

    -- Force layout update after all children are created
    win.contentArea:UpdateLayout()
end

function HandleCalculatorButton(btn)
    if btn >= "0" and btn <= "9" then
        if calcNewInput then
            calcValue = btn
            calcNewInput = false
        else
            if calcValue == "0" then
                calcValue = btn
            else
                calcValue = calcValue .. btn
            end
        end
    elseif btn == "." then
        if calcNewInput then
            calcValue = "0."
            calcNewInput = false
        elseif not string.find(calcValue, "%.") then
            calcValue = calcValue .. "."
        end
    elseif btn == "C" or btn == "CE" then
        calcValue = "0"
        calcOperator = nil
        calcPrevValue = nil
        calcNewInput = true
    elseif btn == "<-" then
        if #calcValue > 1 then
            calcValue = string.sub(calcValue, 1, -2)
        else
            calcValue = "0"
        end
    elseif btn == "+/-" then
        local num = tonumber(calcValue)
        if num then
            calcValue = tostring(-num)
        end
    elseif btn == "%" then
        local num = tonumber(calcValue)
        if num then
            calcValue = tostring(num / 100)
        end
    elseif btn == "x2" then
        local num = tonumber(calcValue)
        if num then
            calcValue = tostring(num * num)
        end
    elseif btn == "sqrt" then
        local num = tonumber(calcValue)
        if num and num >= 0 then
            calcValue = tostring(math.sqrt(num))
        end
    elseif btn == "1/x" then
        local num = tonumber(calcValue)
        if num and num ~= 0 then
            calcValue = tostring(1 / num)
        end
    elseif btn == "/" or btn == "*" or btn == "-" or btn == "+" then
        if calcPrevValue and calcOperator and not calcNewInput then
            calcValue = CalculateResult()
        end
        calcPrevValue = calcValue
        calcOperator = btn
        calcNewInput = true
    elseif btn == "=" then
        if calcPrevValue and calcOperator then
            calcValue = CalculateResult()
            calcOperator = nil
            calcPrevValue = nil
            calcNewInput = true
        end
    end

    UpdateCalculatorDisplay()
end

function CalculateResult()
    local prev = tonumber(calcPrevValue)
    local curr = tonumber(calcValue)

    if not prev or not curr then return calcValue end

    local result = 0
    if calcOperator == "+" then
        result = prev + curr
    elseif calcOperator == "-" then
        result = prev - curr
    elseif calcOperator == "*" then
        result = prev * curr
    elseif calcOperator == "/" then
        if curr ~= 0 then
            result = prev / curr
        else
            return "Error"
        end
    end

    if result == math.floor(result) and math.abs(result) < 1e10 then
        return tostring(math.floor(result))
    else
        return string.format("%.10g", result)
    end
end

function UpdateCalculatorDisplay()
    if calcDisplay then
        local displayValue = calcValue
        if #displayValue > 16 then
            displayValue = string.sub(displayValue, 1, 16)
        end
        calcDisplay.text = displayValue
    end
end

function LaunchFileExplorer()
    local win = Window.new("File Explorer", 180, 80, 780, 500, {iconColor = Colors.TileOrange})
    win:create(desktop)

    local TOOLBAR_HEIGHT = 40
    local SIDEBAR_WIDTH = 180
    local STATUS_HEIGHT = 20
    local HEADER_HEIGHT = 24

    -- Content area uses vertical layout (Pattern 1: Header, Content, Footer)
    win.contentArea:SetLayout(LM_VERTICAL, 0, IntRect(0, 0, 0, 0))

    -- Toolbar (fixed height)
    local toolbar = win.contentArea:CreateChild("BorderImage")
    toolbar:SetFixedHeight(TOOLBAR_HEIGHT)
    toolbar:SetLayout(LM_HORIZONTAL, 4, IntRect(4, 4, 4, 4))
    toolbar.color = Color(0.96, 0.96, 0.96, 1.0)

    -- Navigation buttons
    local navBtns = {"<", ">", "^"}
    for i, symbol in ipairs(navBtns) do
        local btn = toolbar:CreateChild("Button")
        btn:SetFixedSize(32, 32)
        btn.color = Color(0.92, 0.92, 0.92, 1.0)

        local text = btn:CreateChild("Text")
        text:SetFont(CreateFont(14))
        text.text = symbol
        text.color = Colors.TextGray
        text:SetAlignment(HA_CENTER, VA_CENTER)
    end

    -- Address bar (flexible)
    local addressBar = toolbar:CreateChild("BorderImage")
    addressBar:SetMinWidth(100)  -- Minimum width for proper layout
    addressBar:SetLayoutFlexScale(Vector2(1, 0))
    addressBar:SetFixedHeight(28)
    addressBar.color = Color(1, 1, 1, 1.0)

    local addressText = addressBar:CreateChild("Text")
    addressText:SetFont(CreateFont(11))
    addressText.text = " > This PC > Local Disk (C:) > Users > User"
    addressText.color = Colors.TextDark
    addressText:SetPosition(8, 7)

    -- Middle section: sidebar + file area (flexible, fills remaining space)
    local middleSection = win.contentArea:CreateChild("UIElement")
    middleSection:SetMinSize(380, 150)  -- ✅ 宽至少 380 (180+200)，高至少 150
    middleSection:SetLayoutFlexScale(Vector2(1, 1))
    middleSection:SetLayout(LM_HORIZONTAL, 2, IntRect(0, 0, 0, 0))

    -- Sidebar (fixed width, flexible height)
    local sidebar = middleSection:CreateChild("BorderImage")
    sidebar:SetFixedWidth(SIDEBAR_WIDTH)  -- ✅ 固定宽度
    sidebar:SetMinHeight(150)  -- ✅ 最小高度约束
    sidebar:SetLayout(LM_VERTICAL, 2, IntRect(4, 8, 4, 4))
    sidebar.color = Color(0.97, 0.97, 0.97, 1.0)

    local quickItems = {
        {icon = "*", name = "Quick access"},
        {icon = ">", name = "Desktop"},
        {icon = ">", name = "Downloads"},
        {icon = ">", name = "Documents"},
        {icon = ">", name = "Pictures"},
    }

    for _, item in ipairs(quickItems) do
        local itemBtn = sidebar:CreateChild("Button")
        itemBtn:SetFixedHeight(26)
        itemBtn.color = Color(0, 0, 0, 0)

        local itemText = itemBtn:CreateChild("Text")
        itemText:SetFont(CreateFont(11))
        itemText.text = item.icon .. "  " .. item.name
        itemText.color = Colors.TextDark
        itemText:SetPosition(12, 6)

        SubscribeToEvent(itemBtn, "HoverBegin", function()
            itemBtn.color = Color(0.90, 0.90, 0.90, 1.0)
        end)
        SubscribeToEvent(itemBtn, "HoverEnd", function()
            itemBtn.color = Color(0, 0, 0, 0)
        end)
    end

    -- File area (flexible, fills remaining space)
    local fileArea = middleSection:CreateChild("BorderImage")
    fileArea:SetMinSize(200, 150)  -- ✅ 宽至少 200，高至少 150
    fileArea:SetLayoutFlexScale(Vector2(1, 1))
    fileArea:SetLayout(LM_VERTICAL, 0, IntRect(0, 0, 0, 0))
    fileArea.color = Color(1, 1, 1, 1.0)

    -- Column headers (fixed height)
    local headerBg = fileArea:CreateChild("BorderImage")
    headerBg:SetFixedHeight(HEADER_HEIGHT)
    headerBg.color = Color(0.97, 0.97, 0.97, 1.0)

    local headers = {
        {text = "Name", x = 8},
        {text = "Date modified", x = 260},
        {text = "Type", x = 400},
        {text = "Size", x = 500},
    }

    for _, header in ipairs(headers) do
        local headerText = headerBg:CreateChild("Text")
        headerText:SetFont(CreateFont(10))
        headerText.text = header.text
        headerText.color = Colors.TextDark
        headerText:SetPosition(header.x, 6)
    end

    -- File list area (flexible, fills remaining space in fileArea)
    local fileList = fileArea:CreateChild("UIElement")
    fileList:SetLayoutFlexScale(Vector2(1, 1))
    fileList:SetLayout(LM_VERTICAL, 0, IntRect(4, 2, 4, 2))

    -- Files
    local files = {
        {name = "Documents", type = "File folder", date = "11/20/2024", size = ""},
        {name = "Pictures", type = "File folder", date = "11/18/2024", size = ""},
        {name = "Downloads", type = "File folder", date = "11/25/2024", size = ""},
        {name = "readme.txt", type = "Text Document", date = "11/20/2024", size = "4 KB"},
        {name = "report.docx", type = "Word Document", date = "11/19/2024", size = "156 KB"},
        {name = "photo.jpg", type = "JPG File", date = "11/15/2024", size = "2.3 MB"},
    }

    for _, file in ipairs(files) do
        local fileItem = fileList:CreateChild("Button")
        fileItem:SetFixedHeight(24)
        fileItem.color = Color(0, 0, 0, 0)

        -- File icon
        local fileIcon = fileItem:CreateChild("BorderImage")
        fileIcon:SetSize(16, 16)
        fileIcon:SetPosition(4, 4)
        fileIcon.color = file.type == "File folder" and Colors.TileYellow or Colors.TileGray

        local fileName = fileItem:CreateChild("Text")
        fileName:SetFont(CreateFont(10))
        fileName.text = file.name
        fileName.color = Colors.TextDark
        fileName:SetPosition(26, 5)

        local fileDate = fileItem:CreateChild("Text")
        fileDate:SetFont(CreateFont(10))
        fileDate.text = file.date
        fileDate.color = Colors.TextGray
        fileDate:SetPosition(256, 5)

        local fileType = fileItem:CreateChild("Text")
        fileType:SetFont(CreateFont(10))
        fileType.text = file.type
        fileType.color = Colors.TextGray
        fileType:SetPosition(396, 5)

        local fileSize = fileItem:CreateChild("Text")
        fileSize:SetFont(CreateFont(10))
        fileSize.text = file.size
        fileSize.color = Colors.TextGray
        fileSize:SetPosition(496, 5)

        SubscribeToEvent(fileItem, "HoverBegin", function()
            fileItem.color = Color(0.92, 0.92, 0.92, 1.0)
        end)
        SubscribeToEvent(fileItem, "HoverEnd", function()
            fileItem.color = Color(0, 0, 0, 0)
        end)
    end

    -- Status bar (fixed height at bottom)
    local statusBar = win.contentArea:CreateChild("BorderImage")
    statusBar:SetFixedHeight(STATUS_HEIGHT)
    statusBar:SetLayout(LM_HORIZONTAL, 0, IntRect(8, 0, 0, 0))
    statusBar.color = Color(0.96, 0.96, 0.96, 1.0)

    local statusText = statusBar:CreateChild("Text")
    statusText:SetFont(CreateFont(9))
    statusText.text = "6 items"
    statusText.color = Colors.TextGray
    statusText:SetAlignment(HA_LEFT, VA_CENTER)
end

function LaunchBrowser()
    local win = Window.new("Microsoft Edge", 120, 40, 900, 600, {iconColor = Colors.TileCyan})
    win:create(desktop)

    local TAB_HEIGHT = 36
    local NAV_HEIGHT = 40
    local STATUS_HEIGHT = 20
    local PAGE_HEADER_HEIGHT = 80

    -- Content area uses vertical layout (Pattern 1: Header, Content, Footer)
    win.contentArea:SetLayout(LM_VERTICAL, 0, IntRect(0, 0, 0, 0))

    -- Tab bar (fixed height)
    local tabBar = win.contentArea:CreateChild("BorderImage")
    tabBar:SetFixedHeight(TAB_HEIGHT)
    tabBar:SetLayout(LM_HORIZONTAL, 4, IntRect(4, 2, 4, 2))
    tabBar.color = Color(0.94, 0.94, 0.94, 1.0)

    -- Tab
    local tab = tabBar:CreateChild("Button")
    tab:SetFixedSize(200, 32)
    tab:SetLayout(LM_HORIZONTAL, 4, IntRect(8, 0, 4, 0))
    tab.color = Color(1, 1, 1, 1.0)

    local tabIcon = tab:CreateChild("BorderImage")
    tabIcon:SetFixedSize(14, 14)
    tabIcon:SetAlignment(HA_LEFT, VA_CENTER)
    tabIcon.color = Colors.TileCyan

    local tabText = tab:CreateChild("Text")
    tabText:SetFont(CreateFont(10))
    tabText.text = "Example Website"
    tabText.color = Colors.TextDark
    tabText:SetAlignment(HA_LEFT, VA_CENTER)
    tabText:SetMinWidth(50)  -- Minimum width for proper layout
    tabText:SetLayoutFlexScale(Vector2(1, 0))

    local tabClose = tab:CreateChild("Button")
    tabClose:SetFixedSize(20, 20)
    tabClose:SetAlignment(HA_RIGHT, VA_CENTER)
    tabClose.color = Color(0, 0, 0, 0)

    local tabCloseX = tabClose:CreateChild("Text")
    tabCloseX:SetFont(CreateFont(10))
    tabCloseX.text = "x"
    tabCloseX.color = Colors.TextGray
    tabCloseX:SetAlignment(HA_CENTER, VA_CENTER)

    -- New tab button
    local newTab = tabBar:CreateChild("Button")
    newTab:SetFixedSize(28, 28)
    newTab.color = Color(0, 0, 0, 0)

    local newTabText = newTab:CreateChild("Text")
    newTabText:SetFont(CreateFont(16))
    newTabText.text = "+"
    newTabText.color = Colors.TextGray
    newTabText:SetAlignment(HA_CENTER, VA_CENTER)

    -- Navigation bar (fixed height)
    local navBar = win.contentArea:CreateChild("BorderImage")
    navBar:SetFixedHeight(NAV_HEIGHT)
    navBar:SetLayout(LM_HORIZONTAL, 4, IntRect(4, 4, 4, 4))
    navBar.color = Color(1, 1, 1, 1.0)

    -- Nav buttons
    local navBtns = {"<", ">", "O"}
    for i, symbol in ipairs(navBtns) do
        local btn = navBar:CreateChild("Button")
        btn:SetFixedSize(32, 32)
        btn.color = Color(0, 0, 0, 0)

        local text = btn:CreateChild("Text")
        text:SetFont(CreateFont(14))
        text.text = symbol
        text.color = Colors.TextGray
        text:SetAlignment(HA_CENTER, VA_CENTER)

        SubscribeToEvent(btn, "HoverBegin", function()
            btn.color = Color(0.94, 0.94, 0.94, 1.0)
        end)
        SubscribeToEvent(btn, "HoverEnd", function()
            btn.color = Color(0, 0, 0, 0)
        end)
    end

    -- Address bar (flexible)
    local addressBar = navBar:CreateChild("BorderImage")
    addressBar:SetMinWidth(100)  -- Minimum width for proper layout
    addressBar:SetLayoutFlexScale(Vector2(1, 0))
    addressBar:SetFixedHeight(30)
    addressBar.color = Color(0.96, 0.96, 0.96, 1.0)

    local lockIcon = addressBar:CreateChild("Text")
    lockIcon:SetFont(CreateFont(10))
    lockIcon.text = "[S]"
    lockIcon.color = Colors.TileGreen
    lockIcon:SetPosition(8, 9)

    local urlText = addressBar:CreateChild("Text")
    urlText:SetFont(CreateFont(11))
    urlText.text = "https://www.example.com"
    urlText.color = Colors.TextDark
    urlText:SetPosition(32, 8)

    -- Web content (flexible, fills remaining space)
    local webContent = win.contentArea:CreateChild("BorderImage")
    webContent:SetMinSize(0, 200)  -- ✅ 宽度不限，高度至少 200
    webContent:SetLayoutFlexScale(Vector2(1, 1))
    webContent:SetLayout(LM_VERTICAL, 0, IntRect(0, 0, 0, 0))
    webContent.color = Color(1, 1, 1, 1.0)

    -- Page header (fixed height)
    local pageHeader = webContent:CreateChild("BorderImage")
    pageHeader:SetFixedHeight(PAGE_HEADER_HEIGHT)
    pageHeader.color = Colors.Accent

    local pageTitle = pageHeader:CreateChild("Text")
    pageTitle:SetFont(CreateFont(32))
    pageTitle.text = "Example Website"
    pageTitle.color = Colors.TextLight
    pageTitle:SetAlignment(HA_CENTER, VA_CENTER)

    -- Page body (flexible)
    local pageBody = webContent:CreateChild("UIElement")
    pageBody:SetLayoutFlexScale(Vector2(1, 1))

    -- Page content
    local pageText = pageBody:CreateChild("Text")
    pageText:SetFont(CreateFont(12))
    pageText.text = "Welcome to Example Website\n\nThis is a simulated web browser in Windows 10 style.\n\nThe browser includes:\n  - Modern tab interface with close buttons\n  - Navigation controls (back, forward, refresh)\n  - Secure connection indicator\n  - Address bar with URL display\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit."
    pageText.color = Colors.TextDark
    pageText:SetPosition(24, 20)
    pageText:SetWordwrap(true)

    -- Status bar (fixed height at bottom)
    local statusBar = win.contentArea:CreateChild("BorderImage")
    statusBar:SetFixedHeight(STATUS_HEIGHT)
    statusBar:SetLayout(LM_HORIZONTAL, 0, IntRect(8, 0, 0, 0))
    statusBar.color = Color(0.97, 0.97, 0.97, 1.0)

    local statusText = statusBar:CreateChild("Text")
    statusText:SetFont(CreateFont(9))
    statusText.text = "Done"
    statusText.color = Colors.TextGray
    statusText:SetAlignment(HA_LEFT, VA_CENTER)
end

function LaunchSettings()
    local win = Window.new("Settings", 220, 100, 760, 500, {iconColor = Colors.TileGray})
    win:create(desktop)

    -- Header
    local header = win.contentArea:CreateChild("BorderImage")
    header:SetSize(win.width, 60)
    header:SetPosition(0, 0)
    header.color = Color(0.96, 0.96, 0.96, 1.0)

    local headerTitle = header:CreateChild("Text")
    headerTitle:SetFont(CreateFont(24))
    headerTitle.text = "Settings"
    headerTitle.color = Colors.TextDark
    headerTitle:SetPosition(24, 18)

    -- Settings categories
    local categories = {
        {name = "System", desc = "Display, sound, notifications, power", color = Colors.TileCyan},
        {name = "Devices", desc = "Bluetooth, printers, mouse", color = Colors.TileBlue},
        {name = "Network & Internet", desc = "Wi-Fi, airplane mode, VPN", color = Colors.TileGreen},
        {name = "Personalization", desc = "Background, lock screen, colors", color = Colors.TilePurple},
        {name = "Apps", desc = "Uninstall, defaults, optional features", color = Colors.TileOrange},
        {name = "Accounts", desc = "Your accounts, email, sync", color = Colors.TileBlue},
        {name = "Time & Language", desc = "Speech, region, date", color = Colors.TileCyan},
        {name = "Update & Security", desc = "Windows Update, recovery", color = Colors.TileGreen},
    }

    local catY = 75
    local catCol = 0
    local catWidth = 360
    local catHeight = 65

    for i, cat in ipairs(categories) do
        local catBtn = win.contentArea:CreateChild("Button")
        catBtn:SetSize(catWidth, catHeight)
        catBtn:SetPosition(16 + catCol * (catWidth + 12), catY)
        catBtn.color = Color(1, 1, 1, 1.0)

        -- Category icon
        local catIcon = catBtn:CreateChild("BorderImage")
        catIcon:SetSize(36, 36)
        catIcon:SetPosition(12, 14)
        catIcon.color = cat.color

        local catIconInner = catIcon:CreateChild("BorderImage")
        catIconInner:SetSize(18, 18)
        catIconInner:SetAlignment(HA_CENTER, VA_CENTER)
        catIconInner.color = Colors.TextLight

        local catName = catBtn:CreateChild("Text")
        catName:SetFont(CreateFont(13))
        catName.text = cat.name
        catName.color = Colors.TextDark
        catName:SetPosition(58, 14)

        local catDesc = catBtn:CreateChild("Text")
        catDesc:SetFont(CreateFont(10))
        catDesc.text = cat.desc
        catDesc.color = Colors.TextGray
        catDesc:SetPosition(58, 34)

        SubscribeToEvent(catBtn, "HoverBegin", function()
            catBtn.color = Color(0.95, 0.95, 0.95, 1.0)
        end)
        SubscribeToEvent(catBtn, "HoverEnd", function()
            catBtn.color = Color(1, 1, 1, 1.0)
        end)

        catCol = catCol + 1
        if catCol >= 2 then
            catCol = 0
            catY = catY + catHeight + 8
        end
    end
end

function LaunchAbout()
    local win = Window.new("About", 320, 180, 420, 340, {iconColor = Colors.TilePurple})
    win:create(desktop)

    -- Header with Windows logo
    local header = win.contentArea:CreateChild("BorderImage")
    header:SetSize(win.width, 90)
    header:SetPosition(0, 0)
    header.color = Colors.Accent

    -- Windows logo (4 white squares)
    local logoContainer = header:CreateChild("UIElement")
    logoContainer:SetSize(50, 50)
    logoContainer:SetAlignment(HA_CENTER, VA_CENTER)

    local logoSize = 22
    local logoGap = 4
    for i = 0, 1 do
        for j = 0, 1 do
            local square = logoContainer:CreateChild("BorderImage")
            square:SetSize(logoSize, logoSize)
            square:SetPosition(j * (logoSize + logoGap), i * (logoSize + logoGap))
            square.color = Colors.TextLight
        end
    end

    -- Content
    local content = win.contentArea:CreateChild("UIElement")
    content:SetSize(win.width - 48, win.height - WINDOW_TITLE_HEIGHT - 130)
    content:SetPosition(24, 100)

    local title = content:CreateChild("Text")
    title:SetFont(CreateFont(16))
    title.text = "Windows 10 Simulator"
    title.color = Colors.TextDark
    title:SetAlignment(HA_CENTER, VA_TOP)
    title:SetPosition(0, 0)

    local version = content:CreateChild("Text")
    version:SetFont(CreateFont(11))
    version.text = "Version 22H2 (OS Build 19045.3693)"
    version.color = Colors.TextGray
    version:SetAlignment(HA_CENTER, VA_TOP)
    version:SetPosition(0, 24)

    local info = content:CreateChild("Text")
    info:SetFont(CreateFont(10))
    info.text = "Built with UrhoX Game Engine\n\nThis is a simulation of Windows 10 interface,\ndemonstrating Fluent Design System,\nwindow management, and modern UI.\n\n(c) 2024 UrhoX Project"
    info.color = Colors.TextDark
    info:SetPosition(0, 52)
    info:SetWordwrap(true)

    -- OK button
    local okBtn = win.contentArea:CreateChild("Button")
    okBtn:SetSize(90, 30)
    okBtn:SetPosition(win.width - 110, win.height - WINDOW_TITLE_HEIGHT - 45)
    okBtn.color = Colors.Accent

    local okText = okBtn:CreateChild("Text")
    okText:SetFont(CreateFont(11))
    okText.text = "OK"
    okText.color = Colors.TextLight
    okText:SetAlignment(HA_CENTER, VA_CENTER)

    SubscribeToEvent(okBtn, "Released", function()
        win:close()
    end)
end

-- ============================================================================
-- Desktop Setup
-- ============================================================================
local function CreateSoftGradientBackground(parent, width, height)
    -- Windows 10 style gradient background
    -- Use many thin strips for smooth gradient (no visible banding)

    local stripCount = 180  -- Many strips for smooth transition
    local stripHeight = math.ceil(height / stripCount) + 1

    for i = 0, stripCount - 1 do
        local strip = parent:CreateChild("BorderImage")
        strip:SetSize(width, stripHeight)
        strip:SetPosition(0, i * (height / stripCount))

        -- Smooth gradient from top to bottom
        local t = i / stripCount
        -- Top: bright blue (0.0, 0.47, 0.84) -> Bottom: dark blue (0.0, 0.18, 0.38)
        local r = 0.0
        local g = 0.47 * (1 - t) + 0.18 * t
        local b = 0.84 * (1 - t) + 0.38 * t
        strip.color = Color(r, g, b, 1.0)
    end

    -- Subtle Windows logo (4 squares) in bottom-right
    local logoSize = 55
    local logoGap = 5
    local logoX = width - 155
    local logoY = height - 175
    local logoAlpha = 0.05

    for i = 0, 1 do
        for j = 0, 1 do
            local square = parent:CreateChild("BorderImage")
            square:SetSize(logoSize, logoSize)
            square:SetPosition(logoX + j * (logoSize + logoGap), logoY + i * (logoSize + logoGap))
            square.color = Color(1.0, 1.0, 1.0, logoAlpha)
        end
    end
end

local function CreateDesktop()
    local graphics = GetGraphics()

    desktop = ui.root:CreateChild("UIElement", "Desktop")
    desktop:SetSize(graphics.width, graphics.height)
    desktop:SetPosition(0, 0)

    -- Create soft gradient background
    CreateSoftGradientBackground(desktop, graphics.width, graphics.height)

    -- Desktop icons
    local iconX = 20
    local iconY = 16

    CreateDesktopIcon("This PC", iconX, iconY, Colors.TileOrange, "folder", function() LaunchFileExplorer() end)
    iconY = iconY + DESKTOP_ICON_SPACING
    CreateDesktopIcon("Recycle Bin", iconX, iconY, Colors.TileGray, "recycle", nil)
    iconY = iconY + DESKTOP_ICON_SPACING
    CreateDesktopIcon("Notepad", iconX, iconY, Colors.TileBlue, "notepad", function() LaunchNotepad() end)
    iconY = iconY + DESKTOP_ICON_SPACING
    CreateDesktopIcon("Calculator", iconX, iconY, Colors.TileGreen, "calculator", function() LaunchCalculator() end)
    iconY = iconY + DESKTOP_ICON_SPACING
    CreateDesktopIcon("Edge", iconX, iconY, Colors.TileCyan, "browser", function() LaunchBrowser() end)

    CreateTaskbar()
    CreateStartMenu()
end

-- ============================================================================
-- Event Handlers
-- ============================================================================
local function HandleKeyDown(eventType, eventData)
    local key = eventData["Key"]:GetInt()

    if key == KEY_ESCAPE then
        if isStartMenuOpen then
            ToggleStartMenu()
        else
            engine:Exit()
        end
    end
end

local function HandleMouseMove(eventType, eventData)
    -- Handle window dragging with MouseMove event for smoother response
    if draggingWindow then
        local mouseX = eventData["X"]:GetInt()
        local mouseY = eventData["Y"]:GetInt()
        draggingWindow.x = mouseX - dragOffsetX
        draggingWindow.y = mouseY - dragOffsetY
        draggingWindow.element:SetPosition(draggingWindow.x, draggingWindow.y)
    end
end

local function HandleMouseButtonUp(eventType, eventData)
    -- Stop dragging when mouse is released
    if draggingWindow then
        draggingWindow = nil
    end
end

local function HandleUpdate(eventType, eventData)
    UpdateClock()

    if taskbar then
        BringToFront(taskbar)
    end
    if startMenu and startMenu.visible then
        BringToFront(startMenu)
    end
end

-- ============================================================================
-- Main Entry Point
-- ============================================================================
function Start()
    SampleStart()
    input.mouseVisible = true

    local style = cache:GetResource("XMLFile", "UI/DefaultStyle.xml")
    ui.root.defaultStyle = style

    CreateDesktop()

    SubscribeToEvent("KeyDown", HandleKeyDown)
    SubscribeToEvent("Update", HandleUpdate)
    SubscribeToEvent("MouseMove", HandleMouseMove)
    SubscribeToEvent("MouseButtonUp", HandleMouseButtonUp)

    SampleInitMouseMode(MM_FREE)
end

function GetScreenJoystickPatchString()
    return "<patch>" ..
        "<add sel=\"/element/element[./attribute[@name='Name' and @value='Button0']]\">" ..
        "<attribute name=\"Is Visible\" value=\"false\" />" ..
        "</add>" ..
        "<add sel=\"/element/element[./attribute[@name='Name' and @value='Button1']]\">" ..
        "<attribute name=\"Is Visible\" value=\"false\" />" ..
        "</add>" ..
        "</patch>"
end
