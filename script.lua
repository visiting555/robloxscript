local Services = {}
for _,s in ipairs({"Players","RunService","Teams","TweenService","CoreGui","TeleportService","UserInputService"}) do Services[s]=game:GetService(s) end
local Camera, LocalPlayer = workspace.CurrentCamera, Services.Players.LocalPlayer
local AssetService = game:GetService("InsertService")
local Lighting = game:GetService("Lighting")
local anticheatBypass = Instance.new("BindableEvent")
anticheatBypass.Name = string.rep("_",math.random(5,20)).."_Bypass"
anticheatBypass.Parent = workspace
local oldhook = getrawmetatable(game)
setreadonly(oldhook, false)
local oldnamecall = oldhook.__namecall
oldhook.__namecall = function(self, ...)
    local method = getnamecallmethod()
    if tostring(method):lower():find("kick") or tostring(method):lower():find("ban") then
        return 
    end
    return oldnamecall(self, ...)
end

local GUI = Instance.new("ScreenGui")
GUI.Name = "HileV2_Menu"
GUI.ResetOnSpawn = false
if Services.CoreGui:FindFirstChild(GUI.Name) then
    Services.CoreGui[GUI.Name]:Destroy()
end
GUI.Parent = Services.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = GUI
mainFrame.Size = UDim2.new(0,500,0,520)
mainFrame.Position = UDim2.new(0.31,0,0.14,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(8,8,8)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local function roundify(frame, rad)
    local uiC = Instance.new("UICorner")
    uiC.CornerRadius = UDim.new(0,rad)
    uiC.Parent = frame
end
roundify(mainFrame, 18)

local topBar = Instance.new("Frame",mainFrame)
topBar.Size = UDim2.new(1,0,0,38)
topBar.Position = UDim2.new(0,0,0,0)
topBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
topBar.BorderSizePixel = 0
roundify(topBar,16)

local title = Instance.new("TextLabel",topBar)
title.Text = "Hile Paneli"
title.TextColor3 = Color3.fromRGB(255,50,50)
title.TextSize = 21
title.Font = Enum.Font.SourceSansBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Size = UDim2.new(0.9,0,1,0)
title.Position = UDim2.new(0,12,0,0)

local hideBtn = Instance.new("TextButton",topBar)
hideBtn.Size = UDim2.new(0,34,0,32)
hideBtn.Position = UDim2.new(1,-46,0,3)
hideBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
hideBtn.Text = "-"
hideBtn.TextColor3 = Color3.fromRGB(220,220,220)
hideBtn.TextSize = 23
hideBtn.Font = Enum.Font.SourceSansBold
roundify(hideBtn,9)

local closeBtn = Instance.new("TextButton",topBar)
closeBtn.Size = UDim2.new(0,32,0,32)
closeBtn.Position = UDim2.new(1,-10-32,0,3)
closeBtn.BackgroundColor3 = Color3.fromRGB(40,11,11)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,60,60)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.SourceSansBold
roundify(closeBtn,9)
closeBtn.MouseButton1Click:Connect(function() 
    GUI:Destroy() 
end)

hideBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    wait(2)
    mainFrame.Visible = true
end)

local navFrame = Instance.new("Frame", mainFrame)
navFrame.Size = UDim2.new(0,120,1,-40)
navFrame.Position = UDim2.new(0,0,0,40)
navFrame.BackgroundColor3 = Color3.fromRGB(6,6,6)
navFrame.BorderSizePixel = 0
roundify(navFrame, 12)

local categories = {
    ["Aim Hileleri"] = {"Aimbot","SilentAim"},
    ["Görüş Hileleri"] = {"ESP","FOV Changer"},
    ["Troll Hileleri"] = {"Exploda","Spinbot"},
    ["Bireysel Hileler"] = {
        "Fly","Teleport","Yanına Teleport","Noclip","Spectate Player",
        "No Reload","Godmode","Rejoin","Reset Character"
    }
}
local cheatStatus = {}
for cat,v in pairs(categories) do
    for _,op in pairs(v) do
        cheatStatus[op] = false
    end
end
local navBtns, pages, activePage = {}, {}, nil

for i,cat in ipairs({
    "Aim Hileleri","Görüş Hileleri","Troll Hileleri","Bireysel Hileler"
}) do
    local btn = Instance.new("TextButton", navFrame)
    btn.Name = cat.."Btn"
    btn.Size = UDim2.new(1,0,0,36)
    btn.Position = UDim2.new(0,0,0,18+(i-1)*44)
    btn.BackgroundColor3 = Color3.fromRGB(15,15,15)
    btn.Text = cat
    btn.TextColor3 = Color3.fromRGB(255,50,50)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.BorderSizePixel = 0
    roundify(btn,9)
    navBtns[cat]=btn

    local p = Instance.new("Frame", mainFrame)
    p.Name = cat.."Page"
    p.Position = UDim2.new(0,130,0,51)
    p.Size = UDim2.new(0,350,0,420)
    p.BackgroundTransparency = 1
    p.Visible=false
    pages[cat]=p

    btn.MouseButton1Click:Connect(function()
        for _,v in pairs(pages) do v.Visible = false end
        p.Visible = true
        activePage = cat
    end)
end

pages["Aim Hileleri"].Visible=true
activePage="Aim Hileleri"

for cat,opts in pairs(categories) do
    for i,opt in ipairs(opts) do
        local optBtn = Instance.new("TextButton", pages[cat])
        optBtn.Name = opt.."_Btn"
        optBtn.Size = UDim2.new(0,225,0,32)
        optBtn.Position = UDim2.new(0,15,0,(i-1)*38+8)
        optBtn.BackgroundColor3 = Color3.fromRGB(28,28,28)
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.fromRGB(255,50,50)
        optBtn.Font = Enum.Font.SourceSansSemibold
        optBtn.TextSize = 16
        optBtn.BorderSizePixel = 0
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        roundify(optBtn,8)

        local toggleBox = Instance.new("TextButton", pages[cat])
        toggleBox.Name = opt.."_Toggle"
        toggleBox.Size = UDim2.new(0,70,0,31)
        toggleBox.Position = UDim2.new(0,245,0,(i-1)*38+8)
        toggleBox.BackgroundColor3 = Color3.fromRGB(46,46,46)
        toggleBox.Text = "Kapalı"
        toggleBox.TextColor3 = Color3.fromRGB(255,40,40)
        toggleBox.Font = Enum.Font.SourceSansSemibold
        toggleBox.TextSize = 14
        toggleBox.BorderSizePixel = 0
        roundify(toggleBox,8)

        local function updateBtn()
            if cheatStatus[opt] then
                toggleBox.Text = "Açık"
                toggleBox.TextColor3 = Color3.fromRGB(51,225,40)
            else
                toggleBox.Text = "Kapalı"
                toggleBox.TextColor3 = Color3.fromRGB(255,40,40)
            end
        end

        optBtn.MouseButton1Click:Connect(function()
            cheatStatus[opt] = not cheatStatus[opt]
            updateBtn()
            if opt == "No Reload" then
                for _,tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:FindFirstChild("Ammo") then
                        tool.Ammo.Value = cheatStatus[opt] and math.huge or tool.Ammo.Value
                    end
                end
            end
            if opt == "Godmode" and LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Health = cheatStatus[opt] and math.huge or hum.Health
                    hum.MaxHealth = cheatStatus[opt] and math.huge or hum.MaxHealth
                end
            end
        end)
        toggleBox.MouseButton1Click:Connect(optBtn.MouseButton1Click)
        updateBtn()

        if opt=="Teleport" or opt=="Yanına Teleport" or opt=="Exploda" or opt=="Spectate Player" then
            optBtn.MouseButton1Click:Connect(function()
                local dropdown = Instance.new("Frame", mainFrame)
                dropdown.Size = UDim2.new(0,210,0,228)
                dropdown.Position = UDim2.new(0,140,0,120)
                dropdown.BackgroundColor3 = Color3.fromRGB(22,22,22)
                dropdown.BorderSizePixel = 0
                roundify(dropdown,9)
                local scrl = Instance.new("ScrollingFrame", dropdown)
                scrl.Size = UDim2.new(1,0,1,0)
                scrl.BackgroundTransparency = 1
                scrl.ScrollBarThickness = 4
                scrl.VertScrollBarInset = Enum.ScrollBarInset.Always
                scrl.BorderSizePixel = 0
                local y = 0
                for _,pl in ipairs(Services.Players:GetPlayers()) do
                    if pl ~= LocalPlayer and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") and (not Services.Teams or not LocalPlayer.Team or pl.Team ~= LocalPlayer.Team or opt=="Spectate Player") then
                        local b = Instance.new("TextButton", scrl)
                        b.Size = UDim2.new(1,0,0,30)
                        b.Position = UDim2.new(0,0,0,y*34)
                        b.BackgroundColor3 = Color3.fromRGB(28,28,28)
                        b.Text = pl.Name
                        b.TextColor3 = Color3.fromRGB(255,50,50)
                        b.Font = Enum.Font.SourceSansBold
                        b.TextSize = 17
                        y = y+1
                        roundify(b,7)
                        b.MouseButton1Click:Connect(function()
                            if opt=="Teleport" then
                                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = pl.Character.HumanoidRootPart.CFrame + Vector3.new(0,4,0)
                                end
                            elseif opt=="Yanına Teleport" then
                                if pl.Character and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    pl.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
                                end
                            elseif opt=="Exploda" then
                                local ex = Instance.new("Explosion",workspace)
                                ex.Position = pl.Character.HumanoidRootPart.Position
                                ex.BlastRadius = 11
                                ex.BlastPressure = 1e6
                            elseif opt=="Spectate Player" then
                                spectateOriginal = Camera.CameraSubject
                                Camera.CameraSubject = pl.Character:FindFirstChildOfClass("Humanoid")
                            end
                            dropdown:Destroy()
                        end)
                    end
                end
                scrl.CanvasSize = UDim2.new(0,0,0,y*34)
                local xBtn = Instance.new("TextButton",dropdown)
                xBtn.Size = UDim2.new(0,29,0,24)
                xBtn.Position = UDim2.new(1,-34,0,4)
                xBtn.Text = "X"
                xBtn.TextColor3 = Color3.fromRGB(255,80,80)
                xBtn.BackgroundColor3 = Color3.fromRGB(36,36,36)
                xBtn.TextSize = 15
                xBtn.Font = Enum.Font.SourceSansBold
                roundify(xBtn,6)
                xBtn.MouseButton1Click:Connect(function() dropdown:Destroy() end)
            end)
        end

        if opt == "Rejoin" then
            optBtn.MouseButton1Click:Connect(function()
                Services.TeleportService:Teleport(game.PlaceId)
            end)
        end
        if opt == "Reset Character" then
            optBtn.MouseButton1Click:Connect(function()
                if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
            end)
        end
    end
end

local fov = 90
Camera.FieldOfView = fov
local spectateOriginal = nil

local function isEnemy(pl)
    return pl~=LocalPlayer and (not Services.Teams or not LocalPlayer.Team or pl.Team~=LocalPlayer.Team)
end

local function getClosestPlayer()
    local mouse = Services.UserInputService:GetMouseLocation()
    local dist,found = math.huge,nil
    for _,pl in ipairs(Services.Players:GetPlayers()) do
        if isEnemy(pl) and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            local vec,onscreen = Camera:WorldToViewportPoint(pl.Character.HumanoidRootPart.Position)
            local m = (Vector2.new(vec.X,vec.Y) - mouse).Magnitude
            if onscreen and m < fov and m < dist then dist,found = m,pl end
        end
    end
    return found
end

local function makeESP(pl)
    if pl~=LocalPlayer and (not Services.Teams or not LocalPlayer.Team or pl.Team~=LocalPlayer.Team) and pl.Character and pl.Character:FindFirstChild("Head") then
        if not pl.Character.Head:FindFirstChild("hilbox") then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "hilbox"
            box.Adornee = pl.Character.Head
            box.Size = Vector3.new(3.1,3.1,3.1)
            box.Color3 = Color3.fromRGB(255,0,0)
            box.Transparency = 0.72
            box.ZIndex = 2
            box.AlwaysOnTop = true
            box.Parent = pl.Character.Head
        end
    end
end

RunService.RenderStepped:Connect(function()
    if cheatStatus["ESP"] then
        for _,pl in ipairs(Services.Players:GetPlayers()) do
            makeESP(pl)
        end
    else
        for _,pl in ipairs(Services.Players:GetPlayers()) do
            pcall(function()
                local b = pl.Character and pl.Character:FindFirstChild("Head") and pl.Character.Head:FindFirstChild("hilbox")
                if b then b:Destroy() end
            end)
        end
    end

    if cheatStatus["Godmode"] and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = math.huge; hum.MaxHealth = math.huge end
    end

    if (cheatStatus["Spinbot"] or cheatStatus["Fly"]) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(11),0)
    end

    if cheatStatus["Fly"] then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local h = char:FindFirstChildOfClass("Humanoid")
            if h then h.PlatformStand = true end
            local move = Vector3.new()
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
            char.HumanoidRootPart.Velocity = move.Magnitude>0 and move.Unit*38 or Vector3.new()
        end
    else
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").PlatformStand=false
        end
    end

    if cheatStatus["Noclip"] and LocalPlayer.Character then
        for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide=false end
        end
    end

    if cheatStatus["Aimbot"] then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

local old
old = hookmetamethod(game,"__namecall",newcclosure(function(self,...)
    local method = getnamecallmethod()
    if cheatStatus["SilentAim"] and tostring(method)=="FireServer" and tostring(self)=="Hit" then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local args = {...}
            args[2] = target.Character.Head.Position
            return old(self, unpack(args))
        end
    end
    return old(self,...)
end))

Services.UserInputService.InputBegan:Connect(function(inp,gp)
    if inp.KeyCode==Enum.KeyCode.Insert then
        mainFrame.Visible = not mainFrame.Visible
    end
    if inp.KeyCode==Enum.KeyCode.M and Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        mainFrame.Visible=false wait(2) mainFrame.Visible=true
    end
    if inp.KeyCode==Enum.KeyCode.RightBracket and spectateOriginal then
        Camera.CameraSubject = spectateOriginal
        spectateOriginal = nil
    end
end)

Services.UserInputService.InputChanged:Connect(function(input)
    if cheatStatus["FOV Changer"] and input.UserInputType==Enum.UserInputType.MouseWheel then
        fov = math.clamp(fov-input.Position.Z*2.7,28,130)
        Camera.FieldOfView = fov
    end
end)

Camera.FieldOfView = fov

local function hookNoReload(tool)
    if tool:FindFirstChild("Ammo") and not tool:FindFirstChild("HVL_noReload") then
        local marker = Instance.new("BoolValue", tool)
        marker.Name = "HVL_noReload"
        tool.Activated:Connect(function(...)
            if cheatStatus["No Reload"] then
                tool.Ammo.Value = 1e6
            end
        end)
    end
end

LocalPlayer.Backpack.ChildAdded:Connect(function(tool)
    pcall(hookNoReload, tool)
end)
for _,tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
    pcall(hookNoReload, tool)
end
if LocalPlayer.Character then
    for _,tool in ipairs(LocalPlayer.Character:GetChildren()) do
        pcall(hookNoReload, tool)
    end
end

for _,v in ipairs(workspace:GetChildren()) do
    if v:IsA("Part") or v:IsA("BasePart") then
        v.Anchored = false
    end
end

if (not syn and not KRNL_LOADED and not isexecutorclosure) then
    print("Multi-Bypass - Premium injected")
end

coroutine.wrap(function()
    while wait(7) do
        for _,pl in ipairs(Services.Players:GetPlayers()) do
            if pl.Character and pl.Character:FindFirstChildOfClass("Humanoid") then
                local hum = pl.Character:FindFirstChildOfClass("Humanoid")
                if hum.Health ~= math.huge and cheatStatus["Godmode"] and pl==LocalPlayer then
                    hum.Health = math.huge
                end
            end
        end
    end
end)()

local spamInit = false
local function anticheatKeepAlive()
    if not spamInit then
        spamInit = true
        for i=1,18 do
            local dummy = Instance.new("Folder")
            dummy.Name = "AntiCheat_"..math.random(1,9e6)
            dummy.Parent = workspace
        end
    end
end
anticheatKeepAlive()

local function refreshMenu()
    for cat,optlist in pairs(categories) do
        for oidx,opt in ipairs(optlist) do
            local page = pages[cat]
            local ob = page:FindFirstChild(opt.."_Btn")
            local ot = page:FindFirstChild(opt.."_Toggle")
            if ob and ot then
                if cheatStatus[opt] then
                    ot.Text = "Açık"
                    ot.TextColor3 = Color3.fromRGB(51,225,40)
                else
                    ot.Text = "Kapalı"
                    ot.TextColor3 = Color3.fromRGB(255,40,40)
                end
            end
        end
    end
end

Services.Players.PlayerAdded:Connect(function(pl)
    pl.CharacterAdded:Connect(function()
        wait(2)
        if cheatStatus["ESP"] then
            makeESP(pl)
        end
        refreshMenu()
    end)
end)

coroutine.wrap(function()
    while wait(10) do
        if cheatStatus["ESP"] then
            for _,pl in ipairs(Services.Players:GetPlayers()) do
                makeESP(pl)
            end
        end
    end
end)()

coroutine.wrap(function()
    while wait(90) do
        anticheatKeepAlive()
    end
end)()
