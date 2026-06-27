local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Feature1Btn = Instance.new("TextButton")
local Feature2Btn = Instance.new("TextButton")
local Feature3Btn = Instance.new("TextButton")
local Feature4Btn = Instance.new("TextButton")
local Feature5Btn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")

ScreenGui.Name = "ProHileMenu"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.33, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 405)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
Title.Size = UDim2.new(1,0,0,48)
Title.Font = Enum.Font.GothamBlack
Title.Text = "PRO HILE MENÜ"
Title.TextColor3 = Color3.fromRGB(0,255,127)
Title.TextSize = 26
Title.TextStrokeTransparency = 0.5

Feature1Btn.Name = "Feature1Btn"
Feature1Btn.Parent = MainFrame
Feature1Btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
Feature1Btn.Position = UDim2.new(0.1,0,0.16,0)
Feature1Btn.Size = UDim2.new(0.8, 0, 0.13, 0)
Feature1Btn.Font = Enum.Font.Gotham
Feature1Btn.Text = "Kill All"
Feature1Btn.TextColor3 = Color3.fromRGB(255,255,255)
Feature1Btn.TextSize = 19

Feature2Btn.Name = "Feature2Btn"
Feature2Btn.Parent = MainFrame
Feature2Btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
Feature2Btn.Position = UDim2.new(0.1,0,0.314,0)
Feature2Btn.Size = UDim2.new(0.8, 0, 0.13, 0)
Feature2Btn.Font = Enum.Font.Gotham
Feature2Btn.Text = "Invincible Aç/Kapat"
Feature2Btn.TextColor3 = Color3.fromRGB(255,255,255)
Feature2Btn.TextSize = 19

Feature3Btn.Name = "Feature3Btn"
Feature3Btn.Parent = MainFrame
Feature3Btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
Feature3Btn.Position = UDim2.new(0.1,0,0.468,0)
Feature3Btn.Size = UDim2.new(0.8, 0, 0.13, 0)
Feature3Btn.Font = Enum.Font.Gotham
Feature3Btn.Text = "Invisible Aç/Kapat"
Feature3Btn.TextColor3 = Color3.fromRGB(255,255,255)
Feature3Btn.TextSize = 19

Feature4Btn.Name = "Feature4Btn"
Feature4Btn.Parent = MainFrame
Feature4Btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
Feature4Btn.Position = UDim2.new(0.1,0,0.622,0)
Feature4Btn.Size = UDim2.new(0.8, 0, 0.13, 0)
Feature4Btn.Font = Enum.Font.Gotham
Feature4Btn.Text = "Aimbot Aç/Kapat"
Feature4Btn.TextColor3 = Color3.fromRGB(255,255,255)
Feature4Btn.TextSize = 19

Feature5Btn.Name = "Feature5Btn"
Feature5Btn.Parent = MainFrame
Feature5Btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
Feature5Btn.Position = UDim2.new(0.1,0,0.776,0)
Feature5Btn.Size = UDim2.new(0.8, 0, 0.13, 0)
Feature5Btn.Font = Enum.Font.Gotham
Feature5Btn.Text = "Spinbot Aç/Kapat"
Feature5Btn.TextColor3 = Color3.fromRGB(255,255,255)
Feature5Btn.TextSize = 19

CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
CloseBtn.Position = UDim2.new(0.92,0,0,0)
CloseBtn.Size = UDim2.new(0.08,0,0,48)
CloseBtn.Font = Enum.Font.GothamBlack
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.TextSize = 20

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
local Root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local invincible = false
local invisible = false
local aimbot = false
local aimbotConn = nil
local spinbot = false
local spinconn = nil
local fly = false
local flyConn = nil

Feature1Btn.MouseButton1Click:Connect(function()
    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum.Health > 0 then
                hum.Health = 0
            end
        end
    end
end)

Feature2Btn.MouseButton1Click:Connect(function()
    invincible = not invincible
    if invincible then
        Feature2Btn.Text = "Invincible Kapat"
        if humanoid then
            humanoid.Name = "NotHumanoid"
        end
    else
        Feature2Btn.Text = "Invincible Aç"
        if character:FindFirstChild("NotHumanoid") then
            character.NotHumanoid.Name = "Humanoid"
        end
    end
end)

Feature3Btn.MouseButton1Click:Connect(function()
    invisible = not invisible
    if invisible then
        Feature3Btn.Text = "Invisible Kapat"
        for _,v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v.Transparency = 1
                if v:FindFirstChildOfClass("Decal") then
                    for _,d in pairs(v:GetChildren()) do
                        if d:IsA("Decal") then
                            d.Transparency = 1
                        end
                    end
                end
            end
        end
    else
        Feature3Btn.Text = "Invisible Aç"
        for _,v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v.Transparency = 0
                if v:FindFirstChildOfClass("Decal") then
                    for _,d in pairs(v:GetChildren()) do
                        if d:IsA("Decal") then
                            d.Transparency = 0
                        end
                    end
                end
            end
        end
    end
end)

Feature4Btn.MouseButton1Click:Connect(function()
    aimbot = not aimbot
    if aimbot then
        Feature4Btn.Text = "Aimbot Kapat"
        aimbotConn = RS.RenderStepped:Connect(function()
            local closest = nil
            local minDist = math.huge
            for _,plr in pairs(game.Players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health>0 then
                    local pos, visible = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                    if visible then
                        local mouse = UIS:GetMouseLocation()
                        local dist = (Vector2.new(pos.X,pos.Y)-Vector2.new(mouse.X,mouse.Y)).magnitude
                        if dist < minDist and dist < 300 then
                            minDist = dist
                            closest = plr.Character.HumanoidRootPart
                        end
                    end
                end
            end
            if closest then
                cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Position)
            end
        end)
    else
        Feature4Btn.Text = "Aimbot Aç"
        if aimbotConn then
            aimbotConn:Disconnect()
            aimbotConn = nil
        end
    end
end)

Feature5Btn.MouseButton1Click:Connect(function()
    spinbot = not spinbot
    if spinbot then
        Feature5Btn.Text = "Spinbot Kapat"
        spinconn = RS.RenderStepped:Connect(function()
            if Root then
                Root.CFrame = Root.CFrame * CFrame.Angles(0, math.rad(30), 0)
            end
        end)
    else
        Feature5Btn.Text = "Spinbot Aç"
        if spinconn then
            spinconn:Disconnect()
            spinconn = nil
        end
    end
end)

local flybtn = Instance.new("TextButton")
flybtn.Parent = MainFrame
flybtn.Name = "FlyBtn"
flybtn.BackgroundColor3 = Color3.fromRGB(40, 40, 130)
flybtn.Position = UDim2.new(0.76,0,0.013,0)
flybtn.Size = UDim2.new(0.2,0,0.10,0)
flybtn.Font = Enum.Font.Gotham
flybtn.Text = "Fly Aç/Kapat"
flybtn.TextColor3 = Color3.fromRGB(255,255,255)
flybtn.TextSize = 13

flybtn.MouseButton1Click:Connect(function()
    fly = not fly
    if fly then
        flybtn.Text = "Fly Kapat"
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 9e4
        bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
        bodyGyro.CFrame = Root.CFrame
        bodyGyro.Parent = Root
        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.Velocity = Vector3.new(0,0,0)
        bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
        bodyVel.Parent = Root
        flyConn = RS.RenderStepped:Connect(function()
            local move = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then
                move = move + workspace.CurrentCamera.CFrame.LookVector * 3
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                move = move - workspace.CurrentCamera.CFrame.LookVector * 3
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                move = move - workspace.CurrentCamera.CFrame.RightVector * 3
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                move = move + workspace.CurrentCamera.CFrame.RightVector * 3
            end
            bodyVel.Velocity = move + Vector3.new(0, (UIS:IsKeyDown(Enum.KeyCode.Space) and 3 or 0) - (UIS:IsKeyDown(Enum.KeyCode.LeftControl) and 3 or 0), 0)
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
        end)
    else
        flybtn.Text = "Fly Aç"
        if Root then
            for _,v in pairs(Root:GetChildren()) do
                if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
        if flyConn then
            flyConn:Disconnect()
            flyConn = nil
        end
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

UIS.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
