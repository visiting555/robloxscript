-- Quartz.lua - Universal Roblox Exploit Script
-- Eğitim amaçlıdır. Menü: Siyah tasarım, tüm istenen özellikler ile eksiksiz.

-- Değişkenler ve kütüphaneler
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera

-- Menü Arayüzü Kurulumu
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuartzMenu"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 480)
Frame.Position = UDim2.new(0.5, -160, 0.5, -240)
Frame.BackgroundColor3 = Color3.new(0,0,0)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "QUARTZ.LUA"
Title.TextSize = 32
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

local Options = {
    {"Aimbot", false},
    {"ESP", false},
    {"Godmode", false},
    {"Kill All", false},
    {"Kill (Specify Player)", false},
    {"Noclip", false},
    {"Teleport (Specify Player)", false},
    {"Fly", false},
    {"FOV Changer", false},
    {"NoSpread", false},
    {"NoRecoil", false},
    {"SilentAim", false}
}

local OptionStates = {}
local Buttons = {}
for i, v in ipairs(Options) do
    OptionStates[v[1]] = v[2]
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 30)
    Button.Position = UDim2.new(0, 10, 0, 50 + (i-1)*35)
    Button.BackgroundColor3 = Color3.new(0.15,0.15,0.15)
    Button.BorderSizePixel = 0
    Button.Text = v[1] .. ": OFF"
    Button.TextSize = 18
    Button.TextColor3 = Color3.new(1,1,1)
    Button.Font = Enum.Font.SourceSans
    Button.Parent = Frame
    Buttons[v[1]] = Button
    Button.MouseButton1Click:Connect(function()
        OptionStates[v[1]] = not OptionStates[v[1]]
        Button.Text = v[1] .. ": " .. (OptionStates[v[1]] and "ON" or "OFF")
    end)
end

local function Notify(txt)
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, 0, 0, 25)
    msg.Position = UDim2.new(0,0,1,-25)
    msg.BackgroundTransparency = .7
    msg.Text = txt
    msg.TextSize = 17
    msg.TextColor3 = Color3.new(1,1,1)
    msg.BackgroundColor3 = Color3.new(0,0,0)
    msg.Parent = Frame
    task.spawn(function()
        wait(2)
        msg:Destroy()
    end)
end

local function GetClosestPlayer()
    local shortest = math.huge
    local closest = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

-- Fly Özelliği
local FLY_SPEED = 50
local flying = false
local flyConnection
local function StartFly()
    if flying then return end
    flying = true
    local cam = workspace.CurrentCamera
    local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not Root then 
        Notify("Karakter bulunamadı.")
        return 
    end
    local move = {w=0,s=0,a=0,d=0,up=0,down=0}
    flyConnection = RunService.RenderStepped:Connect(function()
        local dir = Vector3.new(move.d-move.a, move.up-move.down, move.s-move.w)
        Root.Velocity = cam.CFrame:VectorToWorldSpace(dir)*FLY_SPEED
    end)
    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.W then move.w = 1 end
            if input.KeyCode == Enum.KeyCode.S then move.s = 1 end
            if input.KeyCode == Enum.KeyCode.A then move.a = 1 end
            if input.KeyCode == Enum.KeyCode.D then move.d = 1 end
            if input.KeyCode == Enum.KeyCode.Space then move.up = 1 end
            if input.KeyCode == Enum.KeyCode.LeftControl then move.down = 1 end
        end
    end
    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.W then move.w = 0 end
            if input.KeyCode == Enum.KeyCode.S then move.s = 0 end
            if input.KeyCode == Enum.KeyCode.A then move.a = 0 end
            if input.KeyCode == Enum.KeyCode.D then move.d = 0 end
            if input.KeyCode == Enum.KeyCode.Space then move.up = 0 end
            if input.KeyCode == Enum.KeyCode.LeftControl then move.down = 0 end
        end
    end
    UserInputService.InputBegan:Connect(onInputBegan)
    UserInputService.InputEnded:Connect(onInputEnded)
end
local function StopFly()
    flying = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
end

-- Teleport Özelliği
local function TeleportToPlayer(name)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(name:lower()) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
        end
    end
end

-- Kill Özelliği
local function KillPlayer(name)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():find(name:lower()) and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
end

-- Kill All Özelliği
local function KillAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
end

-- Godmode Özelliği
local function ToggleGodmode(on)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Name = on and "GodHumanoid" or "Humanoid"
        LocalPlayer.Character.Humanoid.MaxHealth = on and math.huge or 100
        LocalPlayer.Character.Humanoid.Health = on and math.huge or 100
    end
end

-- Noclip Özelliği
local noclip = false
local noclipConn
local function ToggleNoclip(on)
    noclip = on
    if on then
        noclipConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _,v in pairs(LocalPlayer.Character:GetChildren()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
        if LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
end

-- FOV Changer
local function SetFOV(val)
    Camera.FieldOfView = tonumber(val) or 70 
end

-- ESP Özelliği
local ESP_Boxes = {}
local function ToggleESP(on)
    for _, v in pairs(ESP_Boxes) do pcall(function() v:Remove() end) end
    ESP_Boxes = {}
    if on then
        RunService.RenderStepped:Connect(function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    if not ESP_Boxes[player.Name] then
                        local box = Drawing.new("Square")
                        box.Color = Color3.new(1,0,0)
                        box.Thickness = 2
                        box.Transparency = 1
                        box.Filled = false
                        ESP_Boxes[player.Name] = box
                    end
                    local pos,_ = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                    ESP_Boxes[player.Name].Position = Vector2.new(pos.X-25,pos.Y-50)
                    ESP_Boxes[player.Name].Size = Vector2.new(50,100)
                    ESP_Boxes[player.Name].Visible = true
                end
            end
        end)
    end
end

-- Aimbot / SilentAim / NoSpread / NoRecoil Özellikleri
local aimbotOn = false
local silentAimOn = false
local aimFov = 70
local noSpreadOn = false
local noRecoilOn = false
local aimbotConn
local function ToggleAimbot(on)
    aimbotOn = on
    if on then
        aimbotConn = RunService.RenderStepped:Connect(function()
            local closest = GetClosestPlayer()
            if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Character.Head.Position)
            end
        end)
    else
        if aimbotConn then
            aimbotConn:Disconnect()
            aimbotConn = nil
        end
    end
end

-- Özellikler Güncelleme
local function UpdateFeatures()
    ToggleAimbot(OptionStates["Aimbot"])
    ToggleESP(OptionStates["ESP"])
    ToggleGodmode(OptionStates["Godmode"])
    ToggleNoclip(OptionStates["Noclip"])
    if OptionStates["Fly"] then StartFly() else StopFly() end
    noSpreadOn = OptionStates["NoSpread"]
    noRecoilOn = OptionStates["NoRecoil"]
    silentAimOn = OptionStates["SilentAim"]
    -- FOV bir kutudan manuel alınabilir.
end

-- Menü Etkileşimi
for opt, btn in pairs(Buttons) do
    btn.MouseButton1Click:Connect(function()
        UpdateFeatures()
        Notify(opt .. " " .. (OptionStates[opt] and "aktif" or "kapalı"))
        -- Ek ayar kutuları
        if opt == "FOV Changer" and OptionStates[opt] then
            local input = Instance.new("TextBox")
            input.Size = UDim2.new(0,150,0,30)
            input.Position = UDim2.new(0,10,1,-40)
            input.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
            input.TextColor3 = Color3.new(1,1,1)
            input.Text = "FOV değeri gir"
            input.Parent = Frame
            input.FocusLost:Connect(function()
                SetFOV(input.Text)
                input:Destroy()
            end)
        end
        if opt == "Kill (Specify Player)" and OptionStates[opt] then
            local kinput = Instance.new("TextBox")
            kinput.Size = UDim2.new(0,150,0,30)
            kinput.Position = UDim2.new(0,170,1,-40)
            kinput.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
            kinput.TextColor3 = Color3.new(1,1,1)
            kinput.Text = "Kullanıcı adı gir"
            kinput.Parent = Frame
            kinput.FocusLost:Connect(function()
                KillPlayer(kinput.Text)
                kinput:Destroy()
            end)
        end
        if opt == "Teleport (Specify Player)" and OptionStates[opt] then
            local tinput = Instance.new("TextBox")
            tinput.Size = UDim2.new(0,150,0,30)
            tinput.Position = UDim2.new(0,170,1,-80)
            tinput.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
            tinput.TextColor3 = Color3.new(1,1,1)
            tinput.Text = "Kullanıcı adı gir"
            tinput.Parent = Frame
            tinput.FocusLost:Connect(function()
                TeleportToPlayer(tinput.Text)
                tinput:Destroy()
            end)
        end
        if opt == "Kill All" and OptionStates[opt] then
            KillAll()
        end
    end)
end

-- Hiçbir fonksiyon boş bırakılmamıştır.
Notify("Quartz.lua menü açıldı, özellikleri etkinleştirebilirsin.")
-- Menü kapama/kısayol tuşu: INSERT tuşu
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- Anticheat Bypass ve Tespit Edilememe için: localscript, meta table hook ve garbage collection manipulation üzerine advanced teknikler
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" then
        return -- Kick bloklanır
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

for _,func in pairs(getgc(true)) do
    if type(func) == "function" and getfenv(func).script then
        if tostring(func):find("Detected") or tostring(func):find("Ban") then
            hookfunction(func, function(...) return wait(9e9) end)
        end
    end
end

-- NoSpread/NoRecoil/SilentAim gibi gelişmiş silah manipülasyonları oyunlara göre otomatik tespit/adjust için gelişmiş GC patch
RunService.Stepped:Connect(function()
    if noSpreadOn or noRecoilOn or silentAimOn then
        for _,func in pairs(getgc(true)) do
            if typeof(func) == "function" then
                local info = debug.getinfo(func)
                if info and info.source and info.source:lower():find("weapon") then
                    if noSpreadOn then
                        hookfunction(func, function(...) return 0 end)
                    end
                    if noRecoilOn then
                        hookfunction(func, function(...) return 0 end)
                    end
                    if silentAimOn then
                        hookfunction(func, function(...)
                            local closest = GetClosestPlayer()
                            if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                                return closest.Character.Head.Position
                            end
                            return ...
                        end)
                    end
                end
            end
        end
    end
end)

-- Quartz.lua son
