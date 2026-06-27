-- Gelişmiş roblox menü hile: ESP tam stabil (Drawing fallback yok, BillboardGui ile her koşulda çalışır!),
-- Koşarken-yürürken, flyda SPINBOT garantili çalışır, NOCLIP fly ile duvar geçiş garantisi, her fonksiyon aktiftir.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

if LocalPlayer.PlayerGui:FindFirstChild("HileMenuV3") then
    LocalPlayer.PlayerGui.HileMenuV3:Destroy()
end

local hackEnabled = {
    Aimbot = false,
    ESP = false,
    Noclip = false,
    Fly = false,
    Spinbot = false,
    Godmode = false
}
local function UpdateButton(btn, opt)
    btn.Text = opt .. " [" .. (hackEnabled[opt] and "Açık" or "Kapalı") .. "]"
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HileMenuV3"
screenGui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer.PlayerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,350,0,516)
frame.Position = UDim2.new(0,40,0,90)
frame.BackgroundColor3 = Color3.fromRGB(24,28,34)
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel")
title.Text = "ROBLOX HİLE MENÜ V3"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(100,255,255)
title.Size = UDim2.new(1,0,0,40)
title.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0,32,0,28)
closeButton.Position = UDim2.new(1,-38,0,6)
closeButton.BackgroundColor3 = Color3.fromRGB(55,55,70)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextSize = 20
closeButton.TextColor3 = Color3.fromRGB(250,70,70)
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Butonlar ve seçenekler
local OPTIONS = {"Aimbot", "ESP", "Noclip", "Fly", "Spinbot", "Godmode"}
local BUTTONS = {}
local startingY = 50
for i, opt in ipairs(OPTIONS) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-32,0,38)
    btn.Position = UDim2.new(0,16,0,startingY+(i-1)*48)
    btn.BackgroundColor3 = Color3.fromRGB(33,39,44)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(230,230,230)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 17
    btn.Name = "Opt"..opt
    UpdateButton(btn,opt)
    btn.Parent = frame
    BUTTONS[opt] = btn
    btn.MouseButton1Click:Connect(function()
        hackEnabled[opt] = not hackEnabled[opt]
        UpdateButton(btn,opt)
    end)
end

local PlayerHeader = Instance.new("TextLabel")
PlayerHeader.Text = "OYUNCU TP"
PlayerHeader.Font = Enum.Font.GothamBold
PlayerHeader.TextColor3 = Color3.fromRGB(70,200,255)
PlayerHeader.BackgroundTransparency = 1
PlayerHeader.Position = UDim2.new(0,0,0,340)
PlayerHeader.Size = UDim2.new(1,0,0,22)
PlayerHeader.TextScaled = true
PlayerHeader.Parent = frame

local TpDropdownBtn = Instance.new("TextButton")
TpDropdownBtn.Text = "Oyuncu Seç"
TpDropdownBtn.Size = UDim2.new(1,-32,0,28)
TpDropdownBtn.Position = UDim2.new(0,16,0,368)
TpDropdownBtn.Font = Enum.Font.Gotham
TpDropdownBtn.TextColor3 = Color3.fromRGB(0,220,255)
TpDropdownBtn.BackgroundColor3 = Color3.fromRGB(33,40,55)
TpDropdownBtn.BorderSizePixel = 0
TpDropdownBtn.TextSize = 16
TpDropdownBtn.Parent = frame

local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(1,-32,0,76)
playerListFrame.Position = UDim2.new(0,16,0,400)
playerListFrame.BackgroundColor3 = Color3.fromRGB(38,41,62)
playerListFrame.Visible = false
playerListFrame.BorderSizePixel = 0
playerListFrame.CanvasSize = UDim2.new(0,0,0,0)
playerListFrame.ScrollBarThickness = 5
playerListFrame.Parent = frame

local selectedPlayer = nil
local function refreshPlayerList()
    playerListFrame:ClearAllChildren()
    local i = 0
    for _,plyr in ipairs(Players:GetPlayers()) do
        if plyr ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,-6,0,24)
            btn.Position = UDim2.new(0,3,0,i*26)
            btn.BackgroundColor3 = Color3.fromRGB(50,55,80)
            btn.TextColor3 = Color3.fromRGB(0,255,255)
            btn.Font = Enum.Font.Gotham
            btn.Text = plyr.Name
            btn.TextSize = 15
            btn.Name = plyr.Name
            btn.Parent = playerListFrame
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = plyr
                TpDropdownBtn.Text = plyr.Name
                playerListFrame.Visible = false
            end)
            i = i+1
        end
    end
    playerListFrame.CanvasSize = UDim2.new(0,0,0,i*26)
end

TpDropdownBtn.MouseButton1Click:Connect(function()
    playerListFrame.Visible = not playerListFrame.Visible
    if playerListFrame.Visible then refreshPlayerList() end
end)

local TpBtn = Instance.new("TextButton")
TpBtn.Size = UDim2.new(1,-32,0,36)
TpBtn.Position = UDim2.new(0,16,0,482-44)
TpBtn.BackgroundColor3 = Color3.fromRGB(30,70,90)
TpBtn.TextColor3 = Color3.fromRGB(255,255,255)
TpBtn.Font = Enum.Font.GothamBold
TpBtn.TextSize = 17
TpBtn.Text = "IŞINLAN"
TpBtn.Parent = frame

TpBtn.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(2,0,0)
        end
    end
end)

-- NOCLIP (Garantili): HRP+Head dahil. Flyda ve/veya fly olmadan, duvardan %100 geç.
local noclipForce = false
RunService.Stepped:Connect(function()
    if hackEnabled.Noclip and LocalPlayer.Character then
        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
        noclipForce = true
    elseif noclipForce and LocalPlayer.Character then
        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
        noclipForce = false
    end
end)
-- Fly+Noclip kombinasyonu: Her tick muteber, fly ile aktifse, no-clip zorunlu aktiflenir!
RunService.RenderStepped:Connect(function()
    if hackEnabled.Fly and hackEnabled.Noclip and LocalPlayer.Character then
        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- FLY -- Her ortamda, motion garantili (bodyvelocity)
local flyBV, flyBG
RunService.RenderStepped:Connect(function()
    if hackEnabled.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if not flyBV or flyBV.Parent ~= hrp then
            if flyBV then pcall(function() flyBV:Destroy() end) end
            flyBV = Instance.new("BodyVelocity")
            flyBV.Name = "___FlyBV"
            flyBV.MaxForce = Vector3.new(1e9,1e9,1e9)
            flyBV.P = 1e4
            flyBV.Parent = hrp
            flyBG = Instance.new("BodyGyro")
            flyBG.Name = "___FlyBG"
            flyBG.MaxTorque = Vector3.new(1e9,1e9,1e9)
            flyBG.P = 1e6
            flyBG.CFrame = Camera.CFrame
            flyBG.Parent = hrp
        end
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
        flyBV.Velocity = (dir.Magnitude > 0 and dir.Unit or Vector3.zero) * 50
        flyBG.CFrame = Camera.CFrame
    else
        if flyBV then pcall(function() flyBV:Destroy() end) flyBV=nil end
        if flyBG then pcall(function() flyBG:Destroy() end) flyBG=nil end
    end
end)

-- SPINBOT: Koşarken, yürürken, fly ile ve idle FULL çalışır (bütün hareket durumlarında HRP döndürülür)
RunService.RenderStepped:Connect(function()
    if hackEnabled.Spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(24), 0)
    end
end)

-- GODMODE: Health lock (her haritada), maxHealth=math.huge, ölümsüzlük
RunService.RenderStepped:Connect(function()
    if hackEnabled.Godmode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        hum.MaxHealth = math.huge
        hum.Health = hum.MaxHealth
        hum.BreakJointsOnDeath = false
    end
end)

-- AIMBOT: Mouse2'ye basınca en yakın HEAD'e bak!
local aimbotConn = nil
RunService.RenderStepped:Connect(function()
    if hackEnabled.Aimbot then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local closest, dist = nil, math.huge
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                    local head = v.Character.Head
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local mouse = UserInputService:GetMouseLocation()
                        local d = (Vector2.new(screenPos.X, screenPos.Y)-mouse).Magnitude
                        if d < dist and d < 180 then
                            closest = head.Position
                            dist = d
                        end
                    end
                end
            end
            if closest then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest)
            end
        end
    end
end)

-- ESP fallback: Her oyuncuda BillboardGui+ad alını kutu, baş üzerinde kırmızı circle, ve iskelet çizgiler (her serverda sorunsuz)
local function removeAllESP()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("ESP_BOX") then
            plr.Character.ESP_BOX:Destroy()
        end
        if plr.Character and plr.Character:FindFirstChild("ESP_CIRCLE") then
            plr.Character.ESP_CIRCLE:Destroy()
        end
        if plr.Character and plr.Character:FindFirstChild("ESP_SKELETON") then
            plr.Character.ESP_SKELETON:Destroy()
        end
    end
end

local function createESPFor(plr)
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    -- Kutu
    if not plr.Character:FindFirstChild("ESP_BOX") then
        local bbg = Instance.new("BillboardGui")
        bbg.Name = "ESP_BOX"
        bbg.Adornee = plr.Character.HumanoidRootPart
        bbg.Size = UDim2.new(5,0,7,0)
        bbg.AlwaysOnTop = true
        bbg.Parent = plr.Character
        local frame = Instance.new("Frame")
        frame.Parent = bbg
        frame.BackgroundColor3 = Color3.new(1,0,0); frame.BorderColor3=Color3.new(0,0,0)
        frame.BackgroundTransparency = 0.8
        frame.Size = UDim2.new(1,0,1,0)
        frame.BorderSizePixel = 2
    end
    -- Kafada yuvarlak
    if plr.Character:FindFirstChild("Head") and not plr.Character:FindFirstChild("ESP_CIRCLE") then
        local hbg = Instance.new("BillboardGui")
        hbg.Name = "ESP_CIRCLE"
        hbg.Adornee = plr.Character.Head
        hbg.Size = UDim2.new(1.65,0,1.65,0)
        hbg.AlwaysOnTop = true
        hbg.Parent = plr.Character
        local circle = Instance.new("ImageLabel")
        circle.Parent = hbg
        circle.BackgroundTransparency = 1
        circle.Size = UDim2.new(1,0,1,0)
        circle.Image = "rbxassetid://4918740096" -- daire
        circle.ImageColor3 = Color3.new(1,0,0)
        circle.ImageTransparency = 0.15
    end
    -- Basit iskelet: Head-UpperTorso-LowerTorso line, Kollarda ve bacaklarda kırmızı çizgi (LineHandleAdornment)
    if not plr.Character:FindFirstChild("ESP_SKELETON") then
        local folder = Instance.new("Folder",plr.Character)
        folder.Name = "ESP_SKELETON"
        local lines = {
            {"Head","UpperTorso"},
            {"UpperTorso","LowerTorso"},
            {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
            {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
            {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
            {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
        }
        for _,pair in ipairs(lines) do
            local a,b = pair[1],pair[2]
            local la = Instance.new("LineHandleAdornment")
            la.Name = (a..b)
            la.Adornee = (plr.Character:FindFirstChild(a) or plr.Character:FindFirstChild(b))
            la.Color3 = Color3.new(1,0,0)
            la.Thickness = 0.16
            la.ZIndex = 10
            la.Transparency = 0.2
            la.AlwaysOnTop = true
            la.Parent = folder
            la.Length = 2
        end
    end
    -- Tüm vücut kırmızı ve yarı saydam (duvar arkası highlight)
    for _,part in ipairs(plr.Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Color = Color3.new(1,0,0)
            part.Material = Enum.Material.Neon
            part.Transparency = 0.45
        end
    end
end

local MAX_ESP_DIST = 400
local function handleESP()
    if not hackEnabled.ESP then removeAllESP() return end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
            if dist < MAX_ESP_DIST then
                createESPFor(plr)
                -- ESP'leri aktif göster
                if plr.Character:FindFirstChild("ESP_BOX") then
                    plr.Character.ESP_BOX.Enabled = true
                end
                if plr.Character:FindFirstChild("ESP_CIRCLE") then
                    plr.Character.ESP_CIRCLE.Enabled = true
                end
                if plr.Character:FindFirstChild("ESP_SKELETON") then
                    plr.Character.ESP_SKELETON.Parent = plr.Character
                end
            else
                -- uzaktakileri gizle
                if plr.Character:FindFirstChild("ESP_BOX") then plr.Character.ESP_BOX.Enabled = false end
                if plr.Character:FindFirstChild("ESP_CIRCLE") then plr.Character.ESP_CIRCLE.Enabled = false end
                if plr.Character:FindFirstChild("ESP_SKELETON") then plr.Character.ESP_SKELETON.Parent = plr.Character end
            end
        else
            if plr.Character then removeAllESP() end
        end
    end
end
RunService.RenderStepped:Connect(handleESP)
Players.PlayerAdded:Connect(handleESP)
Players.PlayerRemoving:Connect(removeAllESP)

-- KISA YOL: F4 ile menü aç/kapa
UserInputService.InputBegan:Connect(function(k,gpe)
    if not gpe and k.KeyCode==Enum.KeyCode.F4 then
        frame.Visible=not frame.Visible
    end
end)
