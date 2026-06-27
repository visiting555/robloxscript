local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui")
gui.Name = "hilescriptmenu"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 380)
frame.Position = UDim2.new(0, 25, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Hile Script Menüsü"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Parent = frame

local yOffset = 45

function makeButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -30, 0, 35)
    btn.Position = UDim2.new(0, 15, 0, yOffset)
    btn.BackgroundColor3 = Color3.fromRGB(44,44,44)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Parent = frame
    yOffset = yOffset + 40
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local aimbotEnabled = false
local noclipEnabled = false
local flyEnabled = false
local espEnabled = false
local spinbotEnabled = false
local teleportGui = nil
local teleporting = false
local flySpeed = 60
local bodyGyro = nil
local bodyVelocity = nil

function getClosestPlayer()
    local closest = nil
    local shortest = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local pos = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if pos.Z > 0 then
                local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).magnitude
                if dist < shortest then
                    shortest = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

makeButton("Aimbot [AÇ/KAPA]", function()
    aimbotEnabled = not aimbotEnabled
end)

makeButton("Noclip [AÇ/KAPA]", function()
    noclipEnabled = not noclipEnabled
end)

makeButton("Fly [AÇ/KAPA]", function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            bodyGyro = Instance.new("BodyGyro", root)
            bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
            bodyGyro.P = 1e5
            bodyVelocity = Instance.new("BodyVelocity", root)
            bodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
        end
    else
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
        bodyGyro = nil
        bodyVelocity = nil
    end
end)

makeButton("ESP [AÇ/KAPA]", function()
    espEnabled = not espEnabled
    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if player.Character and player.Character:FindFirstChild("Head") and not player.Character.Head:FindFirstChild("ESP") then
                    local box = Instance.new("BillboardGui", player.Character.Head)
                    box.Name = "ESP"
                    box.Size = UDim2.new(4, 0, 4, 0)
                    box.AlwaysOnTop = true
                    local frame2 = Instance.new("Frame", box)
                    frame2.Size = UDim2.new(1, 0, 1, 0)
                    frame2.BackgroundColor3 = Color3.new(1, 0, 0)
                    frame2.BackgroundTransparency = 0.5
                    frame2.BorderSizePixel = 0
                end
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                if player.Character.Head:FindFirstChild("ESP") then
                    player.Character.Head.ESP:Destroy()
                end
            end
        end
    end
end)

makeButton("Spinbot [AÇ/KAPA]", function()
    spinbotEnabled = not spinbotEnabled
end)

makeButton("Teleport Player", function()
    if teleporting then return end
    teleporting = true
    teleportGui = Instance.new("ScreenGui", game.CoreGui)
    teleportGui.Name = "TeleportGUI"
    local win = Instance.new("Frame", teleportGui)
    win.Size = UDim2.new(0, 260, 0, 370)
    win.Position = UDim2.new(0, 340, 0.5, -180)
    win.BackgroundColor3 = Color3.fromRGB(30,30,30)
    win.Active = true
    win.Draggable = true

    local lbl = Instance.new("TextLabel", win)
    lbl.Size = UDim2.new(1, 0, 0, 40)
    lbl.Text = "Teleport Olmak İçin Oyuncu Seç"
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    lbl.TextSize = 18

    local plList = Instance.new("ScrollingFrame", win)
    plList.Size = UDim2.new(1, -10, 1, -60)
    plList.Position = UDim2.new(0,5,0,45)
    plList.CanvasSize = UDim2.new(0,0,0, #Players:GetPlayers() * 40)
    plList.BackgroundTransparency = 1
    plList.BorderSizePixel = 0
    local uilayout = Instance.new("UIListLayout", plList)
    uilayout.Padding = UDim.new(0, 2)
    plList.ScrollBarThickness = 8

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local plbtn = Instance.new("TextButton", plList)
            plbtn.Size = UDim2.new(1, 0, 0, 35)
            plbtn.BackgroundColor3 = Color3.new(0.3,0.3,0.3)
            plbtn.Text = player.Name
            plbtn.TextColor3 = Color3.new(1,1,1)
            plbtn.Font = Enum.Font.SourceSansBold
            plbtn.TextSize = 17
            plbtn.Name = player.Name
            plbtn.MouseButton1Click:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
                end
            end)
        end
    end

    local close = Instance.new("TextButton", win)
    close.Size = UDim2.new(1,0,0,32)
    close.Position = UDim2.new(0,0,1,-32)
    close.Text = "Kapat"
    close.BackgroundColor3 = Color3.fromRGB(80,0,0)
    close.TextColor3 = Color3.new(1,1,1)
    close.Font = Enum.Font.SourceSansBold
    close.TextSize = 18
    close.MouseButton1Click:Connect(function()
        teleportGui:Destroy()
        teleporting = false
    end)
end)

RunService.RenderStepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    if flyEnabled then
        if not bodyGyro or not bodyVelocity or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        local root = LocalPlayer.Character.HumanoidRootPart
        root.Anchored = false
        bodyGyro.CFrame = Camera.CFrame
        local moveDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Camera.CFrame.UpVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Camera.CFrame.UpVector end
        if moveDir.Magnitude > 0 then
            bodyVelocity.Velocity = moveDir.Unit * flySpeed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end
    if spinbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(25), 0)
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 and aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") and (not flyEnabled or (flyEnabled and not spinbotEnabled)) then
            local cf = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            Camera.CFrame = cf
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    if espEnabled then
        player.CharacterAdded:Connect(function(char)
            char:WaitForChild("Head")
            if not char.Head:FindFirstChild("ESP") then
                local box = Instance.new("BillboardGui", char.Head)
                box.Name = "ESP"
                box.Size = UDim2.new(4, 0, 4, 0)
                box.AlwaysOnTop = true
                local frame2 = Instance.new("Frame", box)
                frame2.Size = UDim2.new(1, 0, 1, 0)
                frame2.BackgroundColor3 = Color3.new(1, 0, 0)
                frame2.BackgroundTransparency = 0.5
                frame2.BorderSizePixel = 0
            end
        end)
    end
end)
