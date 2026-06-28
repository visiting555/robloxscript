local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalHackMenuV2"
pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 650, 0, 686)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -340)
MainFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
MainFrame.Visible = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 38)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "UNIVERSAL HİLE MENÜSÜ (F ile Aç/Kapat)"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local tabFrame = Instance.new("Frame", MainFrame)
tabFrame.Size = UDim2.new(1, 0, 0, 36)
tabFrame.Position = UDim2.new(0, 0, 0, 38)
tabFrame.BackgroundTransparency = 1

local contentFrame = Instance.new("Frame", MainFrame)
contentFrame.Size = UDim2.new(1, 0, 1, -74)
contentFrame.Position = UDim2.new(0, 0, 0, 74)
contentFrame.BackgroundTransparency = 1

local Tabs, CurrentTab = {}, nil
local function createTab(tabname)
    local tabBtn = Instance.new("TextButton", tabFrame)
    tabBtn.Size = UDim2.new(0.16, -2, 1, -5)
    tabBtn.Position = UDim2.new(#Tabs * 0.165 + 0.012, 0, 0, 2)
    tabBtn.BackgroundColor3 = Color3.fromRGB(27,27,27)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 16
    tabBtn.Text = tabname
    tabBtn.AutoButtonColor = true
    tabBtn.TextColor3 = Color3.fromRGB(255,255,255)
    tabBtn.BorderSizePixel = 0
    local cFrame = Instance.new("Frame", contentFrame)
    cFrame.Size = UDim2.new(1, 0, 1, 0)
    cFrame.Visible = (#Tabs==0)
    cFrame.BackgroundTransparency = 1
    table.insert(Tabs, {Button=tabBtn, Frame=cFrame})
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Frame.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(27,27,27)
        end
        cFrame.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(64, 217, 255)
        CurrentTab = cFrame
    end)
    if #Tabs==1 then
        tabBtn.BackgroundColor3 = Color3.fromRGB(64, 217, 255)
        cFrame.Visible = true
        CurrentTab = cFrame
    end
    return cFrame
end

local tabAimbot = createTab("Aimbot")
local tabVisual = createTab("ESP")
local tabMovement = createTab("Hareket")
local tabPlayer = createTab("Oyuncu")
local tabFun = createTab("Eğlence")
local tabOther = createTab("Diğer")

local states = {
    aimbot = false,
    aimbotType = 1,
    fov = 90,
    silentaim = false,
    esp = false,
    spinbot = false,
    fly = false,
    flySpeed = 90,
    noclip = false,
    invisible = false,
    godmode = false,
    carLaunch = false,
    carAssetId = "rbxassetid://29439208",
    playerFire=false,
    playerExplode=false,
    followPlayer=false,
    teleportTo=false,
    bringPlayer=false,
    fovValue = 90,
    funSpin = false,
}

local selectedTarget = nil
local flyConn, spinConn, noclipConn, invisibleConn, godConn = nil, nil, nil, nil, nil

local function whiteBtn()
    local b = Instance.new("TextButton")
    b.BackgroundColor3 = Color3.fromRGB(27,27,27)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.TextSize=17
    return b
end

local function addBtn(tab,x,y,w,h,txtOrCB,cb)
    local b = whiteBtn()
    b.Size = UDim2.new(0,w,0,h)
    b.Position = UDim2.new(0,x,0,y)
    b.Text = type(txtOrCB)=='function' and txtOrCB() or txtOrCB
    b.Parent = tab
    if cb then
        b.MouseButton1Click:Connect(function()
            cb(b)
            if type(txtOrCB)=='function' then b.Text = txtOrCB() end
        end)
    end
    return b
end

local function addLabel(tab,x,y,w,txt)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0,w,0,22)
    l.Position = UDim2.new(0,x,0,y)
    l.Text = txt
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.GothamBold
    l.TextSize = 17
    l.TextColor3 = Color3.fromRGB(255,255,255)
    l.Parent = tab
end

local function addSlider(tab, x, y, w, labelName, def, minv, maxv, step, changer)
    addLabel(tab, x, y-6, w, labelName)
    local s = Instance.new("TextBox")
    s.Size = UDim2.new(0, w, 0, 26)
    s.Position = UDim2.new(0, x, 0, y+14)
    s.Text = tostring(def)
    s.BackgroundColor3 = Color3.fromRGB(27,27,27)
    s.Font = Enum.Font.GothamBold
    s.TextColor3 = Color3.fromRGB(255,255,255)
    s.TextSize=17
    s.ClearTextOnFocus=false
    s.BorderSizePixel=0
    s.Parent = tab
    s.FocusLost:Connect(function()
        local n = tonumber(s.Text)
        if n and n>=minv and n<=maxv then
            changer(n)
            s.Text=tostring(n)
        else
            s.Text = tostring(def)
        end
    end)
    return s
end

local function updateDropdown(dropdown)
    dropdown.Text = "Seçili Hedef: " .. (selectedTarget and selectedTarget.Name or "Yok")
end
local function makePlayerDropdown(tab, x, y)
    local ddBtn = whiteBtn()
    ddBtn.Size = UDim2.new(0,220,0,32)
    ddBtn.Position = UDim2.new(0,x,0,y)
    updateDropdown(ddBtn)
    ddBtn.Parent = tab
    ddBtn.MouseButton1Click:Connect(function()
        local popup = Instance.new("Frame",ScreenGui)
        local playerList = {}
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then table.insert(playerList, plr) end
        end
        popup.Size = UDim2.new(0,190,0,#playerList>0 and 31*#playerList or 31)
        popup.Position = UDim2.new(0, MainFrame.AbsolutePosition.X+MainFrame.Size.X.Offset+4, 0, MainFrame.AbsolutePosition.Y+62)
        popup.BackgroundColor3 = Color3.fromRGB(255,255,255)
        popup.BorderSizePixel = 2
        popup.ZIndex = 203
        popup.Active = true
        popup.ClipsDescendants = true
        local list = Instance.new("UIListLayout", popup)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        for _,plr in ipairs(playerList) do
            local pBtn = whiteBtn()
            pBtn.Size = UDim2.new(1,0,0,31)
            pBtn.Text = plr.Name
            pBtn.ZIndex = 204
            pBtn.Parent = popup
            pBtn.MouseButton1Click:Connect(function()
                selectedTarget = plr
                updateDropdown(ddBtn)
                popup:Destroy()
            end)
        end
        local uisConn
        uisConn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local mouse = UserInputService:GetMouseLocation()
                if not (mouse.X > popup.AbsolutePosition.X and mouse.X < popup.AbsolutePosition.X + popup.AbsoluteSize.X and mouse.Y > popup.AbsolutePosition.Y and mouse.Y < popup.AbsolutePosition.Y + popup.AbsoluteSize.Y) then
                    popup:Destroy()
                    if uisConn then uisConn:Disconnect() end
                end
            end
        end)
    end)
    return ddBtn
end
local playerDropdown = makePlayerDropdown(tabPlayer,18,10)

addLabel(tabAimbot,18,8,230,"Aimbot Tipi")
local aimTypes = {"Başa", "Vücuda", "En Yakın Parça"}
addBtn(tabAimbot,18,32,160,28,function() return "Tip: "..aimTypes[states.aimbotType] end,
    function(b) states.aimbotType = (states.aimbotType)%#aimTypes+1 end)
addBtn(tabAimbot,188,32,150,28,function() return "Aimbot "..(states.aimbot and "AÇIK" or "KAPALI") end,
    function(b) states.aimbot = not states.aimbot end)
addBtn(tabAimbot,358,32,150,28,function() return "SilentAim "..(states.silentaim and "AÇIK" or "KAPALI") end,
    function(b) states.silentaim = not states.silentaim end)
addSlider(tabAimbot,18,72,150,"FOV Açısı (50-150)",states.fov,50,150,1,function(val)
    states.fov=val
    Camera.FieldOfView=val
end)

-- ESP (box and head: fixed, correct size and non-freezing, bacon proportions)
local espObjects = {}
local BACON_BOX_W, BACON_BOX_H = 24, 38 -- smaller, matches regular bacon
local HEAD_RADIUS = 6 -- fairly small circle for actual head

local function makeESP(player)
    if player == LocalPlayer or espObjects[player] then return end
    local obj = {drawings = {}}
    local function getCharacterData()
        local char = player.Character
        if not char then return nil end
        local head = char:FindFirstChild("Head")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local lfoot = char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg")
        local rfoot = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg")
        return head, hrp, lfoot, rfoot
    end
    local stopped = false
    obj.run = RunService.RenderStepped:Connect(function()
        if stopped or not states.esp or not player or not player.Character or not Camera then
            for _, d in pairs(obj.drawings) do if d.Remove then pcall(function() d:Remove() end) end end
            return
        end
        local head, hrp, lfoot, rfoot = getCharacterData()
        if not head or not hrp then
            for _, d in pairs(obj.drawings) do if d.Visible~=nil then d.Visible = false end end
            return
        end
        local headScreen, onHead = Camera:WorldToViewportPoint(head.Position)
        local hrpScreen, onTorso = Camera:WorldToViewportPoint(hrp.Position)
        if not onHead or not onTorso then
            for _, d in pairs(obj.drawings) do if d.Visible~=nil then d.Visible = false end end
            return
        end

        if not obj.drawings.box then
            obj.drawings.box = Drawing.new("Square")
            obj.drawings.box.Color = Color3.fromRGB(0,0,0)
            obj.drawings.box.Thickness = 2
            obj.drawings.box.Filled = false
            obj.drawings.box.Transparency = 1
        end

        local boxY = hrpScreen.Y - BACON_BOX_H/2
        obj.drawings.box.Size = Vector2.new(BACON_BOX_W, BACON_BOX_H)
        obj.drawings.box.Position = Vector2.new(hrpScreen.X - BACON_BOX_W/2, boxY)
        obj.drawings.box.Visible = states.esp

        if not obj.drawings.circle then
            obj.drawings.circle = Drawing.new("Circle")
            obj.drawings.circle.Color = Color3.fromRGB(220,78,27)
            obj.drawings.circle.Thickness = 2
            obj.drawings.circle.NumSides = 18
            obj.drawings.circle.Filled = false
            obj.drawings.circle.Transparency = 1
        end
        obj.drawings.circle.Position = Vector2.new(headScreen.X, headScreen.Y)
        obj.drawings.circle.Radius = HEAD_RADIUS
        obj.drawings.circle.Visible = states.esp

        if not obj.drawings.skel then
            obj.drawings.skel = {
                body = Drawing.new("Line"),
                leftLeg = Drawing.new("Line"),
                rightLeg = Drawing.new("Line"),
            }
            obj.drawings.skel.body.Color = Color3.fromRGB(200,200,200)
            obj.drawings.skel.body.Thickness = 2
            obj.drawings.skel.body.Transparency=1
            obj.drawings.skel.leftLeg.Color = Color3.fromRGB(200,200,200)
            obj.drawings.skel.leftLeg.Thickness = 2
            obj.drawings.skel.leftLeg.Transparency=1
            obj.drawings.skel.rightLeg.Color = Color3.fromRGB(200,200,200)
            obj.drawings.skel.rightLeg.Thickness = 2
            obj.drawings.skel.rightLeg.Transparency=1
        end
        obj.drawings.skel.body.From = Vector2.new(headScreen.X, headScreen.Y+HEAD_RADIUS)
        obj.drawings.skel.body.To = Vector2.new(hrpScreen.X, hrpScreen.Y)
        obj.drawings.skel.body.Visible = states.esp

        if lfoot and rfoot then
            local lfootScreen, lfok = Camera:WorldToViewportPoint(lfoot.Position)
            local rfootScreen, rfok = Camera:WorldToViewportPoint(rfoot.Position)
            obj.drawings.skel.leftLeg.From = Vector2.new(hrpScreen.X, hrpScreen.Y)
            obj.drawings.skel.leftLeg.To = lfootScreen
            obj.drawings.skel.leftLeg.Visible = states.esp and lfok
            obj.drawings.skel.rightLeg.From = Vector2.new(hrpScreen.X, hrpScreen.Y)
            obj.drawings.skel.rightLeg.To = rfootScreen
            obj.drawings.skel.rightLeg.Visible = states.esp and rfok
        else
            obj.drawings.skel.leftLeg.Visible = false
            obj.drawings.skel.rightLeg.Visible = false
        end
    end)
    espObjects[player] = obj
end

local function removeESP(player)
    local obj = espObjects[player]
    if obj then
        pcall(function()
            if obj.run then obj.run:Disconnect() end
            for _,d in pairs(obj.drawings) do
                if d.Remove then
                    d:Remove()
                elseif typeof(d)=="table" then
                    for _,ld in pairs(d) do pcall(function() ld:Remove() end) end
                end
            end
        end)
        espObjects[player] = nil
    end
end

addBtn(tabVisual,18,18,240,30,function() return "ESP ["..(states.esp and "AÇIK" or "KAPALI").."]" end,function()
    states.esp = not states.esp
    if states.esp then
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then makeESP(plr) end
        end
    else
        for plr,_ in pairs(espObjects) do removeESP(plr) end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    if states.esp and plr ~= LocalPlayer then
        makeESP(plr)
    end
end)
Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
end)

addBtn(tabVisual,270,18,220,30,function() return "SpinBot ["..(states.spinbot and "AÇIK" or "KAPALI").."]" end,function()
    states.spinbot = not states.spinbot
    if states.spinbot and not spinConn then
        spinConn = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(45),0)
            end
        end)
    elseif not states.spinbot and spinConn then
        spinConn:Disconnect() spinConn=nil
    end
end)

addBtn(tabMovement,18,18,160,30,function() return "Fly ["..(states.fly and "AÇIK" or "KAPALI").."]" end,function()
    states.fly = not states.fly
    if states.fly and not flyConn then
        local vel
        flyConn = RunService.RenderStepped:Connect(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if not vel or not vel.Parent then
                    vel = Instance.new("BodyVelocity")
                    vel.MaxForce = Vector3.new(1,1,1)*1e6
                    vel.Velocity = Vector3.zero
                    vel.Parent = hrp
                end
                local move = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.E) then move = move + Camera.CFrame.UpVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Q) then move = move - Camera.CFrame.UpVector end
                vel.Velocity = move.Magnitude>0 and move.Unit*states.flySpeed or Vector3.zero
            end
        end)
    elseif flyConn then
        flyConn:Disconnect() flyConn=nil
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _,bv in ipairs(LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
                if bv:IsA("BodyVelocity") then bv:Destroy() end
            end
        end
    end
end)
addSlider(tabMovement,190,18,120,"Fly Speed",states.flySpeed,16,160,1,function(val)
    states.flySpeed=val
end)

addBtn(tabMovement,18,65,160,30,function() return "NoClip ["..(states.noclip and "AÇIK" or "KAPALI").."]" end,function()
    states.noclip = not states.noclip
    if states.noclip and not noclipConn then
        noclipConn = RunService.Stepped:Connect(function()
            if states.noclip then
                local char = LocalPlayer.Character
                if char and char ~= nil then
                    for _,p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide=false end
                    end
                end
            end
        end)
    elseif not states.noclip and noclipConn then
        noclipConn:Disconnect() noclipConn=nil
        local char = LocalPlayer.Character
        if char then
            for _,p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide=true end
            end
        end
    end
end)

addBtn(tabMovement,190,65,120,30,function()
    return "Invisible ["..(states.invisible and "AÇIK" or "KAPALI")
end,function()
    states.invisible = not states.invisible
    if states.invisible then
        local c = LocalPlayer.Character
        if c then
            for _,v in pairs(c:GetDescendants()) do
                if v:IsA("BasePart") then v.Transparency = 0.97 end
                if v:IsA("Decal") then v.Transparency = 1 end
            end
        end
    else
        local c = LocalPlayer.Character
        if c then
            for _,v in pairs(c:GetDescendants()) do
                if v:IsA("BasePart") then v.Transparency = 0 end
                if v:IsA("Decal") then v.Transparency = 0 end
            end
        end
    end
end)

addBtn(tabMovement,350,65,120,30,function() return "GodMode ["..(states.godmode and "AÇIK" or "KAPALI") end,function()
    states.godmode = not states.godmode
    if states.godmode and not godConn then
        godConn = RunService.Heartbeat:Connect(function()
            local c = LocalPlayer.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h then h.Health = h.MaxHealth end
        end)
    elseif godConn then godConn:Disconnect() godConn=nil end
end)

addLabel(tabPlayer,18,55,225,"Seçili oyuncuya işlem")
addBtn(tabPlayer,19,80,155,30,"Yak (Yanarak Öldür)",function()
    if selectedTarget and selectedTarget.Character then
        for _,p in ipairs(selectedTarget.Character:GetDescendants()) do
            if p:IsA("BasePart") then
                p.BrickColor = BrickColor.new("Bright red")
                p.Material = Enum.Material.Neon
                local fire = Instance.new("Fire")
                fire.Heat = 12
                fire.Size = 7
                fire.Parent = p
                Debris:AddItem(fire,2.3)
            end
        end
        local h=selectedTarget.Character:FindFirstChildOfClass("Humanoid")
        if h then h.Health=0 end
    end
end)
addBtn(tabPlayer,187,80,155,30,"Patlat (BOOM)",function()
    if selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart") then
        for i=1,5 do
            local exp = Instance.new("Explosion")
            exp.Position = selectedTarget.Character.HumanoidRootPart.Position+Vector3.new(math.random(-5,5),math.random(0,3),math.random(-5,5))
            exp.BlastRadius = 6
            exp.BlastPressure = 5e6
            exp.Parent = Workspace
        end
        local h=selectedTarget.Character:FindFirstChildOfClass("Humanoid")
        if h then h.Health=0 end
    end
end)
addBtn(tabPlayer,355,80,155,30,"Git (Teleport Ol)",function()
    if selectedTarget and selectedTarget.Character and LocalPlayer.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = selectedTarget.Character.HumanoidRootPart.CFrame + Vector3.new(0,4,0)
        end
    end
end)
addBtn(tabPlayer,19,120,155,30,"Yanına Çek",function()
    if selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart") then
        local myroot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myroot then
            selectedTarget.Character.HumanoidRootPart.CFrame = myroot.CFrame+Vector3.new(0,3,0)
        end
    end
end)

addLabel(tabFun,22,10,250,"Baktığın yöne araba fırlat (her basışta)")
addBtn(tabFun,22,32,190,30,"FIRLAT!",function()
    local cf = Camera.CFrame * CFrame.new(0,0,-8)
    local obj = nil
    pcall(function()
        obj = game:GetService("InsertService"):LoadAsset(states.carAssetId):GetChildren()[1]
    end)
    if not obj then
        obj = Instance.new("Part")
        obj.Size = Vector3.new(6,2,10)
        obj.Color = Color3.fromRGB(45,45,45)
        obj.Anchored = false
        obj.CanCollide = true
    end
    obj.Parent = Workspace
    obj.Position = cf.Position
    obj.Orientation = Camera.CFrame:ToOrientation()
    local v = Instance.new("BodyVelocity",obj)
    v.Velocity = Camera.CFrame.LookVector*200 + Vector3.new(0,18,0)
    v.MaxForce = Vector3.new(1,1,1)*1e6
    Debris:AddItem(obj,12)
end)

addBtn(tabFun,240,32,120,30,function() return "Spin ["..(states.funSpin and "AÇIK" or "KAPALI") end,function()
    states.funSpin = not states.funSpin
    if states.funSpin and not spinConn then
        spinConn = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(65),0)
            end
        end)
    elseif not states.funSpin and spinConn then
        spinConn:Disconnect() spinConn=nil
    end
end)

addBtn(tabOther,18,24,180,32,"Anti-AFK",function()
    LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new())
        wait(0.1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new())
    end)
end)
addBtn(tabOther,228,24,180,32,"RESET",function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end)
addBtn(tabOther,440,24,140,32,"FOV ?" ,function()
    Camera.FieldOfView = states.fov
end)

local function getClosestEnemyToCursor(fov)
    local closest, dist = nil, fov or states.fov
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer
            and p.Character
            and p.Character:FindFirstChild("Head")
            and p.Character:FindFirstChildWhichIsA("Humanoid")
            and p.Character:FindFirstChildWhichIsA("Humanoid").Health > 0
        then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
            local mag = (Vector2.new(pos.X,pos.Y)-Vector2.new(Mouse.X,Mouse.Y)).Magnitude
            if mag < dist and onScreen then
                closest = p
                dist = mag
            end
        end
    end
    return closest
end

if not _FOVCIRCLE then
    local circ = Drawing.new("Circle")
    circ.Color = Color3.fromRGB(20, 170, 255)
    circ.Thickness = 2
    circ.NumSides = 30
    circ.Filled = false
    circ.Transparency = 0.72
    circ.Visible = true
    _FOVCIRCLE = circ
    RunService.RenderStepped:Connect(function()
        circ.Radius = states.fov
        circ.Position = Vector2.new(Mouse.X, Mouse.Y+36)
        circ.Visible = MainFrame.Visible and states.aimbot
    end)
end

RunService.RenderStepped:Connect(function()
    if states.aimbot then
        local target = getClosestEnemyToCursor(states.fov)
        if target and target.Character then
            if states.aimbotType==1 then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            elseif states.aimbotType==2 then
                local hum = target.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.RootPart then 
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, hum.RootPart.Position)
                else 
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
                end
            else
                local points={}
                for _,v in pairs(target.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.Transparency<0.96 then table.insert(points,v) end
                end
                if #points>0 then
                    local p = points[math.random(1,#points)]
                    Camera.CFrame=CFrame.new(Camera.CFrame.Position,p.Position)
                end
            end
        end
    end
end)
local _oldNC; _oldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local ncm = typeof(getnamecallmethod)=="function" and getnamecallmethod() or ""
    if states.silentaim and ncm=="FindPartOnRayWithIgnoreList" then
        local target = getClosestEnemyToCursor(states.fov)
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local args={...}
            args[1].Origin = Camera.CFrame.Position
            args[1].Direction = (target.Character.Head.Position - Camera.CFrame.Position).Unit*900
            return _oldNC(self, unpack(args))
        end
    end
    return _oldNC(self,...)
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.F and not gp then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
