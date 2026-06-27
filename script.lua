-- Hile Menü V3 — SÜPER SÜRÜM SON DOKUNUŞ: ESP normal roblox karakteri etrafında, sadece yeterince yakındakilerde düzgün box, iskelet, kafa/baş çizimi var; diğer hileler bozulmadı!

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

-- Noclip: Tüm BASEPART'lar, her frame Collide=false, %100 kafa ve vücut geçer!
RunService.Stepped:Connect(function()
    if hackEnabled.Noclip and LocalPlayer.Character then
        for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    elseif LocalPlayer.Character then
        for _,v in ipairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
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

-- GODMODE: Ölümsüzlük/oto can
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

-- SPINBOT: MoveDirection ile YÜRÜRKEN/KOŞARKEN tam çalışıyor!
RunService.RenderStepped:Connect(function()
    if hackEnabled.Spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0,math.rad(24),0)
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

-- ESP: YAKINDAKİLERDE klasik roblox karakter (torso+head) etrafında kutu, skeleton, kafa/baş — Hepsi beyaz. Diğerleri çizilmiyor!
local espDrawn = {}
local function removeESP()
    for _, obj in pairs(espDrawn) do
        if obj.Remove then obj:Remove() end
        if typeof(obj) == "table" then
            for _, o in ipairs(obj) do if o.Remove then o:Remove() end end
        end
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
local function DrawBox(v1,v2,c)
    local box = {}
    table.insert(box, DrawLine(v1, Vector2.new(v2.X, v1.Y),c))
    table.insert(box, DrawLine(Vector2.new(v2.X, v1.Y), v2,c))
    table.insert(box, DrawLine(v2, Vector2.new(v1.X, v2.Y),c))
    table.insert(box, DrawLine(Vector2.new(v1.X, v2.Y), v1,c))
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

RunService:BindToRenderStep("ESP_V2",200,function()
    if not hackEnabled.ESP then removeESP() return end
    removeESP()
    for _,ply in ipairs(Players:GetPlayers()) do
        if ply ~= LocalPlayer and ply.Character and ply.Character:FindFirstChild("HumanoidRootPart") and ply.Character:FindFirstChild("Head") and ply.Character:FindFirstChildOfClass("Humanoid") and ply.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local hrp = ply.Character.HumanoidRootPart
            local head = ply.Character.Head
            local hum = ply.Character:FindFirstChildOfClass("Humanoid")
            local dist = (hrp.Position - Camera.CFrame.Position).Magnitude
            if dist < 200 then  -- Yeterli yakın olanlar (200-stud altı)
                local torso = ply.Character:FindFirstChild("Torso") or ply.Character:FindFirstChild("UpperTorso") or ply.Character:FindFirstChild("LowerTorso")
                if torso and head then
                    -- Kutu: BAŞ (head) ile TORSO gibi gövdeyi kapsayan dikdörtgen yap
                    local sizeY = (torso.Position.Y - head.Position.Y)
                    local wb1, ons1 = Camera:WorldToViewportPoint(head.Position + Vector3.new(-1,0.2,0))
                    local wb2, ons2 = Camera:WorldToViewportPoint(torso.Position + Vector3.new(1,-1,0))
                    if ons1 and ons2 and wb1.Z > 0 and wb2.Z > 0 then
                        local p1 = Vector2.new(wb1.X, wb1.Y)
                        local p2 = Vector2.new(wb2.X, wb2.Y)
                        local minY,maxY = math.min(p1.Y,p2.Y), math.max(p1.Y,p2.Y)
                        local minX,maxX = math.min(p1.X,p2.X), math.max(p1.X,p2.X)
                        -- Player Box
                        local box = DrawBox(Vector2.new(minX,minY), Vector2.new(maxX,maxY), Color3.new(1,1,1))
                        for _,l in ipairs(box) do table.insert(espDrawn,l) end

                        -- HEAD CIRCLE
                        local center, onhead = Camera:WorldToViewportPoint(head.Position)
                        if onhead and center.Z > 0 then
                            local r = math.abs(Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0)).Y - center.Y)
                            r = math.clamp(r, 11, 28)
                            local circ = DrawCircle(Vector2.new(center.X, center.Y), r, Color3.new(1,1,1))
                            table.insert(espDrawn,circ)

                            -- Kafatası/ Skull cross yukarıya
                            local skullT = DrawLine(
                                Vector2.new(center.X,center.Y - r),
                                Vector2.new(center.X,center.Y - r*1.7),
                                Color3.new(1,1,1)
                            )
                            table.insert(espDrawn,skullT)
                        end

                        -- SKELETON (torso-head, torso-kollar, torso-bacaklar)
                        local shoulderR = ply.Character:FindFirstChild("RightUpperArm") or ply.Character:FindFirstChild("Right Arm")
                        local shoulderL = ply.Character:FindFirstChild("LeftUpperArm") or ply.Character:FindFirstChild("Left Arm")
                        local handR = ply.Character:FindFirstChild("RightHand") or ply.Character:FindFirstChild("Right Arm")
                        local handL = ply.Character:FindFirstChild("LeftHand") or ply.Character:FindFirstChild("Left Arm")
                        local legR = ply.Character:FindFirstChild("RightUpperLeg") or ply.Character:FindFirstChild("Right Leg")
                        local legL = ply.Character:FindFirstChild("LeftUpperLeg") or ply.Character:FindFirstChild("Left Leg")
                        local footR = ply.Character:FindFirstChild("RightFoot") or ply.Character:FindFirstChild("Right Leg")
                        local footL = ply.Character:FindFirstChild("LeftFoot") or ply.Character:FindFirstChild("Left Leg")

                        local function W2V(pos)
                            local v,ok=Camera:WorldToViewportPoint(pos)
                            return Vector2.new(v.X,v.Y),ok and v.Z>0
                        end

                        if torso and head then
                            local h,hh = W2V(head.Position)
                            local t,tt = W2V(torso.Position)
                            if hh and tt then table.insert(espDrawn,DrawLine(h,t,Color3.new(1,1,1))) end
                        end
                        if torso and shoulderR then
                            local t,tt = W2V(torso.Position)
                            local s,ss = W2V(shoulderR.Position)
                            if tt and ss then table.insert(espDrawn,DrawLine(t,s,Color3.new(1,1,1))) end
                        end
                        if torso and shoulderL then
                            local t,tt = W2V(torso.Position)
                            local s,ss = W2V(shoulderL.Position)
                            if tt and ss then table.insert(espDrawn,DrawLine(t,s,Color3.new(1,1,1))) end
                        end
                        if shoulderR and handR then
                            local s,ss = W2V(shoulderR.Position)
                            local h,hh = W2V(handR.Position)
                            if ss and hh then table.insert(espDrawn,DrawLine(s,h,Color3.new(1,1,1))) end
                        end
                        if shoulderL and handL then
                            local s,ss = W2V(shoulderL.Position)
                            local h,hh = W2V(handL.Position)
                            if ss and hh then table.insert(espDrawn,DrawLine(s,h,Color3.new(1,1,1))) end
                        end
                        if torso and hrp then
                            local t,tt = W2V(torso.Position)
                            local r,rr = W2V(hrp.Position)
                            if tt and rr then table.insert(espDrawn,DrawLine(t,r,Color3.new(1,1,1))) end
                        end
                        if hrp and legR then
                            local r,rr = W2V(hrp.Position)
                            local l,ll = W2V(legR.Position)
                            if rr and ll then table.insert(espDrawn,DrawLine(r,l,Color3.new(1,1,1))) end
                        end
                        if hrp and legL then
                            local r,rr = W2V(hrp.Position)
                            local l,ll = W2V(legL.Position)
                            if rr and ll then table.insert(espDrawn,DrawLine(r,l,Color3.new(1,1,1))) end
                        end
                        if legR and footR then
                            local l,ll = W2V(legR.Position)
                            local f,ff = W2V(footR.Position)
                            if ll and ff then table.insert(espDrawn,DrawLine(l,f,Color3.new(1,1,1))) end
                        end
                        if legL and footL then
                            local l,ll = W2V(legL.Position)
                            local f,ff = W2V(footL.Position)
                            if ll and ff then table.insert(espDrawn,DrawLine(l,f,Color3.new(1,1,1))) end
                        end
                    end
                end
            end
        end
    end
end)
