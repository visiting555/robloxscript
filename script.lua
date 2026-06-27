local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Mouse = LocalPlayer:GetMouse()
local StarterGui = game:GetService("StarterGui")

local function getPlayerGui()
    return LocalPlayer:FindFirstChildOfClass("PlayerGui") or CoreGui
end

local features = {
    Aimbot = false, SilentAim = false, ESP = false, Fly = false, Teleport = false, Bring=false, Noclip = false,
    Spectate = false, FOV = false, NoReload = false, Godmode = false, Rejoin = false, Reset = false, Explode = false, Spinbot = false
}

local fovValue = 120
local flySpeed = 5
local cheatDisabled = false

local espObjects = {}
local menuSize = Vector2.new(500, 560)
local menuPos = Vector2.new((Camera.ViewportSize.X-500)/2,(Camera.ViewportSize.Y-560)/2)
local dragStart,dragging = nil,false
local selectedPlayerForTeleport,selectedPlayerForBring,selectedPlayerForSpectate,selectedPlayerForExplode=nil,nil,nil,nil
local menuOpened = true

if getPlayerGui():FindFirstChild("CheatPROMenu") then getPlayerGui().CheatPROMenu:Destroy() end
local gui = {}
gui.Main = Instance.new("ScreenGui")
gui.Main.Name = "CheatPROMenu"
gui.Main.ResetOnSpawn = false
gui.Main.Parent = getPlayerGui()

gui.Frame = Instance.new("Frame")
gui.Frame.Name = "MainFrame"
gui.Frame.Size = UDim2.new(0,menuSize.X,0,menuSize.Y)
gui.Frame.Position = UDim2.new(0,menuPos.X,0,menuPos.Y)
gui.Frame.BackgroundColor3 = Color3.new(0,0,0)
gui.Frame.BorderSizePixel = 0
gui.Frame.Active = true
gui.Frame.Visible = true
gui.Frame.Parent = gui.Main

gui.TopBar = Instance.new("TextLabel", gui.Frame)
gui.TopBar.Text = "ROBLOX MODERN CHEAT MENU"
gui.TopBar.Size = UDim2.new(1,0,0,42)
gui.TopBar.BackgroundColor3 = Color3.new(0,0,0)
gui.TopBar.TextColor3 = Color3.fromRGB(255,0,0)
gui.TopBar.Font = Enum.Font.GothamBold
gui.TopBar.TextSize = 28

local categories = {
    ["Aim Hileleri"] = {
        {Key="Aimbot", Name="Aimbot"},
        {Key="SilentAim",Name="Silent Aim"},
        {Key="FOV",Name="FOV Changer"},
        {Key="Spinbot",Name="Spinbot"},
    },
    ["Görüş Hileleri"] = {
        {Key="ESP", Name="ESP"},
        {Key="Spectate", Name="Oyuncuyu İzle"},
    },
    ["Troll Hileleri"] = {
        {Key="Explode", Name="Patlat"},
        {Key="Bring", Name="Yanına Çek"},
        {Key="Teleport", Name="Oyuncuya Işınlan"},
        {Key="Fly", Name="Fly"},
        {Key="Noclip", Name="Noclip"},
    },
    ["Bireysel Hileler"] = {
        {Key="Godmode", Name="Godmode"},
        {Key="NoReload", Name="Sınırsız Mermi"},
        {Key="Reset", Name="Karakterini Sıfırla"},
        {Key="Rejoin", Name="Rejoin"},
    },
}

local categoryOrder = {"Aim Hileleri", "Görüş Hileleri", "Troll Hileleri", "Bireysel Hileler"}
local buttonRefs = {}

local xPos = 18
for _,cat in ipairs(categoryOrder) do
    local btnFrame = Instance.new("Frame",gui.Frame)
    btnFrame.Position = UDim2.new(0, xPos, 0, 70)
    btnFrame.Size = UDim2.new(0, 116, 0, #categories[cat]*40+27)
    btnFrame.BackgroundColor3 = Color3.new(0,0,0)
    local catTitle = Instance.new("TextLabel", btnFrame)
    catTitle.Text = cat
    catTitle.Font = Enum.Font.GothamBold
    catTitle.TextSize = 15
    catTitle.TextColor3 = Color3.fromRGB(255,0,0)
    catTitle.Size = UDim2.new(1,0,0,20)
    catTitle.BackgroundTransparency = 1

    for i,item in ipairs(categories[cat]) do
        local btn = Instance.new("TextButton", btnFrame)
        btn.Name = item.Key .. "Btn"
        btn.Position = UDim2.new(0, 0, 0, 22+(i-1)*40)
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.Text = item.Name..(features[item.Key] and " [AÇIK]" or " [KAPALI]")
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Color3.fromRGB(255,0,0)
        btn.BackgroundColor3 = Color3.fromRGB(15,15,15)
        btn.BorderSizePixel = 0
        btn.TextSize = 16
        buttonRefs[item.Key] = btn
        btn.MouseButton1Click:Connect(function()
            if item.Key == "Teleport" or item.Key == "Bring" or item.Key=="Spectate" or item.Key=="Explode" then
                local options = {}
                for _,p in ipairs(Players:GetPlayers()) do
                    if p~=LocalPlayer then table.insert(options,p) end
                end
                local selector = Instance.new("Frame",gui.Frame)
                selector.Size = UDim2.new(0,283,0,35+#options*35)
                selector.Position = UDim2.new(0,menuSize.X-10,0,60)
                selector.BackgroundColor3 = Color3.fromRGB(18,4,7)
                local title=Instance.new("TextLabel",selector)
                title.Text = (item.Key=="Teleport" and "Işınlanacağın Oyuncuyu Seç") or (item.Key=="Bring" and "Yanına Çekeceğin Oyuncuyu Seç") or (item.Key=="Spectate" and "İzleyeceğin Oyuncuyu Seç") or (item.Key=="Explode" and "Patlatacağın Oyuncuyu Seç")
                title.Size=UDim2.new(1,0,0,24)
                title.TextColor3=Color3.fromRGB(255,0,0)
                title.BackgroundTransparency=1
                title.Font=Enum.Font.GothamBold
                title.TextSize=15
                for idx,p in ipairs(options) do
                    local pbtn = Instance.new("TextButton",selector)
                    pbtn.Size=UDim2.new(1,-8,0,26)
                    pbtn.Position = UDim2.new(0,4,0,28+(idx-1)*30)
                    pbtn.Text = p.DisplayName.." ("..p.Name..")"
                    pbtn.TextColor3 = Color3.fromRGB(255,0,0)
                    pbtn.BackgroundColor3 = Color3.fromRGB(20,0,0)
                    pbtn.Font = Enum.Font.GothamBold
                    pbtn.TextSize = 14
                    pbtn.MouseButton1Click:Connect(function()
                        selector:Destroy()
                        if item.Key == "Teleport" then selectedPlayerForTeleport=p features.Teleport=true
                        elseif item.Key == "Bring" then selectedPlayerForBring=p features.Bring=true
                        elseif item.Key=="Spectate" then selectedPlayerForSpectate=p features.Spectate=true
                        elseif item.Key=="Explode" then selectedPlayerForExplode=p features.Explode=true end
                    end)
                end
                delay(8,function() if selector and selector.Parent then selector:Destroy() end end)
            elseif item.Key=="FOV" then
                local fovWin=Instance.new("Frame",gui.Frame)
                fovWin.Size=UDim2.new(0,130,0,45)
                fovWin.Position=UDim2.new(0,menuSize.X-110,0,menuSize.Y-145)
                fovWin.BackgroundColor3=Color3.fromRGB(18,8,8)
                local valueLabel=Instance.new("TextLabel",fovWin)
                valueLabel.Text="FOV: "..tostring(fovValue)
                valueLabel.Size=UDim2.new(1,0,0,19)
                valueLabel.Font=Enum.Font.GothamBold
                valueLabel.TextColor3=Color3.fromRGB(255,0,0)
                valueLabel.TextSize=15
                valueLabel.BackgroundTransparency=1
                local minus=Instance.new("TextButton",fovWin)
                minus.Text="-"
                minus.Position = UDim2.new(0,10,0,22)
                minus.Size = UDim2.new(0,40,0,20)
                minus.BackgroundColor3 = Color3.fromRGB(30,0,0)
                minus.Font=Enum.Font.GothamBold
                minus.TextColor3=Color3.fromRGB(255,0,0)
                minus.TextSize=17
                minus.MouseButton1Click:Connect(function() fovValue=math.max(20,fovValue-10) valueLabel.Text="FOV: "..tostring(fovValue) end)
                local plus=Instance.new("TextButton",fovWin)
                plus.Text="+"
                plus.Position = UDim2.new(0,80,0,22)
                plus.Size = UDim2.new(0,40,0,20)
                plus.BackgroundColor3 = Color3.fromRGB(30,0,0)
                plus.Font=Enum.Font.GothamBold
                plus.TextColor3=Color3.fromRGB(255,0,0)
                plus.TextSize=17
                plus.MouseButton1Click:Connect(function() fovValue=math.min(320,fovValue+10) valueLabel.Text="FOV: "..tostring(fovValue) end)
                delay(6,function() if fovWin and fovWin.Parent then fovWin:Destroy() end end)
            else
                features[item.Key]=not features[item.Key]
                btn.Text = item.Name..(features[item.Key] and " [AÇIK]" or " [KAPALI]")
            end
        end)
    end
    xPos = xPos + 126
end

-- Dragging (Modern style)
gui.TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging=true
        dragStart=Vector2.new(input.Position.X, input.Position.Y) - Vector2.new(gui.Frame.Position.X.Offset,gui.Frame.Position.Y.Offset)
    end
end)
gui.TopBar.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
        local newPos = Vector2.new(input.Position.X, input.Position.Y)-dragStart
        gui.Frame.Position = UDim2.new(0,math.clamp(newPos.X,10,Camera.ViewportSize.X-menuSize.X-10),0,math.clamp(newPos.Y,10,Camera.ViewportSize.Y-menuSize.Y-10))
    end
end)

UserInputService.InputBegan:Connect(function(input,gpe)
    if input.KeyCode==Enum.KeyCode.Insert and not gpe then
        menuOpened=not menuOpened
        gui.Frame.Visible=menuOpened
        if not menuOpened then gui.Frame.Visible=false end
    end
end)

local fadeStart
RunService.RenderStepped:Connect(function()
    if not gui.Frame.Visible then
        if not fadeStart then fadeStart=tick() end
        if tick()-fadeStart>2 then
            gui.Frame.Visible=true
            menuOpened=true
            fadeStart=nil
        end
    else
        fadeStart=nil
    end
end)

-- ESP
function getRoot(plr)
    if not plr.Character then return nil end
    return plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChildWhichIsA("BasePart")
end
function isEnemy(plr)
    if not plr or plr == LocalPlayer then return false end
    if LocalPlayer.Team and plr.Team and LocalPlayer.Team==plr.Team then return false end
    return true
end
function updateESP()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LocalPlayer and features.ESP and plr.Character and isEnemy(plr) and getRoot(plr) then
            if not espObjects[plr] then
                local guiObj = Instance.new("BillboardGui",gui.Main)
                guiObj.AlwaysOnTop=true guiObj.Adornee=getRoot(plr)
                guiObj.Size=UDim2.new(0,110,0,22)
                local lab=Instance.new("TextLabel",guiObj)
                lab.Size=UDim2.new(1,0,1,0)
                lab.BackgroundTransparency=1
                lab.TextColor3=Color3.fromRGB(255,0,0)
                lab.Font=Enum.Font.GothamBold
                lab.Text=plr.DisplayName
                lab.TextSize=14
                espObjects[plr]=guiObj
            else
                espObjects[plr].Adornee=getRoot(plr)
            end
        else
            if espObjects[plr] then espObjects[plr]:Destroy() espObjects[plr]=nil end
        end
    end
end
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() delay(0.2,updateESP) end) end)
Players.PlayerRemoving:Connect(function(p) if espObjects[p] then espObjects[p]:Destroy() espObjects[p]=nil end end)
RunService.RenderStepped:Connect(function() if features.ESP then updateESP() else for p,obj in pairs(espObjects) do obj:Destroy() espObjects[p]=nil end end end)

-- Fly / Noclip
local flyBV,flyBG,flyActive=false,nil,nil
function flyStart()
    if flyBV then return end
    local c=LocalPlayer.Character
    if not c or not getRoot(LocalPlayer) then return end
    flyBV=Instance.new("BodyVelocity",getRoot(LocalPlayer))
    flyBV.MaxForce=Vector3.new(1e5,1e5,1e5)*9
    flyBV.Velocity=Vector3.new()
    flyBG=Instance.new("BodyGyro",getRoot(LocalPlayer))
    flyBG.MaxTorque=Vector3.new(1e8,1e8,1e8)
    flyBG.CFrame=Camera.CFrame
end
function flyStep()
    if not flyBV or not flyBG then return end
    local cf=Camera.CFrame
    local v=Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then v=v+cf.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then v=v-cf.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then v=v-cf.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then v=v+cf.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then v=v+Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then v=v-Vector3.new(0,1,0) end
    flyBV.Velocity = (v.Magnitude>0 and v.Unit or v)*flySpeed*15
    flyBG.CFrame = Camera.CFrame
end
function flyStop()
    if flyBV then pcall(function() flyBV:Destroy() end) flyBV=nil end
    if flyBG then pcall(function() flyBG:Destroy() end) flyBG=nil end
end
RunService.RenderStepped:Connect(function() if features.Fly then if not flyBV then flyStart() end flyStep() else flyStop() end end)
RunService.Stepped:Connect(function()
    if features.Noclip then
        local c=LocalPlayer.Character
        if c then for _,prt in ipairs(c:GetDescendants()) do if prt:IsA("BasePart") then prt.CanCollide=false end end end
    end
end)

-- Teleport/Bring/Explode/Spectate
function teleportTo(plr)
    if not plr or not plr.Character then return end
    local myroot=getRoot(LocalPlayer)
    local root=getRoot(plr)
    if myroot and root then myroot.CFrame = root.CFrame + Vector3.new(0,3,0) end
end
function bringToMe(plr)
    if not plr or not plr.Character then return end
    local troot=getRoot(plr)
    local myroot=getRoot(LocalPlayer)
    if troot and myroot then troot.CFrame=myroot.CFrame+Vector3.new(0,1,0) end
end
function explodePlayer(plr)
    if not plr or not plr.Character then return end
    local root=getRoot(plr)
    if root then
        local boom=Instance.new("Explosion",workspace)
        boom.Position=root.Position
        boom.BlastRadius=7
        plr.Character:BreakJoints()
    end
end
function spectatePlayer(plr)
    if plr and plr.Character and getRoot(plr) then
        Camera.CameraSubject=plr.Character:FindFirstChildOfClass("Humanoid")
    else
        Camera.CameraSubject=LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end
end
RunService.RenderStepped:Connect(function()
    if features.Teleport and selectedPlayerForTeleport then teleportTo(selectedPlayerForTeleport) selectedPlayerForTeleport=nil features.Teleport=false end
    if features.Bring and selectedPlayerForBring then bringToMe(selectedPlayerForBring) selectedPlayerForBring=nil features.Bring=false end
    if features.Explode and selectedPlayerForExplode then explodePlayer(selectedPlayerForExplode) selectedPlayerForExplode=nil features.Explode=false end
    if features.Spectate then
        if selectedPlayerForSpectate then
            spectatePlayer(selectedPlayerForSpectate)
        end
    else
        Camera.CameraSubject=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or Camera.CameraSubject
    end
end)

-- Aimbot/SilentAim
function getClosestEnemy()
    local bestDist=fovValue
    local closest=nil
    for _,p in ipairs(Players:GetPlayers()) do
        if isEnemy(p) and p.Character and getRoot(p) and (p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health>0) then
            local s=Camera:WorldToViewportPoint(getRoot(p).Position)
            if s.Z>=0 then
                local d=(Vector2.new(s.X,s.Y)-Vector2.new(Mouse.X,Mouse.Y)).Magnitude
                if d<bestDist then bestDist=d closest=p end
            end
        end
    end
    return closest
end
function getPreferredPart(plr)
    if plr.Character:FindFirstChild("Head") then return "Head" elseif plr.Character:FindFirstChild("UpperTorso") then return "UpperTorso" end return nil
end
local silentAimTarget = nil
function performAimbot()
    if not features.Aimbot then return end
    local tgt=getClosestEnemy()
    if tgt and tgt.Character and getRoot(tgt) then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            Camera.CFrame=CFrame.lookAt(Camera.CFrame.Position,getRoot(tgt).Position)
        end
    end
end
function performSilentAim()
    if not features.SilentAim then silentAimTarget=nil return end
    local tgt=getClosestEnemy()
    if tgt and tgt.Character then
        local pn=getPreferredPart(tgt)
        if pn and tgt.Character:FindFirstChild(pn) then
            silentAimTarget = tgt.Character[pn]
        end
    end
end
RunService.RenderStepped:Connect(function()
    performAimbot()
    performSilentAim()
end)
if not getgenv().__PRO__MT_HOOKED then
    getgenv().__PRO__MT_HOOKED=true
    local raw = getrawmetatable(game)
    setreadonly(raw,false)
    local old=raw.__namecall
    raw.__namecall = function(self, ...)
        local m = getnamecallmethod()
        if features.SilentAim and tostring(m):lower()=="fire" and typeof(self)=="Instance" and self:IsA("RemoteEvent") then
            if silentAimTarget then
                local args={...}
                for i,v in pairs(args) do if typeof(v)=="Vector3" then args[i]=silentAimTarget.Position end end
                return old(self, unpack(args))
            end
        end
        if tostring(m):lower()=="kick" and self==LocalPlayer then return end
        return old(self, ...)
    end
    setreadonly(raw,true)
end

-- Ammo/Godmode/Spinbot/NoReload
function patchAmmo()
    for _,v in pairs(getgc(true)) do
        if typeof(v)=="function" and islclosure(v) and debug.getinfo(v).name then
            if tostring(debug.getinfo(v).name):lower():find("ammo") or tostring(debug.getinfo(v).name):lower():find("reload") then
                setupvalue(v,2, math.huge)
            end
        end
    end
end
function godmode()
    local c=LocalPlayer.Character
    if not c then return end
    for _,h in ipairs(c:GetDescendants()) do
        if h:IsA("Humanoid") then
            h.MaxHealth=math.huge
            h.Health=math.huge
            h:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
            h.BreakJointsOnDeath=false
        end
    end
end
RunService.RenderStepped:Connect(function() if features.NoReload then patchAmmo() end if features.Godmode then godmode() end end)
buttonRefs.Reset.MouseButton1Click:Connect(function() local c=LocalPlayer.Character if c then c:BreakJoints() end end)
buttonRefs.Rejoin.MouseButton1Click:Connect(function()
    local ts=game:GetService("TeleportService")
    ts:TeleportToPlaceInstance(game.PlaceId,game.JobId,LocalPlayer)
end)

-- Spinbot (works during fly, no aimbot interference)
RunService.RenderStepped:Connect(function(dt)
    if features.Spinbot then
        local char=LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(15),0)
        end
    end
end)

LocalPlayer.Idled:Connect(function()
    local vu = game:GetService("VirtualUser")
    vu:Button2Down(Vector2.new(0,0),Camera.CFrame)
    vu:Button2Up(Vector2.new(0,0),Camera.CFrame)
end)
Players.LocalPlayer.OnTeleport:Connect(function(State)
    if State==Enum.TeleportState.Started then if gui.Main then gui.Main:Destroy() end end
end)


