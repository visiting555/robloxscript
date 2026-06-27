// Roblox için eğitim amaçlı script – Menü, aimbot, esp, noclip, spinbot fonksiyonları DOLU

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local AimbotButton = Instance.new("TextButton")
local ESPButton = Instance.new("TextButton")
local NoclipButton = Instance.new("TextButton")
local SpinbotButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")

ScreenGui.Name = "ScriptMenu"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.3, 0, 0.22, 0)
MainFrame.Size = UDim2.new(0, 290, 0, 375)
MainFrame.BorderSizePixel = 0

UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 6)
Title.Size = UDim2.new(1, 0, 0, 42)
Title.Font = Enum.Font.GothamBold
Title.Text = "Roblox Menu"
Title.TextColor3 = Color3.fromRGB(108,205,255)
Title.TextScaled = true

local function StyleButton(btn, pos, txt)
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
    btn.Position = pos
    btn.Size = UDim2.new(0, 210, 0, 40)
    btn.Font = Enum.Font.Gotham
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.TextScaled = true
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
end

StyleButton(AimbotButton, UDim2.new(0, 40, 0, 58), "Aimbot Aç")
StyleButton(ESPButton,    UDim2.new(0, 40, 0, 110), "ESP Aç")
StyleButton(NoclipButton, UDim2.new(0, 40, 0, 162), "Noclip Aç")
StyleButton(SpinbotButton,UDim2.new(0, 40, 0, 214), "Spinbot Aç")

CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255,64,64)
CloseButton.Position = UDim2.new(1, -38, 0, 8)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
CloseButton.TextScaled = true
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = CloseButton

-- SÜRÜKLENEBİLİR MENÜ
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
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- OYUNCU REFERANSI
local plr = game.Players.LocalPlayer

-- ## AIMBOT
local aimbotActive = false
local aimbotConn = nil
local function getClosestEnemy()
    local mouse = plr:GetMouse()
    local shortest = math.huge
    local target = nil
    for _,v in ipairs(game.Players:GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X,pos.Y) - Vector2.new(mouse.X,mouse.Y)).Magnitude
                if dist < shortest then
                    shortest = dist
                    target = v
                end
            end
        end
    end
    return target
end

local function aimAt(target)
    local camera = workspace.CurrentCamera
    if not (target and target.Character and target.Character:FindFirstChild("Head")) then return end
    local head = target.Character.Head.Position
    camera.CFrame = CFrame.new(camera.CFrame.Position, head)
end

local function enableAimbot()
    if aimbotConn then aimbotConn:Disconnect() end
    aimbotConn = game:GetService("RunService").RenderStepped:Connect(function()
        if aimbotActive then
            local tgt = getClosestEnemy()
            if tgt then aimAt(tgt) end
        end
    end)
end

local function disableAimbot()
    if aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end
end

AimbotButton.MouseButton1Click:Connect(function()
    aimbotActive = not aimbotActive
    if aimbotActive then
        enableAimbot()
        AimbotButton.Text = "Aimbot Kapat"
    else
        disableAimbot()
        AimbotButton.Text = "Aimbot Aç"
    end
end)

-- ## ESP
local espActive = false
local espBoxes = {}
local espConn = nil

local function createESPBox(char)
    if not char:FindFirstChild("Head") then return end
    local Box = Instance.new("BoxHandleAdornment")
    Box.Adornee = char
    Box.AlwaysOnTop = true
    Box.ZIndex = 10
    Box.Color3 = Color3.new(1,1,0)
    Box.Transparency = 0.5
    Box.Size = char:GetExtentsSize()
    Box.Name = "ESPBox"
    Box.Parent = workspace
    return Box
end

local function clearAllESP()
    for _,box in pairs(espBoxes) do
        if box and box.Parent then
            box:Destroy()
        end
    end
    espBoxes = {}
end

local function refreshESP()
    clearAllESP()
    for _,v in ipairs(game.Players:GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("Head") then
            local found = false
            -- prevent multiple ESP
            if not v.Character:FindFirstChild("ESPBox") then
                local box = createESPBox(v.Character)
                if box then table.insert(espBoxes, box) end
            end
        end
    end
end

local function enableESP()
    refreshESP()
    if espConn then espConn:Disconnect() end
    espConn = game:GetService("RunService").RenderStepped:Connect(function()
        if not espActive then return end
        for _,pl in ipairs(game.Players:GetPlayers()) do
            if pl ~= plr and pl.Character and pl.Character:FindFirstChild("Head") then
                if not pl.Character:FindFirstChild("ESPBox") then
                    local box = createESPBox(pl.Character)
                    if box then table.insert(espBoxes, box) end
                end
            end
        end
    end)
end

local function disableESP()
    clearAllESP()
    if espConn then espConn:Disconnect() espConn = nil end
end

ESPButton.MouseButton1Click:Connect(function()
    espActive = not espActive
    if espActive then
        enableESP()
        ESPButton.Text = "ESP Kapat"
    else
        disableESP()
        ESPButton.Text = "ESP Aç"
    end
end)

-- ## NOCLIP
local noclipActive = false
local noclipConn = nil
local function enableNoclip()
    if noclipConn then noclipConn:Disconnect() end
    noclipConn = game:GetService("RunService").Stepped:Connect(function()
        if noclipActive and plr.Character then
            for _,part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end
local function disableNoclip()
    noclipActive = false
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    if plr.Character then
        for _,part in pairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

NoclipButton.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    if noclipActive then
        enableNoclip()
        NoclipButton.Text = "Noclip Kapat"
    else
        disableNoclip()
        NoclipButton.Text = "Noclip Aç"
    end
end)

-- ## SPINBOT
local spinbotActive = false
local spinbotConn = nil
local spinSpeed = 10

local function enableSpinbot()
    if spinbotConn then spinbotConn:Disconnect() end
    spinbotConn = game:GetService("RunService").Stepped:Connect(function(_, dt)
        if spinbotActive and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            -- Yaw rotation (Y axis)
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
        end
    end)
end
local function disableSpinbot()
    spinbotActive = false
    if spinbotConn then spinbotConn:Disconnect(); spinbotConn = nil end
end

SpinbotButton.MouseButton1Click:Connect(function()
    spinbotActive = not spinbotActive
    if spinbotActive then
        enableSpinbot()
        SpinbotButton.Text = "Spinbot Kapat"
    else
        disableSpinbot()
        SpinbotButton.Text = "Spinbot Aç"
    end
end)
