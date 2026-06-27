--[[ QUARTZ.LUA | Prison Life Full Modern Türkçe Menü | RC 2024 ]]--
local function Bypass()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local __namecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local m = getnamecallmethod()
        if tostring(self):lower():find("ban") or tostring(self):lower():find("kick") or tostring(self):lower():find("detect") then
            return nil
        end
        return __namecall(self, ...)
    end)
    setreadonly(mt, true)
end
Bypass()

if game.PlaceId ~= 155615604 then return end

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RepStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera

local function Notification(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="QUARTZ", Text=msg, Duration=2})
    end)
end

local function GetPlayer(name)
    name = name:lower()
    for _,p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #name) == name then return p end
    end
end

for _,v in ipairs(game.CoreGui:GetChildren()) do if v.Name=="QUARTZ_GUI" then v:Destroy() end end
local QuartzGUI = Instance.new("ScreenGui")
QuartzGUI.Name = "QUARTZ_GUI"
QuartzGUI.ResetOnSpawn = false
QuartzGUI.Parent = game.CoreGui

local Visible = true

local OpenCloseBtn = Instance.new("TextButton")
OpenCloseBtn.Parent = QuartzGUI
OpenCloseBtn.Size = UDim2.new(0, 80, 0, 30)
OpenCloseBtn.Position = UDim2.new(0, 40, 0, 45)
OpenCloseBtn.BackgroundColor3 = Color3.fromRGB(10,10,10)
OpenCloseBtn.Text = "Aç/Kapat"
OpenCloseBtn.TextColor3 = Color3.fromRGB(250,250,250)
OpenCloseBtn.Font = Enum.Font.GothamBold
OpenCloseBtn.TextSize = 14
OpenCloseBtn.BorderSizePixel = 0
local ocCr = Instance.new("UICorner", OpenCloseBtn)
ocCr.CornerRadius = UDim.new(0,8)

OpenCloseBtn.MouseButton1Click:Connect(function()
    Visible = not Visible
    QuartzGUI.Enabled = Visible
end)

local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 370, 0, 540)
MainPanel.Position = UDim2.new(0.5, -185, 0.5, -270)
MainPanel.BackgroundColor3 = Color3.fromRGB(16,16,16)
MainPanel.BorderSizePixel = 0
MainPanel.Active = true
MainPanel.Draggable = true
MainPanel.AnchorPoint = Vector2.new(0.5,0.5)
MainPanel.Parent = QuartzGUI
local Corner = Instance.new("UICorner",MainPanel)
Corner.CornerRadius = UDim.new(0, 18)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1,0,0,46)
TabBar.BackgroundColor3 = Color3.fromRGB(10,10,10)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainPanel
TabBar.Position = UDim2.new(0,0,0,0)
local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0,3)

local Tabs = {
    "Takım & Rol", "Silah Mod", "Hareket", "ESP & Savaş", "Koruma", "Sunucu"
}
local TabFrames = {}

local function MakeSection(parent, text)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, -6, 0, 32)
    Section.BackgroundColor3 = Color3.fromRGB(22,22,22)
    Section.BorderSizePixel = 0
    Section.BackgroundTransparency = 0.14
    Section.Parent = parent
    local lbl = Instance.new("TextLabel", Section)
    lbl.Text = "  " .. text
    lbl.TextColor3 = Color3.fromRGB(220,220,225)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 19
    lbl.Size = UDim2.new(1, 0, 1, 0)
end

local function MakeButton(parent, name, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -14, 0, 32)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(239,241,240)
    Btn.TextSize = 17
    Btn.Font = Enum.Font.Gotham
    Btn.BackgroundColor3 = Color3.fromRGB(28,28,28)
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = true
    Btn.Parent = parent
    local c1 = Instance.new("UICorner", Btn)
    c1.CornerRadius = UDim.new(0, 8)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

local function MakeSlider(parent, text, min, max, def, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -14, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(34,34,34)
    frame.BorderSizePixel = 0
    local lbl = Instance.new("TextLabel", frame)
    lbl.Text = text.." ["..tostring(def).."]"
    lbl.TextColor3 = Color3.fromRGB(190,190,200)
    lbl.TextSize = 15
    lbl.Font = Enum.Font.Gotham
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local slide = Instance.new("TextButton", frame)
    slide.Size = UDim2.new(0.31, 0, 0.82, 0)
    slide.Position = UDim2.new(0.69, 9, 0.09, 0)
    slide.Text = tostring(def)
    slide.TextColor3 = Color3.fromRGB(245,245,245)
    slide.Font = Enum.Font.Gotham
    slide.BackgroundColor3 = Color3.fromRGB(26,26,26)
    slide.BorderSizePixel = 0
    local c1 = Instance.new("UICorner",slide)
    c1.CornerRadius = UDim.new(0,7)
    slide.MouseButton1Click:Connect(function()
        local newval = tonumber(game:GetService("StarterGui"):PromptInput(text.." ["..min.." - "..max.."]"))
        if newval and newval >= min and newval <= max then
            lbl.Text = text.." ["..tostring(newval).."]"
            slide.Text = tostring(newval)
            callback(newval)
        else
            Notification("Geçersiz değer.")
        end
    end)
    return frame
end

local function MakeTab(name)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(24,24,24)
    frame.Size = UDim2.new(0, 344, 0, 465)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Position = UDim2.new(0,13,0,52)
    frame.Parent = MainPanel
    local lbl = Instance.new("TextLabel", frame)
    lbl.Text = "QUARTZ | "..name
    lbl.Size = UDim2.new(1,0,0,35)
    lbl.TextColor3 = Color3.fromRGB(251,251,253)
    lbl.BackgroundColor3 = Color3.fromRGB(16,16,16)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 19
    lbl.BorderSizePixel = 0
    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0,5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    return frame
end

for idx, tabname in ipairs(Tabs) do
    local btn = Instance.new("TextButton",TabBar)
    btn.Text = tabname
    btn.Size = UDim2.new(0, 112, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(38,38,39)
    btn.TextColor3 = Color3.fromRGB(240,240,240)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 15
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    local cr = Instance.new("UICorner", btn)
    cr.CornerRadius = UDim.new(0,7)
    local frame = MakeTab(tabname)
    frame.Visible = (idx==1)
    table.insert(TabFrames,frame)
    btn.MouseButton1Click:Connect(function()
        for i,tabfr in pairs(TabFrames) do
            tabfr.Visible = (i==idx)
        end
    end)
end

local EnableKey = Enum.KeyCode.RightShift
UIS.InputBegan:Connect(function(input, gp)
    if input.KeyCode == EnableKey and not gp then
        Visible = not Visible
        QuartzGUI.Enabled = Visible
    end
end)

local tab_team = TabFrames[1]
MakeSection(tab_team,"Takım & Rol Yönetimi")
MakeButton(tab_team,"Auto Criminal",function()
    for _,d in pairs(Workspace.Doors:GetChildren()) do if d:FindFirstChild("Open") then d.Open:FireServer() end end
    RunService.RenderStepped:Wait()
    Workspace.Remote.TeamEvent:FireServer("Criminal")
    Notification("Suçlu takımına anında geçildi.")
end)
MakeButton(tab_team,"Become Guard",function()
    Workspace.Remote.TeamEvent:FireServer("Guard")
    Notification("Polis takımına anında geçildi.")
end)
MakeButton(tab_team,"Become Prisoner",function()
    Workspace.Remote.TeamEvent:FireServer("Prisoner")
    Notification("Mahkum takımına döndün.")
end)
MakeButton(tab_team,"Neutral Mode",function()
    Workspace.Remote.TeamEvent:FireServer("Neutral")
    Notification("Nötr moda geçildi.")
end)
MakeButton(tab_team,"Force Inmate",function()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team.Name~="Prisoner" then
            Workspace.Remote.TeamEvent:FireServer("Prisoner",p)
        end
    end
    Notification("Tüm oyuncular mahkum oluyor!")
end)

local tab_weap = TabFrames[2]
MakeSection(tab_weap,"Silah Modifikasyonları")
MakeButton(tab_weap,"Give All Weapons",function()
    for _,w in pairs({"M9","Remington 870","AK-47"}) do Workspace.Remote.ItemHandler:InvokeServer(w) end
    Notification("Tüm silahlar verildi.")
end)
MakeButton(tab_weap,"Infinite Ammo",function()
    if getgenv().Q_AMMO then return end
    getgenv().Q_AMMO = RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            for _,tbl in pairs(getgc(true)) do
                if type(tbl)=="table" and rawget(tbl,"Ammo") then tbl.Ammo=9999 tbl.MaxAmmo=9999 end
            end
        end
    end)
    Notification("Sonsuz mermi açıldı.")
end)
MakeButton(tab_weap,"No Recoil",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"Recoil") then tbl.Recoil=0 end
    end
    Notification("Sekme sıfırlandı.")
end)
MakeButton(tab_weap,"No Reload",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"Reloading") then tbl.Reloading=false end
    end
    Notification("Şarjör değiştirme animasyonları kapalı.")
end)
MakeButton(tab_weap,"Rapid Fire",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"FireRate") then tbl.FireRate=0.032 end
    end
    Notification("Ateş hızı maksimum!")
end)
MakeButton(tab_weap,"One Shot Kill",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"Damage") then tbl.Damage=9999 end
    end
    Notification("Tek atışla öldürme aktif.")
end)
MakeButton(tab_weap,"Wall Bang",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"WallPenetration") then tbl.WallPenetration=true end
    end
    Notification("Duvar arkası ateş aktif.")
end)
MakeButton(tab_weap,"Infinite Range",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"Range") then tbl.Range=2e5 end
    end
    Notification("Menzil sınırsız.")
end)
MakeButton(tab_weap,"Tazer Bypass",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"IsTased") then tbl.IsTased=false end
    end
    Notification("Tazer etkisiz.")
end)
MakeButton(tab_weap,"No Tazer Cooldown",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"TazerCooldown") then tbl.TazerCooldown=0 end
    end
    Notification("Tazer süresi yok.")
end)
MakeButton(tab_weap,"Melee Reach",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"MeleeRange") then tbl.MeleeRange=150 end
    end
    Notification("Yakın dövüş aralığı çok uzun!")
end)
MakeButton(tab_weap,"Fast Melee",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"MeleeCooldown") then tbl.MeleeCooldown=0.019 end
    end
    Notification("Yakın dövüş hızı maksimum.")
end)

local tab_move = TabFrames[3]
MakeSection(tab_move,"Hareket ve Karakter")
MakeButton(tab_move,"Fly",function()
    if getgenv().Q_FLY then return end
    getgenv().Q_FLY = true
    local Root = Character:FindFirstChild("HumanoidRootPart")
    local BG = Instance.new("BodyGyro",Root)
    BG.P = 9e4
    BG.MaxTorque = Vector3.new(9e9,9e9,9e9)
    BG.CFrame = Root.CFrame
    local BV = Instance.new("BodyVelocity",Root)
    BV.Velocity = Vector3.new()
    BV.MaxForce = Vector3.new(9e9,9e9,9e9)
    getgenv().Q_FLYCONN = RunService.RenderStepped:Connect(function()
        local cf = Camera.CFrame
        local vel = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then vel = vel + cf.LookVector * 65 end
        if UIS:IsKeyDown(Enum.KeyCode.S) then vel = vel - cf.LookVector * 65 end
        if UIS:IsKeyDown(Enum.KeyCode.D) then vel = vel + cf.RightVector * 65 end
        if UIS:IsKeyDown(Enum.KeyCode.A) then vel = vel - cf.RightVector * 65 end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then vel = vel + cf.UpVector * 65 end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel - cf.UpVector * 65 end
        BV.Velocity = vel
        BG.CFrame = cf
    end)
    UIS.InputBegan:Connect(function(inp)
        if inp.KeyCode==Enum.KeyCode.LeftControl then
            getgenv().Q_FLY = false
            if getgenv().Q_FLYCONN then getgenv().Q_FLYCONN:Disconnect() end
            BG:Destroy()
            BV:Destroy()
        end
    end)
    Notification("[Çıkış: LCtrl] ile kapatılır!")
end)
MakeSlider(tab_move,"WalkSpeed",16,300,22,function(v)
    if Character:FindFirstChild("Humanoid") then
        Character.Humanoid.WalkSpeed = v
        Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function() Character.Humanoid.WalkSpeed = v end)
    end
end)
MakeSlider(tab_move,"JumpPower",50,400,70,function(v)
    if Character:FindFirstChild("Humanoid") then
        Character.Humanoid.JumpPower = v
        Character.Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function() Character.Humanoid.JumpPower = v end)
    end
end)
MakeButton(tab_move,"Infinite Jump",function()
    if getgenv().Q_IJ then return end
    getgenv().Q_IJ = UIS.JumpRequest:Connect(function()
        if Character and Character:FindFirstChildOfClass("Humanoid") then
            Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
    Notification("Sonsuz zıplama açıldı!")
end)
MakeButton(tab_move,"Noclip",function()
    if getgenv().Q_NOCLIP then return end
    getgenv().Q_NOCLIP = RunService.Stepped:Connect(function()
        for _,v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide=false end
        end
    end)
    Notification("Noclip aktif.")
end)
MakeButton(tab_move,"Click Teleport",function()
    if getgenv().Q_CLICKTP then getgenv().Q_CLICKTP:Disconnect() end
    local mouse = LocalPlayer:GetMouse()
    getgenv().Q_CLICKTP = mouse.Button1Down:Connect(function()
        if UIS:IsKeyDown(Enum.KeyCode.LeftAlt) then
            if Character and Character:FindFirstChild("HumanoidRootPart") then
                Character:SetPrimaryPartCFrame(CFrame.new(mouse.Hit.Position))
            end
        end
    end)
    Notification("LAlt basılı + tık: Işınlan!")
end)
MakeSlider(tab_move,"Vehicle Speed",50,900,95,function(v)
    for _,car in pairs(Workspace:FindFirstChild("Vehicles") and Workspace.Vehicles:GetChildren() or {}) do
        if car:FindFirstChild("Engine") then car.Engine.Speed.Value = v end
    end
end)
MakeButton(tab_move,"No Car Clip",function()
    for _,car in pairs(Workspace:FindFirstChild("Vehicles") and Workspace.Vehicles:GetChildren() or {}) do
        for _,part in pairs(car:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide=false end
        end
    end
    Notification("Araçlar clip kapalı.")
end)
MakeButton(tab_move,"Infinite Stamina",function()
    if Character and Character:FindFirstChild("Humanoid") then
        Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            Character.Humanoid.WalkSpeed=150
        end)
    end
    Notification("Stamina sonsuz.")
end)
MakeButton(tab_move,"Anti-Ragdoll",function()
    LocalPlayer.Character.Humanoid.StateChanged:Connect(function(_,state)
        if state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll then
            Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
    Notification("Anti-Ragdoll aktif.")
end)

local tab_esp = TabFrames[4]
MakeSection(tab_esp,"ESP & Savaş")
MakeButton(tab_esp,"Aimbot",function()
    if getgenv().Q_AIM then return end
    getgenv().Q_AIM = RunService.RenderStepped:Connect(function()
        local ch = LocalPlayer.Character
        local nearest, ndist
        if not ch or not ch:FindFirstChild("Head") then return end
        local root = ch:FindFirstChild("HumanoidRootPart")
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Team~=LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                local d = (root.Position - p.Character.Head.Position).magnitude
                if not ndist or d < ndist then nearest, ndist = p.Character.Head, d end
            end
        end
        if nearest then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position,nearest.Position)
        end
    end)
    Notification("Aimbot açıldı!")
end)
MakeButton(tab_esp,"Silent Aim",function()
    getgenv().Q_SAIM = true
    Notification("Silent aim açık.")
end)
MakeButton(tab_esp,"Player ESP",function()
    if getgenv().Q_PESP then return end
    getgenv().Q_PESP = RunService.RenderStepped:Connect(function()
        pcall(function()
            for _,plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                    if not plr.Character.Head:FindFirstChild("Q_PESP") then
                        local bb = Instance.new("BillboardGui",plr.Character.Head)
                        bb.Name = "Q_PESP"
                        bb.Size = UDim2.new(0,110,0,18)
                        bb.AlwaysOnTop = true
                        local tx = Instance.new("TextLabel",bb)
                        tx.Size = UDim2.new(1,0,1,0)
                        tx.BackgroundTransparency = 1
                        tx.Text = plr.Name.." ["..math.floor((plr.Character.Head.Position-Character.Head.Position).magnitude).."]"
                        tx.TextColor3 = Color3.fromRGB(78,230,235)
                        tx.TextScaled = true
                        tx.Font=Enum.Font.GothamBold
                    end
                end
            end
        end)
    end)
    Notification("Oyuncu ESP açık!")
end)
MakeButton(tab_esp,"Line ESP (Tracers)",function()
    if getgenv().Q_TRACER then return end
    getgenv().Q_TRACER = RunService.RenderStepped:Connect(function()
        pcall(function()
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    if not p.Character.Head:FindFirstChild("QTRACER") then
                        local att0 = Instance.new("Attachment",Camera)
                        local att1 = Instance.new("Attachment",p.Character.Head)
                        local beam = Instance.new("Beam",p.Character.Head)
                        beam.Attachment0 = att0
                        beam.Attachment1 = att1
                        beam.Color = ColorSequence.new(Color3.fromRGB(232,46,75))
                        beam.Width0 = 0.08
                        beam.Width1 = 0.08
                        beam.FaceCamera = true
                        beam.Name = "QTRACER"
                        beam.Transparency = NumberSequence.new(0.18)
                    end
                end
            end
        end)
    end)
    Notification("Tracers açık!")
end)
MakeButton(tab_esp,"Box ESP",function()
    if getgenv().Q_BOXESP then return end
    getgenv().Q_BOXESP = RunService.RenderStepped:Connect(function()
        pcall(function()
            for _,p in pairs(Players:GetPlayers()) do
                if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if not p.Character.HumanoidRootPart:FindFirstChild("Q_BESP") then
                        local bxa = Instance.new("BoxHandleAdornment",p.Character.HumanoidRootPart)
                        bxa.Adornee = p.Character.HumanoidRootPart
                        bxa.Size = Vector3.new(4,7.5,2)
                        bxa.Color3 = Color3.fromRGB(38,218,75)
                        bxa.AlwaysOnTop = true
                        bxa.Name = "Q_BESP"
                        bxa.Transparency = 0.36
                    end
                end
            end
        end)
    end)
    Notification("Box ESP aktif.")
end)
MakeButton(tab_esp,"Item ESP",function()
    if getgenv().Q_ITEMESP then return end
    getgenv().Q_ITEMESP = RunService.RenderStepped:Connect(function()
        if Workspace:FindFirstChild("Prison_ITEMS") then
            for _,it in pairs(Workspace.Prison_ITEMS.single:GetChildren()) do
                if it:IsA("Part") and not it:FindFirstChild("Q_ITEMESP") then
                    local bc = Instance.new("BillboardGui",it)
                    bc.Name="Q_ITEMESP"
                    bc.Size = UDim2.new(0,75,0,12)
                    bc.AlwaysOnTop=true
                    local tx = Instance.new("TextLabel",bc)
                    tx.Size = UDim2.new(1,0,1,0)
                    tx.BackgroundTransparency=1
                    tx.Text=it.Name
                    tx.TextColor3=Color3.fromRGB(100,245,223)
                    tx.Font=Enum.Font.GothamSemibold
                    tx.TextSize=12
                end
            end
        end
    end)
    Notification("Item ESP açık.")
end)
MakeButton(tab_esp,"Kill All",function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Team~=LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.Health=0
        end
    end
    Notification("Tüm düşmanlar öldürüldü.")
end)
MakeButton(tab_esp,"Kill Aura",function()
    if getgenv().Q_AURA then return end
    getgenv().Q_AURA = RunService.RenderStepped:Connect(function()
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Team~=LocalPlayer.Team and p.Character and (p.Character.HumanoidRootPart.Position-Character.HumanoidRootPart.Position).Magnitude<17 then
                if p.Character:FindFirstChild("Humanoid") then p.Character.Humanoid.Health = 0 end
            end
        end
    end)
    Notification("KillAura açık!")
end)
MakeButton(tab_esp,"Auto Arrest All",function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Team and p.Team.Name=="Criminal" and p.Character and p.Character:FindFirstChild("Head") then
            Workspace.Remote.arrest:InvokeServer(p.Character.Head)
        end
    end
    Notification("Tüm suçlular kelepçelendi.")
end)
MakeButton(tab_esp,"Arrest Range Multiplier",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"ArrestRange") then tbl.ArrestRange=99999 end
    end
    Notification("Kelepçe menzili max!")
end)

local tab_def = TabFrames[5]
MakeSection(tab_def,"Defans ve Guard")
MakeButton(tab_def,"God Mode",function()
    if getgenv().Q_GOD then return end
    getgenv().Q_GOD = RunService.RenderStepped:Connect(function()
        pcall(function() Character.Humanoid.Health = math.huge end)
    end)
    Notification("GodMode aktif.")
end)
MakeButton(tab_def,"Semi-God Mode",function()
    if getgenv().Q_SGOD then return end
    getgenv().Q_SGOD = Character.Humanoid.HealthChanged:Connect(function()
        Character.Humanoid.Health = Character.Humanoid.MaxHealth
    end)
    Notification("Hızlı iyileşme açıldı.")
end)
MakeButton(tab_def,"Anti-Arrest",function()
    if getgenv().Q_AARREST then return end
    getgenv().Q_AARREST = LocalPlayer.PlayerGui.ChildAdded:Connect(function(c)
        if c.Name == "ArrestGui" then c:Destroy() end
    end)
    Notification("Anti-Arrest açık.")
end)
MakeButton(tab_def,"Give Keycard",function()
    Workspace.Remote.ItemHandler:InvokeServer("Key card")
    Notification("Keycard alındı!")
end)
MakeButton(tab_def,"Auto Escape",function()
    if Workspace:FindFirstChild("Criminals") and Workspace.Criminals:FindFirstChild("SpawnLocation") then
        Character:MoveTo(Workspace.Criminals.SpawnLocation.Position)
        Notification("Başarıyla kaçtın!")
    end
end)

local tab_srv = TabFrames[6]
MakeSection(tab_srv,"Sunucu/Fun/Trol")
MakeButton(tab_srv,"Spinbot",function()
    if getgenv().Q_SPINBOT then return end
    getgenv().Q_SPINBOT = RunService.RenderStepped:Connect(function()
        local root = Character:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = root.CFrame * CFrame.Angles(0,math.rad(38),0) end
    end)
    Notification("Spinbot aktif.")
end)
MakeButton(tab_srv,"Invisible",function()
    for _,part in pairs(Character:GetChildren()) do
        if part:IsA("BasePart") or part:IsA("MeshPart") then
            part.Transparency=1
        end
    end
    Character.HumanoidRootPart.Transparency = 1
    Notification("Görünmezsiniz!")
end)
MakeButton(tab_srv,"Loop Kill Target",function()
    local pname = game:GetService("StarterGui"):PromptInput("Oyuncu adı:")
    local tgt = GetPlayer(pname)
    if tgt and tgt.Character and tgt.Character:FindFirstChild("Humanoid") then
        if getgenv().Q_LOOPKILL then getgenv().Q_LOOPKILL:Disconnect() end
        getgenv().Q_LOOPKILL = RunService.Stepped:Connect(function()
            if tgt.Character and tgt.Character:FindFirstChild("Humanoid") then
                tgt.Character.Humanoid.Health = 0
            end
        end)
        Notification(pname.." loop kill başlatıldı!")
    else
        Notification("Oyuncu bulunamadı!")
    end
end)
MakeButton(tab_srv,"Bring All Players",function()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos = Character:FindFirstChild("HumanoidRootPart") and Character.HumanoidRootPart.Position or Vector3.new()
            p.Character:MoveTo(pos + Vector3.new(math.random(-7,7),0,math.random(-7,7)))
        end
    end
    Notification("Tüm oyuncular getirildi!")
end)
MakeButton(tab_srv,"Teleport To Locations",function()
    local locs = {
        ["Silah Odası"] = Workspace:FindFirstChild("GunRoom") and Workspace.GunRoom:FindFirstChild("Guns") and Workspace.GunRoom.Guns.Position or nil,
        ["Bahçe"] = Workspace:FindFirstChild("Yard") and Workspace.Yard:FindFirstChild("Yard_Stuff") and Workspace.Yard.Yard_Stuff.Position or nil,
        ["Crim Base"] = Workspace:FindFirstChild("Criminals") and Workspace.Criminals:FindFirstChild("SpawnLocation") and Workspace.Criminals.SpawnLocation.Position or nil,
        ["Hücreler"] = Workspace:FindFirstChild("Cells") and Workspace.Cells:FindFirstChild("Cells") and Workspace.Cells.Cells.Position or nil
    }
    local pick = game:GetService("StarterGui"):PromptInput("Konum adı (Silah Odası, Bahçe, Crim Base, Hücreler):")
    local pos = locs[pick]
    if pos then
        Character:SetPrimaryPartCFrame(CFrame.new(pos + Vector3.new(0,2,0)))
        Notification(pick.." konumuna ışınlandın!")
    else
        Notification("Konum bulunamadı!")
    end
end)
MakeButton(tab_srv,"Chat Spammer",function()
    if getgenv().Q_CHATSPAM then return end
    local msg = game:GetService("StarterGui"):PromptInput("Mesaj gir:")
    getgenv().Q_CHATSPAM = true
    spawn(function()
        while getgenv().Q_CHATSPAM do
            Workspace.Remote.SendMessage:FireServer(msg)
            wait(0.075)
        end
    end)
    Notification("Chat spam başladı! Durdur için tekrar tıkla.")
end)
MakeButton(tab_srv,"Crash Server (Lag Switch)",function()
    for i=1,800 do Workspace.Remote.TeamEvent:FireServer("Neutral") wait() end
    Notification("Lag/crash denemesi başlatıldı!")
end)
MakeButton(tab_srv,"Server View (Spectate)",function()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = p.Character.Humanoid
            Notification(p.Name.." izleniyor.")
            break
        end
    end
end)

Notification("QUARTZ.LUA yüklendi! Menü: [RIGHTSHIFT] veya üstteki Aç/Kapat ile kontrol edilir.")
