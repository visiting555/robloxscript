-- Gelişmiş Roblox Exploit Menü (Noclip kafa geçişli, spinbot koşarken/yürürken/flyda aktif, ESP yakın ve kutulu)
local players = game:GetService("Players")
local plr = players.LocalPlayer
local uis = game:GetService("UserInputService")
local runS = game:GetService("RunService")
local camera = workspace.CurrentCamera

local Drawing = Drawing or getgenv().Drawing

local MAX_ESP_DIST = 500 -- ESP en fazla bu uzaklıktakileri gösterir (studs)

local godloop = nil
local function setGodmode(state)
    if godloop then godloop:Disconnect() godloop = nil end
    if state then
        godloop = runS.Heartbeat:Connect(function()
            if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Health = hum.MaxHealth
                    hum.MaxHealth = math.huge
                    hum.BreakJointsOnDeath = false
                    if hum.Parent and hum:GetState().Name == "Dead" then
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
            end
        end)
    end
end

-- MENU Yİ İKİ KERE OLUŞMASINI ENGELLE!
local function makeMenu()
    if plr.PlayerGui:FindFirstChild("HileMenuGui") then
        plr.PlayerGui.HileMenuGui:Destroy()
    end

    -- ScreenGui düzgün oluşturulmalı ve Parent doğru ayarlanmalı!
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HileMenuGui"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.Parent = plr:FindFirstChildOfClass("PlayerGui") or plr.PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0,350,0,540)
    mainFrame.Position = UDim2.new(0,40,0,60)
    mainFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Visible = true
    mainFrame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Text = "Hile Menü"
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.TextStrokeTransparency = 0.7
    title.TextColor3 = Color3.new(1,1,1)
    title.Size = UDim2.new(1,0,0,44)
    title.BackgroundTransparency = 1
    title.Parent = mainFrame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,40,0,38)
    closeBtn.Position = UDim2.new(1,-45,0,3)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextColor3 = Color3.new(1,0.25,0.25)
    closeBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = mainFrame
    closeBtn.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
        screenGui:Destroy()
    end)

    local enabledHacks = {
        Aimbot = false,
        ESP = false,
        Noclip = false,
        Fly = false,
        Spinbot = false,
        Godmode = false,
    }

    local function hackText(txt, state)
        return txt .. " [" .. (state and "Açık" or "Kapalı") .. "]"
    end

    local yOffset = 54
    local buttonH = 38
    local gap = 12
    local btns = {}

    -- Her bir butonu YENİDEN ve doğu parent ile oluştur!
    local function createButton(name, btnVar)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,-38,0,buttonH)
        btn.Position = UDim2.new(0,18,0,yOffset)
        btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextStrokeTransparency = 0.7
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 19
        btn.Text = hackText(name,false)
        btn.Parent = mainFrame
        table.insert(btns, btn)
        yOffset = yOffset + buttonH + gap
        return btn
    end

    local aimbotBtn = createButton("Aimbot")
    local espBtn = createButton("ESP")
    local godmodeBtn = createButton("Godmode")
    local noclipBtn = createButton("Noclip")
    local flyBtn = createButton("Fly")
    local spinbotBtn = createButton("Spinbot")
    yOffset = yOffset + 4

    -- TP PLAYER TITLE
    local tpTitle = Instance.new("TextLabel")
    tpTitle.Text = "Oyuncuya Işınlan"
    tpTitle.Font = Enum.Font.GothamBold
    tpTitle.TextScaled = true
    tpTitle.TextStrokeTransparency = 0.7
    tpTitle.TextColor3 = Color3.fromRGB(0,180,255)
    tpTitle.Size = UDim2.new(1,0,0,26)
    tpTitle.Position = UDim2.new(0,0,0,yOffset)
    tpTitle.BackgroundTransparency = 1
    tpTitle.Parent = mainFrame
    yOffset = yOffset + 24

    local dropFrame = Instance.new("Frame")
    dropFrame.Size = UDim2.new(1,-38,0,36)
    dropFrame.Position = UDim2.new(0,18,0,yOffset)
    dropFrame.BackgroundColor3 = Color3.fromRGB(25,25,40)
    dropFrame.BorderSizePixel = 0
    dropFrame.Parent = mainFrame

    local tpDropdown = Instance.new("TextButton")
    tpDropdown.Text = "Oyuncu Seç"
    tpDropdown.Size = UDim2.new(1,0,1,0)
    tpDropdown.BackgroundTransparency = 1
    tpDropdown.TextColor3 = Color3.new(1,1,1)
    tpDropdown.Font = Enum.Font.Gotham
    tpDropdown.TextSize = 17
    tpDropdown.Parent = dropFrame

    local playerListFrame = Instance.new("ScrollingFrame")
    playerListFrame.Size = UDim2.new(1,0,0,80)
    playerListFrame.Position = UDim2.new(0,0,1,0)
    playerListFrame.BackgroundTransparency = 0.1
    playerListFrame.BackgroundColor3 = Color3.fromRGB(40,40,55)
    playerListFrame.BorderSizePixel = 0
    playerListFrame.Visible = false
    playerListFrame.Parent = dropFrame
    playerListFrame.CanvasSize = UDim2.new(0,0,0,0)
    playerListFrame.ScrollBarThickness = 4

    local selectedPlayer = nil
    local function refreshPlayerList()
        playerListFrame:ClearAllChildren()
        local i = 0
        for _,v in ipairs(players:GetPlayers()) do
            if v ~= plr then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -4, 0, 24)
                btn.Position = UDim2.new(0,2,0,i*25)
                btn.BackgroundColor3 = Color3.fromRGB(55,55,69)
                btn.Text = v.Name
                btn.Font = Enum.Font.Gotham
                btn.TextColor3 = Color3.fromRGB(0,255,255)
                btn.TextSize = 15
                btn.Name = v.Name
                btn.Parent = playerListFrame
                btn.MouseButton1Click:Connect(function()
                    selectedPlayer = v
                    tpDropdown.Text = v.Name
                    playerListFrame.Visible = false
                end)
                i = i+1
            end
        end
        playerListFrame.CanvasSize = UDim2.new(0,0,0,i*25)
    end
    tpDropdown.MouseButton1Click:Connect(function()
        playerListFrame.Visible = not playerListFrame.Visible
        if playerListFrame.Visible then refreshPlayerList() end
    end)

    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(1,-38,0,buttonH)
    tpBtn.Position = UDim2.new(0,18,0,yOffset+42)
    tpBtn.BackgroundColor3 = Color3.fromRGB(24,55,69)
    tpBtn.TextColor3 = Color3.new(1,1,1)
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.TextSize = 18
    tpBtn.Text = "Seçili Oyuncuya Işınlan"
    tpBtn.Parent = mainFrame

    ---- FONKSİYONELLİK ----
    -- AIMBOT
    local aimbotConn
    local aimbotFunc = function()
        if enabledHacks.Aimbot then
            if aimbotConn then aimbotConn:Disconnect() end
            aimbotConn = runS.RenderStepped:Connect(function()
                if uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                    local closest, dist = nil, math.huge
                    for _,v in ipairs(players:GetPlayers()) do
                        if v ~= plr and v.Character and v.Character:FindFirstChild("Head") and v.Team ~= plr.Team then
                            local pos, onscreen = camera:WorldToViewportPoint(v.Character.Head.Position)
                            if onscreen then
                                local mousePos = uis:GetMouseLocation()
                                local d = (Vector2.new(pos.X,pos.Y)-mousePos).Magnitude
                                if d < dist and d < 180 then
                                    closest, dist = v, d
                                end
                            end
                        end
                    end
                    if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                        camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Character.Head.Position)
                    end
                end
            end)
        else
            if aimbotConn then aimbotConn:Disconnect() aimbotConn = nil end
        end
    end
    aimbotBtn.MouseButton1Click:Connect(function()
        enabledHacks.Aimbot = not enabledHacks.Aimbot
        aimbotBtn.Text = hackText("Aimbot", enabledHacks.Aimbot)
        aimbotFunc()
    end)

    -- ESP: iskelet+box+headcircle -- UZAKTA GÖRÜNMEZ
    local espObjs = {}
    local espConn
    local function clearESP()
        for _,t in pairs(espObjs) do
            for _,o in pairs(t) do if o.Remove then o:Remove() end end
        end
        espObjs = {}
    end
    local skeleton = {
        {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"}, {"UpperTorso","LeftUpperArm"}, {"UpperTorso","RightUpperArm"},
        {"LeftUpperArm","LeftLowerArm"}, {"LeftLowerArm","LeftHand"},
        {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"}, {"LowerTorso","RightUpperLeg"},
        {"LeftUpperLeg","LeftLowerLeg"}, {"LeftLowerLeg","LeftFoot"},
        {"RightUpperLeg","RightLowerLeg"}, {"RightLowerLeg","RightFoot"}
    }
    local function getBodyCorners(model)
        -- Returns {tl, tr, bl, br} on 2d
        if not (model and model:FindFirstChild("HumanoidRootPart")) then return nil end
        local c = model.HumanoidRootPart.Position
        local size = Vector3.new(6, 11, 3)
        local cf = model.HumanoidRootPart.CFrame
        local points = {
            cf * Vector3.new(-size.X/2, size.Y/2, -size.Z/2),
            cf * Vector3.new(size.X/2, size.Y/2, -size.Z/2),
            cf * Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
            cf * Vector3.new(size.X/2, -size.Y/2, -size.Z/2),
        }
        local res, visibility = {}, true
        for i,pt in ipairs(points) do
            local p, vis = camera:WorldToViewportPoint(pt)
            res[i] = Vector2.new(p.X, p.Y)
            if not vis then visibility = false end
        end
        if not visibility then return nil end
        return res
    end
    local function espLoop()
        clearESP()
        if espConn then espConn:Disconnect() espConn = nil end
        if not enabledHacks.ESP then return end
        espConn = runS.RenderStepped:Connect(function()
            for _,v in ipairs(players:GetPlayers()) do
                if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") then
                    local char = v.Character
                    local hrp = char.HumanoidRootPart
                    local distance = (hrp.Position - camera.CFrame.Position).Magnitude
                    if distance > MAX_ESP_DIST then
                        if espObjs[v] then for _,o in pairs(espObjs[v]) do if o.Visible then o.Visible = false end end end
                        goto continue
                    end

                    if not espObjs[v] then
                        espObjs[v] = {}
                        -- box 4 line, 1 skeleton set, 1 head circle
                        for i=1,4 do
                            local line = Drawing.new("Line")
                            line.Color = Color3.new(1,0,0)
                            line.Thickness = 2.5
                            line.Transparency = 1
                            line.Visible = false
                            espObjs[v]["box"..i] = line
                        end
                        for i=1,#skeleton do
                            local line = Drawing.new("Line")
                            line.Color = Color3.new(1,0,0)
                            line.Thickness = 2
                            line.Transparency = 1
                            line.Visible = false
                            espObjs[v]["line"..i] = line
                        end
                        local circle = Drawing.new("Circle")
                        circle.Color = Color3.new(1,0,0)
                        circle.Thickness = 3
                        circle.Transparency = 1
                        circle.Visible = false
                        circle.Filled = false
                        espObjs[v].headcircle = circle
                    end

                    -- box
                    local boxpoints = getBodyCorners(char)
                    if boxpoints then
                        espObjs[v].box1.Visible = true
                        espObjs[v].box1.From = boxpoints[1]
                        espObjs[v].box1.To = boxpoints[2]
                        espObjs[v].box2.Visible = true
                        espObjs[v].box2.From = boxpoints[2]
                        espObjs[v].box2.To = boxpoints[4]
                        espObjs[v].box3.Visible = true
                        espObjs[v].box3.From = boxpoints[4]
                        espObjs[v].box3.To = boxpoints[3]
                        espObjs[v].box4.Visible = true
                        espObjs[v].box4.From = boxpoints[3]
                        espObjs[v].box4.To = boxpoints[1]
                    else
                        for i=1,4 do espObjs[v]["box"..i].Visible = false end
                    end

                    -- skeleton
                    for i,pair in ipairs(skeleton) do
                        local A = char:FindFirstChild(pair[1])
                        local B = char:FindFirstChild(pair[2])
                        local line = espObjs[v]["line"..i]
                        if A and B then
                            local a,ona = camera:WorldToViewportPoint(A.Position)
                            local b,onb = camera:WorldToViewportPoint(B.Position)
                            if ona and onb then
                                line.Visible = true
                                line.From = Vector2.new(a.X,a.Y)
                                line.To   = Vector2.new(b.X,b.Y)
                            else
                                line.Visible = false
                            end
                        else
                            line.Visible = false
                        end
                    end

                    -- Head
                    local head = char:FindFirstChild("Head")
                    local circ = espObjs[v].headcircle
                    if head then
                        local pos,onh = camera:WorldToViewportPoint(head.Position)
                        if onh then
                            circ.Position = Vector2.new(pos.X, pos.Y)
                            circ.Visible = true
                            circ.Radius = 16 * (MAX_ESP_DIST/(distance+1)) -- mesafeye göre ufalır
                        else
                            circ.Visible = false
                        end
                    else
                        circ.Visible = false
                    end
                    ::continue::
                elseif espObjs[v] then
                    for _,o in pairs(espObjs[v]) do if o.Visible then o.Visible = false end end
                end
            end
        end)
    end
    espBtn.MouseButton1Click:Connect(function()
        enabledHacks.ESP = not enabledHacks.ESP
        espBtn.Text = hackText("ESP", enabledHacks.ESP)
        if enabledHacks.ESP then espLoop() else
            if espConn then espConn:Disconnect() espConn = nil end
            clearESP()
        end
    end)

    -- Godmode Button
    godmodeBtn.MouseButton1Click:Connect(function()
        enabledHacks.Godmode = not enabledHacks.Godmode
        godmodeBtn.Text = hackText("Godmode",enabledHacks.Godmode)
        setGodmode(enabledHacks.Godmode)
    end)

    -- NOCLIP: Full Geçiş (Kafa ve Tüm BasePart)
    local noclipConn
    local function setNoclip()
        if noclipConn then noclipConn:Disconnect() end
        if enabledHacks.Noclip then
            noclipConn = runS.Stepped:Connect(function()
                if plr.Character then
                    for _,part in pairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            part.Massless = true
                        end
                    end
                    local hum = plr.Character:FindFirstChildWhichIsA("Humanoid")
                    if hum and hum:GetState() ~= Enum.HumanoidStateType.Physics then
                        hum:ChangeState(Enum.HumanoidStateType.Physics)
                    end
                end
            end)
        else
            if plr.Character then
                for _,part in pairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                        part.Massless = false
                    end
                end
                local hum = plr.Character:FindFirstChildWhichIsA("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end
    end
    noclipBtn.MouseButton1Click:Connect(function()
        enabledHacks.Noclip = not enabledHacks.Noclip
        noclipBtn.Text = hackText("Noclip", enabledHacks.Noclip)
        setNoclip()
    end)

    -- FLY Fonksiyon
    local flyConn
    local flySpeed = 50
    local function setFly()
        if flyConn then flyConn:Disconnect() end
        if enabledHacks.Fly then
            local bodyVelocity, bodyGyro
            flyConn = runS.RenderStepped:Connect(function()
                if not (plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")) then return end
                local hrp = plr.Character.HumanoidRootPart
                if not bodyVelocity or not bodyVelocity.Parent then
                    bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.MaxForce = Vector3.new(1e9,1e9,1e9)
                    bodyVelocity.Name = "HileFlyVel"
                    bodyVelocity.Parent = hrp
                    bodyGyro = Instance.new("BodyGyro")
                    bodyGyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
                    bodyGyro.P = 1e5
                    bodyGyro.Name = "HileFlyRot"
                    bodyGyro.Parent = hrp
                end
                local moveDir = Vector3.zero
                if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + camera.CFrame.UpVector end
                if uis:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - camera.CFrame.UpVector end
                if moveDir.Magnitude > 0 then
                    bodyVelocity.Velocity = moveDir.Unit * flySpeed
                else
                    bodyVelocity.Velocity = Vector3.zero
                end
                bodyGyro.CFrame = camera.CFrame
            end)
            plr.CharacterRemoving:Connect(function()
                if bodyVelocity then bodyVelocity:Destroy() end
                if bodyGyro then bodyGyro:Destroy() end
            end)
        else
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                if hrp:FindFirstChild("HileFlyVel") then hrp.HileFlyVel:Destroy() end
                if hrp:FindFirstChild("HileFlyRot") then hrp.HileFlyRot:Destroy() end
            end
        end
    end
    flyBtn.MouseButton1Click:Connect(function()
        enabledHacks.Fly = not enabledHacks.Fly
        flyBtn.Text = hackText("Fly", enabledHacks.Fly)
        setFly()
    end)

    -- SPINBOT: Her zaman çalıştır (yürüme/koşu/fly dahil)
    local spinConn
    local function setSpinbot()
        if spinConn then spinConn:Disconnect() end
        if enabledHacks.Spinbot then
            spinConn = runS.Stepped:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = plr.Character.HumanoidRootPart
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(20), 0)
                end
            end)
        end
    end
    spinbotBtn.MouseButton1Click:Connect(function()
        enabledHacks.Spinbot = not enabledHacks.Spinbot
        spinbotBtn.Text = hackText("Spinbot", enabledHacks.Spinbot)
        setSpinbot()
    end)

    -- TP PLAYER
    tpBtn.MouseButton1Click:Connect(function()
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") 
            and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(2,0,0)
        end
    end)

    -- Menü Hover Stili
    for _,btn in ipairs(btns) do
        btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(60,62,65) end)
        btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(35,35,35) end)
    end
    tpBtn.MouseEnter:Connect(function() tpBtn.BackgroundColor3 = Color3.fromRGB(38,99,119) end)
    tpBtn.MouseLeave:Connect(function() tpBtn.BackgroundColor3 = Color3.fromRGB(24,55,69) end)

    -- Başlarken hepsi off, fonksiyonlar setup
    setSpinbot()
    setNoclip()
    setFly()
    espLoop()
    setGodmode(enabledHacks.Godmode)
end

-- Menü açmak için F4 tuşu:
uis.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F4 then
        makeMenu()
    end
end)

-- İlk başta da menüyü aç
makeMenu()
