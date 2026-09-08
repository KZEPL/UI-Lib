-- ============================================================
--  PREVIEWLIBARY - Converted from KYZENO X PANEL
--  Navigation on Left Side
-- ============================================================

local Release = "Release 1"

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ============================================================
--  COLORS & THEME
-- ============================================================
local THEME = {
    Scheme = Color3.fromRGB(0, 210, 230),
    Text = Color3.fromRGB(220, 235, 240),
    TextDisabled = Color3.fromRGB(150, 160, 170),
    WindowBg = Color3.fromRGB(8, 18, 22),
    ChildBg = Color3.fromRGB(12, 28, 34),
    PopupBg = Color3.fromRGB(20, 40, 48),
    Border = Color3.fromRGB(30, 55, 65),
    FrameBg = Color3.fromRGB(20, 40, 48),
    CheckMark = Color3.fromRGB(255, 255, 255),
    SliderGrab = Color3.fromRGB(255, 255, 255),
    MID = Color3.fromRGB(20, 40, 48),
    DARK = Color3.fromRGB(12, 28, 34),
    LIGHT = Color3.fromRGB(30, 55, 65),
    ACCENT = Color3.fromRGB(0, 210, 230),
    ACCENT_DARK = Color3.fromRGB(0, 150, 170),
    RED = Color3.fromRGB(255, 70, 70),
    GREEN = Color3.fromRGB(70, 255, 120),
    YELLOW = Color3.fromRGB(255, 210, 70),
    GRAY = Color3.fromRGB(150, 160, 170),
    WHITE = Color3.fromRGB(255, 255, 255),
}

-- ============================================================
--  CREATE UI
-- ============================================================
local SettingsGui = Instance.new("ScreenGui")
SettingsGui.Name = "PreviewLibaryUI"
SettingsGui.ResetOnSpawn = false
SettingsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SettingsGui.Parent = playerGui

-- Sizes
local UI_WIDTH = isMobile and 550 or 650
local UI_HEIGHT = isMobile and 400 or 480
local NAV_WIDTH = 50
local NAV_EXPANDED = 160

-- Main Window
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, UI_WIDTH, 0, UI_HEIGHT)
MainWindow.Position = UDim2.new(0.5, -UI_WIDTH / 2, 0.5, -UI_HEIGHT / 2)
MainWindow.BackgroundColor3 = THEME.WindowBg
MainWindow.BorderSizePixel = 0
MainWindow.Active = true
MainWindow.ZIndex = 1
MainWindow.Parent = SettingsGui
Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 6)

-- NoDrag system
local noDrag = {}
local function markNoDrag(gui) noDrag[gui] = true end

-- ============================================================
--  DRAGGING
-- ============================================================
local dragging = false
local dragStart = nil
local startPos = nil

MainWindow.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local objs = playerGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
        for _, obj in ipairs(objs) do
            local node = obj
            while node do
                if noDrag[node] then return end
                node = node.Parent
            end
        end
        dragging = true
        dragStart = input.Position
        startPos = MainWindow.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainWindow.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================================
--  HEADER
-- ============================================================
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = THEME.DARK
Header.BorderSizePixel = 0
Header.ZIndex = 10
Header.Parent = MainWindow
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 6)
markNoDrag(Header)

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 35, 0, 35)
Logo.Position = UDim2.new(0, 12, 0.5, -17.5)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://109578957492871"
Logo.ZIndex = 11
Logo.Parent = Header

-- Title
local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(0, 200, 0, 25)
TitleLbl.Position = UDim2.new(0, 55, 0, 8)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "KYZENO X"
TitleLbl.TextColor3 = THEME.ACCENT
TitleLbl.TextSize = 18
TitleLbl.Font = Enum.Font.Fantasy
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.ZIndex = 11
TitleLbl.Parent = Header

local SubLbl = Instance.new("TextLabel")
SubLbl.Size = UDim2.new(0, 180, 0, 12)
SubLbl.Position = UDim2.new(0, 55, 0, 32)
SubLbl.BackgroundTransparency = 1
SubLbl.Text = "v1 CP"
SubLbl.TextColor3 = THEME.GRAY
SubLbl.TextSize = 10
SubLbl.Font = Enum.Font.Gotham
SubLbl.TextXAlignment = Enum.TextXAlignment.Left
SubLbl.ZIndex = 11
SubLbl.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundColor3 = THEME.RED
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = THEME.WHITE
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 11
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
markNoDrag(CloseBtn)

CloseBtn.MouseButton1Click:Connect(function()
    MainWindow.Visible = false
    OpenButton.Visible = true
end)

-- Open Button (appears when window is closed)
local OpenButton = Instance.new("ImageButton")
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Position = UDim2.new(0.02, 0, 0.15, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OpenButton.BackgroundTransparency = 0.8
OpenButton.BorderSizePixel = 0
OpenButton.Image = "rbxassetid://109578957492871"
OpenButton.Visible = false
OpenButton.ZIndex = 100
OpenButton.Parent = SettingsGui
Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(0, 8)
markNoDrag(OpenButton)

OpenButton.MouseButton1Click:Connect(function()
    MainWindow.Visible = true
    OpenButton.Visible = false
end)

-- Make Open Button draggable
local openDrag = false
local openDragStart = nil
local openStartPos = nil

OpenButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        openDrag = true
        openDragStart = input.Position
        openStartPos = OpenButton.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        openDrag = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if openDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - openDragStart
        OpenButton.Position = UDim2.new(
            openStartPos.X.Scale,
            openStartPos.X.Offset + delta.X,
            openStartPos.Y.Scale,
            openStartPos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================================
--  LEFT SIDEBAR (Navigation)
-- ============================================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, NAV_WIDTH, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = THEME.DARK
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 10
Sidebar.Parent = MainWindow

local SidebarBorder = Instance.new("Frame")
SidebarBorder.Size = UDim2.new(0, 1, 1, 0)
SidebarBorder.Position = UDim2.new(1, -1, 0, 0)
SidebarBorder.BackgroundColor3 = THEME.Border
SidebarBorder.BorderSizePixel = 0
SidebarBorder.ZIndex = 11
SidebarBorder.Parent = Sidebar

-- Sidebar Scroll (for tabs)
local SidebarScroll = Instance.new("ScrollingFrame")
SidebarScroll.Size = UDim2.new(1, 0, 1, -20)
SidebarScroll.Position = UDim2.new(0, 0, 0, 5)
SidebarScroll.BackgroundTransparency = 1
SidebarScroll.BorderSizePixel = 0
SidebarScroll.ScrollBarThickness = 2
SidebarScroll.ScrollBarImageColor3 = THEME.Border
SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
SidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SidebarScroll.ZIndex = 11
SidebarScroll.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 4)
SidebarList.Parent = SidebarScroll

-- Tab Indicator
local TabIndicator = Instance.new("Frame")
TabIndicator.Size = UDim2.new(0, 2, 0, 24)
TabIndicator.Position = UDim2.new(1, -2, 0, 0)
TabIndicator.BackgroundColor3 = THEME.ACCENT
TabIndicator.BorderSizePixel = 0
TabIndicator.Visible = false
TabIndicator.ZIndex = 12
TabIndicator.Parent = Sidebar
Instance.new("UICorner", TabIndicator).CornerRadius = UDim.new(0, 2)

-- ============================================================
--  CONTENT AREA
-- ============================================================
local ContentArea = Instance.new("CanvasGroup")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -(NAV_WIDTH + 10), 1, -50)
ContentArea.Position = UDim2.new(0, NAV_WIDTH + 5, 0, 50)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel = 0
ContentArea.GroupTransparency = 0
ContentArea.ZIndex = 2
ContentArea.Parent = MainWindow

-- Content Scroll
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, 0, 1, 0)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 4
ContentScroll.ScrollBarImageColor3 = THEME.ACCENT
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentScroll.ZIndex = 3
ContentScroll.Parent = ContentArea

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 6)
ContentLayout.Parent = ContentScroll

local ContentPad = Instance.new("UIPadding")
ContentPad.PaddingTop = UDim.new(0, 8)
ContentPad.PaddingLeft = UDim.new(0, 8)
ContentPad.PaddingRight = UDim.new(0, 8)
ContentPad.PaddingBottom = UDim.new(0, 8)
ContentPad.Parent = ContentScroll

-- ============================================================
--  COLLAPSE BUTTON
-- ============================================================
local CollapseBtn = Instance.new("ImageButton")
CollapseBtn.Size = UDim2.new(0, 17, 0, 17)
CollapseBtn.Position = UDim2.new(1, 0, 0, 5)
CollapseBtn.BackgroundColor3 = THEME.ChildBg
CollapseBtn.Image = "rbxassetid://92473583511724"
CollapseBtn.ImageColor3 = THEME.TextDisabled
CollapseBtn.ZIndex = 15
CollapseBtn.Parent = Sidebar
Instance.new("UICorner", CollapseBtn).CornerRadius = UDim.new(1, 0)
markNoDrag(CollapseBtn)

local navbarCollapsed = true
local currentNavbarWidth = NAV_WIDTH

CollapseBtn.MouseButton1Click:Connect(function()
    navbarCollapsed = not navbarCollapsed
end)

-- ============================================================
--  STATE
-- ============================================================
local tabs = {}
local activeTabId = nil
local tabCount = 0
local targetIndicatorY = 0
local currentIndicatorY = 0

-- ============================================================
--  SWITCH TAB
-- ============================================================
local function switchTab(id)
    if activeTabId == id then return end
    
    for tabId, tabData in pairs(tabs) do
        if tabId == id then
            tabData.Icon.ImageColor3 = THEME.Text
            tabData.Text.TextColor3 = THEME.Text
            tabData.Container.Visible = true
            tabData.Container.GroupTransparency = 0
            targetIndicatorY = (id - 1) * 28 + 5
            TabIndicator.Visible = true
        else
            tabData.Icon.ImageColor3 = THEME.TextDisabled
            tabData.Text.TextColor3 = THEME.TextDisabled
            if tabData.Container.Visible then
                tabData.Container.Visible = false
            end
        end
    end
    activeTabId = id
end

-- ============================================================
--  RENDER LOOP
-- ============================================================
RunService.RenderStepped:Connect(function()
    local tW = navbarCollapsed and NAV_WIDTH or NAV_EXPANDED
    currentNavbarWidth = currentNavbarWidth + (tW - currentNavbarWidth) * 0.15
    Sidebar.Size = UDim2.new(0, currentNavbarWidth, 1, -50)
    
    currentIndicatorY = currentIndicatorY + (targetIndicatorY - currentIndicatorY) * 0.15
    TabIndicator.Position = UDim2.new(1, -2, 0, currentIndicatorY)
    
    local tR = navbarCollapsed and 0 or 180
    CollapseBtn.Rotation = CollapseBtn.Rotation + (tR - CollapseBtn.Rotation) * 0.15
    
    local contentAlpha = math.clamp((currentNavbarWidth - NAV_WIDTH) / 100, 0, 1)
    for _, tabData in pairs(tabs) do
        tabData.Text.TextTransparency = 1 - contentAlpha
    end
end)

-- ============================================================
--  ADD TAB
-- ============================================================
local function AddTab(id, name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 24)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 12
    btn.Parent = SidebarScroll

    local ic = Instance.new("ImageLabel")
    ic.Size = UDim2.new(0, 16, 0, 16)
    ic.Position = UDim2.new(0, 17, 0.5, -8)
    ic.BackgroundTransparency = 1
    ic.Image = icon or "rbxassetid://80758916183665"
    ic.ImageColor3 = THEME.TextDisabled
    ic.ZIndex = 13
    ic.Parent = btn

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 50, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = THEME.TextDisabled
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ClipsDescendants = true
    lbl.ZIndex = 13
    lbl.Parent = btn

    local container = Instance.new("CanvasGroup")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.GroupTransparency = 0
    container.Visible = false
    container.Parent = ContentScroll

    tabs[id] = { Button = btn, Icon = ic, Text = lbl, Container = container }

    markNoDrag(btn)
    btn.MouseButton1Click:Connect(function()
        if not navbarCollapsed then navbarCollapsed = true end
        switchTab(id)
    end)

    return container
end

-- ============================================================
--  UI ELEMENTS
-- ============================================================

-- Section Title
local function AddSectionTitle(parent, text)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 40)
    f.BackgroundTransparency = 1
    f.Parent = parent
    
    local h = Instance.new("TextLabel")
    h.Size = UDim2.new(1, 0, 0, 22)
    h.Position = UDim2.new(0, 0, 0, 15)
    h.BackgroundTransparency = 1
    h.Text = text
    h.TextColor3 = THEME.WHITE
    h.TextSize = 18
    h.Font = Enum.Font.Fantasy
    h.TextXAlignment = Enum.TextXAlignment.Left
    h.Parent = f
    
    local l = Instance.new("Frame")
    l.Size = UDim2.new(0, 50, 0, 2)
    l.Position = UDim2.new(0, 0, 0, 38)
    l.BackgroundColor3 = THEME.ACCENT
    l.BorderSizePixel = 0
    l.Parent = f
    
    return f
end

-- Info Label
local function AddInfoLabel(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = THEME.GRAY
    lbl.TextSize = 10
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.Parent = parent
    return lbl
end

-- Toggle
local function AddToggle(parent, labelText, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 34)
    container.BackgroundColor3 = THEME.MID
    container.BorderSizePixel = 1
    container.BorderColor3 = THEME.LIGHT
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = THEME.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 24)
    btn.Position = UDim2.new(1, -48, 0.5, -12)
    btn.BackgroundColor3 = default and THEME.ACCENT or THEME.LIGHT
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = THEME.WHITE
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = container
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local state = default or false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and THEME.ACCENT or THEME.LIGHT
        if callback then callback(state) end
    end)
    
    return container
end

-- Slider
local function AddSlider(parent, labelText, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = THEME.MID
    container.BorderSizePixel = 1
    container.BorderColor3 = THEME.LIGHT
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = THEME.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valLabel.Position = UDim2.new(0.7, 0, 0, 4)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(default or min)
    valLabel.TextColor3 = THEME.ACCENT
    valLabel.TextSize = 12
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = container

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 8)
    sliderBg.Position = UDim2.new(0, 12, 0, 30)
    sliderBg.BackgroundColor3 = THEME.DARK
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 4)

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.BackgroundColor3 = THEME.ACCENT
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 4)

    local currentVal = default or min
    local function updateSlider(val)
        val = math.clamp(val, min, max)
        valLabel.Text = tostring(math.floor(val))
        local pct = (val - min) / (max - min)
        sliderFill.Size = UDim2.new(pct, 0, 1, 0)
        if callback then callback(val) end
    end
    updateSlider(currentVal)

    local dragging = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local relX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            updateSlider(min + relX * (max - min))
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            updateSlider(min + relX * (max - min))
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return container
end

-- Dropdown
local function AddDropdown(parent, labelText, options, defaultOption, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 34)
    container.BackgroundColor3 = THEME.MID
    container.BorderSizePixel = 1
    container.BorderColor3 = THEME.LIGHT
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = THEME.Text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local currentVal = defaultOption or options[1]
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.45, 0, 0, 24)
    btn.Position = UDim2.new(0.52, 0, 0.5, -12)
    btn.BackgroundColor3 = THEME.LIGHT
    btn.Text = currentVal
    btn.TextColor3 = THEME.WHITE
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = container
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local optionIndex = 1
    for i, v in ipairs(options) do
        if v == currentVal then optionIndex = i break end
    end

    btn.MouseButton1Click:Connect(function()
        optionIndex = (optionIndex % #options) + 1
        local selected = options[optionIndex]
        btn.Text = selected
        if callback then callback(selected) end
    end)

    return container
end

-- Button
local function AddButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = THEME.ACCENT
    btn.Text = text
    btn.TextColor3 = THEME.WHITE
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Text Input
local function AddTextInput(parent, labelText, placeholder, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 38)
    container.BackgroundColor3 = THEME.MID
    container.BorderSizePixel = 1
    container.BorderColor3 = THEME.LIGHT
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.35, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = THEME.Text
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(0.4, 0, 0, 24)
    tb.Position = UDim2.new(0.37, 0, 0.5, -12)
    tb.BackgroundColor3 = THEME.DARK
    tb.BorderSizePixel = 0
    tb.Text = ""
    tb.PlaceholderText = placeholder
    tb.TextColor3 = THEME.WHITE
    tb.PlaceholderColor3 = THEME.GRAY
    tb.TextSize = 11
    tb.Font = Enum.Font.Gotham
    tb.ClearTextOnFocus = false
    tb.Parent = container
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 4)

    local goBtn = Instance.new("TextButton")
    goBtn.Size = UDim2.new(0, 40, 0, 24)
    goBtn.Position = UDim2.new(0.8, 0, 0.5, -12)
    goBtn.BackgroundColor3 = THEME.ACCENT
    goBtn.Text = "GO"
    goBtn.TextColor3 = THEME.WHITE
    goBtn.TextSize = 10
    goBtn.Font = Enum.Font.GothamBold
    goBtn.Parent = container
    Instance.new("UICorner", goBtn).CornerRadius = UDim.new(0, 4)

    goBtn.MouseButton1Click:Connect(function() callback(tb.Text) end)
    return container, tb
end

-- ============================================================
--  MAKE SECTION
-- ============================================================
local function makeSection(parent, name)
    local hasHeader = name ~= nil and name ~= ""
    local headerH = hasHeader and 35 or 6

    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, headerH + 20)
    box.BackgroundColor3 = THEME.Border
    box.BorderSizePixel = 0
    box.Parent = parent
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -2, 1, -2)
    bg.Position = UDim2.new(0, 1, 0, 1)
    bg.BackgroundColor3 = THEME.ChildBg
    bg.BorderSizePixel = 0
    bg.Parent = box
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 3)

    if hasHeader then
        local hdr = Instance.new("TextLabel")
        hdr.Size = UDim2.new(1, -30, 0, 35)
        hdr.Position = UDim2.new(0, 15, 0, 0)
        hdr.BackgroundTransparency = 1
        hdr.Text = name
        hdr.TextColor3 = THEME.Text
        hdr.TextSize = 13
        hdr.Font = Enum.Font.GothamBold
        hdr.TextXAlignment = Enum.TextXAlignment.Left
        hdr.Parent = bg
    end

    local inner = Instance.new("Frame")
    inner.Name = "Inner"
    inner.Size = UDim2.new(1, -30, 0, 0)
    inner.Position = UDim2.new(0, 15, 0, headerH + 5)
    inner.BackgroundTransparency = 1
    inner.Parent = bg
    
    local il = Instance.new("UIListLayout", inner)
    il.SortOrder = Enum.SortOrder.LayoutOrder
    il.Padding = UDim.new(0, 8)

    local function resize()
        local h = il.AbsoluteContentSize.Y
        inner.Size = UDim2.new(1, -30, 0, h)
        box.Size = UDim2.new(1, 0, 0, headerH + 5 + h + 15)
    end
    il:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resize)
    task.wait(0.05)
    resize()

    return inner
end

-- ============================================================
--  PREVIEWLIBARY API
-- ============================================================
local PreviewLibary = {}
PreviewLibary.Flags = {}
PreviewLibary.Options = PreviewLibary.Flags
PreviewLibary.isMobile = isMobile
PreviewLibary._tabSections = {}

local ElementMethods = {}

function ElementMethods:CreateSection(name)
    local inner = makeSection(self.Inner, name)
    return setmetatable({ Inner = inner, _parent = self }, { __index = ElementMethods })
end

function ElementMethods:CreateButton(cfg)
    cfg = cfg or {}
    AddButton(self.Inner, cfg.Name or "Button", function()
        if cfg.Callback then cfg.Callback() end
    end)
    return {}
end

function ElementMethods:CreateToggle(cfg)
    cfg = cfg or {}
    local flag = cfg.Flag
    local value = cfg.CurrentValue or false
    if flag then PreviewLibary.Flags[flag] = value end
    AddToggle(self.Inner, cfg.Name or "Toggle", value, function(v)
        if flag then PreviewLibary.Flags[flag] = v end
        if cfg.Callback then cfg.Callback(v) end
    end)
    return {}
end

function ElementMethods:CreateSlider(cfg)
    cfg = cfg or {}
    local range = cfg.Range or {0, 100}
    local flag = cfg.Flag
    local value = cfg.CurrentValue or range[1]
    if flag then PreviewLibary.Flags[flag] = value end
    AddSlider(self.Inner, cfg.Name or "Slider", range[1], range[2], value, function(v)
        if flag then PreviewLibary.Flags[flag] = v end
        if cfg.Callback then cfg.Callback(v) end
    end)
    return {}
end

function ElementMethods:CreateDropdown(cfg)
    cfg = cfg or {}
    local options = cfg.Options or {}
    local defaultOption = cfg.CurrentOption or options[1]
    local flag = cfg.Flag
    if flag then PreviewLibary.Flags[flag] = defaultOption end
    AddDropdown(self.Inner, cfg.Name or "Dropdown", options, defaultOption, function(opt)
        if flag then PreviewLibary.Flags[flag] = opt end
        if cfg.Callback then cfg.Callback(opt) end
    end)
    return {
        SetValue = function(self, value)
            if flag then PreviewLibary.Flags[flag] = value end
            if cfg.Callback then cfg.Callback(value) end
        end,
        GetValue = function(self)
            if flag then return PreviewLibary.Flags[flag] end
            return nil
        end
    }
end

function ElementMethods:CreateColorPicker(cfg)
    cfg = cfg or {}
    local flag = cfg.Flag
    local color = cfg.Color or Color3.fromRGB(255, 255, 255)
    if flag then PreviewLibary.Flags[flag] = color end
    -- Simple color picker using buttons
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 30)
    row.BackgroundTransparency = 1
    row.Parent = self.Inner
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = cfg.Name or "Color Picker"
    lbl.TextColor3 = THEME.Text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    
    local preview = Instance.new("TextButton")
    preview.Size = UDim2.new(0, 30, 0, 20)
    preview.Position = UDim2.new(1, -35, 0.5, -10)
    preview.BackgroundColor3 = color
    preview.BorderSizePixel = 0
    preview.Text = ""
    preview.AutoButtonColor = false
    preview.Parent = row
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 4)
    
    -- Simple color preset picker
    preview.MouseButton1Click:Connect(function()
        local colors = {
            Color3.fromRGB(255, 70, 70), Color3.fromRGB(70, 255, 70),
            Color3.fromRGB(70, 70, 255), Color3.fromRGB(255, 255, 70),
            Color3.fromRGB(255, 70, 255), Color3.fromRGB(70, 255, 255),
            Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 140, 0),
            Color3.fromRGB(140, 0, 255), Color3.fromRGB(0, 210, 230),
        }
        
        local picker = Instance.new("Frame")
        picker.Size = UDim2.new(0, 200, 0, 150)
        picker.Position = UDim2.new(0.5, -100, 0.5, -75)
        picker.BackgroundColor3 = THEME.PopupBg
        picker.BorderSizePixel = 0
        picker.ZIndex = 250
        picker.Parent = MainWindow
        Instance.new("UICorner", picker).CornerRadius = UDim.new(0, 4)
        
        local grid = Instance.new("Frame")
        grid.Size = UDim2.new(1, -20, 1, -20)
        grid.Position = UDim2.new(0, 10, 0, 10)
        grid.BackgroundTransparency = 1
        grid.Parent = picker
        
        local ul = Instance.new("UIListLayout", grid)
        ul.FillDirection = Enum.FillDirection.Horizontal
        ul.SortOrder = Enum.SortOrder.LayoutOrder
        ul.Padding = UDim.new(0, 8)
        ul.Wrap = true
        
        for _, color in ipairs(colors) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 28, 0, 28)
            btn.BackgroundColor3 = color
            btn.BorderSizePixel = 0
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.Parent = grid
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            
            btn.MouseButton1Click:Connect(function()
                preview.BackgroundColor3 = color
                if flag then PreviewLibary.Flags[flag] = color end
                if cfg.Callback then cfg.Callback(color) end
                picker:Destroy()
            end)
        end
        
        local closeConn
        closeConn = UserInputService.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                task.wait()
                local mPos = UserInputService:GetMouseLocation()
                local ax, ay = picker.AbsolutePosition.X, picker.AbsolutePosition.Y
                local sx, sy = picker.AbsoluteSize.X, picker.AbsoluteSize.Y
                if mPos.X < ax or mPos.X > ax + sx or mPos.Y < ay or mPos.Y > ay + sy then
                    picker:Destroy()
                    closeConn:Disconnect()
                end
            end
        end)
    end)
    
    return {}
end

function ElementMethods:CreateInput(cfg)
    cfg = cfg or {}
    local flag = cfg.Flag
    AddTextInput(self.Inner, cfg.Name or "Input", cfg.PlaceholderText or "", function(txt)
        if flag then PreviewLibary.Flags[flag] = txt end
        if cfg.Callback then cfg.Callback(txt) end
    end)
    return {}
end

function ElementMethods:CreateLabel(text)
    AddInfoLabel(self.Inner, tostring(text))
    return {}
end

function ElementMethods:CreateParagraph(cfg)
    cfg = cfg or {}
    if cfg.Title then AddInfoLabel(self.Inner, cfg.Title) end
    if cfg.Content then AddInfoLabel(self.Inner, cfg.Content) end
    return {}
end

-- Tab Methods
local TabMethods = {}

function TabMethods:CreateSection(name)
    local inner = makeSection(self.Inner, name)
    return setmetatable({ Inner = inner, _tab = self }, { __index = ElementMethods })
end

-- Window Methods
local WindowMethods = {}

function WindowMethods:CreateTab(name, icon)
    tabCount = tabCount + 1
    local id = tabCount
    local container = AddTab(id, name or ("Tab " .. id), icon or "rbxassetid://80758916183665")

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Parent = container
    
    local inner = makeSection(content, nil)
    
    local tab = setmetatable({
        _id = id,
        Container = container,
        Inner = inner,
        _default = nil,
    }, { __index = TabMethods })

    if id == 1 then switchTab(1) end
    return tab
end

function PreviewLibary:CreateWindow(settings)
    settings = settings or {}
    if settings.Name then SettingsGui.Name = tostring(settings.Name) end
    return setmetatable({}, { __index = WindowMethods })
end

-- SaveManager compatibility
function PreviewLibary:ApplyFlags(flags)
    if not flags then return end
    for key, value in pairs(flags) do
        if self.Flags[key] ~= nil then
            self.Flags[key] = value
        end
    end
end

function PreviewLibary:Notify(data)
    data = data or {}
    print("🔔 " .. (data.Title or "Notification") .. ": " .. (data.Content or ""))
end

-- Keybind to toggle window (LeftAlt)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        MainWindow.Visible = not MainWindow.Visible
        OpenButton.Visible = not MainWindow.Visible
    end
end)

return PreviewLibary
