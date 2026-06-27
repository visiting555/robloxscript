local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local mainGuiName = "UltraMinimalCheatMenuV2"
local function getGUIContainer()
    return LocalPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui
end
if getGUIContainer():FindFirstChild(mainGuiName) then getGUIContainer()[mainGuiName]:Destroy() end

local features = {
    Aimbot = false, SilentAim = false, ESP = false, Fly = false, Teleport = false, Bring = false, Noclip = false, Spectate = false, 
    FOV = false, NoReload = false, Godmode = false, Rejoin = false, Reset = false, Explode = false, Spinbot = false
}

local fovValue = 90
local flySpeed = 5
local cheatDisabled = false
local menuOpen = true
local dragging, dragOffset = false, Vector2.new()
local menuSize = Vector2.new(340, 322)
local menuPos = Vector2.new((Camera.ViewportSize.X - menuSize.X) / 2, (Camera.ViewportSize.Y - menuSize.Y) / 2)
local buttonRefs = {}
local espObjects, selectedPlayerForTeleport,selectedPlayerForBring,selectedPlayerForSpectate,selectedPlayerForExplode = {},nil,nil,nil,nil

local categories = {
    ["Aim Hileleri"] = {
        {Key="Aimbot", Name="Aimbot"},
        {Key="SilentAim", Name="Silent Aim"},
        {Key="FOV", Name="FOV Değiştir"},
        {Key="Spinbot", Name="Spinbot"},
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
        v:Destroy()
    end
end

local mainGui = Instance.new("ScreenGui")
mainGui.Name = mainGuiName
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
topBar.Text = "CHEAT MENU"
topBar.Size = UDim2.new(1, 0, 0, 36)
topBar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
topBar.TextColor3 = Color3.fromRGB(255,0,0)
topBar.Font = Enum.Font.GothamBold
topBar.TextSize = 22
topBar.BorderSizePixel = 0

local leftPanelWidth = 104
local leftPanel = Instance.new("Frame", mainFrame)
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, leftPanelWidth, 1, -36)
leftPanel.Position = UDim2.new(0, 0, 0, 36)
leftPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
leftPanel.BorderSizePixel = 0

local container = Instance.new("Frame", mainFrame)
container.Name = "CategoryContainer"
container.Size = UDim2.new(1, -leftPanelWidth, 1, -36)
container.Position = UDim2.new(0, leftPanelWidth, 0, 36)
container.BackgroundTransparency = 1

local categoryBtnRefs = {}
local function updateCategoryButtons()
    for _,cat in ipairs(categoryOrder) do
        if categoryBtnRefs[cat] then
            categoryBtnRefs[cat].BackgroundColor3 = (activeCategory==cat) and Color3.fromRGB(22,0,0) or Color3.fromRGB(18,8,8)
        end
    end
end

local function createCategoryButtons()
    clearFrame(leftPanel)
    categoryBtnRefs = {}
    local y = 7
    for _,cat in ipairs(categoryOrder) do
        local btn = Instance.new("TextButton", leftPanel)
        btn.AutoButtonColor = true
        btn.Size = UDim2.new(1,-18, 0, 32)
        btn.Position = UDim2.new(0,9,0,y)
        btn.Text = cat
        btn.Name = "Category_"..cat
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Color3.fromRGB(255,0,0)
        btn.BackgroundColor3 = (activeCategory==cat) and Color3.fromRGB(22,0,0) or Color3.fromRGB(18,8,8)
        btn.TextSize = 13
        btn.BorderSizePixel = 0
        btn.MouseButton1Click:Connect(function()
            activeCategory = cat
            updateCategoryButtons()
            createCheatOptionButtons()
        end)
        categoryBtnRefs[cat] = btn
        y = y + 36
    end
end

local function updateOptionButtonTexts()
    local cat = activeCategory
    for _,item in ipairs(categories[cat]) do
        if buttonRefs[item.Key] then
            buttonRefs[item.Key].Text = item.Name..(features[item.Key] and " [AÇIK]" or " [KAPALI]")
        end
    end
end

local function playerSelectPopup(optionType, callback)
    local playersList, playerBtns = {}, {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(playersList, p) end
    end
    local pop = Instance.new("Frame", mainFrame)
    pop.BackgroundColor3 = Color3.fromRGB(8,0,0)
    pop.BorderSizePixel = 0
    pop.Size = UDim2.new(0, 180, 0, math.max(60, #playersList*24+31))
    pop.Position = UDim2.new(0.5, -90, 0.5, -pop.Size.Y.Offset//2)
    pop.ZIndex = 15
    local title = Instance.new("TextLabel", pop)
    title.Size = UDim2.new(1,0,0,19)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255,0,0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    if optionType == "Teleport" then
        title.Text = "Işınlanacağın Oyuncuyu Seç"
    elseif optionType == "Bring" then
        title.Text = "Yanına Çekeceğin Oyuncuyu Seç"
    elseif optionType == "Spectate" then
        title.Text = "İzleyeceğin Oyuncuyu Seç"
    elseif optionType == "Explode" then
        title.Text = "Patlatacağın Oyuncuyu Seç"
    end
    local yBtn = 22
    for idx, player in ipairs(playersList) do
        local btn = Instance.new("TextButton", pop)
        btn.Size = UDim2.new(1,-8,0,20)
        btn.Position = UDim2.new(0,4,0,yBtn)
        btn.Text = player.DisplayName.."("..player.Name..")"
        btn.TextColor3 = Color3.fromRGB(255,0,0)
        btn.BackgroundColor3 = Color3.fromRGB(22,0,0)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = true
        btn.MouseButton1Click:Connect(function()
            callback(player)
            pop:Destroy()
        end)
        yBtn = yBtn + 22
    end
    task.delay(7, function()
        if pop and pop.Parent then pop:Destroy() end
    end)
end

local function createCheatOptionButtons()
    clearFrame(container)
    buttonRefs = {}
    local cat = activeCategory
    local y = 15
    for i,item in ipairs(categories[cat]) do
        local btn = Instance.new("TextButton", container)
        btn.Size = UDim2.new(1, -28, 0, 38)
        btn.Position = UDim2.new(0, 14, 0, y)
        btn.Name = "Option_"..item.Key
        btn.Text = item.Name..(features[item.Key] and " [AÇIK]" or " [KAPALI]")
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Color3.fromRGB(255,0,0)
        btn.BackgroundColor3 = Color3.fromRGB(12,12,12)
        btn.BorderSizePixel = 0
        btn.TextSize = 13
        buttonRefs[item.Key] = btn
        btn.MouseButton1Click:Connect(function()
            if item.Key == "Teleport" then
                playerSelectPopup("Teleport", function(p) selectedPlayerForTeleport=p features.Teleport=true end)
            elseif item.Key == "Bring" then
                playerSelectPopup("Bring", function(p) selectedPlayerForBring=p features.Bring=true end)
            elseif item.Key == "Spectate" then
                playerSelectPopup("Spectate", function(p) selectedPlayerForSpectate=p features.Spectate=true end)
            elseif item.Key == "Explode" then
                playerSelectPopup("Explode", function(p) selectedPlayerForExplode=p features.Explode=true end)
            elseif item.Key == "FOV" then
                local win = Instance.new("Frame", mainFrame)
                win.BackgroundColor3 = Color3.fromRGB(7,0,0)
                win.Size = UDim2.new(0,100,0,40)
                win.Position = UDim2.new(0.5,-50,0,menuSize.Y-58)
                win.BorderSizePixel = 0
                win.ZIndex=20
                local label=Instance.new("TextLabel", win)
                label.Size = UDim2.new(1,0,0,17)
                label.BackgroundTransparency = 1
                label.Text = "FOV: "..fovValue
                label.Font = Enum.Font.GothamBold
                label.TextColor3 = Color3.fromRGB(255,0,0)
                label.TextSize = 12
                local minus = Instance.new("TextButton", win)
                minus.Size = UDim2.new(0,24,0,16)
                minus.Position = UDim2.new(0,7,0,20)
                minus.BackgroundColor3 = Color3.fromRGB(24,0,0)
                minus.Text = "-"
                minus.Font = Enum.Font.GothamBold
                minus.TextSize = 15
                minus.TextColor3 = Color3.fromRGB(255,0,0)
                minus.MouseButton1Click:Connect(function()
                    fovValue = math.max(20, fovValue-10) label.Text="FOV: "..tostring(fovValue)
                end)
                local plus = Instance.new("TextButton", win)
                plus.Size = UDim2.new(0,24,0,16)
                plus.Position = UDim2.new(0,69,0,20)
                plus.BackgroundColor3 = Color3.fromRGB(24,0,0)
                plus.Text = "+"
                plus.Font = Enum.Font.GothamBold
                plus.TextSize = 15
                plus.TextColor3 = Color3.fromRGB(255,0,0)
                plus.MouseButton1Click:Connect(function()
                    fovValue = math.min(320, fovValue+10) label.Text="FOV: "..tostring(fovValue)
                end)
                task.delay(4, function() if win and win.Parent then win:Destroy() end end)
            else
                features[item.Key]=not features[item.Key]
                btn.Text = item.Name..(features[item.Key] and " [AÇIK]" or " [KAPALI]")
            end
            updateOptionButtonTexts()
        end)
        y = y + 44
    end
end

createCategoryButtons()
createCheatOptionButtons()

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        local pos = mainFrame.Position
        dragOffset = Vector2.new(input.Position.X - pos.X.Offset, input.Position.Y - pos.Y.Offset)
    end
end)
topBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local newPos = Vector2.new(input.Position.X, input.Position.Y) - dragOffset
        mainFrame.Position = UDim2.new(0, math.clamp(newPos.X,6,Camera.ViewportSize.X-menuSize.X-6), 0, math.clamp(newPos.Y,6,Camera.ViewportSize.Y-menuSize.Y-6))
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.Insert and not gpe then
        menuOpen = not menuOpen
        mainFrame.Visible = menuOpen
    end
end)

local fadeStart
RunService.RenderStepped:Connect(function()
    if not mainFrame.Visible then
        if not fadeStart then fadeStart = tick() end
        if tick()-fadeStart>2 then
            mainFrame.Visible=true
            menuOpen=true
            fadeStart=nil
        end
    else
        fadeStart=nil
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
                bbg.Size = UDim2.new(0,76,0,15)
                local lbl = Instance.new("TextLabel", bbg)
                lbl.Size = UDim2.new(1,0,1,0)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.fromRGB(255,0,0)
                lbl.Font = Enum.Font.GothamBold
                lbl.Text = plr.DisplayName
                lbl.TextSize = 10
                espObjects[plr]=bbg
            else
                espObjects[plr].Adornee = getRoot(plr)
            end
        else
            if espObjects[plr] then pcall(function() espObjects[plr]:Destroy() end) espObjects[plr]=nil end
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

local flyBV,flyBG=nil,nil
function flyStart()
    if flyBV then return end
    local c = LocalPlayer.Character
    if not c or not getRoot(LocalPlayer) then return end
    flyBV = Instance.new("BodyVelocity", getRoot(LocalPlayer))
    flyBV.MaxForce = Vector3.new(1e4,1e4,1e4)*9
    flyBV.Velocity = Vector3.new()
    flyBG = Instance.new("BodyGyro", getRoot(LocalPlayer))
    flyBG.MaxTorque = Vector3.new(1e8,1e8,1e8)
    flyBG.CFrame = Camera.CFrame
end
function flyStep()
    if not flyBV or not flyBG then return end
    local cf = Camera.CFrame
    local v = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then v= v + cf.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then v= v - cf.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then v= v - cf.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then v= v + cf.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then v= v + Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then v= v - Vector3.new(0,1,0) end
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

local function applyNoclip()
    local char = LocalPlayer.Character
    if not char then return end
    for _,p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = false
            if p:IsA("Seat") then p.Disabled = true end
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
        task.wait(0.25)
        applyNoclip()
    end
end)

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
        boom.BlastRadius = 6
        plr.Character:BreakJoints()
    end
end
local function spectatePlayer(plr)
    if plr and plr.Character and getRoot(plr) then
        Camera.CameraSubject = plr.Character:FindFirstChildOfClass("Humanoid") or getRoot(plr)
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
    if plr.Character:FindFirstChild("Head") then return "Head"
    elseif plr.Character:FindFirstChild("UpperTorso") then return "UpperTorso"
    end
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
        if pn and tgt.Character:FindFirstChild(pn) then silentAimTarget = tgt.Character[pn] end
    else
        silentAimTarget = nil
    end
end
RunService.RenderStepped:Connect(function()
    performAimbot()
    performSilentAim()
end)

if not getgenv().__ULTRAMIN_CHEAT_MT_HOOKED then
    getgenv().__ULTRAMIN_CHEAT_MT_HOOKED = true
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
RunService.RenderStepped:Connect(function(dt)
    if features.Spinbot then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(15), 0)
        end
    end
end)
RunService.RenderStepped:Connect(function()
    if features.Fly and features.Spinbot then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(8), 0)
        end
    end
end)

local function bindExtraButtonFns()
    if buttonRefs.Reset then
        buttonRefs.Reset.MouseButton1Click:Connect(function()
            local c = LocalPlayer.Character
            if c then c:BreakJoints() end
        end)
    end
    if buttonRefs.Rejoin then
        buttonRefs.Rejoin.MouseButton1Click:Connect(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
    end
end
bindExtraButtonFns()

LocalPlayer.Idled:Connect(function()
    local vu = game:GetService("VirtualUser")
    vu:Button2Down(Vector2.new(0,0),Camera.CFrame)
    vu:Button2Up(Vector2.new(0,0),Camera.CFrame)
end)
Players.LocalPlayer.OnTeleport:Connect(function(State)
    if State==Enum.TeleportState.Started then if mainGui then pcall(function() mainGui:Destroy() end) end end
end)




