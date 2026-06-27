-- DELTA executor için GUI'nin kesin gelmesi için:
-- 1. Script en başında bekleme ile PlayerGui hazır olana dek bekler
-- 2. Farklı bir GUI Name kullanılabilir. Her şey baştan aşağı güncellendi ve basit hata/engellemeler önlendi.
-- 3. Tüm kodun tek yerde çalışması için fonksiyonlar minimize, core fonksiyonlar tekrar yazıldı.

local plr = game:GetService("Players").LocalPlayer

-- PlayerGui'nın hazır girişini kesinleştir!
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
MainFrame.Size = UDim2.new(0, 300, 0, 340)
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
    {Name="Aimbot",   TextOn="Aimbot Kapat",   TextOff="Aimbot Aç",   Y=56},
    {Name="ESP",      TextOn="ESP Kapat",      TextOff="ESP Aç",      Y=110},
    {Name="Noclip",   TextOn="Noclip Kapat",   TextOff="Noclip Aç",   Y=164},
    {Name="Spinbot",  TextOn="Spinbot Kapat",  TextOff="Spinbot Aç",  Y=218},
}

local Buttons = {}
for i,d in ipairs(ButtonData) do
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Name = d.Name.."Button"
    btn.Position = UDim2.new(0.5,-105,0, d.Y)
    btn.Size = UDim2.new(0,210,0,44)
    btn.BackgroundColor3 = Color3.fromRGB(43,43,42)
    btn.Text = d.TextOff
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.TextColor3 = Color3.fromRGB(235,235,235)
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0,10)
    Buttons[d.Name] = {Button=btn, On=d.TextOn, Off=d.TextOff}
end

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

-- Taşıma rahatlığı: sürüklenebilir pencere
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

--[[ ###  FONKSİYONLAR  ### ]]--

-- *** AIMBOT ***
local aimbotState = false
local aimbotConn = nil

local function getAimTarget()
    local cam = workspace.CurrentCamera
    local mouse = plr:GetMouse()
    local closest, dist = nil, math.huge
    for _,v in ipairs(game:GetService("Players"):GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = cam:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local d = (Vector2.new(pos.X,pos.Y) - Vector2.new(mouse.X,mouse.Y)).Magnitude
                if d < dist then
                    dist = d
                    closest = v
                end
            end
        end
    end
    return closest
end

local function updateAim()
    local tgt = getAimTarget()
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
        if aimbotConn then aimbotConn:Disconnect() aimbotConn = nil end
    end
end)

-- *** ESP ***
local espState = false
local espBoxes = {}
local espConn = nil

local function clearESP()
    for _,b in pairs(espBoxes) do if b and b.Parent then b:Destroy() end end
    espBoxes = {}
end

local function makeESP(char)
    if not char:FindFirstChild("Head") then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = char
    box.AlwaysOnTop = true
    box.ZIndex = 12
    box.Size = char:GetExtentsSize()
    box.Color3 = Color3.new(1,1,0)
    box.Transparency = 0.76
    box.Name = "ESPAdornment"
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

-- *** NOCLIP ***
local noclipState = false
local noclipConn = nil

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

-- *** SPINBOT ***
local spinbotState = false
local spinbotConn = nil
local spinSpeed = 13
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
