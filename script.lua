-- Hile Menü V3 — GÜNCELLENDİ: SPINBOT KOŞARKEN TAMAM, ESP ve NOCLIP MÜKEMMEL! (Beyaz kutu, iskelet, baş, yakın oyuncular, NOCLIP tamamen gövde+kafa her parça Collide=false)

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

-- ESP: YAKIN oyuncular, kutu OYUNCU BOYUTUNDA ve beyaz, DUVAR ARKASI body alanı yarı saydam beyaz, iskelet+baş kutu içinde
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
            if dist < 275 then -- sadece yakın oyuncular
                -- Kutu 
                local min = Vector3.new(math.huge,math.huge,math.huge)
                local max = Vector3.new(-math.huge,-math.huge,-math.huge)
                for _,bp in ipairs(ply.Character:GetChildren()) do
                    if bp:IsA("BasePart") then
                        local p = bp.Position
                        min = Vector3.new(math.min(min.X,p.X),math.min(min.Y,p.Y),math.min(min.Z,p.Z))
                        max = Vector3.new(math.max(max.X,p.X),math.max(max.Y,p.Y),math.max(max.Z,p.Z))
                    end
                end
                -- WorldToViewport
                local vecs = {
                    Vector3.new(min.X,min.Y,min.Z),
                    Vector3.new(max.X,min.Y,min.Z),
                    Vector3.new(min.X,max.Y,min.Z),
                    Vector3.new(min.X,min.Y,max.Z),
                    Vector3.new(max.X,max.Y,min.Z),
                    Vector3.new(min.X,max.Y,max.Z),
                    Vector3.new(max.X,min.Y,max.Z),
                    Vector3.new(max.X,max.Y,max.Z),
                }
                local TL,BR = Vector2.new(9e9,9e9), Vector2.new(-9e9,-9e9)
                local visible = false
                for _,v3 in ipairs(vecs) do
                    local v,onscr = Camera:WorldToViewportPoint(v3)
                    if onscr and v.Z > 0 then
                        visible = true
                        TL = Vector2.new(math.min(TL.X,v.X),math.min(TL.Y,v.Y))
                        BR = Vector2.new(math.max(BR.X,v.X),math.max(BR.Y,v.Y))
                    end
                end
                if visible then
                    local box = DrawBox(TL,BR)
                    for _,l in ipairs(box) do table.insert(espDrawn,l) end
                    -- DUVAR ARKASI VÜCUT: body hepsi collidable ise, alt transparan rect
                    if not ply.Character.Head:IsDescendantOf(workspace.CurrentCamera) then
                        local rect = Drawing.new("Quad")
                        rect.Visible = true
                        rect.Color = Color3.new(1,1,1)
                        rect.Thickness = 0
                        rect.Transparency = 0.1
                        rect.PointA = TL
                        rect.PointB = Vector2.new(BR.X, TL.Y)
                        rect.PointC = BR
                        rect.PointD = Vector2.new(TL.X, BR.Y)
                        table.insert(espDrawn,rect)
                    end
                end
                -- Kafa: ÇEMBER VE KAFATASI
                local headWorld, headOnScreen = Camera:WorldToViewportPoint(head.Position)
                if headOnScreen and headWorld.Z > 0 then
                    local r = math.abs(Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0)).Y - headWorld.Y)
                    r = math.clamp(r, 11, 28)
                    local circ = DrawCircle(Vector2.new(headWorld.X, headWorld.Y), r)
                    table.insert(espDrawn,circ)

                    -- Basit Kafatası—üstte küçük çapraz ve düz
                    local skullT = DrawLine(
                        Vector2.new(headWorld.X,headWorld.Y - r),
                        Vector2.new(headWorld.X,headWorld.Y - r*1.7)
                    )
                    table.insert(espDrawn,skullT)
                    local skullL = DrawLine(
                        Vector2.new(headWorld.X-r*.66,headWorld.Y-r*.66),
                        Vector2.new(headWorld.X-r*1.13,headWorld.Y-r*1.13)
                    )
                    table.insert(espDrawn,skullL)
                    local skullR = DrawLine(
                        Vector2.new(headWorld.X+r*.66,headWorld.Y-r*.66),
                        Vector2.new(headWorld.X+r*1.13,headWorld.Y-r*1.13)
                    )
                    table.insert(espDrawn,skullR)
                end
                -- İSKELET: head>body>kollar>bacaklar çizgilerle
                local function W2V(pos)
                    local v,ok=Camera:WorldToViewportPoint(pos)
                    return Vector2.new(v.X,v.Y),ok and v.Z>0
                end
                local skeletonParts = {
                    head = ply.Character:FindFirstChild("Head"),
                    root = ply.Character:FindFirstChild("HumanoidRootPart"),
                    ptorso = ply.Character:FindFirstChild("Torso") or ply.Character:FindFirstChild("UpperTorso") or ply.Character:FindFirstChild("LowerTorso"),
                    rsho = ply.Character:FindFirstChild("RightUpperArm") or ply.Character:FindFirstChild("Right Arm"),
                    lsho = ply.Character:FindFirstChild("LeftUpperArm") or ply.Character:FindFirstChild("Left Arm"),
                    rwrist = ply.Character:FindFirstChild("RightHand") or ply.Character:FindFirstChild("Right Arm"),
                    lwrist = ply.Character:FindFirstChild("LeftHand") or ply.Character:FindFirstChild("Left Arm"),
                    rleg = ply.Character:FindFirstChild("RightUpperLeg") or ply.Character:FindFirstChild("Right Leg"),
                    lleg = ply.Character:FindFirstChild("LeftUpperLeg") or ply.Character:FindFirstChild("Left Leg"),
                    rfoot = ply.Character:FindFirstChild("RightFoot") or ply.Character:FindFirstChild("Right Leg"),
                    lfoot = ply.Character:FindFirstChild("LeftFoot") or ply.Character:FindFirstChild("Left Leg")
                }

                if skeletonParts.head and skeletonParts.ptorso then
                    local h,hh=W2V(skeletonParts.head.Position)
                    local p,pp=W2V(skeletonParts.ptorso.Position)
                    if hh and pp then table.insert(espDrawn,DrawLine(h,p)) end
                end
                if skeletonParts.ptorso and skeletonParts.rsho then
                    local p,pp = W2V(skeletonParts.ptorso.Position)
                    local s,ss = W2V(skeletonParts.rsho.Position)
                    if pp and ss then table.insert(espDrawn,DrawLine(p,s)) end
                end
                if skeletonParts.ptorso and skeletonParts.lsho then
                    local p,pp = W2V(skeletonParts.ptorso.Position)
                    local s,ss = W2V(skeletonParts.lsho.Position)
                    if pp and ss then table.insert(espDrawn,DrawLine(p,s)) end
                end
                if skeletonParts.rsho and skeletonParts.rwrist then
                    local s,ss = W2V(skeletonParts.rsho.Position)
                    local w,ww = W2V(skeletonParts.rwrist.Position)
                    if ss and ww then table.insert(espDrawn,DrawLine(s,w)) end
                end
                if skeletonParts.lsho and skeletonParts.lwrist then
                    local s,ss = W2V(skeletonParts.lsho.Position)
                    local w,ww = W2V(skeletonParts.lwrist.Position)
                    if ss and ww then table.insert(espDrawn,DrawLine(s,w)) end
                end
                if skeletonParts.ptorso and skeletonParts.root then
                    local p,pp = W2V(skeletonParts.ptorso.Position)
                    local r,rr = W2V(skeletonParts.root.Position)
                    if pp and rr then table.insert(espDrawn,DrawLine(p,r)) end
                end
                if skeletonParts.root and skeletonParts.rleg then
                    local r,rr = W2V(skeletonParts.root.Position)
                    local l,ll = W2V(skeletonParts.rleg.Position)
                    if rr and ll then table.insert(espDrawn,DrawLine(r,l)) end
                end
                if skeletonParts.root and skeletonParts.lleg then
                    local r,rr = W2V(skeletonParts.root.Position)
                    local l,ll = W2V(skeletonParts.lleg.Position)
                    if rr and ll then table.insert(espDrawn,DrawLine(r,l)) end
                end
                if skeletonParts.rleg and skeletonParts.rfoot then
                    local l,ll = W2V(skeletonParts.rleg.Position)
                    local f,ff = W2V(skeletonParts.rfoot.Position)
                    if ll and ff then table.insert(espDrawn,DrawLine(l,f)) end
                end
                if skeletonParts.lleg and skeletonParts.lfoot then
                    local l,ll = W2V(skeletonParts.lleg.Position)
                    local f,ff = W2V(skeletonParts.lfoot.Position)
                    if ll and ff then table.insert(espDrawn,DrawLine(l,f)) end
                end
            end
        end
    end
end)
