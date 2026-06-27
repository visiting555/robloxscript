-- DELTA executor ile uyumlu ve donma sorunu yaşamayan optimize sürüm:

local plr = game:GetService("Players").LocalPlayer

-- PlayerGui yoksa CoreGui'ye ekle
local parentGui = plr:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MultiHackMenu"
ScreenGui.Parent = parentGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.Position = UDim2.new(0.5,0,0.45,0)
MainFrame.Size = UDim2.new(0, 320, 0, 520)
MainFrame.BackgroundColor3 = Color3.fromRGB(29,29,29)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,13)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,0,44)
Title.Position = UDim2.new(0,0,0,0)
Title.Font = Enum.Font.GothamBold
Title.Text = "DELTA MENU"
Title.TextColor3 = Color3.fromRGB(57,200,255)
Title.TextScaled = true

local ButtonData = {
    {Name="Aimbot",    TextOn="Aimbot Kapat",    TextOff="Aimbot Aç",    Y=56},
    {Name="SilentAim", TextOn="SilentAim Kapat", TextOff="SilentAim Aç", Y=110},
    {Name="ESP",       TextOn="ESP Kapat",       TextOff="ESP Aç",       Y=164},
    {Name="Noclip",    TextOn="Noclip Kapat",    TextOff="Noclip Aç",    Y=218},
    {Name="Fly",       TextOn="Fly Kapat",       TextOff="Fly Aç",       Y=272},
    {Name="Spinbot",   TextOn="Spinbot Kapat",   TextOff="Spinbot Aç",   Y=326},
}
local Buttons = {}
for i, d in ipairs(ButtonData) do
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Name = d.Name.."Button"
    btn.Position = UDim2.new(0.5,-115,0, d.Y)
    btn.Size = UDim2.new(0,230,0,44)
    btn.BackgroundColor3 = Color3.fromRGB(43,43,42)
    btn.Text = d.TextOff
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.TextColor3 = Color3.fromRGB(235,235,235)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    Buttons[d.Name] = {Button=btn, On=d.TextOn, Off=d.TextOff}
end

local TeleportLabel = Instance.new("TextLabel")
TeleportLabel.Parent = MainFrame
TeleportLabel.Text = "Teleport: Oyuncu Seç"
TeleportLabel.Font = Enum.Font.GothamBold
TeleportLabel.TextColor3 = Color3.fromRGB(200, 226, 255)
TeleportLabel.TextScaled = true
TeleportLabel.BackgroundTransparency = 1
TeleportLabel.Position = UDim2.new(0.5, -115, 0, 380)
TeleportLabel.Size = UDim2.new(0, 230, 0, 26)

local DropdownFrame = Instance.new("ScrollingFrame")
DropdownFrame.Parent = MainFrame
DropdownFrame.Position = UDim2.new(0.5,-115,0,408)
DropdownFrame.Size = UDim2.new(0,230,0,60)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(40,40,47)
DropdownFrame.BorderSizePixel = 0
DropdownFrame.CanvasSize = UDim2.new(0,0,0,0)
DropdownFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
DropdownFrame.ScrollBarThickness = 5
Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0,8)

local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Parent = MainFrame
TeleportBtn.Position = UDim2.new(0.5,-55,0,470)
TeleportBtn.Size = UDim2.new(0,110,0,33)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(36,163,67)
TeleportBtn.Text = "Seçeneğe TP"
TeleportBtn.Font = Enum.Font.GothamBold
TeleportBtn.TextScaled = true
TeleportBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", TeleportBtn).CornerRadius = UDim.new(0,9)

local selectedPlayer=nil

local function refreshPlayers()
    for _,child in ipairs(DropdownFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local y = 0
    for _,ply in ipairs(game:GetService("Players"):GetPlayers()) do
        if ply ~= plr and ply.Character and ply.Character:FindFirstChild("HumanoidRootPart") then
            local pb = Instance.new("TextButton")
            pb.Parent = DropdownFrame
            pb.Size = UDim2.new(1,0,0,23)
            pb.Position = UDim2.new(0,0,0,y)
            y = y + 24
            pb.Text = ply.DisplayName.." ("..ply.Name..")"
            pb.Font = Enum.Font.Gotham
            pb.BackgroundColor3 = Color3.fromRGB(48,48,68)
            pb.TextColor3 = Color3.fromRGB(255,255,200)
            pb.TextScaled = true
            Instance.new("UICorner", pb).CornerRadius = UDim.new(0,6)
            pb.MouseButton1Click:Connect(function()
                selectedPlayer = ply
                TeleportLabel.Text = "Teleport: "..(ply.DisplayName or ply.Name)
            end)
        end
    end
    DropdownFrame.CanvasSize = UDim2.new(0,0,0,y)
    if not selectedPlayer then
        TeleportLabel.Text = "Teleport: Oyuncu Seç"
    end
end

game:GetService("Players").PlayerAdded:Connect(function() task.defer(refreshPlayers) end)
game:GetService("Players").PlayerRemoving:Connect(function() task.defer(refreshPlayers) end)
refreshPlayers()

TeleportBtn.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") and
        plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
    end
end)

local Close = Instance.new("TextButton")
Close.Parent = MainFrame
Close.Position = UDim2.new(1,-42,0,8)
Close.Size = UDim2.new(0,32,0,32)
Close.BackgroundColor3 = Color3.fromRGB(234,56,77)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextScaled = true
Close.TextColor3 = Color3.fromRGB(240,240,240)
Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)

-- Taşıma: Sürüklenebilir pencere
do
    local dragging = false
    local dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
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

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-------------------------
-- FONKSİYONLAR
-------------------------
-- States & Connections
local aimbotState, aimbotConn = false, nil
local silentAimState = false
local espState, espConn = false, nil
local espBoxes = {}
local noclipState, noclipConn = false, nil
local flyState, flyConn = false, nil
local flySpeed = 40
local spinbotState, spinbotConn = false, nil
local spinSpeed = 12
local UserInputService = game:GetService("UserInputService")

-- En yakın oyuncu fonk (her frame çağrılmaz, throttled!)
local cachedClosest = nil
local cachedClosestTick = 0

local function getClosestTarget()
    local nowTick = tick()
    if nowTick - cachedClosestTick < 0.08 and cachedClosest then
        return cachedClosest
    end
    local cam = workspace.CurrentCamera
    local mouse = plr:GetMouse()
    local closest, dist = nil, math.huge
    for _,v in ipairs(game:GetService("Players"):GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("Head") then
            local succ,pos = pcall(function()
                return cam:WorldToViewportPoint(v.Character.Head.Position)
            end)
            if succ and pos then
                if (typeof(pos) == "Vector3") and (pos.Z > 0) then
                    local d = (Vector2.new(pos.X,pos.Y) - Vector2.new(mouse.X,mouse.Y)).Magnitude
                    if d < dist then
                        dist = d
                        closest = v
                    end
                end
            end
        end
    end
    cachedClosest, cachedClosestTick = closest, nowTick
    return closest
end

-- AIMBOT
local function updateAim()
    local tgt = getClosestTarget()
    if tgt and tgt.Character and tgt.Character:FindFirstChild("Head") then
        local cam = workspace.CurrentCamera
        cam.CFrame = CFrame.new(cam.CFrame.Position, tgt.Character.Head.Position)
    end
end
Buttons.Aimbot.Button.MouseButton1Click:Connect(function()
    aimbotState = not aimbotState
    Buttons.Aimbot.Button.Text = aimbotState and Buttons.Aimbot.On or Buttons.Aimbot.Off
    if aimbotState then
        if not aimbotConn then
            aimbotConn = game:GetService("RunService").RenderStepped:Connect(function()
                if aimbotState then updateAim() end
            end)
        end
    else
        if aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end
    end
end)

-- SILENTAIM (hooked metatable ile, throttled)
local oldIndex
local mouse = plr:GetMouse()
Buttons.SilentAim.Button.MouseButton1Click:Connect(function()
    silentAimState = not silentAimState
    Buttons.SilentAim.Button.Text = silentAimState and Buttons.SilentAim.On or Buttons.SilentAim.Off
    if silentAimState and not oldIndex then
        if hookmetamethod then
            oldIndex = hookmetamethod(game, "__index", function(self, k)
                if self==mouse and (k == "Target" or k == "Hit") and silentAimState then
                    local tgt = getClosestTarget()
                    if tgt and tgt.Character and tgt.Character:FindFirstChild("Head") then
                        if k=="Target" then return tgt.Character.Head end
                        if k=="Hit" then return tgt.Character.Head.CFrame end
                    end
                end
                return oldIndex(self, k)
            end)
        end
    end
end)

-- ESP: Sadece değişiklik olunca güncelle
local function clearESP()
    for _,b in pairs(espBoxes) do if b and b.Parent then b:Destroy() end end
    espBoxes = {}
end

local function makeESP(char)
    if not char:FindFirstChild("Head") then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESPAdornment"
    box.Adornee = char
    box.AlwaysOnTop = true
    box.ZIndex = 12
    box.Size = char:GetExtentsSize()
    box.Color3 = Color3.new(1,0.9,0)
    box.Transparency = 0.8
    box.Parent = workspace
    table.insert(espBoxes,box)
end

Buttons.ESP.Button.MouseButton1Click:Connect(function()
    espState = not espState
    Buttons.ESP.Button.Text = espState and Buttons.ESP.On or Buttons.ESP.Off
    if espState then
        local function updateESP()
            clearESP()
            for _,v in ipairs(game:GetService("Players"):GetPlayers()) do
                if v ~= plr and v.Character and v.Character:FindFirstChild("Head") then
                    makeESP(v.Character)
                end
            end
        end
        updateESP()
        espConn = game:GetService("Players").PlayerAdded:Connect(updateESP)
        game:GetService("Players").PlayerRemoving:Connect(updateESP)
    else
        if espConn then pcall(function() espConn:Disconnect() end) espConn=nil end
        clearESP()
    end
end)

-- NOCLIP
Buttons.Noclip.Button.MouseButton1Click:Connect(function()
    noclipState = not noclipState
    Buttons.Noclip.Button.Text = noclipState and Buttons.Noclip.On or Buttons.Noclip.Off
    if noclipState and not noclipConn then
        noclipConn = game:GetService("RunService").Stepped:Connect(function()
            if plr.Character then
                for _,part in pairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        if plr.Character then
            for _,part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end)

-- FLY (flyConn sadece bir tane aktif!)
local function doFly(enable)
    if enable then
        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        local velocity = Instance.new("BodyVelocity", hrp)
        velocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        velocity.P = 9e4
        local gyro = Instance.new("BodyGyro", hrp)
        gyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        local move = Vector3.new()
        flyConn = game:GetService("RunService").Heartbeat:Connect(function()
            if not flyState or not char or not char:FindFirstChild("HumanoidRootPart") then
                pcall(function() velocity:Destroy() end)
                pcall(function() gyro:Destroy() end)
                if flyConn then flyConn:Disconnect(); flyConn=nil end
                return
            end
            move = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                move = move + (workspace.CurrentCamera.CFrame.LookVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                move = move - (workspace.CurrentCamera.CFrame.LookVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                move = move - (workspace.CurrentCamera.CFrame.RightVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                move = move + (workspace.CurrentCamera.CFrame.RightVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                move = move + Vector3.new(0,1,0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                move = move - Vector3.new(0,1,0)
            end
            if move.Magnitude>0 then
                velocity.Velocity = move.Unit * flySpeed
            else
                velocity.Velocity = Vector3.new()
            end
            gyro.CFrame = workspace.CurrentCamera.CFrame
        end)
    else
        if flyConn then flyConn:Disconnect(); flyConn=nil end
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _,v in ipairs(hrp:GetChildren()) do
                if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end
            end
        end
    end
end

Buttons.Fly.Button.MouseButton1Click:Connect(function()
    flyState = not flyState
    Buttons.Fly.Button.Text = flyState and Buttons.Fly.On or Buttons.Fly.Off
    doFly(flyState)
end)

-- SPINBOT (Heartbeat ile, sadece döndürme - minimum iş)
Buttons.Spinbot.Button.MouseButton1Click:Connect(function()
    spinbotState = not spinbotState
    Buttons.Spinbot.Button.Text = spinbotState and Buttons.Spinbot.On or Buttons.Spinbot.Off
    if spinbotState and not spinbotConn then
        spinbotConn = game:GetService("RunService").Heartbeat:Connect(function()
            if spinbotState and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
            end
        end)
    else
        if spinbotConn then spinbotConn:Disconnect(); spinbotConn = nil end
    end
end)
