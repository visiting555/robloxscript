local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Teams = game:GetService("Teams")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local GUI = Instance.new("ScreenGui")
local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
local open = true
local hileTurleri = {
    ["Aim Hileleri"] = {"Aimbot","SilentAim"},
    ["Görüş Hileleri"] = {"ESP","FOV Changer"},
    ["Troll Hileleri"] = {"Exploda","Spinbot"},
    ["Bireysel Hileler"] = {"Fly","Teleport","Yanına Teleport","Noclip","Spectate Player","No Reload","Godmode","Rejoin","Reset Character"}
}
local tumHileler = {
    ["Aimbot"]=false,["SilentAim"]=false,["ESP"]=false,["FOV Changer"]=false,["Exploda"]=false,["Spinbot"]=false,
    ["Fly"]=false,["Teleport"]=false,["Yanına Teleport"]=false,["Noclip"]=false,["Spectate Player"]=false,["No Reload"]=false,["Godmode"]=false,
    ["Rejoin"]=false,["Reset Character"]=false
}
local fov = 90
local mainFrame = Instance.new("Frame")
GUI.Name = "HileMenu"
GUI.Parent = game.CoreGui
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mainFrame.Size = UDim2.new(0,430,0,430)
mainFrame.Position = UDim2.new(0.08,0,0.19,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10,10,10)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = GUI
mainFrame.Active = true
mainFrame.Draggable = true

local kapatBtn = Instance.new("TextButton")
kapatBtn.Size = UDim2.new(0,40,0,25)
kapatBtn.Position = UDim2.new(1,-45,0,5)
kapatBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
kapatBtn.Text = "-"
kapatBtn.TextColor3 = Color3.fromRGB(255,255,255)
kapatBtn.Parent = mainFrame
kapatBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    wait(2)
    mainFrame.Visible = true
end)

local navFrame = Instance.new("Frame")
navFrame.Size = UDim2.new(0,130,1,0)
navFrame.Position = UDim2.new(0,0,0,0)
navFrame.BackgroundColor3 = Color3.fromRGB(10,10,10)
navFrame.Parent = mainFrame
navFrame.BorderSizePixel = 0

local pageFrames = {}
local navBtns = {}
local seciliKategori

function acHileSecenekleri(kategori)
    for kat,frame in pairs(pageFrames) do
        frame.Visible = (kat == kategori)
    end
    seciliKategori = kategori
end

local i = 0
for kategori,liste in pairs(hileTurleri) do
    i = i + 1
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,45)
    btn.Position = UDim2.new(0,0,0,(i-1)*46)
    btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
    btn.Text = kategori
    btn.TextColor3 = Color3.fromRGB(255,50,50)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 22
    btn.Parent = navFrame
    navBtns[kategori] = btn

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1.2,200,1,0)
    page.Position = UDim2.new(0.38,0,0,0)
    page.BackgroundTransparency = 1
    page.Parent = mainFrame
    page.Visible = false
    pageFrames[kategori] = page

    local t = 0
    for _,hileadi in ipairs(liste) do
        t = t + 1
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(0,275,0,35)
        optBtn.Position = UDim2.new(0,25,0, (t-1)*39+18)
        optBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
        optBtn.Text = hileadi
        optBtn.TextColor3 = Color3.fromRGB(255,50,50)
        optBtn.Font = Enum.Font.SourceSansBold
        optBtn.TextSize = 20
        optBtn.Parent = page

        local toggleBox = Instance.new("TextButton")
        toggleBox.Size = UDim2.new(0,32,0,32)
        toggleBox.Position = UDim2.new(0,312,0,optBtn.Position.Y.Offset)
        toggleBox.Text = tumHileler[hileadi] and "Açık" or "Kapalı"
        toggleBox.TextColor3 = tumHileler[hileadi] and Color3.new(0,1,0) or Color3.new(1,0,0)
        toggleBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
        toggleBox.Font = Enum.Font.SourceSansBold
        toggleBox.TextSize = 15
        toggleBox.Parent = page

        optBtn.MouseButton1Click:Connect(function()
            toggleBox:CaptureFocus()
            tumHileler[hileadi] = not tumHileler[hileadi]
            if tumHileler[hileadi] then
                toggleBox.Text = "Açık" toggleBox.TextColor3 = Color3.new(0,1,0)
            else
                toggleBox.Text = "Kapalı" toggleBox.TextColor3 = Color3.new(1,0,0)
            end
        end)
        toggleBox.MouseButton1Click:Connect(optBtn.MouseButton1Click)
    end
    btn.MouseButton1Click:Connect(function()
        acHileSecenekleri(kategori)
    end)
end
acHileSecenekleri("Aim Hileleri")

-- Aimbot/SilentAim
local function dusmanmi(plr)
    if plr==LocalPlayer or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return false end
    if Teams and LocalPlayer.Team and plr.Team == LocalPlayer.Team then return false end
    return true
end
local function nearestEnemy()
    local closest,dist = nil,999999
    for _,plr in ipairs(Players:GetPlayers()) do
        if dusmanmi(plr) then
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos,onscreen = Camera:WorldToViewportPoint(hrp.Position)
                local mousepos = UserInputService:GetMouseLocation()
                local mDist = (Vector2.new(pos.X,pos.Y)-mousepos).Magnitude
                if onscreen and mDist < dist and mDist < fov then
                    closest,dist = plr,mDist
                end
            end
        end
    end
    return closest
end

local aimconn, silentconn
RunService.RenderStepped:Connect(function()
    if tumHileler["Aimbot"] then
        local target = nearestEnemy()
        if target and target.Character:FindFirstChild("Head") then
            local mouse = LocalPlayer:GetMouse()
            mouse.TargetFilter = LocalPlayer.Character
            local head = target.Character.Head
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
        end
    end
end)
local __old; __old = hookmetamethod(game,"__namecall",newcclosure(function(...)
    local self,method = ...,getnamecallmethod()
    if tumHileler["SilentAim"] and tostring(method) == "FireServer" and tostring(self)=="Hit" then
        local target = nearestEnemy()
        if target and target.Character:FindFirstChild("Head") then
            local args = {...}
            args[2] = target.Character.Head.Position
            return __old(unpack(args))
        end
    end
    return __old(...)
end))

-- ESP
local espObjs = {}
RunService.RenderStepped:Connect(function()
    if tumHileler["ESP"] then
        for _,v in pairs(espObjs) do if v.Adornee and not v.Adornee.Parent then v:Destroy() end end
        for _,plr in ipairs(Players:GetPlayers()) do
            if dusmanmi(plr) and plr.Character and plr.Character:FindFirstChild("Head") then
                if not espObjs[plr] or not espObjs[plr].Parent then
                    local box = Instance.new("BoxHandleAdornment",Camera)
                    box.Adornee = plr.Character.Head
                    box.Color3 = Color3.fromRGB(255,0,0)
                    box.Size = Vector3.new(3,3,3)
                    box.AlwaysOnTop = true
                    box.Transparency = 0.4
                    espObjs[plr] = box
                end
            end
        end
    else
        for _,v in pairs(espObjs) do v:Destroy() end
        espObjs = {}
    end
end)

-- FOV Changer
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if tumHileler["FOV Changer"] and input.UserInputType==Enum.UserInputType.MouseWheel then
        fov = math.clamp(fov + input.Position.Z*4,40,120)
        Camera.FieldOfView = fov
    end
end)
Camera.FieldOfView = fov

-- Spinbot
RunService.RenderStepped:Connect(function()
    if tumHileler["Spinbot"] then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(40),0)
        end
    end
end)

-- Fly/Noclip
local hareket = {flyspd=37,fly=false,noclip=false}
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if tumHileler["Fly"] then
            hareket.fly = true
            local hum=char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand=true end
            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir+Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir-Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir-Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir+Camera.CFrame.RightVector end
            char:FindFirstChild("HumanoidRootPart").Velocity = moveDir.Unit*hareket.flyspd
        else
            local hum=char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand=false end
            hareket.fly = false
        end
        if tumHileler["Noclip"] then
            for _,v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide=false end
            end
        end
    end
end)

-- Teleport/Exploda/Yanına Teleport/Spectate Player
local selectedPlayer = nil
local playerDropdown = Instance.new("Frame")
playerDropdown.Size = UDim2.new(0,220,0,220)
playerDropdown.Position = UDim2.new(0.48,0,0.1,0)
playerDropdown.BackgroundColor3 = Color3.fromRGB(18,18,18)
playerDropdown.Visible = false
playerDropdown.Parent = mainFrame
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1,0,1,0)
playerList.CanvasSize = UDim2.new(0,0,0,0)
playerList.BackgroundTransparency = 1
playerList.ScrollBarThickness = 4
playerList.Parent = playerDropdown
local function updatePlayers(cb)
    for _,v in pairs(playerList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    playerList.CanvasSize = UDim2.new(0,0,0,#Players:GetPlayers()*30)
    local y = 0
    for _,pl in ipairs(Players:GetPlayers()) do
        if dusmanmi(pl) then
            local b = Instance.new("TextButton",playerList)
            b.Size = UDim2.new(1,0,0,29)
            b.Position = UDim2.new(0,0,0,y*30)
            b.Text = pl.Name
            b.TextColor3 = Color3.fromRGB(255,50,50)
            b.BackgroundTransparency = 1
            b.MouseButton1Click:Connect(function()
                playerDropdown.Visible=false
                cb(pl)
            end)
            y=y+1
        end
    end
end

for kategori,frame in pairs(pageFrames) do
    for _,opt in ipairs(hileTurleri[kategori]) do
        if opt=="Teleport" then
            for _,c in pairs(frame:GetChildren()) do
                if c:IsA("TextButton") and c.Text=="Teleport" then
                    c.MouseButton1Click:Connect(function()
                        updatePlayers(function(pl)
                            if LocalPlayer.Character and pl.Character then
                                LocalPlayer.Character:SetPrimaryPartCFrame(pl.Character:GetPrimaryPartCFrame())
                            end
                        end)
                        playerDropdown.Visible = true
                    end)
                end
            end
        elseif opt=="Yanına Teleport" then
            for _,c in pairs(frame:GetChildren()) do
                if c:IsA("TextButton") and c.Text=="Yanına Teleport" then
                    c.MouseButton1Click:Connect(function()
                        updatePlayers(function(pl)
                            if pl.Character and LocalPlayer.Character then
                                pl.Character:SetPrimaryPartCFrame(LocalPlayer.Character:GetPrimaryPartCFrame())
                            end
                        end)
                        playerDropdown.Visible = true
                    end)
                end
            end
        elseif opt=="Exploda" then
            for _,c in pairs(frame:GetChildren()) do
                if c:IsA("TextButton") and c.Text=="Exploda" then
                    c.MouseButton1Click:Connect(function()
                        updatePlayers(function(pl)
                            if pl.Character then
                                local ex = Instance.new("Explosion",workspace)
                                ex.Position = pl.Character:FindFirstChild("HumanoidRootPart").Position
                                ex.BlastRadius = 10
                                ex.BlastPressure = 999999
                            end
                        end)
                        playerDropdown.Visible = true
                    end)
                end
            end
        elseif opt=="Spectate Player" then
            for _,c in pairs(frame:GetChildren()) do
                if c:IsA("TextButton") and c.Text=="Spectate Player" then
                    c.MouseButton1Click:Connect(function()
                        updatePlayers(function(pl)
                            if pl.Character and pl.Character:FindFirstChild("Humanoid") then
                                Camera.CameraSubject = pl.Character:FindFirstChild("Humanoid")
                            end
                        end)
                        playerDropdown.Visible = true
                    end)
                end
            end
        end
    end
end

-- No Reload
local oldFire; oldFire = hookfunction(Instance.new("Tool").Activate,function(self,...)
    if tumHileler["No Reload"] then
        local ammo = self:FindFirstChild("Ammo")
        if ammo then ammo.Value = math.huge end
    end
    return oldFire(self,...)
end)

-- Godmode
RunService.Stepped:Connect(function()
    if tumHileler["Godmode"] then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").Health = math.huge
        end
    end
end)

-- Rejoin/Reset
for kategori,frame in pairs(pageFrames) do
    for _,opt in ipairs(hileTurleri[kategori]) do
        if opt=="Rejoin" then
            for _,c in pairs(frame:GetChildren()) do
                if c:IsA("TextButton") and c.Text=="Rejoin" then
                    c.MouseButton1Click:Connect(function()
                        game:GetService("TeleportService"):Teleport(game.PlaceId)
                    end)
                end
            end
        elseif opt=="Reset Character" then
            for _,c in pairs(frame:GetChildren()) do
                if c:IsA("TextButton") and c.Text:match("Reset Character") then
                    c.MouseButton1Click:Connect(function()
                        LocalPlayer.Character:BreakJoints()
                    end)
                end
            end
        end
    end
end

-- Menüde hareket ettirme
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = mainFrame.Position
    end
end)
mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputBegan:Connect(function(input)
    -- Menü toggle: INSERT tuşu ile
    if input.KeyCode == Enum.KeyCode.Insert then
        mainFrame.Visible = not mainFrame.Visible
    end
    -- Menü hızlı kapatıp açmak için: CTRL + M
    if input.KeyCode == Enum.KeyCode.M and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        mainFrame.Visible = false
        wait(2)
        mainFrame.Visible = true
    end
end)
