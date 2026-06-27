local sg=Instance.new("ScreenGui")sg.Parent=game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")or game:GetService("Players").LocalPlayer.PlayerGui
local mf=Instance.new("Frame")mf.Size=UDim2.new(0,540,0,540)mf.Position=UDim2.new(0.35,0,0.2,0)mf.BackgroundColor3=Color3.fromRGB(18,20,32)mf.Parent=sg mf.BorderSizePixel=0 local mc=Instance.new("UICorner",mf)mc.CornerRadius=UDim.new(0,20)
mf.Active=true;mf.Draggable=true

local header=Instance.new("Frame",mf)header.Size=UDim2.new(1,0,0,50)header.Position=UDim2.new(0,0,0,0)header.BackgroundColor3=Color3.fromRGB(23,33,55)header.BorderSizePixel=0 local hcr=Instance.new("UICorner",header)hcr.CornerRadius=UDim.new(0,20)

local t=Instance.new("TextLabel",header)t.Size=UDim2.new(1,0,1,0)t.BackgroundTransparency=1 t.Text="EĞİTİM HİLE MENÜ"t.TextColor3=Color3.fromRGB(86,190,255)t.Font=Enum.Font.GothamBlack t.TextScaled=true

local cbtn=Instance.new("TextButton",header)cbtn.Size=UDim2.new(0,40,0,40)cbtn.Position=UDim2.new(1,-48,0,5)cbtn.BackgroundColor3=Color3.fromRGB(255,74,74)cbtn.Text="X"cbtn.Font=Enum.Font.GothamBold cbtn.TextColor3=Color3.new(1,1,1)cbtn.TextScaled=true local cbcr=Instance.new("UICorner",cbtn)cbcr.CornerRadius=UDim.new(0,15)
cbtn.ZIndex=99
cbtn.MouseButton1Click:Connect(function()sg:Destroy()end)

local controls=Instance.new("Frame",mf)controls.Size=UDim2.new(0,210,1,-58)controls.Position=UDim2.new(0,0,0,54)controls.BackgroundColor3=Color3.fromRGB(28,32,48)controls.BorderSizePixel=0 local lcr=Instance.new("UICorner",controls)lcr.CornerRadius=UDim.new(0,15)controls.ZIndex=2
local clayout=Instance.new("UIListLayout",controls)clayout.SortOrder=Enum.SortOrder.LayoutOrder clayout.Padding=UDim.new(0,18)clayout.HorizontalAlignment=Enum.HorizontalAlignment.Center clayout.VerticalAlignment=Enum.VerticalAlignment.Top
clayout.FillDirection=Enum.FillDirection.Vertical

for _,v in pairs(controls:GetChildren()) do if v:IsA("TextButton") or v:IsA("Frame") then v:Destroy() end end

local function mkbtn(txt,icol,ht)
    local b=Instance.new("TextButton")b.Parent=controls
    b.Size=UDim2.new(0.92,0,0,ht or 40)
    b.BackgroundColor3=icol or Color3.fromRGB(40,40,54)
    b.Text=txt b.TextColor3=Color3.fromRGB(243,243,243)
    b.Font=Enum.Font.GothamBold b.TextScaled=true
    local c=Instance.new("UICorner",b)c.CornerRadius=UDim.new(0,14)
    b.AutoButtonColor=true b.Active=true b.Selectable=true
    return b
end

local aimb=mkbtn("AIMBOT",Color3.fromRGB(50,149,255))
local spinb=mkbtn("SPINBOT",Color3.fromRGB(60,77,183))
local flyb=mkbtn("FLY",Color3.fromRGB(185,140,29))
local noclipb=mkbtn("NOCLIP",Color3.fromRGB(127,57,175))
local gmb=mkbtn("GODMODE",Color3.fromRGB(70,185,86))

local playersbox=Instance.new("Frame",mf)playersbox.Size=UDim2.new(1,-210,1,-54)playersbox.Position=UDim2.new(0,210,0,54)playersbox.BackgroundColor3=Color3.fromRGB(37,43,68)playersbox.BorderSizePixel=0
local pbcr=Instance.new("UICorner",playersbox)pbcr.CornerRadius=UDim.new(0,15)
playersbox.Active=true playersbox.Selectable=true playersbox.ZIndex=2

local headerpl=Instance.new("TextLabel",playersbox)headerpl.Size=UDim2.new(1,0,0,28)headerpl.Position=UDim2.new(0,0,0,0)headerpl.Text="TP Oyuncu Listesi"headerpl.Font=Enum.Font.GothamBold headerpl.TextColor3=Color3.fromRGB(156,148,250)headerpl.TextScaled=true headerpl.BackgroundTransparency=1 
local scroll=Instance.new("ScrollingFrame",playersbox)scroll.Size=UDim2.new(1,-14,0,320)scroll.Position=UDim2.new(0,7,0,32)scroll.CanvasSize=UDim2.new(0,0,0,0)scroll.ScrollBarThickness=8 scroll.BackgroundTransparency=1 scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y scroll.BorderSizePixel=0 scroll.Active=true scroll.Selectable=true
scroll.ScrollingDirection=Enum.ScrollingDirection.Y
local scrollLayout=Instance.new("UIListLayout",scroll)scrollLayout.SortOrder=Enum.SortOrder.LayoutOrder scrollLayout.Padding=UDim.new(0,10)

local tplbl=Instance.new("TextLabel",playersbox)tplbl.Size=UDim2.new(1,0,0,22)tplbl.Position=UDim2.new(0,0,0,360)tplbl.BackgroundTransparency=1 tplbl.Font=Enum.Font.Gotham tplbl.TextScaled=true tplbl.TextColor3=Color3.fromRGB(255,223,57)tplbl.Text="Seçili: Yok"
local tpb=Instance.new("TextButton",playersbox)tpb.Size=UDim2.new(0.65,0,0,40)tpb.Position=UDim2.new(0.175,0,0,390)tpb.BackgroundColor3=Color3.fromRGB(49,82,255)
tpb.Text="SEÇİLENİ TP AT" tpb.TextColor3=Color3.fromRGB(255,255,255)tpb.Font=Enum.Font.GothamBold tpb.TextScaled=true local tpcr=Instance.new("UICorner",tpb)tpcr.CornerRadius=UDim.new(0,13)

local pl=game.Players.LocalPlayer
local tplsel=nil
local function refreshList()
    for _,v in ipairs(scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end tplsel=nil tplbl.Text="Seçili: Yok"
    local allPlayers={}
    for _,v in ipairs(game.Players:GetPlayers()) do if v and v:IsA("Player") and v~=pl then table.insert(allPlayers, v) end end
    table.sort(allPlayers,function(a,b) return string.lower(a.Name)<string.lower(b.Name)end)
    for _,v in ipairs(allPlayers) do
        local btn=Instance.new("TextButton",scroll)btn.Size=UDim2.new(1,0,0,28)
        btn.BackgroundColor3=Color3.fromRGB(64,113,189)
        btn.Text=v.Name btn.Font=Enum.Font.Gotham btn.TextColor3=Color3.new(1,1,1)btn.TextScaled=true btn.AutoButtonColor=true btn.Active=true btn.Selectable=true
        local lco=Instance.new("UICorner",btn)lco.CornerRadius=UDim.new(0,8)
        btn.MouseButton1Click:Connect(function()
            tplsel=v
            for _,b in pairs(scroll:GetChildren()) do if b:IsA("TextButton") then b.BackgroundColor3=Color3.fromRGB(64,113,189)end end
            btn.BackgroundColor3=Color3.fromRGB(245,195,65)
            tplbl.Text="Seçili: "..v.Name
        end)
    end
end
refreshList()
game.Players.PlayerAdded:Connect(refreshList)
game.Players.PlayerRemoving:Connect(refreshList)
scroll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()scroll.CanvasSize=UDim2.new(0,0,0,scrollLayout.AbsoluteContentSize.Y)end)

local aimbotOn=false local abConn
local function closest()
    local m=pl:GetMouse()local s=math.huge local cl=nil
    for _,v in ipairs(game.Players:GetPlayers())do
        if v~=pl and v.Character and v.Character:FindFirstChild("Head")then
            local p,os=workspace.CurrentCamera:WorldToScreenPoint(v.Character.Head.Position)
            if os then local dst=(Vector2.new(p.X,p.Y)-Vector2.new(m.X,m.Y)).Magnitude
                if dst<s then s=dst cl=v end
            end
        end
    end
    return cl
end
local function aimAt(tgt)
    local cam=workspace.CurrentCamera
    if tgt and tgt.Character and tgt.Character:FindFirstChild("Head")then cam.CFrame=CFrame.new(cam.CFrame.Position,tgt.Character.Head.Position)end
end
local function enableAimbot()
    if abConn then abConn:Disconnect()end
    abConn=game:GetService("RunService").RenderStepped:Connect(function()
        if aimbotOn then local t=closest()if t then aimAt(t)end end
    end)
end
local function disableAimbot()if abConn then abConn:Disconnect()abConn=nil end end

aimb.MouseButton1Click:Connect(function()
    aimbotOn=not aimbotOn if aimbotOn then aimb.Text="AIMBOT KAPAT" enableAimbot() else aimb.Text="AIMBOT"disableAimbot()end
end)

local sbOn=false local sbConn
local function enableSpinbot()
    if sbConn then sbConn:Disconnect()end
    sbConn=game:GetService("RunService").Heartbeat:Connect(function()
        if sbOn and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")then
            pl.Character.HumanoidRootPart.CFrame=pl.Character.HumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(45),0)
        end
    end)
end
local function disableSpinbot()if sbConn then sbConn:Disconnect()sbConn=nil end end
spinb.MouseButton1Click:Connect(function()
    sbOn=not sbOn if sbOn then spinb.Text="SPINBOT KAPAT"enableSpinbot()else spinb.Text="SPINBOT"disableSpinbot()end
end)

local flyOn=false local flyConn
local function enableFly()
    if flyConn then flyConn:Disconnect()end flyOn=true
    local ch=pl.Character if not ch or not ch:FindFirstChild("HumanoidRootPart")then return end
    local hrp=ch.HumanoidRootPart
    local bv=hrp:FindFirstChildOfClass("BodyVelocity") or Instance.new("BodyVelocity",hrp)bv.MaxForce=Vector3.new(1e5,1e5,1e5)
    local uis=game:GetService("UserInputService")
    flyConn=game:GetService("RunService").Heartbeat:Connect(function()
        if not flyOn or not ch:FindFirstChild("HumanoidRootPart")then if bv and bv.Parent then bv:Destroy()end flyConn:Disconnect()flyConn=nil return end
        local f=Vector3.new()
        if uis:IsKeyDown(Enum.KeyCode.W)then f=f+workspace.CurrentCamera.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S)then f=f-workspace.CurrentCamera.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A)then f=f-workspace.CurrentCamera.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D)then f=f+workspace.CurrentCamera.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.Space)then f=f+Vector3.new(0,1,0)end
        if uis:IsKeyDown(Enum.KeyCode.LeftShift)then f=f-Vector3.new(0,1,0)end
        if f.Magnitude>0 then bv.Velocity=f.Unit*54 else bv.Velocity=Vector3.new()end
    end)
end
local function disableFly()flyOn=false if flyConn then flyConn:Disconnect()flyConn=nil end local hrp=pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")if hrp then for _,v in ipairs(hrp:GetChildren())do if v:IsA("BodyVelocity")then v:Destroy()end end end end
flyb.MouseButton1Click:Connect(function()
    flyOn=not flyOn if flyOn then flyb.Text="FLY KAPAT" enableFly() else flyb.Text="FLY"disableFly()end
end)
game:GetService("RunService").Heartbeat:Connect(function()
    if sbOn and (flyOn or not flyOn) and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")then
        pl.Character.HumanoidRootPart.CFrame=pl.Character.HumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(45),0)
    end
end)

local ncOn=false local ncConn
local function enableNoclip()
    ncOn=true
    if ncConn then ncConn:Disconnect()end
    ncConn=game:GetService("RunService").Stepped:Connect(function(_,s)
        if ncOn and pl.Character then
            for _,p in pairs(pl.Character:GetDescendants())do
                if p:IsA("BasePart")then p.CanCollide=false end
            end
        end
    end)
end
local function disableNoclip()
    ncOn=false
    if ncConn then ncConn:Disconnect()ncConn=nil end
    local c=pl.Character
    if c then
        for _,p in pairs(c:GetDescendants())do
            if p:IsA("BasePart")then p.CanCollide=true end
        end
    end
end
noclipb.MouseButton1Click:Connect(function()
    ncOn=not ncOn if ncOn then noclipb.Text="NOCLIP KAPAT"enableNoclip()else noclipb.Text="NOCLIP"disableNoclip()end
end)

local gmOn=false local gmConns={} local orgWlkSpd,orgJump,orgHp
local function enableGodmode()
    gmOn=true
    local c=pl.Character
    if not c or not c:FindFirstChild("Humanoid")then return end
    local h=c:FindFirstChild("Humanoid")
    orgWlkSpd=h.WalkSpeed orgJump=h.JumpPower orgHp=h.MaxHealth
    pcall(function()h.MaxHealth=9e9 h.Health=9e9 h.WalkSpeed=200 h.JumpPower=200 end)
    if gmConns["death"] then gmConns["death"]:Disconnect()end
    gmConns["death"]=h.Died:Connect(function()
        task.wait(0.35)
        if gmOn then
            local ch=pl.Character repeat task.wait() until ch and ch:FindFirstChild("Humanoid")
            orgWlkSpd=16 orgJump=50 orgHp=100
            enableGodmode()
        end
    end)
    if gmConns["takingdmg"] then gmConns["takingdmg"]:Disconnect()end
    gmConns["takingdmg"]=h:GetPropertyChangedSignal("Health"):Connect(function()
        if h.Health<h.MaxHealth then h.Health=h.MaxHealth end
    end)
end
local function disableGodmode()
    gmOn=false
    if gmConns["death"] then gmConns["death"]:Disconnect()gmConns["death"]=nil end
    if gmConns["takingdmg"] then gmConns["takingdmg"]:Disconnect()gmConns["takingdmg"]=nil end
    local c=pl.Character
    if c and c:FindFirstChild("Humanoid")then
        local h=c.Humanoid
        pcall(function()
            if orgWlkSpd then h.WalkSpeed=orgWlkSpd end
            if orgJump then h.JumpPower=orgJump end
            if orgHp then h.MaxHealth=orgHp end
        end)
    end
end
gmb.MouseButton1Click:Connect(function()
    gmOn=not gmOn if gmOn then gmb.Text="GODMODE KAPAT"enableGodmode()else gmb.Text="GODMODE"disableGodmode()end
end)

tpb.MouseButton1Click:Connect(function()
    if tplsel and tplsel.Character and tplsel.Character:FindFirstChild("HumanoidRootPart")then
        local ch=pl.Character if ch and ch:FindFirstChild("HumanoidRootPart")then ch.HumanoidRootPart.CFrame=tplsel.Character.HumanoidRootPart.CFrame+Vector3.new(2,1,0)end
    end
end)

aimb.Visible=true spinb.Visible=true flyb.Visible=true noclipb.Visible=true gmb.Visible=true tpb.Visible=true tplbl.Visible=true controls.Visible=true playersbox.Visible=true header.Visible=true t.Visible=true
controls.Visible=true
playersbox.Visible=true
header.Visible=true
t.Visible=true
-- Fonksiyonlar otomatik gözüksün ve başlatılsın
aimb.AutoButtonColor=true spinb.AutoButtonColor=true flyb.AutoButtonColor=true noclipb.AutoButtonColor=true gmb.AutoButtonColor=true tpb.AutoButtonColor=true
for _,v in ipairs({aimb,spinb,flyb,noclipb,gmb,tpb})do v.Active=true v.Selectable=true end
controls.Active=true controls.Selectable=true playersbox.Active=true playersbox.Selectable=true
-- Hile başlat: visible ve fonksiyonlar
aimb.Visible=true spinb.Visible=true flyb.Visible=true noclipb.Visible=true gmb.Visible=true tpb.Visible=true tplbl.Visible=true
-- Menü animasyonu
mf.Visible=true sg.Enabled=true
