-- DELTA executor uyumlu, optimize (donmayı önleyici), tüm fonksiyonel özellikler:
local plr = game:GetService("Players").LocalPlayer
local parentGui = plr:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaHackMenu"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = parentGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.Position = UDim2.new(0.5,0,0.5,0)
MainFrame.Size = UDim2.new(0, 320, 0, 520)
MainFrame.BackgroundColor3 = Color3.fromRGB(33,33,33)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,14)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,44)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "DELTA ADVANCED MENU"
Title.TextColor3 = Color3.fromRGB(0,210,255)
Title.TextScaled = true

-- Buton satırları
local ButtonData = {
    {Name="Aimbot",    TextOn="Aimbot Kapat",    TextOff="Aimbot Aç",    Y=54},
    {Name="SilentAim", TextOn="SilentAim Kapat", TextOff="SilentAim Aç", Y=104},
    {Name="ESP",       TextOn="ESP Kapat",       TextOff="ESP Aç",       Y=154},
    {Name="Noclip",    TextOn="Noclip Kapat",    TextOff="Noclip Aç",    Y=204},
    {Name="Fly",       TextOn="Fly Kapat",       TextOff="Fly Aç",       Y=254},
    {Name="Spinbot",   TextOn="Spinbot Kapat",   TextOff="Spinbot Aç",   Y=304},
}
local Buttons = {}
for i, d in ipairs(ButtonData) do
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Name = d.Name.."Button"
    btn.Position = UDim2.new(0.5,-115,0, d.Y)
    btn.Size = UDim2.new(0,230,0,38)
    btn.BackgroundColor3 = Color3.fromRGB(54,54,56)
    btn.Text = d.TextOff
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.TextColor3 = Color3.fromRGB(225,225,225)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    Buttons[d.Name] = {Button=btn, On=d.TextOn, Off=d.TextOff}
end

local TeleportLabel = Instance.new("TextLabel", MainFrame)
TeleportLabel.Text = "Teleport: Oyuncu Seç"
TeleportLabel.Font = Enum.Font.GothamBold
TeleportLabel.TextColor3 = Color3.fromRGB(200, 226, 255)
TeleportLabel.TextScaled = true
TeleportLabel.BackgroundTransparency = 1
TeleportLabel.Position = UDim2.new(0.5,-115,0,358)
TeleportLabel.Size = UDim2.new(0, 230, 0, 24)

local DropdownFrame = Instance.new("ScrollingFrame", MainFrame)
DropdownFrame.Position = UDim2.new(0.5,-115,0,386)
DropdownFrame.Size = UDim2.new(0,230,0,64)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(36,38,45)
DropdownFrame.BorderSizePixel = 0
DropdownFrame.CanvasSize = UDim2.new(0,0,0,0)
DropdownFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
DropdownFrame.ScrollBarThickness = 5
Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0,8)

local TeleportBtn = Instance.new("TextButton", MainFrame)
TeleportBtn.Position = UDim2.new(0.5,-55,0,460)
TeleportBtn.Size = UDim2.new(0,110,0,33)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(36,163,67)
TeleportBtn.Text = "Seçeneğe TP"
TeleportBtn.Font = Enum.Font.GothamBold
TeleportBtn.TextScaled = true
TeleportBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", TeleportBtn).CornerRadius = UDim.new(0,9)

-- Kapat
local Close = Instance.new("TextButton", MainFrame)
Close.Position = UDim2.new(1,-42,0,8)
Close.Size = UDim2.new(0,32,0,32)
Close.BackgroundColor3 = Color3.fromRGB(234,56,77)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextScaled = true
Close.TextColor3 = Color3.fromRGB(240,240,240)
Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Taşıma: Sürüklenebilir frame
do
    local dragging = false
    local dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, dragStart, startPos = true, input.Position, MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)
end

-- Teleport listesi, optimize (oyuncular değişince, frame yavaş yeniler)
local selectedPlayer=nil
local lastPlyRefresh = 0
local function refreshPlayers()
    -- yenileme limiti (donmayı önler)
    if tick()-lastPlyRefresh < 0.75 then return end
    lastPlyRefresh = tick()
    for _,child in ipairs(DropdownFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local y = 0
    for _,ply in ipairs(game:GetService("Players"):GetPlayers()) do
        if ply ~= plr and ply.Character and ply.Character:FindFirstChild("HumanoidRootPart") then
            local pb = Instance.new("TextButton")
            pb.Parent = DropdownFrame
            pb.Size = UDim2.new(1,0,0,22)
            pb.Position = UDim2.new(0,0,0,y)
            y = y + 23
            pb.Text = ply.DisplayName.." ("..ply.Name..")"
            pb.Font = Enum.Font.Gotham
            pb.BackgroundColor3 = Color3.fromRGB(58,62,72)
            pb.TextColor3 = Color3.fromRGB(255,255,220)
            pb.TextScaled = true
            Instance.new("UICorner", pb).CornerRadius = UDim.new(0,5)
            pb.MouseButton1Click:Connect(function()
                selectedPlayer = ply
                TeleportLabel.Text = "Teleport: "..(ply.DisplayName or ply.Name)
            end)
        end
    end
    DropdownFrame.CanvasSize = UDim2.new(0,0,0,math.max(1,y))
    if not selectedPlayer then TeleportLabel.Text = "Teleport: Oyuncu Seç" end
end
game:GetService("Players").PlayerAdded:Connect(refreshPlayers)
game:GetService("Players").PlayerRemoving:Connect(refreshPlayers)
task.spawn(refreshPlayers)

TeleportBtn.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") and
        plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
    end
end)

-------------------------
-- OPTİMİZE FONKSİYONLAR
-------------------------
local UserInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local mouse = plr:GetMouse()

local State = {
    Aimbot = false, SilentAim = false, ESP = false,
    Noclip = false, Fly = false, Spinbot = false,
}
local Conns = {
    Aimbot=nil, ESP=nil, Noclip=nil, Fly=nil, Spinbot=nil
}
local other = {
    FlyVelocity = nil, FlyGyro = nil,
    ESP_Boxes = {}, SilentAimHooked = false,
}

-- Donma karşıtı throttle & cache
local lastTarget, lastClosestTick = nil, 0
local function getClosest()
    local now = tick()
    if now-lastClosestTick < 0.09 and lastTarget then return lastTarget end
    lastClosestTick = now
    local cam = workspace.CurrentCamera
    local closest, dist = nil, math.huge
    local mouseX, mouseY = mouse.X, mouse.Y
    for _,v in ipairs(game:GetService("Players"):GetPlayers()) do
        if v~=plr and v.Character and v.Character:FindFirstChild("Head") then
            local succ,pos = pcall(function()
                return cam:WorldToViewportPoint(v.Character.Head.Position)
            end)
            if succ and pos and pos.Z > 0 then
                local d = (Vector2.new(pos.X,pos.Y) - Vector2.new(mouseX,mouseY)).Magnitude
                if d < dist then dist = d closest = v end
            end
        end
    end
    lastTarget = closest
    return closest
end

-- Aimbot
local function aimbotUpdate()
    local tgt = getClosest()
    if tgt and tgt.Character and tgt.Character:FindFirstChild("Head") then
        local cam = workspace.CurrentCamera
        cam.CFrame = CFrame.new(cam.CFrame.Position, tgt.Character.Head.Position)
    end
end
Buttons.Aimbot.Button.MouseButton1Click:Connect(function()
    State.Aimbot = not State.Aimbot
    Buttons.Aimbot.Button.Text = State.Aimbot and Buttons.Aimbot.On or Buttons.Aimbot.Off
    if State.Aimbot then
        if not Conns.Aimbot then
            Conns.Aimbot = runService.RenderStepped:Connect(function()
                if State.Aimbot then aimbotUpdate() end
            end)
        end
    elseif Conns.Aimbot then Conns.Aimbot:Disconnect() Conns.Aimbot=nil end
end)

-- SilentAim (low-impact, mt hook bir kez; donmaya sebep olmayan throttle içerir)
Buttons.SilentAim.Button.MouseButton1Click:Connect(function()
    State.SilentAim = not State.SilentAim
    Buttons.SilentAim.Button.Text = State.SilentAim and Buttons.SilentAim.On or Buttons.SilentAim.Off
    if not other.SilentAimHooked and hookmetamethod then -- sadece 1 kez hookla!
        local oldIndex = nil
        oldIndex = hookmetamethod(game, "__index", function(self, k)
            if self==mouse and (k=="Target" or k=="Hit") and State.SilentAim then
                local tgt = getClosest()
                if tgt and tgt.Character and tgt.Character:FindFirstChild("Head") then
                    if k=="Target" then return tgt.Character.Head end
                    if k=="Hit" then return tgt.Character.Head.CFrame end
                end
            end
            return oldIndex(self,k)
        end)
        other.SilentAimHooked = true
    end
end)

-- ESP (Optimize: sadece önemli eventlerde güncellenir ve donmayı önler)
local function clearESP()
    for _,box in ipairs(other.ESP_Boxes) do if box and box.Parent then box:Destroy() end end
    other.ESP_Boxes = {}
end
local function updateESP()
    clearESP()
    for _,v in ipairs(game:GetService("Players"):GetPlayers()) do
        if v~=plr and v.Character and v.Character:FindFirstChild("Head") then
            local c = Instance.new("BoxHandleAdornment")
            c.Name = "ESPBox"
            c.Adornee = v.Character
            c.AlwaysOnTop = true
            c.ZIndex = 10
            c.Size = v.Character:GetExtentsSize()
            c.Color3 = Color3.new(1,0.9,0)
            c.Transparency = 0.75
            c.Parent = workspace
            table.insert(other.ESP_Boxes,c)
        end
    end
end
Buttons.ESP.Button.MouseButton1Click:Connect(function()
    State.ESP = not State.ESP
    Buttons.ESP.Button.Text = State.ESP and Buttons.ESP.On or Buttons.ESP.Off
    if State.ESP then
        updateESP()
        if not Conns.ESP then
            -- Sadece oyuncularda değişiklik olduğunda
            local function update() if State.ESP then updateESP() end end
            Conns.ESP = {
                Added = game:GetService("Players").PlayerAdded:Connect(update),
                Removed = game:GetService("Players").PlayerRemoving:Connect(update),
                Char = plr.CharacterAdded:Connect(update),
            }
        end
    else
        if Conns.ESP then
            for _,c in pairs(Conns.ESP) do c:Disconnect() end
            Conns.ESP = nil
        end
        clearESP()
    end
end)

-- Noclip
Buttons.Noclip.Button.MouseButton1Click:Connect(function()
    State.Noclip = not State.Noclip
    Buttons.Noclip.Button.Text = State.Noclip and Buttons.Noclip.On or Buttons.Noclip.Off
    if State.Noclip and not Conns.Noclip then
        Conns.Noclip = runService.Stepped:Connect(function()
            if plr.Character then
                for _,part in ipairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    elseif Conns.Noclip then
        Conns.Noclip:Disconnect(); Conns.Noclip = nil
        if plr.Character then
            for _,part in ipairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end)

-- Fly (donmayı önleyici tasarım, gyro ve velocity bir kez eklenir)
local flySpeed = 40
local function flyStart()
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    other.FlyVelocity = Instance.new("BodyVelocity")
    other.FlyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    other.FlyVelocity.P = 5e4
    other.FlyVelocity.Parent = hrp
    other.FlyGyro = Instance.new("BodyGyro", hrp)
    other.FlyGyro.MaxTorque = Vector3.new(1e6,1e6,1e6)
    other.FlyGyro.Parent = hrp
    if not Conns.Fly then
        Conns.Fly = runService.RenderStepped:Connect(function()
            if not State.Fly then return end
            local move = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
            if move.Magnitude > 0 then
                other.FlyVelocity.Velocity = move.Unit * flySpeed
            else
                other.FlyVelocity.Velocity = Vector3.new()
            end
            other.FlyGyro.CFrame = workspace.CurrentCamera.CFrame
        end)
    end
end
local function flyStop()
    if Conns.Fly then Conns.Fly:Disconnect() Conns.Fly=nil end
    if other.FlyVelocity then pcall(function() other.FlyVelocity:Destroy() end) other.FlyVelocity=nil end
    if other.FlyGyro then pcall(function() other.FlyGyro:Destroy() end) other.FlyGyro=nil end
end
Buttons.Fly.Button.MouseButton1Click:Connect(function()
    State.Fly = not State.Fly
    Buttons.Fly.Button.Text = State.Fly and Buttons.Fly.On or Buttons.Fly.Off
    if State.Fly then flyStart() else flyStop() end
end)

-- Spinbot (Fly ile birlikte de çalışır, RenderStepped tek loop!)
local spinSpeed = 14
Buttons.Spinbot.Button.MouseButton1Click:Connect(function()
    State.Spinbot = not State.Spinbot
    Buttons.Spinbot.Button.Text = State.Spinbot and Buttons.Spinbot.On or Buttons.Spinbot.Off
    if State.Spinbot and not Conns.Spinbot then
        Conns.Spinbot = runService.RenderStepped:Connect(function()
            if State.Spinbot and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
            end
        end)
    elseif Conns.Spinbot then
        Conns.Spinbot:Disconnect(); Conns.Spinbot = nil
    end
end)
