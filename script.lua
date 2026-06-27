-- DELTA executor ile uyum, tam çözüm:
local plr = game:GetService("Players").LocalPlayer

-- PlayerGui'yı bul ve arayüzü ekle
local playerGui
repeat
    playerGui = plr:FindFirstChildOfClass("PlayerGui")
    if not playerGui then wait(0.2) end
until playerGui

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MultiHackMenu"
ScreenGui.Parent = playerGui
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
local mainUICorner = Instance.new("UICorner", MainFrame)
mainUICorner.CornerRadius = UDim.new(0,13)

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
    {Name="Aimbot",    TextOn="Aimbot Kapat",      TextOff="Aimbot Aç",    Y=56},
    {Name="SilentAim", TextOn="SilentAim Kapat",   TextOff="SilentAim Aç", Y=110},
    {Name="ESP",       TextOn="ESP Kapat",         TextOff="ESP Aç",       Y=164},
    {Name="Noclip",    TextOn="Noclip Kapat",      TextOff="Noclip Aç",    Y=218},
    {Name="Fly",       TextOn="Fly Kapat",         TextOff="Fly Aç",       Y=272},
    {Name="Spinbot",   TextOn="Spinbot Kapat",     TextOff="Spinbot Aç",   Y=326},
}
local Buttons = {}
for i,d in ipairs(ButtonData) do
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
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0,10)
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
DropdownFrame.Size = UDim2.new(0,230,0,55)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(40,40,47)
DropdownFrame.BorderSizePixel = 0
DropdownFrame.CanvasSize = UDim2.new(0,0,0,0)
DropdownFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
DropdownFrame.ScrollBarThickness = 5
local dropCorner = Instance.new("UICorner", DropdownFrame)
dropCorner.CornerRadius = UDim.new(0,8)

local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Parent = MainFrame
TeleportBtn.Position = UDim2.new(0.5,-55,0,470)
TeleportBtn.Size = UDim2.new(0,110,0,33)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(36,163,67)
TeleportBtn.Text = "Seçeneğe TP"
TeleportBtn.Font = Enum.Font.GothamBold
TeleportBtn.TextScaled = true
TeleportBtn.TextColor3 = Color3.fromRGB(255,255,255)
local tpcorner = Instance.new("UICorner", TeleportBtn)
tpcorner.CornerRadius = UDim.new(0,9)

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
            local cc = Instance.new("UICorner", pb) cc.CornerRadius = UDim.new(0,6)
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
DropdownFrame.ChildAdded:Connect(function() refreshPlayers() end)
game:GetService("Players").PlayerAdded:Connect(refreshPlayers)
game:GetService("Players").PlayerRemoving:Connect(refreshPlayers)
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
local closeCorner = Instance.new("UICorner", Close)
closeCorner.CornerRadius = UDim.new(1,0)

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
-- *** AIMBOT ***
local aimbotState, aimbotConn = false, nil
-- *** SILENTAIM ***
local silentAimState = false
-- *** ESP ***
local espState, espBoxes, espConn = false, {}, nil
-- *** NOCLIP ***
local noclipState, noclipConn = false, nil
-- *** FLY ***
local flyState, flyConn = false, nil
local flySpeed = 40
-- *** SPINBOT ***
local spinbotState, spinbotConn = false, nil
local spinSpeed = 12
local flyMove = Vector3.new()
local UserInputService = game:GetService("UserInputService")

--**** EN YAKIN PLAYER FONK
local function getClosestTarget()
    local cam = workspace.CurrentCamera
    local mouse = plr:GetMouse()
    local closest, dist, posScreen = nil, math.huge, nil
    for _,v in ipairs(game:GetService("Players"):GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = cam:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local d = (Vector2.new(pos.X,pos.Y) - Vector2.new(mouse.X,mouse.Y)).Magnitude
                if d < dist then
                    dist = d
                    closest = v
                    posScreen = pos
                end
            end
        end
    end
    return closest,posScreen
end

--**** AIMBOT 
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
        aimbotConn = game:GetService("RunService").RenderStepped:Connect(function()
            if aimbotState then updateAim() end
        end)
    else
        if aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end
    end
end)

--**** SILENTAIM (Mouse.Target değiştirme)
local origMT = nil
local silentAimedTarget = nil
Buttons.SilentAim.Button.MouseButton1Click:Connect(function()
    silentAimState = not silentAimState
    Buttons.SilentAim.Button.Text = silentAimState and Buttons.SilentAim.On or Buttons.SilentAim.Off
    if silentAimState then
        local mouse = plr:GetMouse()
        origMT = hookmetamethod and hookmetamethod(game, "__index", function(self, k)
            if silentAimState and self == mouse and (k == "Target" or k == "Hit") then
                local tgt = getClosestTarget()
                if tgt and tgt.Character and tgt.Character:FindFirstChild("Head") then
                    silentAimedTarget = tgt
                    return tgt.Character.Head
                end
            end
            return origMT(self, k)
        end)
    else
        if origMT then
            -- Remove hook (not all exploits support, so just ignore)
            origMT = nil
        end
    end
end)

--**** ESP
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
    box.Transparency = 0.75
    box.Parent = workspace
    return box
end

Buttons.ESP.Button.MouseButton1Click:Connect(function()
    espState = not espState
    Buttons.ESP.Button.Text = espState and Buttons.ESP.On or Buttons.ESP.Off
    if espState then
        clearESP()
        espConn = game:GetService("RunService").RenderStepped:Connect(function()
            clearESP()
            for _,v in ipairs(game:GetService("Players"):GetPlayers()) do
                if v ~= plr and v.Character and v.Character:FindFirstChild("Head") then
                    local espBox = makeESP(v.Character)
                    if espBox then table.insert(espBoxes,espBox) end
                end
            end
        end)
    else
        if espConn then espConn:Disconnect(); espConn = nil end
        clearESP()
    end
end)

--**** NOCLIP
Buttons.Noclip.Button.MouseButton1Click:Connect(function()
    noclipState = not noclipState
    Buttons.Noclip.Button.Text = noclipState and Buttons.Noclip.On or Buttons.Noclip.Off
    if noclipState then
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

--**** FLY + SPINBOT ENTEGRASYON
local function doFly(enable)
    if enable then
        local char = plr.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        local velocity = Instance.new("BodyVelocity", hrp)
        velocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        local gy = Instance.new("BodyGyro", hrp)
        gy.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        local dir
        flyConn = game:GetService("RunService").Heartbeat:Connect(function()
            if not flyState or not char or not char:FindFirstChild("HumanoidRootPart") then
                if velocity and velocity.Parent then velocity:Destroy() end
                if gy and gy.Parent then gy:Destroy() end
                if flyConn then flyConn:Disconnect(); flyConn=nil end
                return
            end
            dir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                dir = dir + (workspace.CurrentCamera.CFrame.LookVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                dir = dir - (workspace.CurrentCamera.CFrame.LookVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                dir = dir - (workspace.CurrentCamera.CFrame.RightVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                dir = dir + (workspace.CurrentCamera.CFrame.RightVector)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                dir = dir + Vector3.new(0,1,0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                dir = dir - Vector3.new(0,1,0)
            end
            if dir.Magnitude>0 then
                velocity.Velocity = dir.Unit * flySpeed
            else
                velocity.Velocity = Vector3.new()
            end
            gy.CFrame = workspace.CurrentCamera.CFrame
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

--**** SPINBOT (FLY VARKEN DE AKTİF)
Buttons.Spinbot.Button.MouseButton1Click:Connect(function()
    spinbotState = not spinbotState
    Buttons.Spinbot.Button.Text = spinbotState and Buttons.Spinbot.On or Buttons.Spinbot.Off
    if spinbotState then
        spinbotConn = game:GetService("RunService").Heartbeat:Connect(function()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
            end
        end)
    else
        if spinbotConn then spinbotConn:Disconnect(); spinbotConn = nil end
    end
end)
