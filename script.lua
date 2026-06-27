local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

local Gui = Instance.new("ScreenGui")
Gui.Name = "ProHileV2Menusu"
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 550, 0, 740)
Main.Position = UDim2.new(0.3, 0, 0.13, 0)
Main.BackgroundColor3 = Color3.fromRGB(18,18,22)
Main.BorderSizePixel = 0
Main.Parent = Gui
Main.Active = true
Main.Draggable = true

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,60)
TopBar.BackgroundColor3 = Color3.fromRGB(30,30,35)
TopBar.Parent = Main
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,1,0)
Title.BackgroundTransparency = 1
Title.Text = "PRO HİLE MENÜ | GELİŞMİŞ"
Title.Font = Enum.Font.FredokaOne
Title.TextSize = 32
Title.TextColor3 = Color3.fromRGB(69,197,255)
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,46,0,46)
CloseBtn.Position = UDim2.new(1,-58,0,7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255,47,47)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBlack
CloseBtn.TextSize = 28
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Parent = TopBar
CloseBtn.AutoButtonColor = true
CloseBtn.MouseButton1Click:Connect(function() Gui:Destroy() end)

local Side = Instance.new("Frame")
Side.Size = UDim2.new(0,170,1,-60)
Side.Position = UDim2.new(0,0,0,60)
Side.BackgroundColor3 = Color3.fromRGB(23,23,27)
Side.BorderSizePixel = 0
Side.Parent = Main

local FeatureFrame = Instance.new("Frame")
FeatureFrame.Size = UDim2.new(1,-170,1,-60)
FeatureFrame.Position = UDim2.new(0,170,0,60)
FeatureFrame.BackgroundColor3 = Color3.fromRGB(28,28,34)
FeatureFrame.BorderSizePixel = 0
FeatureFrame.Parent = Main

local Features = {
    "Kill All", "Invincible", "Invisible", "Aimbot", "Spinbot", "Fly", "ESP", "Player Teleport", "Speed", "JumpPower",
    "No Clip", "Remove Doors", "Inf Coins", "Rejoin", "Serverhop", "No Fall Damage", "Rainbow Character", "Anti Ragdoll",
    "Highlight Enemies", "Highlight Friends", "Delete Water", "Freeze All", "God Gun", "Walk On Walls", "Infinite Yield", 
    "Auto Farm", "Auto Respawn"
}

local Executed = {
    ["Kill All"]=false,["Invisible"]=false,["Invincible"]=false,["Aimbot"]=false,["Spinbot"]=false,["Fly"]=false,["ESP"]=false,
    ["Player Teleport"]=false,["Speed"]=false,["JumpPower"]=false,["No Clip"]=false,["Remove Doors"]=false,["Inf Coins"]=false,
    ["Rejoin"]=false,["Serverhop"]=false,["No Fall Damage"]=false,["Rainbow Character"]=false,["Anti Ragdoll"]=false,
    ["Highlight Enemies"]=false,["Highlight Friends"]=false,["Delete Water"]=false,["Freeze All"]=false,["God Gun"]=false,
    ["Walk On Walls"]=false,["Infinite Yield"]=false,["Auto Farm"]=false,["Auto Respawn"]=false
}

local scroll = Instance.new("ScrollingFrame")
scroll.Parent = Side
scroll.Size = UDim2.new(1,0,1,0)
scroll.CanvasSize = UDim2.new(0,0,0,math.max(#Features*52,300))
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6

local Buttons = {}
for i,ft in ipairs(Features) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-18,0,46)
    btn.Position = UDim2.new(0,9,0,8 + 52*(i-1))
    btn.BackgroundColor3 = Color3.fromRGB(38,38,49)
    btn.Text = ft
    btn.TextColor3 = Color3.fromRGB(208,255,255)
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamBold
    btn.Parent = scroll
    btn.Name = ft.."Button"
    btn.AutoButtonColor = true
    Buttons[ft] = btn
end

local function GetChar(plr)
    local c = plr.Character
    if c and c:FindFirstChildOfClass("Humanoid") and c:FindFirstChild("HumanoidRootPart") then
        return c
    end
end

local function Announcement(str)
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1,0,0,34)
    msg.Position = UDim2.new(0,0,0,FeatureFrame.AbsoluteSize.Y/2-17)
    msg.BackgroundTransparency = 0.33
    msg.BackgroundColor3 = Color3.fromRGB(28,28,42)
    msg.TextColor3 = Color3.fromRGB(66,255,72)
    msg.Font = Enum.Font.GothamBlack
    msg.TextSize = 19
    msg.Text = str
    msg.Parent = FeatureFrame
    TweenService:Create(msg,TweenInfo.new(0.6,Enum.EasingStyle.Sine),{BackgroundTransparency=1,TextTransparency=1,TextStrokeTransparency=1}):Play()
    task.spawn(function() wait(2.1) msg:Destroy() end)
end

--- KILL ALL ---
Buttons["Kill All"].MouseButton1Click:Connect(function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and GetChar(plr) then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                pcall(function() hum.Health = 0 end)
            end
        end
    end
    Announcement("Herkes öldürüldü!")
end)

--- INVINCIBLE ---
local orgHumName
Buttons["Invincible"].MouseButton1Click:Connect(function()
    Executed["Invincible"] = not Executed["Invincible"]
    local char = GetChar(LocalPlayer)
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if Executed["Invincible"] then
            if hum and hum.Name=="Humanoid" then
                orgHumName = hum.Name
                hum.Name = "NotHumanoid"
            end
            Announcement("Ölümsüzlük Aktif!")
        else
            if char:FindFirstChild("NotHumanoid") then
                char.NotHumanoid.Name = orgHumName or "Humanoid"
            end
            Announcement("Ölümsüzlük Kapalı")
        end
    end
end)

--- INVISIBLE ---
Buttons["Invisible"].MouseButton1Click:Connect(function()
    Executed["Invisible"] = not Executed["Invisible"]
    local char = GetChar(LocalPlayer)
    if char then
        for _,v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then
                v.Transparency = Executed["Invisible"] and 1 or 0
            end
        end
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("Decal") then v.Transparency = Executed["Invisible"] and 1 or 0 end
        end
        Announcement(Executed["Invisible"] and "Görünmez oldun!" or "Görünmezlik Kapalı")
    end
end)

--- AIMBOT & ESP ENHANCED ---
local AimbotActive = false
local ESPActive = false
local esp_boxes = {}
local function clear_esp()
    for _,v in pairs(esp_boxes) do
        v:Destroy()
    end
    esp_boxes = {}
end

local function create_esp()
    clear_esp()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and GetChar(plr) then
            local box = Instance.new("BoxHandleAdornment")
            box.Adornee = GetChar(plr)
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Size = Vector3.new(2, 3, 1)
            box.Color3 = Color3.fromRGB(255, 80, 44)
            box.Transparency = 0.4
            box.Parent = workspace
            esp_boxes[plr] = box
        end
    end
end

Players.PlayerRemoving:Connect(function(plr) if esp_boxes[plr] then esp_boxes[plr]:Destroy() esp_boxes[plr]=nil end end)

Buttons["ESP"].MouseButton1Click:Connect(function()
    ESPActive = not ESPActive
    if ESPActive then
        create_esp()
        Announcement("ESP Açık")
    else
        clear_esp()
        Announcement("ESP Kapalı")
    end
end)

RunService.Heartbeat:Connect(function()
    if ESPActive then
        for plr,box in pairs(esp_boxes) do
            if GetChar(plr) then
                box.Adornee = GetChar(plr)
            else
                box.Adornee = nil
            end
        end
    end
end)

local function getClosest(targetType)
    local shortest = math.huge
    local target = nil
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and GetChar(plr) then
            local hrp = GetChar(plr):FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos,vis = Camera:WorldToViewportPoint(hrp.Position)
                local mousepos = UserInputService:GetMouseLocation()
                local dist = (Vector2.new(pos.X,pos.Y) - Vector2.new(mousepos.X,mousepos.Y)).Magnitude
                if vis and dist < shortest and dist < 400 then
                    shortest = dist
                    target = hrp
                end
            end
        end
    end
    return target
end

local AimbotConn
Buttons["Aimbot"].MouseButton1Click:Connect(function()
    AimbotActive = not AimbotActive
    if not AimbotActive then
        if AimbotConn then AimbotConn:Disconnect() AimbotConn=nil end
        Announcement("Aimbot Kapalı")
        return
    end
    Announcement("Aimbot Açık")
    AimbotConn = RunService.RenderStepped:Connect(function()
        if AimbotActive then
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local t = getClosest("enemy")
                if t then
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Position), 0.30)
                end
            end
        end
    end)
end)

--- SPINBOT ---
local SpinBotConn
Buttons["Spinbot"].MouseButton1Click:Connect(function()
    Executed["Spinbot"] = not Executed["Spinbot"]
    local char = GetChar(LocalPlayer)
    if Executed["Spinbot"] and char then
        Announcement("Spinbot Açık")
        SpinBotConn = RunService.RenderStepped:Connect(function()
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(30), 0)
            end
        end)
    else
        if SpinBotConn then SpinBotConn:Disconnect() SpinBotConn=nil end
        Announcement("Spinbot Kapalı")
    end
end)

--- FLY (HIZLI & GELİŞMİŞ) ---
local FlyActive = false
local FlyGyro, FlyVel, FlyConn
Buttons["Fly"].MouseButton1Click:Connect(function()
    FlyActive = not FlyActive
    local char = GetChar(LocalPlayer)
    if FlyActive and char then
        Announcement("Fly Açık")
        local hrp = char.HumanoidRootPart
        FlyGyro = Instance.new("BodyGyro")
        FlyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
        FlyGyro.P = 9e4
        FlyGyro.CFrame = hrp.CFrame
        FlyGyro.Parent = hrp
        FlyVel = Instance.new("BodyVelocity")
        FlyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
        FlyVel.Parent = hrp
        FlyConn = RunService.Heartbeat:Connect(function()
            local move = Vector3.zero
            local cf = Camera.CFrame
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
            FlyVel.Velocity = move.Unit * (move.magnitude > 0 and 70 or 0)
            FlyGyro.CFrame = Camera.CFrame
        end)
    else
        if FlyGyro then FlyGyro:Destroy() FlyGyro=nil end
        if FlyVel then FlyVel:Destroy() FlyVel=nil end
        if FlyConn then FlyConn:Disconnect() FlyConn=nil end
        Announcement("Fly Kapalı")
    end
end)

--- PLAYER TELEPORT ---
Buttons["Player Teleport"].MouseButton1Click:Connect(function()
    local plrs = {}
    for _,pl in pairs(Players:GetPlayers()) do if pl~=LocalPlayer then table.insert(plrs,pl.Name) end end
    if #plrs > 0 then
        local sel = plrs[math.random(1,#plrs)]
        local char = GetChar(LocalPlayer)
        local tchar = GetChar(Players:FindFirstChild(sel))
        if char and tchar then
            char:MoveTo(tchar.HumanoidRootPart.Position + Vector3.new(4,0,0))
            Announcement("Işınlandın: "..sel)
        end
    end
end)

--- SPEED ---
Buttons["Speed"].MouseButton1Click:Connect(function()
    Executed["Speed"] = not Executed["Speed"]
    local char = GetChar(LocalPlayer)
    if char then
        char.Humanoid.WalkSpeed = Executed["Speed"] and 75 or 16
        Announcement(Executed["Speed"] and "Speed X5 Açık" or "Speed Normal")
    end
end)

--- JUMPPOWER ---
Buttons["JumpPower"].MouseButton1Click:Connect(function()
    Executed["JumpPower"] = not Executed["JumpPower"]
    local char = GetChar(LocalPlayer)
    if char then
        char.Humanoid.JumpPower = Executed["JumpPower"] and 180 or 50
        Announcement(Executed["JumpPower"] and "JumpPower X3 Açık" or "JumpPower Normal")
    end
end)

--- NO CLIP ---
local NoclipConn = nil
Buttons["No Clip"].MouseButton1Click:Connect(function()
    Executed["No Clip"] = not Executed["No Clip"]
    local char = GetChar(LocalPlayer)
    if Executed["No Clip"] and char then
        Announcement("Noclip Aktif")
        NoclipConn = RunService.Stepped:Connect(function()
            for _,v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
    else
        if NoclipConn then NoclipConn:Disconnect() NoclipConn=nil end
        Announcement("Noclip Kapalı")
    end
end)

--- REMOVE DOORS ---
Buttons["Remove Doors"].MouseButton1Click:Connect(function()
    for _,o in pairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") and o.Name:lower():find("door") then
            o:Destroy()
        end
    end
    Announcement("Kapılar silindi!")
end)

--- INF COINS ---
Buttons["Inf Coins"].MouseButton1Click:Connect(function()
    local st = LocalPlayer:FindFirstChild("leaderstats")
    if st and st:FindFirstChild("Coins") then
        st.Coins.Value = 1e9
        Announcement("Sonsuz coin.")
    end
end)

--- REJOIN ---
Buttons["Rejoin"].MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

--- SERVERHOP ---
Buttons["Serverhop"].MouseButton1Click:Connect(function()
    local ts = game:GetService("TeleportService")
    ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

--- NO FALL DAMAGE ---
Buttons["No Fall Damage"].MouseButton1Click:Connect(function()
    local char = GetChar(LocalPlayer)
    if char then
        for _,obj in pairs(char:GetChildren()) do
            if obj.Name:lower():find("fall") then obj:Destroy() end
        end
        Announcement("Düşme hasarı engellendi")
    end
end)

--- RAINBOW CHARACTER ---
local Rainbow = false
local RainbowConn = nil
Buttons["Rainbow Character"].MouseButton1Click:Connect(function()
    Rainbow = not Rainbow
    if Rainbow then
        Announcement("Gökkuşağı karakter aktif")
        RainbowConn = RunService.Heartbeat:Connect(function()
            local char = GetChar(LocalPlayer)
            if char then
                local h = tick()%5/5
                local col = Color3.fromHSV(h,1,1)
                for _,v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then
                        v.Color = col
                    end
                end
            end
        end)
    else
        if RainbowConn then RainbowConn:Disconnect() RainbowConn=nil end
        Announcement("Gökkuşağı karakter kapalı")
    end
end)

--- ANTI RAGDOLL ---
Buttons["Anti Ragdoll"].MouseButton1Click:Connect(function()
    local char = GetChar(LocalPlayer)
    if char then
        for _,v in pairs(char:GetChildren()) do
            if v:IsA("JointInstance") and v.Name:lower():find("ragdoll") then v:Destroy() end
        end
        Announcement("Ragdoll engellendi")
    end
end)

--- HIGHLIGHT ENEMIES ---
local EnemiesHL=false
local enemiesHLs={}
Buttons["Highlight Enemies"].MouseButton1Click:Connect(function()
    EnemiesHL = not EnemiesHL
    if EnemiesHL then
        Announcement("Düşmanlar vurgulandı")
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and GetChar(plr) then
                local hi = Instance.new("Highlight")
                hi.Parent = GetChar(plr)
                hi.Adornee = GetChar(plr)
                hi.FillColor = Color3.fromRGB(255,40,89)
                hi.OutlineColor = Color3.fromRGB(255,255,255)
                enemiesHLs[plr] = hi
            end
        end
    else
        for _,hi in pairs(enemiesHLs) do hi:Destroy() end
        enemiesHLs = {}
        Announcement("Düşman vurgusu kapalı")
    end
end)

--- HIGHLIGHT FRIENDS ---
local FriendsHL=false
local friendsHLs={}
Buttons["Highlight Friends"].MouseButton1Click:Connect(function()
    FriendsHL = not FriendsHL
    local friends = {} -- Roblox Friends check is not native, demo for all other players as 'friends'
    if FriendsHL then
        Announcement("Arkadaşlar vurgulandı")
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and GetChar(plr) then
                local hi = Instance.new("Highlight")
                hi.Parent = GetChar(plr)
                hi.Adornee = GetChar(plr)
                hi.FillColor = Color3.fromRGB(54,212,255)
                hi.OutlineColor = Color3.fromRGB(255,255,0)
                friendsHLs[plr] = hi
            end
        end
    else
        for _,hi in pairs(friendsHLs) do hi:Destroy() end
        friendsHLs = {}
        Announcement("Arkadaş vurgusu kapalı")
    end
end)

--- DELETE WATER ---
Buttons["Delete Water"].MouseButton1Click:Connect(function()
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Terrain") then obj:Clear() end
    end
    Announcement("Tüm su silindi")
end)

--- FREEZE ALL ---
Buttons["Freeze All"].MouseButton1Click:Connect(function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and GetChar(plr) then
            local hrp = GetChar(plr):FindFirstChild("HumanoidRootPart")
            if hrp then hrp.Anchored = true end
        end
    end
    wait(2)
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and GetChar(plr) then
            local hrp = GetChar(plr):FindFirstChild("HumanoidRootPart")
            if hrp then hrp.Anchored = false end
        end
    end
    Announcement("Tüm oyuncular donduruldu")
end)

--- GOD GUN (Silah varsa hasarı aşırı arttır) ---
Buttons["God Gun"].MouseButton1Click:Connect(function()
    local char = GetChar(LocalPlayer)
    if char then
        for _,v in pairs(char:GetChildren()) do
            if v:IsA("Tool") then
                for _,vv in pairs(v:GetDescendants()) do
                    if vv:IsA("ModuleScript") and vv:FindFirstChild("Damage") then
                        vv.Damage.Value = 999999
                    end
                end
            end
        end
        Announcement("God Gun Aktif")
    end
end)

--- WALK ON WALLS ---
local wallWalk = false
Buttons["Walk On Walls"].MouseButton1Click:Connect(function()
    wallWalk = not wallWalk
    local char = GetChar(LocalPlayer)
    if wallWalk and char then
        Announcement("Duvarlarda Yürüme Aktif")
        char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
    else
        if char then char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false) end
        Announcement("Duvarlarda yürüme kapalı")
    end
end)

--- INFINITE YIELD (Loader) ---
Buttons["Infinite Yield"].MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    Announcement("InfiniteYield")
end)

--- AUTO FARM MOCKUP ---
local AF_Conn
Buttons["Auto Farm"].MouseButton1Click:Connect(function()
    Executed["Auto Farm"] = not Executed["Auto Farm"]
    if Executed["Auto Farm"] then
        Announcement("Oto farm açıldı")
        AF_Conn = RunService.Heartbeat:Connect(function()
            local char = GetChar(LocalPlayer)
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0,0.05,0)
            end
        end)
    else
        if AF_Conn then AF_Conn:Disconnect() AF_Conn=nil end
        Announcement("Oto farm kapalı")
    end
end)

--- AUTO RESPAWN ---
local AutoRespawn = false
local respConn
Buttons["Auto Respawn"].MouseButton1Click:Connect(function()
    AutoRespawn = not AutoRespawn
    local function setup()
        if respConn then respConn:Disconnect() end
        if AutoRespawn then
            respConn = LocalPlayer.CharacterAdded:Connect(function(char)
                Announcement("Oto respawn oldu!")
            end)
        end
    end
    setup()
    Announcement(AutoRespawn and "Oto respawn açık" or "Oto respawn kapalı")
end)

UserInputService.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode==Enum.KeyCode.RightAlt then Main.Visible = not Main.Visible end
end)
