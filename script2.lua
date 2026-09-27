local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera

local flagtables = {
    ["DFIntMaximumUnstickForceInGs"] = "-15"
}

local function m(z)
    z = z:gsub("^DFInt", "")
    z = z:gsub("^DFFlag", "")
    z = z:gsub("FString", "")
    z = z:gsub("FLog", "")
    z = z:gsub("^FFlag", "")
    z = z:gsub("^DFint", "")
    z = z:gsub("^FInt", "")
    return z
end

local function setFlag(value)
    if not setfflag then return false end
    for k, _ in pairs(flagtables) do
        if getfflag(m(k)) then
            setfflag(m(k), value)
        elseif getfflag(k) then
            setfflag(k, value)
        end
    end
    return true
end

local function applyFlags() return setFlag("-15") end
local function resetFlags() return setFlag("0") end

local old = PlayerGui:FindFirstChild("SylaHub")
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SylaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 420, 0, 520)
Main.Position = UDim2.new(0.5, -210, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Main

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 75)
UIStroke.Thickness = 1
UIStroke.Parent = Main

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 12)
TopFix.Position = UDim2.new(0, 0, 1, -12)
TopFix.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Syla Hub"
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(1, -80, 0, 12)
Subtitle.Position = UDim2.new(0, 14, 0, 22)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Syla Hub by Enes"
Subtitle.TextColor3 = Color3.fromRGB(130, 130, 145)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 11
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar

local Minimize = Instance.new("TextButton")
Minimize.Name = "Minimize"
Minimize.Size = UDim2.new(0, 28, 0, 28)
Minimize.Position = UDim2.new(1, -68, 0, 4)
Minimize.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Minimize.BorderSizePixel = 0
Minimize.Text = "—"
Minimize.TextColor3 = Color3.fromRGB(220, 220, 230)
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 14
Minimize.AutoButtonColor = false
Minimize.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = Minimize

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -36, 0, 4)
Close.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(220, 220, 230)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Close.AutoButtonColor = false
Close.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = Close

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "Scroll"
ScrollFrame.Size = UDim2.new(1, -20, 1, -56)
ScrollFrame.Position = UDim2.new(0, 10, 0, 46)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(90, 140, 255)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.Parent = Main

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.Padding = UDim.new(0, 8)
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollLayout.Parent = ScrollFrame

local ScrollPadding = Instance.new("UIPadding")
ScrollPadding.PaddingTop = UDim.new(0, 4)
ScrollPadding.PaddingBottom = UDim.new(0, 8)
ScrollPadding.PaddingRight = UDim.new(0, 6)
ScrollPadding.Parent = ScrollFrame

local function makeRow(height)
    local Row = Instance.new("Frame")
    Row.Name = "Row"
    Row.Size = UDim2.new(1, 0, 0, height or 52)
    Row.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    Row.BorderSizePixel = 0
    Row.Parent = ScrollFrame

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 8)
    RowCorner.Parent = Row

    local RowStroke = Instance.new("UIStroke")
    RowStroke.Color = Color3.fromRGB(50, 50, 62)
    RowStroke.Thickness = 1
    RowStroke.Parent = Row

    return Row
end

local function makeSwitch(parent, initialState, callback)
    local Switch = Instance.new("TextButton")
    Switch.Name = "Switch"
    Switch.Size = UDim2.new(0, 46, 0, 24)
    Switch.Position = UDim2.new(1, -60, 0.5, -12)
    Switch.BackgroundColor3 = initialState and Color3.fromRGB(90, 140, 255) or Color3.fromRGB(50, 50, 62)
    Switch.BorderSizePixel = 0
    Switch.Text = ""
    Switch.AutoButtonColor = false
    Switch.Parent = parent

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch

    local Knob = Instance.new("Frame")
    Knob.Name = "Knob"
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = initialState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    Knob.BorderSizePixel = 0
    Knob.Parent = Switch

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local state = initialState

    local function update(newState)
        state = newState
        local targetColor = state and Color3.fromRGB(90, 140, 255) or Color3.fromRGB(50, 50, 62)
        local knobPos = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        TweenService:Create(Switch, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(Knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Position = knobPos}):Play()
    end

    Switch.MouseButton1Click:Connect(function()
        update(not state)
        callback(state)
    end)

    return {
        Set = update,
        Get = function() return state end
    }
end

local function makeSlider(parent, min, max, default, callback)
    local Slider = Instance.new("Frame")
    Slider.Name = "Slider"
    Slider.Size = UDim2.new(1, -28, 0, 20)
    Slider.Position = UDim2.new(0, 14, 1, -30)
    Slider.BackgroundColor3 = Color3.fromRGB(50, 50, 62)
    Slider.BorderSizePixel = 0
    Slider.Parent = parent

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1, 0)
    SliderCorner.Parent = Slider

    local Fill = Instance.new("Frame")
    Fill.Name = "Fill"
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(90, 140, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = Slider

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local Knob = Instance.new("Frame")
    Knob.Name = "Knob"
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
    Knob.BorderSizePixel = 0
    Knob.Parent = Slider

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Name = "ValueLabel"
    ValueLabel.Size = UDim2.new(0, 60, 0, 18)
    ValueLabel.Position = UDim2.new(1, -74, 0, 8)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(180, 180, 195)
    ValueLabel.Font = Enum.Font.GothamMedium
    ValueLabel.TextSize = 12
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = parent

    local value = default
    local dragging = false

    local function updateFromX(x)
        local rel = math.clamp((x - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * rel + 0.5)
        Fill.Size = UDim2.new(rel, 0, 1, 0)
        Knob.Position = UDim2.new(rel, -7, 0.5, -7)
        ValueLabel.Text = tostring(value)
        callback(value)
    end

    Slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(input.Position.X)
        end
    end)

    Slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(input.Position.X)
        end
    end)

    return {
        Get = function() return value end,
        Set = function(v)
            value = math.clamp(v, min, max)
            local rel = (value - min) / (max - min)
            Fill.Size = UDim2.new(rel, 0, 1, 0)
            Knob.Position = UDim2.new(rel, -7, 0.5, -7)
            ValueLabel.Text = tostring(value)
            callback(value)
        end
    }
end

local function makeNotify(text, duration)
    local existing = ScreenGui:FindFirstChild("Notify")
    if existing then existing:Destroy() end

    local Notify = Instance.new("Frame")
    Notify.Name = "Notify"
    Notify.Size = UDim2.new(0, 240, 0, 44)
    Notify.Position = UDim2.new(0.5, -120, 0, -60)
    Notify.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    Notify.BorderSizePixel = 0
    Notify.Parent = ScreenGui

    local NCorner = Instance.new("UICorner")
    NCorner.CornerRadius = UDim.new(0, 8)
    NCorner.Parent = Notify

    local NStroke = Instance.new("UIStroke")
    NStroke.Color = Color3.fromRGB(90, 140, 255)
    NStroke.Thickness = 1
    NStroke.Parent = Notify

    local NLabel = Instance.new("TextLabel")
    NLabel.Size = UDim2.new(1, -20, 1, 0)
    NLabel.Position = UDim2.new(0, 10, 0, 0)
    NLabel.BackgroundTransparency = 1
    NLabel.Text = text
    NLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
    NLabel.Font = Enum.Font.GothamMedium
    NLabel.TextSize = 14
    NLabel.Parent = Notify

    TweenService:Create(Notify, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -120, 0, 20)}):Play()

    task.delay(duration, function()
        if Notify and Notify.Parent then
            local t = TweenService:Create(Notify, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -120, 0, -60)})
            t:Play()
            t.Completed:Connect(function()
                Notify:Destroy()
            end)
        end
    end)
end

local FFlagRow = makeRow(52)
local FFlagLabel = Instance.new("TextLabel")
FFlagLabel.Size = UDim2.new(1, -90, 1, 0)
FFlagLabel.Position = UDim2.new(0, 14, 0, 0)
FFlagLabel.BackgroundTransparency = 1
FFlagLabel.Text = "Wall Glide FFlag"
FFlagLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
FFlagLabel.Font = Enum.Font.GothamMedium
FFlagLabel.TextSize = 14
FFlagLabel.TextXAlignment = Enum.TextXAlignment.Left
FFlagLabel.Parent = FFlagRow

local FFlagEnabled = false
makeSwitch(FFlagRow, false, function(state)
    FFlagEnabled = state
    if state then
        applyFlags()
        makeNotify("FFlag applied", 2)
    else
        resetFlags()
        makeNotify("FFlag reset", 2)
    end
end)

local SpeedRow = makeRow(52)
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -90, 1, 0)
SpeedLabel.Position = UDim2.new(0, 14, 0, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed (CFrame)"
SpeedLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
SpeedLabel.Font = Enum.Font.GothamMedium
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SpeedRow

local SpeedEnabled = false
makeSwitch(SpeedRow, false, function(state)
    SpeedEnabled = state
    makeNotify(state and "Speed CFrame enabled" or "Speed CFrame disabled", 2)
end)

local Speed2Row = makeRow(52)
local Speed2Label = Instance.new("TextLabel")
Speed2Label.Size = UDim2.new(1, -90, 1, 0)
Speed2Label.Position = UDim2.new(0, 14, 0, 0)
Speed2Label.BackgroundTransparency = 1
Speed2Label.Text = "Speed (CFrame) V2"
Speed2Label.TextColor3 = Color3.fromRGB(235, 235, 240)
Speed2Label.Font = Enum.Font.GothamMedium
Speed2Label.TextSize = 14
Speed2Label.TextXAlignment = Enum.TextXAlignment.Left
Speed2Label.Parent = Speed2Row

local Speed2Enabled = false
makeSwitch(Speed2Row, false, function(state)
    Speed2Enabled = state
    makeNotify(state and "Speed CFrame V2 enabled" or "Speed CFrame V2 disabled", 2)
end)

local Speed3Row = makeRow(52)
local Speed3Label = Instance.new("TextLabel")
Speed3Label.Size = UDim2.new(1, -90, 1, 0)
Speed3Label.Position = UDim2.new(0, 14, 0, 0)
Speed3Label.BackgroundTransparency = 1
Speed3Label.Text = "Speed (CFrame) V3"
Speed3Label.TextColor3 = Color3.fromRGB(235, 235, 240)
Speed3Label.Font = Enum.Font.GothamMedium
Speed3Label.TextSize = 14
Speed3Label.TextXAlignment = Enum.TextXAlignment.Left
Speed3Label.Parent = Speed3Row

local Speed3Enabled = false
makeSwitch(Speed3Row, false, function(state)
    Speed3Enabled = state
    makeNotify(state and "Speed CFrame V3 enabled" or "Speed CFrame V3 disabled", 2)
end)

local TeleportRow = makeRow(52)
local TeleportLabel = Instance.new("TextLabel")
TeleportLabel.Size = UDim2.new(1, -90, 1, 0)
TeleportLabel.Position = UDim2.new(0, 14, 0, 0)
TeleportLabel.BackgroundTransparency = 1
TeleportLabel.Text = "Teleport Bypass"
TeleportLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
TeleportLabel.Font = Enum.Font.GothamMedium
TeleportLabel.TextSize = 14
TeleportLabel.TextXAlignment = Enum.TextXAlignment.Left
TeleportLabel.Parent = TeleportRow

local TeleportEnabled = false
makeSwitch(TeleportRow, false, function(state)
    TeleportEnabled = state
    makeNotify(state and "Teleport Bypass enabled" or "Teleport Bypass disabled", 2)
end)

local BombRow = makeRow(52)
local BombLabel = Instance.new("TextLabel")
BombLabel.Size = UDim2.new(1, -90, 1, 0)
BombLabel.Position = UDim2.new(0, 14, 0, 0)
BombLabel.BackgroundTransparency = 1
BombLabel.Text = "Auto Give Bomb"
BombLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
BombLabel.Font = Enum.Font.GothamMedium
BombLabel.TextSize = 14
BombLabel.TextXAlignment = Enum.TextXAlignment.Left
BombLabel.Parent = BombRow

local AutoBombEnabled = false
makeSwitch(BombRow, false, function(state)
    AutoBombEnabled = state
    if state then
        makeNotify("Auto Give Bomb enabled", 2)
    else
        makeNotify("Auto Give Bomb disabled", 2)
    end
end)

local BombRangeRow = makeRow(62)
local BombRangeLabel = Instance.new("TextLabel")
BombRangeLabel.Size = UDim2.new(1, -90, 0, 20)
BombRangeLabel.Position = UDim2.new(0, 14, 0, 8)
BombRangeLabel.BackgroundTransparency = 1
BombRangeLabel.Text = "Reach Range"
BombRangeLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
BombRangeLabel.Font = Enum.Font.GothamMedium
BombRangeLabel.TextSize = 14
BombRangeLabel.TextXAlignment = Enum.TextXAlignment.Left
BombRangeLabel.Parent = BombRangeRow

local BombRange = 30
makeSlider(BombRangeRow, 5, 100, 30, function(v)
    BombRange = v
end)

local HitboxRow = makeRow(52)
local HitboxLabel = Instance.new("TextLabel")
HitboxLabel.Size = UDim2.new(1, -90, 1, 0)
HitboxLabel.Position = UDim2.new(0, 14, 0, 0)
HitboxLabel.BackgroundTransparency = 1
HitboxLabel.Text = "Hitbox Expander"
HitboxLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
HitboxLabel.Font = Enum.Font.GothamMedium
HitboxLabel.TextSize = 14
HitboxLabel.TextXAlignment = Enum.TextXAlignment.Left
HitboxLabel.Parent = HitboxRow

local HitboxEnabled = false
makeSwitch(HitboxRow, false, function(state)
    HitboxEnabled = state
    if state then
        makeNotify("Hitbox Expander enabled", 2)
    else
        makeNotify("Hitbox Expander disabled", 2)
    end
end)

local HitboxSizeRow = makeRow(62)
local HitboxSizeLabel = Instance.new("TextLabel")
HitboxSizeLabel.Size = UDim2.new(1, -90, 0, 20)
HitboxSizeLabel.Position = UDim2.new(0, 14, 0, 8)
HitboxSizeLabel.BackgroundTransparency = 1
HitboxSizeLabel.Text = "Hitbox Size"
HitboxSizeLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
HitboxSizeLabel.Font = Enum.Font.GothamMedium
HitboxSizeLabel.TextSize = 14
HitboxSizeLabel.TextXAlignment = Enum.TextXAlignment.Left
HitboxSizeLabel.Parent = HitboxSizeRow

local HitboxSize = 5
makeSlider(HitboxSizeRow, 1, 20, 5, function(v)
    HitboxSize = v
end)

Minimize.MouseButton1Click:Connect(function()
    ScrollFrame.Visible = not ScrollFrame.Visible
    Main.Size = ScrollFrame.Visible and UDim2.new(0, 420, 0, 520) or UDim2.new(0, 420, 0, 46)
end)

Close.MouseButton1Click:Connect(function()
    resetFlags()
    if ReachCircle then ReachCircle:Destroy() end
    if SpinBV then SpinBV:Destroy() end
    ScreenGui:Destroy()
end)

local function getCharacter()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return nil end
    return char, hrp, hum
end

local speeds = {
    {flag = function() return SpeedEnabled end, speed = 60},
    {flag = function() return Speed2Enabled end, speed = 100},
    {flag = function() return Speed3Enabled end, speed = 150},
}

RunService.RenderStepped:Connect(function(dt)
    local char, hrp, hum = getCharacter()
    if not char or not hrp or not hum then return end
    if hum.Health <= 0 then return end

    local moveDir = hum.MoveDirection
    if moveDir.Magnitude < 0.01 then return end

    for _, entry in ipairs(speeds) do
        if entry.flag() then
            local delta = moveDir * entry.speed * dt
            hrp.CFrame = hrp.CFrame + delta
        end
    end
end)

local ReachCircle = nil

RunService.RenderStepped:Connect(function()
    if not AutoBombEnabled then
        if ReachCircle then
            ReachCircle:Destroy()
            ReachCircle = nil
        end
        return
    end

    local char, hrp = getCharacter()
    if not char or not hrp then
        if ReachCircle then
            ReachCircle:Destroy()
            ReachCircle = nil
        end
        return
    end

    if not ReachCircle or not ReachCircle.Parent then
        ReachCircle = Instance.new("Part")
        ReachCircle.Name = "SylaReachCircle"
        ReachCircle.Shape = Enum.PartType.Ball
        ReachCircle.Material = Enum.Material.ForceField
        ReachCircle.Color = Color3.fromRGB(60, 140, 255)
        ReachCircle.Transparency = 0.75
        ReachCircle.CanCollide = false
        ReachCircle.CanTouch = false
        ReachCircle.CanQuery = false
        ReachCircle.Anchored = true
        ReachCircle.CastShadow = false
        ReachCircle.Size = Vector3.new(BombRange * 2, BombRange * 2, BombRange * 2)
        ReachCircle.Parent = Camera
    end

    ReachCircle.Size = Vector3.new(BombRange * 2, BombRange * 2, BombRange * 2)
    ReachCircle.CFrame = hrp.CFrame
end)

local function hasToolWithName(char, name)
    if not char then return false end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and string.find(string.lower(tool.Name), string.lower(name)) then
            return true
        end
    end
    return false
end

local function anyPlayerHasBomb()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char and hasToolWithName(char, "bomb") then
                return true
            end
        end
    end
    return false
end

local function localHasTool()
    local char = LocalPlayer.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then return true end
        end
    end
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then return true end
        end
    end
    return false
end

local SpinBV = nil
local BombLoopActive = false

local function startSpin(hrp)
    if SpinBV then SpinBV:Destroy() end
    SpinBV = Instance.new("BodyAngularVelocity")
    SpinBV.AngularVelocity = Vector3.new(0, 30, 0)
    SpinBV.MaxTorque = Vector3.new(0, math.huge, 0)
    SpinBV.P = 3000
    SpinBV.Parent = hrp
end

local function stopSpin()
    if SpinBV then
        SpinBV:Destroy()
        SpinBV = nil
    end
end

task.spawn(function()
    while task.wait(0.15) do
        if not AutoBombEnabled then
            BombLoopActive = false
            stopSpin()
            continue
        end

        local char, hrp, hum = getCharacter()
        if not char or not hrp or not hum or hum.Health <= 0 then
            BombLoopActive = false
            stopSpin()
            continue
        end

        if not localHasTool() then
            BombLoopActive = false
            stopSpin()
            continue
        end

        if anyPlayerHasBomb() then
            BombLoopActive = false
            stopSpin()
            continue
        end

        if BombLoopActive then continue end

        local target = nil
        local targetPlr = nil
        local closest = math.huge

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local pChar = plr.Character
                if pChar then
                    local pRoot = pChar:FindFirstChild("HumanoidRootPart")
                    local pHum = pChar:FindFirstChildOfClass("Humanoid")
                    if pRoot and pHum and pHum.Health > 0 then
                        local dist = (pRoot.Position - hrp.Position).Magnitude
                        if dist <= BombRange and dist < closest then
                            closest = dist
                            target = pRoot
                            targetPlr = plr
                        end
                    end
                end
            end
        end

        if target and targetPlr then
            local savedPos = hrp.CFrame
            BombLoopActive = true
            startSpin(hrp)

            task.spawn(function()
                while AutoBombEnabled and BombLoopActive do
                    local c, r = getCharacter()
                    if not c or not r then break end

                    local tp = targetPlr.Character
                    if not tp then break end
                    local tRoot = tp:FindFirstChild("HumanoidRootPart")
                    local tHum = tp:FindFirstChildOfClass("Humanoid")
                    if not tRoot or not tHum or tHum.Health <= 0 then break end

                    if hasToolWithName(tp, "bomb") then break end

                    r.CFrame = CFrame.new(tRoot.Position)
                    task.wait()
                end

                stopSpin()
                local c, r = getCharacter()
                if c and r and savedPos then
                    r.CFrame = savedPos
                end
                BombLoopActive = false
            end)
        end
    end
end)

local originalHeadProps = {}

local function expandHitbox(plr)
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if not originalHeadProps[head] then
        originalHeadProps[head] = {
            Size = head.Size,
            Transparency = head.Transparency,
            CanCollide = head.CanCollide,
            CanTouch = head.CanTouch,
            Massless = head.Massless,
            Material = head.Material,
        }
    end

    head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
    head.Transparency = 0.7
    head.CanCollide = false
    head.CanTouch = true
    head.Massless = true
end

local function restoreHitbox(plr)
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local orig = originalHeadProps[head]
    if orig then
        head.Size = orig.Size
        head.Transparency = orig.Transparency
        head.CanCollide = orig.CanCollide
        head.CanTouch = orig.CanTouch
        head.Massless = orig.Massless
        head.Material = orig.Material
        originalHeadProps[head] = nil
    else
        head.Size = Vector3.new(2, 1, 1)
        head.Transparency = 0
        head.CanCollide = false
        head.CanTouch = true
        head.Massless = false
    end
end

local function handleCharacter(plr, char)
    if plr == LocalPlayer then return end

    local function hookHead()
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        if HitboxEnabled then
            task.wait(0.5)
            expandHitbox(plr)
        end
    end

    task.spawn(hookHead)

    char.ChildAdded:Connect(function(c)
        if c.Name == "Head" then
            task.wait(0.3)
            if HitboxEnabled then
                expandHitbox(plr)
            end
        end
    end)

    char.AncestryChanged:Connect(function()
        if not char:IsDescendantOf(Workspace) then
            originalHeadProps[char:FindFirstChild("Head")] = nil
        end
    end)

    if HitboxEnabled then
        task.wait(0.5)
        expandHitbox(plr)
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function(c)
            handleCharacter(plr, c)
        end)
        if plr.Character then
            handleCharacter(plr, plr.Character)
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    if plr == LocalPlayer then return end
    plr.CharacterAdded:Connect(function(c)
        handleCharacter(plr, c)
    end)
    if plr.Character then
        handleCharacter(plr, plr.Character)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr == LocalPlayer then return end
    local char = plr.Character
    if char then
        local head = char:FindFirstChild("Head")
        if head then
            originalHeadProps[head] = nil
        end
    end
end)

local hitboxUpdateTick = 0
RunService.Heartbeat:Connect(function(dt)
    if not HitboxEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                restoreHitbox(plr)
            end
        end
        return
    end

    hitboxUpdateTick = hitboxUpdateTick + dt
    if hitboxUpdateTick < 0.2 then return end
    hitboxUpdateTick = 0

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
                local head = char:FindFirstChild("Head")
                if head then
                    if head.Size ~= Vector3.new(HitboxSize, HitboxSize, HitboxSize) then
                        if not originalHeadProps[head] then
                            originalHeadProps[head] = {
                                Size = Vector3.new(2, 1, 1),
                                Transparency = 0,
                                CanCollide = false,
                                CanTouch = true,
                                Massless = false,
                                Material = head.Material,
                            }
                        end
                    end
                    head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    head.Transparency = 0.7
                    head.CanCollide = false
                    head.CanTouch = true
                    head.Massless = true
                end
            end
        end
    end
end)

local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        if FFlagEnabled then
            task.wait(0.5)
            applyFlags()
            makeNotify("Reapplied", 2)
        end
        stopSpin()
        BombLoopActive = false
    end)
end

if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
