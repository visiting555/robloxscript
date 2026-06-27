-- Daha basit, garantili ScreenGui menü (hiçbir şey blank kalmıyor, tüm fonksiyonlar aktif ve açılışta menü daima geliyor)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Destroy old GUI if exists
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("HileMenuV2") then
        LocalPlayer.PlayerGui.HileMenuV2:Destroy()
    end
end)

-- Başlatıcı hack settings:
local hackEnabled = {
    ["Aimbot"] = false,
    ["ESP"] = false,
    ["Noclip"] = false,
    ["Fly"] = false,
    ["Spinbot"] = false,
    ["Godmode"] = false
}

-- Utility fn
local function UpdateButton(btn, opt)
    btn.Text = opt .. " [" .. (hackEnabled[opt] and "Açık" or "Kapalı") .. "]"
end

-- Ana GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HileMenuV2"
screenGui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer.PlayerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,340,0,500)
frame.Position = UDim2.new(0,40,0,90)
frame.BackgroundColor3 = Color3.fromRGB(24,28,34)
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel")
title.Text = "ROBLOX HİLE MENÜ V2"
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

-- Şık buton seçenekleri
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

-- PLAYER TP başlığı & dropdown
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

-- FONKSİYONELLİK: her bir modül threadinde tüm fonksiyonlar devrede/iptal edilir:
-- NOCLIP: Kafa dahil garanti duvar içinden geçişli
spawn(function()
    local running = false
    while true do
        if hackEnabled.Noclip and LocalPlayer.Character then
            for _,part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") 
            if hum then hum:ChangeState(Enum.HumanoidStateType.Physics) end
        elseif not hackEnabled.Noclip and LocalPlayer.Character then
            for _,part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        wait(0.22)
    end
end)

-- FLY: w,a,s,d,space,ctrl ve flyda spinbot TAM entegre
local flyBV, flyBG
spawn(function()
    while true do
        if hackEnabled.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            if not flyBV or flyBV.Parent ~= hrp then
                pcall(function() if flyBV then flyBV:Destroy() end end)
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
            if flyBV then flyBV:Destroy() flyBV=nil end
            if flyBG then flyBG:Destroy() flyBG=nil end
        end
        wait()
    end
end)

-- SPINBOT: Her adımda HRP'yi döndür, DÜZ DURURKEN KOŞARKEN FLYDA AKTİF
spawn(function()
    while true do
        if hackEnabled.Spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(22), 0)
        end
        wait(0.032)
    end
end)

-- GODMODE: Modern health lock, hangi map olursa olsun
spawn(function()
    while true do
        if hackEnabled.Godmode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
            local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            hum.Health = hum.MaxHealth
            hum.MaxHealth = math.huge
            hum.BreakJointsOnDeath = false
            for _,v in pairs(LocalPlayer.Character:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
        wait(0.2)
    end
end)

-- AIMBOT: Mouse2 basınca en yakın kafa otomatik bak
local aimbotConn = nil
spawn(function()
    while true do
        if hackEnabled.Aimbot then
            if not aimbotConn then
                aimbotConn = RunService.RenderStepped:Connect(function()
                    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                        local closest, dist = nil, math.huge
                        for _,v in pairs(Players:GetPlayers()) do
                            if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and v.Character and v.Character:FindFirstChild("Head") then
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
                end)
            end
        else
            if aimbotConn then aimbotConn:Disconnect() aimbotConn=nil end
        end
        wait(0.15)
    end
end)

-- ESP: kutu+iskelet+başı yuvarlak KIRMIZI, DUVAR ARKASI BODY highlight (Drawing zorunlu)
local DrawingLib = (Drawing and Drawing.new) and Drawing or (getgenv and getgenv().Drawing)
if DrawingLib then
    local MAX_ESP_DIST = 400
    local ESPs = {}
    local skelPairs = {
        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},{"UpperTorso","RightUpperArm"},
        {"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
        {"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},{"LowerTorso","RightUpperLeg"},
        {"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
        {"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}
    }
    local function cleanESP()
        for _,tbl in pairs(ESPs) do for _,obj in pairs(tbl) do pcall(function() obj.Visible=false obj:Remove() end) end end
        ESPs = {}
    end
    spawn(function()
        while true do
            if hackEnabled.ESP then
                for _,plr in pairs(Players:GetPlayers()) do
                    if plr~=LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") then
                        if not ESPs[plr] then
                            ESPs[plr]={}
                            for i=1,4 do -- box
                                local l=DrawingLib("Line")
                                l.Color=Color3.new(1,0,0)
                                l.Thickness=1.8
                                l.Visible=false
                                ESPs[plr]["b"..i]=l
                            end
                            for k=1,#skelPairs do
                                local l=DrawingLib("Line")
                                l.Color=Color3.new(1,0,0)
                                l.Thickness=1.3
                                l.Visible=false
                                ESPs[plr]["s"..k]=l
                            end
                            local c=DrawingLib("Circle")
                            c.Color=Color3.new(1,0,0)
                            c.Thickness=2
                            c.Visible=false
                            c.Filled=false
                            ESPs[plr].head=c
                        end
                        -- Draw if near enough
                        local hrp = plr.Character.HumanoidRootPart
                        local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
                        if distance > MAX_ESP_DIST then
                            for _,obj in pairs(ESPs[plr]) do obj.Visible=false end
                        else
                            -- box
                            local size=Vector3.new(6,10.5,3)
                            local cf=hrp.CFrame
                            local points={
                                cf*Vector3.new(-size.X/2, size.Y/2, -size.Z/2),
                                cf*Vector3.new( size.X/2, size.Y/2, -size.Z/2),
                                cf*Vector3.new( size.X/2,-size.Y/2, -size.Z/2),
                                cf*Vector3.new(-size.X/2,-size.Y/2, -size.Z/2)
                            }
                            local scrPts={}
                            local ons=true
                            for i,pt in ipairs(points) do
                                local vp,on=Camera:WorldToViewportPoint(pt)
                                ons=ons and on
                                scrPts[i]=Vector2.new(vp.X,vp.Y)
                            end
                            for i=1,4 do
                                ESPs[plr]["b"..i].Visible=ons
                            end
                            if ons then
                                ESPs[plr].b1.From= scrPts[1]; ESPs[plr].b1.To=scrPts[2]
                                ESPs[plr].b2.From= scrPts[2]; ESPs[plr].b2.To=scrPts[3]
                                ESPs[plr].b3.From= scrPts[3]; ESPs[plr].b3.To=scrPts[4]
                                ESPs[plr].b4.From= scrPts[4]; ESPs[plr].b4.To=scrPts[1]
                            end
                            -- skeleton
                            for k,p in ipairs(skelPairs) do
                                local A,B=plr.Character:FindFirstChild(p[1]),plr.Character:FindFirstChild(p[2])
                                local l=ESPs[plr]["s"..k]
                                if A and B then
                                    local a,ona=Camera:WorldToViewportPoint(A.Position)
                                    local b,onb=Camera:WorldToViewportPoint(B.Position)
                                    if ona and onb then
                                        l.From=Vector2.new(a.X,a.Y)
                                        l.To=Vector2.new(b.X,b.Y)
                                        l.Visible=true
                                    else l.Visible=false end
                                else l.Visible=false end
                            end
                            -- headcircle
                            local h=plr.Character.Head; local onh
                            if h then
                                local p,onh=Camera:WorldToViewportPoint(h.Position)
                                if onh then
                                    ESPs[plr].head.Position=Vector2.new(p.X,p.Y)
                                    ESPs[plr].head.Radius=15*(MAX_ESP_DIST/(distance+12))
                                    ESPs[plr].head.Visible=true
                                else ESPs[plr].head.Visible=false end
                            else ESPs[plr].head.Visible=false end
                        end
                        -- Wallhack: kırmızı highlight içini doldur!
                        for _,v in pairs(plr.Character:GetDescendants()) do
                            if v:IsA("BasePart") then
                                pcall(function()
                                    v.Material = Enum.Material.Neon
                                    v.Color = Color3.new(1,0,0)
                                    v.Transparency = hackEnabled.ESP and 0.55 or 0
                                end)
                            end
                        end
                    elseif ESPs[plr] then for _,obj in pairs(ESPs[plr]) do obj.Visible=false end
                    end
                end
            else cleanESP() end
            wait(0.18)
        end
    end)
end

-- KISA YOL: F4 her zaman menü aç/kapat
UserInputService.InputBegan:Connect(function(k,gpe)
    if not gpe and k.KeyCode==Enum.KeyCode.F4 then
        frame.Visible=not frame.Visible
    end
end)
