local sg=Instance.new("ScreenGui")sg.Parent=game.CoreGui
local mf=Instance.new("Frame")mf.Parent=sg mf.Size=UDim2.new(0,420,0,610)mf.Position=UDim2.new(0.32,0,0.18,0)mf.BackgroundColor3=Color3.fromRGB(18,22,30)mf.BorderSizePixel=0 local mc=Instance.new("UICorner",mf)mc.CornerRadius=UDim.new(0,18)
local tt=Instance.new("TextLabel",mf)tt.Size=UDim2.new(1,0,0,59)tt.Position=UDim2.new(0,0,0,0)tt.Text="EĞİTİM HİLE MENÜ"tt.TextColor3=Color3.fromRGB(80,200,255)tt.Font=Enum.Font.GothamBlack tt.TextScaled=true tt.BackgroundTransparency=1
local cbtn=Instance.new("TextButton",mf)cbtn.Size=UDim2.new(0,46,0,46)cbtn.Position=UDim2.new(1,-66,0,14)cbtn.BackgroundColor3=Color3.fromRGB(255,58,58)cbtn.Text="X"cbtn.Font=Enum.Font.GothamBold cbtn.TextColor3=Color3.new(1,1,1)cbtn.TextScaled=true local cbtnu=Instance.new("UICorner",cbtn)cbtnu.CornerRadius=UDim.new(0,13)
local dragging,dragInput,dragStart,startPos
mf.InputBegan:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true dragStart=input.Position startPos=mf.Position input.Changed:Connect(function()if input.UserInputState==Enum.UserInputState.End then dragging=false end end)end end)
mf.InputChanged:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseMovement then dragInput=input end end)
game:GetService("UserInputService").InputChanged:Connect(function(input)if input==dragInput and dragging then local delta=input.Position-dragStart mf.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)end end)
cbtn.MouseButton1Click:Connect(function()sg:Destroy()end)
local btnFrame=Instance.new("Frame",mf)btnFrame.Size=UDim2.new(1,0,0,296)btnFrame.Position=UDim2.new(0,0,0,70)btnFrame.BackgroundTransparency=1
local layout=Instance.new("UIListLayout",btnFrame)layout.Padding=UDim.new(0,14)layout.HorizontalAlignment=Enum.HorizontalAlignment.Center layout.SortOrder=Enum.SortOrder.LayoutOrder layout.VerticalAlignment=Enum.VerticalAlignment.Top
local function mkbtn(txt,icol)
    local b=Instance.new("TextButton",btnFrame)
    b.Size=UDim2.new(0.8,0,0,48)
    b.BackgroundColor3=icol or Color3.fromRGB(35,40,55)
    b.Text=txt b.TextColor3=Color3.fromRGB(245,245,245)
    b.Font=Enum.Font.GothamBold b.TextScaled=true
    local c=Instance.new("UICorner",b)c.CornerRadius=UDim.new(0,14)
    return b
end
local aimb=mkbtn("AIMBOT")
local flyb=mkbtn("FLY")
local noclipb=mkbtn("NOCLIP")
local spinb=mkbtn("SPINBOT")
local gmb=mkbtn("GODMODE",Color3.fromRGB(80,150,80))
local tlt=Instance.new("TextLabel",mf)tlt.Size=UDim2.new(0.8,0,0,29)tlt.Position=UDim2.new(0.1,0,0,380)tlt.BackgroundTransparency=1 tlt.Text="TP İÇİN OYUNCU SEÇİN"tlt.Font=Enum.Font.GothamSemibold tlt.TextColor3=Color3.fromRGB(210,210,220)tlt.TextScaled=true
local dp=Instance.new("Frame",mf)dp.Size=UDim2.new(0.8,0,0,100)dp.Position=UDim2.new(0.1,0,0,420)dp.BackgroundColor3=Color3.fromRGB(40,54,62)local dpc=Instance.new("UICorner",dp)dpc.CornerRadius=UDim.new(0,11)
local lst=Instance.new("ScrollingFrame",dp)lst.Size=UDim2.new(1,0,1,0)lst.Position=UDim2.new(0,0,0,0)lst.CanvasSize=UDim2.new(0,0,0,0)lst.ScrollBarThickness=5 lst.BackgroundTransparency=1 lst.AutomaticCanvasSize=Enum.AutomaticSize.Y
local layout2=Instance.new("UIListLayout",lst)layout2.SortOrder=Enum.SortOrder.LayoutOrder layout2.Padding=UDim.new(0,8)
lst.ChildAdded:Connect(function()lst.CanvasSize=UDim2.new(0,0,0,lst.UIListLayout.AbsoluteContentSize.Y)end)
local tplsel
local tplbl=Instance.new("TextLabel",mf)tplbl.Size=UDim2.new(0.8,0,0,24)tplbl.Position=UDim2.new(0.1,0,0,530)tplbl.BackgroundTransparency=1 tplbl.Font=Enum.Font.Gotham tplbl.TextScaled=true tplbl.TextColor3=Color3.fromRGB(156,148,250)tplbl.Text="Seçili: Yok"
local tpb=Instance.new("TextButton",mf)tpb.Size=UDim2.new(0.8,0,0,42)tpb.Position=UDim2.new(0.1,0,0,560)tpb.BackgroundColor3=Color3.fromRGB(80,110,190)
tpb.Text="SEÇİLENİ TP AT" tpb.TextColor3=Color3.fromRGB(250,250,255)tpb.Font=Enum.Font.GothamBold tpb.TextScaled=true
local c2=Instance.new("UICorner",tpb)c2.CornerRadius=UDim.new(0,11)
local pl=game.Players.LocalPlayer
local function mklist()
    lst:ClearAllChildren() tplsel=nil tplbl.Text="Seçili: Yok"
    local ps={}for _,v in ipairs(game.Players:GetPlayers())do if v~=pl then table.insert(ps,v)end end
    for _,v in ipairs(ps)do
        local li=Instance.new("TextButton",lst)li.Size=UDim2.new(1,0,0,30)
        li.BackgroundColor3=Color3.fromRGB(60,98,125)
        li.Text=v.Name li.Font=Enum.Font.Gotham li.TextColor3=Color3.new(1,1,1)li.TextScaled=true
        local lco=Instance.new("UICorner",li)lco.CornerRadius=UDim.new(0,8)
        li.MouseButton1Click:Connect(function()
            tplsel=v
            for _,b in pairs(lst:GetChildren())do if b:IsA("TextButton")then b.BackgroundColor3=Color3.fromRGB(60,98,125)end end
            li.BackgroundColor3=Color3.fromRGB(120,72,201)
            tplbl.Text="Seçili: "..v.Name
        end)
    end
end
mklist()game.Players.PlayerAdded:Connect(mklist)game.Players.PlayerRemoving:Connect(mklist)
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
local flyOn=false local flyConn
function enableFly()
    if flyConn then flyConn:Disconnect()end flyOn=true
    local ch=pl.Character if not ch or not ch:FindFirstChild("HumanoidRootPart")then return end
    local hrp=ch.HumanoidRootPart
    local bv=Instance.new("BodyVelocity",hrp)bv.MaxForce=Vector3.new(1e5,1e5,1e5)
    local uis=game:GetService("UserInputService")
    flyConn=game:GetService("RunService").Heartbeat:Connect(function()
        if not flyOn or not ch:FindFirstChild("HumanoidRootPart")then bv:Destroy()flyConn:Disconnect()return end
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
    if ncConn then ncConn:Disconnect()end
    ncConn=game:GetService("RunService").Stepped:Connect(function()
        if ncOn and pl.Character then for _,p in pairs(pl.Character:GetDescendants())do if p:IsA("BasePart")then p.CanCollide=false end end end
    end)
end
function disableNoclip()ncOn=false if ncConn then ncConn:Disconnect()ncConn=nil end if pl.Character then for _,p in pairs(pl.Character:GetDescendants())do if p:IsA("BasePart")then p.CanCollide=true end end end end
noclipb.MouseButton1Click:Connect(function()
    ncOn=not ncOn if ncOn then noclipb.Text="NOCLIP KAPAT"enableNoclip()else noclipb.Text="NOCLIP"disableNoclip()end
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
        task.wait(0.3)
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
