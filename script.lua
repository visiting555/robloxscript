local function RS(t,b)local d={}for i=1,t do d[i]=string.char(math.random(97,122)+(math.random(0,1)*32))end;return table.concat(d)end
local HiddenGlobals=getgenv and getgenv() or _G
local SCRIPT_ID=RS(24,true)
HiddenGlobals["__CHEAT_"..SCRIPT_ID]=true
local LP=game:GetService("Players").LocalPlayer
local PS=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RSrv=game:GetService("RunService")
local TS=game:GetService("TeleportService")
local WSP=workspace
local CC=WSP.CurrentCamera
math.randomseed(tick()*os.time())

local function deepProtect(inst)pcall(function()if sethiddenproperty then sethiddenproperty(inst,"Archivable",false)end;if syn and syn.protect_gui then syn.protect_gui(inst)end end)return inst end

local MenuGui=deepProtect(Instance.new("ScreenGui"))
MenuGui.Name="CHEATHILE_MENU_"..SCRIPT_ID
pcall(function()MenuGui.Parent=game:GetService("CoreGui")end)
if not MenuGui.Parent then MenuGui.Parent=LP:FindFirstChildOfClass("PlayerGui")end

local MainFrm=deepProtect(Instance.new("Frame"))
MainFrm.Parent=MenuGui
MainFrm.Size=UDim2.new(0,760,0,600)
MainFrm.Position=UDim2.new(0.15,0,0.11,0)
MainFrm.BackgroundColor3=Color3.fromRGB(0,0,0)
MainFrm.Draggable=true;MainFrm.Active=true;MainFrm.BorderSizePixel=0
MainFrm.Visible=true
local Menu_IsVisible=true

local MenuConfig={
    SideCatWidth=186,
    OptionPadX=32,
    OptionPadY=17,
    OptionHeight=44,
    OptionGap=3,
    CatGap=22,
    RightPad=18,
    TitleHeight=50,
}
local Categories={
    {Name="Aim Hileleri",Options={"Aimbot","SilentAim","Spinbot","Fov Changer"}},
    {Name="Görüş Hileleri",Options={"ESP","Spectate Player"}},
    {Name="Troll Hileleri",Options={"Explode","Fly","Teleport","Yanına Teleport","Noclip"}},
    {Name="Bireysel Hileler",Options={"No Reload","Godmode","Rejoin","Reset Character"}}
}
local CatOptionTypes={
    ["Aimbot"]="Toggle",
    ["SilentAim"]="Toggle",
    ["Spinbot"]="Toggle",
    ["Fov Changer"]="Input",
    ["ESP"]="Toggle",
    ["Spectate Player"]="Button",
    ["Explode"]="Button",
    ["Fly"]="Toggle",
    ["Teleport"]="Button",
    ["Yanına Teleport"]="Button",
    ["Noclip"]="Toggle",
    ["No Reload"]="Toggle",
    ["Godmode"]="Toggle",
    ["Rejoin"]="Button",
    ["Reset Character"]="Button"
}
local AllOptions={}
for _,c in ipairs(Categories)do
    for _,o in ipairs(c.Options) do AllOptions[o]=true end
end

local TITLE=deepProtect(Instance.new("TextLabel"))
TITLE.Parent=MainFrm
TITLE.Size=UDim2.new(1,0,0,MenuConfig.TitleHeight)
TITLE.Position=UDim2.new(0,0,0,0)
TITLE.BackgroundTransparency=1
TITLE.Text="EĞİTİM AMAÇLI MODERN ROBLOX HİLE MENÜSÜ"
TITLE.Font=Enum.Font.SourceSansBold
TITLE.TextSize=34
TITLE.TextColor3=Color3.fromRGB(255,36,60)
TITLE.TextStrokeTransparency=.8

local function Notify(msg,tm)
    local old=MenuGui:FindFirstChild("NotifyMsg")
    if old then old:Destroy()end
    local n=deepProtect(Instance.new("TextLabel"))
    n.Name="NotifyMsg"
    n.Parent=MainFrm
    n.Size=UDim2.new(0.7,0,0,32)
    n.Position=UDim2.new(0.12,0,0.91,0)
    n.BackgroundColor3=Color3.fromRGB(33,33,33)
    n.TextColor3=Color3.fromRGB(255,255,255)
    n.TextSize=20
    n.BackgroundTransparency=0.15
    n.Font=Enum.Font.SourceSansBold
    n.Text=" "..tostring(msg)
    n.TextStrokeTransparency=.9
    game.Debris:AddItem(n,tm or 2.3)
end

local CloseBtn=deepProtect(Instance.new("TextButton"))
CloseBtn.Parent=MainFrm
CloseBtn.Position=UDim2.new(1,-52,0,7)
CloseBtn.Size=UDim2.new(0,40,0,30)
CloseBtn.Text="✖"
CloseBtn.Font=Enum.Font.SourceSansBold
CloseBtn.BackgroundTransparency=1
CloseBtn.TextSize=23
CloseBtn.TextColor3=Color3.fromRGB(255,36,60)
local IsClosing=false
CloseBtn.MouseButton1Click:Connect(function()
    if IsClosing then return end;IsClosing=true
    MainFrm.Visible=false
    wait(2)
    MainFrm.Visible=true
    IsClosing=false
end)
UIS.InputBegan:Connect(function(k)
    if k.KeyCode==Enum.KeyCode.RightControl then
        MainFrm.Visible=not MainFrm.Visible
        Menu_IsVisible=MainFrm.Visible
    end
end)

local CatBtns,Settings,BtnUI,OptionFrms={}, {}, {}, {}
local CurrentCategory=nil
local globalCons,espTable,FlyB,SpecCon={}, {}, nil, nil
local OptionFrame=deepProtect(Instance.new("Frame"))
OptionFrame.Parent=MainFrm
OptionFrame.BackgroundTransparency=1
OptionFrame.Position=UDim2.new(0,MenuConfig.SideCatWidth+MenuConfig.RightPad,0,MenuConfig.TitleHeight+8)
OptionFrame.Size=UDim2.new(0,MainFrm.Size.X.Offset-MenuConfig.SideCatWidth-MenuConfig.RightPad-18,1,-MenuConfig.TitleHeight-22)

local function DisconnectAll(t)for k,v in pairs(t)do pcall(function()if typeof(v)=="RBXScriptConnection"then v:Disconnect()else v:remove()end end)t[k]=nil end end

local function PickPlayerPopup(clb)
    local fm=deepProtect(Instance.new("Frame"))
    fm.Size=UDim2.new(0,270,0,226)
    fm.Position=UDim2.new(.50,-50,.19,0)
    fm.Name="Picker_"..RS(6)
    fm.BackgroundColor3=Color3.fromRGB(17,17,21)
    fm.BorderSizePixel=0
    fm.ZIndex=150
    fm.Parent=MainFrm
    local close=deepProtect(Instance.new("TextButton"))
    close.Parent=fm
    close.Size=UDim2.new(0,36,0,25)
    close.Position=UDim2.new(1,-39,0,4)
    close.Text="✖"
    close.BackgroundTransparency=1
    close.TextColor3=Color3.fromRGB(255,36,60)
    close.TextSize=20
    close.Font=Enum.Font.SourceSansBold
    close.ZIndex=155
    close.MouseButton1Click:Connect(function()fm:Destroy()end)
    local lb=deepProtect(Instance.new("TextLabel"))
    lb.Size=UDim2.new(1,0,0,22)
    lb.Position=UDim2.new(0,0,0,2)
    lb.Text="Oyuncu Seç"
    lb.TextColor3=Color3.fromRGB(255,255,255)
    lb.TextSize=18
    lb.Font=Enum.Font.SourceSansBold
    lb.BackgroundTransparency=1
    lb.ZIndex=151
    lb.Parent=fm
    local pList={}
    for _,p in ipairs(PS:GetPlayers())do
        if p~=LP then table.insert(pList,p)end
    end
    table.sort(pList,function(a,b)return a.Name:lower()<b.Name:lower()end)
    for i,pl in ipairs(pList)do
        local pp=deepProtect(Instance.new("TextButton"))
        pp.ZIndex=152
        pp.Parent=fm
        pp.Size=UDim2.new(1,-7,0,24)
        pp.Position=UDim2.new(0,5,0,28+(i-1)*25)
        pp.Text=pl.DisplayName.." ["..pl.Name.."]"
        pp.Font=Enum.Font.SourceSans
        pp.TextColor3=Color3.fromRGB(255,80,80)
        pp.TextSize=18
        pp.BackgroundColor3=Color3.fromRGB(36,18,18)
        pp.BackgroundTransparency=.15
        pp.MouseButton1Click:Connect(function()clb(pl)fm:Destroy()end)
    end
end

local function getCategoryIndexByName(catName)
    for i,cat in ipairs(Categories)do if cat.Name==catName then return i end end
    return 1
end

local function getOptionType(optName)
    return CatOptionTypes[optName] or "Toggle"
end

local function setCategory(cat)
    CurrentCategory=cat
    for _,cbtn in pairs(CatBtns)do
        cbtn.BackgroundTransparency=(cbtn._cat==cat) and .13 or 1
    end
    for _,f in pairs(OptionFrms)do f:Destroy()end
    OptionFrms={}
    local cIdx=getCategoryIndexByName(cat)
    local thisCat=Categories[cIdx]
    for idx,opt in ipairs(thisCat.Options)do
        local oy=(idx-1)*(MenuConfig.OptionHeight+MenuConfig.OptionGap)
        local f=deepProtect(Instance.new("Frame"))
        f.Parent=OptionFrame
        f.Size=UDim2.new(1,-18,0,MenuConfig.OptionHeight)
        f.Position=UDim2.new(0,MenuConfig.OptionPadX,0,oy)
        f.BackgroundColor3=Color3.fromRGB(18,18,18)
        f.BorderSizePixel=0
        OptionFrms[#OptionFrms+1]=f
        local lbl=deepProtect(Instance.new("TextLabel"))
        lbl.Parent=f
        lbl.Size=UDim2.new(0.68,0,1,0)
        lbl.Text=opt
        lbl.BackgroundTransparency=1
        lbl.Position=UDim2.new(0,10,0,0)
        lbl.Font=Enum.Font.SourceSans
        lbl.TextColor3=Color3.fromRGB(255,36,60)
        lbl.TextSize=20
        local typ=getOptionType(opt)
        if typ=="Toggle" then
            local tg=deepProtect(Instance.new("TextButton"))
            tg.Parent=f
            tg.Size=UDim2.new(0,58,0,25)
            tg.Position=UDim2.new(1,-67,0.5,-12)
            tg.Text=Settings[opt] and "Açık" or "Kapalı"
            tg.Font=Enum.Font.SourceSansBold
            tg.TextColor3=Color3.fromRGB(255,255,255)
            tg.BackgroundColor3=Settings[opt] and Color3.fromRGB(255,36,60) or Color3.fromRGB(60,60,60)
            tg.TextSize=17
            tg.MouseButton1Click:Connect(function()
                Settings[opt]=not Settings[opt]
                tg.Text=Settings[opt] and "Açık" or "Kapalı"
                tg.BackgroundColor3=Settings[opt] and Color3.fromRGB(255,36,60) or Color3.fromRGB(60,60,60)
                if BtnUI[opt] and type(BtnUI[opt])=="function" then BtnUI[opt](Settings[opt],tg) end
            end)
        elseif typ=="Input" then
            local inp=deepProtect(Instance.new("TextBox"))
            inp.Parent=f
            inp.Size=UDim2.new(0,52,0,22)
            inp.Position=UDim2.new(1,-67,0.5,-11)
            inp.Text=Settings[opt] or "85"
            inp.TextColor3=Color3.fromRGB(255,255,255)
            inp.BackgroundColor3=Color3.fromRGB(60,60,60)
            inp.Font=Enum.Font.SourceSansBold
            inp.TextSize=15
            inp.ClearTextOnFocus=false
            inp.FocusLost:Connect(function()
                local v=tonumber(inp.Text)
                if v then Settings[opt]=v if BtnUI[opt] and type(BtnUI[opt])=="function" then BtnUI[opt](v,inp) end end
            end)
        elseif typ=="Button" then
            local b=deepProtect(Instance.new("TextButton"))
            b.Parent=f
            b.Size=UDim2.new(0,58,0,25)
            b.Position=UDim2.new(1,-67,0.5,-12)
            b.Text=opt
            b.Font=Enum.Font.SourceSansBold
            b.TextSize=16
            b.BackgroundColor3=Color3.fromRGB(255,36,60)
            b.TextColor3=Color3.new(1,1,1)
            b.MouseButton1Click:Connect(function()
                if BtnUI[opt] and type(BtnUI[opt])=="function" then BtnUI[opt](true,b) end
            end)
        end
    end
end

for idx,cat in ipairs(Categories)do
    local y=MenuConfig.TitleHeight+8+(idx-1)*(45+MenuConfig.CatGap)
    local btn=deepProtect(Instance.new("TextButton"))
    btn.Parent=MainFrm
    btn.Size=UDim2.new(0,MenuConfig.SideCatWidth,0,45)
    btn.Position=UDim2.new(0,0,0,y)
    btn.BackgroundColor3=Color3.fromRGB(42,14,18)
    btn.BackgroundTransparency=1
    btn.Text=cat.Name
    btn.Font=Enum.Font.SourceSansBold
    btn.TextColor3=Color3.fromRGB(255,36,60)
    btn.TextSize=21
    btn.ZIndex=6
    btn._cat=cat.Name
    btn.MouseButton1Click:Connect(function()
        setCategory(cat.Name)
    end)
    CatBtns[#CatBtns+1]=btn
end
setCategory(Categories[1].Name)

local function isEnemyFunc(target)
    if not target or target == LP then return false end
    if LP.Team and target.Team then
        return LP.Team ~= target.Team
    end
    return true
end

local function getClosestEnemy()
    local trg,dist=nil,1/0
    for _,p in ipairs(PS:GetPlayers()) do
        if isEnemyFunc(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos,vis=CC:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if vis then
                local d=(Vector2.new(pos.X,pos.Y)-Vector2.new(CC.ViewportSize.X/2,CC.ViewportSize.Y/2)).Magnitude
                if d<dist then dist, trg = d, p end
            end
        end
    end
    return trg
end

BtnUI["Aimbot"]=function(on)
    DisconnectAll({globalCons.aimbot})
    if on then
        globalCons.aimbot=RSrv.RenderStepped:Connect(function()
            if not Settings["Aimbot"] then return end
            local enemy=getClosestEnemy()
            if enemy and enemy.Character and enemy.Character:FindFirstChild("Head") then
                CC.CFrame=CFrame.new(CC.CFrame.Position,enemy.Character.Head.Position)
            end
        end)
        Notify("Aimbot Aktif")
    else
        Notify("Aimbot Kapalı")
    end
end

BtnUI["SilentAim"]=function(on)
    if on then
        if not globalCons.saimhook then
            globalCons._oldmeta = getrenv().__namecall
            setreadonly(getrawmetatable(game), false)
            globalCons.saimhook = hookmetamethod(game,"__namecall",function(self,...)
                local m=getnamecallmethod()local args={...}
                if m=="FireServer" and Settings["SilentAim"] and type(args[1])=="Vector3" then
                    local en=getClosestEnemy()
                    if en and en.Character and en.Character:FindFirstChild("Head") then
                        args[1]=en.Character.Head.Position
                    end
                end
                return globalCons._oldmeta(self,unpack(args))
            end)
        end
        Notify("SilentAim Açık")
    else
        if globalCons.saimhook then globalCons.saimhook=nil end
        Notify("SilentAim Kapalı")
    end
end

BtnUI["Spinbot"]=function(on)
    DisconnectAll({globalCons.spinloop})
    if on then
        globalCons.spinloop=RSrv.RenderStepped:Connect(function(dt)
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame=LP.Character.HumanoidRootPart.CFrame*CFrame.Angles(0,20*dt,0)
            end
        end)
        Notify("Spinbot Aktif")
    else
        Notify("Spinbot Kapalı")
    end
end

BtnUI["Fov Changer"]=function(val,inp)
    if type(val)=="number" then CC.FieldOfView=val Notify("FOV: "..val) end
end

BtnUI["ESP"]=function(on)
    DisconnectAll({globalCons.esp})
    if on then
        globalCons.esp=RSrv.RenderStepped:Connect(function()
            for _,v in pairs(espTable)do pcall(function()if typeof(v.Remove)=="function"then v:Remove()end end)end;espTable={}
            for _,p in ipairs(PS:GetPlayers()) do
                if p~=LP and isEnemyFunc(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local DrawingLib=Drawing and Drawing.new
                    if DrawingLib then
                        local sq=DrawingLib("Square")
                        sq.Color=Color3.fromRGB(255,36,60)
                        sq.Thickness=2;sq.Filled=false;sq.Transparency=1;sq.Visible=true
                        local pos,vis=CC:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                        sq.Position=Vector2.new(pos.X-32,pos.Y-50)
                        sq.Size=Vector2.new(64,96);sq.Visible=vis and true or false
                        espTable[p]=sq
                    end
                end
            end
        end)
        Notify("ESP Açık")
    else
        for _,obj in pairs(espTable)do pcall(function()obj:Remove()end)end
        espTable={}
        Notify("ESP Kapalı")
    end
end

BtnUI["Spectate Player"]=function(on)
    PickPlayerPopup(function(plr)
        if plr and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            local old=CC.CameraSubject
            CC.CameraSubject=plr.Character:FindFirstChildOfClass("Humanoid")
            Notify("İzleniyor: "..plr.Name)
            wait(8.5)
            CC.CameraSubject=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") or old
            Notify("Tekrar kendisine dönüldü")
        end
    end)
end

BtnUI["Explode"]=function(on)
    PickPlayerPopup(function(pl)
        if pl and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            local ex=Instance.new("Explosion")
            ex.Position=pl.Character.HumanoidRootPart.Position
            ex.BlastRadius=8
            ex.BlastPressure=1.45e7
            ex.Parent=WSP
            Notify(pl.Name.." Patlatıldı")
        end
    end)
end

BtnUI["Fly"]=function(on)
    if on then
        if not FlyB then
            FlyB=deepProtect(Instance.new("BodyVelocity"))
            FlyB.MaxForce=Vector3.new(1e7,1e7,1e7)
            FlyB.Velocity=Vector3.new(0,0,0)
            local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if root then FlyB.Parent=root end
        end
        if not globalCons.flymove then
            globalCons.flymove=UIS.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.Keyboard and FlyB and FlyB.Parent then
                    if i.KeyCode==Enum.KeyCode.Space then FlyB.Velocity=Vector3.new(0,60,0)
                    elseif i.KeyCode==Enum.KeyCode.W then FlyB.Velocity=CC.CFrame.LookVector*52
                    elseif i.KeyCode==Enum.KeyCode.S then FlyB.Velocity=CC.CFrame.LookVector*-40 end
                end
            end)
            globalCons.flystop=UIS.InputEnded:Connect(function()if FlyB then FlyB.Velocity=Vector3.new(0,0,0)end end)
        end
        Notify("Fly Açık")
    else
        if FlyB then FlyB:Destroy();FlyB=nil end
        if globalCons.flymove then globalCons.flymove:Disconnect();globalCons.flymove=nil end
        if globalCons.flystop then globalCons.flystop:Disconnect();globalCons.flystop=nil end
        Notify("Fly Kapalı")
    end
end

BtnUI["Teleport"]=function()
    PickPlayerPopup(function(pl)
        if pl and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame=pl.Character.HumanoidRootPart.CFrame+Vector3.new(0,4,0)
            Notify("Işınlandın > "..pl.Name)
        end
    end)
end

BtnUI["Yanına Teleport"]=function()
    PickPlayerPopup(function(pl)
        if pl and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            pl.Character.HumanoidRootPart.CFrame=LP.Character.HumanoidRootPart.CFrame+Vector3.new(2,3,0)
            Notify(pl.Name.." yanınıza çekildi")
        end
    end)
end

BtnUI["Noclip"]=function(on)
    DisconnectAll({globalCons.noclip})
    if on then
        globalCons.noclip=RSrv.Stepped:Connect(function()
            if LP.Character then
                for _,v in ipairs(LP.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide=false end
                end
            end
        end)
        Notify("Noclip Açık")
    else
        Notify("Noclip Kapalı")
    end
end

BtnUI["No Reload"]=function(on)
    for _,itm in pairs(LP.Backpack:GetChildren()) do
        if itm and itm:FindFirstChild("Ammo") and itm:FindFirstChild("Reload") then
            itm.Ammo.Value=99999999
            itm.Reload.Disabled=on
        end
    end
    Notify(on and "No Reload Açık" or "No Reload Kapalı")
end

BtnUI["Godmode"]=function(on)
    if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        if on then
            LP.Character:FindFirstChildOfClass("Humanoid").Name="God"
            LP.Character.God.MaxHealth=math.huge
            LP.Character.God.Health=math.huge
            for _,v in pairs(LP.Character:GetChildren()) do
                if v:IsA("Part") then v.Anchored=false;v.CanCollide=true end
            end
            Notify("Godmode Açık")
        else
            LP.Character.God.MaxHealth=100;LP.Character.God.Health=100;LP.Character.God.Name="Humanoid"
            Notify("Godmode Kapalı")
        end
    end
end

BtnUI["Rejoin"]=function()
    TS:Teleport(game.PlaceId)
end

BtnUI["Reset Character"]=function()
    if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        LP.Character:BreakJoints()
        Notify("Resetlendi")
    end
end

local SelectAll=deepProtect(Instance.new("TextButton",MainFrm))
SelectAll.Size=UDim2.new(0,192,0,32)
SelectAll.Position=UDim2.new(0.55,0,0.93,0)
SelectAll.BackgroundColor3=Color3.fromRGB(54,17,22)
SelectAll.TextColor3=Color3.fromRGB(255,255,255)
SelectAll.TextSize=16
SelectAll.Font=Enum.Font.SourceSansBold
SelectAll.Text="TÜM HİLELERİ AÇ / KAPAT"
SelectAll.MouseButton1Click:Connect(function()
    local allActive=true
    for name,_ in pairs(CatOptionTypes) do
        if CatOptionTypes[name]=="Toggle" and (not Settings[name]) then
            allActive=false; break
        end
    end
    for name,fun in pairs(BtnUI)do
        if CatOptionTypes[name]=="Toggle" then
            Settings[name]=not allActive
            if type(fun)=="function" then fun(Settings[name]) end
        end
    end
    setCategory(CurrentCategory)
    Notify("Tüm hile opsiyonları "..(allActive and "kapatıldı" or "açıldı"))
end)

local function blockAnticheat()
    local block_hooks={"Kick","kick","BreakJoints"}
    for _,obj in ipairs({LP,game:GetService("Players")})do
        for _,nm in ipairs(block_hooks)do
            pcall(function()
                if not obj[nm] then return end
                local old=obj[nm]
                obj[nm]=function(...)return nil end
                setreadonly(obj,false)
                obj[nm]=function(...)return nil end
                setreadonly(obj,true)
            end)
        end
    end
end; blockAnticheat()
Notify("Menü Hazır! Sağ CTRL ile aç/kapat")
