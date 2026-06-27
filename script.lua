// Roblox eğitim amaçlı script, modern menü, dolu fonksiyonlar ile aimbot, fly ve noclip.

// MODERN GUI OLUŞTUR
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local AimbotButton = Instance.new("TextButton")
local FlyButton = Instance.new("TextButton")
local NoclipButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")

ScreenGui.Name = "EgitimGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling


MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 350)

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 8)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "Eğitim Hilesi"
Title.TextColor3 = Color3.fromRGB(85, 170, 255)
Title.TextScaled = true

local function StyleButton(button, pos, text)
    button.Parent = MainFrame
    button.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
    button.Position = pos
    button.Size = UDim2.new(0, 240, 0, 44)
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Color3.fromRGB(230, 230, 230)
    button.TextScaled = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
end

StyleButton(AimbotButton, UDim2.new(0, 30, 0, 60), "Aimbot Aç/Kapa")
StyleButton(FlyButton,   UDim2.new(0, 30, 0, 120), "Fly Aç/Kapa")
StyleButton(NoclipButton,UDim2.new(0, 30, 0, 180), "Noclip Aç/Kapa")

CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255,64,64)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = CloseButton

-- Menüyü Sürüklenebilir yap
local dragging
local dragInput
local dragStart
local startPos

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
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

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- FONKSİYONLAR
local plr = game.Players.LocalPlayer
local aimbotActive = false
local flyActive = false
local noclipActive = false
local connectionAimbot = nil
local connectionNoclip = nil

-- AIMBOT
local function getClosestPlayer()
    local mouse = plr:GetMouse()
    local shortestDist = math.huge
    local closest = nil
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("Head") then
            local headPos = v.Character.Head.Position
            local vector, onScreen = workspace.CurrentCamera:WorldToScreenPoint(headPos)
            if onScreen then
                local dist = (Vector2.new(vector.X, vector.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = v
                end
            end
        end
    end
    return closest
end

local function aimAt(target)
    local camera = workspace.CurrentCamera
    if not target or not target.Character or not target.Character:FindFirstChild("Head") then return end
    local head = target.Character.Head.Position
    camera.CFrame = CFrame.new(camera.CFrame.Position, head)
end

local function enableAimbot()
    if connectionAimbot then connectionAimbot:Disconnect() end
    connectionAimbot = game:GetService("RunService").RenderStepped:Connect(function()
        if aimbotActive then
            local target = getClosestPlayer()
            if target then
                aimAt(target)
            end
        end
    end)
end

local function disableAimbot()
    if connectionAimbot then connectionAimbot:Disconnect() end
    connectionAimbot = nil
end

AimbotButton.MouseButton1Click:Connect(function()
    aimbotActive = not aimbotActive
    if aimbotActive then
        enableAimbot()
        AimbotButton.Text = "Aimbot KAPAT"
    else
        disableAimbot()
        AimbotButton.Text = "Aimbot AÇ"
    end
end)

-- FLY
local flySpeed = 50
local flyConn = nil
function enableFly()
    if flyConn then flyConn:Disconnect() end
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local UserInputService = game:GetService("UserInputService")
    local velocity = Instance.new("BodyVelocity", hrp)
    velocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    local flyDir = Vector3.new()

    flyConn = game:GetService("RunService").Heartbeat:Connect(function()
        if not flyActive or not char or not char:FindFirstChild("HumanoidRootPart") then
            velocity:Destroy()
            flyConn:Disconnect()
            return
        end

        flyDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            flyDir = flyDir + (workspace.CurrentCamera.CFrame.LookVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            flyDir = flyDir - (workspace.CurrentCamera.CFrame.LookVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            flyDir = flyDir - (workspace.CurrentCamera.CFrame.RightVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            flyDir = flyDir + (workspace.CurrentCamera.CFrame.RightVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            flyDir = flyDir + Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            flyDir = flyDir - Vector3.new(0,1,0)
        end
        velocity.Velocity = flyDir.Unit * flySpeed
        if flyDir.Magnitude == 0 then
            velocity.Velocity = Vector3.new()
        end
    end)
end

function disableFly()
    flyActive = false
    if flyConn then
        flyConn:Disconnect()
        flyConn = nil
    end
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _,v in ipairs(hrp:GetChildren()) do
            if v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
end

FlyButton.MouseButton1Click:Connect(function()
    flyActive = not flyActive
    if flyActive then
        enableFly()
        FlyButton.Text = "Fly KAPAT"
    else
        disableFly()
        FlyButton.Text = "Fly AÇ"
    end
end)

-- NOCLIP
function enableNoclip()
    if connectionNoclip then connectionNoclip:Disconnect() end
    connectionNoclip = game:GetService("RunService").Stepped:Connect(function()
        if noclipActive and plr.Character then
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end
    end)
end

function disableNoclip()
    noclipActive = false
    if connectionNoclip then
        connectionNoclip:Disconnect()
        connectionNoclip = nil
    end
    if plr.Character then
        for _, part in pairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

NoclipButton.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    if noclipActive then
        enableNoclip()
        NoclipButton.Text = "Noclip KAPAT"
    else
        disableNoclip()
        NoclipButton.Text = "Noclip AÇ"
    end
end)
