local players = game:GetService("Players")
local plr = players.LocalPlayer
local uis = game:GetService("UserInputService")
local runS = game:GetService("RunService")
local camera = workspace.CurrentCamera

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = plr.PlayerGui
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,300,0,370)
mainFrame.Position = UDim2.new(0,50,0,120)
mainFrame.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Hile Menü"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Parent = mainFrame

local enabledHacks = {
    Aimbot = false,
    ESP = false,
    Noclip = false,
    Fly = false,
    Spinbot = false,
    Teleport = false
}

local yOffset = 55

function createButton(text,callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,36)
    btn.Position = UDim2.new(0,10,0,yOffset)
    btn.BackgroundColor3 = Color3.new(.2,.2,.2)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.Text = text
    btn.Parent = mainFrame
    yOffset = yOffset + 41
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function updateButton(btn,hack)
    btn.Text = hack.." ["..(enabledHacks[hack] and "Açık" or "Kapalı").."]"
end

local aimbotBtn = createButton("Aimbot [Kapalı]",function()
    enabledHacks.Aimbot = not enabledHacks.Aimbot
    updateButton(aimbotBtn,"Aimbot")
end)
local espBtn = createButton("ESP [Kapalı]",function()
    enabledHacks.ESP = not enabledHacks.ESP
    updateButton(espBtn,"ESP")
    if not enabledHacks.ESP then
        for _,v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and players:GetPlayerFromCharacter(v) and v:FindFirstChild("ESPBox") then
                v.ESPBox:Destroy()
            end
        end
    end
end)
local noclipBtn = createButton("Noclip [Kapalı]",function()
    enabledHacks.Noclip = not enabledHacks.Noclip
    updateButton(noclipBtn,"Noclip")
end)
local flyBtn = createButton("Fly [Kapalı]",function()
    enabledHacks.Fly = not enabledHacks.Fly
    updateButton(flyBtn,"Fly")
end)
local spinbotBtn = createButton("Spinbot [Kapalı]",function()
    enabledHacks.Spinbot = not enabledHacks.Spinbot
    updateButton(spinbotBtn,"Spinbot")
end)

local tpPlayers = {}
for _,p in ipairs(players:GetPlayers()) do
    if p~=plr then
        table.insert(tpPlayers,p)
    end
end

local teleportLabel = Instance.new("TextLabel")
teleportLabel.Text = "Teleport Player:"
teleportLabel.Font = Enum.Font.GothamBold
teleportLabel.TextScaled = true
teleportLabel.TextColor3 = Color3.new(1,1,1)
teleportLabel.Size = UDim2.new(1,-20,0,24)
teleportLabel.Position = UDim2.new(0,10,0,yOffset)
teleportLabel.BackgroundTransparency = 1
teleportLabel.TextXAlignment = Enum.TextXAlignment.Left
teleportLabel.Parent = mainFrame
yOffset = yOffset + 28

local tpDropDown = Instance.new("TextButton")
tpDropDown.Size = UDim2.new(1,-20,0,32)
tpDropDown.Position = UDim2.new(0,10,0,yOffset)
tpDropDown.BackgroundColor3 = Color3.new(.18,.18,.18)
tpDropDown.TextColor3 = Color3.new(1,1,1)
tpDropDown.Font = Enum.Font.Gotham
tpDropDown.TextSize = 16
tpDropDown.Text = (#tpPlayers>0 and tpPlayers[1].Name) or "Kimse Yok"
tpDropDown.Parent = mainFrame
yOffset = yOffset + 36

local tpSelectedIdx = 1

tpDropDown.MouseButton1Click:Connect(function()
    tpPlayers = {}
    for _,p in ipairs(players:GetPlayers()) do
        if p~=plr then
            table.insert(tpPlayers,p)
        end
    end
    if #tpPlayers==0 then
        tpDropDown.Text = "Kimse Yok"
        tpSelectedIdx = 1
        return
    end
    tpSelectedIdx = tpSelectedIdx%#tpPlayers+1
    tpDropDown.Text = tpPlayers[tpSelectedIdx].Name
end)

local tpBtn = createButton("Teleport",function()
    tpPlayers = {}
    for _,p in ipairs(players:GetPlayers()) do
        if p~=plr then
            table.insert(tpPlayers,p)
        end
    end
    if #tpPlayers>0 then
        local selected = tpPlayers[tpSelectedIdx] or tpPlayers[1]
        if selected.Character and selected.Character:FindFirstChild("HumanoidRootPart") and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = selected.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
        end
    end
end)
updateButton(aimbotBtn,"Aimbot")
updateButton(espBtn,"ESP")
updateButton(noclipBtn,"Noclip")
updateButton(flyBtn,"Fly")
updateButton(spinbotBtn,"Spinbot")

local flyActive = false
local flyVelocity = Vector3.new()
local flySpeed = 80
local flyConn

local function flyFunc()
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = plr.Character.HumanoidRootPart
    local bv = hrp:FindFirstChild("FLYBV") or Instance.new("BodyVelocity")
    bv.Name = "FLYBV"
    bv.MaxForce = Vector3.new(1,1,1)*1e9
    bv.Parent = hrp
    flyActive = true
    if flyConn then flyConn:Disconnect() end
    flyConn = runS.RenderStepped:Connect(function()
        if not enabledHacks.Fly then
            flyActive = false
            bv:Destroy()
            if flyConn then flyConn:Disconnect() end
            return
        end
        local move = Vector3.new()
        if uis:IsKeyDown(Enum.KeyCode.W) then move = move + camera.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then move = move - camera.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then move = move - camera.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then move = move + camera.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
        bv.Velocity = move.Unit * flySpeed
        if move.Magnitude == 0 then bv.Velocity = Vector3.new() end
    end)
end

local function unFly()
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.HumanoidRootPart:FindFirstChild("FLYBV") then
        plr.Character.HumanoidRootPart.FLYBV:Destroy()
    end
    if flyConn then flyConn:Disconnect() end
    flyActive = false
end

local noclipActive = false
runS.Stepped:Connect(function()
    if enabledHacks.Noclip and plr.Character and plr.Character:FindFirstChild("Humanoid") then
        for _,part in pairs(plr.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif plr.Character and plr.Character:FindFirstChild("Humanoid") then
        for _,part in pairs(plr.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

runS.RenderStepped:Connect(function()
    if enabledHacks.Fly then
        if not flyActive then flyFunc() end
    else
        if flyActive then unFly() end
    end
end)

local espColor = Color3.fromRGB(0,255,100)
function espOn()
    for _,play in pairs(players:GetPlayers()) do
        if play~=plr and play.Character and play.Character:FindFirstChild("HumanoidRootPart") then
            if not play.Character:FindFirstChild("ESPBox") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESPBox"
                box.Size = Vector3.new(3,6,2)
                box.Color3 = espColor
                box.Adornee = play.Character.HumanoidRootPart
                box.AlwaysOnTop = true
                box.ZIndex = 1
                box.Transparency = 0.4
                box.Parent = play.Character
            end
        end
    end
end

function removeESP()
    for _,play in pairs(players:GetPlayers()) do
        if play.Character and play.Character:FindFirstChild("ESPBox") then
            play.Character.ESPBox:Destroy()
        end
    end
end

runS.RenderStepped:Connect(function()
    if enabledHacks.ESP then
        espOn()
    else
        removeESP()
    end
end)

function getClosestPlayer()
    local closest,dist = nil,math.huge
    for _,p in pairs(players:GetPlayers()) do
        if p~=plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health>0 then
            local pRoot = p.Character.HumanoidRootPart.Position
            local screenPos,visible = camera:WorldToViewportPoint(pRoot)
            if visible then
                local mousePos = uis:GetMouseLocation()
                local d = (Vector2.new(screenPos.X,screenPos.Y)-Vector2.new(mousePos.X,mousePos.Y)).Magnitude
                if d < dist then
                    dist = d
                    closest = p
                end
            end
        end
    end
    return closest
end

local aimEnabled = false
local aimConn
uis.InputBegan:Connect(function(input,proc)
    if enabledHacks.Aimbot and input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimEnabled = true
        if aimConn then aimConn:Disconnect() end
        aimConn = runS.RenderStepped:Connect(function()
            if aimEnabled and enabledHacks.Aimbot then
                local cp = getClosestPlayer()
                if cp and cp.Character and cp.Character:FindFirstChild("Head") then
                    local head = cp.Character.Head
                    local dir = (head.Position - camera.CFrame.Position).Unit
                    local newCFrame = CFrame.new(camera.CFrame.Position, head.Position)
                    camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + dir)
                end
            end
        end)
    end
end)
uis.InputEnded:Connect(function(input,proc)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimEnabled = false
        if aimConn then aimConn:Disconnect() end
    end
end)

runS.RenderStepped:Connect(function()
    if enabledHacks.Spinbot and (enabledHacks.Fly or (plr.Character and plr.Character:FindFirstChild("HumanoidRootPart"))) then
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0,math.rad(30),0)
        end
    end
end)

players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        wait(1)
        if enabledHacks.ESP then
            espOn()
        end
        tpPlayers = {}
        for _,p2 in ipairs(players:GetPlayers()) do
            if p2~=plr then
                table.insert(tpPlayers,p2)
            end
        end
    end)
end)
players.PlayerRemoving:Connect(function()
    tpPlayers = {}
    for _,p2 in ipairs(players:GetPlayers()) do
        if p2~=plr then
            table.insert(tpPlayers,p2)
        end
    end
end)
