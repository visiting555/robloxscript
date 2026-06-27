local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Workspace = game:GetService("Workspace")

local menuOpen = true
local dragging = false
local dragOffset = Vector2.new(0,0)
local menuPos = Vector2.new(120,120)
local menuSize = Vector2.new(335,292)
local activeTab = 1
local font = Enum.Font.GothamBold

local cheats = {
    Aim = {
        Aimbot = false,
        SilentAim = false,
        FOV = 90,
        FOVChanger = false,
    },
    Vision = {
        ESP = false,
        Spectate = false,
    },
    Troll = {
        Fly = false,
        Spinbot = false,
        Teleport = false,
        TeleportTo = "",
        BringHere = false,
        BringHereTarget = "",
        Exploda = false,
        ExplodaTarget = "",
    },
    Misc = {
        NoClip = false,
        NoReload = false,
        Godmode = false,
        Rejoin = false,
        ResetChar = false,
    }
}

local menuTabs = {
    {name="Aim Hileleri", color=Color3.fromRGB(255,0,0)},
    {name="Görüş Hileleri", color=Color3.fromRGB(255,0,0)},
    {name="Troll Hileleri", color=Color3.fromRGB(255,0,0)},
    {name="Bireysel Hileler", color=Color3.fromRGB(255,0,0)}
}

local tabOpt = {
    [1] = {"Aimbot","SilentAim","FOVChanger"},
    [2] = {"ESP","Spectate"},
    [3] = {"Fly","Spinbot","Teleport","Yanına Teleport","Exploda"},
    [4] = {"NoClip","NoReload","Godmode","Rejoin","ResetChar"}
}

local spectateTarget = ""
local function isWithin(pos, size, point)
    return point.X > pos.X and point.X < (pos.X+size.X) and point.Y > pos.Y and point.Y < (pos.Y+size.Y)
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        menuOpen = not menuOpen
    end
    if input.KeyCode==Enum.KeyCode.RightControl then
        menuOpen=false
        wait(2)
        menuOpen=true
    end
end)

local drawingObjects = {}
function clearDrawings()
    for _,obj in ipairs(drawingObjects) do
        pcall(function() obj:Remove() end)
    end
    drawingObjects = {}
end
function drawRect(pos, size, color, transparency, thickness)
    local s = Drawing.new("Square")
    s.Position = pos
    s.Size = size
    s.Color = color
    s.Transparency = transparency or 1
    s.Thickess = thickness or 1
    s.Filled = true
    table.insert(drawingObjects, s)
    return s
end
function drawText(text, pos, size, color)
    local t = Drawing.new("Text")
    t.Text = text
    t.Position = pos
    t.Size = size
    t.Font = font
    t.Color = color
    t.Outline = true
    t.Center = false
    table.insert(drawingObjects, t)
    return t
end
function drawButton(text,pos,size,selected,clickevent)
    local b = drawRect(pos,size,selected and Color3.fromRGB(90,0,0) or Color3.fromRGB(30,0,0),0.92)
    local t = drawText(text,Vector2.new(pos.X+7,pos.Y+3),17,Color3.fromRGB(255,0,0))
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local mx,my = Mouse.X,Mouse.Y
        if isWithin(pos,size,Vector2.new(mx,my)) then
            clickevent()
        end
    end
    return {b,t}
end
function drawToggle(text,pos,enabled,evt)
    local r=drawRect(pos,Vector2.new(19,19),enabled and Color3.fromRGB(220,0,0) or Color3.fromRGB(60,0,0),0.82)
    local t=drawText(text,Vector2.new(pos.X+25,pos.Y+1),17,Color3.fromRGB(255,0,0))
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        if isWithin(pos,Vector2.new(19,19),Vector2.new(Mouse.X,Mouse.Y)) then
            evt(not enabled)
        end
    end
    return {r,t}
end
function drawSlider(text,pos,value,minv,maxv,onchange)
    local size=Vector2.new(90,15)
    local track=drawRect(pos,size,Color3.fromRGB(25,0,0),1)
    local fillv=(value-minv)/(maxv-minv)*size.X
    local fill=drawRect(pos,Vector2.new(fillv,size.Y),Color3.fromRGB(120,0,0),1)
    local t=drawText(text..":"..math.floor(value),Vector2.new(pos.X+size.X+6,pos.Y+1),15,Color3.fromRGB(255,0,0))
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        if isWithin(pos,size,Vector2.new(Mouse.X,Mouse.Y)) then
            local nv=(((Mouse.X-pos.X)/size.X)*(maxv-minv))+minv
            nv=math.clamp(nv,minv,maxv)
            onchange(nv)
        end
    end
    return {track,fill,t}
end
function drawPlayerDropdown(players,pos,selected,onchange)
    local size=Vector2.new(110,17)
    local chosen=selected or ""
    local btn=drawRect(pos,size,Color3.fromRGB(25,0,0),1)
    local t=drawText(chosen=="" and "Oyuncu seç" or chosen,Vector2.new(pos.X+3,pos.Y+1),15,Color3.fromRGB(255,255,255))
    local open=false
    if isWithin(pos,size,Vector2.new(Mouse.X,Mouse.Y)) and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        open=true
    end
    if open then
        for i,p in ipairs(players) do
            drawRect(Vector2.new(pos.X,pos.Y+17*i),size,Color3.fromRGB(20,20,20),1)
            drawText(p.Name,Vector2.new(pos.X+3,pos.Y+1+17*i),15,Color3.fromRGB(255,255,255))
            if isWithin(Vector2.new(pos.X,pos.Y+17*i),size,Vector2.new(Mouse.X,Mouse.Y)) and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                chosen=p.Name
                onchange(p.Name)
            end
        end
    end
    return chosen
end

Mouse.Button1Down:Connect(function()
    if isWithin(menuPos,Vector2.new(menuSize.X,32),Vector2.new(Mouse.X,Mouse.Y)) and menuOpen then
        dragging=true
        dragOffset=Vector2.new(Mouse.X,Mouse.Y)-menuPos
    end
end)
Mouse.Button1Up:Connect(function()
    dragging=false
end)
RunService.RenderStepped:Connect(function()
    if dragging then
        menuPos=Vector2.new(Mouse.X,Mouse.Y)-dragOffset
    end
end)

local function getDropdownPlayers()
    local plys = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=Player then table.insert(plys,p) end
    end
    return plys
end

function drawMenu()
    clearDrawings()
    if not menuOpen then return end
    drawRect(menuPos,menuSize,Color3.fromRGB(10,10,10),0.93)
    drawRect(menuPos,Vector2.new(menuSize.X,32),Color3.fromRGB(20,20,20),0.99)
    drawText("ROX Modern v3",Vector2.new(menuPos.X+10,menuPos.Y+5),21,Color3.fromRGB(255,0,0))
    local tabX,tabY=menuPos.X+7,menuPos.Y+40
    for i,tab in ipairs(menuTabs) do
        drawButton(tab.name,Vector2.new(tabX,tabY+(i-1)*28),Vector2.new(106,26),i==activeTab,function()activeTab=i end)
    end
    local optX=menuPos.X+117
    local optY=menuPos.Y+40
    local optSep=29
    if activeTab==1 then
        drawToggle("Aimbot",Vector2.new(optX,optY),cheats.Aim.Aimbot,function(v)cheats.Aim.Aimbot=v end)
        drawToggle("SilentAim",Vector2.new(optX,optY+optSep),cheats.Aim.SilentAim,function(v)cheats.Aim.SilentAim=v end)
        drawSlider("FOV",Vector2.new(optX,optY+optSep*2),cheats.Aim.FOV,30,360,function(v)cheats.Aim.FOV=math.floor(v) end)
        drawToggle("FOVChanger",Vector2.new(optX,optY+optSep*3),cheats.Aim.FOVChanger,function(v)cheats.Aim.FOVChanger=v end)
    elseif activeTab==2 then
        drawToggle("ESP",Vector2.new(optX,optY),cheats.Vision.ESP,function(v)cheats.Vision.ESP=v end)
        drawToggle("Spectate",Vector2.new(optX,optY+optSep),cheats.Vision.Spectate,function(v)
            cheats.Vision.Spectate=v
            if not v then spectateTarget = "" end
        end)
        local plys=getDropdownPlayers()
        if cheats.Vision.Spectate then
            spectateTarget=drawPlayerDropdown(plys,Vector2.new(optX,optY+optSep*2),spectateTarget,function(name)spectateTarget=name end)
        end
    elseif activeTab==3 then
        drawToggle("Fly",Vector2.new(optX,optY),cheats.Troll.Fly,function(v)cheats.Troll.Fly=v end)
        drawToggle("Spinbot",Vector2.new(optX,optY+optSep),cheats.Troll.Spinbot,function(v)cheats.Troll.Spinbot=v end)
        drawToggle("Teleport",Vector2.new(optX,optY+optSep*2),cheats.Troll.Teleport,function(v)cheats.Troll.Teleport=v end)
        local plys=getDropdownPlayers()
        if cheats.Troll.Teleport then
            cheats.Troll.TeleportTo=drawPlayerDropdown(plys,Vector2.new(optX+100,optY+optSep*2),cheats.Troll.TeleportTo,function(n)cheats.Troll.TeleportTo=n end)
        end
        drawToggle("Yanına Teleport",Vector2.new(optX,optY+optSep*3),cheats.Troll.BringHere,function(v)cheats.Troll.BringHere=v end)
        if cheats.Troll.BringHere then
            cheats.Troll.BringHereTarget=drawPlayerDropdown(plys,Vector2.new(optX+100,optY+optSep*3),cheats.Troll.BringHereTarget,function(n)cheats.Troll.BringHereTarget=n end)
        end
        drawToggle("Exploda",Vector2.new(optX,optY+optSep*4),cheats.Troll.Exploda,function(v)cheats.Troll.Exploda=v end)
        if cheats.Troll.Exploda then
            cheats.Troll.ExplodaTarget=drawPlayerDropdown(plys,Vector2.new(optX+100,optY+optSep*4),cheats.Troll.ExplodaTarget,function(n)cheats.Troll.ExplodaTarget=n end)
        end
    elseif activeTab==4 then
        drawToggle("NoClip",Vector2.new(optX,optY),cheats.Misc.NoClip,function(v)cheats.Misc.NoClip=v end)
        drawToggle("NoReload",Vector2.new(optX,optY+optSep),cheats.Misc.NoReload,function(v)cheats.Misc.NoReload=v end)
        drawToggle("Godmode",Vector2.new(optX,optY+optSep*2),cheats.Misc.Godmode,function(v)cheats.Misc.Godmode=v end)
        drawButton("Rejoin",Vector2.new(optX,optY+optSep*3),Vector2.new(95,25),false,function()cheats.Misc.Rejoin=true end)
        drawButton("Reset",Vector2.new(optX,optY+optSep*4),Vector2.new(95,25),false,function()cheats.Misc.ResetChar=true end)
    end
end

RunService.RenderStepped:Connect(drawMenu)

function antiDetect()
    if setreadonly then
        pcall(function()
            setreadonly(getrawmetatable(game),false)
            getrawmetatable(game).__newindex=function(...) return nil end
            getrawmetatable(game).__index=function(t,k) return rawget(t,k) end
        end)
    end
    for i=1,190 do spawn(function() math.randomseed(os.clock()) end) end
end
antiDetect()

local function isEnemy(plr)
    if plr==Player then return false end
    local suc,tt=pcall(function() return plr.Team end)
    if suc and tt then
        return plr.Team~=Player.Team
    end
    return true
end

local function getClosestEnemy(FOV)
    local tgt,dist=nil,FOV
    for _,plr in pairs(Players:GetPlayers()) do
        if isEnemy(plr) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health>0 then
            local pos=Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            local d=(Vector2.new(pos.X,pos.Y)-Vector2.new(Mouse.X,Mouse.Y)).Magnitude
            if d<dist then dist=d tgt=plr.Character end
        end
    end
    return tgt
end

local silentTarget=nil
RunService.RenderStepped:Connect(function()
    if cheats.Aim.Aimbot then
        local tgt=getClosestEnemy(cheats.Aim.FOV)
        if tgt then
            local tool=Player.Character and Player.Character:FindFirstChildOfClass("Tool")
            if tool then
                Camera.CFrame=CFrame.new(Camera.CFrame.Position,tgt.HumanoidRootPart.Position)
            end
        end
    end
    if cheats.Aim.SilentAim then
        silentTarget=getClosestEnemy(cheats.Aim.FOV)
    else
        silentTarget=nil
    end
    if cheats.Aim.FOVChanger then
        Camera.FieldOfView=cheats.Aim.FOV
    else
        Camera.FieldOfView=70
    end
end)

local espObjs={}
function clearESP()
    for _,v in ipairs(espObjs) do pcall(function() v:Remove() end) end
    espObjs={}
end
RunService.RenderStepped:Connect(function()
    clearESP()
    if cheats.Vision.ESP then
        for _,plr in pairs(Players:GetPlayers()) do
            if isEnemy(plr) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health>0 then
                local hrp=plr.Character.HumanoidRootPart
                local pos,onScreen=Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local b=Drawing.new("Square")
                    b.Position=Vector2.new(pos.X-13,pos.Y-31)
                    b.Size=Vector2.new(26,52)
                    b.Color=Color3.fromRGB(255,0,0)
                    b.Filled=false
                    b.Visible=true
                    b.Thickness=2
                    table.insert(espObjs,b)
                    local t=Drawing.new("Text")
                    t.Text=plr.Name
                    t.Position=Vector2.new(pos.X-14,pos.Y-44)
                    t.Size=15
                    t.Color=Color3.fromRGB(255,0,0)
                    t.Outline=true
                    t.Center=true
                    table.insert(espObjs,t)
                end
            end
        end
    end
end)

local flying,flyConn=false,nil
function setFly(state)
    local cc=Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if state and not flying and cc then
        flying=true
        local bv=Instance.new("BodyVelocity",cc)
        bv.MaxForce=Vector3.new(9e9,9e9,9e9)
        bv.Name="~fly"
        flyConn=RunService.RenderStepped:Connect(function()
            if cheats.Troll.Fly and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local move=Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move=move+Camera.CFrame.LookVector*4 end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move=move-Camera.CFrame.LookVector*3 end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move=move+Vector3.new(0,8,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move=move-Vector3.new(0,7,0) end
                bv.Velocity=move
            else
                bv:Destroy()
                if flyConn then flyConn:Disconnect() end
                flying=false
            end
        end)
    elseif not state and flying then
        if cc:FindFirstChild("~fly") then cc["~fly"]:Destroy() end
        if flyConn then flyConn:Disconnect() end
        flying=false
    end
end

RunService.RenderStepped:Connect(function()setFly(cheats.Troll.Fly)end)

RunService.RenderStepped:Connect(function()
    if cheats.Troll.Spinbot then
        local char=Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame=char.HumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(31),0)
        end
    end
end)

function teleportToPlayer(name)
    for _,pl in pairs(Players:GetPlayers()) do
        if pl.Name==name and pl~=Player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.CFrame=pl.Character.HumanoidRootPart.CFrame+Vector3.new(0,3,0)
            end
        end
    end
end
function bringHerePlayer(name)
    for _,pl in pairs(Players:GetPlayers()) do
        if pl.Name==name and pl~=Player and pl.Character and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            pl.Character.HumanoidRootPart.CFrame=Player.Character.HumanoidRootPart.CFrame+Vector3.new(2,0,0)
        end
    end
end
function explodaPlayer(name)
    for _,pl in pairs(Players:GetPlayers()) do
        if pl.Name==name and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            local exp=Instance.new("Explosion",Workspace)
            exp.Position=pl.Character.HumanoidRootPart.Position
            exp.BlastRadius=6
            exp.BlastPressure=999999
        end
    end
end

RunService.RenderStepped:Connect(function()
    if cheats.Troll.Teleport and cheats.Troll.TeleportTo~="" then
        teleportToPlayer(cheats.Troll.TeleportTo)
        cheats.Troll.Teleport=false
        cheats.Troll.TeleportTo=""
    end
    if cheats.Troll.BringHere and cheats.Troll.BringHereTarget~="" then
        bringHerePlayer(cheats.Troll.BringHereTarget)
        cheats.Troll.BringHere=false
        cheats.Troll.BringHereTarget=""
    end
    if cheats.Troll.Exploda and cheats.Troll.ExplodaTarget~="" then
        explodaPlayer(cheats.Troll.ExplodaTarget)
        cheats.Troll.Exploda=false
        cheats.Troll.ExplodaTarget=""
    end
end)

local noclipActive,noclipConn=false,nil
function setNoclip(state)
    if state and not noclipActive then
        noclipActive=true
        noclipConn=RunService.Stepped:Connect(function()
            local char=Player.Character
            if char then
                for _,part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide=false
                    end
                end
            end
        end)
    elseif not state and noclipActive then
        noclipActive=false
        if noclipConn then noclipConn:Disconnect() end
        local char=Player.Character
        if char then
            for _,part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide=true
                end
            end
        end
    end
end
RunService.RenderStepped:Connect(function()setNoclip(cheats.Misc.NoClip)end)

RunService.RenderStepped:Connect(function()
    if cheats.Vision.Spectate and spectateTarget~="" then
        for _,pl in pairs(Players:GetPlayers()) do
            if pl.Name==spectateTarget and pl.Character and pl.Character:FindFirstChild("Head") then
                Camera.CameraSubject=pl.Character.Head
            end
        end
    elseif not cheats.Vision.Spectate then
        Camera.CameraSubject=Player.Character and Player.Character:FindFirstChild("Head") or Player.Character
    end
end)

local function unlimitedAmmo()
    local bp=Player.Backpack
    for _,tool in pairs(bp:GetChildren()) do
        if tool:FindFirstChild("Ammo") then
            tool.Ammo.Value=999999
        end
    end
    if Player.Character then
        for _,tool in pairs(Player.Character:GetChildren()) do
            if tool:FindFirstChild("Ammo") then
                tool.Ammo.Value=999999
            end
        end
    end
end
RunService.RenderStepped:Connect(function()
    if cheats.Misc.NoReload then
        unlimitedAmmo()
    end
end)

function godmode()
    local char = Player.Character or Player.CharacterAdded:Wait()
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Name="1"
        local nh=char.Humanoid:Clone()
        nh.Name="Humanoid"
        nh.Parent=char
        wait(0.1)
        char["1"]:Destroy()
        Camera.CameraSubject=nh
    end
end
RunService.RenderStepped:Connect(function()
    if cheats.Misc.Godmode then
        godmode()
    end
end)

function rejoin()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId,Player)
end
function resetChar()
    if Player.Character then
        Player.Character:BreakJoints()
    end
end
RunService.RenderStepped:Connect(function()
    if cheats.Misc.Rejoin then
        cheats.Misc.Rejoin=false
        rejoin()
    end
    if cheats.Misc.ResetChar then
        cheats.Misc.ResetChar=false
        resetChar()
    end
end)

local old;old=hookmetamethod(game,"__namecall",function(self,...)
    local args={...}
    if cheats.Aim.SilentAim and tostring(self)=="Hit" and silentTarget and not checkcaller() then
        if silentTarget and silentTarget:FindFirstChild("HumanoidRootPart") then
            args[2]=silentTarget.HumanoidRootPart.Position
            return old(self,unpack(args))
        end
    end
    return old(self,...)
end)

Players.PlayerAdded:Connect(function()wait(0.35)end)
Players.PlayerRemoving:Connect(function()wait(0.33)end)

for i=1,250 do spawn(function() pcall(function() math.random();end) end) end
for i=1,100 do function _G["compatcb"..i]()return true end end
