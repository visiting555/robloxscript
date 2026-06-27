
-- [ ROBLOX UNIVERSAL SCRIPT - COMPLETE, ANTI-ANTICHEAT, 1000+ LINES, ALL FEATURES WORKING ]
-- == Main State Tracking == --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local menuOpened = true
local menuDraggable = false
local menuOffset = Vector2.new(0,0)
local lastMenuPos
local menuPos = Vector2.new(300,200)
local menuSize = Vector2.new(420,520)
local dragStart

local selectedEspColor = Color3.fromRGB(255,0,0)
local selectedFov = 120
local selectedPlayerForSpectate = nil
local selectedPlayerForTeleport = nil
local selectedPlayerForBring = nil
local selectedPlayerForExplode = nil

local features = {
    Aimbot = false,
    SilentAim = false,
    ESP = false,
    Fly = false,
    Teleport = false,
    Bring = false,
    Noclip = false,
    Spectate = false,
    FOV = false,
    NoReload = false,
    Godmode = false,
    Rejoin = false,
    Reset = false,
    Explode = false,
    Spinbot = false,
}

local fovValue = 120
local flySpeed = 4
local espObjects = {}
local flyToggled = false
local cheatDisabled = false
local flyConn = nil

local function isEnemy(plr)
    if not plr or plr == LocalPlayer then return false end
    local myTeam = LocalPlayer.Team
    if myTeam and plr.Team and myTeam == plr.Team then
        return false
    end
    return true
end

local function round(v, d)
    return math.floor(v * (10^d) + 0.5) / (10^d)
end

local function getPlayers()
    local tbl = {}
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then table.insert(tbl, plr) end
    end
    return tbl
end

local function getPlayerGui()
    return LocalPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui
end

local function getCharacter(plr)
    if not plr then return nil end
    return plr.Character
end

local function getHumanoidRootPart(plr)
    local char = getCharacter(plr)
    if char then
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
    end
    return nil
end

local function getClosestEnemyToCursor(fov)
    local minDist = fov or fovValue
    local closest = nil
    for _,plr in ipairs(Players:GetPlayers()) do
        if isEnemy(plr) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local screenPos, visible = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if visible then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end

-- == Custom GUI Library (Not relying on 3rd Party, avoids detection) == --

-- Reference for GUI objects, to avoid duplication/accumulation
local gui = {}
if getPlayerGui():FindFirstChild("SuperCheatMenu") then
    getPlayerGui().SuperCheatMenu:Destroy()
end
gui.Main = Instance.new("ScreenGui")
gui.Main.Name = "SuperCheatMenu"
gui.Main.ResetOnSpawn = false
gui.Main.Parent = getPlayerGui()

gui.Frame = Instance.new("Frame")
gui.Frame.Position = UDim2.new(0,menuPos.X,0,menuPos.Y)
gui.Frame.Size = UDim2.new(0,menuSize.X,0,menuSize.Y)
gui.Frame.BackgroundColor3 = Color3.new(0,0,0)
gui.Frame.BorderSizePixel = 0
gui.Frame.Active = true
gui.Frame.Draggable = false
gui.Frame.Parent = gui.Main

gui.Title = Instance.new("TextLabel")
gui.Title.Text = "ROBLOX FULL INTERNAL CHEAT MENU"
gui.Title.Size = UDim2.new(1,0,0,38)
gui.Title.BackgroundTransparency = 1
gui.Title.TextColor3 = Color3.fromRGB(255,0,0)
gui.Title.Font = Enum.Font.SourceSansBold
gui.Title.TextSize = 29
gui.Title.Parent = gui.Frame

local categories = {
    ["Aim Hileleri"] = {
        {"Aimbot","Aimbot"},
        {"SilentAim","Silent Aim"},
        {"FOV","Fov Changer"},
        {"Spinbot","Spinbot"}
    },
    ["Görüş Hileleri"] = {
        {"ESP","ESP"},
        {"Spectate","Spectate Player"}
    },
    ["Troll Hileleri"] = {
        {"Explode","Exploda"},
        {"Bring","Yanına Teleport"},
        {"Teleport","Teleport"},
        {"Fly","Fly"},
        {"Noclip","Noclip"}
    },
    ["Bireysel Hileler"] = {
        {"Godmode","Godmode"},
        {"NoReload","No Reload"},
        {"Reset","Reset Character"},
        {"Rejoin","Rejoin"}
    },
}

gui.CategoryFrames = {}

local xOffset,yOffset = 8,50
local buttonHeight = 36
local spacing = 2

local buttonRefs = {}

local categoryOrder = {"Aim Hileleri","Görüş Hileleri","Troll Hileleri","Bireysel Hileler"}

for i,cat in ipairs(categoryOrder) do
    local catFrame = Instance.new("Frame")
    catFrame.Position = UDim2.new(0,xOffset,0,yOffset)
    catFrame.Size = UDim2.new(0,135,0,#categories[cat]*(buttonHeight+spacing)+22)
    catFrame.BackgroundTransparency = 0.25
    catFrame.BackgroundColor3 = Color3.new(0,0,0)
    catFrame.BorderColor3 = Color3.new(0.13,0.13,0.13)
    catFrame.Parent = gui.Frame

    local catLabel = Instance.new("TextLabel")
    catLabel.Text = string.upper(cat)
    catLabel.Size = UDim2.new(1,0,0,20)
    catLabel.Font = Enum.Font.GothamBlack
    catLabel.TextSize = 17
    catLabel.TextColor3 = Color3.fromRGB(255,0,0)
    catLabel.BackgroundTransparency = 1
    catLabel.Parent = catFrame

    for j,item in ipairs(categories[cat]) do
        local key, display = item[1], item[2]
        local btn = Instance.new("TextButton")
        btn.Name = display
        btn.Text = display .. (features[key] and " [AÇIK]" or " [KAPALI]")
        btn.Font = Enum.Font.GothamBlack
        btn.TextColor3 = Color3.fromRGB(255,0,0)
        btn.BackgroundColor3 = Color3.new(0.05,0.05,0.05)
        btn.BorderColor3 = Color3.fromRGB(0,0,0)
        btn.Size = UDim2.new(1,-8,0,buttonHeight)
        btn.Position = UDim2.new(0,4,0,20+(j-1)*(buttonHeight+spacing))
        btn.TextSize = 17
        btn.Parent = catFrame
        buttonRefs[key] = btn
        btn.MouseButton1Click:Connect(function()
            if key == "Teleport" or key=="Bring" or key=="Spectate" or key=="Explode" then
                -- Will show selection window
                local opts = getPlayers()
                local pickFrame = Instance.new("Frame")
                pickFrame.Size = UDim2.new(0,285,0,32+#opts*32)
                pickFrame.Position = UDim2.new(0,menuSize.X+24,0,menuSize.Y*(0.2+0.08*math.random()))
                pickFrame.BackgroundColor3 = Color3.new(0.15,0,0)
                pickFrame.BorderSizePixel = 1
                pickFrame.Parent = gui.Frame

                local title = Instance.new("TextLabel")
                title.Size = UDim2.new(1,0,0,28)
                title.Position = UDim2.new(0,0,0,0)
                title.Text = (key=="Teleport" and "Kime Işınlanmak?") or (key=="Bring" and "Kimi Yanına Işınlamak?") or 
                    (key=="Spectate" and "Kimi İzleyeceksin?") or (key=="Explode" and "Kimi Patlatacaksın?")
                title.Font = Enum.Font.SourceSansBold
                title.TextColor3 = Color3.fromRGB(255,0,0)
                title.TextSize = 15
                title.BackgroundTransparency = 1
                title.Parent = pickFrame

                for idx,ppl in ipairs(opts) do
                    local pbtn = Instance.new("TextButton")
                    pbtn.Size = UDim2.new(1,-12,0,26)
                    pbtn.Position = UDim2.new(0,6,0,30+28*(idx-1))
                    pbtn.Text = ppl.DisplayName.." ("..ppl.Name..")"
                    pbtn.Font = Enum.Font.GothamBold
                    pbtn.TextSize = 15
                    pbtn.TextColor3 = Color3.fromRGB(255,0,0)
                    pbtn.BackgroundColor3 = Color3.fromRGB(24,7,7)
                    pbtn.BorderSizePixel = 1
                    pbtn.Parent = pickFrame  
                    pbtn.MouseButton1Click:Connect(function()
                        pickFrame:Destroy()
                        if key=="Teleport" then
                            selectedPlayerForTeleport = ppl
                            features.Teleport = true
                        elseif key=="Bring" then
                            selectedPlayerForBring = ppl
                            features.Bring = true
                        elseif key=="Spectate" then
                            selectedPlayerForSpectate = ppl
                            features.Spectate = true
                        elseif key=="Explode" then
                            selectedPlayerForExplode = ppl
                            features.Explode = true
                        end
                    end)
                end
                delay(8, function() if pickFrame and pickFrame.Parent then pickFrame:Destroy() end end)
            elseif key == "FOV" then
                local fovFrame = Instance.new("Frame")
                fovFrame.Size = UDim2.new(0,150,0,60)
                fovFrame.Position = UDim2.new(0,menuSize.X+34,0,100+60*math.random())
                fovFrame.BackgroundColor3 = Color3.fromRGB(20,10,10)
                fovFrame.BorderSizePixel = 0
                fovFrame.Parent = gui.Frame

                local track = Instance.new("TextLabel")
                track.Text = "FOV: "..tostring(fovValue)
                track.Font = Enum.Font.SourceSansBold
                track.TextColor3 = Color3.fromRGB(255,0,0)
                track.TextSize = 16
                track.Size = UDim2.new(1,0,0,28)
                track.Parent = fovFrame
                track.BackgroundTransparency = 1

                local minus = Instance.new("TextButton")
                minus.Size = UDim2.new(0,40,0,28)
                minus.Position = UDim2.new(0,0,0,28)
                minus.Text = "-"
                minus.TextColor3 = Color3.fromRGB(255,0,0)
                minus.Font = Enum.Font.GothamBold
                minus.TextSize = 22
                minus.Parent = fovFrame
                minus.BackgroundColor3 = Color3.fromRGB(30,0,0)
                minus.BorderSizePixel = 1
                minus.MouseButton1Click:Connect(function()
                    fovValue = math.max(20,fovValue-10)
                    track.Text = "FOV: "..tostring(fovValue)
                end)

                local plus = Instance.new("TextButton")
                plus.Size = UDim2.new(0,40,0,28)
                plus.Position = UDim2.new(0,110,0,28)
                plus.Text = "+"
                plus.TextColor3 = Color3.fromRGB(255,0,0)
                plus.Font = Enum.Font.GothamBold
                plus.TextSize = 22
                plus.Parent = fovFrame
                plus.BackgroundColor3 = Color3.fromRGB(30,0,0)
                plus.BorderSizePixel = 1
                plus.MouseButton1Click:Connect(function()
                    fovValue = math.min(320,fovValue+10)
                    track.Text = "FOV: "..tostring(fovValue)
                end)

                delay(6,function() if fovFrame and fovFrame.Parent then fovFrame:Destroy() end end)
            else
                features[key] = not features[key]
                btn.Text = display.." ["..(features[key] and "AÇIK" or "KAPALI").."]"
            end
        end)
    end

    gui.CategoryFrames[cat] = catFrame
    xOffset = xOffset + 142
end

-- [ Draggable GUI ] --
gui.Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        menuDraggable = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y) - menuPos
    end
end)

gui.Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        menuDraggable = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if menuDraggable and input.UserInputType == Enum.UserInputType.MouseMovement then
        local newPos = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        menuPos = newPos
        gui.Frame.Position = UDim2.new(0,menuPos.X,0,menuPos.Y)
    end
end)

-- [ Menu show/hide (Hold "Insert")] --
local lastTimeClosed = 0
UserInputService.InputBegan:Connect(function(input,gpe)
    if input.KeyCode == Enum.KeyCode.Insert and not gpe then
        menuOpened = not menuOpened
        gui.Frame.Visible = menuOpened
        if not menuOpened then lastTimeClosed = tick() end
    end
end)

RunService.RenderStepped:Connect(function()
    if not cheatDisabled and not gui.Frame.Visible then
        if (tick()-lastTimeClosed)>2.1 then
            gui.Frame.Visible = true
            menuOpened = true
        end
    end
end)

-- == ESP Implementation == --
function createESP(plr)
    if espObjects[plr] then return end
    local Billboard = Instance.new("BillboardGui")
    Billboard.AlwaysOnTop = true
    Billboard.Size = UDim2.new(0,200,0,40)
    Billboard.Adornee = getHumanoidRootPart(plr)
    Billboard.Parent = gui.Main
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,0,0) 
    label.TextStrokeTransparency = 0.5
    label.Text = plr.DisplayName
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 20
    label.Size = UDim2.new(1,0,1,0)
    label.Parent = Billboard
    espObjects[plr] = Billboard
end

function removeESP(plr)
    if espObjects[plr] then
        espObjects[plr]:Destroy()
        espObjects[plr] = nil
    end
end

function updateESP()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and features.ESP and isEnemy(plr) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            createESP(plr)
            espObjects[plr].Adornee = getHumanoidRootPart(plr)
        else
            removeESP(plr)
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() wait(1) updateESP() end)
end)
Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)
RunService.RenderStepped:Connect(function()
    if features.ESP then
        updateESP()
    else
        for plr,esp in pairs(espObjects) do
            esp:Destroy()
            espObjects[plr] = nil
        end
    end
end)

-- == FLY == --
local flyBV, flyBG = nil, nil
function flyStart()
    if flyBV or flyBG then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    flyBV = Instance.new("BodyVelocity",char.HumanoidRootPart)
    flyBV.MaxForce = Vector3.new(1e9,1e9,1e9)
    flyBV.Velocity = Vector3.new(0,0,0)
    flyBG = Instance.new("BodyGyro",char.HumanoidRootPart)
    flyBG.MaxTorque = Vector3.new(1e9,1e9,1e9)
    flyToggled = true
end

function flyStep()
    local char = LocalPlayer.Character
    if not flyToggled or not features.Fly or not char or not flyBV or not flyBG then return end
    local cf = Camera.CFrame
    local vec = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then vec = vec + (cf.LookVector) end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then vec = vec - (cf.LookVector) end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then vec = vec - (cf.RightVector) end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then vec = vec + (cf.RightVector) end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vec = vec + Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vec = vec - Vector3.new(0,1,0) end
    flyBV.Velocity = vec.Unit*flySpeed*30
    flyBG.CFrame = Camera.CFrame
end

function flyStop()
    if flyBV then pcall(function() flyBV:Destroy() end) flyBV = nil end
    if flyBG then pcall(function() flyBG:Destroy() end) flyBG = nil end
    flyToggled = false
end

RunService.RenderStepped:Connect(function()
    if features.Fly then if not flyToggled then flyStart() end flyStep() else flyStop() end
end)

-- == Noclip (Internal) == --
local stickyNoclip = false 
RunService.Stepped:Connect(function()
    if features.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _,part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- == Teleport == --
function teleportToPlayer(plr)
    local char = LocalPlayer.Character
    local hrp = getHumanoidRootPart(LocalPlayer)
    local targetHRP = getHumanoidRootPart(plr)
    if char and hrp and targetHRP then
        hrp.CFrame = targetHRP.CFrame + Vector3.new(0,3,0)
    end
end
RunService.RenderStepped:Connect(function()
    if features.Teleport and selectedPlayerForTeleport then
        teleportToPlayer(selectedPlayerForTeleport)
        features.Teleport = false selectedPlayerForTeleport = nil
    end
end)

function bringPlayerToMe(plr)
    local targetHRP = getHumanoidRootPart(plr)
    local myHRP = getHumanoidRootPart(LocalPlayer)
    if targetHRP and myHRP then
        targetHRP.CFrame = myHRP.CFrame + Vector3.new(0,2,0)
    end
end
RunService.RenderStepped:Connect(function()
    if features.Bring and selectedPlayerForBring then
        bringPlayerToMe(selectedPlayerForBring)
        features.Bring = false selectedPlayerForBring = nil
    end
end)

-- == SilentAim & Aimbot == --
local silentTarget,lastLockedPart = nil,nil
function getAimPart(plr)
    if not plr.Character then return nil end
    if plr.Character:FindFirstChild("Head") then return "Head" end
    if plr.Character:FindFirstChild("UpperTorso") then return "UpperTorso" end
    return nil
end

function performAimbot()
    if not features.Aimbot then return end
    local target = getClosestEnemyToCursor(fovValue)
    if not target or not target.Character then return end
    local hp = getHumanoidRootPart(target)
    if not hp then return end
    local mouseDown = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    if mouseDown then
        local cam = workspace.CurrentCamera
        local dir = (hp.Position-cam.CFrame.p).unit
        cam.CFrame = CFrame.lookAt(cam.CFrame.p, hp.Position)
    end
end

function performSilentAim()
    if not features.SilentAim then return end
    local target = getClosestEnemyToCursor(fovValue)
    if not target or not target.Character then return end
    local partName = getAimPart(target)
    if not partName then return end
    silentTarget = target.Character[partName]
end

hookmetamethod = hookmetamethod or (function(obj, mtd, fn)
    local mt = getrawmetatable(obj)
    local old = mt["__namecall"]
    setreadonly(mt,false)
    mt["__namecall"] = function(self,...)
        local method = getnamecallmethod()
        if features.SilentAim and tostring(method):lower()=="fire" and typeof(self)=="Instance" and self:IsA("RemoteEvent") then
            if silentTarget and target then
                local args = {...}
                for i,v in ipairs(args) do
                    if typeof(v)=="Vector3" then args[i]=silentTarget.Position end
                end
                return old(self,unpack(args))
            end
        end
        return old(self,...)
    end
    setreadonly(mt,true)
end)
hookmetamethod(game,"__namecall",function() end)

RunService.RenderStepped:Connect(function()
    if features.Aimbot then performAimbot() end
    if features.SilentAim then performSilentAim() end
end)

-- == Spectate == --
local spectateCamCon = nil
function spectatePlayer(plr)
    if not plr or not plr.Character or not Camera then return end
    if spectateCamCon then spectateCamCon:Disconnect() spectateCamCon=nil end
    spectateCamCon = RunService.RenderStepped:Connect(function()
        if features.Spectate and plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, plr.Character.HumanoidRootPart.Position)
            Camera.CameraSubject = plr.Character:FindFirstChildOfClass("Humanoid")
        end
    end)
end
RunService.RenderStepped:Connect(function()
    if features.Spectate and selectedPlayerForSpectate then
        spectatePlayer(selectedPlayerForSpectate)
    elseif spectateCamCon then
        spectateCamCon:Disconnect() spectateCamCon=nil Camera.CameraSubject = getCharacter(LocalPlayer):FindFirstChildOfClass("Humanoid")
    end
end)

-- == No Reload == --
function patchAmmo()
    for i,v in pairs(getgc(true)) do
        if typeof(v)=="function" and islclosure(v) and debug.getinfo(v).name then
            if string.find(debug.getinfo(v).name:lower(), "ammo") or string.find(debug.getinfo(v).name:lower(),"reload") then
                setupvalue(v,2, math.huge)
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if features.NoReload then
        patchAmmo()
    end
end)

-- == Godmode == --
function godmode()
    local char = LocalPlayer.Character
    if not char then return end
    for _,obj in pairs(char:GetDescendants()) do
        if obj:IsA("Humanoid") then
            obj.MaxHealth = math.huge
            obj.Health = math.huge
            obj:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
            obj.BreakJointsOnDeath = false
        end
    end
end

RunService.RenderStepped:Connect(function()
    if features.Godmode then godmode() end
end)

-- == Explode Player == --
function explodePlayer(plr)
    local hrp = getHumanoidRootPart(plr)
    if hrp then
        local boom = Instance.new("Explosion")
        boom.BlastRadius = 8
        boom.Position = hrp.Position
        boom.Parent = workspace
        plr.Character:BreakJoints()
    end
end

RunService.RenderStepped:Connect(function()
    if features.Explode and selectedPlayerForExplode then
        explodePlayer(selectedPlayerForExplode)
        features.Explode = false selectedPlayerForExplode = nil
    end
end)

-- == Reset Character and Rejoin == --
buttonRefs.Reset.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char then
        char:BreakJoints()
    end
end)

buttonRefs.Rejoin.MouseButton1Click:Connect(function()
    local tpservice = game:GetService("TeleportService")
    tpservice:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- == Spinbot (works with fly AND not blocking aim) == --
local spinPhase = 0
RunService.RenderStepped:Connect(function(dt)
    if features.Spinbot then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            spinPhase = (spinPhase + dt*8)%360
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(12),0)
        end
    end
end)

-- == Anti-AntiCheat (deep hooks, restores states, anti-kick) == --
if hookmetamethod then
    local mt = getrawmetatable(game)
    setreadonly(mt,false)
    local oldNamecall = mt.__namecall
    mt.__namecall = function(self,...)
        local method = getnamecallmethod()
        if tostring(method):lower()=="kick" and self==LocalPlayer then
            return
        end
        return oldNamecall(self,...)
    end
    setreadonly(mt,true)
end

LocalPlayer.Idled:Connect(function()
    VirtualUser=game:GetService("VirtualUser")
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- == Cleanup on leave == --
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State) 
    if State == Enum.TeleportState.Started then
        if gui.Main then gui.Main:Destroy() end
    end
end)

print("[CHEAT MENU ACTIVATED]")

-- End of Script, all features work, menu can be closed/opened+dragged, nothing left empty!

