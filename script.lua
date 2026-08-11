local windui = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local players = game:GetService("Players")
local workspace = game:GetService("Workspace")
local runservice = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local tween = game:GetService("TweenService")

local lp = players.LocalPlayer

local TextChatService = game:GetService("TextChatService")

local function sendMessage(msg)
    local channels = TextChatService:FindFirstChild("TextChannels")

    if channels and channels:FindFirstChild("RBXGeneral") then
        channels.RBXGeneral:SendAsync(msg)
    else
        game:GetService("ReplicatedStorage")
            :WaitForChild("DefaultChatSystemChatEvents")
            :WaitForChild("SayMessageRequest")
            :FireServer(msg, "All")
    end
end

local state = {
    murderesp = false,
    sheriffesp = false,
    innoesp = false,
    gunesp = false,
    autoshoot = false,
    autocoin = false,
    autogun = false,
    noclip = false,
    infjump = false,
    flying = false,
    walkspeed = 16,
    jumppower = 50,
}

local highlights = {}
local bodygyro, bodyvel

local purple = Color3.fromHex("#7775F2")
local red = Color3.fromHex("#EF4F1D")
local green = Color3.fromHex("#10C550")
local blue = Color3.fromHex("#257AF7")
local yellow = Color3.fromHex("#ECA201")




local window = windui:CreateWindow({
    Title = "Soul.lol",
    Icon = "sword",
    Author = "by enes",
    Folder = "mm2script",
    Size = uis.TouchEnabled and UDim2.new(0, 560, 0, 392) or UDim2.fromOffset(600, 480),
    Theme = "Emerald",
    HideSearchBar = false,
    NewElements = false,
    OpenButton = {
        Title = "MM2 Script",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 2,
        Enabled = true,
        Draggable = true,
        Scale = 0.5,
        Color = ColorSequence.new(
            Color3.fromHex("#EF4F1D"),
            Color3.fromHex("#ECA201")
        ),
    },
    Topbar = { Height = 44, ButtonsType = "Mac" },
})





local esptab = window:Tab({ Title = "ESP", Icon = "eye", IconColor = blue, Desc = "Player & item highlights" })
local acttab = window:Tab({ Title = "Actions", Icon = "sword", IconColor = red, Desc = "Combat & gun tools" })
local movtab = window:Tab({ Title = "Movement", Icon = "person-standing", IconColor = green, Desc = "Speed, jump & fly" })
local farmtab = window:Tab({ Title = "Auto Farm", Icon = "coins", IconColor = yellow, Desc = "Coin collection" })
local tptab = window:Tab({ Title = "Teleport", Icon = "map-pin", IconColor = purple, Desc = "Quick teleports" })
local rolestab = window:Tab({ 
    Title = "Roles", 
    Icon = "users", 
    IconColor = Color3.fromRGB(200, 200, 0), 
    Desc = "Role notifications & chat" 
})

local flingtab = window:Tab({
    Title = "Fling",
    Icon = "zap",
    IconColor = Color3.fromRGB(255, 100, 100),
    Desc = "Fling players"
})


local flingsec = flingtab:Section({ Title = "Fling Tools" })



local antiflingConnection = nil

local function toggleAntiFling(state)
    if antiflingConnection then
        antiflingConnection:Disconnect()
        antiflingConnection = nil
    end
    if state then
        antiflingConnection = runservice.Stepped:Connect(function()
            for _, player in pairs(players:GetPlayers()) do
                if player ~= lp and player.Character then
                    for _, v in pairs(player.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end
        end)
    end
end

flingsec:Toggle({
    Title = "Anti-Fling",
    Desc = "Prevents others from flinging you",
    Icon = "shield",
    Callback = function(v)
        toggleAntiFling(v)
    end
})


local function FlingPlayer(Target)
    if Target and Target.Character then
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local OldPos = hrp.CFrame
        local walkflinging = true
        local movel = 0.1
        local hum = lp.Character:FindFirstChildWhichIsA("Humanoid")
        
        local connection
        if hum then
            connection = hum.Died:Connect(function()
                walkflinging = false
            end)
        end

        repeat
            runservice.Heartbeat:Wait()

            local char = lp.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")

            local tchar = Target.Character
            local troot = tchar and tchar:FindFirstChild("HumanoidRootPart")

            if char and root and tchar and troot then
                root.CFrame = troot.CFrame
                local vel = root.Velocity
                root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)

                runservice.RenderStepped:Wait()
                if root and root.Parent then
                    root.Velocity = vel
                end

                runservice.Stepped:Wait()
                if root and root.Parent then
                    root.Velocity = vel + Vector3.new(0, movel, 0)
                    movel = movel * -1
                end
            end
        until not (Target.Character and Target.Character:FindFirstChild("Head")) or walkflinging == false or not Target.Parent
        
        if connection then connection:Disconnect() end
        
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = OldPos
        end
    end
end

local function getMurderer()
    for _, p in pairs(players:GetPlayers()) do
        if (p.Character and p.Character:FindFirstChild("Knife")) or (p.Backpack and p.Backpack:FindFirstChild("Knife")) then
            return p
        end
    end
    return nil
end

local function getSheriff()
    for _, p in pairs(players:GetPlayers()) do
        if (p.Character and p.Character:FindFirstChild("Gun")) or (p.Backpack and p.Backpack:FindFirstChild("Gun")) then
            return p
        end
    end
    return nil
end


local flingState = {
    target = nil,
    active = false,
    oldPos = nil,
    fpdh = workspace.FallenPartsDestroyHeight
}

local function startFling(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local myChar = lp.Character
    local myHum = myChar and myChar:FindFirstChildWhichIsA("Humanoid")
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local tChar = targetPlayer.Character
    local tHum = tChar:FindFirstChildWhichIsA("Humanoid")
    local tRoot = tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("Head")

    if myRoot and myHum and tRoot then
        flingState.oldPos = myRoot.CFrame
        flingState.active = true
        workspace.FallenPartsDestroyHeight = 0/0
        
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.zero
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = myRoot

        myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        task.spawn(function()
            local angle = 0
            while flingState.active and targetPlayer.Parent and tChar.Parent and myRoot.Parent do
                runservice.Heartbeat:Wait()
                angle = angle + 100
                
                local rot = CFrame.Angles(math.rad(angle), 0, 0)
                local offset = (tHum and tHum.MoveDirection * tRoot.Velocity.Magnitude / 1.25) or Vector3.zero
                
                myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 1.5, 0) * rot + offset
                myRoot.Velocity = Vector3.new(9e7, 9e8, 9e7)
                myRoot.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                
                runservice.RenderStepped:Wait()
                myRoot.CFrame = tRoot.CFrame * CFrame.new(0, -1.5, 0) * rot + offset
            end

            bv:Destroy()
            myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            flingState.active = false
            
            if flingState.oldPos then
                local timeout = tick()
                repeat
                    myRoot.CFrame = flingState.oldPos
                    myRoot.Velocity = Vector3.zero
                    myRoot.RotVelocity = Vector3.zero
                    task.wait()
                until (myRoot.Position - flingState.oldPos.p).Magnitude < 10 or tick() - timeout > 2
                workspace.FallenPartsDestroyHeight = flingState.fpdh
            end

            for _, v in pairs(myChar:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end)
    end
end

local function stopFling()
    flingState.active = false
end


flingsec:Toggle({
    Title = "Fling Murderer",
    Desc = "Flings the Murderer",
    Icon = "skull",
    Callback = function(v)
        if v then
            local target = getMurderer()
            if target then startFling(target) else stopFling() end
        else stopFling() end
    end
})

flingsec:Space()

flingsec:Toggle({
    Title = "Fling Sheriff",
    Desc = "Flings the Sheriff",
    Icon = "shield",
    Callback = function(v)
        if v then
            local target = getSheriff()
            if target then startFling(target) else stopFling() end
        else stopFling() end
    end
})

flingsec:Space()

local playerNames = {}
for _, p in pairs(players:GetPlayers()) do
    if p ~= lp then table.insert(playerNames, p.Name) end
end

local selectedUser = nil
local flingDropdown = flingsec:Dropdown({
    Title = "Select Target",
    Values = playerNames,
    Value = nil,
    Callback = function(val) selectedUser = val end,
})

flingsec:Space()

flingsec:Toggle({
    Title = "Fling Selected",
    Desc = "Flings the player you selected in the dropdown",
    Icon = "zap",
    Callback = function(v)
        if v and selectedUser then
            local target = players:FindFirstChild(selectedUser)
            if target then startFling(target) else stopFling() end
        else stopFling() end
    end
})

runservice.Stepped:Connect(function()
    if flingState.active and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

task.spawn(function()
    while task.wait(5) do
        local newNames = {}
        for _, p in pairs(players:GetPlayers()) do
            if p ~= lp then table.insert(newNames, p.Name) end
        end
        flingDropdown:Refresh(newNames)
    end
end)


local extratab = window:Tab({
    Title = "Extra",
    Icon = "wrench",
    IconColor = Color3.fromRGB(150,150,150),
    Desc = "Utility tools"
})

local extrasec = extratab:Section({ Title = "Main Tools" })

extrasec:Button({
    Title = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

extrasec:Button({
    Title = "Dex Explorer",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua"))()
    end
})

extrasec:Button({
    Title = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

extrasec:Button({
    Title = "Server Hop",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/CF-Trail/random/main/serverhop.lua"))()
    end
})

extrasec:Button({
    Title = "Copy Discord (yezano)",
    Desc = "Click to copy username",
    Icon = "clipboard",
    Justify = "Center",
    Callback = function()
        if setclipboard then
            setclipboard("yezano")
            windui:Notify({
                Title = "Copied!",
                Content = "yezano copied to clipboard",
                Icon = "check-circle",
                Duration = 3
            })
        else
            windui:Notify({
                Title = "Error",
                Content = "Your executor doesn't support clipboard",
                Icon = "alert-circle",
                Duration = 3
            })
        end
    end
})

local rolesec = rolestab:Section({ Title = "Role Tools" })

local rolestate = {
    notif = false,
    chat = false
}

rolesec:Toggle({
    Title = "Role Reveal Notification",
    Desc = "Notify when murderer or sheriff is detected",
    Icon = "eye",
    Callback = function(v)
        rolestate.notif = v
    end
})

rolesec:Space()

rolesec:Toggle({
    Title = "Auto Announce Roles",
    Desc = "Automatically send roles in chat",
    Icon = "message-circle",
    Callback = function(v)
        rolestate.chat = v
    end
})

rolesec:Space()

rolesec:Button({
    Title = "Announce Roles Now",
    Desc = "Send roles in chat once",
    Icon = "send",
    Justify = "Center",
    Callback = function()

        local murderer = nil
        local sheriff = nil

        for _, p in pairs(players:GetPlayers()) do
            if (p.Character and p.Character:FindFirstChild("Knife")) or
               (p.Backpack and p.Backpack:FindFirstChild("Knife")) then
                murderer = p
            end

            if (p.Character and p.Character:FindFirstChild("Gun")) or
               (p.Backpack and p.Backpack:FindFirstChild("Gun")) then
                sheriff = p
            end
        end

        local msg = "[MM2] Murderer: "..(murderer and murderer.Name or "Unknown")
            .." | Sheriff: "..(sheriff and sheriff.Name or "Unknown")

        sendMessage(msg)

    end
})

local function getroot(char)
    return char and (
        char:FindFirstChild("HumanoidRootPart") or
        char:FindFirstChild("Torso") or
        char:FindFirstChild("UpperTorso")
    )
end

local function getrole(p)
    if p.Backpack:FindFirstChild("Knife") or (p.Character and p.Character:FindFirstChild("Knife")) then
        return "Murderer"
    elseif p.Backpack:FindFirstChild("Gun") or (p.Character and p.Character:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    return "Innocent"
end

local function findmurderer()
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp then
            if (p.Character and p.Character:FindFirstChild("Knife")) or
               (p.Backpack and p.Backpack:FindFirstChild("Knife")) then
                return p
            end
        end
    end
end

local function clearesp()
    for _, v in pairs(highlights) do
        if v and v.Parent then v:Destroy() end
    end
    table.clear(highlights)
end

local function makeesp(p)
    if p == lp or not p.Character then return end
    local role = getrole(p)
    if role == "Murderer" and not state.murderesp then return end
    if role == "Sheriff" and not state.sheriffesp then return end
    if role == "Innocent" and not state.innoesp then return end

    local h = Instance.new("Highlight")
    h.FillTransparency = 0.45
    h.OutlineTransparency = 0

    if role == "Murderer" then
        h.FillColor = Color3.fromRGB(220, 30, 30)
        h.OutlineColor = Color3.fromRGB(255, 80, 80)
    elseif role == "Sheriff" then
        h.FillColor = Color3.fromRGB(30, 80, 220)
        h.OutlineColor = Color3.fromRGB(80, 140, 255)
    else
        h.FillColor = Color3.fromRGB(30, 200, 80)
        h.OutlineColor = Color3.fromRGB(80, 255, 130)
    end

    h.Parent = p.Character
    highlights[p] = h
end

local function makegunesp()
    if not state.gunesp then return end
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "GunDrop" then
            local h = Instance.new("Highlight")
            h.FillColor = Color3.fromRGB(255, 215, 0)
            h.OutlineColor = Color3.fromRGB(255, 255, 120)
            h.FillTransparency = 0.3
            h.Parent = v
            highlights[v] = h
        end
    end
end

local function refreshesp()
    clearesp()
    for _, p in pairs(players:GetPlayers()) do makeesp(p) end
    makegunesp()
end

local espsec = esptab:Section({ Title = "Player Highlights" })

espsec:Toggle({ Title = "Murderer ESP", Desc = "Red highlight", Icon = "skull", Callback = function(v) state.murderesp = v refreshesp() end })
espsec:Space()
espsec:Toggle({ Title = "Sheriff ESP", Desc = "Blue highlight", Icon = "shield", Callback = function(v) state.sheriffesp = v refreshesp() end })
espsec:Space()
espsec:Toggle({ Title = "Innocent ESP", Desc = "Green highlight", Icon = "user", Callback = function(v) state.innoesp = v refreshesp() end })
espsec:Space()
espsec:Toggle({ Title = "Dropped Gun ESP", Desc = "Yellow highlight", Icon = "crosshair", Callback = function(v) state.gunesp = v refreshesp() end })

local function bringplayer(target)
    if not target.Character or not lp.Character then return end
    local tr = getroot(target.Character)
    local mr = getroot(lp.Character)
    if tr and mr then tr.CFrame = mr.CFrame * CFrame.new(0, 0, -3) end
end

local function swingknife()
    local knife = lp.Character and lp.Character:FindFirstChild("Knife")
    if knife then knife:Activate() end
end

local function shootmurderer()
    local m = findmurderer()
    if not m then return end
    if lp.Backpack:FindFirstChild("Gun") then
        lp.Character.Humanoid:EquipTool(lp.Backpack.Gun)
    end
    local target = m.Character and m.Character:FindFirstChild("HumanoidRootPart")
    local gun = lp.Character and lp.Character:FindFirstChild("Gun")
    if gun and target and gun:FindFirstChild("Shoot") then
        gun.Shoot:FireServer(
            CFrame.new(lp.Character.RightHand.Position),
            CFrame.new(target.Position)
        )
    end
end

local function grabgun()
    local char = lp.Character
    if not char then return end
    local root = getroot(char)
    if not root then return end
    local gun = workspace:FindFirstChild("GunDrop", true)
    if not gun then return end
    local origin = root.CFrame
    root.CFrame = gun.CFrame
    if firetouchinterest then
        firetouchinterest(root, gun, 0)
        firetouchinterest(root, gun, 1)
    else
        gun.CFrame = root.CFrame
    end
    root.CFrame = origin
end

local killsec = acttab:Section({ Title = "Kill Actions" })

killsec:Button({ Title = "Kill All", Desc = "Bring & kill everyone", Icon = "skull", Color = red, Justify = "Center",
    Callback = function()
        for _, p in pairs(players:GetPlayers()) do
            if p ~= lp then bringplayer(p) swingknife() end
        end
    end,
})
killsec:Space()
killsec:Button({ Title = "Kill Sheriff", Desc = "Kill the sheriff", Icon = "shield-off", Justify = "Center",
    Callback = function()
        for _, p in pairs(players:GetPlayers()) do
            if getrole(p) == "Sheriff" then bringplayer(p) swingknife() end
        end
    end,
})
killsec:Space()
killsec:Button({ Title = "Kill Innocents", Desc = "Kill all innocents", Icon = "users", Justify = "Center",
    Callback = function()
        for _, p in pairs(players:GetPlayers()) do
            if getrole(p) == "Innocent" then bringplayer(p) swingknife() end
        end
    end,
})

local gunsec = acttab:Section({ Title = "Gun Actions" })

gunsec:Button({ Title = "Shoot Murderer", Desc = "Fire at the murderer", Icon = "crosshair", Justify = "Center", Callback = function() shootmurderer() end })
gunsec:Space()
gunsec:Toggle({ Title = "Auto Shoot", Desc = "Shoots murderer on loop", Icon = "zap", Callback = function(v) state.autoshoot = v end })
gunsec:Space()
gunsec:Button({ Title = "Grab Gun", Desc = "Picks up the dropped gun", Icon = "hand", Justify = "Center", Callback = function() grabgun() end })
gunsec:Space()
gunsec:Toggle({ Title = "Auto Pickup Gun", Desc = "Grabs gun on loop", Icon = "refresh-cw", Callback = function(v) state.autogun = v end })

task.spawn(function()
    while task.wait(0.5) do
        if state.autoshoot then shootmurderer() end
        if state.autogun then grabgun() end
    end
end)

local function applymove()
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = state.walkspeed
        hum.JumpPower = state.jumppower
    end
end

local movsec = movtab:Section({ Title = "Movement Settings" })

movsec:Slider({ Title = "Walk Speed", Desc = "Movement speed", Step = 1, Value = { Min = 16, Max = 250, Default = 16 }, Callback = function(v) state.walkspeed = v applymove() end })
movsec:Space()
movsec:Slider({ Title = "Jump Power", Desc = "Jump height", Step = 1, Value = { Min = 50, Max = 300, Default = 50 }, Callback = function(v) state.jumppower = v applymove() end })

local ablsec = movtab:Section({ Title = "Abilities" })

ablsec:Toggle({ Title = "Noclip", Desc = "Walk through walls", Icon = "ghost", Callback = function(v) state.noclip = v end })
ablsec:Space()
ablsec:Toggle({ Title = "Infinite Jump", Desc = "Jump infinitely", Icon = "chevrons-up", Callback = function(v) state.infjump = v end })
ablsec:Space()
ablsec:Toggle({ Title = "Fly", Desc = "Fly with WASD", Icon = "wind",
    Callback = function(v)
        state.flying = v
        local char = lp.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end

        if state.flying then
            hum.PlatformStand = true
            bodygyro = Instance.new("BodyGyro")
            bodygyro.P = 9e4
            bodygyro.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
            bodygyro.CFrame = root.CFrame
            bodygyro.Parent = root
            bodyvel = Instance.new("BodyVelocity")
            bodyvel.MaxForce = Vector3.new(9e4, 9e4, 9e4)
            bodyvel.Parent = root
        else
            hum.PlatformStand = false
            if bodygyro then bodygyro:Destroy() end
            if bodyvel then bodyvel:Destroy() end
        end
    end,
})

runservice.Stepped:Connect(function()
    if state.noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

uis.JumpRequest:Connect(function()
    if state.infjump and lp.Character then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

runservice.RenderStepped:Connect(function()
    if not state.flying or not lp.Character then return end
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    if not root or not bodyvel or not bodygyro then return end
    local move = Vector3.zero
    local cam = workspace.CurrentCamera
    if uis:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
    if uis:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
    if uis:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
    if uis:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
    bodyvel.Velocity = move * 55
    bodygyro.CFrame = cam.CFrame
end)

local function getmap()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:FindFirstChild("CoinContainer") then return obj end
    end
end

local function closestcoin(container)
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local pos = lp.Character.HumanoidRootPart.Position
    local closest, shortest = nil, math.huge
    for _, m in ipairs(container:GetChildren()) do
        local d = (pos - m:GetPivot().Position).Magnitude
        if d < shortest then shortest = d closest = m end
    end
    return closest
end

local farmsec = farmtab:Section({ Title = "Coin Farming" })

local activetween = nil
local farmrunning = false

local function stopfarm()
    farmrunning = false
    if activetween then
        activetween:Cancel()
        activetween = nil
    end
end

farmsec:Toggle({
    Title = "Auto Collect Coins", Desc = "Collects nearest coin", Icon = "coins",
    Callback = function(v)
        state.autocoin = v
        if not v then stopfarm() end
    end,
})

task.spawn(function()
    while true do
        task.wait(0.05)

        if not state.autocoin then
            farmrunning = false
            task.wait(0.1)
            continue
        end

        if farmrunning then continue end

        local map = getmap()
        if not map then continue end

        local container = map:FindFirstChild("CoinContainer")
        if not container or #container:GetChildren() < 1 then continue end

        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        local coin = closestcoin(container)
        if not coin or not coin.Parent then continue end

        local dist = (root.Position - coin:GetPivot().Position).Magnitude
        local speed = math.clamp(dist / 25, 0.3, 2)

        farmrunning = true
        activetween = tween:Create(root, TweenInfo.new(speed, Enum.EasingStyle.Linear), { CFrame = coin:GetPivot() })

        activetween.Completed:Connect(function(ps)
            activetween = nil
            farmrunning = false
            if ps == Enum.PlaybackState.Completed then
                if coin and coin.Parent then coin:Destroy() end
            end
        end)

        local coincon, mapcon
        coincon = coin.AncestryChanged:Connect(function()
            if not coin.Parent then
                stopfarm()
                coincon:Disconnect()
                if mapcon then mapcon:Disconnect() end
            end
        end)
        mapcon = container.AncestryChanged:Connect(function()
            if not container.Parent then
                stopfarm()
                if coincon then coincon:Disconnect() end
                mapcon:Disconnect()
            end
        end)

        activetween:Play()
    end
end)

local tpsec = tptab:Section({ Title = "Quick Teleports" })

tpsec:Button({ Title = "Teleport to Lobby", Desc = "Go to lobby", Icon = "home", Justify = "Center",
    Callback = function()
        local lobby = workspace:FindFirstChild("Lobby", true)
        if not lobby then return end
        local part = lobby:FindFirstChildWhichIsA("BasePart", true)
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if part and root then root.CFrame = part.CFrame * CFrame.new(0, 3, 0) end
    end,
})
tpsec:Space()
tpsec:Button({ Title = "Teleport to Map", Desc = "Go to game map", Icon = "map", Justify = "Center",
    Callback = function()
        local c = workspace:FindFirstChild("CoinContainer", true)
        if not c or not c.Parent then return end
        local part = c:FindFirstChildWhichIsA("BasePart", true)
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if part and root then root.CFrame = part.CFrame * CFrame.new(0, 3, 0) end
    end,
})
tpsec:Space()
tpsec:Button({ Title = "Teleport to Murderer", Desc = "Go to murderer", Icon = "skull", Justify = "Center",
    Callback = function()
        local m = findmurderer()
        if m and m.Character then
            local target = getroot(m.Character)
            local myroot = lp.Character and getroot(lp.Character)
            if target and myroot then myroot.CFrame = target.CFrame * CFrame.new(0, 0, 3) end
        else
            windui:Notify({ Title = "Not Found", Content = "No murderer detected.", Icon = "alert-circle", Duration = 3 })
        end
    end,
})

tpsec:Space()
tpsec:Button({
    Title = "Teleport to Sheriff",
    Desc = "Go to the sheriff",
    Icon = "shield",
    Justify = "Center",
    Callback = function()
        for _, p in pairs(players:GetPlayers()) do
            if getrole(p) == "Sheriff" and p.Character then
                local target = getroot(p.Character)
                local myroot = lp.Character and getroot(lp.Character)
                if target and myroot then
                    myroot.CFrame = target.CFrame * CFrame.new(0, 0, 3)
                end
                return
            end
        end
        windui:Notify({
            Title = "Not Found",
            Content = "Sheriff not detected.",
            Icon = "alert-circle",
            Duration = 3
        })
    end,
})

tpsec:Space()
tpsec:Button({
    Title = "Teleport to Gun",
    Desc = "Go to dropped gun",
    Icon = "crosshair",
    Justify = "Center",
    Callback = function()
        local gun = workspace:FindFirstChild("GunDrop", true)
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")

        if gun and root then
            root.CFrame = gun.CFrame * CFrame.new(0, 3, 0)
        else
            windui:Notify({
                Title = "Not Found",
                Content = "Dropped gun not found.",
                Icon = "alert-circle",
                Duration = 3
            })
        end
    end,
})

task.spawn(function()
    while task.wait(0.5) do refreshesp() end
end)

players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        refreshesp()
    end)
end)

local toggleKey = Enum.KeyCode.K

uis.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == toggleKey then
        if window and window.Toggle then
            window:Toggle()
        end
    end
end)

windui:Notify({
    Title = "MM2 Script",
    Content = "Press [K] to reopen the UI if it is minimized.",
    Icon = "keyboard",
    Duration = 5
})

local lastMurderer = nil
local lastSheriff = nil

task.spawn(function()
    while task.wait(1) do

        local murderer = nil
        local sheriff = nil

        for _, p in pairs(players:GetPlayers()) do
            if (p.Character and p.Character:FindFirstChild("Knife")) or
               (p.Backpack and p.Backpack:FindFirstChild("Knife")) then
                murderer = p
            end

            if (p.Character and p.Character:FindFirstChild("Gun")) or
               (p.Backpack and p.Backpack:FindFirstChild("Gun")) then
                sheriff = p
            end
        end

        if rolestate.notif then

            if murderer and murderer ~= lastMurderer then
                lastMurderer = murderer

                windui:Notify({
                    Title = "Murderer Detected",
                    Content = murderer.Name,
                    Icon = "skull",
                    Duration = 4
                })
            end

            if sheriff and sheriff ~= lastSheriff then
                lastSheriff = sheriff

                windui:Notify({
                    Title = "Sheriff Detected",
                    Content = sheriff.Name,
                    Icon = "shield",
                    Duration = 4
                })
            end
        end

        if rolestate.chat and murderer and sheriff then
            local msg = "[MM2] Murderer: "..murderer.Name.." | Sheriff: "..sheriff.Name
            sendMessage(msg)
            task.wait(8)
        end

    end
end)

windui:Notify({ Title = "MM2 Script", Content = "Loaded successfully.", Icon = "check-circle", Duration = 4 })
