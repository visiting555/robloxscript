-- Roblox Hile Menü (Fly, Aimbot, Noclip, Spinbot, TP Player)
-- Delta executor ile inject edilebilir şekilde yazılmıştır.

local players = game:GetService("Players")
local plr = players.LocalPlayer
local uis = game:GetService("UserInputService")
local runS = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- Hile Menü Fonksiyonu
local function makeMenu()
    if plr.PlayerGui:FindFirstChild("HileMenuGui") then
        plr.PlayerGui.HileMenuGui:Destroy()
    end
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HileMenuGui"
    screenGui.Parent = plr.PlayerGui
    screenGui.ResetOnSpawn = false
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0,340,0,460)
    mainFrame.Position = UDim2.new(0,40,0,100)
    mainFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Visible = true
    mainFrame.Parent = screenGui

    -- Başlık
    local title = Instance.new("TextLabel")
    title.Text = "Hile Menü"
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.TextStrokeTransparency = 0.7
    title.TextColor3 = Color3.new(1,1,1)
    title.Size = UDim2.new(1,0,0,44)
    title.BackgroundTransparency = 1
    title.Parent = mainFrame

    -- Kapat Butonu
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

    -- Hacklerin Durumlarını Tut
    local enabledHacks = {
        Aimbot = false,
        ESP = false,
        Noclip = false,
        Fly = false,
        Spinbot = false,
    }

    local function hackText(txt, state)
        return txt .. " [" .. (state and "Açık" or "Kapalı") .. "]"
    end

    local yOffset = 54
    local buttonH = 38
    local gap = 13
    local btns = {}
    ----------------------------------------------------------------
    -- AIMBOT
    local aimbotBtn = Instance.new("TextButton")
    aimbotBtn.Size = UDim2.new(1,-38,0,buttonH)
    aimbotBtn.Position = UDim2.new(0,18,0,yOffset)
    aimbotBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    aimbotBtn.TextColor3 = Color3.new(1,1,1)
    aimbotBtn.TextStrokeTransparency = 0.7
    aimbotBtn.Font = Enum.Font.Gotham
    aimbotBtn.TextSize = 19
    aimbotBtn.Text = hackText("Aimbot",false)
    aimbotBtn.Parent = mainFrame
    table.insert(btns, aimbotBtn)
    yOffset = yOffset + buttonH + gap

    -- ESP KALDIRILABİLİR
    -- NOCLIP
    local noclipBtn = Instance.new("TextButton")
    noclipBtn.Size = UDim2.new(1,-38,0,buttonH)
    noclipBtn.Position = UDim2.new(0,18,0,yOffset)
    noclipBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    noclipBtn.TextColor3 = Color3.new(1,1,1)
    noclipBtn.TextStrokeTransparency = 0.7
    noclipBtn.Font = Enum.Font.Gotham
    noclipBtn.TextSize = 19
    noclipBtn.Text = hackText("Noclip",false)
    noclipBtn.Parent = mainFrame
    table.insert(btns, noclipBtn)
    yOffset = yOffset + buttonH + gap

    -- FLY
    local flyBtn = Instance.new("TextButton")
    flyBtn.Size = UDim2.new(1,-38,0,buttonH)
    flyBtn.Position = UDim2.new(0,18,0,yOffset)
    flyBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    flyBtn.TextColor3 = Color3.new(1,1,1)
    flyBtn.TextStrokeTransparency = 0.7
    flyBtn.Font = Enum.Font.Gotham
    flyBtn.TextSize = 19
    flyBtn.Text = hackText("Fly",false)
    flyBtn.Parent = mainFrame
    table.insert(btns, flyBtn)
    yOffset = yOffset + buttonH + gap

    -- SPINBOT (Sadece Fly Açıkken Çalışacak)
    local spinbotBtn = Instance.new("TextButton")
    spinbotBtn.Size = UDim2.new(1,-38,0,buttonH)
    spinbotBtn.Position = UDim2.new(0,18,0,yOffset)
    spinbotBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    spinbotBtn.TextColor3 = Color3.new(1,1,1)
    spinbotBtn.TextStrokeTransparency = 0.7
    spinbotBtn.Font = Enum.Font.Gotham
    spinbotBtn.TextSize = 19
    spinbotBtn.Text = hackText("Spinbot (Fly'da)",false)
    spinbotBtn.Parent = mainFrame
    table.insert(btns, spinbotBtn)
    yOffset = yOffset + buttonH + gap + 4

    -- TP PLAYER BAŞLIK
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

    -- Oyuncu Seçme DDM
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

    -- Dropdown Menu
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

    -- TP PLAYER Button
    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(1,-38,0,buttonH)
    tpBtn.Position = UDim2.new(0,18,0,yOffset+42)
    tpBtn.BackgroundColor3 = Color3.fromRGB(24,55,69)
    tpBtn.TextColor3 = Color3.new(1,1,1)
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.TextSize = 18
    tpBtn.Text = "Seçili Oyuncuya Işınlan"
    tpBtn.Parent = mainFrame

    -- FONKSİYONELLİK ----------------------------------------------------------
    -- AIMBOT (Sağ Mouse Başı Takip)
    local aimbotConn
    local aimbotFunc = function()
        if enabledHacks.Aimbot then
            if aimbotConn then aimbotConn:Disconnect() end
            aimbotConn = runS.RenderStepped:Connect(function()
                if uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                    local closest, dist = nil, math.huge
                    for _,v in ipairs(players:GetPlayers()) do
                        if v ~= plr and v.Character and v.Character:FindFirstChild("Head") then
                            local pos, onscreen = camera:WorldToViewportPoint(v.Character.Head.Position)
                            if onscreen then
                                local mousePos = uis:GetMouseLocation()
                                local d = (Vector2.new(pos.X,pos.Y)-mousePos).Magnitude
                                if d < dist and d < 150 then
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
            if aimbotConn then aimbotConn:Disconnect() end
        end
    end

    aimbotBtn.MouseButton1Click:Connect(function()
        enabledHacks.Aimbot = not enabledHacks.Aimbot
        aimbotBtn.Text = hackText("Aimbot", enabledHacks.Aimbot)
        aimbotFunc()
    end)

    -- NOCLIP (Bütün Parçalardan Geçme)
    local noclipConn
    local function setNoclip()
        if enabledHacks.Noclip then
            if noclipConn then noclipConn:Disconnect() end
            noclipConn = runS.Stepped:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                    for _,v in pairs(plr.Character:GetDescendants()) do
                        if v:IsA("BasePart") and v.CanCollide == true then
                            v.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() end
        end
    end
    noclipBtn.MouseButton1Click:Connect(function()
        enabledHacks.Noclip = not enabledHacks.Noclip
        noclipBtn.Text = hackText("Noclip", enabledHacks.Noclip)
        setNoclip()
    end)

    -- FLY
    local flyConn
    local flySpeed = 50
    local flying = false
    local function setFly()
        if enabledHacks.Fly then
            flying = true
            if flyConn then flyConn:Disconnect() end
            local bodyVelocity, bodyGyro
            flyConn = runS.RenderStepped:Connect(function()
                if not (plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")) then return end
                local hrp = plr.Character.HumanoidRootPart
                if not bodyVelocity then
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
                bodyVelocity.Velocity = moveDir.Unit * flySpeed
                if moveDir.Magnitude == 0 then bodyVelocity.Velocity = Vector3.zero end
                bodyGyro.CFrame = camera.CFrame
            end)
            -- Temizlik
            plr.CharacterRemoving:Connect(function()
                if bodyVelocity then bodyVelocity:Destroy() end
                if bodyGyro then bodyGyro:Destroy() end
            end)
        else
            flying = false
            if flyConn then flyConn:Disconnect() end
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

    -- SPINBOT (Sadece Fly Açıkken Çalışır)
    local spinConn
    local function setSpinbot()
        if enabledHacks.Spinbot and enabledHacks.Fly then
            if spinConn then spinConn:Disconnect() end
            spinConn = runS.RenderStepped:Connect(function()
                if flying and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(14), 0)
                end
            end)
        else
            if spinConn then spinConn:Disconnect() end
        end
    end
    spinbotBtn.MouseButton1Click:Connect(function()
        enabledHacks.Spinbot = not enabledHacks.Spinbot
        spinbotBtn.Text = hackText("Spinbot (Fly'da)", enabledHacks.Spinbot)
        setSpinbot()
    end)

    -- Fly durumu değişirse spinbot'u tekrar ayarla
    flyBtn.MouseButton1Click:Connect(setSpinbot)

    -- TP PLAYER FONKSİYON
    tpBtn.MouseButton1Click:Connect(function()
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") 
            and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(2,0,0)
        end
    end)

    -- Menü Güzel Kalsın Diye
    for _,btn in ipairs(btns) do
        btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(60,62,65) end)
        btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(35,35,35) end)
    end
    tpBtn.MouseEnter:Connect(function() tpBtn.BackgroundColor3 = Color3.fromRGB(38,99,119) end)
    tpBtn.MouseLeave:Connect(function() tpBtn.BackgroundColor3 = Color3.fromRGB(24,55,69) end)
end

makeMenu()
