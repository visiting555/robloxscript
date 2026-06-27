if game.PlaceId~=155615604 then return end
local UIS=game:GetService("UserInputService")
local Players=game:GetService("Players")
local LocalPlayer=Players.LocalPlayer
local Character=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RepStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local RunService=game:GetService("RunService")
local Camera=Workspace.CurrentCamera

local function Notification(msg)
    pcall(function() game.StarterGui:SetCore("SendNotification",{Title="QUARTZ",Text=msg,Duration=2}) end)
end

local function GetPlayer(name)
    name=name:lower()
    for _,p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1,#name)==name then
            return p
        end
    end
end

local QuartzGUI=Instance.new("ScreenGui")
QuartzGUI.Name="QUARTZ_GUI"
QuartzGUI.Parent=game.CoreGui
QuartzGUI.ResetOnSpawn=false
local MainPanel=Instance.new("Frame")
MainPanel.Size=UDim2.new(0,350,0,500)
MainPanel.Position=UDim2.new(0.5,-175,0.5,-250)
MainPanel.BackgroundColor3=Color3.fromRGB(6,6,6)
MainPanel.BorderSizePixel=0
MainPanel.Active=true
MainPanel.Draggable=true
MainPanel.AnchorPoint=Vector2.new(0.5,0.5)
MainPanel.Parent=QuartzGUI
local Corner=Instance.new("UICorner",MainPanel)
Corner.CornerRadius=UDim.new(0,15)
local TabBar=Instance.new("Frame",MainPanel)
TabBar.Size=UDim2.new(1,0,0,48)
TabBar.BackgroundColor3=Color3.fromRGB(15,15,15)
TabBar.BorderSizePixel=0
TabBar.Position=UDim2.new(0,0,0,0)
local TabLayout=Instance.new("UIListLayout",TabBar)
TabLayout.FillDirection=Enum.FillDirection.Horizontal
TabLayout.Padding=UDim.new(0,4)
local Tabs={"Takım & Rol","Silah Mod","Hareket","ESP & Savaş","Koruma","Sunucu"}
local TabFrames={}

local function MakeSection(parent,text)
    local Section=Instance.new("Frame")
    Section.Size=UDim2.new(1,-10,0,34)
    Section.BackgroundColor3=Color3.fromRGB(25,25,25)
    Section.BorderSizePixel=0
    Section.BackgroundTransparency=0.13
    Section.Parent=parent
    local lbl=Instance.new("TextLabel",Section)
    lbl.Text="  "..text
    lbl.TextColor3=Color3.fromRGB(230,230,230)
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.BackgroundTransparency=1
    lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=21
    lbl.Size=UDim2.new(1,0,1,0)
end

local function MakeButton(parent,name,callback)
    local Btn=Instance.new("TextButton")
    Btn.Size=UDim2.new(1,-18,0,32)
    Btn.Text=name
    Btn.TextColor3=Color3.fromRGB(250,250,250)
    Btn.TextSize=18
    Btn.Font=Enum.Font.Gotham
    Btn.BackgroundColor3=Color3.fromRGB(30,30,30)
    Btn.BorderSizePixel=0
    Btn.AutoButtonColor=true
    Btn.Parent=parent
    local c1=Instance.new("UICorner",Btn)
    c1.CornerRadius=UDim.new(0,7)
    Btn.MouseButton1Click:Connect(callback)
end

local function MakeSlider(parent,text,min,max,def,callback)
    local frame=Instance.new("Frame",parent)
    frame.Size=UDim2.new(1,-18,0,36)
    frame.BackgroundColor3=Color3.fromRGB(34,34,34)
    frame.BorderSizePixel=0
    local lbl=Instance.new("TextLabel",frame)
    lbl.Text=text.." ["..def.."]"
    lbl.TextColor3=Color3.fromRGB(200,200,200)
    lbl.TextSize=16
    lbl.Font=Enum.Font.Gotham
    lbl.BackgroundTransparency=1
    lbl.Size=UDim2.new(0.65,0,1,0)
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    local slide=Instance.new("TextButton",frame)
    slide.Size=UDim2.new(0.31,0,0.78,0)
    slide.Position=UDim2.new(0.69,8,0.11,0)
    slide.Text=tostring(def)
    slide.TextColor3=Color3.fromRGB(240,240,240)
    slide.Font=Enum.Font.Gotham
    slide.BackgroundColor3=Color3.fromRGB(25,25,25)
    slide.BorderSizePixel=0
    local c1=Instance.new("UICorner",slide)
    c1.CornerRadius=UDim.new(0,6)
    slide.MouseButton1Click:Connect(function()
        local val=tonumber(game:GetService("StarterGui"):PromptInput(text.." ["..min.." - "..max.."]"))
        if val and val>=min and val<=max then
            lbl.Text=text.." ["..val.."]"
            slide.Text=tostring(val)
            callback(val)
        end
    end)
end

local function MakeTab(name)
    local frame=Instance.new("Frame")
    frame.BackgroundColor3=Color3.fromRGB(18,18,18)
    frame.Size=UDim2.new(0,330,0,435)
    frame.BorderSizePixel=0
    frame.Visible=false
    frame.Position=UDim2.new(0,10,0,58)
    frame.Parent=MainPanel
    local lbl=Instance.new("TextLabel",frame)
    lbl.Text="QUARTZ | "..name
    lbl.Size=UDim2.new(1,0,0,40)
    lbl.TextColor3=Color3.fromRGB(253,253,253)
    lbl.BackgroundColor3=Color3.fromRGB(12,12,12)
    lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=22
    lbl.BorderSizePixel=0
    local layout=Instance.new("UIListLayout",frame)
    layout.Padding=UDim.new(0,5)
    layout.SortOrder=Enum.SortOrder.LayoutOrder
    return frame
end

for idx,tabname in ipairs(Tabs) do
    local btn=Instance.new("TextButton",TabBar)
    btn.Text=tabname
    btn.Size=UDim2.new(0,105,1,0)
    btn.BackgroundColor3=Color3.fromRGB(36,36,36)
    btn.TextColor3=Color3.fromRGB(240,240,240)
    btn.Font=Enum.Font.GothamSemibold
    btn.TextSize=17
    btn.BorderSizePixel=0
    btn.AutoButtonColor=true
    local cr=Instance.new("UICorner",btn)
    cr.CornerRadius=UDim.new(0,7)
    local frame=MakeTab(tabname)
    frame.Visible=(idx==1)
    table.insert(TabFrames,frame)
    btn.MouseButton1Click:Connect(function()
        for i,tabfr in pairs(TabFrames) do
            tabfr.Visible=(i==idx)
        end
    end)
end

local EnableKey=Enum.KeyCode.RightShift
UIS.InputBegan:Connect(function(input)
    if input.KeyCode==EnableKey then
        QuartzGUI.Enabled=not QuartzGUI.Enabled
    end
end)

local tab_team=TabFrames[1]
MakeSection(tab_team,"Takım & Rol Yönetimi")
MakeButton(tab_team,"Auto Criminal",function()
    Workspace.Remote.TeamEvent:FireServer("Criminal")
    Notification("Takımınız Criminal yapıldı.")
end)
MakeButton(tab_team,"Become Guard",function()
    Workspace.Remote.TeamEvent:FireServer("Guard")
    Notification("Polis takımına geçildi.")
end)
MakeButton(tab_team,"Become Prisoner",function()
    Workspace.Remote.TeamEvent:FireServer("Prisoner")
    Notification("Mahkum olundu.")
end)
MakeButton(tab_team,"Neutral Mode",function()
    Workspace.Remote.TeamEvent:FireServer("Neutral")
    Notification("Takımsız mod aktif.")
end)
MakeButton(tab_team,"Force Inmate",function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Team.Name~="Prisoner" then
            Workspace.Remote.TeamEvent:FireServer("Prisoner",p)
        end
    end
    Notification("Tüm oyuncular Prisoner yapıldı.")
end)

local tab_weap=TabFrames[2]
MakeSection(tab_weap,"Silah Modifikasyonları")
MakeButton(tab_weap,"Give All Weapons",function()
    for _,w in pairs({"M9","Remington 870","AK-47"}) do
        Workspace.Remote.ItemHandler:InvokeServer(w)
    end
    Notification("Tüm silahlar alındı.")
end)
MakeButton(tab_weap,"Infinite Ammo",function()
    RunService.RenderStepped:Connect(function()
        local tool=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _,tbl in pairs(getgc(true)) do
                if type(tbl)=="table" and rawget(tbl,"Ammo") then
                    tbl.Ammo=999
                    tbl.MaxAmmo=999
                end
            end
        end
    end)
    Notification("Sonsuz mermi aktif.")
end)
MakeButton(tab_weap,"No Recoil",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"Recoil") then
            tbl.Recoil=0
        end
    end
    Notification("Sekme kapalı.")
end)
MakeButton(tab_weap,"No Reload",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"Reloading") then
            tbl.Reloading=false
        end
    end
    Notification("Şarjör değiştirme kaldırıldı.")
end)
MakeButton(tab_weap,"Rapid Fire",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"FireRate") then
            tbl.FireRate=0.01
        end
    end
    Notification("Hızlı ateş aktif.")
end)
MakeButton(tab_weap,"One Shot Kill",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"Damage") then
            tbl.Damage=1000
        end
    end
    Notification("One Shot Kill aktif.")
end)
MakeButton(tab_weap,"Wall Bang",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"WallPenetration") then
            tbl.WallPenetration=true
        end
    end
    Notification("Kurşunlar duvardan geçiyor.")
end)
MakeButton(tab_weap,"Infinite Range",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"Range") then
            tbl.Range=9999
        end
    end
    Notification("Silah menzili sınırsız.")
end)
MakeButton(tab_weap,"Tazer Bypass",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"IsTased") then
            tbl.IsTased=false
        end
    end
    Notification("Tazer etkisi önlendi.")
end)
MakeButton(tab_weap,"No Tazer Cooldown",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"TazerCooldown") then
            tbl.TazerCooldown=0
        end
    end
    Notification("Tazer bekleme süresi sıfır.")
end)
MakeButton(tab_weap,"Melee Reach",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"MeleeRange") then
            tbl.MeleeRange=48
        end
    end
    Notification("Yakın dövüş mesafesi arttı.")
end)
MakeButton(tab_weap,"Fast Melee",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"MeleeCooldown") then
            tbl.MeleeCooldown=0.01
        end
    end
    Notification("Hızlı bıçak/yumruk aktif.")
end)

local tab_move=TabFrames[3]
MakeSection(tab_move,"Hareket ve Karakter")
MakeButton(tab_move,"Fly",function()
    local BV=Instance.new("BodyVelocity",Character.HumanoidRootPart)
    BV.MaxForce=Vector3.new(1e5,1e5,1e5)
    while QuartzGUI.Enabled do
        BV.Velocity=Camera.CFrame.LookVector*80
        RunService.Heartbeat:Wait()
    end
    BV:Destroy()
end)
MakeSlider(tab_move,"WalkSpeed",16,300,100,function(v)
    Character.Humanoid.WalkSpeed=v
end)
MakeSlider(tab_move,"JumpPower",50,400,120,function(v)
    Character.Humanoid.JumpPower=v
end)
MakeButton(tab_move,"Infinite Jump",function()
    UIS.JumpRequest:Connect(function() Character.Humanoid:ChangeState("Jumping") end)
    Notification("Sonsuz zıplama etkin.")
end)
MakeButton(tab_move,"Noclip",function()
    RunService.Stepped:Connect(function()
        for _,v in pairs(Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide=false
            end
        end
    end)
    Notification("Noclip etkin.")
end)
MakeButton(tab_move,"Click Teleport",function()
    local mouse=LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        Character:MoveTo(mouse.Hit.Position)
    end)
    Notification("Tıkla ışınlan etkin.")
end)
MakeSlider(tab_move,"Vehicle Speed",50,800,350,function(v)
    for _,car in pairs(Workspace:FindFirstChild("Vehicles") and Workspace.Vehicles:GetChildren() or {}) do
        if car:FindFirstChild("Engine") then
            car.Engine.Speed.Value=v
        end
    end
end)
MakeButton(tab_move,"No Car Clip",function()
    for _,car in pairs(Workspace:FindFirstChild("Vehicles") and Workspace.Vehicles:GetChildren() or {}) do
        for _,part in pairs(car:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide=false end
        end
    end
    Notification("Arabalar engellerin içinden geçebiliyor.")
end)
MakeButton(tab_move,"Infinite Stamina",function()
    if Character and Character:FindFirstChild("Humanoid") then
        Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            Character.Humanoid.WalkSpeed=100
        end)
    end
    Notification("Sonsuz stamina aktif.")
end)
MakeButton(tab_move,"Anti-Ragdoll",function()
    Character.Humanoid.StateChanged:Connect(function(_,state)
        if state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll then
            Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
    Notification("Anti-ragdoll aktif.")
end)

local tab_esp=TabFrames[4]
MakeSection(tab_esp,"ESP & Savaş")
MakeButton(tab_esp,"Aimbot",function()
    RunService.RenderStepped:Connect(function()
        local nearest,dist=nil,99999
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Team~=LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                local d=(Camera.CFrame.Position-p.Character.Head.Position).magnitude
                if d<dist then
                    dist=d
                    nearest=p.Character.Head
                end
            end
        end
        if nearest then
            Camera.CFrame=CFrame.new(Camera.CFrame.Position,nearest.Position)
        end
    end)
    Notification("Aimbot aktif.")
end)
MakeButton(tab_esp,"Silent Aim",function()
    getgenv().QUARTZ_SILENTAIM=true
    Notification("Silent aim aktif.")
end)
MakeButton(tab_esp,"Player ESP",function()
    RunService.RenderStepped:Connect(function()
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                if not p.Character.Head:FindFirstChild("PLR_ESP") then
                    local bg=Instance.new("BillboardGui",p.Character.Head)
                    bg.Name="PLR_ESP"
                    bg.Size=UDim2.new(0,140,0,34)
                    bg.AlwaysOnTop=true
                    local tl=Instance.new("TextLabel",bg)
                    tl.Size=UDim2.new(1,0,1,0)
                    tl.BackgroundTransparency=1
                    tl.Text=p.Name.." | "..math.floor((p.Character.HumanoidRootPart.Position-Character.HumanoidRootPart.Position).magnitude)
                    tl.TextStrokeTransparency=0.8
                    tl.TextColor3=Color3.fromRGB(255,240,6)
                    tl.Font=Enum.Font.GothamSemibold
                    tl.TextSize=14
                end
            end
        end
    end)
    Notification("Player ESP aktif.")
end)
MakeButton(tab_esp,"Line ESP (Tracers)",function()
    RunService.RenderStepped:Connect(function()
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                if not p.Character.Head:FindFirstChild("TRC_ESP") then
                    local att0=Instance.new("Attachment",Camera)
                    local att1=Instance.new("Attachment",p.Character.Head)
                    local beam=Instance.new("Beam",p.Character.Head)
                    beam.Attachment0=att0
                    beam.Attachment1=att1
                    beam.Color=ColorSequence.new(Color3.fromRGB(250,30,40))
                    beam.Width0=0.1
                    beam.Width1=0.1
                    beam.FaceCamera=true
                    beam.Name="TRC_ESP"
                end
            end
        end
    end)
    Notification("Tracer (Line ESP) aktif.")
end)
MakeButton(tab_esp,"Box ESP",function()
    RunService.RenderStepped:Connect(function()
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if not p.Character.HumanoidRootPart:FindFirstChild("BOX_ESP") then
                    local bx=Instance.new("BoxHandleAdornment",p.Character.HumanoidRootPart)
                    bx.Adornee=p.Character.HumanoidRootPart
                    bx.Size=Vector3.new(5,7,3)
                    bx.Color3=Color3.fromRGB(18,255,60)
                    bx.AlwaysOnTop=true
                    bx.Name="BOX_ESP"
                    bx.Transparency=0.6
                end
            end
        end
    end)
    Notification("Box ESP aktif.")
end)
MakeButton(tab_esp,"Item ESP",function()
    RunService.RenderStepped:Connect(function()
        for _,item in pairs(Workspace:FindFirstChild("Prison_ITEMS") and Workspace.Prison_ITEMS.single:GetChildren() or {}) do
            if item:IsA("Part") and not item:FindFirstChild("ITEM_ESP") then
                local bc=Instance.new("BillboardGui",item)
                bc.Name="ITEM_ESP"
                bc.Size=UDim2.new(0,85,0,24)
                bc.AlwaysOnTop=true
                local tx=Instance.new("TextLabel",bc)
                tx.Size=UDim2.new(1,0,1,0)
                tx.Text=item.Name
                tx.BackgroundTransparency=1
                tx.TextColor3=Color3.fromRGB(80,255,240)
                tx.Font=Enum.Font.GothamSemibold
                tx.TextSize=14
            end
        end
    end)
    Notification("Eşya ESP aktif.")
end)
MakeButton(tab_esp,"Kill All",function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Team~=LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.Health=0
        end
    end
    Notification("Düşmanlar öldürüldü.")
end)
MakeButton(tab_esp,"Kill Aura",function()
    RunService.RenderStepped:Connect(function()
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Team~=LocalPlayer.Team and p.Character and (p.Character.HumanoidRootPart.Position-Character.HumanoidRootPart.Position).magnitude<17 then
                if p.Character:FindFirstChild("Humanoid") then p.Character.Humanoid.Health=0 end
            end
        end
    end)
    Notification("Kill Aura aktif.")
end)
MakeButton(tab_esp,"Auto Arrest All",function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Team.Name=="Criminal" and p.Character and p.Character:FindFirstChild("Head") then
            Workspace.Remote.arrest:InvokeServer(p.Character.Head)
        end
    end
    Notification("Tüm suçlular içeri atıldı.")
end)
MakeButton(tab_esp,"Arrest Range Multiplier",function()
    for _,tbl in pairs(getgc(true)) do
        if type(tbl)=="table" and rawget(tbl,"ArrestRange") then
            tbl.ArrestRange=5000
        end
    end
    Notification("Kelepçe menzili arttı.")
end)

local tab_def=TabFrames[5]
MakeSection(tab_def,"Defans ve Guard")
MakeButton(tab_def,"God Mode",function()
    Character.Humanoid.Health=math.huge
    Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        Character.Humanoid.Health=math.huge
    end)
    Notification("Ölümsüz oldunuz.")
end)
MakeButton(tab_def,"Semi-God Mode",function()
    Character.Humanoid.HealthChanged:Connect(function()
        Character.Humanoid.Health=Character.Humanoid.MaxHealth
    end)
    Notification("Semi-god aktif.")
end)
MakeButton(tab_def,"Anti-Arrest",function()
    LocalPlayer.PlayerGui.ChildAdded:Connect(function(c)
        if c.Name=="ArrestGui" then c:Destroy() end
    end)
    Notification("Anti-arrest aktif.")
end)
MakeButton(tab_def,"Give Keycard",function()
    Workspace.Remote.ItemHandler:InvokeServer("Key card")
    Notification("Keycard alındı.")
end)
MakeButton(tab_def,"Auto Escape",function()
    if Workspace:FindFirstChild("Criminals") and Workspace.Criminals:FindFirstChild("SpawnLocation") then
        Character:MoveTo(Workspace.Criminals.SpawnLocation.Position)
    end
    Notification("Kaçış başarılı!")
end)

local tab_srv=TabFrames[6]
MakeSection(tab_srv,"Sunucu/Fun/Trol")
MakeButton(tab_srv,"Spinbot",function()
    RunService.RenderStepped:Connect(function()
        pcall(function()
            Character:SetPrimaryPartCFrame(Character.PrimaryPart.CFrame*CFrame.Angles(0,math.rad(42),0))
        end)
    end)
    Notification("Spinbot aktif.")
end)
MakeButton(tab_srv,"Invisible",function()
    pcall(function()
        Character.HumanoidRootPart.Transparency=1
        for _,part in pairs(Character:GetChildren()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then part.Transparency=1 end
        end
    end)
    Notification("Görünmezlik aktif.")
end)
MakeButton(tab_srv,"Loop Kill Target",function()
    local pname=game:GetService("StarterGui"):PromptInput("Öldürülecek oyuncunun adını yaz:")
    local tgt=GetPlayer(pname)
    if tgt and tgt.Character and tgt.Character:FindFirstChild("Humanoid") then
        RunService.Stepped:Connect(function()
            if tgt.Character:FindFirstChild("Humanoid") and tgt.Character.Humanoid.Health>0 then
                tgt.Character.Humanoid.Health=0
            end
        end)
        Notification(pname.." öldürülüyor - loop.")
    end
end)
MakeButton(tab_srv,"Bring All Players",function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character:MoveTo(Character.HumanoidRootPart.Position+Vector3.new(math.random(-7,7),0,math.random(-7,7)))
        end
    end
    Notification("Tüm oyuncular getirildi.")
end)
MakeButton(tab_srv,"Teleport To Locations",function()
    local locs={
        ["Silah Odası"]=Workspace:FindFirstChild("GunRoom") and Workspace.GunRoom:FindFirstChild("Guns") and Workspace.GunRoom.Guns.Position or nil,
        ["Bahçe"]=Workspace:FindFirstChild("Yard") and Workspace.Yard:FindFirstChild("Yard_Stuff") and Workspace.Yard.Yard_Stuff.Position or nil,
        ["Crim Base"]=Workspace:FindFirstChild("Criminals") and Workspace.Criminals:FindFirstChild("SpawnLocation") and Workspace.Criminals.SpawnLocation.Position or nil,
        ["Hücreler"]=Workspace:FindFirstChild("Cells") and Workspace.Cells:FindFirstChild("Cells") and Workspace.Cells.Cells.Position or nil
    }
    local pick=game:GetService("StarterGui"):PromptInput("Konum adı (Silah Odası, Bahçe, Crim Base, Hücreler):")
    if pick and locs[pick] then
        Character:MoveTo(locs[pick])
        Notification(pick.." konumuna ışınlandınız.")
    end
end)
MakeButton(tab_srv,"Chat Spammer",function()
    local msg=game:GetService("StarterGui"):PromptInput("Mesajı girin:")
    spawn(function()
        while QuartzGUI.Enabled do
            pcall(function()
                Workspace.Remote.SendMessage:FireServer(msg)
            end)
            task.wait(0.06)
        end
    end)
end)
MakeButton(tab_srv,"Crash Server (Lag Switch)",function()
    for i=1,750 do
        Workspace.Remote.TeamEvent:FireServer("Neutral")
        task.wait()
    end
    Notification("Sunucu lag/crash denemesi uygulandı.")
end)
MakeButton(tab_srv,"Server View (Spectate)",function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject=p.Character.Humanoid
            Notification(p.Name.." izleniyor.")
            break
        end
    end
end)

Notification("QUARTZ.LUA yüklendi. Menü: RightShift")
