local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Mouse = LocalPlayer:GetMouse()
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")

local function getGUIContainer()
    return LocalPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui
end

local features = {
    Aimbot = false, SilentAim = false, ESP = false, Fly = false, Teleport = false, Bring = false, Noclip = false, Spectate = false, 
    FOV = false, NoReload = false, Godmode = false, Rejoin = false, Reset = false, Explode = false, Spinbot = false
}

local fovValue = 120
local flySpeed = 5
local cheatDisabled = false
local menuOpen = true
local dragStart,dragging = nil,false
local menuSize = Vector2.new(630, 570)
local menuPos = Vector2.new((Camera.ViewportSize.X-menuSize.X)/2,(Camera.ViewportSize.Y-menuSize.Y)/2)
local selectedPlayerForTeleport,selectedPlayerForBring,selectedPlayerForSpectate,selectedPlayerForExplode = nil,nil,nil,nil
local buttonRefs = {}
local espObjects = {}

if getGUIContainer():FindFirstChild("RealCheatMenu") then getGUIContainer().RealCheatMenu:Destroy() end
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "RealCheatMenu"
mainGui.ResetOnSpawn = false
mainGui.IgnoreGuiInset = true
mainGui.Parent = getGUIContainer()

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, menuSize.X, 0, menuSize.Y)
mainFrame.Position = UDim2.new(0, menuPos.X, 0, menuPos.Y)
mainFrame.BackgroundColor3 = Color3.new(0,0,0)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = false
mainFrame.Visible = true
mainFrame.Parent = mainGui

local topBar = Instance.new("TextLabel", mainFrame)
topBar.Name = "TopBar"
topBar.Text = "ROBLOX ADVANCED CHEAT MENU"
topBar.Size = UDim2.new(1, 0, 0, 48)
topBar.BackgroundColor3 = Color3.new(0,0,0)
topBar.TextColor3 = Color3.fromRGB(255,0,0)
topBar.Font = Enum.Font.GothamBold
topBar.TextSize = 30
topBar.BorderSizePixel = 0

local leftPanel = Instance.new("Frame", mainFrame)
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, 180, 1, -48)
leftPanel.Position = UDim2.new(0, 0, 0, 48)
leftPanel.BackgroundColor3 = Color3.fromRGB(10,10,10)
leftPanel.BorderSizePixel = 0

local container = Instance.new("Frame", mainFrame)
container.Name = "CategoryContainer"
container.Size = UDim2.new(1, -180, 1, -48)
container.Position = UDim2.new(0, 180, 0, 48)
container.BackgroundTransparency = 1

local categories = {
    ["Aim Hileleri"] = {
        {Key="Aimbot", Name="Aimbot"},
        {Key="SilentAim",Name="Silent Aim"},
        {Key="FOV",Name="FOV Changer"},
        {Key="Spinbot",Name="Spinbot"},
    },
    ["Görüş Hileleri"] = {
        {Key="ESP", Name="ESP"},
        {Key="Spectate", Name="Oyuncuyu İzle"},
    },
    ["Troll Hileleri"] = {
        {Key="Explode", Name="Patlat"},
        {Key="Bring", Name="Yanına Çek"},
        {Key="Teleport", Name="Oyuncuya Işınlan"},
        {Key="Fly", Name="Fly"},
        {Key="Noclip", Name="Noclip"},
    },
    ["Bireysel Hileler"] = {
        {Key="Godmode", Name="Godmode"},
        {Key="NoReload", Name="Sınırsız Mermi"},
        {Key="Reset", Name="Karakterini Sıfırla"},
        {Key="Rejoin", Name="Rejoin"},
    }
}
local categoryOrder = {"Aim Hileleri", "Görüş Hileleri", "Troll Hileleri", "Bireysel Hileler"}
local activeCategory = categoryOrder[1]

local function clearFrame(frame)
    for _,v in ipairs(frame:GetChildren()) do
        if not v:IsA("UIListLayout") then
            v:Destroy()
        end
    end
end

local function updateButtonTexts()
    for _,cat in ipairs(categoryOrder) do
        for _,item in ipairs(categories[cat]) do
            if buttonRefs[item.Key] then
                buttonRefs[item.Key].Text = item.Name .. (features[item.Key] and " [AÇIK]" or " [KAPALI]")
            end
        end
    end
end

local function createCategoryButtons()
    clearFrame(leftPanel)
    local y = 18
    for _,cat in ipairs(categoryOrder) do
        local btn = Instance.new("TextButton", leftPanel)
        btn.Size = UDim2.new(1, -26, 0, 38)
        btn.Position = UDim2.new(0, 13, 0, y)
        btn.Text = cat
        btn.Name = "CatBtn_"..cat
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Color3.fromRGB(255,0,0)
        btn.BackgroundColor3 = (cat==activeCategory) and Color3.fromRGB(22,0,0) or Color3.fromRGB(18,8,8)
        btn.TextSize = 15
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = true
        btn.MouseButton1Click:Connect(function()
            activeCategory = cat
            createCheatOptionButtons()
            createCategoryButtons()
        end)
        y = y + 48
    end
end

local function playerSelectPopup(optionType, callback)
    local playersList, playerBtns = {}, {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(playersList, p) end
    end
    local pop = Instance.new("Frame", mainFrame)
    pop.BackgroundColor3 = Color3.fromRGB(15,0,0)
    pop.BorderSizePixel = 0
    pop.Size = UDim2.new(0, 290, 0, math.max(70,#playersList*32+36))
    pop.Position = UDim2.new(0, menuSize.X-310, 0, 66)
    pop.ZIndex = 15
    local title = Instance.new("TextLabel", pop)
    title.Size = UDim2.new(1,0,0,25)
    title.Position = UDim2.new(0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255,0,0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    if optionType == "Teleport" then
        title.Text = "Işınlanacağın Oyuncuyu Seç"
    elseif optionType == "Bring" then
        title.Text = "Yanına Çekeceğin Oyuncuyu Seç"
    elseif optionType == "Spectate" then
        title.Text = "İzleyeceğin Oyuncuyu Seç"
    elseif optionType == "Explode" then
        title.Text = "Patlatacağın Oyuncuyu Seç"
    end
    local yBtn = 30
    for idx, player in ipairs(playersList) do
        local btn = Instance.new("TextButton", pop)
        btn.Size = UDim2.new(1,-10,0,28)
        btn.Position = UDim2.new(0,5,0,yBtn)
        btn.Text = player.DisplayName .. " ("..player.Name..")"
        btn.TextColor3 = Color3.fromRGB(255,0,0)
        btn.BackgroundColor3 = Color3.fromRGB(30,0,0)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = true
        btn.MouseButton1Click:Connect(function()
            callback(player)
            pop:Destroy()
        end)
        table.insert(playerBtns, btn)
        yBtn = yBtn + 30
    end
    task.delay(8,function() if pop and pop.Parent then pop:Destroy() end end)
end

local function createCheatOptionButtons()
    clearFrame(container)
    local cat = activeCategory
    local count = #categories[cat]
    for i,item in ipairs(categories[cat]) do
        local btn = Instance.new("TextButton", container)
        btn.Size = UDim2.new(0, 260, 0, 44)
        btn.Position = UDim2.new(0, 34+math.floor((i-1)%2)*286, 0, 8+math.floor((i-1)/2)*54)
        btn.Name = "Option_"..item.Key
        btn.Text = item.Name..(features[item.Key] and " [AÇIK]" or " [KAPALI]")
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Color3.fromRGB(255,0,0)
        btn.BackgroundColor3 = Color3.fromRGB(14,14,14)
        btn.BorderSizePixel = 0
        btn.TextSize = 16
        buttonRefs[item.Key] = btn
        btn.MouseButton1Click:Connect(function()
            if item.Key == "Teleport" then
                playerSelectPopup("Teleport", function(p) selectedPlayerForTeleport=p features.Teleport = true end)
            elseif item.Key == "Bring" then
                playerSelectPopup("Bring", function(p) selectedPlayerForBring=p features.Bring = true end)
            elseif item.Key == "Spectate" then
                playerSelectPopup("Spectate", function(p) selectedPlayerForSpectate=p features.Spectate = true end)
            elseif item.Key == "Explode" then
                playerSelectPopup("Explode", function(p) selectedPlayerForExplode=p features.Explode = true end)
            elseif item.Key == "FOV" then
                local win = Instance.new("Frame", mainFrame)
                win.BackgroundColor3 = Color3.fromRGB(10,0,0)
                win.Size = UDim2.new(0,140,0,53)
                win.Position = UDim2.new(0,menuSize.X-160,0,menuSize.Y-140)
                win.BorderSizePixel = 0
                win.ZIndex=16
                local label = Instance.new("TextLabel", win)
                label.Size = UDim2.new(1,0,0,21)
                label.BackgroundTransparency = 1
                label.Text = "FOV: "..fovValue
                label.Font = Enum.Font.GothamBold
                label.TextColor3 = Color3.fromRGB(255,0,0)
                label.TextSize = 15
                local minus = Instance.new("TextButton", win)
                minus.Size = UDim2.new(0,38,0,22)
                minus.Position = UDim2.new(0,9,0,23)
                minus.BackgroundColor3 = Color3.fromRGB(25,0,0)
                minus.Text = "-"
                minus.Font = Enum.Font.GothamBold
                minus.TextSize = 20
                minus.TextColor3 = Color3.fromRGB(255,0,0)
                minus.MouseButton1Click:Connect(function()
                    fovValue = math.max(20, fovValue-10) label.Text="FOV: "..tostring(fovValue)
                end)
                local plus = Instance.new("TextButton", win)
                plus.Size = UDim2.new(0,38,0,22)
                plus.Position = UDim2.new(0,90,0,23)
                plus.BackgroundColor3 = Color3.fromRGB(25,0,0)
                plus.Text = "+"
                plus.Font = Enum.Font.GothamBold
                plus.TextSize = 20
                plus.TextColor3 = Color3.fromRGB(255,0,0)
                plus.MouseButton1Click:Connect(function()
                    fovValue = math.min(320, fovValue+10) label.Text="FOV: "..tostring(fovValue)
                end)
                task.delay(6, function() if win and win.Parent then win:Destroy() end end)
            else
                features[item.Key] = not features[item.Key]
                btn.Text = item.Name..(features[item.Key] and " [AÇIK]" or " [KAPALI]")
            end
            updateButtonTexts()
        end)
    end
end

createCategoryButtons()
createCheatOptionButtons()

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging=true
        dragStart=Vector2.new(input.Position.X, input.Position.Y) - Vector2.new(mainFrame.Position.X.Offset, mainFrame.Position.Y.Offset)
    end
end)
topBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
        local newPos = Vector2.new(input.Position.X,input.Position.Y) - dragStart
        mainFrame.Position = UDim2.new(0, math.clamp(newPos.X,10,Camera.ViewportSize.X-menuSize.X-10), 0, math.clamp(newPos.Y,10,Camera.ViewportSize.Y-menuSize.Y-10))
    end
end)

UserInputService.InputBegan:Connect(function(input,gpe)
    if input.KeyCode==Enum.KeyCode.Insert and not gpe then
        menuOpen=not menuOpen
        mainFrame.Visible=menuOpen
        if not menuOpen then mainFrame.Visible=false end
    end
end)
local fadeStart
RunService.RenderStepped:Connect(function()
    if not mainFrame.Visible then
        if not fadeStart then fadeStart = tick() end
        if tick()-fadeStart > 2 then
            mainFrame.Visible = true
            menuOpen = true
            fadeStart = nil
        end
    else
        fadeStart = nil
    end
end)

local function getRoot(plr)
    if not plr or not plr.Character then return nil end
    return plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChildWhichIsA("BasePart")
end

local function isEnemy(plr)
    if not plr or plr == LocalPlayer then return false end
    local hasTeams = LocalPlayer.Team ~= nil and plr.Team ~= nil
    if hasTeams and LocalPlayer.Team == plr.Team then return false end
    return true
end

local function updateESP()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and features.ESP and plr.Character and isEnemy(plr) and getRoot(plr) then
            if not espObjects[plr] then
                local bbg = Instance.new("BillboardGui", mainGui)
                bbg.AlwaysOnTop=true bbg.Adornee = getRoot(plr)
                bbg.Size = UDim2.new(0,110,0,22)
                local lbl = Instance.new("TextLabel", bbg)
                lbl.Size = UDim2.new(1,0,1,0)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.fromRGB(255,0,0)
                lbl.Font = Enum.Font.GothamBold
                lbl.Text = plr.DisplayName
                lbl.TextSize = 14
                espObjects[plr]=bbg
            else
                espObjects[plr].Adornee = getRoot(plr)
            end
        else
            if espObjects[plr] then pcall(function() espObjects[plr]:Destroy() end) espObjects[plr] = nil end
        end
    end
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.defer(updateESP) end)
end)
Players.PlayerRemoving:Connect(function(p)
    if espObjects[p] then pcall(function() espObjects[p]:Destroy() end) espObjects[p] = nil end
end)
RunService.RenderStepped:Connect(function()
    if features.ESP then
        updateESP()
    else
        for p,obj in pairs(espObjects) do pcall(function() obj:Destroy() end) espObjects[p]=nil end
    end
end)

-- Fly & Noclip
local flyBV,flyBG = nil,nil
function flyStart()
    if flyBV then return end
    local c = LocalPlayer.Character
    if not c or not getRoot(LocalPlayer) then return end
    flyBV = Instance.new("BodyVelocity", getRoot(LocalPlayer))
    flyBV.MaxForce = Vector3.new(1e5,1e5,1e5) * 9
    flyBV.Velocity = Vector3.new()
    flyBG = Instance.new("BodyGyro", getRoot(LocalPlayer))
    flyBG.MaxTorque = Vector3.new(1e8,1e8,1e8)
    flyBG.CFrame = Camera.CFrame
end
function flyStep()
    if not flyBV or not flyBG then return end
    local cf = Camera.CFrame
    local v = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then v = v + cf.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then v = v - cf.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then v = v - cf.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then v = v + cf.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then v = v + Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then v = v - Vector3.new(0,1,0) end
    flyBV.Velocity = (v.Magnitude>0 and v.Unit or v) * flySpeed * 18
    flyBG.CFrame = Camera.CFrame
end
function flyStop()
    if flyBV then pcall(function() flyBV:Destroy() end) flyBV = nil end
    if flyBG then pcall(function() flyBG:Destroy() end) flyBG = nil end
end

RunService.RenderStepped:Connect(function()
    if features.Fly then
        if not flyBV then flyStart() end
        flyStep()
    else
        flyStop()
    end
end)

-- Improved Noclip (permanently disables collision regardless of state)
local noclipConnection
local function applyNoclip()
    local char = LocalPlayer.Character
    if not char then return end
    for _,p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = false
            p.CastShadow = false
            if p:IsA("MeshPart") then p.Material = Enum.Material.ForceField end
        end
    end
end
RunService.Stepped:Connect(function()
    if features.Noclip then
        local char = LocalPlayer.Character
        if char then
            applyNoclip()
        end
    end
end)
LocalPlayer.CharacterAdded:Connect(function(char)
    if features.Noclip then
        task.wait(0.4)
        applyNoclip()
    end
end)

-- Teleport/Bring/Explode/Spectate
local function teleportTo(plr)
    if not plr or not plr.Character then return end
    local myroot,root = getRoot(LocalPlayer),getRoot(plr)
    if myroot and root then myroot.CFrame = root.CFrame + Vector3.new(0,3,0) end
end
local function bringToMe(plr)
    if not plr or not plr.Character then return end
    local troot, myroot = getRoot(plr),getRoot(LocalPlayer)
    if troot and myroot then troot.CFrame = myroot.CFrame + Vector3.new(0,1,0) end
end
local function explodePlayer(plr)
    if not plr or not plr.Character then return end
    local root = getRoot(plr)
    if root then
        local boom = Instance.new("Explosion", workspace)
        boom.Position = root.Position
        boom.BlastRadius = 7
        plr.Character:BreakJoints()
    end
end
local function spectatePlayer(plr)
    if plr and plr.Character and getRoot(plr) then
        Camera.CameraSubject = plr.Character:FindFirstChildOfClass("Humanoid")
    else
        Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or Camera.CameraSubject
    end
end

RunService.RenderStepped:Connect(function()
    if features.Teleport and selectedPlayerForTeleport then teleportTo(selectedPlayerForTeleport) selectedPlayerForTeleport = nil features.Teleport = false end
    if features.Bring and selectedPlayerForBring then bringToMe(selectedPlayerForBring) selectedPlayerForBring = nil features.Bring = false end
    if features.Explode and selectedPlayerForExplode then explodePlayer(selectedPlayerForExplode) selectedPlayerForExplode = nil features.Explode = false end
    if features.Spectate and selectedPlayerForSpectate then
        spectatePlayer(selectedPlayerForSpectate)
    elseif not features.Spectate then
        Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or Camera.CameraSubject
    end
end)

-- Aimbot/SilentAim
local function getClosestEnemy()
    local bestDist = fovValue
    local closest = nil
    for _,p in ipairs(Players:GetPlayers()) do
        if isEnemy(p) and p.Character and getRoot(p) and (p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0) then
            local s = Camera:WorldToViewportPoint(getRoot(p).Position)
            if s.Z > 0 then
                local d = (Vector2.new(s.X, s.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if d < bestDist then bestDist = d closest = p end
            end
        end
    end
    return closest
end
local function getPreferredPart(plr)
    if plr.Character:FindFirstChild("Head") then return "Head" end
    if plr.Character:FindFirstChild("UpperTorso") then return "UpperTorso" end
    return nil
end
local silentAimTarget = nil
local function performAimbot()
    if not features.Aimbot then return end
    local tgt = getClosestEnemy()
    if tgt and tgt.Character and getRoot(tgt) then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, getRoot(tgt).Position)
        end
    end
end
local function performSilentAim()
    if not features.SilentAim then silentAimTarget = nil return end
    local tgt = getClosestEnemy()
    if tgt and tgt.Character then
        local pn = getPreferredPart(tgt)
        if pn and tgt.Character:FindFirstChild(pn) then
            silentAimTarget = tgt.Character[pn]
        end
    else
        silentAimTarget = nil
    end
end
RunService.RenderStepped:Connect(function()
    performAimbot()
    performSilentAim()
end)

if not getgenv().__REAL_CHEAT_MT_HOOKED then
    getgenv().__REAL_CHEAT_MT_HOOKED = true
    local raw = getrawmetatable(game)
    setreadonly(raw, false)
    local old = raw.__namecall
    raw.__namecall = function(self, ...)
        local m = getnamecallmethod()
        if features.SilentAim and tostring(m):lower() == "fire" and typeof(self) == "Instance" and self:IsA("RemoteEvent") then
            if silentAimTarget then
                local args = {...}
                for i,v in pairs(args) do
                    if typeof(v) == "Vector3" then args[i] = silentAimTarget.Position end
                end
                return old(self, unpack(args))
            end
        end
        if tostring(m):lower() == "kick" and self == LocalPlayer then return end
        return old(self, ...)
    end
    setreadonly(raw, true)
end

-- Ammo/Godmode/Spinbot/NoReload
local function patchAmmo()
    for _,v in pairs(getgc(true)) do
        if typeof(v) == "function" and islclosure(v) and debug.getinfo(v).name then
            if tostring(debug.getinfo(v).name):lower():find("ammo") or tostring(debug.getinfo(v).name):lower():find("reload") then
                pcall(function() setupvalue(v,2,math.huge) end)
            end
        end
    end
end
local function godmode()
    local c = LocalPlayer.Character
    if not c then return end
    for _,h in ipairs(c:GetDescendants()) do
        if h:IsA("Humanoid") then
            h.MaxHealth = math.huge
            h.Health = math.huge
            h:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
            h.BreakJointsOnDeath = false
        end
    end
end

RunService.RenderStepped:Connect(function()
    if features.NoReload then patchAmmo() end
    if features.Godmode then godmode() end
end)
buttonRefs.Reset.MouseButton1Click:Connect(function()
    local c = LocalPlayer.Character
    if c then c:BreakJoints() end
end)
buttonRefs.Rejoin.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

RunService.RenderStepped:Connect(function(dt)
    if features.Spinbot then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(15), 0)
        end
    end
end)
LocalPlayer.Idled:Connect(function()
    local vu = game:GetService("VirtualUser")
    vu:Button2Down(Vector2.new(0,0),Camera.CFrame)
    vu:Button2Up(Vector2.new(0,0),Camera.CFrame)
end)
Players.LocalPlayer.OnTeleport:Connect(function(State)
    if State==Enum.TeleportState.Started then if mainGui then pcall(function() mainGui:Destroy() end) end end
end)



