-- Hile Menü V3 — ESP kutulu & iskelet+baş, kutular oyuncu boyutunda, SPINBOT koşarken/yürürken çalışır, NOCLIP ve AIMBOT DÜZGÜN, DELTA için.

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

-- NOCLIP: Artık head, body tüm parçalar CanCollide=false
local noclipToggled = false
RunService.Stepped:Connect(function()
    if hackEnabled.Noclip and LocalPlayer.Character then
        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    elseif LocalPlayer.Character then
        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
end)

-- FLY -- BodyVelocity, BodyGyro ile klasik uçuş
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

-- GODMODE: Sürekli can yenileme ve Humanoid ayarlarıyla tam ölümsüzlük.
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

-- SPINBOT: YÜRÜRKEN/KOŞARKEN DAİMA ÇALIŞSIN, HumanoidMoveDirection ile
RunService.RenderStepped:Connect(function()
    if hackEnabled.Spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            -- Koşarken/Yürürken de çalışsın
            if hum.MoveDirection.Magnitude > 0 or hum.MoveDirection.Magnitude==0 then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0,math.rad(24),0)
            end
        end
    end
end)

-- AIMBOT: En yakın oyuncunun kafasına
local aimbotFOV = 120
RunService.RenderStepped:Connect(function()
    if hackEnabled.Aimbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local closest, minDist = nil, math.huge
        for _, ply in pairs(Players:GetPlayers()) do
            if ply ~= LocalPlayer and ply.Character and ply.Character:FindFirstChild("Head") and ply.Character:FindFirstChildOfClass("Humanoid") and ply.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local head = ply.Character.Head
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(head.Position)
                if OnScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                    if dist < aimbotFOV and dist < minDist then
                        minDist = dist
                        closest = head
                    end
                end
            end
        end
        if closest then
            local headPos = closest.Position
            local cam = workspace.CurrentCamera
            local direction = (headPos - cam.CFrame.Position).Unit
            cam.CFrame = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + direction)
        end
    end
end)

-- ESP: Kutu BOYUTU OYUNCU BOYUTUNDA ve iskelet + kafa + kafatası, Uzaktakiler yok.
local espObjects = {}
local function removeESP()
    for item, _ in pairs(espObjects) do
        if item and item.Remove then item:Remove() end
    end
    espObjects = {}
end

local function DrawLine(from,to)
    local line = Drawing.new("Line")
    line.From = from
    line.To = to
    line.Color = Color3.new(1, 1, 1)
    line.Thickness = 2
    line.Transparency = 1
    return line
end
local function DrawBox(v1,v2)
    -- v1 = Vector2: topleft, v2 = Vector2: bottomright
    local box = {}
    table.insert(box, DrawLine(v1, Vector2.new(v2.X, v1.Y)))
    table.insert(box, DrawLine(Vector2.new(v2.X, v1.Y), v2))
    table.insert(box, DrawLine(v2, Vector2.new(v1.X, v2.Y)))
    table.insert(box, DrawLine(Vector2.new(v1.X, v2.Y), v1))
    return box
end
local function DrawCircle(center, radius)
    local circ = Drawing.new("Circle")
    circ.Position = center
    circ.Radius = radius
    circ.Color = Color3.new(1,1,1)
    circ.Thickness = 2
    circ.Transparency = 1
    circ.NumSides = 32
    circ.Filled = false
    return circ
end

RunService:BindToRenderStep("ESPHack", 199, function()
    if not hackEnabled.ESP then removeESP() return end
    removeESP()
    for _,ply in ipairs(Players:GetPlayers()) do
        if ply ~= LocalPlayer and ply.Character and ply.Character:FindFirstChild("HumanoidRootPart") and ply.Character:FindFirstChild("Head") and ply.Character:FindFirstChildOfClass("Humanoid") then
            local hrp = ply.Character.HumanoidRootPart
            local head = ply.Character.Head
            local hum = ply.Character:FindFirstChildOfClass("Humanoid")
            if (hrp.Position - Camera.CFrame.Position).Magnitude < 250 then -- uzak kısıtlama
                local TL = Camera:WorldToViewportPoint(head.Position + Vector3.new(-0.9,0.5,-0.85)*hum.HipWidth)
                local BR = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(-0.9,3,0.85)*hum.HipWidth)
                if not TL.Z or not BR.Z or TL.Z < 0 or BR.Z < 0 then continue end

                local topleft = Vector2.new(TL.X, TL.Y)
                local bottomright = Vector2.new(BR.X, BR.Y)
                local box = DrawBox(topleft, bottomright)
                for _, b in ipairs(box) do espObjects[b] = true end

                -- Kafa Çember + Kafatası (üstte ve çaprazda minik çizgiler)
                local headScreen, hOnScreen = Camera:WorldToViewportPoint(head.Position)
                if hOnScreen then
                    local r = math.abs(Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0)).Y - headScreen.Y)
                    r = math.clamp(r, 11, 28)
                    local circ = DrawCircle(Vector2.new(headScreen.X, headScreen.Y), r)
                    espObjects[circ] = true

                    -- Kafatası Çizgileri
                    local skullT = Drawing.new("Line")
                    skullT.From = Vector2.new(headScreen.X,headScreen.Y - r)
                    skullT.To = Vector2.new(headScreen.X,headScreen.Y - r - r*0.6)
                    skullT.Color, skullT.Thickness, skullT.Transparency = Color3.new(1,1,1), 2, 1
                    espObjects[skullT]=true

                    local skullL = Drawing.new("Line")
                    skullL.From = Vector2.new(headScreen.X-r*0.7, headScreen.Y-r*0.4)
                    skullL.To   = Vector2.new(headScreen.X-r*1.3, headScreen.Y-r*0.7)
                    skullL.Color, skullL.Thickness, skullL.Transparency = Color3.new(1,1,1), 2, 1
                    espObjects[skullL]=true

                    local skullR = Drawing.new("Line")
                    skullR.From = Vector2.new(headScreen.X+r*0.7, headScreen.Y-r*0.4)
                    skullR.To   = Vector2.new(headScreen.X+r*1.3, headScreen.Y-r*0.7)
                    skullR.Color, skullR.Thickness, skullR.Transparency = Color3.new(1,1,1), 2, 1
                    espObjects[skullR]=true
                end
                -- İskelet
                local function W2V(pos) local v,ok=Camera:WorldToViewportPoint(pos) return Vector2.new(v.X,v.Y),ok end
                local root = hrp
                local headPos,_=W2V(head.Position)
                local torso = ply.Character:FindFirstChild("Torso") or ply.Character:FindFirstChild("UpperTorso") or ply.Character:FindFirstChild("LowerTorso")
                local upperTorso = ply.Character:FindFirstChild("UpperTorso")
                local lowerTorso = ply.Character:FindFirstChild("LowerTorso")
                local rsho = ply.Character:FindFirstChild("RightUpperArm") or ply.Character:FindFirstChild("Right Arm")
                local lsho = ply.Character:FindFirstChild("LeftUpperArm") or ply.Character:FindFirstChild("Left Arm")
                local rleg = ply.Character:FindFirstChild("RightUpperLeg") or ply.Character:FindFirstChild("Right Leg")
                local lleg = ply.Character:FindFirstChild("LeftUpperLeg") or ply.Character:FindFirstChild("Left Leg")
                local rfoot = ply.Character:FindFirstChild("RightFoot") or ply.Character:FindFirstChild("Right Leg")
                local lfoot = ply.Character:FindFirstChild("LeftFoot") or ply.Character:FindFirstChild("Left Leg")
                local tvec,_ = torso and W2V(torso.Position) or W2V(hrp.Position)
                if upperTorso and lowerTorso then
                    local uTorso,_ = W2V(upperTorso.Position)
                    local lTorso,_ = W2V(lowerTorso.Position)
                    espObjects[DrawLine(headPos, uTorso)] = true
                    espObjects[DrawLine(uTorso,lTorso)] = true
                    espObjects[DrawLine(lTorso,W2V(hrp.Position))] = true
                else
                    espObjects[DrawLine(headPos, tvec)] = true
                    espObjects[DrawLine(tvec, W2V(hrp.Position))] = true
                end
                if rsho then espObjects[DrawLine(tvec, W2V(rsho.Position))]=true end
                if lsho then espObjects[DrawLine(tvec, W2V(lsho.Position))]=true end
                if rleg then espObjects[DrawLine(W2V(hrp.Position), W2V(rleg.Position))]=true end
                if lleg then espObjects[DrawLine(W2V(hrp.Position), W2V(lleg.Position))]=true end
                if rfoot and rleg then espObjects[DrawLine(W2V(rleg.Position),W2V(rfoot.Position))]=true end
                if lfoot and lleg then espObjects[DrawLine(W2V(lleg.Position),W2V(lfoot.Position))]=true end
            end
        end
    end
end)
