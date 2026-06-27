local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local TPService = game:GetService("TeleportService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local gui = Instance.new("ScreenGui")
gui.Name = "ModernCheatGUI"
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = LP:FindFirstChildOfClass("PlayerGui") end

local frame = Instance.new("Frame")
frame.Parent = gui
frame.BackgroundColor3 = Color3.fromRGB(28, 31, 42)
frame.Size = UDim2.new(0, 400, 0, 495)
frame.Position = UDim2.new(0.5, -200, 0.5, -240)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Parent = frame
title.Text = "visitingmenu"
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
    {name="Teleport",    kind="PickPlayer"},
    {name="Rejoin",      kind="Button"}
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
    n.BackgroundColor3 = Color3.fromRGB(40,13,13)
    n.TextColor3 = Color3.fromRGB(255,83,83)
    n.Font = Enum.Font.GothamSemibold
    n.TextSize = 20
    n.ZIndex = 30
    task.wait(2.2)
    pcall(function() n:Destroy() end)
end

local function playerDropdown(cb)
    if dropdownHandle then pcall(function() dropdownHandle:Destroy() end) end
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, 290, 0, 220)
    panel.Position = UDim2.new(0.5,-145,0.5,-110)
    panel.BackgroundColor3 = Color3.fromRGB(36,12,12)
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
            b.TextColor3 = Color3.fromRGB(255,64,64)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 20
            b.BackgroundColor3 = Color3.fromRGB(49,8,8)
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
    label.TextColor3 = Color3.fromRGB(255,83,83)
    label.TextXAlignment = Enum.TextXAlignment.Left

    if kind == "Toggle" then
        local toggle = Instance.new("TextButton")
        toggle.Parent = holder
        toggle.Size = UDim2.new(0,90,1,0)
        toggle.Position = UDim2.new(1,-97,0,0)
        toggle.Text = "KAPALI"
        toggle.Font = Enum.Font.GothamBold
        toggle.TextSize = 19
        toggle.BackgroundColor3 = Color3.fromRGB(91,26,26)
        toggle.TextColor3 = Color3.fromRGB(251,181,64)
        local cr = Instance.new("UICorner", toggle)
        cr.CornerRadius = UDim.new(0,8)
        optStates[name] = false
        toggle.MouseButton1Click:Connect(function()
            optStates[name] = not optStates[name]
            toggle.Text = optStates[name] and "AÇIK" or "KAPALI"
            toggle.BackgroundColor3 = optStates[name] and Color3.fromRGB(210,33,52) or Color3.fromRGB(91,26,26)
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
        openList.BackgroundColor3 = Color3.fromRGB(225, 38, 68)
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
    elseif kind == "Button" then
        local btn = Instance.new("TextButton")
        btn.Parent = holder
        btn.Size = UDim2.new(0,105,1,0)
        btn.Position = UDim2.new(1, -113, 0, 0)
        btn.Text = name
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 18
        btn.BackgroundColor3 = Color3.fromRGB(200,26,42)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        local cr = Instance.new("UICorner", btn)
        cr.CornerRadius = UDim.new(0,8)
        btn.MouseButton1Click:Connect(function()
            if name == "Rejoin" then
                TPService:Teleport(game.PlaceId)
            end
        end)
        btns[name] = btn
    end
end

for i, v in ipairs(options) do
    createOption(i, v.name, v.kind)
end

local Drawing = Drawing
local currentESP = {}
local espConnections = {}
local espRunning = false

local function get2DFrom3D(p)
    local pos, onscreen = Cam:WorldToViewportPoint(p)
    return Vector2.new(pos.X, pos.Y), onscreen
end

local function getBoxVertsFromParts(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local size = hrp.Size
    local scale = 1.2
    local offsetY = Vector3.new(0, size.Y*scale/2, 0)
    local verts3d = {
        (hrp.Position + hrp.CFrame.RightVector*size.X/2*scale + offsetY + hrp.CFrame.LookVector*size.Z/2*scale),
        (hrp.Position - hrp.CFrame.RightVector*size.X/2*scale + offsetY + hrp.CFrame.LookVector*size.Z/2*scale),
        (hrp.Position - hrp.CFrame.RightVector*size.X/2*scale + offsetY - hrp.CFrame.LookVector*size.Z/2*scale),
        (hrp.Position + hrp.CFrame.RightVector*size.X/2*scale + offsetY - hrp.CFrame.LookVector*size.Z/2*scale),

        (hrp.Position + hrp.CFrame.RightVector*size.X/2*scale - offsetY + hrp.CFrame.LookVector*size.Z/2*scale),
        (hrp.Position - hrp.CFrame.RightVector*size.X/2*scale - offsetY + hrp.CFrame.LookVector*size.Z/2*scale),
        (hrp.Position - hrp.CFrame.RightVector*size.X/2*scale - offsetY - hrp.CFrame.LookVector*size.Z/2*scale),
        (hrp.Position + hrp.CFrame.RightVector*size.X/2*scale - offsetY - hrp.CFrame.LookVector*size.Z/2*scale),
    }
    local verts2d, onscreen = {}, true
    for i,v in pairs(verts3d) do
        local pt, scr = get2DFrom3D(v)
        verts2d[i] = pt
        onscreen = onscreen and scr
    end
    return verts2d, onscreen
end

local function getCharacterOutline(char)
    local body = {}
    for _, part in pairs(char:GetChildren()) do
        if (part:IsA("BasePart") or part:IsA("MeshPart")) and part.Name~="HumanoidRootPart" then
            table.insert(body, part)
        end
    end
    return body
end

local function drawBodyESP(p)
    if not p.Character then return end
    if not currentESP[p] then currentESP[p] = {} end

    -- 3D box
    local corners, onscreen = getBoxVertsFromParts(p.Character)
    local lines = currentESP[p].boxLines or {}
    local edgeIndexes = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
    if not lines[1] then
        for i=1,#edgeIndexes do
            local l = Drawing and Drawing.new and Drawing.new("Line") or nil
            if l then
                l.Color = Color3.fromRGB(255, 0, 0)
                l.Thickness = 2.7
                l.Transparency = 1
                l.Visible = false
                lines[i] = l
            end
        end
        currentESP[p].boxLines = lines
    end

    if corners and onscreen then
        for i,ij in ipairs(edgeIndexes) do
            local l = lines[i]
            if l then
                l.From = corners[ij[1]]
                l.To = corners[ij[2]]
                l.Visible = optStates["ESP"] and true or false
                l.Color = Color3.fromRGB(255, 0, 0)
            end
        end
    else
        for _,l in ipairs(lines) do if l then l.Visible = false end end
    end

    -- Body outline
    local outline = currentESP[p].outlineParts or {}
    local idx = 1
    for _,part in pairs(getCharacterOutline(p.Character)) do
        local size = part.Size
        local corners3d = {
            part.CFrame * Vector3.new( size.X/2,  size.Y/2,  size.Z/2),
            part.CFrame * Vector3.new(-size.X/2,  size.Y/2,  size.Z/2),
            part.CFrame * Vector3.new(-size.X/2, -size.Y/2,  size.Z/2),
            part.CFrame * Vector3.new( size.X/2, -size.Y/2,  size.Z/2),
            part.CFrame * Vector3.new( size.X/2,  size.Y/2, -size.Z/2),
            part.CFrame * Vector3.new(-size.X/2,  size.Y/2, -size.Z/2),
            part.CFrame * Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
            part.CFrame * Vector3.new( size.X/2, -size.Y/2, -size.Z/2)
        }
        local c2d, visible = {}, true
        for i=1,8 do
            local pt, scr = get2DFrom3D(corners3d[i])
            c2d[i] = pt
            visible = visible and scr
        end
        local edges = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
        for _,edge in ipairs(edges) do
            if not outline[idx] then
                local l = Drawing and Drawing.new and Drawing.new("Line") or nil
                if l then l.Color=Color3.fromRGB(255,0,0) l.Thickness=1.9 l.Transparency=1 l.Visible=false end
                outline[idx] = l
            end
            local l = outline[idx]
            if l and visible then
                l.From = c2d[edge[1]]
                l.To = c2d[edge[2]]
                l.Color = Color3.fromRGB(255, 0, 0)
                l.Thickness = 1.9
                l.Visible = optStates["ESP"]
            elseif l then
                l.Visible = false
            end
            idx = idx + 1
        end
    end
    -- Clear leftovers
    for ci = idx, #(outline) do pcall(function() outline[ci].Visible = false end) end
    currentESP[p].outlineParts = outline
end

local function updateESP()
    for p, sections in pairs(currentESP) do
        if not Players:FindFirstChild(p.Name) or not p.Character then
            local boxLines = sections.boxLines or {}
            for _,l in ipairs(boxLines) do if l and typeof(l.Remove)=="function" then l:Remove() end end
            local outlineParts = sections.outlineParts or {}
            for _,l in ipairs(outlineParts) do if l and typeof(l.Remove)=="function" then l:Remove() end end
            currentESP[p] = nil
        end
    end
end

local function startESP()
    if espRunning then return end
    espRunning = true
    RS.RenderStepped:Connect(function()
        updateESP()
        if not optStates["ESP"] then
            for _,sections in pairs(currentESP) do
                for _,l in ipairs(sections.boxLines or {}) do if l then l.Visible=false end end
                for _,l in ipairs(sections.outlineParts or {}) do if l then l.Visible=false end end
            end
            return
        end
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                drawBodyESP(p)
            elseif currentESP[p] then
                local sec = currentESP[p]
                for _,l in ipairs(sec.boxLines or {}) do if l then l.Visible=false end end
                for _,l in ipairs(sec.outlineParts or {}) do if l then l.Visible=false end end
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
                local offset = Vector3.new(
                    math.sin(tick()*__random())*0.31,
                    math.cos(tick()*__random())*0.19,
                    0)
                mouse.Target = plr.Character.Head
                mouse.Hit = CFrame.new(pos + offset)
            end
        end
    end)
end

local flyVel = Vector3.new()
local flyActive, flyBV, flyConn = false, nil, nil
local function startFly()
    flyBV = nil
    flyActive = false
    local function flyStep()
        if not optStates["Fly"] or not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then
            if flyBV then flyBV:Destroy() flyBV=nil end return
        end
        if not flyBV then
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
            flyBV.Velocity = Vector3.new()
            flyBV.Parent = LP.Character.HumanoidRootPart
        end
        local vel = Vector3.new()
        local spd = 58
        if UIS:IsKeyDown(Enum.KeyCode.W) then vel = vel + Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then vel = vel - Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then vel = vel - Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then vel = vel + Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.E) then vel = vel + Cam.CFrame.UpVector end
        if UIS:IsKeyDown(Enum.KeyCode.Q) then vel = vel - Cam.CFrame.UpVector end
        if vel.Magnitude > 0 then vel = vel.Unit * spd end
        flyBV.Velocity = vel
    end
    flyConn = RS.RenderStepped:Connect(flyStep)
    UIS.InputBegan:Connect(function(i,gpe) if not gpe and i.KeyCode==Enum.KeyCode.F and optStates["Fly"] then optStates["Fly"] = false if flyBV then flyBV:Destroy() flyBV=nil end end end)
end

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
