local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local aimbotEnabled = false
local noclipEnabled = false
local flyEnabled = false
local espEnabled = false
local spinbotEnabled = false
local teleporting = false
local flySpeed = 70
local spinSpeed = 10
local selectedTPIndex = 1
local bodyGyro, bodyVelocity = nil, nil

local function getAllPlayers()
    local plrs = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(plrs, p)
        end
    end
    return plrs
end

local function getClosestPlayer()
    local closest = nil
    local shortest = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local pos, ons = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if ons then
                local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

local function enableESP()
    espEnabled = true
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and not player.Character.Head:FindFirstChild("ESPBox") then
            local bb = Instance.new("BillboardGui", player.Character.Head)
            bb.Name = "ESPBox"
            bb.Size = UDim2.new(4,0,4,0)
            bb.Adornee = player.Character.Head
            bb.AlwaysOnTop = true
            local f = Instance.new("Frame", bb)
            f.Size = UDim2.new(1,0,1,0)
            f.Transparency = 0.6
            f.BackgroundColor3 = Color3.fromRGB(13,255,0)
            f.BorderSizePixel = 0
        end
    end
    RunService.RenderStepped:Connect(function()
        if not espEnabled then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local bb = player.Character.Head:FindFirstChild("ESPBox")
                if bb then
                    bb.Enabled = player.Character:FindFirstChildOfClass("Humanoid").Health > 0
                end
            end
        end
    end)
end
local function disableESP()
    espEnabled = false
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local bb = player.Character.Head:FindFirstChild("ESPBox")
            if bb then
                bb:Destroy()
            end
        end
    end
end

local function enableNoclip()
    noclipEnabled = true
    RunService.Stepped:Connect(function()
        if noclipEnabled and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)
end
local function disableNoclip()
    noclipEnabled = false
    if LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
end

local function startFly()
    flyEnabled = true
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if char and hrp then
        bodyGyro = Instance.new("BodyGyro", hrp)
        bodyGyro.P = 9e4
        bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
        bodyGyro.CFrame = hrp.CFrame
        bodyVelocity = Instance.new("BodyVelocity", hrp)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
        local flying = true
        local speed = flySpeed
        local controls = {F=0,B=0,L=0,R=0,U=0,D=0}
        local function flyFunc()
            while flyEnabled and flying and char and hrp and bodyGyro and bodyVelocity do
                local new = hrp.Position
                local camCF = workspace.CurrentCamera.CFrame
                local mv = Vector3.new()
                if controls.F == 1 then mv += camCF.LookVector end
                if controls.B == 1 then mv -= camCF.LookVector end
                if controls.L == 1 then mv -= camCF.RightVector end
                if controls.R == 1 then mv += camCF.RightVector end
                if controls.U == 1 then mv += camCF.UpVector end
                if controls.D == 1 then mv -= camCF.UpVector end
                bodyVelocity.Velocity = mv.Unit * speed
                bodyGyro.CFrame = workspace.CurrentCamera.CFrame
                if mv.Magnitude == 0 then
                    bodyVelocity.Velocity = Vector3.new(0,0,0)
                end
                RunService.RenderStepped:Wait()
            end
        end
        local inputBinds = {}
        inputBinds[Enum.KeyCode.W] = function(b) controls.F = b and 1 or 0 end
        inputBinds[Enum.KeyCode.S] = function(b) controls.B = b and 1 or 0 end
        inputBinds[Enum.KeyCode.A] = function(b) controls.L = b and 1 or 0 end
        inputBinds[Enum.KeyCode.D] = function(b) controls.R = b and 1 or 0 end
        inputBinds[Enum.KeyCode.Space] = function(b) controls.U = b and 1 or 0 end
        inputBinds[Enum.KeyCode.LeftControl] = function(b) controls.D = b and 1 or 0 end
        UserInputService.InputBegan:Connect(function(input)
            if inputBinds[input.KeyCode] then inputBinds[input.KeyCode](true) end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if inputBinds[input.KeyCode] then inputBinds[input.KeyCode](false) end
        end)
        coroutine.wrap(flyFunc)()
    end
end
local function stopFly()
    flyEnabled = false
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    pcall(function() if bodyGyro then bodyGyro:Destroy() end end)
    pcall(function() if bodyVelocity then bodyVelocity:Destroy() end end)
end

local function aimbot()
    aimbotEnabled = true
    RunService.RenderStepped:Connect(function()
        if aimbotEnabled and Camera and (not flyEnabled or (flyEnabled and spinbotEnabled == false)) then
            local plr = getClosestPlayer()
            if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = plr.Character.HumanoidRootPart.Position
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            end
        end
    end)
end
local function stopAimbot() aimbotEnabled = false end

local function spinbot()
    spinbotEnabled = true
    RunService.RenderStepped:Connect(function()
        if spinbotEnabled and flyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(spinSpeed),0)
        end
    end)
end
local function stopSpinbot() spinbotEnabled = false end

local function getTPPlayers()
    local plrs = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(plrs, p)
        end
    end
    return plrs
end

local function teleportMenu()
    teleporting = true
    local plrs = getTPPlayers()
    if #plrs == 0 then return end
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "TPMenu"
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0,250,0,30+#plrs*30)
    frame.Position = UDim2.new(0.5,-125,0.3,0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    local layout = Instance.new("UIListLayout", frame)
    layout.FillDirection = Enum.FillDirection.Vertical

    for i, p in ipairs(plrs) do
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1,0,0,30)
        btn.Text = "["..i.."] "..p.DisplayName.." ("..p.Name..")"
        btn.BackgroundColor3 = Color3.fromRGB(65,65,65)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.MouseButton1Click:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            end
            if gui then gui:Destroy() end
            teleporting = false
        end)
    end
    UserInputService.InputBegan:Connect(function(input)
        if not teleporting then return end
        if input.KeyCode == Enum.KeyCode.A then
            local num = tonumber(UserInputService:GetFocusedTextBox() and UserInputService:GetFocusedTextBox().Text or "")
            if not num then num = selectedTPIndex end
            local tgt = plrs[selectedTPIndex]
            if tgt and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = tgt.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            end
            if gui then gui:Destroy() end
            teleporting = false
        elseif input.KeyCode == Enum.KeyCode.Down then
            selectedTPIndex = math.clamp(selectedTPIndex+1, 1, #plrs)
        elseif input.KeyCode == Enum.KeyCode.Up then
            selectedTPIndex = math.clamp(selectedTPIndex-1, 1, #plrs)
        elseif input.KeyCode == Enum.KeyCode.Escape then
            if gui then gui:Destroy() end
            teleporting = false
        end
    end)
end

enableESP()
aimbot()
enableNoclip()
startFly()
spinbot()

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        if aimbotEnabled then stopAimbot() else aimbot() end
    elseif input.KeyCode == Enum.KeyCode.F2 then
        if noclipEnabled then disableNoclip() else enableNoclip() end
    elseif input.KeyCode == Enum.KeyCode.F3 then
        if flyEnabled then stopFly() else startFly() end
    elseif input.KeyCode == Enum.KeyCode.F4 then
        if espEnabled then disableESP() else enableESP() end
    elseif input.KeyCode == Enum.KeyCode.F5 then
        if spinbotEnabled then stopSpinbot() else spinbot() end
    elseif input.KeyCode == Enum.KeyCode.T then
        if not teleporting then teleportMenu() end
    end
end)
