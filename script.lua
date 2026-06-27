local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local TPService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local gui = Instance.new("ScreenGui")
gui.Name = "VisitingMenu"
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = LP:FindFirstChildOfClass("PlayerGui") end

local menuOpen = true
local frame = Instance.new("Frame")
frame.Parent = gui
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.Size = UDim2.new(0, 580, 0, 480)
frame.Position = UDim2.new(0.5, -290, 0.5, -240)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = true
local mainUICorner = Instance.new("UICorner", frame)
mainUICorner.CornerRadius = UDim.new(0, 13)
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1,0,0,54)
header.Position = UDim2.new(0,0,0,0)
header.BackgroundColor3 = Color3.fromRGB(16,16,16)
header.BorderSizePixel = 0
local hc = Instance.new("UICorner", header)
hc.CornerRadius = UDim.new(0,13)
local baslik = Instance.new("TextLabel", header)
baslik.Text = "visitingmenu"
baslik.Size = UDim2.new(1, 0, 1, 0)
baslik.BackgroundTransparency = 1
baslik.TextColor3 = Color3.fromRGB(255,83,83)
baslik.TextStrokeTransparency = .4
baslik.Font = Enum.Font.GothamBold
baslik.TextSize = 33
local kapat = Instance.new("TextButton", header)
kapat.Size = UDim2.new(0,44,0,44)
kapat.Position = UDim2.new(1,-52,0,6)
kapat.BackgroundColor3 = Color3.fromRGB(40,0,0)
local ccr = Instance.new("UICorner", kapat)
ccr.CornerRadius = UDim.new(1,0)
kapat.Text = "✕"
kapat.TextColor3 = Color3.fromRGB(255,83,83)
kapat.Font = Enum.Font.GothamBold
kapat.TextSize = 26
kapat.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    frame.Visible = menuOpen
end)
UIS.InputBegan:Connect(function(input,gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
        menuOpen = not menuOpen
        frame.Visible = menuOpen
    end
end)

local sideBar = Instance.new("Frame", frame)
sideBar.Size = UDim2.new(0,160,1,-54)
sideBar.Position = UDim2.new(0,0,0,54)
sideBar.BackgroundColor3 = Color3.fromRGB(13,13,13)
sideBar.BorderSizePixel = 0
local sbc = Instance.new("UICorner", sideBar)
sbc.CornerRadius = UDim.new(0,13)
local menuSections = {
    {Title="AIM HİLELERİ", Key="aim", Color=Color3.fromRGB(255,83,83)},
    {Title="GÖRÜŞ HİLELERİ", Key="vision", Color=Color3.fromRGB(255,83,83)},
    {Title="DÜNYA HİLELERİ", Key="world", Color=Color3.fromRGB(255,83,83)},
    {Title="SERVİS", Key="servis", Color=Color3.fromRGB(255,83,83)},
}
local sectionContents = {
    aim = {
        {name="Aimbot", kind="Toggle"},
        {name="SilentAim", kind="Toggle"},
    },
    vision = {
        {name="ESP", kind="Toggle"},
        {name="Görünmezlik", kind="Toggle"},
    },
    world = {
        {name="Noclip", kind="Toggle"},
        {name="Fly", kind="Toggle"},
        {name="Teleport", kind="PickPlayer"},
        {name="Yanına Çek", kind="PickPlayer"},
        {name="Patlat", kind="PickPlayer"},
    },
    servis = {
        {name="Yeniden Katıl", kind="Button"},
    }
}

local sectionBtns = {}
local optStates, btns, dropdownHandle = {}, {}, nil
local currentSection = "aim"
local contentHolder = Instance.new("Frame", frame)
contentHolder.BackgroundTransparency = 1
contentHolder.Size = UDim2.new(0, 420, 1, -64)
contentHolder.Position = UDim2.new(0, 168, 0, 60)
for i, sec in ipairs(menuSections) do
    local b = Instance.new("TextButton", sideBar)
    b.Size = UDim2.new(1, -19, 0, 48)
    b.Position = UDim2.new(0, 9, 0, 10+(i-1)*54)
    b.Text = sec.Title
    b.Name = sec.Key
    b.TextColor3 = sec.Color
    b.Font = Enum.Font.GothamBold
    b.TextSize = 18
    b.BackgroundColor3 = Color3.fromRGB(28,28,28)
    local secorner = Instance.new("UICorner",b)
    secorner.CornerRadius = UDim.new(0,9)
    sectionBtns[sec.Key] = b
    b.MouseButton1Click:Connect(function()
        currentSection = sec.Key
        for k,v in pairs(sectionBtns) do
            v.BackgroundColor3 = (k == sec.Key and Color3.fromRGB(255,83,83)) or Color3.fromRGB(28,28,28)
            v.TextColor3 = (k == sec.Key and Color3.fromRGB(26,26,26)) or sec.Color
        end
        for _,v in ipairs(contentHolder:GetChildren()) do v:Destroy() end
        renderSection(sec.Key)
    end)
end
sectionBtns["aim"].BackgroundColor3 = Color3.fromRGB(255,83,83)
sectionBtns["aim"].TextColor3 = Color3.fromRGB(26,26,26)
function notify(txt)
    local n = Instance.new("TextLabel")
    n.Parent = frame
    n.Text = tostring(txt)
    n.Size = UDim2.new(1, 0, 0, 31)
    n.Position = UDim2.new(0,0,1,-36)
    n.BackgroundTransparency = 0.21
    n.BackgroundColor3 = Color3.fromRGB(70,0,0)
    n.TextColor3 = Color3.fromRGB(255,83,83)
    n.Font = Enum.Font.GothamSemibold
    n.TextSize = 20
    n.ZIndex = 30
    task.wait(2.08)
    pcall(function() n:Destroy() end)
end

function playerDropdown(callback)
    if dropdownHandle then pcall(function() dropdownHandle:Destroy() end) end
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, 320, 0, 238)
    panel.Position = UDim2.new(0.5,-160,0.5,-120)
    panel.BackgroundColor3 = Color3.fromRGB(0,0,0)
    panel.BorderSizePixel = 0
    local cr = Instance.new("UICorner", panel)
    cr.CornerRadius = UDim.new(0,11)
    panel.Parent = frame
    local kapatDD = Instance.new("TextButton", panel)
    kapatDD.Size = UDim2.new(0,34,0,34)
    kapatDD.Position = UDim2.new(1,-36,0,3)
    kapatDD.BackgroundTransparency = 1
    kapatDD.Text = "✖"
    kapatDD.TextColor3 = Color3.new(1,0.3,0.3)
    kapatDD.TextSize = 27
    kapatDD.Font = Enum.Font.GothamBold
    kapatDD.MouseButton1Click:Connect(function() panel:Destroy() dropdownHandle = nil end)
    local scroll = Instance.new("ScrollingFrame", panel)
    scroll.Size = UDim2.new(1, 0, 1, -30)
    scroll.Position = UDim2.new(0,0,0,29)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 8
    local numPlayers = 0
    for _,player in pairs(Players:GetPlayers()) do if player ~= LP then numPlayers = numPlayers+1 end end
    scroll.CanvasSize = UDim2.new(0,0,0, math.max(1,(numPlayers)*36+10))
    scroll.BorderSizePixel = 0
    local i = 0
    for _,player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            i = i + 1
            local b = Instance.new("TextButton")
            b.Parent = scroll
            b.Size = UDim2.new(1,-10,0,31)
            b.Position = UDim2.new(0,6,0,6+(i-1)*36)
            b.TextColor3 = Color3.fromRGB(255,64,64)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 20
            b.BackgroundColor3 = Color3.fromRGB(44,0,0)
            b.Text = player.DisplayName.." ["..player.Name.."]"
            local cr2 = Instance.new("UICorner", b)
            cr2.CornerRadius = UDim.new(0,5)
            b.MouseButton1Click:Connect(function()
                if callback then callback(player) end
                panel:Destroy()
                dropdownHandle = nil
            end)
        end
    end
    dropdownHandle = panel
end

function createOption(idx, name, typ)
    local holder = Instance.new("Frame")
    holder.Parent = contentHolder
    holder.Size = UDim2.new(1, -20, 0, 41)
    holder.Position = UDim2.new(0,10,0, 10+(idx-1)*48)
    holder.BackgroundTransparency = 1
    local label = Instance.new("TextLabel")
    label.Parent = holder
    label.Size = UDim2.new(0.45, 0, 1, 0)
    label.Position = UDim2.new(0,1,0,0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255,64,64)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 19
    label.TextXAlignment = Enum.TextXAlignment.Left

    if typ == "Toggle" then
        local tgl = Instance.new("TextButton")
        tgl.Parent = holder
        tgl.Size = UDim2.new(0,86,1,0)
        tgl.Position = UDim2.new(1,-96,0,0)
        tgl.Text = "KAPALI"
        tgl.Font = Enum.Font.GothamBold
        tgl.TextSize = 18
        tgl.BackgroundColor3 = Color3.fromRGB(103,0,0)
        tgl.TextColor3 = Color3.fromRGB(255,83,83)
        local cr = Instance.new("UICorner", tgl)
        cr.CornerRadius = UDim.new(0,6)
        optStates[name] = false
        tgl.MouseButton1Click:Connect(function()
            optStates[name] = not optStates[name]
            tgl.Text = optStates[name] and "AÇIK" or "KAPALI"
            tgl.BackgroundColor3 = optStates[name] and Color3.fromRGB(255,83,83) or Color3.fromRGB(103,0,0)
            tgl.TextColor3 = optStates[name] and Color3.new(0.13,0.13,0.13) or Color3.fromRGB(255,83,83)
        end)
        btns[name] = tgl
    elseif typ == "PickPlayer" then
        local openList = Instance.new("TextButton")
        openList.Parent = holder
        openList.Size = UDim2.new(0,110,1,0)
        openList.Position = UDim2.new(1, -120, 0, 0)
        openList.Text = name
        openList.Font = Enum.Font.GothamBold
        openList.TextSize = 17
        openList.BackgroundColor3 = Color3.fromRGB(255,83,83)
        openList.TextColor3 = Color3.new(0.07,0.07,0.07)
        local cr = Instance.new("UICorner", openList)
        cr.CornerRadius = UDim.new(0,6)
        openList.MouseButton1Click:Connect(function()
            if name=="Teleport" then
                playerDropdown(function(plr)
                    if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        LP.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0,7,0))
                        notify(plr.Name.." yanına ışınlandın.")
                    end
                end)
            elseif name=="Yanına Çek" then
                playerDropdown(function(plr)
                    if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                        plr.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame + Vector3.new(0,7,0)
                        notify(plr.Name.." sana çekildi!")
                    end
                end)
            elseif name=="Patlat" then
                playerDropdown(function(plr)
                    if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = plr.Character.HumanoidRootPart
                        local boom = Instance.new("Explosion")
                        boom.BlastRadius = 8
                        boom.BlastPressure = 100000
                        boom.DestroyJointRadiusPercent = 0.65
                        boom.Position = hrp.Position + Vector3.new(0,2,0)
                        boom.Parent = workspace
                        plr.Character:FindFirstChildOfClass("Humanoid").Health = 0
                        notify(plr.Name.." patlatıldı!")
                    end
                end)
            end
        end)
        btns[name] = openList
    elseif typ == "Button" then
        local btn = Instance.new("TextButton")
        btn.Parent = holder
        btn.Size = UDim2.new(0,114,1,0)
        btn.Position = UDim2.new(1, -124, 0, 0)
        btn.Text = name
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 16
        btn.BackgroundColor3 = Color3.fromRGB(255,83,83)
        btn.TextColor3 = Color3.new(0.09,0.09,0.09)
        local cr = Instance.new("UICorner", btn)
        cr.CornerRadius = UDim.new(0,6)
        btn.MouseButton1Click:Connect(function()
            if name == "Yeniden Katıl" then
                TPService:Teleport(game.PlaceId)
            end
        end)
        btns[name]=btn
    end
end

function renderSection(secKey)
    for _,v in ipairs(contentHolder:GetChildren()) do v:Destroy() end
    local arr = sectionContents[secKey]
    for k,v in ipairs(arr) do
        createOption(k, v.name, v.kind)
    end
end
renderSection("aim")

local Drawing = Drawing
local currentESP = {}
local espRunning = false
local ESP_DISTANCE = 350

function get2DFrom3D(p)
    local pos, onscreen = Cam:WorldToViewportPoint(p)
    return Vector2.new(pos.X, pos.Y), onscreen
end

function getBoxVertsFromParts(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local size = hrp.Size
    local scale = 1.07
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

function getCharacterOutline(char)
    local body = {}
    for _, part in pairs(char:GetChildren()) do
        if (part:IsA("BasePart") or part:IsA("MeshPart")) and part.Name~="HumanoidRootPart" then
            table.insert(body, part)
        end
    end
    return body
end

function drawBodyESP(p)
    if not p.Character then return end
    if not currentESP[p] then currentESP[p] = {} end
    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and (LP.Character.HumanoidRootPart.Position-hrp.Position).Magnitude) or 999
    if dist > ESP_DISTANCE then
        if currentESP[p] then
            if currentESP[p].boxLines then for _,l in ipairs(currentESP[p].boxLines) do if l then l.Visible=false end end end
            if currentESP[p].outlineParts then for _,l in ipairs(currentESP[p].outlineParts) do if l then l.Visible=false end end end
        end
        return
    end
    local corners, onscreen = getBoxVertsFromParts(p.Character)
    local lines = currentESP[p].boxLines or {}
    local edgeIndexes = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
    if not lines[1] then
        for i=1,#edgeIndexes do
            local l = Drawing and Drawing.new and Drawing.new("Line") or nil
            if l then
                l.Color = Color3.fromRGB(255, 0, 0)
                l.Thickness = 2.2
                l.Transparency = 0.96
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
                if l then l.Color=Color3.fromRGB(255,0,0) l.Thickness=1.25 l.Transparency=0.97 l.Visible=false end
                outline[idx] = l
            end
            local l = outline[idx]
            if l and visible then
                l.From = c2d[edge[1]]
                l.To = c2d[edge[2]]
                l.Color = Color3.fromRGB(255, 0, 0)
                l.Visible = optStates["ESP"]
            elseif l then
                l.Visible = false
            end
            idx = idx + 1
        end
    end
    for ci = idx, #(outline) do pcall(function() outline[ci].Visible = false end) end
    currentESP[p].outlineParts = outline
end

function clearDeadESP()
    for p, sections in pairs(currentESP) do
        if not Players:FindFirstChild(p.Name) or not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then
            local boxLines = sections.boxLines or {}
            for _,l in ipairs(boxLines) do if l and typeof(l.Remove)=="function" then l:Remove() end end
            local outlineParts = sections.outlineParts or {}
            for _,l in ipairs(outlineParts) do if l and typeof(l.Remove)=="function" then l:Remove() end end
            currentESP[p] = nil
        end
    end
end

function startESP()
    if espRunning then return end
    espRunning = true
    local ESPUpdateTick = 0
    RS.RenderStepped:Connect(function(dt)
        ESPUpdateTick = ESPUpdateTick + dt
        if ESPUpdateTick < 0.033 then
            return
        end
        ESPUpdateTick = 0
        if not optStates["ESP"] then
            for _,sections in pairs(currentESP) do
                for _,l in ipairs(sections.boxLines or {}) do if l then l.Visible=false end end
                for _,l in ipairs(sections.outlineParts or {}) do if l then l.Visible=false end end
            end
            return
        end
        local framePlayers = {}
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                table.insert(framePlayers, p)
            end
        end
        clearDeadESP()
        for _,p in pairs(framePlayers) do
            drawBodyESP(p)
        end
    end)
end

function startAimbot()
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

local function __random()
    local t = tick() * math.pi
    return math.abs(math.sin(t*3.97)+math.cos(t*1.51)*math.sin(t*2.05))
end
function startSilentAim()
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
                    math.sin(tick()*__random())*0.32,
                    math.cos(tick()*__random())*0.16,
                    0)
                mouse.Target = plr.Character.Head
                mouse.Hit = CFrame.new(pos + offset)
            end
        end
    end)
end

local flyBV, flyConn
function startFly()
    flyBV = nil
    local flyingFunc = function()
        if not optStates["Fly"] or not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then
            if flyBV then flyBV:Destroy() flyBV=nil end return
        end
        if not flyBV then
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
            flyBV.Parent = LP.Character.HumanoidRootPart
        end
        local vel = Vector3.new()
        local spd = 62
        if UIS:IsKeyDown(Enum.KeyCode.W) then vel = vel + Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then vel = vel - Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then vel = vel - Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then vel = vel + Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.E) then vel = vel + Cam.CFrame.UpVector end
        if UIS:IsKeyDown(Enum.KeyCode.Q) then vel = vel - Cam.CFrame.UpVector end
        if vel.Magnitude > 0 then vel = vel.Unit * spd end
        flyBV.Velocity = vel
    end
    flyConn = RS.RenderStepped:Connect(flyingFunc)
    UIS.InputBegan:Connect(function(i,gpe) if not gpe and i.KeyCode==Enum.KeyCode.F and optStates["Fly"] then optStates["Fly"] = false if flyBV then flyBV:Destroy() flyBV=nil end end end)
end

function startNoclip()
    RS.Stepped:Connect(function()
        if optStates["Noclip"] and LP.Character then
            for _, v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end

function startGorunmezlik()
    RS.RenderStepped:Connect(function()
        if optStates["Görünmezlik"] and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            for _,v in ipairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("MeshPart") then v.Transparency=1 v.LocalTransparencyModifier=1 end
                if v.ClassName=="Decal" or v.ClassName=="Texture" then v.Transparency=1 end
            end
            if LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.Transparency=1
            end
            if LP.Character:FindFirstChildOfClass("Humanoid") then
                LP.Character:FindFirstChildOfClass("Humanoid").Name = "__VIS__"
            end
            if game.Workspace:FindFirstChild(LP.Name) then
                game.Workspace[LP.Name].Name = tostring(math.random(100000,999999))
            end
        elseif LP.Character then
            for _,v in ipairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("MeshPart") then
                    v.Transparency=0
                    v.LocalTransparencyModifier=0
                end
            end
            if LP.Character:FindFirstChildOfClass("Humanoid") then
                LP.Character:FindFirstChildOfClass("Humanoid").Name = "Humanoid"
            end
            if game.Workspace:FindFirstChild(tostring(math.random(100000,999999))) then
                game.Workspace[tostring(math.random(100000,999999))].Name = LP.Name
            end
        end
    end)
end

function bypassAntiCheat()
    local ranName = tostring(math.random(100000,999999))
    local mt = getrawmetatable and getrawmetatable(game)
    if mt then
        setreadonly(mt, false)
        local rawnamecall = mt.__namecall
        mt.__namecall = newcclosure(function(self,...)
            local Method = getnamecallmethod and getnamecallmethod() or ""
            if Method == "Kick" or Method == "Ban" or tostring(self):lower():find("ban") or tostring(self):lower():find("kick") or tostring(self):lower():find("anti") then
                return
            end
            return rawnamecall(self, ...)
        end)
        if setreadonly then setreadonly(mt, true) end
    end
    if hookfunction and LP and LP.Kick then
        pcall(function()
            hookfunction(LP.Kick, function() end)
        end)
    end
    local envs = {"kick","ban",".kick",".ban","anticheat"}
    for _,v in ipairs(envs) do
        for _,s in pairs(getgc and getgc(true) or {}) do
            if type(s)=="function" and debug.getinfo(s).name:lower():find(v) then
                if hookfunction then pcall(function() hookfunction(s, function() end) end) end
            end
        end
    end
    game.DescendantAdded:Connect(function(child)
        if (child:IsA("RemoteEvent") or child:IsA("RemoteFunction")) and (child.Name:lower():find("ban") or child.Name:lower():find("kick") or child.Name:lower():find("anti")) then
            pcall(function() child.Parent=nil end)
        end
    end)
end

bypassAntiCheat()
startESP()
startAimbot()
startSilentAim()
startFly()
startNoclip()
startGorunmezlik()
