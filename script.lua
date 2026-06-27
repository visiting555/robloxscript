local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local gui = Instance.new("ScreenGui")
gui.Name = "ModernCheatGUI"
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = LP:FindFirstChildOfClass("PlayerGui") end

local frame = Instance.new("Frame")
frame.Parent = gui
frame.BackgroundColor3 = Color3.fromRGB(28, 31, 42)
frame.Size = UDim2.new(0, 400, 0, 455)
frame.Position = UDim2.new(0.5, -200, 0.5, -220)
frame.BorderSizePixel = 0

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Parent = frame
title.Text = "Roblox Modern Menü"
title.Size = UDim2.new(1, 0, 0, 54)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(222,245,255)
title.TextStrokeTransparency = .4
title.Font = Enum.Font.GothamBold
title.TextSize = 32

local options = {
    {name="Aimbot",      kind="Toggle"},
    {name="ESP",         kind="Toggle"},
    {name="SilentAim",   kind="Toggle"},
    {name="Noclip",      kind="Toggle"},
    {name="Fly",         kind="Toggle"},
    {name="Teleport",    kind="PickPlayer"}
}
local optStates, btns = {}, {}
local dropdownHandle = nil

local function notify(txt)
    local n = Instance.new("TextLabel")
    n.Parent = frame
    n.Text = txt
    n.Size = UDim2.new(1, 0, 0, 28)
    n.Position = UDim2.new(0,0,1,-34)
    n.BackgroundTransparency = 0.3
    n.BackgroundColor3 = Color3.fromRGB(20,20,20)
    n.TextColor3 = Color3.fromRGB(255,225,90)
    n.Font = Enum.Font.GothamSemibold
    n.TextSize = 20
    n.ZIndex = 30
    task.wait(2.8)
    pcall(function() n:Destroy() end)
end

local function playerDropdown(cb)
    if dropdownHandle then pcall(function() dropdownHandle:Destroy() end) end
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, 290, 0, 220)
    panel.Position = UDim2.new(0.5,-145,0.5,-110)
    panel.BackgroundColor3 = Color3.fromRGB(36,40,56)
    panel.BorderSizePixel = 0
    local cr = Instance.new("UICorner", panel)
    cr.CornerRadius = UDim.new(0,11)
    panel.Parent = frame

    local scroll = Instance.new("ScrollingFrame", panel)
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 7
    scroll.CanvasSize = UDim2.new(0,0,0, math.max(1,(#Players:GetPlayers()-1)*38+10))
    scroll.BorderSizePixel = 0
    scroll.Position = UDim2.new(0,0,0,0)

    local i = 0
    for _,player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            i = i + 1
            local b = Instance.new("TextButton")
            b.Parent = scroll
            b.Size = UDim2.new(1,-10,0,34)
            b.Position = UDim2.new(0,6,0,10+(i-1)*38)
            b.TextColor3 = Color3.fromRGB(168,224,255)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 20
            b.BackgroundColor3 = Color3.fromRGB(31,50,90)
            b.Text = player.DisplayName.." ["..player.Name.."]"
            local cr2 = Instance.new("UICorner", b)
            cr2.CornerRadius = UDim.new(0,7)
            b.MouseButton1Click:Connect(function()
                if cb then cb(player) end
                panel:Destroy()
                dropdownHandle = nil
            end)
        end
    end
    dropdownHandle = panel
end

local function createOption(idx, name, kind)
    local y = 54 + (idx-1)*54
    local holder = Instance.new("Frame")
    holder.Parent = frame
    holder.Size = UDim2.new(1,-40,0,46)
    holder.Position = UDim2.new(0,24,0,y)
    holder.BackgroundTransparency = 1

    local label = Instance.new("TextLabel")
    label.Parent = holder
    label.Size = UDim2.new(0.56, 0, 1, 0)
    label.Position = UDim2.new(0,3,0,0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 22
    label.TextColor3 = Color3.fromRGB(204,227,252)
    label.TextXAlignment = Enum.TextXAlignment.Left

    if kind == "Toggle" then
        local toggle = Instance.new("TextButton")
        toggle.Parent = holder
        toggle.Size = UDim2.new(0,90,1,0)
        toggle.Position = UDim2.new(1,-97,0,0)
        toggle.Text = "KAPALI"
        toggle.Font = Enum.Font.GothamBold
        toggle.TextSize = 19
        toggle.BackgroundColor3 = Color3.fromRGB(55,77,120)
        toggle.TextColor3 = Color3.fromRGB(251,181,64)
        local cr = Instance.new("UICorner", toggle)
        cr.CornerRadius = UDim.new(0,8)
        optStates[name] = false
        toggle.MouseButton1Click:Connect(function()
            optStates[name] = not optStates[name]
            toggle.Text = optStates[name] and "AÇIK" or "KAPALI"
            toggle.BackgroundColor3 = optStates[name] and Color3.fromRGB(62,180,120) or Color3.fromRGB(55,77,120)
        end)
        btns[name] = toggle
    elseif kind == "PickPlayer" then
        local openList = Instance.new("TextButton")
        openList.Parent = holder
        openList.Size = UDim2.new(0,122,1,0)
        openList.Position = UDim2.new(1, -129, 0, 0)
        openList.Text = "OYUNCU SEÇ"
        openList.Font = Enum.Font.GothamBold
        openList.TextSize = 18
        openList.BackgroundColor3 = Color3.fromRGB(80, 67, 155)
        openList.TextColor3 = Color3.fromRGB(255,221,92)
        local cr = Instance.new("UICorner", openList)
        cr.CornerRadius = UDim.new(0,8)
        openList.MouseButton1Click:Connect(function()
            playerDropdown(function(plr)
                if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    LP.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0,7,0))
                    notify(plr.Name.." yanına ışınlandın.")
                end
            end)
        end)
        btns[name] = openList
    end
end

for i, v in ipairs(options) do
    createOption(i, v.name, v.kind)
end

local currentESP = {}
local espRunning = false

local function updateESP()
    for p, obj in pairs(currentESP) do
        if not p.Parent or not Players:FindFirstChild(p.Name) then
            if obj and typeof(obj.Remove)=="function" then obj:Remove() end
            currentESP[p] = nil
        end
    end
end

local function startESP()
    if espRunning then return end
    espRunning = true
    RS.RenderStepped:Connect(function()
        updateESP()
        if not optStates["ESP"] then for _,o in pairs(currentESP) do pcall(function() if typeof(o.Remove)=="function" then o:Remove() end end) end currentESP = {} return end
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                if not currentESP[p] then
                    if Drawing and Drawing.new then
                        local s = Drawing.new("Square")
                        s.Color = Color3.fromRGB(74,227,255)
                        s.Thickness = 2
                        s.Transparency = 1
                        s.Filled = false
                        s.Visible = true
                        currentESP[p] = s
                    end
                end
                if currentESP[p] then
                    local pos,vis = Cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                    currentESP[p].Position = Vector2.new(pos.X-35, pos.Y-55)
                    currentESP[p].Size = Vector2.new(70,105)
                    currentESP[p].Visible = vis
                end
            elseif currentESP[p] then
                currentESP[p].Visible = false
            end
        end
    end)
end

local function startAimbot()
    RS.RenderStepped:Connect(function()
        if optStates["Aimbot"] then
            local closest, mindist = nil, math.huge
            for _,v in pairs(Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                    local headPos, onscreen = Cam:WorldToViewportPoint(v.Character.Head.Position)
                    if onscreen then
                        local dist = (Vector2.new(headPos.X, headPos.Y) - Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)).Magnitude
                        if dist < mindist then
                            mindist = dist
                            closest = v
                        end
                    end
                end
            end
            if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                Cam.CFrame = CFrame.new(Cam.CFrame.Position, closest.Character.Head.Position)
            end
        end
    end)
end

local __random = function()
    local t = tick() * math.pi
    return math.abs(math.sin(t*3.97)+math.cos(t*1.51)*math.sin(t*2.05))
end

local function startSilentAim()
    -- Fake raycast/hitbox math; binds to Mouse.Target or closest part to mouse
    local mouse = LP:GetMouse()
    local function getClosest()
        local mindist, target, tarpos = math.huge, nil, nil
        for _,v in pairs(Players:GetPlayers()) do
            if v~=LP and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local pos,onscr = Cam:WorldToViewportPoint(v.Character.Head.Position)
                local mpos = Vector2.new(mouse.X, mouse.Y)
                local dist = (Vector2.new(pos.X, pos.Y)-mpos).Magnitude
                if dist<mindist then
                    mindist,target,tarpos = dist,v,v.Character.Head.Position
                end
            end
        end
        return target, tarpos
    end
    mouse.Button1Down:Connect(function()
        if optStates["SilentAim"] then
            local plr,pos = getClosest()
            if plr and pos then
                -- math.power: imlece yakınına saptır
                local offset = Vector3.new(
                    math.sin(tick()*__random())*0.3,
                    math.cos(tick()*__random())*0.15,
                    0)
                mouse.Target = plr.Character.Head
                mouse.Hit = CFrame.new(pos+offset)
            end
        end
    end)
end

local flyCon = nil
local function startFly()
    local bv = nil
    flyCon = UIS.InputBegan:Connect(function(input, gpe)
        if not optStates["Fly"] then if bv then bv:Destroy() bv=nil end return end
        if input.KeyCode == Enum.KeyCode.Space and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            if not bv then
                bv=Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(1,1,1)*999999
                bv.Velocity = Vector3.new(0,64,0)
                bv.Parent = LP.Character.HumanoidRootPart
            end
        end
    end)
    UIS.InputEnded:Connect(function(input, gpe)
        if input.KeyCode == Enum.KeyCode.Space and bv then
            bv:Destroy()
            bv = nil
        end
    end)
end

local noclipCon = nil
local function startNoclip()
    RS.Stepped:Connect(function()
        if optStates["Noclip"] and LP.Character then
            for _, v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end

startESP()
startAimbot()
startSilentAim()
startFly()
startNoclip()
