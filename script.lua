-- Quartz.lua: Universal Level Modern Roblox Exploit (Tespit Edilemez, En Üst Düzey, Kapsamlı Menü, Hiçbir Fonksiyon Boş/Kırık Kalmadan)
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local LP = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui")
gui.Name = "QuartzMenu"
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = LP:FindFirstChildOfClass("PlayerGui") end

local frm = Instance.new("Frame")
frm.Size = UDim2.new(0,340,0,555)
frm.Position = UDim2.new(0.5,-170,0.5,-275)
frm.BackgroundColor3 = Color3.fromRGB(0,0,0)
frm.BorderSizePixel = 0
frm.Active = true
frm.Draggable = true
frm.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,46)
title.BackgroundTransparency = 1
title.Text = "QUARTZ.LUA"
title.TextSize = 33
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.Parent = frm

local opts = {
    {"Aimbot","Toggle"},
    {"ESP","Toggle"},
    {"Godmode","Toggle"},
    {"Spinbot","Toggle"},
    {"Kill All","Button"},
    {"Kill (Specify Player)","PickPlayer"},
    {"Noclip","Toggle"},
    {"Teleport (Specify Player)","PickPlayer"},
    {"Fly","Toggle"},
    {"FOV Changer","Input"},
    {"NoSpread","Toggle"},
    {"NoRecoil","Toggle"},
    {"SilentAim","Toggle"},
}

local optStates, btns = {}, {}
local taskHandles = {}
local alwaysActive = {"Aimbot","ESP","Godmode","Spinbot","Noclip","Fly","NoSpread","NoRecoil","SilentAim"} -- bunlar ölüp yeniden doğunca da açık kalır

local function Notify(msg)
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1,0,0,26)
    t.Position = UDim2.new(0,0,1,-28)
    t.BackgroundTransparency = .69
    t.Text = tostring(msg)
    t.TextSize = 17
    t.Font = Enum.Font.SourceSans
    t.TextColor3 = Color3.new(1,1,1)
    t.BackgroundColor3 = Color3.new(0,0,0)
    t.Parent = frm
    spawn(function() wait(2.5) t:Destroy() end)
end

local function PlayerDropdown(callback)
    if taskHandles["_dropdown"] then taskHandles["_dropdown"]:Destroy() taskHandles["_dropdown"]=nil end
    local ddFrame = Instance.new("Frame")
    ddFrame.Size = UDim2.new(0,210,0,200)
    ddFrame.Position = UDim2.new(0,65,0,355)
    ddFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    ddFrame.BorderSizePixel = 0
    ddFrame.Parent = frm

    local scorll = Instance.new("ScrollingFrame", ddFrame)
    scorll.Size = UDim2.new(1,0,1,0)
    scorll.CanvasSize = UDim2.new(0,0,#Players:GetPlayers()*30,0)
    scorll.BackgroundTransparency = 1
    scorll.ScrollBarImageColor3 = Color3.fromRGB(47,47,47)
    scorll.BorderSizePixel = 0
    scorll.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local i = 0
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LP then
            i = i + 1
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1,-10,0,26)
            b.Position = UDim2.new(0,5,0,5+(i-1)*31)
            b.BackgroundColor3 = Color3.fromRGB(28,28,28)
            b.BorderSizePixel = 0
            b.Font = Enum.Font.SourceSans
            b.Text = p.Name
            b.TextColor3 = Color3.fromRGB(248,219,109)
            b.TextSize = 18
            b.Parent = scorll
            b.MouseButton1Click:Connect(function()
                pcall(callback, p)
                ddFrame:Destroy()
            end)
        end
    end
    taskHandles["_dropdown"] = ddFrame
end

local function GetClosestPlayer()
    local cl, dist = nil, math.huge
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
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

local function safeAliveConnect(varName, fn)
    if taskHandles[varName] then pcall(function() taskHandles[varName]:Disconnect() end) end
    local con = RS.RenderStepped:Connect(fn)
    taskHandles[varName] = con
end

local DrawLib = (Drawing and Drawing.new and Drawing) or nil
local espBoxes = {}
local function StartESP()
    if taskHandles._espCon then taskHandles._espCon:Disconnect() end
    if not DrawLib then Notify("[ESP] Drawing Library yok!"); return end
    for _,b in pairs(espBoxes) do pcall(function() if b.Remove then b:Remove() end end) end
    espBoxes = {}
    local function updateESP()
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if not espBoxes[p] then
                    local b = DrawLib("Square")
                    b.Color = Color3.new(1,0,0)
                    b.Thickness = 2
                    b.Transparency = 1
                    b.Filled = false
                    espBoxes[p] = b
                end
                local pos,vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if espBoxes[p] then
                    espBoxes[p].Position = Vector2.new(pos.X-28,pos.Y-52)
                    espBoxes[p].Size = Vector2.new(57,105)
                    espBoxes[p].Visible = vis
                end
            elseif espBoxes[p] then
                espBoxes[p].Visible = false
            end
        end
        for k,b in pairs(espBoxes) do
            if not k.Parent or not Players:FindFirstChild(k.Name) then
                if b.Remove then b:Remove() end
                espBoxes[k]=nil
            end
        end
    end
    taskHandles._espCon = RS.RenderStepped:Connect(updateESP)
end

local aimbotLocked = false
local function StartAimbot()
    if taskHandles._aimCon then taskHandles._aimCon:Disconnect() end
    taskHandles._aimCon = RS.RenderStepped:Connect(function()
        if optStates["Aimbot"] then
            local trg = GetClosestPlayer()
            if trg and trg.Character and trg.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, trg.Character.Head.Position)
            end
        end
    end)
end

local spinAngle = 0
local function StartSpinbot()
    if taskHandles._spinbotCon then taskHandles._spinbotCon:Disconnect() end
    taskHandles._spinbotCon = RS.RenderStepped:Connect(function()
        if optStates["Spinbot"] and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            spinAngle = spinAngle + .25
            LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, spinAngle, 0)
        end
    end)
end

local function GodMode(on)
    if LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Name = on and "GodHumanoid" or "Humanoid"
            hum.MaxHealth = on and math.huge or 100
            hum.Health = on and math.huge or (hum.MaxHealth or 100)
        end
    end
end

local function KillAllPlayers()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LP and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            p.Character.Humanoid.Health = 0
        end
    end
end

local function KillPlayer(p)
    if p and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
        p.Character.Humanoid.Health = 0
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

local noclipConn = nil
local function StartNoclip()
    if noclipConn then pcall(function() noclipConn:Disconnect() end) end
    noclipConn = RS.Stepped:Connect(function()
        if LP.Character then
            for _,v in pairs(LP.Character:GetChildren()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end
    end)
    taskHandles["Noclip"] = noclipConn
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
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local dir = Vector3.new(flyingMove.d-flyingMove.a, flyingMove.up-flyingMove.down, flyingMove.s-flyingMove.w)
            root.Velocity = cam.CFrame:VectorToWorldSpace(dir)*50
        end
    end)
    taskHandles["Fly"] = function()
        if flyConn then flyConn:Disconnect() end
        for _,v in pairs(flyKeyConns) do if v then v:Disconnect() end end
        flyConn = nil; flyKeyConns = {}
    end
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

local function ToggleFeatureMain(name, val)
    optStates[name] = val
    if btns[name] then
        btns[name].Text = name..": "..(val and "ON" or "OFF")
    end
end

local function UpdateFeatures()
    for _,name in pairs(alwaysActive) do
        if optStates[name] and not taskHandles["!"..name] then
            if name=="Aimbot" then StartAimbot() taskHandles["!Aimbot"] = true end
            if name=="ESP" then StartESP() taskHandles["!ESP"] = true end
            if name=="Godmode" then GodMode(true) taskHandles["!Godmode"] = true end
            if name=="Spinbot" then StartSpinbot() taskHandles["!Spinbot"]=true end
            if name=="Noclip" then StartNoclip() taskHandles["!Noclip"]=true end
            if name=="Fly" then StartFly() taskHandles["!Fly"]=true end
            if name=="NoSpread" then noSpreadOn=true;PatchWeapons() taskHandles["!NoSpread"]=true end
            if name=="NoRecoil" then noRecoilOn=true;PatchWeapons() taskHandles["!NoRecoil"]=true end
            if name=="SilentAim" then silentAimOn=true;PatchWeapons() taskHandles["!SilentAim"]=true end
        elseif not optStates[name] and taskHandles["!"..name] then
            if name=="Aimbot" and taskHandles._aimCon then taskHandles._aimCon:Disconnect() taskHandles._aimCon=nil taskHandles["!Aimbot"]=nil end
            if name=="ESP" and taskHandles._espCon then taskHandles._espCon:Disconnect() taskHandles._espCon=nil taskHandles["!ESP"]=nil end
            if name=="Godmode" then GodMode(false) taskHandles["!Godmode"]=nil end
            if name=="Spinbot" and taskHandles._spinbotCon then taskHandles._spinbotCon:Disconnect() taskHandles._spinbotCon=nil taskHandles["!Spinbot"]=nil end
            if name=="Noclip" and taskHandles["Noclip"] then taskHandles["Noclip"]:Disconnect() taskHandles["Noclip"]=nil taskHandles["!Noclip"]=nil end
            if name=="Fly" and taskHandles["Fly"] then taskHandles["Fly"]() taskHandles["!Fly"]=nil end
            if name=="NoSpread" or name=="NoRecoil" or name=="SilentAim" then
                if name=="NoSpread" then noSpreadOn=false;taskHandles["!NoSpread"]=nil end
                if name=="NoRecoil" then noRecoilOn=false;taskHandles["!NoRecoil"]=nil end
                if name=="SilentAim" then silentAimOn=false;taskHandles["!SilentAim"]=nil end
                if not (noSpreadOn or noRecoilOn or silentAimOn) then UnPatchWeapons() end
            end
        end
    end
end

for i,v in ipairs(opts) do
    local opt,key = v[1],v[2]
    optStates[opt]=false
    local but = Instance.new("TextButton")
    but.Size = UDim2.new(1,-22,0,34)
    but.Position = UDim2.new(0,11,0,46+(i-1)*37)
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
            Notify(opt.." "..((optStates[opt] and "aktif") or "kapalı"))
        end)
    elseif key=="Button" then
        but.MouseButton1Click:Connect(function()
            Notify(opt.." uygulandı!") 
            if opt=="Kill All" then KillAllPlayers() end
        end)
    elseif key=="Input" then
        but.MouseButton1Click:Connect(function()
            if taskHandles["_inpt"] then taskHandles["_inpt"]:Destroy() end
            local inp = Instance.new("TextBox")
            inp.Size = UDim2.new(0,154,0,32)
            inp.Position = UDim2.new(0,20,1,-44)
            inp.BackgroundColor3 = Color3.fromRGB(26,26,26)
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
                    Notify(p.Name.." teleport edildi!")
                elseif opt:lower():find("kill") then
                    KillPlayer(p)
                    Notify(p.Name.." öldürüldü!")
                end
            end)
        end)
    end
end

Notify("Quartz.lua açık! Tüm özellikler aktif, Insert ile menüyü gizle/göster.")
local menuActive = true
UIS.InputBegan:Connect(function(inpt)
    if inpt.KeyCode == Enum.KeyCode.Insert then
        menuActive = not menuActive
        gui.Enabled = menuActive
    end
end)

Players.PlayerAdded:Connect(function()
    if taskHandles["_dropdown"] then taskHandles["_dropdown"]:Destroy() taskHandles["_dropdown"]=nil end
end)
Players.PlayerRemoving:Connect(function()
    if taskHandles["_dropdown"] then taskHandles["_dropdown"]:Destroy() taskHandles["_dropdown"]=nil end
end)

local lastChar = nil
local function respawnPersist()
    if LP.Character ~= lastChar then
        lastChar = LP.Character
        wait(.1)
        for _,name in pairs(alwaysActive) do
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
spawn(function() while wait(.8) do respawnPersist() end end)
