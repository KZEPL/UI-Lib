local PreviewLibary = {}
PreviewLibary.Release = "v2.0"

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local DEFAULT_THEME = {
    BG = Color3.fromRGB(8, 18, 22),
    DARK = Color3.fromRGB(12, 28, 34),
    MID = Color3.fromRGB(20, 40, 48),
    LIGHT = Color3.fromRGB(30, 55, 65),
    ACCENT = Color3.fromRGB(0, 210, 230),
    ACCENT_DARK = Color3.fromRGB(0, 150, 170),
    WHITE = Color3.fromRGB(255, 255, 255),
    GRAY = Color3.fromRGB(150, 160, 170),
    TEXT = Color3.fromRGB(220, 235, 240),
    RED = Color3.fromRGB(255, 70, 70),
    GREEN = Color3.fromRGB(70, 255, 120),
    YELLOW = Color3.fromRGB(255, 210, 70),
}

local UI = {}
UI.__index = UI

function UI.new(config)
    config = config or {}
    local self = setmetatable({}, UI)
    self.Name = config.Name or "PreviewLibary"
    self.Theme = config.Theme or DEFAULT_THEME
    self.Flags = {}
    self.Options = self.Flags
    self.Tabs = {}
    self.CurrentTab = nil
    self._contentAreas = {}
    self:_createGUI(config)
    return self
end

function UI:_createGUI(config)
    local UI_WIDTH = isMobile and 550 or 580
    local UI_HEIGHT = isMobile and 400 or 450
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = self.Name .. "_UI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.Parent = playerGui
    
    self:_createOpenButton()
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, UI_WIDTH, 0, UI_HEIGHT)
    self.MainFrame.Position = UDim2.new(0.5, -UI_WIDTH/2, 0.5, -UI_HEIGHT/2)
    self.MainFrame.BackgroundColor3 = self.Theme.BG
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Visible = false
    self.MainFrame.Parent = self.ScreenGui
    self:_round(self.MainFrame, 10)
    
    local stroke = Instance.new("UIStroke", self.MainFrame)
    stroke.Color = self.Theme.ACCENT
    stroke.Thickness = 1.5
    
    self:_makeDraggable(self.MainFrame, self.MainFrame)
    self:_createHeader()
    self:_createNavBar()
    self:_createSidebar()
    self:_createContentArea()
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftAlt then
            self.MainFrame.Visible = not self.MainFrame.Visible
        end
    end)
end

function UI:_createOpenButton()
    self.OpenButton = Instance.new("ImageButton")
    self.OpenButton.Size = UDim2.new(0, 50, 0, 50)
    self.OpenButton.Position = UDim2.new(0.02, 0, 0.15, 0)
    self.OpenButton.Image = "rbxassetid://109578957492871"
    self.OpenButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.OpenButton.BorderSizePixel = 0
    self.OpenButton.BackgroundTransparency = 1
    self.OpenButton.Parent = self.ScreenGui
    self:_round(self.OpenButton, 8)
    self:_makeDraggable(self.OpenButton, self.OpenButton)
    self.OpenButton.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = not self.MainFrame.Visible
    end)
end

function UI:_createHeader()
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = self.Theme.DARK
    header.BorderSizePixel = 0
    header.Parent = self.MainFrame
    self:_round(header, 10)
    self:_makeDraggable(header, self.MainFrame)
    
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 35, 0, 35)
    logo.Position = UDim2.new(0, 12, 0.5, -17.5)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://109578957492871"
    logo.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 200, 0, 25)
    title.Position = UDim2.new(0, 55, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = self.Name
    title.TextColor3 = self.Theme.ACCENT
    title.TextSize = 18
    title.Font = Enum.Font.Fantasy
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(0, 180, 0, 12)
    sub.Position = UDim2.new(0, 55, 0, 32)
    sub.BackgroundTransparency = 1
    sub.Text = "v" .. PreviewLibary.Release
    sub.TextColor3 = self.Theme.GRAY
    sub.TextSize = 10
    sub.Font = Enum.Font.Gotham
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = header
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
    closeBtn.BackgroundColor3 = self.Theme.RED
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = self.Theme.WHITE
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    self:_round(closeBtn, 6)
    closeBtn.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = false
    end)
end

function UI:_createNavBar()
    self.NavScroll = Instance.new("ScrollingFrame")
    self.NavScroll.Size = UDim2.new(1, 0, 0, 35)
    self.NavScroll.Position = UDim2.new(0, 0, 0, 50)
    self.NavScroll.BackgroundColor3 = self.Theme.MID
    self.NavScroll.BorderSizePixel = 0
    self.NavScroll.ScrollBarThickness = 3
    self.NavScroll.ScrollBarImageColor3 = self.Theme.ACCENT
    self.NavScroll.ScrollingDirection = Enum.ScrollingDirection.X
    self.NavScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.NavScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    self.NavScroll.Parent = self.MainFrame
    
    local layout = Instance.new("UIListLayout", self.NavScroll)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 0)
end

function UI:_createSidebar()
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 160, 1, -85)
    sidebar.Position = UDim2.new(0, 0, 0, 85)
    sidebar.BackgroundColor3 = self.Theme.DARK
    sidebar.BorderSizePixel = 0
    sidebar.Parent = self.MainFrame
    
    local stroke = Instance.new("UIStroke", sidebar)
    stroke.Color = self.Theme.MID
    stroke.Thickness = 1
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -16, 0, 25)
    title.Position = UDim2.new(0, 8, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "PLAYER INFO"
    title.TextColor3 = self.Theme.ACCENT
    title.TextSize = 12
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = sidebar
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 35, 0, 2)
    line.Position = UDim2.new(0, 8, 0, 34)
    line.BackgroundColor3 = self.Theme.ACCENT
    line.BorderSizePixel = 0
    line.Parent = sidebar
    
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 50, 0, 50)
    avatar.Position = UDim2.new(0.5, -25, 0, 42)
    avatar.BackgroundColor3 = self.Theme.MID
    avatar.BorderSizePixel = 0
    pcall(function()
        avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    avatar.Parent = sidebar
    self:_round(avatar, 25)
    
    local userRow = Instance.new("Frame")
    userRow.Size = UDim2.new(1, -16, 0, 20)
    userRow.Position = UDim2.new(0, 8, 0, 100)
    userRow.BackgroundTransparency = 1
    userRow.Parent = sidebar
    
    self.UserLabel = Instance.new("TextLabel")
    self.UserLabel.Size = UDim2.new(0.7, 0, 1, 0)
    self.UserLabel.Position = UDim2.new(0, 0, 0, 0)
    self.UserLabel.BackgroundTransparency = 1
    self.UserLabel.Text = "User: " .. player.UserId
    self.UserLabel.TextColor3 = self.Theme.ACCENT
    self.UserLabel.TextSize = 10
    self.UserLabel.Font = Enum.Font.Gotham
    self.UserLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.UserLabel.Parent = userRow
    
    local nameRow = Instance.new("Frame")
    nameRow.Size = UDim2.new(1, -16, 0, 20)
    nameRow.Position = UDim2.new(0, 8, 0, 122)
    nameRow.BackgroundTransparency = 1
    nameRow.Parent = sidebar
    
    self.NameLabel = Instance.new("TextLabel")
    self.NameLabel.Size = UDim2.new(0.7, 0, 1, 0)
    self.NameLabel.Position = UDim2.new(0, 0, 0, 0)
    self.NameLabel.BackgroundTransparency = 1
    self.NameLabel.Text = "Name: " .. player.DisplayName
    self.NameLabel.TextColor3 = self.Theme.YELLOW
    self.NameLabel.TextSize = 10
    self.NameLabel.Font = Enum.Font.Gotham
    self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.NameLabel.Parent = nameRow
    
    self.FPSLabel = Instance.new("TextLabel")
    self.FPSLabel.Size = UDim2.new(1, -16, 0, 16)
    self.FPSLabel.Position = UDim2.new(0, 8, 0, 146)
    self.FPSLabel.BackgroundTransparency = 1
    self.FPSLabel.Text = "FPS: 0"
    self.FPSLabel.TextColor3 = self.Theme.GRAY
    self.FPSLabel.TextSize = 10
    self.FPSLabel.Font = Enum.Font.Gotham
    self.FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.FPSLabel.Parent = sidebar
    
    self.TimeLabel = Instance.new("TextLabel")
    self.TimeLabel.Size = UDim2.new(1, -16, 0, 16)
    self.TimeLabel.Position = UDim2.new(0, 8, 0, 164)
    self.TimeLabel.BackgroundTransparency = 1
    self.TimeLabel.Text = "Time: 0h 0min 0s"
    self.TimeLabel.TextColor3 = self.Theme.GRAY
    self.TimeLabel.TextSize = 10
    self.TimeLabel.Font = Enum.Font.Gotham
    self.TimeLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TimeLabel.Parent = sidebar
    
    local credit = Instance.new("TextLabel")
    credit.Size = UDim2.new(1, -16, 0, 30)
    credit.Position = UDim2.new(0, 8, 0, 185)
    credit.BackgroundTransparency = 1
    credit.Text = self.Name .. "\nFREE"
    credit.TextColor3 = self.Theme.ACCENT
    credit.TextSize = 9
    credit.Font = Enum.Font.Gotham
    credit.TextXAlignment = Enum.TextXAlignment.Left
    credit.Parent = sidebar
    
    local startTime = tick()
    local fps = 0
    local lastFrame = tick()
    
    RunService.RenderStepped:Connect(function()
        local now = tick()
        local delta = now - lastFrame
        lastFrame = now
        if delta > 0 then fps = math.floor(1 / delta) end
    end)
    
    task.spawn(function()
        while true do
            self.FPSLabel.Text = "FPS: " .. tostring(fps)
            local elapsed = tick() - startTime
            local h = math.floor(elapsed / 3600)
            local m = math.floor((elapsed % 3600) / 60)
            local s = math.floor(elapsed % 60)
            self.TimeLabel.Text = string.format("Time: %dh %dmin %ds", h, m, s)
            task.wait(1)
        end
    end)
end

function UI:_createContentArea()
    self.ContentArea = Instance.new("ScrollingFrame")
    self.ContentArea.Size = UDim2.new(1, -170, 1, -85)
    self.ContentArea.Position = UDim2.new(0, 170, 0, 85)
    self.ContentArea.BackgroundColor3 = self.Theme.BG
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.ScrollBarThickness = 8
    self.ContentArea.ScrollBarImageColor3 = self.Theme.ACCENT
    self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentArea.ScrollingDirection = Enum.ScrollingDirection.Y
    self.ContentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.ContentArea.Parent = self.MainFrame
    
    local layout = Instance.new("UIListLayout", self.ContentArea)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    
    local pad = Instance.new("UIPadding", self.ContentArea)
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
end

function UI:CreateSectionTitle(text)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 40)
    f.BackgroundTransparency = 1
    f.Parent = self.ContentArea
    
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(0, 120, 0, 20)
    t.Position = UDim2.new(0, 0, 0, 0)
    t.BackgroundTransparency = 1
    t.Text = text:upper()
    t.TextColor3 = self.Theme.RED
    t.TextSize = 10
    t.Font = Enum.Font.Gotham
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = f
    
    local h = Instance.new("TextLabel")
    h.Size = UDim2.new(1, 0, 0, 22)
    h.Position = UDim2.new(0, 0, 0, 15)
    h.BackgroundTransparency = 1
    h.Text = text
    h.TextColor3 = self.Theme.WHITE
    h.TextSize = 18
    h.Font = Enum.Font.Fantasy
    h.TextXAlignment = Enum.TextXAlignment.Left
    h.Parent = f
    
    local l = Instance.new("Frame")
    l.Size = UDim2.new(0, 50, 0, 2)
    l.Position = UDim2.new(0, 0, 0, 38)
    l.BackgroundColor3 = self.Theme.ACCENT
    l.BorderSizePixel = 0
    l.Parent = f
    
    return f
end

function UI:CreateInfoLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = self.Theme.GRAY
    lbl.TextSize = 10
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.Parent = self.ContentArea
    return lbl
end

function UI:CreateLabel(text)
    return self:CreateInfoLabel(text)
end

function UI:CreateToggle(config)
    config = config or {}
    local labelText = config.Name or "Toggle"
    local flag = config.Flag
    local defaultState = config.CurrentValue or false
    local callback = config.Callback
    
    if flag then self.Flags[flag] = defaultState end
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 34)
    container.BackgroundColor3 = self.Theme.MID
    container.BorderSizePixel = 1
    container.BorderColor3 = self.Theme.LIGHT
    container.Parent = self.ContentArea
    self:_round(container, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = self.Theme.TEXT
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 24)
    btn.Position = UDim2.new(1, -48, 0.5, -12)
    btn.BackgroundColor3 = defaultState and self.Theme.ACCENT or self.Theme.LIGHT
    btn.Text = defaultState and "ON" or "OFF"
    btn.TextColor3 = self.Theme.WHITE
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = container
    self:_round(btn, 4)
    
    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        if flag then self.Flags[flag] = state end
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and self.Theme.ACCENT or self.Theme.LIGHT
        if callback then callback(state) end
    end)
    
    return container
end

function UI:CreateSlider(config)
    config = config or {}
    local labelText = config.Name or "Slider"
    local flag = config.Flag
    local min = config.Range and config.Range[1] or 0
    local max = config.Range and config.Range[2] or 100
    local currentVal = config.CurrentValue or min
    local callback = config.Callback
    
    if flag then self.Flags[flag] = currentVal end
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = self.Theme.MID
    container.BorderSizePixel = 1
    container.BorderColor3 = self.Theme.LIGHT
    container.Parent = self.ContentArea
    self:_round(container, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = self.Theme.TEXT
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valLabel.Position = UDim2.new(0.7, 0, 0, 4)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(currentVal)
    valLabel.TextColor3 = self.Theme.ACCENT
    valLabel.TextSize = 12
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = container
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 8)
    sliderBg.Position = UDim2.new(0, 12, 0, 30)
    sliderBg.BackgroundColor3 = self.Theme.DARK
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    self:_round(sliderBg, 4)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((currentVal - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = self.Theme.ACCENT
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    self:_round(sliderFill, 4)
    
    local function updateSlider(val)
        val = math.clamp(val, min, max)
        if flag then self.Flags[flag] = val end
        valLabel.Text = tostring(math.floor(val))
        local pct = (val - min) / (max - min)
        sliderFill.Size = UDim2.new(pct, 0, 1, 0)
        if callback then callback(val) end
    end
    
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

function UI:CreateDropdown(config)
    config = config or {}
    local labelText = config.Name or "Dropdown"
    local flag = config.Flag
    local options = config.Options or {"Option 1", "Option 2"}
    local currentVal = config.CurrentOption or options[1]
    local callback = config.Callback
    
    if flag then self.Flags[flag] = currentVal end
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 34)
    container.BackgroundColor3 = self.Theme.MID
    container.BorderSizePixel = 1
    container.BorderColor3 = self.Theme.LIGHT
    container.Parent = self.ContentArea
    self:_round(container, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = self.Theme.TEXT
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.45, 0, 0, 24)
    btn.Position = UDim2.new(0.52, 0, 0.5, -12)
    btn.BackgroundColor3 = self.Theme.LIGHT
    btn.Text = currentVal
    btn.TextColor3 = self.Theme.WHITE
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = container
    self:_round(btn, 4)
    
    local optionIndex = 1
    for i, v in ipairs(options) do
        if v == currentVal then optionIndex = i break end
    end
    
    btn.MouseButton1Click:Connect(function()
        optionIndex = (optionIndex % #options) + 1
        local selected = options[optionIndex]
        if flag then self.Flags[flag] = selected end
        btn.Text = selected
        if callback then callback(selected) end
    end)
    
    return btn
end

function UI:CreateButton(config)
    config = config or {}
    local text = config.Name or "Button"
    local callback = config.Callback
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = self.Theme.ACCENT
    btn.Text = text
    btn.TextColor3 = self.Theme.WHITE
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = self.ContentArea
    self:_round(btn, 6)
    
    btn.MouseButton1Click:Connect(callback or function() end)
    return btn
end

function UI:CreateInput(config)
    config = config or {}
    local labelText = config.Name or "Input"
    local placeholder = config.PlaceholderText or ""
    local flag = config.Flag
    local callback = config.Callback
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 38)
    container.BackgroundColor3 = self.Theme.MID
    container.BorderSizePixel = 1
    container.BorderColor3 = self.Theme.LIGHT
    container.Parent = self.ContentArea
    self:_round(container, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.35, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = self.Theme.TEXT
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(0.4, 0, 0, 24)
    tb.Position = UDim2.new(0.37, 0, 0.5, -12)
    tb.BackgroundColor3 = self.Theme.DARK
    tb.BorderSizePixel = 0
    tb.Text = ""
    tb.PlaceholderText = placeholder
    tb.TextColor3 = self.Theme.WHITE
    tb.PlaceholderColor3 = self.Theme.GRAY
    tb.TextSize = 11
    tb.Font = Enum.Font.Gotham
    tb.ClearTextOnFocus = false
    tb.Parent = container
    self:_round(tb, 4)
    
    local goBtn = Instance.new("TextButton")
    goBtn.Size = UDim2.new(0, 40, 0, 24)
    goBtn.Position = UDim2.new(0.8, 0, 0.5, -12)
    goBtn.BackgroundColor3 = self.Theme.ACCENT
    goBtn.Text = "GO"
    goBtn.TextColor3 = self.Theme.WHITE
    goBtn.TextSize = 10
    goBtn.Font = Enum.Font.GothamBold
    goBtn.Parent = container
    self:_round(goBtn, 4)
    
    goBtn.MouseButton1Click:Connect(function()
        if flag then self.Flags[flag] = tb.Text end
        if callback then callback(tb.Text) end
    end)
    
    return container, tb
end

function UI:CreateParagraph(config)
    config = config or {}
    local title = config.Title or ""
    local content = config.Content or ""
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = self.ContentArea
    
    if title and title ~= "" then
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, 0, 0, 18)
        t.BackgroundTransparency = 1
        t.Text = title
        t.TextColor3 = self.Theme.ACCENT
        t.TextSize = 13
        t.Font = Enum.Font.GothamBold
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Parent = container
    end
    
    if content and content ~= "" then
        local c = Instance.new("TextLabel")
        c.Size = UDim2.new(1, 0, 0, 0)
        c.AutomaticSize = Enum.AutomaticSize.Y
        c.BackgroundTransparency = 1
        c.Text = content
        c.TextColor3 = self.Theme.GRAY
        c.TextSize = 12
        c.Font = Enum.Font.Gotham
        c.TextXAlignment = Enum.TextXAlignment.Left
        c.TextWrapped = true
        c.Parent = container
    end
    
    return container
end

local ElementMethods = {}

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
    local defaultIndex = 1
    if cfg.CurrentOption then
        for i, o in ipairs(options) do
            if o == cfg.CurrentOption then defaultIndex = i break end
        end
    end
    local flag = cfg.Flag
    if flag then PreviewLibary.Flags[flag] = options[defaultIndex] end
    AddDropdown(self.Inner, cfg.Name or "Dropdown", options, defaultIndex, function(opt)
        if flag then PreviewLibary.Flags[flag] = opt end
        if cfg.Callback then cfg.Callback(opt) end
    end)
    return {}
end

function ElementMethods:CreateColorPicker(cfg)
    cfg = cfg or {}
    local flag = cfg.Flag
    local color = cfg.Color or Color3.fromRGB(255, 255, 255)
    if flag then PreviewLibary.Flags[flag] = color end
    AddColorpicker(self.Inner, cfg.Name or "Color Picker", color, function(c)
        if flag then PreviewLibary.Flags[flag] = c end
        if cfg.Callback then cfg.Callback(c) end
    end)
    return {}
end

function ElementMethods:CreateInput(cfg)
    cfg = cfg or {}
    AddInput(self.Inner, cfg.Name or "Input", cfg.PlaceholderText or "", function(txt)
        if cfg.Callback then cfg.Callback(txt) end
    end)
    return {}
end

function ElementMethods:CreateLabel(text)
    AddLabel(self.Inner, tostring(text))
    return {}
end

function ElementMethods:CreateInfoLabel(text)
    AddLabel(self.Inner, tostring(text))
    return {}
end

function ElementMethods:CreateParagraph(cfg)
    cfg = cfg or {}
    AddParagraph(self.Inner, cfg.Title or "", cfg.Content or "")
    return {}
end

local function AddButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = THEME.ACCENT
    btn.Text = text
    btn.TextColor3 = THEME.WHITE
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    self:_round(btn, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function AddLabel(parent, text)
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

local function AddToggle(parent, labelText, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = THEME.TEXT
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local box = Instance.new("TextButton")
    box.Size = UDim2.new(0, 40, 0, 24)
    box.Position = UDim2.new(1, -48, 0.5, -12)
    box.BackgroundColor3 = default and THEME.ACCENT or THEME.LIGHT
    box.Text = default and "ON" or "OFF"
    box.TextColor3 = THEME.WHITE
    box.TextSize = 10
    box.Font = Enum.Font.GothamBold
    box.Parent = row
    self:_round(box, 4)

    local state = default
    box.MouseButton1Click:Connect(function()
        state = not state
        box.Text = state and "ON" or "OFF"
        box.BackgroundColor3 = state and THEME.ACCENT or THEME.LIGHT
        if callback then callback(state) end
    end)
end

local function AddSlider(parent, labelText, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 0, 20)
    lbl.Position = UDim2.new(0, 12, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = THEME.TEXT
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0.3, 0, 0, 20)
    valLbl.Position = UDim2.new(0.7, 0, 0, 4)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(default)
    valLbl.TextColor3 = THEME.ACCENT
    valLbl.TextSize = 12
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 8)
    sliderBg.Position = UDim2.new(0, 12, 0, 30)
    sliderBg.BackgroundColor3 = THEME.DARK
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    self:_round(sliderBg, 4)

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = THEME.ACCENT
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    self:_round(sliderFill, 4)

    local dragging = false
    local function update(input)
        local delta = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(delta, 0, 1, 0)
        local value = math.floor(min + (max - min) * delta)
        valLbl.Text = tostring(value)
        if callback then callback(value) end
    end
    
    sliderBg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(i)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            update(i)
        end
    end)
end

local function AddDropdown(parent, labelText, options, defaultIndex, callback)
    local selectedIndex = defaultIndex or 1
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = THEME.TEXT
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.45, 0, 0, 24)
    btn.Position = UDim2.new(0.52, 0, 0.5, -12)
    btn.BackgroundColor3 = THEME.LIGHT
    btn.Text = options[selectedIndex]
    btn.TextColor3 = THEME.WHITE
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.Parent = row
    self:_round(btn, 4)

    local open = false
    local listFrame = nil

    btn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            listFrame = Instance.new("Frame")
            local relPos = btn.AbsolutePosition - MainWindow.AbsolutePosition
            listFrame.Position = UDim2.new(0, relPos.X, 0, relPos.Y + btn.AbsoluteSize.Y + 2)
            listFrame.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, math.min(#options * 24 + 4, 130))
            listFrame.BackgroundColor3 = THEME.PopupBg
            listFrame.BorderSizePixel = 0
            listFrame.ZIndex = 200
            listFrame.Parent = MainWindow
            self:_round(listFrame, 4)

            local scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, 0, 1, 0)
            scroll.BackgroundTransparency = 1
            scroll.BorderSizePixel = 0
            scroll.ScrollBarThickness = 4
            scroll.ScrollBarImageColor3 = THEME.Border
            scroll.CanvasSize = UDim2.new(1, 0, 0, #options * 24)
            scroll.ZIndex = 201
            scroll.Parent = listFrame

            for idx, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 24)
                optBtn.BackgroundColor3 = THEME.PopupBg
                optBtn.BorderSizePixel = 0
                optBtn.Text = opt
                optBtn.TextColor3 = (idx == selectedIndex) and THEME.Scheme or THEME.Text
                optBtn.TextSize = 12
                optBtn.Font = Enum.Font.Gotham
                optBtn.ZIndex = 202
                optBtn.Parent = scroll

                optBtn.MouseButton1Click:Connect(function()
                    selectedIndex = idx
                    btn.Text = opt
                    if callback then callback(opt) end
                    listFrame:Destroy()
                    open = false
                end)
            end
        else
            if listFrame then listFrame:Destroy() end
        end
    end)
end

local function AddColorpicker(parent, labelText, defaultColor, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 20)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = THEME.Text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local preview = Instance.new("TextButton")
    preview.Size = UDim2.new(0, 28, 0, 14)
    preview.Position = UDim2.new(1, -28, 0.5, -7)
    preview.BackgroundColor3 = defaultColor
    preview.BorderSizePixel = 0
    preview.Text = ""
    preview.Parent = row
    self:_round(preview, 2)
end

local function AddInput(parent, labelText, placeholder, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.35, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = THEME.TEXT
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local boxFrame = Instance.new("Frame")
    boxFrame.Size = UDim2.new(0.4, 0, 1, 0)
    boxFrame.Position = UDim2.new(0.37, 0, 0, 0)
    boxFrame.BackgroundColor3 = THEME.DARK
    boxFrame.BorderSizePixel = 0
    boxFrame.Parent = row
    self:_round(boxFrame, 4)

    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(1, -12, 1, 0)
    tb.Position = UDim2.new(0, 6, 0, 0)
    tb.BackgroundTransparency = 1
    tb.Text = ""
    tb.PlaceholderText = placeholder or ""
    tb.TextColor3 = THEME.WHITE
    tb.PlaceholderColor3 = THEME.GRAY
    tb.TextSize = 11
    tb.Font = Enum.Font.Gotham
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.ClearTextOnFocus = false
    tb.Parent = boxFrame

    tb.FocusLost:Connect(function()
        if callback then callback(tb.Text) end
    end)
end

local function AddParagraph(parent, title, content)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    if title and title ~= "" then
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, 0, 0, 18)
        t.BackgroundTransparency = 1
        t.Text = title
        t.TextColor3 = THEME.ACCENT
        t.TextSize = 13
        t.Font = Enum.Font.GothamBold
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Parent = container
    end
    
    if content and content ~= "" then
        local c = Instance.new("TextLabel")
        c.Size = UDim2.new(1, 0, 0, 0)
        c.AutomaticSize = Enum.AutomaticSize.Y
        c.BackgroundTransparency = 1
        c.Text = content
        c.TextColor3 = THEME.GRAY
        c.TextSize = 12
        c.Font = Enum.Font.Gotham
        c.TextXAlignment = Enum.TextXAlignment.Left
        c.TextWrapped = true
        c.Parent = container
    end
end

function UI:CreateTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 1, 0)
    btn.BackgroundColor3 = (#self.Tabs == 0) and self.Theme.ACCENT or self.Theme.MID
    btn.Text = name
    btn.TextColor3 = self.Theme.WHITE
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.LayoutOrder = #self.Tabs + 1
    btn.Parent = self.NavScroll
    self:_round(btn, 4)
    
    local tabData = {
        Name = name,
        Button = btn,
        Active = (#self.Tabs == 0)
    }
    table.insert(self.Tabs, tabData)
    
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = (#self.Tabs == 1)
    tabContent.Parent = self.ContentArea
    
    tabData.Content = tabContent
    
    local function switchTab()
        for _, t in ipairs(self.Tabs) do
            t.Button.BackgroundColor3 = self.Theme.MID
            if t.Content then
                t.Content.Visible = false
            end
        end
        btn.BackgroundColor3 = self.Theme.ACCENT
        if tabContent then
            tabContent.Visible = true
        end
    end
    
    btn.MouseButton1Click:Connect(switchTab)
    
    local tabMethods = {}
    
    function tabMethods:CreateSection(name)
        local originalContent = self.ContentArea
        self.ContentArea = tabContent
        
        if name and name ~= "" then
            self:CreateSectionTitle(name)
        end
        
        local sectionContainer = Instance.new("Frame")
        sectionContainer.Size = UDim2.new(1, 0, 0, 0)
        sectionContainer.AutomaticSize = Enum.AutomaticSize.Y
        sectionContainer.BackgroundTransparency = 1
        sectionContainer.Parent = tabContent
        
        local layout = Instance.new("UIListLayout", sectionContainer)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 6)
        
        local sectionMethods = {}
        
        function sectionMethods:CreateToggle(cfg)
            cfg = cfg or {}
            local oldContent = self.ContentArea
            self.ContentArea = sectionContainer
            local result = self:CreateToggle(cfg)
            self.ContentArea = oldContent
            return result
        end
        
        function sectionMethods:CreateSlider(cfg)
            cfg = cfg or {}
            local oldContent = self.ContentArea
            self.ContentArea = sectionContainer
            local result = self:CreateSlider(cfg)
            self.ContentArea = oldContent
            return result
        end
        
        function sectionMethods:CreateDropdown(cfg)
            cfg = cfg or {}
            local oldContent = self.ContentArea
            self.ContentArea = sectionContainer
            local result = self:CreateDropdown(cfg)
            self.ContentArea = oldContent
            return result
        end
        
        function sectionMethods:CreateButton(cfg)
            cfg = cfg or {}
            local oldContent = self.ContentArea
            self.ContentArea = sectionContainer
            local result = self:CreateButton(cfg)
            self.ContentArea = oldContent
            return result
        end
        
        function sectionMethods:CreateInput(cfg)
            cfg = cfg or {}
            local oldContent = self.ContentArea
            self.ContentArea = sectionContainer
            local result = self:CreateInput(cfg)
            self.ContentArea = oldContent
            return result
        end
        
        function sectionMethods:CreateLabel(text)
            local oldContent = self.ContentArea
            self.ContentArea = sectionContainer
            local result = self:CreateInfoLabel(text)
            self.ContentArea = oldContent
            return result
        end
        
        function sectionMethods:CreateInfoLabel(text)
            local oldContent = self.ContentArea
            self.ContentArea = sectionContainer
            local result = self:CreateInfoLabel(text)
            self.ContentArea = oldContent
            return result
        end
        
        function sectionMethods:CreateParagraph(cfg)
            cfg = cfg or {}
            local oldContent = self.ContentArea
            self.ContentArea = sectionContainer
            local result = self:CreateParagraph(cfg)
            self.ContentArea = oldContent
            return result
        end
        
        function sectionMethods:CreateColorPicker(cfg)
            cfg = cfg or {}
            local oldContent = self.ContentArea
            self.ContentArea = sectionContainer
            local result = self:CreateColorPicker(cfg)
            self.ContentArea = oldContent
            return result
        end
        
        return sectionMethods
    end
    
    function tabMethods:CreateLabel(text)
        local oldContent = self.ContentArea
        self.ContentArea = tabContent
        local result = self:CreateInfoLabel(text)
        self.ContentArea = oldContent
        return result
    end
    
    function tabMethods:CreateInfoLabel(text)
        local oldContent = self.ContentArea
        self.ContentArea = tabContent
        local result = self:CreateInfoLabel(text)
        self.ContentArea = oldContent
        return result
    end
    
    function tabMethods:CreateButton(cfg)
        cfg = cfg or {}
        local oldContent = self.ContentArea
        self.ContentArea = tabContent
        local result = self:CreateButton(cfg)
        self.ContentArea = oldContent
        return result
    end
    
    function tabMethods:CreateToggle(cfg)
        cfg = cfg or {}
        local oldContent = self.ContentArea
        self.ContentArea = tabContent
        local result = self:CreateToggle(cfg)
        self.ContentArea = oldContent
        return result
    end
    
    function tabMethods:CreateSlider(cfg)
        cfg = cfg or {}
        local oldContent = self.ContentArea
        self.ContentArea = tabContent
        local result = self:CreateSlider(cfg)
        self.ContentArea = oldContent
        return result
    end
    
    function tabMethods:CreateDropdown(cfg)
        cfg = cfg or {}
        local oldContent = self.ContentArea
        self.ContentArea = tabContent
        local result = self:CreateDropdown(cfg)
        self.ContentArea = oldContent
        return result
    end
    
    function tabMethods:CreateInput(cfg)
        cfg = cfg or {}
        local oldContent = self.ContentArea
        self.ContentArea = tabContent
        local result = self:CreateInput(cfg)
        self.ContentArea = oldContent
        return result
    end
    
    function tabMethods:CreateParagraph(cfg)
        cfg = cfg or {}
        local oldContent = self.ContentArea
        self.ContentArea = tabContent
        local result = self:CreateParagraph(cfg)
        self.ContentArea = oldContent
        return result
    end
    
    function tabMethods:CreateColorPicker(cfg)
        cfg = cfg or {}
        local oldContent = self.ContentArea
        self.ContentArea = tabContent
        local result = self:CreateColorPicker(cfg)
        self.ContentArea = oldContent
        return result
    end
    
    local tabSelf = self
    setmetatable(tabMethods, {
        __index = function(t, k)
            return tabSelf[k]
        end
    })
    
    return tabMethods
end

function UI:_round(obj, radius)
    local corner = Instance.new("UICorner", obj)
    corner.CornerRadius = UDim.new(0, radius or 4)
    return corner
end

function UI:_makeDraggable(dragFrame, frameToMove)
    local dragToggle = false
    local dragStart = nil
    local startPos = nil
    
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frameToMove.Position
        end
    end)
    
    dragFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frameToMove.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function UI:Notify(data)
    data = data or {}
    print("🔔 " .. (data.Title or "Notification") .. ": " .. (data.Content or ""))
end

function UI:ApplyFlags(flags)
    if not flags then return end
    for key, value in pairs(flags) do
        if self.Flags[key] ~= nil then
            self.Flags[key] = value
        end
    end
end

function PreviewLibary:CreateWindow(config)
    config = config or {}
    local ui = UI.new(config)
    return ui
end

return PreviewLibary
