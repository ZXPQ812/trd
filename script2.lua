local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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

local function applyFlags()
    if not setfflag then return false end
    for k, v in pairs(flagtables) do
        if getfflag(m(k)) then
            setfflag(m(k), v)
        elseif getfflag(k) then
            setfflag(k, v)
        end
    end
    return true
end

local old = PlayerGui:FindFirstChild("SylaHub")
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SylaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 420, 0, 440)
Main.Position = UDim2.new(0.5, -210, 0.5, -220)
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

local function makeButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(235, 235, 240)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 14
    Button.AutoButtonColor = false
    Button.Parent = parent

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(70, 70, 85)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Button

    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 60, 75)}):Play()
    end)

    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 58)}):Play()
    end)

    Button.MouseButton1Click:Connect(function()
        callback()
    end)

    return Button
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
        makeNotify("Disabled", 2)
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

local TeleportDistRow = makeRow(62)
local TeleportDistLabel = Instance.new("TextLabel")
TeleportDistLabel.Size = UDim2.new(1, -90, 0, 20)
TeleportDistLabel.Position = UDim2.new(0, 14, 0, 8)
TeleportDistLabel.BackgroundTransparency = 1
TeleportDistLabel.Text = "Teleport Distance"
TeleportDistLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
TeleportDistLabel.Font = Enum.Font.GothamMedium
TeleportDistLabel.TextSize = 14
TeleportDistLabel.TextXAlignment = Enum.TextXAlignment.Left
TeleportDistLabel.Parent = TeleportDistRow

local TeleportDistance = 500
makeSlider(TeleportDistRow, 50, 5000, 500, function(v)
    TeleportDistance = v
end)

local TeleportBtnRow = makeRow(44)
makeButton(TeleportBtnRow, "Teleport", function()
    if not TeleportEnabled then
        makeNotify("Enable Teleport Bypass first", 2)
        return
    end

    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    local cam = workspace.CurrentCamera
    local look = cam.CFrame.LookVector
    local startPos = hrp.Position
    local target = startPos + look * TeleportDistance

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {char}
    local result = workspace:Raycast(startPos, look * TeleportDistance, params)
    if result then
        target = result.Position + look * 3
    end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    hrp.CFrame = CFrame.new(target)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    task.wait(0.1)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    task.wait(0.05)

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.CanCollide = true
        end
    end

    makeNotify("Teleported", 2)
end)

Minimize.MouseButton1Click:Connect(function()
    ScrollFrame.Visible = not ScrollFrame.Visible
    Main.Size = ScrollFrame.Visible and UDim2.new(0, 420, 0, 440) or UDim2.new(0, 420, 0, 46)
end)

Close.MouseButton1Click:Connect(function()
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

local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        if FFlagEnabled then
            task.wait(0.5)
            applyFlags()
            makeNotify("Reapplied", 2)
        end
    end)
end

if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
