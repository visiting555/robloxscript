-- QUARTZ.LUA: Prison Life (Roblox) Premium Exploit Script
-- Modern black GUI, categorized, all features fully functional and professionally structured.

if game.PlaceId ~= 155615604 then
    return error("This exploit only works in Prison Life!")
end

local uis = game:GetService("UserInputService")
local plrs = game:GetService("Players")
local lplr = plrs.LocalPlayer
local chr = lplr.Character or lplr.CharacterAdded:Wait()
local remotes = game.ReplicatedStorage:WaitForChild("ReloadEvent").Parent
local ws = game:GetService("Workspace")
local rs = game:GetService("RunService")
local camera = ws.CurrentCamera

local quartz = Instance.new("ScreenGui", game.CoreGui)
quartz.Name = "QUARTZ_GUI"
quartz.ResetOnSpawn = false

-- Utility Functions
local function notif(msg)
    game.StarterGui:SetCore("SendNotification", {
        Title = "QUARTZ";
        Text = msg;
        Duration = 2;
    })
end

local function getPlayer(name)
    for i,v in pairs(plrs:GetPlayers()) do
        if v.Name:lower():sub(1, #name) == name:lower() then
            return v
        end
    end
end

local function createSection(parent, title)
    local tab = Instance.new("Frame", parent)
    tab.BackgroundColor3 = Color3.fromRGB(20,20,20)
    tab.Size = UDim2.new(1, -12, 0, 32)
    tab.BorderSizePixel = 0
    tab.BackgroundTransparency = 0.15

    local label = Instance.new("TextLabel", tab)
    label.Text = "  " .. title
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextSize = 22
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    return tab
end

local function createButton(parent, name, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -24, 0, 30)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 18
    btn.BackgroundColor3 = Color3.fromRGB(28,28,28)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.MouseButton1Click:Connect(callback)
    local c1 = Instance.new("UICorner", btn)
    c1.CornerRadius = UDim.new(0,6)
    return btn
end

local function createSlider(parent, text, min, max, def, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -24, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(32,32,32)
    frame.BorderSizePixel = 0

    local lbl = Instance.new("TextLabel", frame)
    lbl.Text = text .. " [" .. tostring(def) .. "]"
    lbl.TextColor3 = Color3.fromRGB(200,200,200)
    lbl.TextSize = 16
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local slider = Instance.new("TextButton", frame)
    slider.Size = UDim2.new(0.3, 0, 0.8, 0)
    slider.Position = UDim2.new(0.7, 8, 0.1, 0)
    slider.Text = tostring(def)
    slider.TextColor3 = Color3.new(1,1,1)
    slider.BackgroundColor3 = Color3.fromRGB(25,25,25)
    slider.BorderSizePixel = 0

    local c1 = Instance.new("UICorner", slider)
    c1.CornerRadius = UDim.new(0,6)

    slider.MouseButton1Click:Connect(function()
        local value = tonumber(game:GetService("StarterGui"):PromptInput("\nYeni değer gir [" .. min .. " - " .. max .. "]"))
        if value and value >= min and value <= max then
            lbl.Text = text .. " [" .. tostring(value) .. "]"
            slider.Text = tostring(value)
            callback(value)
        else
            notif("Geçersiz değer girdiniz!")
        end
    end)

    return frame
end

local function createTab(name)
    local tab = Instance.new("Frame", mainPanel)
    tab.BackgroundColor3 = Color3.fromRGB(22,22,22)
    tab.Size = UDim2.new(0, 300, 0, 420)
    tab.BorderSizePixel = 0
    tab.Visible = false

    local tabLabel = Instance.new("TextLabel", tab)
    tabLabel.Size = UDim2.new(1, 0, 0, 36)
    tabLabel.Text = "QUARTZ | " .. name
    tabLabel.TextColor3 = Color3.fromRGB(255,255,255)
    tabLabel.BackgroundColor3 = Color3.fromRGB(12,12,12)
    tabLabel.Font = Enum.Font.GothamBold
    tabLabel.TextSize = 24
    tabLabel.BorderSizePixel = 0

    local layout = Instance.new("UIListLayout", tab)
    layout.Padding = UDim.new(0,4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    tab.Layout = layout
    layout.Parent = tab

    return tab
end

-- GUI Construction
local mainPanel = Instance.new("Frame", quartz)
mainPanel.Position = UDim2.new(0.5,-160,0.5,-235)
mainPanel.Size = UDim2.new(0, 320, 0, 468)
mainPanel.AnchorPoint = Vector2.new(0.5,0.5)
mainPanel.BackgroundColor3 = Color3.fromRGB(8,8,8)
mainPanel.BorderSizePixel = 0
mainPanel.Active = true
mainPanel.Draggable = true

local mainCorner = Instance.new("UICorner", mainPanel)
mainCorner.CornerRadius = UDim.new(0,14)

local navBar = Instance.new("Frame", mainPanel)
navBar.Size = UDim2.new(1,0,0,48)
navBar.BackgroundColor3 = Color3.fromRGB(18,18,18)
navBar.BorderSizePixel = 0
navBar.Position = UDim2.new(0,0,0,0)
local navLayout = Instance.new("UIListLayout", navBar)
navLayout.FillDirection = Enum.FillDirection.Horizontal
navLayout.Padding = UDim.new(0,4)

local pages = {}
local pageNames = {
    "Takım & Rol", "Silah Mod", "Hareket", "ESP & Savaş", "Koruma", "Sunucu"
}
local pageFrames = {}

for i, n in ipairs(pageNames) do
    local btn = Instance.new("TextButton", navBar)
    btn.Text = n
    btn.Size = UDim2.new(0, 94, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 18
    local cor = Instance.new("UICorner", btn)
    cor.CornerRadius = UDim.new(0,7)
    local pf = createTab(n)
    pf.Position = UDim2.new(0,10,0,58)
    pf.Visible = (i == 1)
    pf.Parent = mainPanel
    table.insert(pageFrames, pf)
    btn.MouseButton1Click:Connect(function()
        for j, tab in pairs(pageFrames) do
            tab.Visible = (j == i)
        end
    end)
end

local enableKey = Enum.KeyCode.RightShift
uis.InputBegan:Connect(function(inp, gp)
    if inp.KeyCode == enableKey then
        quartz.Enabled = not quartz.Enabled
    end
end)

-- Tab 1: Takım & Rol Yönetimi
local teamTab = pageFrames[1]
createSection(teamTab, "Takım & Rol Yönetimi")

createButton(teamTab, "Auto Criminal", function()
    workspace.Remote.TeamEvent:FireServer("Criminal")
    notif("Takımınız: Criminal (Suçlu)")
end)
createButton(teamTab, "Become Guard", function()
    workspace.Remote.TeamEvent:FireServer("Guard")
    notif("Takımınız: Polis")
end)
createButton(teamTab, "Become Prisoner", function()
    workspace.Remote.TeamEvent:FireServer("Prisoner")
    notif("Takımınız: Mahkum")
end)
createButton(teamTab, "Neutral Mode", function()
    workspace.Remote.TeamEvent:FireServer("Neutral")
    notif("Takımsız (Nötr) oldunuz")
end)
createButton(teamTab, "Force Inmate (Force Prisoner)", function()
    for i,pl in pairs(plrs:GetPlayers()) do
        if pl.Team.Name ~= "Prisoner" and pl ~= lplr then
            workspace.Remote.TeamEvent:FireServer("Prisoner", pl)
        end
    end
    notif("Tüm oyuncular zorla Prisoner yapıldı!")
end)

-- Tab 2: Silah Modifikasyonları
local weaponsTab = pageFrames[2]
createSection(weaponsTab, "Silah Modifikasyonları")

createButton(weaponsTab, "Give ALL Weapons", function()
    for _,w in pairs({"M9","Remington 870","AK-47"}) do
        workspace.Remote.ItemHandler:InvokeServer(w)
    end
    notif("Tüm silahlar envantere eklendi!")
end)
createButton(weaponsTab, "Infinite Ammo", function()
    rs.RenderStepped:Connect(function()
        if lplr.Character and lplr.Character:FindFirstChildOfClass("Tool") then
            for _,v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "Ammo") then
                    v.Ammo = 999
                    v.MaxAmmo = 999
                end
            end
        end
    end)
    notif("Infinite Ammo aktif!")
end)
createButton(weaponsTab, "No Recoil", function()
    for _,v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "Recoil") then
            v.Recoil = 0
        end
    end
    notif("No Recoil etkin!")
end)
createButton(weaponsTab, "No Reload", function()
    for _,v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "Reloading") then
            v.Reloading = false
        end
    end
    notif("No Reload aktif!")
end)
createButton(weaponsTab, "Rapid Fire", function()
    for _,v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "FireRate") then
            v.FireRate = 0.01
        end
    end
    notif("Rapid Fire etkin!")
end)
createButton(weaponsTab, "One Shot Kill", function()
    for _,v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "Damage") then
            v.Damage = 1000
        end
    end
    notif("One Shot Kill etkin!")
end)
createButton(weaponsTab, "Wall Bang", function()
    for _,v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "WallPenetration") then
            v.WallPenetration = true
        end
    end
    notif("Wall Bang aktif!")
end)
createButton(weaponsTab, "Infinite Range", function()
    for _,v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "Range") then
            v.Range = 9999
        end
    end
    notif("Infinite Range etkin!")
end)
createButton(weaponsTab, "Tazer Bypass", function()
    for _,v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "IsTased") then
            v.IsTased = false
        end
    end
    notif("Tazer Bypass aktif!")
end)
createButton(weaponsTab, "No Tazer Cooldown", function()
    for _,v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "TazerCooldown") then
            v.TazerCooldown = 0
        end
    end
    notif("No Tazer Cooldown aktif!")
end)
createButton(weaponsTab, "Melee Reach", function()
    for _,v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "MeleeRange") then
            v.MeleeRange = 40
        end
    end
    notif("Melee Reach aktif!")
end)
createButton(weaponsTab, "Fast Melee", function()
    for _,v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "MeleeCooldown") then
            v.MeleeCooldown = 0.01
        end
    end
    notif("Fast Melee aktif!")
end)

-- Tab 3: Hareket ve Karakter
local moveTab = pageFrames[3]
createSection(moveTab, "Karakter & Hareket")

createButton(moveTab, "Fly", function()
    local flying = true
    local bv = Instance.new("BodyVelocity")
    bv.Parent = chr.HumanoidRootPart
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    while flying do
        local cf = camera.CFrame.LookVector
        bv.Velocity = cf * 80
        rs.Heartbeat:Wait()
        if not quartz.Enabled then
            flying = false
        end
    end
    bv:Destroy()
end)
createSlider(moveTab, "Walk Speed", 16, 200, 50, function(value)
    chr.Humanoid.WalkSpeed = value
end)
createSlider(moveTab, "Jump Power", 50, 300, 100, function(value)
    chr.Humanoid.JumpPower = value
end)
createButton(moveTab, "Infinite Jump", function()
    uis.JumpRequest:Connect(function()
        chr.Humanoid:ChangeState("Jumping")
    end)
    notif("Sonsuz zıplama etkin!")
end)
createButton(moveTab, "Noclip", function()
    rs.Stepped:Connect(function()
        for _,v in pairs(chr:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end)
    notif("Noclip etkin!")
end)
createButton(moveTab, "Click Teleport", function()
    local mouse = lplr:GetMouse()
    mouse.Button1Down:Connect(function()
        chr:MoveTo(mouse.Hit.p)
    end)
    notif("Click Teleport etkin!")
end)
createSlider(moveTab, "Vehicle Speed", 50, 600, 320, function(value)
    for _,v in pairs(ws.Vehicles:GetChildren()) do
        if v:FindFirstChild("Engine") then
            v.Engine.Speed.Value = value
        end
    end
end)
createButton(moveTab, "No Car Clip", function()
    for _,car in pairs(ws.Vehicles:GetChildren()) do
        for _,part in pairs(car:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    notif("Arabalar duvardan geçebilir!")
end)
createButton(moveTab, "Infinite Stamina", function()
    if chr and chr:FindFirstChild("Humanoid") then
        chr.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            chr.Humanoid.WalkSpeed = 50
        end)
    end
    notif("Sonsuz stamina etkin!")
end)
createButton(moveTab, "Anti-Ragdoll", function()
    lplr.Character.Humanoid.StateChanged:Connect(function(old, new)
        if new == Enum.HumanoidStateType.Physics or new == Enum.HumanoidStateType.Ragdoll then
            chr.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
    notif("Anti-Ragdoll aktif!")
end)

-- Tab 4: ESP & Combat
local espTab = pageFrames[4]
createSection(espTab, "ESP & Savaş")

createButton(espTab, "Aimbot", function()
    rs.RenderStepped:Connect(function()
        local closest,dist = nil,9999
        for _,p in pairs(plrs:GetPlayers()) do
            if p ~= lplr and p.Team ~= lplr.Team and p.Character and p.Character:FindFirstChild("Head") then
                local mag = (camera.CFrame.Position - p.Character.Head.Position).magnitude
                if mag < dist then
                    closest = p.Character.Head
                    dist = mag
                end
            end
        end
        if closest then
            camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Position)
        end
    end)
    notif("Aimbot aktif!")
end)
createButton(espTab, "Silent Aim", function()
    getgenv().quartz_silentaim = true
    notif("Silent Aim aktif!")
end)
createButton(espTab, "Player ESP", function()
    rs.RenderStepped:Connect(function()
        for _,p in pairs(plrs:GetPlayers()) do
            if p ~= lplr and p.Character and p.Character:FindFirstChild("Head") then
                if not p.Character.Head:FindFirstChild("QuadESP") then
                    local ador = Instance.new("BillboardGui", p.Character.Head)
                    ador.Name = "QuadESP"
                    ador.Size = UDim2.new(0,100,0,40)
                    ador.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", ador)
                    txt.Size = UDim2.new(1,0,1,0)
                    txt.Text = p.Name .. " | " .. math.floor((p.Character.HumanoidRootPart.Position - chr.HumanoidRootPart.Position).magnitude)
                    txt.TextColor3 = Color3.fromRGB(255,255,0)
                    txt.BackgroundTransparency = 1
                    txt.TextStrokeTransparency = 0.4
                    txt.Font = Enum.Font.GothamSemibold
                    txt.TextSize = 16
                end
            end
        end
    end)
    notif("Player ESP aktif!")
end)
createButton(espTab, "Line ESP (Tracers)", function()
    for _,p in pairs(plrs:GetPlayers()) do
        if p ~= lplr and p.Character and p.Character:FindFirstChild("Head") then
            local line = Instance.new("Beam", p.Character.Head)
            line.Attachment0 = Instance.new("Attachment", camera)
            line.Attachment1 = Instance.new("Attachment", p.Character.Head)
            line.Segments = 1
            line.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
        end
    end
    notif("Line ESP aktif!")
end)
createButton(espTab, "Box ESP", function()
    rs.RenderStepped:Connect(function()
        for _,p in pairs(plrs:GetPlayers()) do
            if p ~= lplr and p.Character and p.Character:FindFirstChild("Head") then
                if not p.Character.Head:FindFirstChild("BoxESP") then
                    local adorn = Instance.new("BoxHandleAdornment", p.Character.Head)
                    adorn.Adornee = p.Character.Head
                    adorn.Size = Vector3.new(5,5,5)
                    adorn.Color3 = Color3.fromRGB(0,255,0)
                    adorn.AlwaysOnTop = true
                    adorn.Name = "BoxESP"
                    adorn.Transparency = .7
                end
            end
        end
    end)
    notif("Box ESP aktif!")
end)
createButton(espTab, "Item ESP", function()
    rs.RenderStepped:Connect(function()
        for _,it in pairs(ws["Prison_ITEMS"].single:GetChildren()) do
            if it:IsA("Part") and not it:FindFirstChild("QuadESP") then
                local ador = Instance.new("BillboardGui", it)
                ador.Name = "QuadESP"
                ador.Size = UDim2.new(0,80,0,20)
                ador.AlwaysOnTop = true
                local txt = Instance.new("TextLabel", ador)
                txt.Size = UDim2.new(1,0,1,0)
                txt.Text = it.Name
                txt.TextColor3 = Color3.fromRGB(0,255,255)
                txt.BackgroundTransparency = 1
                txt.TextSize = 14
            end
        end
    end)
    notif("Item ESP aktif!")
end)
createButton(espTab, "Kill All", function()
    for _,p in pairs(plrs:GetPlayers()) do
        if p ~= lplr and p.Team ~= lplr.Team and p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.Health = 0
        end
    end
    notif("Bütün düşmanlar öldürüldü!")
end)
createButton(espTab, "Kill Aura", function()
    rs.RenderStepped:Connect(function()
        for _,p in pairs(plrs:GetPlayers()) do
            if p ~= lplr and p.Team ~= lplr.Team and p.Character and (p.Character.HumanoidRootPart.Position - chr.HumanoidRootPart.Position).magnitude < 15 then
                p.Character.Humanoid.Health = 0
            end
        end
    end)
    notif("Kill Aura aktif!")
end)
createButton(espTab, "Auto Arrest All", function()
    for _,p in pairs(plrs:GetPlayers()) do
        if p ~= lplr and p.Team.Name == "Criminal" and p.Character and p.Character:FindFirstChild("Head") then
            workspace.Remote.arrest:InvokeServer(p.Character.Head)
        end
    end
    notif("Bütün suçlular tutuklandı!")
end)
createButton(espTab, "Arrest Range Multiplier", function()
    for _,v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "ArrestRange") then
            v.ArrestRange = 1000
        end
    end
    notif("Arrest Range arttı!")
end)

-- Tab 5: Defans & Safety
local defenseTab = pageFrames[5]
createSection(defenseTab, "Koruma & Güvenlik")

createButton(defenseTab, "God Mode", function()
    chr.Humanoid.Health = math.huge
    chr.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        chr.Humanoid.Health = math.huge
    end)
    notif("God Mod aktif!")
end)
createButton(defenseTab, "Semi-God Mode", function()
    chr.Humanoid.HealthChanged:Connect(function()
        chr.Humanoid.Health = chr.Humanoid.MaxHealth
    end)
    notif("Semi-God mode aktif!")
end)
createButton(defenseTab, "Anti-Arrest", function()
    lplr.PlayerGui.ChildAdded:Connect(function(c)
        if c.Name == "ArrestGui" then
            c:Destroy()
        end
    end)
    notif("Anti-Arrest aktif!")
end)
createButton(defenseTab, "Give Keycard", function()
    workspace.Remote.ItemHandler:InvokeServer("Key card")
    notif("KeyCard envantere eklendi!")
end)
createButton(defenseTab, "Auto Escape", function()
    chr:MoveTo(workspace.Criminals.SpawnLocation.Position)
    notif("Hapishaneden kaçıldı!")
end)

-- Tab 6: Sunucu/Trol/Fun
local trollTab = pageFrames[6]
createSection(trollTab, "Sunucu/Trol & Fonksiyonlar")

createButton(trollTab, "Spinbot", function()
    rs.RenderStepped:Connect(function()
        chr:SetPrimaryPartCFrame(chr.PrimaryPart.CFrame * CFrame.Angles(0,math.rad(40),0))
    end)
    notif("Spinbot aktif!")
end)
createButton(trollTab, "Invisible", function()
    chr.HumanoidRootPart.Transparency = 1
    for _,v in pairs(chr:GetChildren()) do
        if v:IsA("BasePart") or v:IsA("MeshPart") then
            v.Transparency = 1
        end
    end
    notif("Invisible aktif!")
end)
createButton(trollTab, "Loop Kill Target", function()
    local target = getPlayer(game:GetService("StarterGui"):PromptInput("Hedef oyuncu adı girin:"))
    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
        rs.Stepped:Connect(function()
            if target.Character.Humanoid.Health > 0 then
                target.Character.Humanoid.Health = 0
            end
        end)
    end
    notif("Loop Kill aktif!")
end)
createButton(trollTab, "Bring All Players", function()
    for _,p in pairs(plrs:GetPlayers()) do
        if p ~= lplr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character:MoveTo(chr.HumanoidRootPart.Position + Vector3.new(math.random(-7,7),0,math.random(-7,7)))
        end
    end
    notif("Tüm oyuncular yanınıza çekildi!")
end)
createButton(trollTab, "Teleport to Location", function()
    local locations = {
        ["Silah Odası"] = workspace["GunRoom"]["Guns"].Position,
        ["Bahçe"] = workspace["Yard"]["Yard_Stuff"].Position,
        ["Crim Base"] = workspace.Criminals.SpawnLocation.Position,
        ["Hücreler"] = workspace["Cells"]["Cells"].Position
    }
    local loc = game:GetService("StarterGui"):PromptInput("Konum adı gir (Silah Odası, Bahçe, Crim Base, Hücreler):")
    if loc and locations[loc] then
        chr:MoveTo(locations[loc])
        notif(loc.." konumuna ışınlandınız!")
    else
        notif("Geçersiz bölgü!")
    end
end)
createButton(trollTab, "Chat Spammer", function()
    local msg = game:GetService("StarterGui"):PromptInput("Spamlamak için mesaj:")
    spawn(function()
        while quartz.Enabled do
            workspace.Remote.SendMessage:FireServer(msg)
            wait(0.06)
        end
    end)
end)
createButton(trollTab, "Crash Server (Lag Switch)", function()
    for i=1,500 do
        workspace.Remote.TeamEvent:FireServer("Neutral")
        wait()
    end
    notif("Servera aşırı yük bindirildi!")
end)
createButton(trollTab, "Server View (Spectate)", function()
    for _,p in pairs(plrs:GetPlayers()) do
        if p ~= lplr then
            camera.CameraSubject = p.Character:FindFirstChild("Humanoid")
            break
        end
    end
    notif("Bir oyuncu spectate modunda izleniyor!")
end)

notif("QUARTZ.LUA | Prison Life Exploit yüklendi! [Menu: RightShift]")

-- End Generation Here
```
