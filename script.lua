-- Quartz.lua: Ultra Level Modern Roblox Exploit (Tüm Oyunlarda, Algılanamaz, Bypass, Geniş Menü, Her Fonksiyon Eksiksiz)
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local TPService = game:GetService("TeleportService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local HttpService = game:GetService("HttpService")
local gui = Instance.new("ScreenGui")
gui.Name = "QuartzMenu"
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = LP:FindFirstChildOfClass("PlayerGui") end
local frm = Instance.new("Frame")
frm.Size = UDim2.new(0,360,0,605)
frm.Position = UDim2.new(0.5,-180,0.5,-302)
frm.BackgroundColor3 = Color3.fromRGB(0,0,0)
frm.BorderSizePixel = 0
frm.Active = true
frm.Draggable = true
frm.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "QUARTZ.LUA"
title.TextSize = 36
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.Parent = frm

local opts = {
    {"Aimbot","Toggle"},
    {"ESP","Toggle"},
    {"Godmode","Toggle"},
    {"Spinbot","Toggle"},
    {"Noclip","Toggle"},
    {"Fly","Toggle"},
    {"SilentAim","Toggle"},
    {"NoSpread","Toggle"},
    {"NoRecoil","Toggle"},
    {"FOV Changer","Input"},
    {"Kill All","Button"},
    {"Kill (Specify Player)","PickPlayer"},
    {"Teleport (Specify Player)","PickPlayer"},
    {"Rejoin","Button"},
    {"Invisible","Button"}
}
local alwaysActive = {"Aimbot","ESP","Godmode","Spinbot","Noclip","Fly","NoSpread","NoRecoil","SilentAim"}

local optStates, btns = {}, {}
local taskHandles = {}
local DrawLib = (Drawing and Drawing.new and Drawing) or nil

local function Notify(msg)
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1,0,0,26)
    t.Position = UDim2.new(0,0,1,-28)
    t.BackgroundTransparency = .7
    t.Text = tostring(msg)
    t.TextSize = 18
    t.Font = Enum.Font.SourceSans
    t.TextColor3 = Color3.new(1,1,1)
    t.BackgroundColor3 = Color3.new(0,0,0)
    t.Parent = frm
    spawn(function() wait(2.3) t:Destroy() end)
end

local function PlayerDropdown(callback)
    if taskHandles["_dropdown"] then pcall(function() taskHandles["_dropdown"]:Destroy() end) taskHandles["_dropdown"]=nil end
    local ddFrame = Instance.new("Frame")
    ddFrame.Size = UDim2.new(0,228,0,215)
    ddFrame.Position = UDim2.new(0,68,0,380)
    ddFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    ddFrame.BorderSizePixel = 0
    ddFrame.Parent = frm

    local scrl = Instance.new("ScrollingFrame", ddFrame)
    scrl.Size = UDim2.new(1,0,1,0)
    scrl.CanvasSize = UDim2.new(0,0,0,0)
    scrl.BackgroundTransparency = 1
    scrl.ScrollBarImageColor3 = Color3.fromRGB(50,50,50)
    scrl.BorderSizePixel = 0
    scrl.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrl.ScrollBarThickness = 6

    local sortedPlayers = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LP then table.insert(sortedPlayers, p) end
    end
    table.sort(sortedPlayers,function(a,b) return a.Name:lower() < b.Name:lower() end)

    for i,plr in ipairs(sortedPlayers) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1,-10,0,28)
        b.Position = UDim2.new(0,5,0,5+(i-1)*32)
        b.BackgroundColor3 = Color3.fromRGB(33,33,33)
        b.BorderSizePixel = 0
        b.Font = Enum.Font.SourceSans
        b.Text = plr.Name
        b.TextColor3 = Color3.fromRGB(248,219,109)
        b.TextSize = 18
        b.Parent = scrl
        b.MouseButton1Click:Connect(function()
            if callback then callback(plr) end
            ddFrame:Destroy()
            taskHandles["_dropdown"]=nil
        end)
    end
    scrl.CanvasSize = UDim2.new(0,0,0,#sortedPlayers*32+10)
    taskHandles["_dropdown"] = ddFrame
end

local function GetClosestPlayer()
    local cl, dist = nil, math.huge
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local ps,onScr = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScr then
                local d = (Vector2.new(ps.X,ps.Y) - Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude
                if d < dist then dist = d;cl = p end
            end
        end
    end
    return cl
end

local function clearHandles(flag)
    for n, v in pairs(taskHandles) do
        if v and typeof(v)=="RBXScriptConnection" then pcall(function() v:Disconnect() end)
        elseif type(v)=="function" then pcall(v)
        elseif typeof(v) == "Instance" then pcall(function() v:Destroy() end)
        end
        taskHandles[n] = nil
    end
    if flag==true then
        for k in pairs(optStates) do optStates[k] = false end
        for k, b in pairs(btns) do if b then b.Text = k .. ": OFF" end end
    end
end

-- ESP SYSTEM, now each player's ESP is independently tracked and only updated by ESP logic
local espBoxes = {}
local function StartESP()
    if not DrawLib then Notify("[ESP] Drawing Library yok!"); return end
    if taskHandles._espCon then pcall(function() taskHandles._espCon:Disconnect() end) end
    for _,b in next,espBoxes do pcall(function() if typeof(b.Remove)=="function" then b:Remove() end end) end
    espBoxes = {}
    taskHandles._espCon = RS.RenderStepped:Connect(function()
        for _,p in ipairs(Players:GetPlayers()) do
            local show = (optStates["ESP"]==true)
            if show and p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health>0 then
                if not espBoxes[p] then
                    local b = DrawLib("Square")
                    b.Color = Color3.new(0,1,1)
                    b.Thickness = 2
                    b.Transparency = 1
                    b.Filled = false
                    b.Visible = true
                    espBoxes[p] = b
                end
                local pos,vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                espBoxes[p].Position = Vector2.new(pos.X-30,pos.Y-56)
                espBoxes[p].Size = Vector2.new(60,110)
                espBoxes[p].Visible = vis and true
            elseif espBoxes[p] then
                espBoxes[p].Visible = false
            end
        end
        for k,b in pairs(espBoxes) do
            if not Players:FindFirstChild(k.Name) or not k.Character then
                pcall(function() if typeof(b.Remove)=="function" then b:Remove() end end)
                espBoxes[k]=nil
            end
        end
    end)
end

local function StopESP()
    if taskHandles._espCon then pcall(function() taskHandles._espCon:Disconnect() end) taskHandles._espCon=nil end
    for _,b in pairs(espBoxes) do pcall(function() if typeof(b.Remove)=="function" then b:Remove() end end) end
    espBoxes = {}
end

local aimbotLocked = false
local function StartAimbot()
    if taskHandles._aimCon then pcall(function() taskHandles._aimCon:Disconnect() end) end
    taskHandles._aimCon = RS.RenderStepped:Connect(function()
        if optStates["Aimbot"] then
            local trg = GetClosestPlayer()
            if trg and trg.Character and trg.Character:FindFirstChild("Head") and trg.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, trg.Character.Head.Position)
            end
        end
    end)
end

local function StopAimbot()
    if taskHandles._aimCon then pcall(function() taskHandles._aimCon:Disconnect() end) taskHandles._aimCon=nil end
end

local spinAngle = 0
local function StartSpinbot()
    if taskHandles._spinbotCon then pcall(function() taskHandles._spinbotCon:Disconnect() end) end
    spinAngle = 0
    taskHandles._spinbotCon = RS.RenderStepped:Connect(function()
        if optStates["Spinbot"] and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            spinAngle = spinAngle + 15
            if spinAngle > 360 then spinAngle = 0 end
            local root = LP.Character.HumanoidRootPart
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(15), 0)
        end
    end)
end
local function StopSpinbot()
    if taskHandles._spinbotCon then pcall(function() taskHandles._spinbotCon:Disconnect() end) taskHandles._spinbotCon=nil end
end

local function GodMode(on)
    local c = LP.Character
    if c then
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then
            if on then
                hum.Name = "GodHumanoid"
                hum.MaxHealth = math.huge
                hum.Health = math.huge
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum.BreakJointsOnDeath = false
                hum.PlatformStand = false
            else
                hum.Name = "Humanoid"
                hum.MaxHealth = 100
                hum.Health = hum.MaxHealth
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum.BreakJointsOnDeath = true
            end
        end
    end
end

local function KillAllPlayers()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then hum.Health = 0 end
        end
    end
end

local function KillPlayer(p)
    if p and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then hum.Health = 0 end
    end
end

local function TeleportTo(p)
    if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
    end
end

local function SetFOV(fval)
    Camera.FieldOfView = tonumber(fval) or 70
end

local function StartNoclip()
    if taskHandles["Noclip"] then pcall(function() taskHandles["Noclip"]:Disconnect() end) end
    taskHandles["Noclip"] = RS.Stepped:Connect(function()
        if optStates["Noclip"] and LP.Character then
            for _,v in pairs(LP.Character:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end

local function StopNoclip()
    if taskHandles["Noclip"] then pcall(function() taskHandles["Noclip"]:Disconnect() end) taskHandles["Noclip"]=nil end
    if LP.Character then
        for _,v in pairs(LP.Character:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
end

local flyConn, flyKeyConns, flyingMove = nil, {}, {w=0,s=0,a=0,d=0,up=0,down=0}
local function StartFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    for _,con in pairs(flyKeyConns) do if con then con:Disconnect() end end
    flyKeyConns = {}
    local cam = Camera
    local function onKeyBegan(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.W then flyingMove.w = 1 end
            if input.KeyCode == Enum.KeyCode.S then flyingMove.s = 1 end
            if input.KeyCode == Enum.KeyCode.A then flyingMove.a = 1 end
            if input.KeyCode == Enum.KeyCode.D then flyingMove.d = 1 end
            if input.KeyCode == Enum.KeyCode.Space then flyingMove.up = 1 end
            if input.KeyCode == Enum.KeyCode.LeftControl then flyingMove.down = 1 end
        end
    end
    local function onKeyEnded(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.W then flyingMove.w = 0 end
            if input.KeyCode == Enum.KeyCode.S then flyingMove.s = 0 end
            if input.KeyCode == Enum.KeyCode.A then flyingMove.a = 0 end
            if input.KeyCode == Enum.KeyCode.D then flyingMove.d = 0 end
            if input.KeyCode == Enum.KeyCode.Space then flyingMove.up = 0 end
            if input.KeyCode == Enum.KeyCode.LeftControl then flyingMove.down = 0 end
        end
    end
    flyKeyConns[1]=UIS.InputBegan:Connect(onKeyBegan)
    flyKeyConns[2]=UIS.InputEnded:Connect(onKeyEnded)
    flyConn = RS.RenderStepped:Connect(function()
        if optStates["Fly"] then
            local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local dir = Vector3.new(flyingMove.d-flyingMove.a, flyingMove.up-flyingMove.down, flyingMove.s-flyingMove.w)
                root.Velocity = cam.CFrame:VectorToWorldSpace(dir)*48
            end
        end
    end)
    taskHandles["Fly"] = function()
        if flyConn then flyConn:Disconnect() end
        for _,v in pairs(flyKeyConns) do if v then v:Disconnect() end end
        flyConn = nil; flyKeyConns = {}
    end
end
local function StopFly()
    if taskHandles["Fly"] then taskHandles["Fly"]() end
end

local noSpreadOn, noRecoilOn, silentAimOn = false,false,false
local patchConn = nil
local function PatchWeapons()
    if patchConn then patchConn:Disconnect() end
    patchConn = RS.Stepped:Connect(function()
        if noSpreadOn or noRecoilOn or silentAimOn then
            for _,f in pairs(getgc and getgc(true) or {}) do
                if typeof(f)=="function" then
                    local info = debug.getinfo and debug.getinfo(f)
                    if info and info.source and typeof(info.source)=="string" and info.source:lower():find("weapon") then
                        if noSpreadOn then pcall(function() hookfunction(f,function(...) return 0 end) end) end
                        if noRecoilOn then pcall(function() hookfunction(f,function(...) return 0 end) end) end
                        if silentAimOn then
                            pcall(function() hookfunction(f,function(...)
                                local cl = GetClosestPlayer()
                                if cl and cl.Character and cl.Character:FindFirstChild("Head") then
                                    return cl.Character.Head.Position
                                end
                                return ...
                            end) end)
                        end
                    end
                end
            end
        end
    end)
    taskHandles["WeaponPatch"] = patchConn
end

local function UnPatchWeapons()
    if patchConn then patchConn:Disconnect() patchConn = nil end
end

local function RejoinSelf()
    pcall(function()
        TPService:Teleport(game.PlaceId, LP)
    end)
end

local function SetInvisible()
    local char = LP.Character
    if not char then return end
    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then
            v.Transparency = 1
        elseif v:IsA("Decal") then
            v.Transparency = 1
        end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Name = "GodHumanoid" -- Godmodu tekrar uygula
    end
    Notify("Karakter görünmez yapıldı!")
end

local mt = getrawmetatable(game)
if setreadonly then setreadonly(mt, false) end
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod and getnamecallmethod() or ""
    if method=="Kick" then return end
    return oldNamecall(self, ...)
end)
if setreadonly then setreadonly(mt, true) end
for _,f in pairs(getgc and getgc(true) or {}) do
    if typeof(f)=="function" and getfenv(f).script then
        if tostring(f):find("Detected") or tostring(f):find("Ban") then
            hookfunction(f,function(...) return wait(9e9) end)
        end
    end
end

local function UpdateFeatures()
    for _,name in ipairs(alwaysActive) do
        if optStates[name] and not taskHandles["!"..name] then
            if name=="Aimbot" then StartAimbot() taskHandles["!Aimbot"]=true end
            if name=="ESP" then StartESP() taskHandles["!ESP"]=true end
            if name=="Godmode" then GodMode(true) taskHandles["!Godmode"]=true end
            if name=="Spinbot" then StartSpinbot() taskHandles["!Spinbot"]=true end
            if name=="Noclip" then StartNoclip() taskHandles["!Noclip"]=true end
            if name=="Fly" then StartFly() taskHandles["!Fly"]=true end
            if name=="NoSpread" then noSpreadOn=true;PatchWeapons() taskHandles["!NoSpread"]=true end
            if name=="NoRecoil" then noRecoilOn=true;PatchWeapons() taskHandles["!NoRecoil"]=true end
            if name=="SilentAim" then silentAimOn=true;PatchWeapons() taskHandles["!SilentAim"]=true end
        elseif not optStates[name] and taskHandles["!"..name] then
            if name=="Aimbot" then StopAimbot() taskHandles["!Aimbot"]=nil end
            if name=="ESP" then StopESP() taskHandles["!ESP"]=nil end
            if name=="Godmode" then GodMode(false) taskHandles["!Godmode"]=nil end
            if name=="Spinbot" then StopSpinbot() taskHandles["!Spinbot"]=nil end
            if name=="Noclip" then StopNoclip() taskHandles["!Noclip"]=nil end
            if name=="Fly" then StopFly() taskHandles["!Fly"]=nil end
            if name=="NoSpread" then noSpreadOn=false;taskHandles["!NoSpread"]=nil end
            if name=="NoRecoil" then noRecoilOn=false;taskHandles["!NoRecoil"]=nil end
            if name=="SilentAim" then silentAimOn=false;taskHandles["!SilentAim"]=nil end
            if not (noSpreadOn or noRecoilOn or silentAimOn) then UnPatchWeapons() end
        end
    end
end

for i,v in ipairs(opts) do
    local opt,key = v[1],v[2]
    optStates[opt]=false
    local but = Instance.new("TextButton")
    but.Size = UDim2.new(1,-22,0,34)
    but.Position = UDim2.new(0,11,0,50+(i-1)*37)
    but.BackgroundColor3 = Color3.fromRGB(36,36,36)
    but.BorderSizePixel = 0
    but.Font = Enum.Font.SourceSans
    but.Text = opt..": OFF"
    but.TextSize = 18
    but.TextColor3 = Color3.fromRGB(255,255,255)
    but.Parent = frm
    btns[opt] = but

    if key=="Toggle" then
        but.MouseButton1Click:Connect(function()
            optStates[opt] = not optStates[opt]
            but.Text = opt..": "..((optStates[opt] and "ON" or "OFF"))
            UpdateFeatures()
            Notify(opt.." "..((optStates[opt] and "AÇIK") or "KAPALI"))
        end)
    elseif key=="Button" then
        but.MouseButton1Click:Connect(function()
            if opt=="Kill All" then
                KillAllPlayers()
                Notify("Tüm oyuncular öldürüldü!")
            elseif opt=="Rejoin" then
                Notify("Yeniden bağlanılıyor...")
                RejoinSelf()
            elseif opt=="Invisible" then
                SetInvisible()
            else
                Notify(opt.." uygulandı!")
            end
        end)
    elseif key=="Input" then
        but.MouseButton1Click:Connect(function()
            if taskHandles["_inpt"] then pcall(function() taskHandles["_inpt"]:Destroy() end) end
            local inp = Instance.new("TextBox")
            inp.Size = UDim2.new(0,155,0,32)
            inp.Position = UDim2.new(0,21,1,-48)
            inp.BackgroundColor3 = Color3.fromRGB(27,27,27)
            inp.TextColor3 = Color3.fromRGB(255,255,255)
            inp.Text = "FOV değeri gir"
            inp.ClearTextOnFocus = true
            inp.Font = Enum.Font.SourceSans
            inp.TextSize = 18
            inp.Parent = frm
            inp.FocusLost:Connect(function()
                SetFOV(inp.Text)
                inp:Destroy()
            end)
            taskHandles["_inpt"] = inp
        end)
    elseif key=="PickPlayer" then
        but.MouseButton1Click:Connect(function()
            PlayerDropdown(function(p)
                if opt:lower():find("teleport") then
                    TeleportTo(p)
                    Notify(p.Name.." yanına ışınlandın!")
                elseif opt:lower():find("kill") then
                    KillPlayer(p)
                    Notify(p.Name.." öldürüldü!")
                end
            end)
        end)
    end
end

Notify("Quartz.lua açık! Insert tuşu ile menüyü aç/kapat. Tüm özellikler sorunsuz çalışıyor.")
local menuActive = true
UIS.InputBegan:Connect(function(inpt)
    if inpt.KeyCode == Enum.KeyCode.Insert then
        menuActive = not menuActive
        gui.Enabled = menuActive
    end
end)

Players.PlayerAdded:Connect(function()
    if taskHandles["_dropdown"] then pcall(function() taskHandles["_dropdown"]:Destroy() end) taskHandles["_dropdown"]=nil end
end)
Players.PlayerRemoving:Connect(function()
    if taskHandles["_dropdown"] then pcall(function() taskHandles["_dropdown"]:Destroy() end) taskHandles["_dropdown"]=nil end
end)

-- Tüm sürekli aktif özellikler ölümden sonra da devam etsin
local lastChar = nil
local function respawnPersist()
    if LP.Character ~= lastChar then
        lastChar = LP.Character
        wait(.12)
        for _,name in ipairs(alwaysActive) do
            if optStates[name] then
                if name=="Godmode" then GodMode(true) end
                if name=="Aimbot" then StartAimbot() end
                if name=="ESP" then StartESP() end
                if name=="Spinbot" then StartSpinbot() end
                if name=="Noclip" then StartNoclip() end
                if name=="Fly" then StartFly() end
                if name=="NoSpread" or name=="NoRecoil" or name=="SilentAim" then PatchWeapons() end
            end
        end
    end
end
LP.CharacterAdded:Connect(respawnPersist)
spawn(function() while wait(.75) do respawnPersist() end end)
