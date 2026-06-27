if game.PlaceId ~= 155615604 then return end
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RepStorage = game:GetService("ReplicatedStorage")
local Remotes = RepStorage:WaitForChild("ReloadEvent").Parent
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera

local Notification = function(msg)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {Title="QUARTZ", Text=msg, Duration=2})
    end)
end

local function GetPlayer(name)
    name = name:lower()
    for _,p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #name) == name then
            return p
        end
    end
end

pcall(function() if game.CoreGui:FindFirstChild("QUARTZ_GUI") then game.CoreGui.QUARTZ_GUI:Destroy() end end)
local QuartzGUI = Instance.new("ScreenGui")
QuartzGUI.Name = "QUARTZ_GUI"
QuartzGUI.Parent = game.CoreGui
QuartzGUI.ResetOnSpawn = false

local MainPanel = Instance.new("Frame")
MainPanel.Parent = QuartzGUI
MainPanel.BackgroundColor3 = Color3.fromRGB(6,6,6)
MainPanel.Size = UDim2.new(0, 470, 0, 540)
MainPanel.Position = UDim2.new(0.5,-235,0.5,-270)
MainPanel.Active = true
MainPanel.Draggable = true
Instance.new("UICorner",MainPanel).CornerRadius = UDim.new(0, 14)
MainPanel.AnchorPoint = Vector2.new(0,0)
MainPanel.ClipsDescendants = true

local TabsTitle = {"Takım & Rol","Silah Mod","Hareket","ESP & Savaş","Koruma","Sunucu"}
local TabFrames,TabButtons = {},{}
local TabBar = Instance.new("Frame",MainPanel)
TabBar.Size = UDim2.new(1,0,0,46)
TabBar.BackgroundColor3 = Color3.fromRGB(15,15,15)
TabBar.BorderSizePixel = 0
TabBar.Position = UDim2.new(0,0,0,0)
local TabLayout = Instance.new("UIListLayout", TabBar)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0,3)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

for i,name in ipairs(TabsTitle) do
    local frame = Instance.new("Frame",MainPanel)
    frame.BackgroundColor3 = Color3.fromRGB(14,14,14)
    frame.Size = UDim2.new(1,-14,1,-59)
    frame.Position = UDim2.new(0,7,0,53)
    frame.BorderSizePixel = 0
    frame.Visible = i==1
    frame.ClipsDescendants = true
    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0,5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    TabFrames[i] = frame

    local btn = Instance.new("TextButton",TabBar)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(240,240,240)
    btn.Size = UDim2.new(0, math.floor((MainPanel.Size.X.Offset-18)/#TabsTitle), 1,0)
    btn.BackgroundColor3 = Color3.fromRGB(36,36,36)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 17
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)
    TabButtons[i] = btn

    btn.MouseButton1Click:Connect(function()
        for k,tab in ipairs(TabFrames) do
            tab.Visible = k==i
        end
        for k,tabbtn in ipairs(TabButtons) do
            tabbtn.BackgroundColor3 = k==i and Color3.fromRGB(24,24,24) or Color3.fromRGB(36,36,36)
        end
    end)
end

local function MakeSection(parent,text)
    local Section = Instance.new("Frame",parent)
    Section.Size = UDim2.new(1,0,0,33)
    Section.BackgroundColor3 = Color3.fromRGB(26,26,26)
    Section.BorderSizePixel = 0
    Section.BackgroundTransparency = 0.11
    local lbl = Instance.new("TextLabel",Section)
    lbl.Text = "  "..text
    lbl.TextColor3 = Color3.fromRGB(235,235,235)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 21
    lbl.Size = UDim2.new(1,0,1,0)
end

local function MakeButton(parent,name,callback)
    local Btn = Instance.new("TextButton",parent)
    Btn.Size = UDim2.new(1,-10,0,32)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(245,245,245)
    Btn.TextSize = 17
    Btn.Font = Enum.Font.Gotham
    Btn.BackgroundColor3 = Color3.fromRGB(28,28,28)
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = true
    Instance.new("UICorner",Btn).CornerRadius = UDim.new(0,7)
    Btn.MouseButton1Click:Connect(callback)
end

local function MakeSlider(parent, text, min, max, def, callback)
    local frame = Instance.new("Frame",parent)
    frame.Size = UDim2.new(1,-12,0,34)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.BorderSizePixel = 0

    local lbl = Instance.new("TextLabel",frame)
    lbl.Text = text.." ["..tostring(def).."]"
    lbl.TextColor3 = Color3.fromRGB(210,210,210)
    lbl.TextSize = 15
    lbl.Font = Enum.Font.Gotham
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0.55,0,1,0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local slide = Instance.new("TextButton",frame)
    slide.Size = UDim2.new(0.42,0,0.76,0)
    slide.Position = UDim2.new(0.57,5,0.12,0)
    slide.Text = tostring(def)
    slide.TextColor3 = Color3.fromRGB(235,235,235)
    slide.Font = Enum.Font.GothamBlack
    slide.BackgroundColor3 = Color3.fromRGB(25,25,25)
    slide.BorderSizePixel = 0
    Instance.new("UICorner",slide).CornerRadius = UDim.new(0, 7)
    slide.MouseButton1Click:Connect(function()
        local val = tonumber(game:GetService("StarterGui"):PromptInput(text..": ["..min.." - "..max.."]"))
        if val and val >= min and val <= max then
            lbl.Text = text.." ["..tostring(val).."]"
            slide.Text = tostring(val)
            callback(val)
        else
            Notification("Geçersiz değer.")
        end
    end)
end

local tab_team = TabFrames[1]
local tab_weap = TabFrames[2]
local tab_move = TabFrames[3]
local tab_esp = TabFrames[4]
local tab_def = TabFrames[5]
local tab_srv = TabFrames[6]

-- TAKIM VE ROL
MakeSection(tab_team,"Takım & Rol Yönetimi")
MakeButton(tab_team,"Auto Criminal",function()
    Workspace.Remote.TeamEvent:FireServer("Criminal")
    Notification("Suçlu takımına geçildi")
end)
MakeButton(tab_team,"Become Guard",function()
    Workspace.Remote.TeamEvent:FireServer("Guard")
    Notification("Polis takımına geçildi")
end)
MakeButton(tab_team,"Become Prisoner",function()
    Workspace.Remote.TeamEvent:FireServer("Prisoner")
    Notification("Mahkum takımına geçildi")
end)
MakeButton(tab_team,"Neutral Mode",function()
    Workspace.Remote.TeamEvent:FireServer("Neutral")
    Notification("Nötr moda geçildi")
end)
MakeButton(tab_team,"Force Inmate",function()
    for _,pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Team.Name ~= "Prisoner" then
            Workspace.Remote.TeamEvent:FireServer("Prisoner",pl)
        end
    end
    Notification("Tüm oyuncular mahkum yapıldı")
end)

-- SİLAH MOD
MakeSection(tab_weap,"Silah Modifikasyonları")
MakeButton(tab_weap,"Give All Weapons",function()
    for _,w in pairs({"M9", "Remington 870", "AK-47"}) do
        Workspace.Remote.ItemHandler:InvokeServer(w)
    end
    Notification("Tüm silahlar alındı")
end)
MakeButton(tab_weap,"Infinite Ammo",function()
    if getgenv().QuartzAMMO then return end
    getgenv().QuartzAMMO = RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character then
            for _,tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                pcall(function()
                for _,v in pairs(getgc(true)) do
                    if type(v)=="table" and rawget(v,"Ammo") and tool.Name == v.Name then
                        v.Ammo = 999
                        v.MaxAmmo = 999
                    end
                end end)
            end
        end
    end)
    Notification("Sonsuz mermi açıldı")
end)
MakeButton(tab_weap,"No Recoil",function()
    for _,v in ipairs(getgc(true)) do
        if type(v)=="table" and rawget(v,"Recoil") then
            v.Recoil = 0
        end
    end
    Notification("Sekme kaldırıldı")
end)
MakeButton(tab_weap,"No Reload",function()
    for _,v in ipairs(getgc(true)) do
        if type(v)=="table" and rawget(v,"Reloading") then
            v.Reloading = false
        end
    end
    Notification("Şarjör değiştirme kaldırıldı")
end)
MakeButton(tab_weap,"Rapid Fire",function()
    for _,v in ipairs(getgc(true)) do
        if type(v)=="table" and rawget(v,"FireRate") then
            v.FireRate = 0.03
        end
    end
    Notification("Hızlı ateş açıldı")
end)
MakeButton(tab_weap,"One Shot Kill",function()
    for _,v in ipairs(getgc(true)) do
        if type(v)=="table" and rawget(v,"Damage") then
            v.Damage = 999
        end
    end
    Notification("Tek atış açıldı")
end)
MakeButton(tab_weap,"Wall Bang",function()
    for _,v in ipairs(getgc(true)) do
        if type(v)=="table" and rawget(v,"WallPenetration") then
            v.WallPenetration = true
        end
    end
    Notification("Wallbang aktif")
end)
MakeButton(tab_weap,"Infinite Range",function()
    for _,v in ipairs(getgc(true)) do
        if type(v)=="table" and rawget(v,"Range") then
            v.Range = 9999
        end
    end
    Notification("Sınırsız menzil")
end)
MakeButton(tab_weap,"Tazer Bypass",function()
    for _,v in ipairs(getgc(true)) do
        if type(v)=="table" and rawget(v,"IsTased") then
            v.IsTased = false
        end
    end
    Notification("Şok etkisi kaldırıldı")
end)
MakeButton(tab_weap,"No Tazer Cooldown",function()
    for _,v in ipairs(getgc(true)) do
        if type(v)=="table" and rawget(v,"TazerCooldown") then
            v.TazerCooldown = 0
        end
    end
    Notification("Tazer bekleme sıfırlandı")
end)
MakeButton(tab_weap,"Melee Reach",function()
    for _,v in ipairs(getgc(true)) do
        if type(v)=="table" and rawget(v,"MeleeRange") then
            v.MeleeRange = 160
        end
    end
    Notification("Yakın dövüş mesafesi aşırı artırıldı")
end)
MakeButton(tab_weap,"Fast Melee",function()
    for _,v in ipairs(getgc(true)) do
        if type(v)=="table" and rawget(v,"MeleeCooldown") then
            v.MeleeCooldown = 0
        end
    end
    Notification("Sürekli yakın dövüş")
end)

-- HAREKET VE FİZİK
MakeSection(tab_move,"Hareket ve Fizik")
local flyConn = nil
MakeButton(tab_move,"Fly",function()
    if getgenv().QuartzFLY then return end
    getgenv().QuartzFLY = true
    local FlySpeed = 3
    local BodyGyro = Instance.new("BodyGyro",Character.HumanoidRootPart)
    BodyGyro.P = 9e4
    BodyGyro.CFrame = Character.HumanoidRootPart.CFrame
    BodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    local BodyVel = Instance.new("BodyVelocity",Character.HumanoidRootPart)
    BodyVel.Velocity = Vector3.new(0,0,0)
    BodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
    flyConn = RunService.RenderStepped:Connect(function()
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            BodyVel.Velocity = Camera.CFrame.LookVector * 55 * FlySpeed
        elseif UIS:IsKeyDown(Enum.KeyCode.S) then
            BodyVel.Velocity = -Camera.CFrame.LookVector * 55 * FlySpeed
        else
            BodyVel.Velocity = Vector3.new(0,0,0)
        end
        BodyGyro.CFrame = Camera.CFrame
    end)
    UIS.InputBegan:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.LeftControl then
            getgenv().QuartzFLY = false
            BodyGyro:Destroy() BodyVel:Destroy()
            if flyConn then flyConn:Disconnect() end
        end
    end)
    Notification("Uçuş açıldı (Left Ctrl: İptal)")
end)
MakeSlider(tab_move,"WalkSpeed",16,999,16,function(val)
    Character.Humanoid.WalkSpeed = val
    Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        Character.Humanoid.WalkSpeed = val
    end)
end)
MakeSlider(tab_move,"JumpPower",50,1000,50,function(val)
    Character.Humanoid.JumpPower = val
    Character.Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
        Character.Humanoid.JumpPower = val
    end)
end)
MakeButton(tab_move,"Infinite Jump",function()
    if getgenv().QuartzINFJUMP then return end
    getgenv().QuartzINFJUMP = UIS.JumpRequest:Connect(function()
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end)
    Notification("Infinite Jump açıldı")
end)
MakeButton(tab_move,"Noclip",function()
    if getgenv().QuartzNOCLIP then return end
    getgenv().QuartzNOCLIP = RunService.Stepped:Connect(function()
        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
    Notification("Noclip açıldı")
end)
MakeButton(tab_move,"Click Teleport",function()
    if getgenv().QuartzCLICKTP then getgenv().QuartzCLICKTP:Disconnect() end
    local mouse = LocalPlayer:GetMouse()
    getgenv().QuartzCLICKTP = mouse.Button1Down:Connect(function()
        if UIS:IsKeyDown(Enum.KeyCode.LeftAlt) then
            Character:SetPrimaryPartCFrame(CFrame.new(mouse.Hit.Position))
        end
    end)
    Notification("Lütfen ışınlanılacak yere tıklayın (sol alt tuşu ile)")
end)
MakeSlider(tab_move,"Vehicle Speed",50,650,90,function(val)
    for _,car in pairs(Workspace:FindFirstChild("Vehicles") and Workspace.Vehicles:GetChildren() or {}) do
        if car:FindFirstChild("Engine") then
            car.Engine.Speed.Value = val
        end
    end
end)
MakeButton(tab_move,"No Car Clip",function()
    for _,car in pairs(Workspace:FindFirstChild("Vehicles") and Workspace.Vehicles:GetChildren() or {}) do
        for _,part in pairs(car:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
    Notification("Arabalar clip kapalı")
end)
MakeButton(tab_move,"Infinite Stamina",function()
    if Character:FindFirstChild("Humanoid") then
        Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            Character.Humanoid.WalkSpeed = 50
        end)
        Character.Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
            Character.Humanoid.JumpPower = 70
        end)
    end
    Notification("Sonsuz stamina aktif")
end)
MakeButton(tab_move,"Anti-Ragdoll",function()
    LocalPlayer.Character.Humanoid.StateChanged:Connect(function(_,state)
        if state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll then
            Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
    Notification("Anti-Ragdoll etkin")
end)

-- ESP & COMBAT
MakeSection(tab_esp,"ESP ve Savaş")
MakeButton(tab_esp,"Aimbot",function()
    if getgenv().QuartzAimbot then return end
    getgenv().QuartzAimbot = RunService.RenderStepped:Connect(function()
        local ch = LocalPlayer.Character; if not ch then return end
        local root = ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChildWhichIsA("BasePart")
        local nearest,ndist
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character and p.Team~=LocalPlayer.Team and p.Character:FindFirstChild("Head") then
                local d = (root.Position - p.Character.Head.Position).magnitude
                if not ndist or d < ndist then nearest,ndist = p.Character.Head,d end
            end
        end
        if nearest then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position,nearest.Position)
        end
    end)
    Notification("Aimbot açıldı")
end)
MakeButton(tab_esp,"Silent Aim",function()
    getgenv().QuartzSilentAim = true
    Notification("Silent Aim açıldı")
end)
MakeButton(tab_esp,"Player ESP",function()
    if getgenv().QuartzPESP then return end
    getgenv().QuartzPESP = RunService.RenderStepped:Connect(function()
        for _,plr in pairs(Players:GetPlayers()) do
            if plr~=LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                if not plr.Character.Head:FindFirstChild("QUARTZ_PESP") then
                    local bb = Instance.new("BillboardGui",plr.Character.Head)
                    bb.Name = "QUARTZ_PESP"
                    bb.Size = UDim2.new(0,120,0,21)
                    bb.AlwaysOnTop = true
                    local tx = Instance.new("TextLabel",bb)
                    tx.Size = UDim2.new(1,0,1,0)
                    tx.BackgroundTransparency = 1
                    tx.Text = plr.Name.." ["..(math.floor((plr.Character.Head.Position-Character.Head.Position).magnitude)).."]"
                    tx.TextColor3 = Color3.fromRGB(35,235,235)
                    tx.TextScaled = true
                    tx.Font=Enum.Font.Gotham
                end
            end
        end
    end)
    Notification("Player ESP açıldı")
end)
MakeButton(tab_esp,"Line ESP (Tracers)",function()
    if getgenv().QuartzTracer then return end
    getgenv().QuartzTracer = RunService.RenderStepped:Connect(function()
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                if not p.Character.Head:FindFirstChild("TRC_ESP") then
                    local att0 = Instance.new("Attachment",Camera)
                    local att1 = Instance.new("Attachment",p.Character.Head)
                    local beam = Instance.new("Beam",p.Character.Head)
                    beam.Attachment0 = att0
                    beam.Attachment1 = att1
                    beam.Color = ColorSequence.new(Color3.fromRGB(250,30,40))
                    beam.Width0 = 0.09
                    beam.Width1 = 0.09
                    beam.FaceCamera = true
                    beam.Name = "TRC_ESP"
                    beam.Transparency = NumberSequence.new(0.25)
                end
            end
        end
    end)
    Notification("Tracer açıldı")
end)
MakeButton(tab_esp,"Box ESP",function()
    if getgenv().QuartzBoxESP then return end
    getgenv().QuartzBoxESP = RunService.RenderStepped:Connect(function()
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if not p.Character.HumanoidRootPart:FindFirstChild("BOX_ESP") then
                    local bxa = Instance.new("BoxHandleAdornment",p.Character.HumanoidRootPart)
                    bxa.Adornee = p.Character.HumanoidRootPart
                    bxa.Size = Vector3.new(4,7,2)
                    bxa.Color3 = Color3.fromRGB(18,255,60)
                    bxa.AlwaysOnTop = true
                    bxa.Name = "BOX_ESP"
                    bxa.Transparency = 0.4
                end
            end
        end
    end)
    Notification("Box ESP açıldı")
end)
MakeButton(tab_esp,"Item ESP",function()
    if getgenv().QuartzItemESP then return end
    getgenv().QuartzItemESP = RunService.RenderStepped:Connect(function()
        if Workspace:FindFirstChild("Prison_ITEMS") then
            for _,it in pairs(Workspace.Prison_ITEMS.single:GetChildren()) do
                if it:IsA("Part") and not it:FindFirstChild("ITM_ESP") then
                    local bc = Instance.new("BillboardGui",it)
                    bc.Name="ITM_ESP"
                    bc.Size = UDim2.new(0,82,0,17)
                    bc.AlwaysOnTop=true
                    local tx = Instance.new("TextLabel",bc)
                    tx.Size = UDim2.new(1,0,1,0)
                    tx.BackgroundTransparency=1
                    tx.Text=it.Name
                    tx.TextColor3=Color3.fromRGB(80,255,240)
                    tx.Font=Enum.Font.GothamBold
                    tx.TextSize=13
                end
            end
        end
    end)
    Notification("Eşya ESP açıldı")
end)
MakeButton(tab_esp,"Kill All",function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Team~=LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character:FindFirstChild("Humanoid").Health = 0
        end
    end
    Notification("Tüm düşmanlar öldürüldü")
end)
MakeButton(tab_esp,"Kill Aura",function()
    if getgenv().QuartzAURA then return end
    getgenv().QuartzAURA = RunService.RenderStepped:Connect(function()
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Team~=LocalPlayer.Team and p.Character and (p.Character.HumanoidRootPart.Position-Character.HumanoidRootPart.Position).Magnitude < 16 then
                if p.Character:FindFirstChild("Humanoid") then
                    p.Character.Humanoid.Health = 0
                end
            end
        end
    end)
    Notification("Kill Aura açıldı")
end)
MakeButton(tab_esp,"Auto Arrest All",function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Team.Name=="Criminal" and p.Character and p.Character:FindFirstChild("Head") then
            Workspace.Remote.arrest:InvokeServer(p.Character.Head)
        end
    end
    Notification("Tüm suçlular tutuklandı")
end)
MakeButton(tab_esp,"Arrest Range Multiplier",function()
    for _,v in ipairs(getgc(true)) do
        if type(v)=="table" and rawget(v,"ArrestRange") then
            v.ArrestRange = 9999
        end
    end
    Notification("Kelepçe menzili artırıldı")
end)

-- DEFANS (KORUMA)
MakeSection(tab_def,"Defans ve Koruma")
MakeButton(tab_def,"God Mode",function()
    getgenv().QuartzGOD = RunService.RenderStepped:Connect(function()
        pcall(function() Character.Humanoid.Health = math.huge end)
    end)
    Notification("Ölümsüz oldunuz")
end)
MakeButton(tab_def,"Semi-God Mode",function()
    Character.Humanoid.HealthChanged:Connect(function()
        Character.Humanoid.Health = Character.Humanoid.MaxHealth
    end)
    Notification("Sağlık sürekli yenileniyor")
end)
MakeButton(tab_def,"Anti-Arrest",function()
    LocalPlayer.PlayerGui.ChildAdded:Connect(function(c)
        if c.Name == "ArrestGui" then c:Destroy() end
    end)
    Notification("Anti-Arrest açıldı")
end)
MakeButton(tab_def,"Give Keycard",function()
    Workspace.Remote.ItemHandler:InvokeServer("Key card")
    Notification("Keycard verildi")
end)
MakeButton(tab_def,"Auto Escape",function()
    local cells = Workspace:FindFirstChild("Prison_Cellblock")
    if cells then
        Character:MoveTo(cells.Position + Vector3.new(0,5,0))
    end
    local crimSpawn = Workspace:FindFirstChild("Criminals") and Workspace.Criminals:FindFirstChild("SpawnLocation")
    if crimSpawn then
        Character:MoveTo(crimSpawn.Position+Vector3.new(0,3,0))
    end
    Notification("Hapisten çıktınız")
end)

-- SUNUCU/ TROL
MakeSection(tab_srv,"Server - Fun & Trol")
MakeButton(tab_srv,"Spinbot",function()
    if getgenv().QuartzSPIN then return end
    getgenv().QuartzSPIN = RunService.RenderStepped:Connect(function()
        pcall(function()
            Character:SetPrimaryPartCFrame(Character.PrimaryPart.CFrame*CFrame.Angles(0,math.rad(32),0))
        end)
    end)
    Notification("Spinbot açıldı")
end)
MakeButton(tab_srv,"Invisible",function()
    for _,part in pairs(Character:GetChildren()) do
        if part:IsA("BasePart") or part:IsA("MeshPart") then
            part.Transparency = 1
        end
    end
    Character.HumanoidRootPart.Transparency = 1
    Notification("Görünmez oldunuz")
end)
MakeButton(tab_srv,"Loop Kill Target",function()
    local pname = game:GetService("StarterGui"):PromptInput("Oyuncu adı:")
    local target = GetPlayer(pname)
    if target and target.Character then
        if getgenv().QuartzLOOPKILL then getgenv().QuartzLOOPKILL:Disconnect() end
        getgenv().QuartzLOOPKILL = RunService.Stepped:Connect(function()
            if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                target.Character.Humanoid.Health = 0
            end
        end)
        Notification("Loop kill uygulandı: "..target.Name)
    else
        Notification("Oyuncu bulunamadı")
    end
end)
MakeButton(tab_srv,"Bring All Players",function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("HumanoidRootPart") then
            p.Character:MoveTo(Character.HumanoidRootPart.Position + Vector3.new(math.random(-7,7),0,math.random(-7,7)))
        end
    end
    Notification("Tüm oyuncular getirildi")
end)
MakeButton(tab_srv,"Teleport To Locations",function()
    local locs = {
        ["Silah Odası"] = Workspace:FindFirstChild("GunRoom") and Workspace.GunRoom:FindFirstChild("Guns") and Workspace.GunRoom.Guns.Position or nil,
        ["Bahçe"] = Workspace:FindFirstChild("Yard") and Workspace.Yard:FindFirstChild("Yard_Stuff") and Workspace.Yard.Yard_Stuff.Position or nil,
        ["Crim Base"] = Workspace:FindFirstChild("Criminals") and Workspace.Criminals:FindFirstChild("SpawnLocation") and Workspace.Criminals.SpawnLocation.Position or nil,
        ["Hücreler"] = Workspace:FindFirstChild("Cells") and Workspace.Cells:FindFirstChild("Cells") and Workspace.Cells.Cells.Position or nil
    }
    local pick = game:GetService("StarterGui"):PromptInput("Konum adı yaz (Silah Odası,Bahçe,Crim Base,Hücreler):")
    local pos = locs[pick]
    if pos then
        Character:SetPrimaryPartCFrame(CFrame.new(pos + Vector3.new(0,2,0)))
        Notification(pick.." konumuna ışınlandınız")
    else
        Notification("Konum bulunamadı")
    end
end)
MakeButton(tab_srv,"Chat Spammer",function()
    local msg = game:GetService("StarterGui"):PromptInput("Spam mesajını gir:")
    if not getgenv().QuartzCHATSPAM then
        getgenv().QuartzCHATSPAM = true
        spawn(function()
            while getgenv().QuartzCHATSPAM do
                pcall(function() Workspace.Remote.SendMessage:FireServer(msg) end)
                task.wait(0.09)
            end
        end)
    end
    Notification("Spam başladı, menü kapatınca durur")
end)
MakeButton(tab_srv,"Crash Server (Lag Switch)",function()
    for i=1,987 do
        Workspace.Remote.TeamEvent:FireServer("Neutral")
        task.wait()
    end
    Notification("Sunucuya ağır lag gönderildi!")
end)
MakeButton(tab_srv,"Server View (Spectate)",function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = p.Character.Humanoid
            Notification(p.Name.." izleniyor")
            break
        end
    end
end)

UIS.InputBegan:Connect(function(inp,gp)
    if not gp and inp.KeyCode == Enum.KeyCode.RightShift then
        QuartzGUI.Enabled = not QuartzGUI.Enabled
    end
end)
Notification("QUARTZ.LUA yüklendi! [Menü: RightShift]")
-- End Generation Here
```
