-- GELİŞTİRİLMİŞ FULL HİLE MENÜ (FULL FUNCTIONAL ROBLOX HILE MENU PRO)

// Servisler
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Teams = game:GetService("Teams")

-- Menü toggle için ayar
local menuOpen = true
local hotkey = Enum.KeyCode.Insert

-- Eski menüyü sil
if LocalPlayer.PlayerGui:FindFirstChild("HileMenuV3") then
    LocalPlayer.PlayerGui.HileMenuV3:Destroy()
end

-- Hile ayarları ve yeni özellikler
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
local config = {
    FOV = 120,
}

-- Seçenekler ve fonksiyonel butonlar
local OPTIONS = {
    "Aimbot", "SilentAim", "TeamCheck", "ESP", "Noclip", "Fly", "Spinbot", "Godmode", "NoReload"
}
local PLAYER_ACTIONS = {
    {Name="TP Yanına", Key="TpToMe"},
    {Name="Işınlan", Key="Tp"},
    {Name="Dondur", Key="Freeze"},
    {Name="Patlat", Key="Explode"},
    {Name="Yak", Key="Fire"},
    {Name="Spectate", Key="Spectate"}
}

-- Menü arayüzü
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HileMenuV3"
screenGui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer.PlayerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,380,0,570)
frame.Position = UDim2.new(0,40,0,90)
frame.BackgroundColor3 = Color3.fromRGB(24,28,34)
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true
frame.Visible = menuOpen

local title = Instance.new("TextLabel")
title.Text = "ROBLOX HİLE MENÜ V3 - PRO"
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

-- Menü toggling
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == hotkey then
        menuOpen = not menuOpen
        frame.Visible = menuOpen
    end
end)

-- Fonksiyonel hile butonları
local BUTTONS = {}
local startingY = 50
for i, opt in ipairs(OPTIONS) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-32,0,34)
    btn.Position = UDim2.new(0,16,0,startingY+(i-1)*38)
    btn.BackgroundColor3 = Color3.fromRGB(33,39,44)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Name = "Opt"..opt
    local function UpdateBtn()
        btn.Text = (opt ~= "TeamCheck" and opt or "TeamCheck (AIM)") .. " [" .. (hackEnabled[opt] and "Açık" or "Kapalı") .. "]"
    end
    UpdateBtn()
    btn.Parent = frame
    BUTTONS[opt] = btn
    btn.MouseButton1Click:Connect(function()
        hackEnabled[opt] = not hackEnabled[opt]
        UpdateBtn()
    end)
end

-- FOV CHANGER ekleyelim
local fovLabel = Instance.new("TextLabel")
fovLabel.Text = "Aimbot FOV: "..tostring(config.FOV)
fovLabel.TextColor3 = Color3.fromRGB(200,255,140)
fovLabel.Font = Enum.Font.GothamBold
fovLabel.BackgroundTransparency = 1
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.Position = UDim2.new(0,16,0,startingY + #OPTIONS * 38 + 2)
fovLabel.Size = UDim2.new(0,170,0,28)
fovLabel.TextSize = 15
fovLabel.Parent = frame

local fovBox = Instance.new("TextBox")
fovBox.Text = tostring(config.FOV)
fovBox.Size = UDim2.new(0,60,0,28)
fovBox.Position = UDim2.new(0,200,0,startingY + #OPTIONS * 38 + 2)
fovBox.Font = Enum.Font.GothamBold
fovBox.TextColor3 = Color3.fromRGB(0,255,200)
fovBox.BackgroundColor3 = Color3.fromRGB(33,39,44)
fovBox.BorderSizePixel = 0
fovBox.TextSize = 15
fovBox.Parent = frame

fovBox.FocusLost:Connect(function(enter)
    local num = tonumber(fovBox.Text)
    if num and num > 5 then
        config.FOV = math.clamp(num,10,500)
    end
    fovBox.Text = tostring(config.FOV)
    fovLabel.Text = "Aimbot FOV: "..tostring(config.FOV)
end)

-- Oyuncu eylemleri bölümü
local PlayerHeader = Instance.new("TextLabel")
PlayerHeader.Text = "OYUNCU AKSİYONLARI"
PlayerHeader.Font = Enum.Font.GothamBold
PlayerHeader.TextColor3 = Color3.fromRGB(70,200,255)
PlayerHeader.BackgroundTransparency = 1
PlayerHeader.Position = UDim2.new(0,0,0,360)
PlayerHeader.Size = UDim2.new(1,0,0,22)
PlayerHeader.TextScaled = true
PlayerHeader.Parent = frame

local TpDropdownBtn = Instance.new("TextButton")
TpDropdownBtn.Text = "Oyuncu Seç"
TpDropdownBtn.Size = UDim2.new(1,-32,0,28)
TpDropdownBtn.Position = UDim2.new(0,16,0,392)
TpDropdownBtn.Font = Enum.Font.Gotham
TpDropdownBtn.TextColor3 = Color3.fromRGB(0,220,255)
TpDropdownBtn.BackgroundColor3 = Color3.fromRGB(33,40,55)
TpDropdownBtn.BorderSizePixel = 0
TpDropdownBtn.TextSize = 16
TpDropdownBtn.Parent = frame

local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(1,-32,0,76)
playerListFrame.Position = UDim2.new(0,16,0,425)
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

-- Oyuncu aksiyon fonksiyonları
local function getSelectableChar()
    return selectedPlayer and selectedPlayer.Character
end

local function teleportToPlayer()
    if getSelectableChar() and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(2,0,0)
        end
    end
end

local function teleportPlayerToMe()
    if getSelectableChar() and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        selectedPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(3,0,0)
    end
end

local function freezePlayer()
    if getSelectableChar() then
        for _,v in ipairs(selectedPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Anchored = true
            end
        end
        local hum = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 0
            hum.JumpPower = 0
            hum.PlatformStand = true
        end
    end
end

local function unfreezePlayer()
    if getSelectableChar() then
        for _,v in ipairs(selectedPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Anchored = false
            end
        end
        local hum = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
            hum.PlatformStand = false
        end
    end
end

local function explodePlayer()
    if getSelectableChar() and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local boom = Instance.new("Explosion")
        boom.BlastRadius = 10
        boom.BlastPressure = 999999
        boom.Position = selectedPlayer.Character.HumanoidRootPart.Position
        boom.Parent = workspace
    end
end

local function firePlayer()
    if getSelectableChar() then
        for _,bp in ipairs(selectedPlayer.Character:GetChildren()) do
            if bp:IsA("BasePart") and not bp:FindFirstChild("ONFIRE") then
                local fire = Instance.new("Fire")
                fire.Name = "ONFIRE"
                fire.Size = 8
                fire.Heat = 20
                fire.Parent = bp
            end
        end
        local hum = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = hum.Health - math.random(30,60)
        end
    end
end

local spectating = false
local spectateConn = nil

local function spectatePlayer()
    if not getSelectableChar() then return end
    if Camera.CameraSubject ~= selectedPlayer.Character:FindFirstChildOfClass("Humanoid") then
        Camera.CameraSubject = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
        Camera.CameraType = Enum.CameraType.Custom
        spectating = true
    end
end

local function unspectatePlayer()
    if spectating then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            Camera.CameraType = Enum.CameraType.Custom
        end
        spectating = false
    end
end

-- Oyuncu eylem butonlarını oluştur
local actionBtnY = 510
for idx, act in ipairs(PLAYER_ACTIONS) do
    local yOff = actionBtnY+((idx-1)*32)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.175,0,0,28)
    btn.Position = UDim2.new(0,16+(idx-1)*70,0,yOff)
    btn.Text = act.Name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.TextColor3 = Color3.fromRGB(230,230,255)
    btn.BackgroundColor3 = Color3.fromRGB(38,41,62)
    btn.BorderSizePixel = 0
    btn.Parent = frame

    if act.Key == "Tp" then
        btn.MouseButton1Click:Connect(teleportToPlayer)
    elseif act.Key == "TpToMe" then
        btn.MouseButton1Click:Connect(teleportPlayerToMe)
    elseif act.Key == "Freeze" then
        btn.MouseButton1Click:Connect(freezePlayer)
    elseif act.Key == "Explode" then
        btn.MouseButton1Click:Connect(explodePlayer)
    elseif act.Key == "Fire" then
        btn.MouseButton1Click:Connect(firePlayer)
    elseif act.Key == "Spectate" then
        btn.MouseButton1Click:Connect(function()
            if not spectating then
                spectatePlayer()
                btn.Text = "Çık(Spectate)"
            else
                unspectatePlayer()
                btn.Text = "Spectate"
            end
        end)
    end
end

-- NOCLIP (modifiye edilmedi)
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

-- FLY (modifiye edilmedi)
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

-- GODMODE (modifiye edilmedi)
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

-- SPINBOT (modifiye edilmedi)
RunService.RenderStepped:Connect(function()
    if hackEnabled.Spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0,math.rad(24),0)
        end
    end
end)

-- NO RELOAD
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

-- AIMBOT + SİLENTAIM + TEAMCHECK + FOV
local function isEnemy(ply)
    -- Eğer TeamCheck açıksa ve takımlı oyun ise
    if hackEnabled.TeamCheck and ply.Team and LocalPlayer.Team and ply.Team == LocalPlayer.Team then
        return false
    end
    return true
end

local function getClosestHead(forAim)
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

-- AİMBOT (kamera head'e kilitleniyor)
RunService.RenderStepped:Connect(function()
    if hackEnabled.Aimbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local head = getClosestHead(true)
        if head then
            local direction = (head.Position - Camera.CFrame.Position).Unit
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
        end
    end
end)

-- SİLENTAIM (input intercept, mouse click head'e)
local _oldMouse
local function patchMouse()
    if hackEnabled.SilentAim then
        if not _oldMouse then
            _oldMouse = hookfunction(game:GetService("Players").LocalPlayer.GetMouse, function(self)
                local mouse = _oldMouse(self)
                -- Fire intercept (Ray'den head'e)
                local oldHit = rawget(mouse, "Hit")
                rawset(mouse, "Hit", setmetatable({}, {
                    __index = function(t, k)
                        if k=="p" or k=="Position" then
                            local head = getClosestHead(true)
                            if head then return head.Position end
                        end
                        return oldHit and oldHit[k]
                    end
                }))
                return mouse
            end)
        end
    elseif _oldMouse then
        -- reset patch
        hookfunction(game:GetService("Players").LocalPlayer.GetMouse, _oldMouse)
        _oldMouse = nil
    end
end
RunService.Heartbeat:Connect(patchMouse)

-- ESP: kutu, skeleton, büyük kafa (modifiye edilmedi)
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

RunService:BindToRenderStep("ESP_V2",200,function()
    if not hackEnabled.ESP then removeESP() return end
    removeESP()
    for _,ply in ipairs(Players:GetPlayers()) do
        if ply ~= LocalPlayer and ply.Character and ply.Character:FindFirstChild("HumanoidRootPart") and ply.Character:FindFirstChild("Head") and ply.Character:FindFirstChildOfClass("Humanoid") and ply.Character:FindFirstChildOfClass("Humanoid").Health > 0 and isEnemy(ply) then
            local hrp = ply.Character.HumanoidRootPart
            local head = ply.Character.Head
            local hum = ply.Character:FindFirstChildOfClass("Humanoid")
            local dist = (hrp.Position - Camera.CFrame.Position).Magnitude
            if dist < 400 then -- FOV'dan daha genişçek
                -- Kutu baştan ayağa
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

                -- HEAD: büyük yuvarlak
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

                -- Iskelet çiz
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
