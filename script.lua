local sg=Instance.new("ScreenGui")sg.Parent=game.CoreGui
local mf=Instance.new("Frame")mf.Parent=sg mf.Size=UDim2.new(0,380,0,510)mf.Position=UDim2.new(0.35,0,0.2,0)mf.BackgroundColor3=Color3.fromRGB(20,20,28)mf.BorderSizePixel=0 local mc=Instance.new("UICorner",mf)mc.CornerRadius=UDim.new(0,17)
local tt=Instance.new("TextLabel",mf)tt.Size=UDim2.new(1,0,0,55)tt.Position=UDim2.new(0,0,0,0)tt.Text="EĞİTİM MENÜ"tt.TextColor3=Color3.fromRGB(75,175,255)tt.Font=Enum.Font.GothamBold tt.TextScaled=true tt.BackgroundTransparency=1
local function mkbtn(txt,y)
    local b=Instance.new("TextButton",mf)b.Size=UDim2.new(0.75,0,0,48)b.Position=UDim2.new(0.125,0,0,y)b.BackgroundColor3=Color3.fromRGB(33,35,50)b.Text=txt b.TextColor3=Color3.fromRGB(235,235,235)b.Font=Enum.Font.Gotham b.TextScaled=true local c=Instance.new("UICorner",b)c.CornerRadius=UDim.new(0,13)return b
end
local aimb=mkbtn("AIMBOT",0.13)local flyb=mkbtn("FLY",0.23)local noclipb=mkbtn("NOCLIP",0.33)local spinb=mkbtn("SPINBOT",0.43)
local tplb=Instance.new("TextLabel",mf)tplb.Size=UDim2.new(0.75,0,0,28)tplb.Position=UDim2.new(0.125,0,0,0.53)tplb.BackgroundTransparency=1 tplb.Text="TP İÇİN OYUNCUYU SEÇ"tplb.Font=Enum.Font.GothamSemibold tplb.TextColor3=Color3.fromRGB(220,220,220)tplb.TextScaled=true
local dp=Instance.new("Frame",mf)dp.Size=UDim2.new(0.75,0,0,45)dp.Position=UDim2.new(0.125,0,0,0.57)dp.BackgroundColor3=Color3.fromRGB(38,48,58)local dpc=Instance.new("UICorner",dp)dpc.CornerRadius=UDim.new(0,10)
local lst=Instance.new("ScrollingFrame",dp)lst.Size=UDim2.new(1,0,1,0)lst.Position=UDim2.new(0,0,0,0)lst.CanvasSize=UDim2.new(0,0,0,0)lst.ScrollBarThickness=4 lst.BackgroundTransparency=1
local tplsel
local tplbl=Instance.new("TextLabel",mf)tplbl.Size=UDim2.new(0.75,0,0,25)tplbl.Position=UDim2.new(0.125,0,0,0.66)tplbl.BackgroundTransparency=1 tplbl.Font=Enum.Font.Gotham tplbl.TextScaled=true tplbl.TextColor3=Color3.fromRGB(190,190,250)tplbl.Text="Seçili: Yok"
local tpb=mkbtn("SEÇİLENİ TP AT",0.73)
local cbtn=Instance.new("TextButton",mf)cbtn.Size=UDim2.new(0,43,0,43)cbtn.Position=UDim2.new(1,-58,0,7)cbtn.BackgroundColor3=Color3.fromRGB(255,68,68)cbtn.Text="X"cbtn.Font=Enum.Font.GothamBold cbtn.TextColor3=Color3.new(1,1,1)cbtn.TextScaled=true local cbtnu=Instance.new("UICorner",cbtn)cbtnu.CornerRadius=UDim.new(0,13)
local dragging,dragInput,dragStart,startPos
mf.InputBegan:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true dragStart=input.Position startPos=mf.Position input.Changed:Connect(function()if input.UserInputState==Enum.UserInputState.End then dragging=false end end)end end)
mf.InputChanged:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseMovement then dragInput=input end end)
game:GetService("UserInputService").InputChanged:Connect(function(input)if input==dragInput and dragging then local delta=input.Position-dragStart mf.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)end end)
cbtn.MouseButton1Click:Connect(function()sg:Destroy()end)
local pl=game.Players.LocalPlayer
local function mklist()
    lst:ClearAllChildren()tplsel=nil tplbl.Text="Seçili: Yok"
    local ps={}for _,v in ipairs(game.Players:GetPlayers())do if v~=pl then table.insert(ps,v)end end
    lst.CanvasSize=UDim2.new(0,0,0,math.max(0,(#ps)*28))
    for i,v in ipairs(ps)do
        local li=Instance.new("TextButton",lst)li.Size=UDim2.new(1,0,0,26)li.Position=UDim2.new(0,0,0,(i-1)*28)li.BackgroundColor3=Color3.fromRGB(70,90,110)
        li.Text=v.Name li.Font=Enum.Font.Gotham li.TextColor3=Color3.new(1,1,1)li.TextScaled=true
        local lco=Instance.new("UICorner",li)lco.CornerRadius=UDim.new(0,7)
        li.MouseButton1Click:Connect(function()tplsel=v tplbl.Text="Seçili: "..v.Name end)
    end
end
mklist()
game.Players.PlayerAdded:Connect(mklist)game.Players.PlayerRemoving:Connect(mklist)
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
tpb.MouseButton1Click:Connect(function()
    if tplsel and tplsel.Character and tplsel.Character:FindFirstChild("HumanoidRootPart")then
        local ch=pl.Character if ch and ch:FindFirstChild("HumanoidRootPart")then ch.HumanoidRootPart.CFrame=tplsel.Character.HumanoidRootPart.CFrame+Vector3.new(2,1,0)end
    end
end)
