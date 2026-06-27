local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local aimbotEnabled = true
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
        bodyVelocity.Velocity = moveDir.Unit * flySpeed
        if moveDir.Magnitude == 0 then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end
    if spinbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(25), 0)
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        aimbotEnabled = not aimbotEnabled
    elseif input.KeyCode == Enum.KeyCode.F2 then
        noclipEnabled = not noclipEnabled
    elseif input.KeyCode == Enum.KeyCode.F3 then
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
    elseif input.KeyCode == Enum.KeyCode.F4 then
        espEnabled = not espEnabled
        if espEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    if player.Character and player.Character:FindFirstChild("Head") and not player.Character.Head:FindFirstChild("ESP") then
                        local box = Instance.new("BillboardGui", player.Character.Head)
                        box.Name = "ESP"
                        box.Size = UDim2.new(4, 0, 4, 0)
                        box.AlwaysOnTop = true
                        local frame = Instance.new("Frame", box)
                        frame.Size = UDim2.new(1, 0, 1, 0)
                        frame.BackgroundColor3 = Color3.new(1, 0, 0)
                        frame.BackgroundTransparency = 0.5
                        frame.BorderSizePixel = 0
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
    elseif input.KeyCode == Enum.KeyCode.F5 then
        spinbotEnabled = not spinbotEnabled
    elseif input.KeyCode == Enum.KeyCode.F6 then
        if not teleporting then
            teleporting = true
            teleportGui = Instance.new("ScreenGui", game.CoreGui)
            teleportGui.Name = "TeleportGUI"
            local frame = Instance.new("Frame", teleportGui)
            frame.Size = UDim2.new(0, 200, 0, 400)
            frame.Position = UDim2.new(0.5, -100, 0.5, -200)
            frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
            frame.Active = true
            frame.Draggable = true
            local uiList = Instance.new("UIListLayout", frame)
            uiList.SortOrder = Enum.SortOrder.LayoutOrder
            local close = Instance.new("TextButton", frame)
            close.Size = UDim2.new(1,0,0,25)
            close.Text = "Kapat"
            close.BackgroundColor3 = Color3.fromRGB(80,0,0)
            close.TextColor3 = Color3.new(1,1,1)
            close.MouseButton1Click:Connect(function()
                teleportGui:Destroy()
                teleporting = false
            end)
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local btn = Instance.new("TextButton", frame)
                    btn.Size = UDim2.new(1,0,0,30)
                    btn.Text = player.Name
                    btn.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
                    btn.TextColor3 = Color3.new(1,1,1)
                    btn.MouseButton1Click:Connect(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
                            teleportGui:Destroy()
                            teleporting = false
                        end
                    end)
                end
            end
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 and aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
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
                local frame = Instance.new("Frame", box)
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.new(1, 0, 0)
                frame.BackgroundTransparency = 0.5
                frame.BorderSizePixel = 0
            end
        end)
    end
end)
