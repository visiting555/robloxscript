local sg=Instance.new("ScreenGui")sg.Parent=game:GetService("Players").LocalPlayer.PlayerGui
local mf=Instance.new("Frame")mf.Size=UDim2.new(0,500,0,480)mf.Position=UDim2.new(0.35,0,0.22,0)mf.BackgroundColor3=Color3.fromRGB(17,23,37)mf.Parent=sg mf.BorderSizePixel=0 local mc=Instance.new("UICorner",mf)mc.CornerRadius=UDim.new(0,18)
mf.Active=true;mf.Draggable=true

local header=Instance.new("Frame",mf)header.Size=UDim2.new(1,0,0,55)header.Position=UDim2.new(0,0,0,0)header.BackgroundColor3=Color3.fromRGB(20,30,45)header.BorderSizePixel=0 local hcr=Instance.new("UICorner",header)hcr.CornerRadius=UDim.new(0,18)

local t=Instance.new("TextLabel",header)t.Size=UDim2.new(1,0,1,0)t.BackgroundTransparency=1 t.Text="EĞİTİM HİLE MENÜ"t.TextColor3=Color3.fromRGB(86,190,255)t.Font=Enum.Font.GothamBlack t.TextScaled=true

local cbtn=Instance.new("TextButton",header)cbtn.Size=UDim2.new(0,40,0,40)cbtn.Position=UDim2.new(1,-48,0,8)cbtn.BackgroundColor3=Color3.fromRGB(255,75,75)cbtn.Text="X"cbtn.Font=Enum.Font.GothamBold cbtn.TextColor3=Color3.new(1,1,1)cbtn.TextScaled=true local cbcr=Instance.new("UICorner",cbtn)cbcr.CornerRadius=UDim.new(0,14)
cbtn.ZIndex=5
cbtn.MouseButton1Click:Connect(function()sg:Destroy()end)

local left=Instance.new("Frame",mf)left.Size=UDim2.new(0,178,1,-55)left.Position=UDim2.new(0,0,0,55)left.BackgroundColor3=Color3.fromRGB(23,29,44)left.BorderSizePixel=0 left.Active=true left.Selectable=true local lcr=Instance.new("UICorner",left)lcr.CornerRadius=UDim.new(0,13)
left.ZIndex=2
local layout=Instance.new("UIListLayout",left)layout.SortOrder=Enum.SortOrder.LayoutOrder layout.Padding=UDim.new(0,14)layout.HorizontalAlignment=Enum.HorizontalAlignment.Center layout.VerticalAlignment=Enum.VerticalAlignment.Top

local right=Instance.new("Frame",mf)right.Size=UDim2.new(1,-178,1,-55)right.Position=UDim2.new(0,178,0,55)right.BackgroundTransparency=1 right.Active=true right.Selectable=true right.ZIndex=2

local tpheader=Instance.new("TextLabel",right)tpheader.Size=UDim2.new(1,0,0,26)tpheader.Position=UDim2.new(0,0,0,0)tpheader.Text="Oyuncu Listesi"tpheader.Font=Enum.Font.GothamBold tpheader.TextColor3=Color3.fromRGB(156,148,250)tpheader.TextScaled=true tpheader.BackgroundTransparency=1 
local dlist=Instance.new("Frame",right)dlist.Size=UDim2.new(1,0,0,280)dlist.Position=UDim2.new(0,0,0,32)dlist.BackgroundColor3=Color3.fromRGB(37,43,68)dlist.Active=true dlist.Selectable=true
local dcr=Instance.new("UICorner",dlist)dcr.CornerRadius=UDim.new(0,11)
local lst=Instance.new("ScrollingFrame",dlist)lst.Size=UDim2.new(1,-6,1,0)lst.Position=UDim2.new(0,3,0,0)lst.CanvasSize=UDim2.new(0,0,0,0)lst.ScrollBarThickness=8 lst.BackgroundTransparency=1 lst.AutomaticCanvasSize=Enum.AutomaticSize.Y lst.BorderSizePixel=0 lst.Active=true lst.Selectable=true
local layout2=Instance.new("UIListLayout",lst)layout2.SortOrder=Enum.SortOrder.LayoutOrder layout2.Padding=UDim.new(0,8)
local tplbl=Instance.new("TextLabel",right)tplbl.Size=UDim2.new(1,0,0,24)tplbl.Position=UDim2.new(0,0,0,322)tplbl.BackgroundTransparency=1 tplbl.Font=Enum.Font.Gotham tplbl.TextScaled=true tplbl.TextColor3=Color3.fromRGB(255,223,57)tplbl.Text="Seçili: Yok"
local tpb=Instance.new("TextButton",right)tpb.Size=UDim2.new(0.68,0,0,39)tpb.Position=UDim2.new(0.16,0,0,360)tpb.BackgroundColor3=Color3.fromRGB(49,82,255)
tpb.Text="SEÇİLENİ TP AT" tpb.TextColor3=Color3.fromRGB(255,255,255)tpb.Font=Enum.Font.GothamBold tpb.TextScaled=true local tpcr=Instance.new("UICorner",tpb)tpcr.CornerRadius=UDim.new(0,11)

local sep=Instance.new("Frame",left)sep.Size=UDim2.new(0.85,0,0,1)sep.BackgroundColor3=Color3.fromRGB(43,47,65)sep.LayoutOrder=0 sep.BorderSizePixel=0

local function mkbtn(txt,icol,ht,lorder)
    local b=Instance.new("TextButton")b.Parent=left
    b.Size=UDim2.new(0.92,0,0,ht or 38)
    b.BackgroundColor3=icol or Color3.fromRGB(37,40,54)
    b.Text=txt b.TextColor3=Color3.fromRGB(243,243,243)
    b.Font=Enum.Font.GothamBold b.TextScaled=true
    local c=Instance.new("UICorner",b)c.CornerRadius=UDim.new(0,14)
    b.AutoButtonColor=true
    if lorder then b.LayoutOrder=lorder end
    return b
end

local aimb=mkbtn("AIMBOT",Color3.fromRGB(30,135,255),38,1)
local spinb=mkbtn("SPINBOT",Color3.fromRGB(60,77,183),38,2)
local flyb=mkbtn("FLY",Color3.fromRGB(185,140,29),38,3)
local noclipb=mkbtn("NOCLIP",Color3.fromRGB(127,57,175),38,4)
local gmb=mkbtn("GODMODE",Color3.fromRGB(70,185,86),38,5)

local pl=game.Players.LocalPlayer
local tplsel=nil
function mklist()
    for _,v in ipairs(lst:GetChildren())do if v:IsA("TextButton")then v:Destroy()end end tplsel=nil tplbl.Text="Seçili: Yok"
    local allPlayers = {}
    for _,v in pairs(game.Players:GetPlayers())do
        if v and v:IsA("Player") and v ~= pl then table.insert(allPlayers,v) end
    end
    table.sort(allPlayers,function(a,b) return a.Name:lower()<b.Name:lower()end)
    for _,v in ipairs(allPlayers)do
        local li=Instance.new("TextButton",lst)li.Size=UDim2.new(1,0,0,31)
        li.BackgroundColor3=Color3.fromRGB(64,113,189)
        li.Text=v.Name li.Font=Enum.Font.Gotham li.TextColor3=Color3.new(1,1,1)li.TextScaled=true li.AutoButtonColor=true
        local lco=Instance.new("UICorner",li)lco.CornerRadius=UDim.new(0,8)
        li.MouseButton1Click:Connect(function()
            tplsel=v
            for _,b in pairs(lst:GetChildren())do if b:IsA("TextButton")then b.BackgroundColor3=Color3.fromRGB(64,113,189)end end
            li.BackgroundColor3=Color3.fromRGB(255,195,85)
            tplbl.Text="Seçili: "..v.Name
        end)
    end
end
mklist()
game.Players.PlayerAdded:Connect(function()mklist()end)
game.Players.PlayerRemoving:Connect(function(rem)mklist()if tplsel==rem then tplsel=nil tplbl.Text="Seçili: Yok"end end)
lst:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    lst.CanvasSize = UDim2.new(0,0,0,lst.UIListLayout and lst.UIListLayout.AbsoluteContentSize.Y or 0)
end)

local aimbotOn=false local abConn
function closest()
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
function aimAt(t)
    local cam=workspace.CurrentCamera
    if t and t.Character and t.Character:FindFirstChild("Head")then cam.CFrame=CFrame.new(cam.CFrame.Position,t.Character.Head.Position)end
end
function enableAimbot()
    if abConn then abConn:Disconnect()end
    abConn=game:GetService("RunService").RenderStepped:Connect(function()
        if aimbotOn then local t=closest()if t then aimAt(t)end end
    end)
end
function disableAimbot()if abConn then abConn:Disconnect()abConn=nil end end
aimb.MouseButton1Click:Connect(function()
    aimbotOn=not aimbotOn if aimbotOn then aimb.Text="AIMBOT KAPAT" enableAimbot() else aimb.Text="AIMBOT"disableAimbot()end
end)
local sbOn=false local sbConn
function enableSpinbot()
    if sbConn then sbConn:Disconnect()end
    sbConn=game:GetService("RunService").Heartbeat:Connect(function()
        if sbOn and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")then
            pl.Character.HumanoidRootPart.CFrame=pl.Character.HumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(45),0)
        end
    end)
end
function disableSpinbot()if sbConn then sbConn:Disconnect()sbConn=nil end end
spinb.MouseButton1Click:Connect(function()
    sbOn=not sbOn if sbOn then spinb.Text="SPINBOT KAPAT"enableSpinbot()else spinb.Text="SPINBOT"disableSpinbot()end
end)
game:GetService("RunService").Heartbeat:Connect(function()
    if sbOn and flyOn and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")then
        pl.Character.HumanoidRootPart.CFrame=pl.Character.HumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(45),0)
    end
end)
local flyOn=false local flyConn
function enableFly()
    if flyConn then flyConn:Disconnect()end flyOn=true
    local ch=pl.Character if not ch or not ch:FindFirstChild("HumanoidRootPart")then return end
    local hrp=ch.HumanoidRootPart
    local bv=hrp:FindFirstChildOfClass("BodyVelocity") or Instance.new("BodyVelocity",hrp)bv.MaxForce=Vector3.new(1e5,1e5,1e5)
    local uis=game:GetService("UserInputService")
    flyConn=game:GetService("RunService").Heartbeat:Connect(function()
        if not flyOn or not ch:FindFirstChild("HumanoidRootPart")then if bv and bv.Parent then bv:Destroy()end flyConn:Disconnect()return end
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
function disableFly()flyOn=false if flyConn then flyConn:Disconnect()flyConn=nil end local hrp=pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")if hrp then for _,v in ipairs(hrp:GetChildren())do if v:IsA("BodyVelocity")then v:Destroy()end end end end
flyb.MouseButton1Click:Connect(function()
    flyOn=not flyOn if flyOn then flyb.Text="FLY KAPAT" enableFly() else flyb.Text="FLY"disableFly()end
end)
local ncOn=false local ncConn
function enableNoclip()
    ncOn=true
    if ncConn then ncConn:Disconnect()end
    ncConn=game:GetService("RunService").Stepped:Connect(function()
        if ncOn and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            for _,p in pairs(pl.Character:GetDescendants())do
                if p:IsA("BasePart")then p.CanCollide=false end
            end
        end
    end)
end
function disableNoclip()
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
function enableGodmode()
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
function disableGodmode()
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
