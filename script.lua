local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local states = {
    aimbot = false,
    noclip = false,
    fly = false,
    esp = false,
    spinbot = false,
    teleport = false
}
local connections = {}
local flyParts = {gyro = nil, vel = nil}
local flySpeed = 70
local selectedTPIndex = 1
local teleportGui = nil

function getOtherPlayers()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(t, p)
        end
    end
    return t
end

function aimbotFunc()
    if connections.aimbot then connections.aimbot:Disconnect() end
    connections.aimbot = RunService.RenderStepped:Connect(function()
        if not states.aimbot then return end
        local closest, dist = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                local pos, onscreen = Camera:WorldToViewportPoint(hrp.Position)
                if onscreen then
                    local d = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if d < dist then
                        dist = d
                        closest = hrp
                    end
                end
            end
        end
        if closest then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
        end
    end)
end

function espFunc()
    if connections.esp then connections.esp:Disconnect() end
    connections.esp = RunService.RenderStepped:Connect(function()
        if not states.esp then
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Head") then
                    local bb = p.Character.Head:FindFirstChild("ESPBOX")
                    if bb then bb:Destroy() end
                end
            end
            return
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                if not p.Character.Head:FindFirstChild("ESPBOX") then
                    local bb = Instance.new("BillboardGui", p.Character.Head)
                    bb.Name = "ESPBOX"
                    bb.Size = UDim2.new(4,0,4,0)
                    bb.Adornee = p.Character.Head
                    bb.AlwaysOnTop = true
                    local f = Instance.new("Frame", bb)
                    f.Size = UDim2.new(1,0,1,0)
                    f.BackgroundColor3 = Color3.fromRGB(10,255,60)
                    f.BackgroundTransparency = 0.4
                    f.BorderSizePixel = 0
                end
            end
        end
    end)
end

function noclipFunc()
    if connections.noclip then connections.noclip:Disconnect() end
    connections.noclip = RunService.Stepped:Connect(function()
        if not states.noclip then return end
        if LocalPlayer.Character then
            for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)
end

function flyFunc()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    flyParts.gyro = Instance.new("BodyGyro", hrp)
    flyParts.gyro.P = 9e4
    flyParts.gyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    flyParts.gyro.CFrame = hrp.CFrame
    flyParts.vel = Instance.new("BodyVelocity", hrp)
    flyParts.vel.Velocity = Vector3.new(0,0,0)
    flyParts.vel.MaxForce = Vector3.new(9e9,9e9,9e9)
    local control = {F=0, B=0, L=0, R=0, U=0, D=0}
    local speed = flySpeed
    connections.fly_input1 = UserInputService.InputBegan:Connect(function(key, p)
        if p then return end
        if key.KeyCode == Enum.KeyCode.W then control.F = 1 end
        if key.KeyCode == Enum.KeyCode.S then control.B = 1 end
        if key.KeyCode == Enum.KeyCode.A then control.L = 1 end
        if key.KeyCode == Enum.KeyCode.D then control.R = 1 end
        if key.KeyCode == Enum.KeyCode.Space then control.U = 1 end
        if key.KeyCode == Enum.KeyCode.LeftControl then control.D = 1 end
    end)
    connections.fly_input2 = UserInputService.InputEnded:Connect(function(key, p)
        if p then return end
        if key.KeyCode == Enum.KeyCode.W then control.F = 0 end
        if key.KeyCode == Enum.KeyCode.S then control.B = 0 end
        if key.KeyCode == Enum.KeyCode.A then control.L = 0 end
        if key.KeyCode == Enum.KeyCode.D then control.R = 0 end
        if key.KeyCode == Enum.KeyCode.Space then control.U = 0 end
        if key.KeyCode == Enum.KeyCode.LeftControl then control.D = 0 end
    end)
    connections.flymove = RunService.RenderStepped:Connect(function()
        if not states.fly then return end
        local camCF = workspace.CurrentCamera.CFrame
        local mv = Vector3.new()
        if control.F == 1 then mv = mv + camCF.LookVector end
        if control.B == 1 then mv = mv - camCF.LookVector end
        if control.L == 1 then mv = mv - camCF.RightVector end
        if control.R == 1 then mv = mv + camCF.RightVector end
        if control.U == 1 then mv = mv + camCF.UpVector end
        if control.D == 1 then mv = mv - camCF.UpVector end
        if mv.Magnitude > 0 then
            flyParts.vel.Velocity = mv.Unit * speed
        else
            flyParts.vel.Velocity = Vector3.new(0,0,0)
        end
        flyParts.gyro.CFrame = camCF
    end)
end

function stopFlyFunc()
    if flyParts.gyro then pcall(function() flyParts.gyro:Destroy() end) flyParts.gyro = nil end
    if flyParts.vel then pcall(function() flyParts.vel:Destroy() end) flyParts.vel = nil end
    if connections.fly_input1 then connections.fly_input1:Disconnect() end
    if connections.fly_input2 then connections.fly_input2:Disconnect() end
    if connections.flymove then connections.flymove:Disconnect() end
end

function spinbotFunc()
    if connections.spinbot then connections.spinbot:Disconnect() end
    connections.spinbot = RunService.RenderStepped:Connect(function()
        if not states.spinbot then return end
        if not states.fly then return end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(10), 0)
        end
    end)
end

function showTeleportMenu()
    if teleportGui then teleportGui:Destroy() end
    teleportGui = Instance.new("ScreenGui")
    teleportGui.Name = "TeleportGUI"
    teleportGui.ResetOnSpawn = false
    teleportGui.Parent = game:GetService("CoreGui")
    local frame = Instance.new("Frame", teleportGui)
    frame.Size = UDim2.new(0, 300, 0, 40+30*#getOtherPlayers())
    frame.Position = UDim2.new(0.5, -150, 0.4, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,50)
    frame.BorderSizePixel = 0
    local uilist = Instance.new("UIListLayout", frame)
    uilist.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uilist.SortOrder = Enum.SortOrder.LayoutOrder
    local lab = Instance.new("TextLabel", frame)
    lab.Text = "TELEPORT PLAYER - Yukarı/Aşağı: Seç, [A]: Teleport, [ESC]: Çık"
    lab.Size = UDim2.new(1,0,0,30)
    lab.BackgroundTransparency = 1
    lab.TextColor3 = Color3.new(1,1,1)
    local tPlayers = getOtherPlayers()
    selectedTPIndex = 1
    local btns = {}
    for i, p in ipairs(tPlayers) do
        btns[i] = Instance.new("TextButton", frame)
        btns[i].Size = UDim2.new(1,-10,0,28)
        btns[i].Text = p.DisplayName.." ("..p.Name..")"
        btns[i].BackgroundColor3 = (i==selectedTPIndex) and Color3.fromRGB(24,177,140) or Color3.fromRGB(60,68,100)
        btns[i].TextColor3 = Color3.new(1,1,1)
        btns[i].AutoButtonColor = false
        btns[i].MouseButton1Click:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                teleportGui:Destroy()
            end
        end)
    end
    local function updateSelBtn()
        for i, b in ipairs(btns) do
            b.BackgroundColor3 = (i==selectedTPIndex) and Color3.fromRGB(24,177,140) or Color3.fromRGB(60,68,100)
        end
    end
    connections.tpInput = UserInputService.InputBegan:Connect(function(input, gamep)
        if not teleportGui or not teleportGui.Parent then return end
        if input.KeyCode == Enum.KeyCode.Up then
            selectedTPIndex = math.clamp(selectedTPIndex-1, 1, #tPlayers)
            updateSelBtn()
        elseif input.KeyCode == Enum.KeyCode.Down then
            selectedTPIndex = math.clamp(selectedTPIndex+1, 1, #tPlayers)
            updateSelBtn()
        elseif input.KeyCode == Enum.KeyCode.A then
            local tgt = tPlayers[selectedTPIndex]
            if tgt and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = tgt.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            end
            teleportGui:Destroy()
            if connections.tpInput then connections.tpInput:Disconnect() end
        elseif input.KeyCode == Enum.KeyCode.Escape then
            teleportGui:Destroy()
            if connections.tpInput then connections.tpInput:Disconnect() end
        end
    end)
end

function toggleFeature(feat)
    states[feat] = not states[feat]
    if feat == "aimbot" then
        if states.aimbot then
            aimbotFunc()
        else
            if connections.aimbot then connections.aimbot:Disconnect() end
        end
    elseif feat == "noclip" then
        if states.noclip then
            noclipFunc()
        else
            if connections.noclip then connections.noclip:Disconnect() end
        end
    elseif feat == "fly" then
        if states.fly then
            flyFunc()
        else
            stopFlyFunc()
        end
    elseif feat == "esp" then
        if states.esp then
            espFunc()
        else
            if connections.esp then connections.esp:Disconnect() end
            for _,p in ipairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Head") then
                    local bb = p.Character.Head:FindFirstChild("ESPBOX")
                    if bb then bb:Destroy() end
                end
            end
        end
    elseif feat == "spinbot" then
        if states.spinbot then
            spinbotFunc()
        else
            if connections.spinbot then connections.spinbot:Disconnect() end
        end
    end
end

function showMenu()
    if connections.menuInput then connections.menuInput:Disconnect() end
    if _G.HileMenu then pcall(function() _G.HileMenu:Destroy() end) end
    local menu = Instance.new("ScreenGui")
    menu.Name = "HileMenu"
    menu.ResetOnSpawn = false
    menu.Parent = game:GetService("CoreGui")
    _G.HileMenu = menu
    local frame = Instance.new("Frame",menu)
    frame.Size = UDim2.new(0,340,0,295)
    frame.Position = UDim2.new(0.02,0,0.3,0)
    frame.BackgroundColor3 = Color3.fromRGB(40,50,60)
    frame.BorderSizePixel = 0
    local uil = Instance.new("UIListLayout",frame)
    uil.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uil.SortOrder = Enum.SortOrder.LayoutOrder
    local items = {
        {"Aimbot", "aimbot"},
        {"Noclip", "noclip"},
        {"Fly", "fly"},
        {"ESP", "esp"},
        {"Spinbot", "spinbot"},
        {"Teleport Player", "teleport"}
    }
    local sel = 1
    local btns = {}
    for i, v in ipairs(items) do
        btns[i] = Instance.new("TextButton",frame)
        btns[i].Size = UDim2.new(1,-12,0,40)
        btns[i].Text = (v[1]) .. ((v[2]~="teleport") and " : [ "..(states[v[2]] and "Açık" or "Kapalı").." ]" or "")
        btns[i].BackgroundColor3 = (i==sel) and Color3.fromRGB(30,160,120) or Color3.fromRGB(73,80,129)
        btns[i].TextColor3 = Color3.new(1,1,1)
        btns[i].Font = Enum.Font.SourceSansBold
        btns[i].TextSize = 22
        btns[i].AutoButtonColor = false
        btns[i].MouseButton1Click:Connect(function()
            if v[2] ~= "teleport" then
                toggleFeature(v[2])
                btns[i].Text = (v[1]) .. " : [ "..(states[v[2]] and "Açık" or "Kapalı").." ]"
            elseif v[2] == "teleport" then
                showTeleportMenu()
            end
        end)
    end
    local lab = Instance.new("TextLabel",frame)
    lab.Size = UDim2.new(1,-12,0,30)
    lab.Text = "YUKARI/AŞAĞI: Seç; Enter: Aç/Kapat; [T]: TP Menüsünü Aç; ESC: Menüyü Kapat"
    lab.TextColor3 = Color3.fromRGB(210,210,230)
    lab.BackgroundTransparency = 1
    lab.Font = Enum.Font.SourceSans
    lab.TextSize = 16
    local function updateBtns()
        for i, v in ipairs(items) do
            btns[i].BackgroundColor3 = (i==sel) and Color3.fromRGB(30,160,120) or Color3.fromRGB(73,80,129)
            if v[2] ~= "teleport" then
                btns[i].Text = (v[1]).." : [ "..(states[v[2]] and "Açık" or "Kapalı").." ]"
            end
        end
    end
    connections.menuInput = UserInputService.InputBegan:Connect(function(input, p)
        if not menu.Parent then return end
        if input.KeyCode == Enum.KeyCode.Up then sel = sel>1 and sel-1 or #items updateBtns()
        elseif input.KeyCode == Enum.KeyCode.Down then sel = sel<#items and sel+1 or 1 updateBtns()
        elseif input.KeyCode == Enum.KeyCode.Return or input.KeyCode==Enum.KeyCode.KeypadEnter then
            local entry = items[sel]
            if entry[2]~="teleport" then
                toggleFeature(entry[2])
                updateBtns()
            else
                showTeleportMenu()
            end
        elseif input.KeyCode == Enum.KeyCode.T then showTeleportMenu()
        elseif input.KeyCode == Enum.KeyCode.Escape then
            menu:Destroy()
            if connections.menuInput then connections.menuInput:Disconnect() end
        end
    end)
end

toggleFeature("aimbot")
toggleFeature("aimbot")
toggleFeature("noclip")
toggleFeature("noclip")
toggleFeature("fly")
toggleFeature("fly")
toggleFeature("esp")
toggleFeature("esp")
toggleFeature("spinbot")
toggleFeature("spinbot")

UserInputService.InputBegan:Connect(function(input,gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F6 then
        showMenu()
    end
end)
