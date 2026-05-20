local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function getGuiParent()
    local success, parent = pcall(function() return CoreGui end)
    if success and parent then
        return parent
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- UI Construction
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnimationInfoLogger"
ScreenGui.ResetOnSpawn = false
_G.LoggingPaused = _G.LoggingPaused or false
_G.LogPlayers = _G.LogPlayers ~= nil and _G.LogPlayers or true
_G.LogMobs = _G.LogMobs ~= nil and _G.LogMobs or true

ScreenGui.Parent = getGuiParent()

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 530, 0, 350)
MainFrame.Position = UDim2.new(0.5, -265, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainUICorner = Instance.new("UICorner")
MainUICorner.CornerRadius = UDim.new(0, 6)
MainUICorner.Parent = MainFrame

local MainUIStroke = Instance.new("UIStroke")
MainUIStroke.Color = Color3.fromRGB(0, 255, 150)
MainUIStroke.Thickness = 1.5
MainUIStroke.Transparency = 0
MainUIStroke.Parent = MainFrame

-- Draggable logic
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 85, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "INFO LOGGER"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.Code
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local EntryCountLabel = Instance.new("TextLabel")
EntryCountLabel.Size = UDim2.new(0, 65, 1, 0)
EntryCountLabel.Position = UDim2.new(0, 100, 0, 0)
EntryCountLabel.BackgroundTransparency = 1
EntryCountLabel.Text = "0 entries"
EntryCountLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
EntryCountLabel.Font = Enum.Font.Code
EntryCountLabel.TextSize = 10
EntryCountLabel.TextXAlignment = Enum.TextXAlignment.Left
EntryCountLabel.Parent = TopBar

-- QoL Control Buttons (Pause, Players, Mobs)
local PauseBtn = Instance.new("TextButton")
PauseBtn.Size = UDim2.new(0, 45, 1, -15)
PauseBtn.Position = UDim2.new(0, 165, 0, 7)
PauseBtn.BackgroundColor3 = Color3.fromRGB(10, 15, 15)
PauseBtn.BorderSizePixel = 1
PauseBtn.BorderColor3 = _G.LoggingPaused and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(0, 255, 150)
PauseBtn.Text = _G.LoggingPaused and "Resume" or "Pause"
PauseBtn.TextColor3 = _G.LoggingPaused and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(0, 255, 150)
PauseBtn.Font = Enum.Font.Code
PauseBtn.TextSize = 11
PauseBtn.Parent = TopBar

local PauseBtnCorner = Instance.new("UICorner")
PauseBtnCorner.CornerRadius = UDim.new(0, 4)
PauseBtnCorner.Parent = PauseBtn

PauseBtn.MouseButton1Click:Connect(function()
    _G.LoggingPaused = not _G.LoggingPaused
    PauseBtn.BorderColor3 = _G.LoggingPaused and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(0, 255, 150)
    PauseBtn.Text = _G.LoggingPaused and "Resume" or "Pause"
    PauseBtn.TextColor3 = _G.LoggingPaused and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(0, 255, 150)
end)

local PlayersBtn = Instance.new("TextButton")
PlayersBtn.Size = UDim2.new(0, 50, 1, -15)
PlayersBtn.Position = UDim2.new(0, 215, 0, 7)
PlayersBtn.BackgroundColor3 = Color3.fromRGB(10, 15, 15)
PlayersBtn.BorderSizePixel = 1
PlayersBtn.BorderColor3 = _G.LogPlayers and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 60, 60)
PlayersBtn.Text = "Players"
PlayersBtn.TextColor3 = _G.LogPlayers and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 60, 60)
PlayersBtn.Font = Enum.Font.Code
PlayersBtn.TextSize = 11
PlayersBtn.Parent = TopBar

local PlayersBtnCorner = Instance.new("UICorner")
PlayersBtnCorner.CornerRadius = UDim.new(0, 4)
PlayersBtnCorner.Parent = PlayersBtn

PlayersBtn.MouseButton1Click:Connect(function()
    _G.LogPlayers = not _G.LogPlayers
    PlayersBtn.BorderColor3 = _G.LogPlayers and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 60, 60)
    PlayersBtn.TextColor3 = _G.LogPlayers and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 60, 60)
end)

local MobsBtn = Instance.new("TextButton")
MobsBtn.Size = UDim2.new(0, 40, 1, -15)
MobsBtn.Position = UDim2.new(0, 270, 0, 7)
MobsBtn.BackgroundColor3 = Color3.fromRGB(10, 15, 15)
MobsBtn.BorderSizePixel = 1
MobsBtn.BorderColor3 = _G.LogMobs and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 60, 60)
MobsBtn.Text = "Mobs"
MobsBtn.TextColor3 = _G.LogMobs and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 60, 60)
MobsBtn.Font = Enum.Font.Code
MobsBtn.TextSize = 11
MobsBtn.Parent = TopBar

local MobsBtnCorner = Instance.new("UICorner")
MobsBtnCorner.CornerRadius = UDim.new(0, 4)
MobsBtnCorner.Parent = MobsBtn

MobsBtn.MouseButton1Click:Connect(function()
    _G.LogMobs = not _G.LogMobs
    MobsBtn.BorderColor3 = _G.LogMobs and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 60, 60)
    MobsBtn.TextColor3 = _G.LogMobs and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 60, 60)
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 1, -15)
CloseBtn.Position = UDim2.new(1, -30, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(10, 15, 15)
CloseBtn.BorderSizePixel = 1
CloseBtn.BorderColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Font = Enum.Font.Code
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 4)
CloseBtnCorner.Parent = CloseBtn

local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Size = UDim2.new(0, 35, 1, 0)
RadiusLabel.Position = UDim2.new(1, -170, 0, 0)
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.Text = "Dist:"
RadiusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
RadiusLabel.Font = Enum.Font.Code
RadiusLabel.TextSize = 12
RadiusLabel.TextXAlignment = Enum.TextXAlignment.Right
RadiusLabel.Parent = TopBar

local RadiusBox = Instance.new("TextBox")
RadiusBox.Size = UDim2.new(0, 35, 1, -8)
RadiusBox.Position = UDim2.new(1, -130, 0, 4)
RadiusBox.BackgroundColor3 = Color3.fromRGB(10, 15, 15)
RadiusBox.BorderSizePixel = 1
RadiusBox.BorderColor3 = Color3.fromRGB(0, 255, 150)
RadiusBox.Text = "100"
RadiusBox.TextColor3 = Color3.fromRGB(0, 255, 150)
RadiusBox.Font = Enum.Font.Code
RadiusBox.TextSize = 12
RadiusBox.Parent = TopBar

local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0, 50, 1, -15)
ClearBtn.Position = UDim2.new(1, -85, 0, 7)
ClearBtn.BackgroundColor3 = Color3.fromRGB(10, 15, 15)
ClearBtn.BorderSizePixel = 1
ClearBtn.BorderColor3 = Color3.fromRGB(0, 255, 150)
ClearBtn.Text = "Clear"
ClearBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
ClearBtn.Font = Enum.Font.Code
ClearBtn.TextSize = 12
ClearBtn.Parent = TopBar

local ClearBtnCorner = Instance.new("UICorner")
ClearBtnCorner.CornerRadius = UDim.new(0, 4)
ClearBtnCorner.Parent = ClearBtn

-- Header Row
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(1, 0, 0, 20)
HeaderFrame.Position = UDim2.new(0, 0, 0, 35)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 20)
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Parent = MainFrame

local function createHeaderLabel(text, sizeScale, posScale, isStatus)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(sizeScale, 0, 1, 0)
    lbl.Position = UDim2.new(posScale, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(0, 255, 150)
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = HeaderFrame
end

createHeaderLabel("Time", 0.12, 0.02)
createHeaderLabel("Animation", 0.16, 0.14)
createHeaderLabel("ID", 0.22, 0.30)
createHeaderLabel("Enemy", 0.25, 0.52)
createHeaderLabel("Dist", 0.08, 0.77)
createHeaderLabel("Status", 0.10, 0.88, true)

-- Scrolling Frame
local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Size = UDim2.new(1, 0, 1, -55)
ScrollList.Position = UDim2.new(0, 0, 0, 55)
ScrollList.BackgroundTransparency = 1
ScrollList.BorderSizePixel = 0
ScrollList.ScrollBarThickness = 4
ScrollList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ScrollList.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 0)
ListLayout.Parent = ScrollList

-- Logic State
local connections = {}
local entryCount = 0
local maxEntries = 100

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

ClearBtn.MouseButton1Click:Connect(function()
    for _, child in ipairs(ScrollList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    entryCount = 0
    EntryCountLabel.Text = entryCount .. " entries"
end)

local VisualizerGui = nil
local activeAnimTrack = nil
local visConnection = nil
local visDragConnection = nil
local visCamDragConnection = nil

_G.openVisualizer = function(animId, sourceCharacter)
    local savedPos = nil
    if VisualizerGui then
        -- Save position before destroying
        local existingFrame = VisualizerGui:FindFirstChild("VisFrame")
        if existingFrame then
            savedPos = existingFrame.Position
        end
        VisualizerGui:Destroy()
        if visConnection then visConnection:Disconnect() end
        if visDragConnection then visDragConnection:Disconnect() end
        if visCamDragConnection then visCamDragConnection:Disconnect() end
        if activeAnimTrack then activeAnimTrack:Stop() end
    end
    
    VisualizerGui = Instance.new("ScreenGui")
    VisualizerGui.Name = "AnimationVisualizer"
    VisualizerGui.ResetOnSpawn = false
    VisualizerGui.Parent = getGuiParent()
    
    local VisFrame = Instance.new("Frame")
    VisFrame.Name = "VisFrame"
    VisFrame.Size = UDim2.new(0, 520, 0, 420)
    VisFrame.Position = savedPos or UDim2.new(0.5, -550, 0.5, -210)
    VisFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
    VisFrame.BorderSizePixel = 0
    VisFrame.Parent = VisualizerGui

    local VisUICorner = Instance.new("UICorner")
    VisUICorner.CornerRadius = UDim.new(0, 10)
    VisUICorner.Parent = VisFrame

    local VisUIStroke = Instance.new("UIStroke")
    VisUIStroke.Color = Color3.fromRGB(0, 150, 255)
    VisUIStroke.Thickness = 1.5
    VisUIStroke.Transparency = 0.5
    VisUIStroke.Parent = VisFrame
    
    -- Draggable logic for VisFrame
    local vDragging, vDragInput, vDragStart, vStartPos
    VisFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            vDragging = true
            vDragStart = input.Position
            vStartPos = VisFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    vDragging = false
                end
            end)
        end
    end)
    VisFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            vDragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == vDragInput and vDragging then
            local delta = input.Position - vDragStart
            VisFrame.Position = UDim2.new(vStartPos.X.Scale, vStartPos.X.Offset + delta.X, vStartPos.Y.Scale, vStartPos.Y.Offset + delta.Y)
        end
    end)
    
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = VisFrame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -30, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "ANIMATION VISUALIZER"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 1, -15)
    CloseBtn.Position = UDim2.new(1, -30, 0, 7)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 12
    CloseBtn.Parent = TopBar
    
    local CloseBtnCorner = Instance.new("UICorner")
    CloseBtnCorner.CornerRadius = UDim.new(0, 6)
    CloseBtnCorner.Parent = CloseBtn
    
    local deathConn
    local ancestorConn

    CloseBtn.MouseButton1Click:Connect(function()
        VisualizerGui:Destroy()
        if visConnection then visConnection:Disconnect() end
        if visDragConnection then visDragConnection:Disconnect() end
        if visCamDragConnection then visCamDragConnection:Disconnect() end
        if deathConn then deathConn:Disconnect() end
        if ancestorConn then ancestorConn:Disconnect() end
        if activeAnimTrack then activeAnimTrack:Stop() end
        if dummy then dummy:Destroy() end
    end)
    
    -- Left Side (Viewport)
    local LeftPanel = Instance.new("Frame")
    LeftPanel.Size = UDim2.new(0.6, -10, 1, -35)
    LeftPanel.Position = UDim2.new(0, 5, 0, 30)
    LeftPanel.BackgroundTransparency = 1
    LeftPanel.Parent = VisFrame
    
    local IDLabel = Instance.new("TextLabel")
    IDLabel.Size = UDim2.new(1, 0, 0, 20)
    IDLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    IDLabel.BorderSizePixel = 1
    IDLabel.BorderColor3 = Color3.fromRGB(100, 100, 100)
    IDLabel.Text = animId
    IDLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    IDLabel.Font = Enum.Font.Code
    IDLabel.TextSize = 11
    IDLabel.Parent = LeftPanel
    
    local Viewport = Instance.new("ViewportFrame")
    Viewport.Size = UDim2.new(1, 0, 1, -100)
    Viewport.Position = UDim2.new(0, 0, 0, 25)
    Viewport.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Viewport.BorderSizePixel = 1
    Viewport.BorderColor3 = Color3.fromRGB(100, 100, 100)
    Viewport.Parent = LeftPanel
    
    -- Controls
    local ControlsFrame = Instance.new("Frame")
    ControlsFrame.Size = UDim2.new(1, 0, 0, 70)
    ControlsFrame.Position = UDim2.new(0, 0, 1, -70)
    ControlsFrame.BackgroundTransparency = 1
    ControlsFrame.Parent = LeftPanel
    
    local PlayPauseBtn = Instance.new("TextButton")
    PlayPauseBtn.Size = UDim2.new(0, 80, 0, 25)
    PlayPauseBtn.Position = UDim2.new(0.5, -40, 0, 5)
    PlayPauseBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    PlayPauseBtn.BorderSizePixel = 1
    PlayPauseBtn.BorderColor3 = Color3.fromRGB(200, 200, 200)
    PlayPauseBtn.Text = "||"
    PlayPauseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayPauseBtn.Font = Enum.Font.Code
    PlayPauseBtn.TextSize = 14
    PlayPauseBtn.Parent = ControlsFrame
    
    local CamSliderBg = Instance.new("TextButton")
    CamSliderBg.Size = UDim2.new(1, 0, 0, 10)
    CamSliderBg.Position = UDim2.new(0, 0, 0, 35)
    CamSliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    CamSliderBg.BorderSizePixel = 1
    CamSliderBg.BorderColor3 = Color3.fromRGB(100, 100, 100)
    CamSliderBg.Text = ""
    CamSliderBg.AutoButtonColor = false
    CamSliderBg.Parent = ControlsFrame
    
    local CamSliderKnob = Instance.new("Frame")
    CamSliderKnob.Size = UDim2.new(0, 10, 1, 0)
    CamSliderKnob.Position = UDim2.new(0.5, -5, 0, 0)
    CamSliderKnob.BackgroundColor3 = Color3.fromRGB(220, 140, 40)
    CamSliderKnob.BorderSizePixel = 0
    CamSliderKnob.Parent = CamSliderBg
    
    local ProgressBarBg = Instance.new("TextButton")
    ProgressBarBg.Size = UDim2.new(1, 0, 0, 15)
    ProgressBarBg.Position = UDim2.new(0, 0, 0, 50)
    ProgressBarBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ProgressBarBg.BorderSizePixel = 1
    ProgressBarBg.BorderColor3 = Color3.fromRGB(200, 200, 200)
    ProgressBarBg.Text = ""
    ProgressBarBg.AutoButtonColor = false
    ProgressBarBg.Parent = ControlsFrame
    
    local ProgressFill = Instance.new("Frame")
    ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    ProgressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ProgressFill.BorderSizePixel = 0
    ProgressFill.Parent = ProgressBarBg
    
    local ProgressText = Instance.new("TextLabel")
    ProgressText.Size = UDim2.new(1, 0, 1, 0)
    ProgressText.BackgroundTransparency = 1
    ProgressText.Text = "0.000 / 0.000 (0ms)"
    ProgressText.TextColor3 = Color3.fromRGB(150, 150, 150)
    ProgressText.Font = Enum.Font.Code
    ProgressText.TextSize = 11
    ProgressText.Parent = ProgressBarBg
    
    -- Right Side (Editor)
    local RightPanel = Instance.new("Frame")
    RightPanel.Size = UDim2.new(0.4, -10, 1, -35)
    RightPanel.Position = UDim2.new(0.6, 5, 0, 30)
    RightPanel.BackgroundTransparency = 1
    RightPanel.Parent = VisFrame
    
    local EditorTitle = Instance.new("TextLabel")
    EditorTitle.Size = UDim2.new(1, 0, 0, 20)
    EditorTitle.BackgroundTransparency = 1
    EditorTitle.Text = "⚙ Quick Edit Timing"
    EditorTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    EditorTitle.Font = Enum.Font.Code
    EditorTitle.TextSize = 12
    EditorTitle.Parent = RightPanel
    
    local fields = {
        {"Delay (s):", "0.15"},
        {"Hitbox X:", "11"},
        {"Hitbox Y:", "10"},
        {"Hitbox Z:", "30.5"},
        {"HSO:", "3"},
        {"Max Dist:", "85"},
        {"Repeat:", "1"},
        {"Rep Delay:", "0.35"},
        {"Dodge Dir:", "None"}
    }
    
    local function createField(name, default, yOffset)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.4, 0, 0, 20)
        lbl.Position = UDim2.new(0, 0, 0, yOffset)
        lbl.BackgroundTransparency = 1
        lbl.Text = name
        lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = RightPanel
        
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0.6, 0, 0, 20)
        box.Position = UDim2.new(0.4, 0, 0, yOffset)
        box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        box.BorderSizePixel = 1
        box.BorderColor3 = Color3.fromRGB(100, 100, 100)
        box.Text = default
        box.TextColor3 = Color3.fromRGB(220, 220, 220)
        box.Font = Enum.Font.Code
        box.TextSize = 11
        box.Parent = RightPanel
    end
    
    local yOff = 30
    for _, f in ipairs(fields) do
        createField(f[1], f[2], yOff)
        yOff = yOff + 25
    end
    
    local SaveBtn = Instance.new("TextButton")
    SaveBtn.Size = UDim2.new(1, 0, 0, 30)
    SaveBtn.Position = UDim2.new(0, 0, 1, -30)
    SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    SaveBtn.BorderSizePixel = 0
    SaveBtn.Text = "💾 Save & Apply"
    SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SaveBtn.Font = Enum.Font.GothamBold
    SaveBtn.TextSize = 12
    SaveBtn.Parent = RightPanel
    
    local SaveBtnCorner = Instance.new("UICorner")
    SaveBtnCorner.CornerRadius = UDim.new(0, 6)
    SaveBtnCorner.Parent = SaveBtn
    
    SaveBtn.MouseButton1Click:Connect(function()
        if not activeAnimTrack then return end
        
        local delaySeconds = 0
        if activeAnimTrack.Length > 0 then
            delaySeconds = activeAnimTrack.TimePosition
        end
        
        if not isfolder("parryids") then
            makefolder("parryids")
        end
        
        local cleanId = animId:match("%d+")
        if not cleanId then cleanId = animId end
        
        local data = {
            id = animId,
            delay = delaySeconds
        }
        
        local success = pcall(function()
            writefile("parryids/" .. cleanId .. ".json", game:GetService("HttpService"):JSONEncode(data))
        end)
        
        if success then
            for _, child in ipairs(ScrollList:GetChildren()) do
                if child:IsA("Frame") then
                    local idLbl = child:FindFirstChild("IDBtn")
                    if idLbl and idLbl.Text == cleanId then
                        local statusLbl = child:FindFirstChild("Status")
                        if statusLbl then
                            statusLbl.Text = "LOGGED"
                            statusLbl.TextColor3 = Color3.fromRGB(0, 255, 0)
                        end
                    end
                end
            end
            
            SaveBtn.Text = "✓ Saved!"
            task.delay(1, function()
                if SaveBtn and SaveBtn.Parent then
                    SaveBtn.Text = "💾 Save & Apply"
                end
            end)
            
            if AutoParryController and AutoParryController.LoadSavedTimings then
                AutoParryController:LoadSavedTimings()
            end
        end
    end)
    
    -- Viewport Logic
    local WorldModel = Instance.new("WorldModel")
    WorldModel.Parent = Viewport
    
    local Cam = Instance.new("Camera")
    Viewport.CurrentCamera = Cam
    Cam.Parent = Viewport
    
    local dummy
    
    -- Check if sourceCharacter is an NPC (not a real player's character)
    local isNPC = sourceCharacter and (Players:GetPlayerFromCharacter(sourceCharacter) == nil)
    
    if isNPC and sourceCharacter and sourceCharacter.PrimaryPart then
        -- Use the NPC's actual model
        pcall(function()
            sourceCharacter.Archivable = true
            dummy = sourceCharacter:Clone()
        end)
    else
        -- Use the local player's grey clone (player animations are replicated)
        pcall(function()
            local c = LocalPlayer.Character
            if c then
                c.Archivable = true
                dummy = c:Clone()
            end
        end)
    end
    
    if dummy then
        -- Clean up dummy
        for _, child in ipairs(dummy:GetDescendants()) do
            if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("Decal") then
                child:Destroy()
            elseif child:IsA("BasePart") then
                child.Color = Color3.fromRGB(150, 150, 150)
                child.Material = Enum.Material.SmoothPlastic
            end
        end
        dummy.Parent = WorldModel
        
        -- Listen for source character death/despawn to clean up the dummy model
        if sourceCharacter then
            local sourceHumanoid = sourceCharacter:FindFirstChildOfClass("Humanoid")
            if sourceHumanoid then
                deathConn = sourceHumanoid.Died:Connect(function()
                    if dummy then
                        dummy:Destroy()
                        dummy = nil
                    end
                end)
            end
            ancestorConn = sourceCharacter.AncestryChanged:Connect(function(_, parent)
                if not parent then
                    if dummy then
                        dummy:Destroy()
                        dummy = nil
                    end
                end
            end)
        end
        
        local camRotAngle = 0
        local function updateCamera()
            if not dummy or not dummy.PrimaryPart then return end
            local hrp = dummy.PrimaryPart
            local dist = 10
            local height = 2
            local orbitCFrame = hrp.CFrame * CFrame.Angles(0, math.rad(camRotAngle), 0)
            local camPos = orbitCFrame.Position + (orbitCFrame.LookVector * dist) + Vector3.new(0, height, 0)
            Cam.CFrame = CFrame.new(camPos, hrp.Position)
        end
        updateCamera()
        
        local humanoid = dummy:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if animator then
            local anim = Instance.new("Animation")
            anim.AnimationId = animId
            activeAnimTrack = animator:LoadAnimation(anim)
            activeAnimTrack:Play()
            
            local isPlaying = true
            PlayPauseBtn.MouseButton1Click:Connect(function()
                isPlaying = not isPlaying
                if isPlaying then
                    activeAnimTrack:AdjustSpeed(1)
                    PlayPauseBtn.Text = "||"
                else
                    activeAnimTrack:AdjustSpeed(0)
                    PlayPauseBtn.Text = "▶"
                end
            end)
            
            local isDraggingCam = false
            CamSliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDraggingCam = true
                    local pct = math.clamp((input.Position.X - CamSliderBg.AbsolutePosition.X) / CamSliderBg.AbsoluteSize.X, 0, 1)
                    CamSliderKnob.Position = UDim2.new(pct, -5, 0, 0)
                    camRotAngle = (pct - 0.5) * 360
                    updateCamera()
                end
            end)
            CamSliderBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDraggingCam = false
                end
            end)
            if visCamDragConnection then visCamDragConnection:Disconnect() end
            visCamDragConnection = UserInputService.InputChanged:Connect(function(input)
                if isDraggingCam and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pct = math.clamp((input.Position.X - CamSliderBg.AbsolutePosition.X) / CamSliderBg.AbsoluteSize.X, 0, 1)
                    CamSliderKnob.Position = UDim2.new(pct, -5, 0, 0)
                    camRotAngle = (pct - 0.5) * 360
                    updateCamera()
                end
            end)
            
            local isDraggingBar = false
            ProgressBarBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDraggingBar = true
                    local pct = math.clamp((input.Position.X - ProgressBarBg.AbsolutePosition.X) / ProgressBarBg.AbsoluteSize.X, 0, 1)
                    if activeAnimTrack and activeAnimTrack.Length > 0 then
                        activeAnimTrack.TimePosition = activeAnimTrack.Length * pct
                    end
                end
            end)
            ProgressBarBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDraggingBar = false
                end
            end)
            if visDragConnection then visDragConnection:Disconnect() end
            visDragConnection = UserInputService.InputChanged:Connect(function(input)
                if isDraggingBar and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pct = math.clamp((input.Position.X - ProgressBarBg.AbsolutePosition.X) / ProgressBarBg.AbsoluteSize.X, 0, 1)
                    if activeAnimTrack and activeAnimTrack.Length > 0 then
                        activeAnimTrack.TimePosition = activeAnimTrack.Length * pct
                    end
                end
            end)
            
            visConnection = RunService.RenderStepped:Connect(function()
                if not dummy then return end
                if not activeAnimTrack then return end
                local len = activeAnimTrack.Length
                if len > 0 then
                    local pos = activeAnimTrack.TimePosition
                    ProgressFill.Size = UDim2.new(math.clamp(pos / len, 0, 1), 0, 1, 0)
                    ProgressText.Text = string.format("%.3f / %.3f (%.0fms)", pos, len, len * 1000)
                    
                    if pos >= len * 0.99 and isPlaying then
                        activeAnimTrack.TimePosition = 0
                        activeAnimTrack:Play()
                    end
                end
            end)
        end
    end
end

local function extractID(animationId)
    if not animationId then return "N/A" end
    local id = string.match(animationId, "%d+")
    return id or animationId
end

local function addEntry(animId, enemyName, dist, characterRef)
    entryCount = entryCount + 1
    
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 20)
    row.BackgroundTransparency = entryCount % 2 == 0 and 0.85 or 1
    row.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    row.BorderSizePixel = 0
    row.LayoutOrder = -entryCount -- Newest at top
    
    local function createRowLabel(text, sizeScale, posScale, color)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(sizeScale, 0, 1, 0)
        lbl.Position = UDim2.new(posScale, 0, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = tostring(text)
        lbl.TextColor3 = color or Color3.fromRGB(0, 200, 100)
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.Parent = row
        return lbl
    end
    
    local currTime = os.date("%H:%M:%S")
    local extractedId = extractID(animId)
    local shortId = string.sub(extractedId, 1, 5) .. ".."
    
    createRowLabel(currTime, 0.12, 0.02, Color3.fromRGB(0, 150, 50))
    createRowLabel("ID: " .. shortId, 0.16, 0.14)
    
    local idBtn = Instance.new("TextButton")
    idBtn.Name = "IDBtn"
    idBtn.Size = UDim2.new(0.22, 0, 1, 0)
    idBtn.Position = UDim2.new(0.30, 0, 0, 0)
    idBtn.BackgroundTransparency = 1
    idBtn.Text = extractedId
    idBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
    idBtn.Font = Enum.Font.Code
    idBtn.TextSize = 12
    idBtn.TextXAlignment = Enum.TextXAlignment.Left
    idBtn.TextTruncate = Enum.TextTruncate.AtEnd
    idBtn.Parent = row
    
    idBtn.MouseButton1Click:Connect(function()
        _G.SelectedAnimId = extractedId
        if _G.openVisualizer then
            _G.openVisualizer(animId, characterRef)
        end
    end)
    createRowLabel(enemyName, 0.25, 0.52)
    createRowLabel(math.floor(dist), 0.08, 0.77, Color3.fromRGB(0, 255, 150))
    local statusLbl = createRowLabel("NEW", 0.10, 0.88, Color3.fromRGB(255, 60, 60))
    statusLbl.Name = "Status"
    
    if isfolder and isfile and isfolder("parryids") then
        if isfile("parryids/" .. extractedId .. ".json") then
            statusLbl.Text = "LOGGED"
            statusLbl.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
    end
    
    row.Parent = ScrollList
    
    EntryCountLabel.Text = entryCount .. " entries"
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
    
    -- Cleanup old entries
    local children = {}
    for _, child in ipairs(ScrollList:GetChildren()) do
        if child:IsA("Frame") then
            table.insert(children, child)
        end
    end
    
    if #children > maxEntries then
        table.sort(children, function(a, b) return a.LayoutOrder > b.LayoutOrder end)
        for i = maxEntries + 1, #children do
            children[i]:Destroy()
        end
    end
end

local trackedAnimators = {}

local function setupAnimator(animator, character)
    if trackedAnimators[animator] then return end
    trackedAnimators[animator] = true
    
    local conn = animator.AnimationPlayed:Connect(function(animationTrack)
        -- Ignore local player
        if character == LocalPlayer.Character then return end
        
        -- Pause Filter
        if _G.LoggingPaused then return end
        
        -- Player / Mob Filter
        local isPlayer = Players:GetPlayerFromCharacter(character) ~= nil
        if isPlayer and not _G.LogPlayers then return end
        if not isPlayer and not _G.LogMobs then return end
        
        -- Movement / Looped Animation Filters
        if animationTrack.Looped == true then return end
        
        local animName = string.lower(animationTrack.Name or "")
        local animObjName = animationTrack.Animation and string.lower(animationTrack.Animation.Name or "") or ""
        if string.find(animName, "walk") or string.find(animName, "run") or string.find(animName, "idle") or 
           string.find(animName, "locomotion") or string.find(animName, "dash") or string.find(animName, "sprint") or 
           string.find(animName, "jump") or string.find(animName, "fall") or string.find(animName, "movement") then
            return
        end
        if string.find(animObjName, "walk") or string.find(animObjName, "run") or string.find(animObjName, "idle") or 
           string.find(animObjName, "locomotion") or string.find(animObjName, "dash") or string.find(animObjName, "sprint") or 
           string.find(animObjName, "jump") or string.find(animObjName, "fall") or string.find(animObjName, "movement") then
            return
        end
        
        local animId = animationTrack.Animation and animationTrack.Animation.AnimationId
        if not animId or animId == "" then return end
        
        local dist = 0
        local lpChar = LocalPlayer.Character
        if lpChar and lpChar.PrimaryPart and character.PrimaryPart then
            dist = (lpChar.PrimaryPart.Position - character.PrimaryPart.Position).Magnitude
        end
        
        local maxRadius = tonumber(RadiusBox.Text)
        if maxRadius and dist > maxRadius then
            return
        end
        
        addEntry(animId, character.Name, dist, character)
    end)
    
    table.insert(connections, conn)
end

local function scanCharacter(character)
    if not character or not character:IsA("Model") then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if animator then
            setupAnimator(animator, character)
        else
            local conn; conn = humanoid.ChildAdded:Connect(function(child)
                if child:IsA("Animator") then
                    setupAnimator(child, character)
                    conn:Disconnect()
                end
            end)
            table.insert(connections, conn)
        end
    end
end

-- Start Tracking
local function startTracking()
    -- Scan existing workspace
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Humanoid") then
            scanCharacter(obj.Parent)
        end
    end
    
    -- Listen for new objects
    local wsConn = Workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Humanoid") then
            task.delay(0.5, function()
                scanCharacter(descendant.Parent)
            end)
        elseif descendant:IsA("Animator") and descendant.Parent and descendant.Parent:IsA("Humanoid") then
            setupAnimator(descendant, descendant.Parent.Parent)
        end
    end)
    
    table.insert(connections, wsConn)
end

startTracking()

_G.ToggleInfoLogger = function(state)
    if ScreenGui then
        if state == nil then
            ScreenGui.Enabled = not ScreenGui.Enabled
        else
            ScreenGui.Enabled = state
        end
    end
end
