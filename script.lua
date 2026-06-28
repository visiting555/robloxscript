-- GELİŞTİRİLMİŞ FULL HİLE MENÜ (YENİ MENÜ SİSTEMİ & TAM FONKSİYONELLİK)
// Kullanıcı için yeni, sabit menü ve fonksiyonlar

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Teams = game:GetService("Teams")

-- Hotkey (F4) ile menü göster/gizle
local HOTKEY = Enum.KeyCode.F4

if LocalPlayer.PlayerGui:FindFirstChild("HileMenuV3") then
    LocalPlayer.PlayerGui.HileMenuV3:Destroy()
end

----------------- UI OLUŞTURMA -------------------

local UI = Instance.new("ScreenGui")
UI.Name = "HileMenuV3"
UI.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer.PlayerGui
UI.ResetOnSpawn = false

local rootFrame = Instance.new("Frame")
rootFrame.Parent = UI
rootFrame.BackgroundColor3 = Color3.fromRGB(18,22,28)
rootFrame.Size = UDim2.new(0,380,0,482)
rootFrame.Position = UDim2.new(0,40,0,90)
rootFrame.Active = true
rootFrame.Draggable = true
rootFrame.Visible = true -- Hotkey ile aç/kapa yapılabilir

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = rootFrame
titleLabel.Text = "ROBLOX HİLE MENÜ V4"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(112,230,255)
titleLabel.BackgroundTransparency = 1
titleLabel.TextScaled = true
titleLabel.Size = UDim2.new(1,0,0,36)
titleLabel.Position = UDim2.new(0,0,0,0)

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = rootFrame
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.fromRGB(220,70,70)
closeBtn.Size = UDim2.new(0,36,0,28)
closeBtn.Position = UDim2.new(1,-38,0,6)
closeBtn.BackgroundColor3 = Color3.fromRGB(40,40,60)
closeBtn.BorderSizePixel = 0
closeBtn.MouseButton1Click:Connect(function()
    UI.Enabled = false
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == HOTKEY then
        rootFrame.Visible = not rootFrame.Visible
    end
end)

-- Sekmeler (Sayfa yapısı!)
local tabs = {"Hileler", "Oyuncu"}
local currentTab = "Hileler"

local tabButtons = {}
for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Parent = rootFrame
    btn.Text = tab
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.TextColor3 = Color3.fromRGB(210,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(37,44,52)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0.5,0,0,34)
    btn.Position = UDim2.new((i-1)*0.5,0,0,36)
    btn.Name = tab
    btn.Activated:Connect(function()
        currentTab = tab
        for _,tbtn in pairs(tabButtons) do
            tbtn.BackgroundColor3 = Color3.fromRGB(37,44,52)
        end
        btn.BackgroundColor3 = Color3.fromRGB(0,160,255)
        updateTabVisibility()
    end)
    tabButtons[tab] = btn
end
tabButtons.Hileler.BackgroundColor3 = Color3.fromRGB(0,160,255)

local hilelerFrame = Instance.new("Frame")
hilelerFrame.Parent = rootFrame
hilelerFrame.Name = "HilelerPage"
hilelerFrame.BackgroundTransparency = 1
hilelerFrame.Size = UDim2.new(1,0,1,-70)
hilelerFrame.Position = UDim2.new(0,0,0,70)

local oyuncuFrame = Instance.new("Frame")
oyuncuFrame.Parent = rootFrame
oyuncuFrame.Name = "OyuncuPage"
oyuncuFrame.BackgroundTransparency = 1
oyuncuFrame.Size = UDim2.new(1,0,1,-70)
oyuncuFrame.Position = UDim2.new(0,0,0,70)

local function updateTabVisibility()
    hilelerFrame.Visible = currentTab == "Hileler"
    oyuncuFrame.Visible = currentTab == "Oyuncu"
end
updateTabVisibility()

----------------- HİLELER -------------------
local hackEnabled = {
    Aimbot = false,
    SilentAim = false,
    ESP = false,
    Noclip = false,
    Fly = false,
    Spinbot = false,
    Godmode = false,
    TeamCheck = true,
    NoReload = false,
}
local optionsUI = {
    {Key="Aimbot",    Name="Aimbot"},
    {Key="SilentAim", Name="Silent Aim"},
    {Key="ESP",       Name="ESP"},
    {Key="Noclip",    Name="Noclip"},
    {Key="Fly",       Name="Fly"},
    {Key="Spinbot",   Name="Spinbot"},
    {Key="Godmode",   Name="Godmode"},
    {Key="TeamCheck", Name="Takım Kontrol"},
    {Key="NoReload",  Name="NoReload"},
}

local config = { FOV = 120 }
local labelY = 8
local butRef = {}

for i,data in ipairs(optionsUI) do
    local btn = Instance.new("TextButton")
    btn.Parent = hilelerFrame
    btn.Name = "h_"..data.Key
    btn.Position = UDim2.new(0,18,0,8 + (i-1)*36)
    btn.Size = UDim2.new(0.5, -24, 0,32)
    btn.BackgroundColor3 = Color3.fromRGB(45,54,70)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.BorderSizePixel = 0
    local function updateTxt()
        btn.Text = data.Name .. " [" .. (hackEnabled[data.Key] and "Açık" or "Kapalı") .. "]"
        btn.TextColor3 = hackEnabled[data.Key] and Color3.fromRGB(0,255,185) or Color3.fromRGB(240,230,230)
    end
    updateTxt()
    btn.MouseButton1Click:Connect(function()
        hackEnabled[data.Key] = not hackEnabled[data.Key]
        updateTxt()
    end)
    butRef[data.Key] = btn
end

-- FOV
local fovLbl = Instance.new("TextLabel")
fovLbl.Parent = hilelerFrame
fovLbl.Position = UDim2.new(0.55,0,0,16)
fovLbl.Size = UDim2.new(0,88,0,26)
fovLbl.BackgroundTransparency = 1
fovLbl.Font = Enum.Font.GothamBold
fovLbl.TextSize = 14
fovLbl.TextXAlignment = Enum.TextXAlignment.Left
fovLbl.TextColor3 = Color3.fromRGB(140,255,140)
fovLbl.Text = "Aimbot FOV"

local fovBox = Instance.new("TextBox")
fovBox.Parent = hilelerFrame
fovBox.Position = UDim2.new(0.55,100,0,16)
fovBox.Size = UDim2.new(0,44,0,26)
fovBox.Font = Enum.Font.GothamBold
fovBox.TextSize = 14
fovBox.Text = tostring(config.FOV)
fovBox.BackgroundColor3 = Color3.fromRGB(30,38,42)
fovBox.TextColor3 = Color3.fromRGB(0,230,170)
fovBox.BorderSizePixel = 0

fovBox.FocusLost:Connect(function()
    local n = tonumber(fovBox.Text)
    if n and n>=5 then
        config.FOV = math.floor(math.clamp(n, 10, 500))
        fovBox.Text = tostring(config.FOV)
    else
        fovBox.Text = tostring(config.FOV)
    end
end)

-- Bilgi
local infoLbl = Instance.new("TextLabel")
infoLbl.Parent = hilelerFrame
infoLbl.Size = UDim2.new(1, 0, 0, 18)
infoLbl.Position = UDim2.new(0, 8, 1, -26)
infoLbl.Text = "(Menuyu aç/kapat: F4) | FOV Default: 120" 
infoLbl.TextColor3 = Color3.fromRGB(64,200,180)
infoLbl.Font = Enum.Font.Gotham
infoLbl.TextSize = 13
infoLbl.BackgroundTransparency = 1
infoLbl.TextXAlignment = Enum.TextXAlignment.Left

------------------- OYUNCU AKSİYONLARI -----------------

local secilenOyuncu = nil
local oyuncuYaz = Instance.new("TextLabel")
oyuncuYaz.Parent = oyuncuFrame
oyuncuYaz.Size = UDim2.new(0, 168, 0, 28)
oyuncuYaz.Position = UDim2.new(0,16,0,8)
oyuncuYaz.Text = "Seçili Oyuncu : Yok"
oyuncuYaz.Font = Enum.Font.GothamBold
oyuncuYaz.TextSize = 15
oyuncuYaz.TextColor3 = Color3.fromRGB(120,220,255)
oyuncuYaz.BackgroundTransparency = 1
oyuncuYaz.TextXAlignment = Enum.TextXAlignment.Left

local acBtn = Instance.new("TextButton")
acBtn.Parent = oyuncuFrame
acBtn.Size = UDim2.new(0,110,0,28)
acBtn.Position = UDim2.new(0,200,0,8)
acBtn.Text = "Oyuncu Seç"
acBtn.Font = Enum.Font.Gotham
acBtn.TextSize = 15
acBtn.BorderSizePixel = 0
acBtn.BackgroundColor3 = Color3.fromRGB(46,56,66)
acBtn.TextColor3 = Color3.fromRGB(0,240,200)

local scFrame = Instance.new("ScrollingFrame")
scFrame.Parent = oyuncuFrame
scFrame.Size = UDim2.new(1, -40, 0, 90)
scFrame.Position = UDim2.new(0, 16, 0, 42)
scFrame.BackgroundColor3 = Color3.fromRGB(30,39,56)
scFrame.BorderSizePixel = 0
scFrame.Visible = false
scFrame.CanvasSize = UDim2.new(0,0,0,0)
scFrame.ScrollBarThickness = 6

local function updateOyuncular()
    scFrame:ClearAllChildren()
    local i = 0
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Parent = scFrame
            btn.Size = UDim2.new(1, -8, 0, 24)
            btn.Position = UDim2.new(0, 4, 0, i * 28)
            btn.BackgroundColor3 = Color3.fromRGB(57,69,99)
            btn.BorderSizePixel = 0
            btn.Font = Enum.Font.Gotham
            btn.Text = plr.Name
            btn.TextSize = 15
            btn.TextColor3 = Color3.fromRGB(5,255,255)
            btn.MouseButton1Click:Connect(function()
                secilenOyuncu = plr
                oyuncuYaz.Text = "Seçili Oyuncu : " .. plr.Name
                scFrame.Visible = false
            end)
            i = i+1
        end
    end
    scFrame.CanvasSize = UDim2.new(0,0,0,i*28)
end

acBtn.MouseButton1Click:Connect(function()
    scFrame.Visible = not scFrame.Visible
    if scFrame.Visible then updateOyuncular() end
end)

local aksiyonlar = {
    { Name="Yanına Çek",   Fn=function()
        if secilenOyuncu and secilenOyuncu.Character and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and secilenOyuncu.Character:FindFirstChild("HumanoidRootPart") then
            secilenOyuncu.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(3,0,0)
        end
    end },
    { Name="Işınlan",      Fn=function()
        if secilenOyuncu and secilenOyuncu.Character and LocalPlayer.Character and secilenOyuncu.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = secilenOyuncu.Character.HumanoidRootPart.CFrame * CFrame.new(2,0,0)
        end
    end },
    { Name="Dondur",       Fn=function()
        if secilenOyuncu and secilenOyuncu.Character then
            for _,v in ipairs(secilenOyuncu.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Anchored = true
                end
            end
            local hum = secilenOyuncu.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 0; hum.JumpPower = 0; hum.PlatformStand = true end
        end
    end },
    { Name="Patlat",       Fn=function()
        if secilenOyuncu and secilenOyuncu.Character and secilenOyuncu.Character:FindFirstChild("HumanoidRootPart") then
            local boom = Instance.new("Explosion")
            boom.BlastRadius = 10
            boom.BlastPressure = 9e5
            boom.Position = secilenOyuncu.Character.HumanoidRootPart.Position
            boom.Parent = workspace
        end
    end },
    { Name="Yak",          Fn=function()
        if secilenOyuncu and secilenOyuncu.Character then
            for _,bp in ipairs(secilenOyuncu.Character:GetChildren()) do
                if bp:IsA("BasePart") and not bp:FindFirstChild("ONFIRE") then
                    local fire = Instance.new("Fire")
                    fire.Name = "ONFIRE"
                    fire.Size = 8
                    fire.Heat = 20
                    fire.Parent = bp
                end
            end
            local hum = secilenOyuncu.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = hum.Health - math.random(30,60) end
        end
    end },
}
-- Spectate özelliği: Canlı izleme
local isSpectating = false
local specBtn
local function specPlayer()
    if secilenOyuncu and secilenOyuncu.Character and secilenOyuncu.Character:FindFirstChildOfClass("Humanoid") then
        Camera.CameraSubject = secilenOyuncu.Character:FindFirstChildOfClass("Humanoid")
        Camera.CameraType = Enum.CameraType.Custom
        isSpectating = true
        specBtn.Text = "Çık (Spectate)"
    end
end
local function unspecPlayer()
    if isSpectating and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        Camera.CameraType = Enum.CameraType.Custom
        isSpectating = false
        specBtn.Text = "Spectate"
    end
end

-- Butonları yerleştir (Player Tools)
for i,ax in ipairs(aksiyonlar) do
    local b = Instance.new("TextButton")
    b.Parent = oyuncuFrame
    b.Size = UDim2.new(0,110,0,28)
    b.Position = UDim2.new(0,16 + ((i-1)%3)*120,0,148 + math.floor((i-1)/3)*38)
    b.BackgroundColor3 = Color3.fromRGB(42,56,66)
    b.BorderSizePixel = 0
    b.Text = ax.Name
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(230,240,240)
    b.MouseButton1Click:Connect(ax.Fn)
end

-- Spectate ayrı
specBtn = Instance.new("TextButton")
specBtn.Parent = oyuncuFrame
specBtn.Size = UDim2.new(0,110,0,28)
specBtn.Position = UDim2.new(0,16 + 3*120,0,148)
specBtn.BackgroundColor3 = Color3.fromRGB(65,80,120)
specBtn.BorderSizePixel = 0
specBtn.Text = "Spectate"
specBtn.Font = Enum.Font.GothamBold
specBtn.TextSize = 14
specBtn.TextColor3 = Color3.fromRGB(255,240,70)
specBtn.MouseButton1Click:Connect(function()
    if not isSpectating then specPlayer() else unspecPlayer() end
end)

------------------------------------------------
---- HİLE FONKSİYONELLİKLERİ
------------------------------------------------

-- Hileler
local NoclipConn, NoclipLastEn = nil, false
local function SetNoClipOnChar(state)
    local char = LocalPlayer.Character
    if not char then return end
    for _,v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state
            v.Anchored = false
        end
    end
end
if NoclipConn then NoclipConn:Disconnect() end
NoclipConn = RunService.Stepped:Connect(function()
    if hackEnabled.Noclip and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        SetNoClipOnChar(true)
        pcall(function() LocalPlayer.Character.Humanoid:ChangeState(11) end)
        NoclipLastEn = true
    elseif NoclipLastEn then
        SetNoClipOnChar(false)
        NoclipLastEn = false
    end
end)

-- FLY
local flyBV, flyBG
RunService.RenderStepped:Connect(function()
    if hackEnabled.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if not flyBV or flyBV.Parent ~= hrp then
            if flyBV then pcall(function() flyBV:Destroy() end) end
            flyBV = Instance.new("BodyVelocity")
            flyBV.Name = "___FlyBV"
            flyBV.MaxForce = Vector3.new(1e9,1e9,1e9)
            flyBV.Velocity = Vector3.new()
            flyBV.Parent = hrp
            flyBG = Instance.new("BodyGyro")
            flyBG.Name = "___FlyBG"
            flyBG.MaxTorque = Vector3.new(1e9,1e9,1e9)
            flyBG.CFrame = Camera.CFrame
            flyBG.Parent = hrp
        end
        local camCF = Camera.CFrame
        flyBG.CFrame = camCF
        local movevec = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then movevec = movevec + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then movevec = movevec - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then movevec = movevec - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then movevec = movevec + camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then movevec = movevec + camCF.UpVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then movevec = movevec - camCF.UpVector end
        if movevec.Magnitude > 0 then
            movevec = movevec.Unit * 75
        end
        flyBV.Velocity = movevec
    else
        if flyBV then pcall(function() flyBV:Destroy() end) flyBV = nil end
        if flyBG then pcall(function() flyBG:Destroy() end) flyBG = nil end
    end
end)

-- GODMODE
RunService.Heartbeat:Connect(function()
    if hackEnabled.Godmode then
        local chr = LocalPlayer.Character
        if chr and chr:FindFirstChildOfClass("Humanoid") then
            local hum = chr:FindFirstChildOfClass("Humanoid")
            pcall(function()
                hum.Health = hum.MaxHealth
                hum.MaxHealth = 9999999
                hum.WalkSpeed = 16
                hum.JumpPower = 50
                hum.PlatformStand = false
                hum.BreakJointsOnDeath = false
            end)
            for _, v in ipairs(chr:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
end)

-- NORELOAD
local function tryRemoveReloadGuns()
    if hackEnabled.NoReload then
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        local char = LocalPlayer.Character
        local function patchGun(obj)
            for _,desc in ipairs(obj:GetDescendants()) do
                if desc:IsA("Script") or desc:IsA("LocalScript") then
                    local n = (desc.Name..""):lower()
                    if n:find("ammo") or n:find("reload") or n:find("magazine") then
                        desc.Disabled = true
                    end
                end
            end
        end
        if backpack then for _,v in ipairs(backpack:GetChildren()) do patchGun(v) end end
        if char then for _,v in ipairs(char:GetChildren()) do patchGun(v) end end
    end
end
RunService.Heartbeat:Connect(tryRemoveReloadGuns)

-- SPINBOT
RunService.RenderStepped:Connect(function()
    if hackEnabled.Spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0,math.rad(24),0)
        end
    end
end)

-- TEAM CHECK
local function isEnemy(ply)
    if hackEnabled.TeamCheck and ply.Team and LocalPlayer.Team and ply.Team == LocalPlayer.Team then
        return false
    end
    return true
end

-- AIMBOT/SILENTAIM (otomatik kilit)
local function getClosestHead()
    local closest, minDist = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()
    for _, ply in pairs(Players:GetPlayers()) do
        if ply ~= LocalPlayer and ply.Character and ply.Character:FindFirstChild("Head") and ply.Character:FindFirstChildOfClass("Humanoid") and ply.Character:FindFirstChildOfClass("Humanoid").Health > 0 and isEnemy(ply) then
            local head = ply.Character.Head
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(head.Position)
            if OnScreen then
                local dist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                if dist < config.FOV and dist < minDist then
                    minDist = dist
                    closest = head
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if hackEnabled.Aimbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local head = getClosestHead()
        if head then
            local direction = (head.Position - Camera.CFrame.Position).Unit
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
        end
    end
end)

-- SİLENTAİM (vuruş performansı - örnek basic implementation)
-- (Simulated: If SilentAim is on, shoot always hits closest head)
local oldMeta = getrawmetatable(game)
local oldNamecall = oldMeta.__namecall
setreadonly(oldMeta, false)
oldMeta.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if hackEnabled.SilentAim and tostring(method):lower():find("fire") and getClosestHead() then
        if typeof(args[1])=="Vector3" then
            args[1]=getClosestHead().Position
        end
        return oldNamecall(self, unpack(args))
    end
    return oldNamecall(self, ...)
end)
setreadonly(oldMeta, true)

-- ESP (görsel)
local espDrawn = {}
local function removeESP()
    for _, obj in pairs(espDrawn) do
        if obj.Remove then pcall(function() obj:Remove() end) end
        if typeof(obj) == "table" then for _, o in ipairs(obj) do if o.Remove then pcall(function() o:Remove() end) end end end
    end
    espDrawn = {}
end

local function DrawLine(from,to,c)
    local line = Drawing.new("Line")
    line.From = from
    line.To = to
    line.Color = c or Color3.new(1, 1, 1)
    line.Thickness = 2
    line.Transparency = 1
    return line
end
local function DrawBox(minX,minY,maxX,maxY,c)
    local box = {}
    table.insert(box, DrawLine(Vector2.new(minX,minY), Vector2.new(maxX,minY),c))
    table.insert(box, DrawLine(Vector2.new(maxX,minY), Vector2.new(maxX,maxY),c))
    table.insert(box, DrawLine(Vector2.new(maxX,maxY), Vector2.new(minX,maxY),c))
    table.insert(box, DrawLine(Vector2.new(minX,maxY), Vector2.new(minX,minY),c))
    return box
end
local function DrawCircle(center, radius, c)
    local circ = Drawing.new("Circle")
    circ.Position = center
    circ.Radius = radius
    circ.Color = c or Color3.new(1,1,1)
    circ.Thickness = 2
    circ.Transparency = 1
    circ.NumSides = 32
    circ.Filled = false
    return circ
end

RunService:BindToRenderStep("ESP_PRO",201,function()
    if not hackEnabled.ESP then removeESP() return end
    removeESP()
    for _,ply in ipairs(Players:GetPlayers()) do
        if ply ~= LocalPlayer and ply.Character and ply.Character:FindFirstChild("HumanoidRootPart") and ply.Character:FindFirstChild("Head") and ply.Character:FindFirstChildOfClass("Humanoid") and ply.Character:FindFirstChildOfClass("Humanoid").Health > 0 and isEnemy(ply) then
            local hrp = ply.Character.HumanoidRootPart
            local head = ply.Character.Head
            local dist = (hrp.Position - Camera.CFrame.Position).Magnitude
            if dist < 400 then -- mesafe
                local parts = {}
                for _,p in ipairs({"Head","UpperTorso","LowerTorso","Torso","LeftLeg","LeftFoot","LeftLowerLeg","LeftUpperLeg","RightLeg","RightFoot","RightLowerLeg","RightUpperLeg"}) do
                    if ply.Character:FindFirstChild(p) then table.insert(parts, ply.Character:FindFirstChild(p)) end
                end
                local min, max = Vector3.new(math.huge,math.huge,math.huge), Vector3.new(-math.huge,-math.huge,-math.huge)
                for _,part in ipairs(parts) do
                    local pos = part.Position
                    min = Vector3.new(math.min(min.X,pos.X),math.min(min.Y,pos.Y),math.min(min.Z,pos.Z))
                    max = Vector3.new(math.max(max.X,pos.X),math.max(max.Y,pos.Y),math.max(max.Z,pos.Z))
                end
                local corners = {
                    Vector3.new(min.X,min.Y,min.Z),
                    Vector3.new(min.X,max.Y,min.Z),
                    Vector3.new(max.X,max.Y,max.Z),
                    Vector3.new(max.X,min.Y,max.Z)
                }
                local vecs = {}
                for i,v in ipairs(corners) do
                    local vp,onsc = Camera:WorldToViewportPoint(v)
                    if onsc and vp.Z > 0 then table.insert(vecs,Vector2.new(vp.X,vp.Y)) end
                end
                if #vecs > 0 then
                    local pminX,pminY,pmaxX,pmaxY = vecs[1].X,vecs[1].Y,vecs[1].X,vecs[1].Y
                    for _,v in ipairs(vecs) do
                        if v.X < pminX then pminX = v.X end
                        if v.X > pmaxX then pmaxX = v.X end
                        if v.Y < pminY then pminY = v.Y end
                        if v.Y > pmaxY then pmaxY = v.Y end
                    end
                    local box = DrawBox(pminX,pminY,pmaxX,pmaxY,Color3.new(1,1,1))
                    for _,l in ipairs(box) do table.insert(espDrawn,l) end
                end
                -- HEAD
                local headVP,headOn = Camera:WorldToViewportPoint(head.Position)
                if headOn and headVP.Z > 0 then
                    local r = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,head.Size.Y/1.33,0))
                    local rad = math.min(36, math.max(12, math.abs((Vector2.new(r.X,r.Y)-Vector2.new(headVP.X,headVP.Y)).Magnitude)))
                    local circ = DrawCircle(Vector2.new(headVP.X, headVP.Y), rad, Color3.new(1,1,1))
                    table.insert(espDrawn, circ)
                    table.insert(espDrawn, DrawLine(
                        Vector2.new(headVP.X, headVP.Y - rad),
                        Vector2.new(headVP.X, headVP.Y - rad * 1.15),
                        Color3.new(1,1,1)
                    ))
                end
                -- İskelet
                local function W2V(pos)
                    local vp,ons = Camera:WorldToViewportPoint(pos)
                    return Vector2.new(vp.X,vp.Y),ons and vp.Z>0
                end
                local utorso = ply.Character:FindFirstChild("UpperTorso") or ply.Character:FindFirstChild("Torso")
                local ltorso = ply.Character:FindFirstChild("LowerTorso")
                if utorso and ltorso then
                    local p1,on1 = W2V(utorso.Position)
                    local p2,on2 = W2V(ltorso.Position)
                    if on1 and on2 then table.insert(espDrawn, DrawLine(p1,p2,Color3.new(1,1,1))) end
                end
                if head and utorso then
                    local p1,on1 = W2V(head.Position)
                    local p2,on2 = W2V(utorso.Position)
                    if on1 and on2 then table.insert(espDrawn, DrawLine(p1,p2,Color3.new(1,1,1))) end
                end
                local rsh = ply.Character:FindFirstChild("RightUpperArm") or ply.Character:FindFirstChild("Right Arm")
                local rlow = ply.Character:FindFirstChild("RightLowerArm")
                local rhand = ply.Character:FindFirstChild("RightHand") or ply.Character:FindFirstChild("Right Arm")
                local lsh = ply.Character:FindFirstChild("LeftUpperArm") or ply.Character:FindFirstChild("Left Arm")
                local llow = ply.Character:FindFirstChild("LeftLowerArm")
                local lhand = ply.Character:FindFirstChild("LeftHand") or ply.Character:FindFirstChild("Left Arm")
                if utorso and rsh then
                    local p1,on1 = W2V(utorso.Position)
                    local p2,on2 = W2V(rsh.Position)
                    if on1 and on2 then table.insert(espDrawn, DrawLine(p1,p2,Color3.new(1,1,1))) end
                    if rlow then
                        local p3,on3 = W2V(rlow.Position)
                        if on2 and on3 then table.insert(espDrawn, DrawLine(p2,p3,Color3.new(1,1,1))) end
                        if rhand then
                            local p4,on4 = W2V(rhand.Position)
                            if on3 and on4 then table.insert(espDrawn, DrawLine(p3,p4,Color3.new(1,1,1))) end
                        end
                    end
                end
                if utorso and lsh then
                    local p1,on1 = W2V(utorso.Position)
                    local p2,on2 = W2V(lsh.Position)
                    if on1 and on2 then table.insert(espDrawn, DrawLine(p1,p2,Color3.new(1,1,1))) end
                    if llow then
                        local p3,on3 = W2V(llow.Position)
                        if on2 and on3 then table.insert(espDrawn, DrawLine(p2,p3,Color3.new(1,1,1))) end
                        if lhand then
                            local p4,on4 = W2V(lhand.Position)
                            if on3 and on4 then table.insert(espDrawn, DrawLine(p3,p4,Color3.new(1,1,1))) end
                        end
                    end
                end
                local rupper = ply.Character:FindFirstChild("RightUpperLeg") or ply.Character:FindFirstChild("Right Leg")
                local rlower = ply.Character:FindFirstChild("RightLowerLeg")
                local rfoot = ply.Character:FindFirstChild("RightFoot") or ply.Character:FindFirstChild("Right Leg")
                local lupper = ply.Character:FindFirstChild("LeftUpperLeg") or ply.Character:FindFirstChild("Left Leg")
                local llower = ply.Character:FindFirstChild("LeftLowerLeg")
                local lfoot = ply.Character:FindFirstChild("LeftFoot") or ply.Character:FindFirstChild("Left Leg")
                if ltorso and rupper then
                    local p1,on1 = W2V(ltorso.Position)
                    local p2,on2 = W2V(rupper.Position)
                    if on1 and on2 then table.insert(espDrawn, DrawLine(p1,p2,Color3.new(1,1,1))) end
                    if rlower then
                        local p3,on3 = W2V(rlower.Position)
                        if on2 and on3 then table.insert(espDrawn, DrawLine(p2,p3,Color3.new(1,1,1))) end
                        if rfoot then
                            local p4,on4 = W2V(rfoot.Position)
                            if on3 and on4 then table.insert(espDrawn, DrawLine(p3,p4,Color3.new(1,1,1))) end
                        end
                    end
                end
                if ltorso and lupper then
                    local p1,on1 = W2V(ltorso.Position)
                    local p2,on2 = W2V(lupper.Position)
                    if on1 and on2 then table.insert(espDrawn, DrawLine(p1,p2,Color3.new(1,1,1))) end
                    if llower then
                        local p3,on3 = W2V(llower.Position)
                        if on2 and on3 then table.insert(espDrawn, DrawLine(p2,p3,Color3.new(1,1,1))) end
                        if lfoot then
                            local p4,on4 = W2V(lfoot.Position)
                            if on3 and on4 then table.insert(espDrawn, DrawLine(p3,p4,Color3.new(1,1,1))) end
                        end
                    end
                end
            end
        end
    end
end)
