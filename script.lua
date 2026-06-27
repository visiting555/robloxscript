local function RS(t,b)local d={}for i=1,t do d[i]=string.char(math.random(97,122)+(math.random(0,1)*32))end;return table.concat(d)end
local HiddenGlobals=getgenv and getgenv() or _G
local SCRIPT_ID=RS(24,true)
HiddenGlobals["__CHEAT_"..SCRIPT_ID]=true
local LP=game:GetService("Players").LocalPlayer;
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
MainFrm.Parent=MenuGui;
MainFrm.Size=UDim2.new(0,720,0,590)
MainFrm.Position=UDim2.new(0.21,0,0.13,0)
MainFrm.BackgroundColor3=Color3.fromRGB(0,0,0)
MainFrm.Draggable=true;MainFrm.Active=true;MainFrm.BorderSizePixel=0;MainFrm.Visible=true
local Menu_IsVisible=true

local function setVis(v)MainFrm.Visible=v;Menu_IsVisible=v end
UIS.InputBegan:Connect(function(k)if k.KeyCode==Enum.KeyCode.RightControl then setVis(not MainFrm.Visible)end end)

local TITLE=deepProtect(Instance.new("TextLabel"))
TITLE.Parent=MainFrm
TITLE.Size=UDim2.new(1,0,0,47)
TITLE.Position=UDim2.new(0,0,0,0)
TITLE.BackgroundTransparency=1
TITLE.Text="EĞİTİM AMAÇLI MODERN ROBLOX HİLE MENÜSÜ"
TITLE.Font=Enum.Font.SourceSansBold
TITLE.TextSize=37
TITLE.TextColor3=Color3.fromRGB(255,36,60)

local function Notify(msg,tm)
    local old=MenuGui:FindFirstChild("NotifyMsg")
    if old then old:Destroy()end
    local n=deepProtect(Instance.new("TextLabel"));n.Name="NotifyMsg"
    n.Parent=MainFrm;n.Size=UDim2.new(0.7,0,0,28)
    n.Position=UDim2.new(0.15,0,0.92,0)
    n.BackgroundColor3=Color3.fromRGB(33,33,33)
    n.TextColor3=Color3.fromRGB(255,255,255)
    n.TextSize=23;n.BackgroundTransparency=0.12
    n.Font=Enum.Font.SourceSansBold;n.Text=" "..tostring(msg)
    game.Debris:AddItem(n,tm or 2.3)
end

local CloseBtn=deepProtect(Instance.new("TextButton"))
CloseBtn.Parent=MainFrm; CloseBtn.Position=UDim2.new(1,-56,0,6)
CloseBtn.Size=UDim2.new(0,42,0,32)
CloseBtn.Text="✖"
CloseBtn.Font=Enum.Font.SourceSansBold
CloseBtn.BackgroundTransparency=1;CloseBtn.TextSize=26
CloseBtn.TextColor3=Color3.fromRGB(255,36,60)
local IsClosing=false
CloseBtn.MouseButton1Click:Connect(function()
    if IsClosing then return end;IsClosing=true
    MainFrm.Visible=false
    wait(2)
    MainFrm.Visible=true
    IsClosing=false
end)

local SectionInfo={
    ["Aim Hileleri"]={"Aimbot","SilentAim","Spinbot","Fov Changer"},
    ["Görüş Hileleri"]={"ESP","Spectate Player"},
    ["Troll Hileleri"]={"Explode","Fly","Teleport","Yanına Teleport","Noclip"},
    ["Bireysel Hileler"]={"No Reload","Godmode","Rejoin","Reset Character"}
}
local AllOptsInOrder={}
for _,cat in ipairs({"Aim Hileleri","Görüş Hileleri","Troll Hileleri","Bireysel Hileler"})do
    for i,v in ipairs(SectionInfo[cat])do
        table.insert(AllOptsInOrder,{cat,v})
    end
end

local SectionX=15
local SectionOffsets={}
do
    local oy=57
    for _,sec in ipairs({"Aim Hileleri","Görüş Hileleri","Troll Hileleri","Bireysel Hileler"})do
        SectionOffsets[sec]=oy
        oy=oy+#SectionInfo[sec]*39+60
    end
end

local function CreateSection(title,oy)
    local lbl=deepProtect(Instance.new("TextLabel"))
    lbl.Name="SEC_"..title:gsub(" ","_")
    lbl.Parent=MainFrm
    lbl.Size=UDim2.new(0,140,0,34)
    lbl.Position=UDim2.new(0,SectionX,0,oy)
    lbl.BackgroundTransparency=1
    lbl.Text=title
    lbl.TextColor3=Color3.fromRGB(255,36,60)
    lbl.TextSize=23
    lbl.Font=Enum.Font.SourceSansBold
end

local function PickPlayerPopup(clb)
    local fm=deepProtect(Instance.new("Frame"))
    fm.Size=UDim2.new(0,240,0,225);fm.Position=UDim2.new(.60,0,.17,0)
    fm.Name="Picker_"..RS(6);fm.BackgroundColor3=Color3.fromRGB(17,17,21);fm.BorderSizePixel=0;fm.ZIndex=78;fm.Parent=MainFrm
    local close=deepProtect(Instance.new("TextButton"))
    close.Parent=fm;close.Size=UDim2.new(0,38,0,28);close.Position=UDim2.new(1,-41,0,2)
    close.Text="✖";close.BackgroundTransparency=1;close.TextColor3=Color3.fromRGB(255,36,60);close.ZIndex=81;close.TextSize=21
    close.Font=Enum.Font.SourceSansBold
    close.MouseButton1Click:Connect(function()fm:Destroy()end)
    local lb=deepProtect(Instance.new("TextLabel"))
    lb.Size=UDim2.new(1,0,0,25);lb.Position=UDim2.new(0,0,0,0);lb.Text="Oyuncu Seç";lb.TextColor3=Color3.fromRGB(255,255,255)
    lb.TextSize=20;lb.Font=Enum.Font.SourceSansBold;lb.ZIndex=80;lb.BackgroundTransparency=1;lb.Parent=fm
    local pList={}
    for _,p in ipairs(PS:GetPlayers())do if p~=LP then table.insert(pList,p)end end
    table.sort(pList,function(a,b)return a.Name:lower()<b.Name:lower()end)
    for i,pl in ipairs(pList)do
        local pp=deepProtect(Instance.new("TextButton"));pp.ZIndex=81
        pp.Parent=fm;pp.Size=UDim2.new(1,-9,0,25);pp.Position=UDim2.new(0,5,0,31+(i-1)*25)
        pp.Text=pl.DisplayName.." ["..pl.Name.."]";pp.Font=Enum.Font.SourceSans;pp.TextColor3=Color3.fromRGB(255,80,80)
        pp.TextSize=19;pp.BackgroundColor3=Color3.fromRGB(45,24,24);pp.BackgroundTransparency=.09
        pp.MouseButton1Click:Connect(function()clb(pl)fm:Destroy()end)
    end
end

local Settings,BtnUI={},{}
local function CreateButton(oy,txt,typ,callback)
    local ff=deepProtect(Instance.new("Frame",MainFrm));
    ff.Size=UDim2.new(0,145,0,31);ff.Position=UDim2.new(0,SectionX+7,0,oy)
    ff.BackgroundColor3=Color3.fromRGB(20,19,20);ff.BorderSizePixel=0
    local lbl=deepProtect(Instance.new("TextLabel",ff));lbl.Size=UDim2.new(0.62,0,1,0)
    lbl.Text=txt;lbl.TextColor3=Color3.fromRGB(255,36,60);lbl.TextSize=18
    lbl.BackgroundTransparency=1;lbl.Position=UDim2.new(0,7,0,0);lbl.Font=Enum.Font.Code
    if typ=="Toggle" then
        local tg=deepProtect(Instance.new("TextButton",ff))
        tg.Size=UDim2.new(0,54,0,21);tg.Position=UDim2.new(1,-59,0,5)
        tg.Text="Kapalı";tg.Font=Enum.Font.SourceSansBold
        tg.TextColor3=Color3.fromRGB(255,255,255);tg.BackgroundColor3=Color3.fromRGB(60,60,60);tg.TextSize=15
        tg.MouseButton1Click:Connect(function()
            Settings[txt]=not Settings[txt]
            tg.Text=Settings[txt] and "Açık" or "Kapalı"
            tg.BackgroundColor3=Settings[txt] and Color3.fromRGB(255,36,60) or Color3.fromRGB(60,60,60)
            callback(Settings[txt])
        end)BtnUI[txt]=tg
    elseif typ=="Button" then
        local tv=deepProtect(Instance.new("TextButton",ff))
        tv.Size=UDim2.new(0,60,0,21);tv.Position=UDim2.new(1,-64,0,5)
        tv.Text=txt;tv.Font=Enum.Font.SourceSansBold;tv.BackgroundColor3=Color3.fromRGB(188,26,26);
        tv.TextSize=15;tv.TextColor3=Color3.new(1,1,1);tv.MouseButton1Click:Connect(callback);
        BtnUI[txt]=tv
    elseif typ=="Input" then
        local inp=deepProtect(Instance.new("TextBox",ff))
        inp.Size=UDim2.new(0,42,0,19);inp.Position=UDim2.new(1,-44,0,6)
        inp.Text=Settings[txt] or "85"
        inp.TextColor3=Color3.fromRGB(255,255,255);inp.BackgroundColor3=Color3.fromRGB(60,60,60)
        inp.Font=Enum.Font.SourceSansBold;inp.TextSize=13
        inp.FocusLost:Connect(function()
            local v=tonumber(inp.Text)
            if v then
                Settings[txt]=v
                callback(v)
            end
        end)
    end
end

local function DisconnectAll(t)
    for k,v in pairs(t)do pcall(function()if typeof(v)=="RBXScriptConnection"then v:Disconnect()else v:remove()end end)t[k]=nil end
end

local globalCons,espTable,FlyB,SpecCon={}, {}, nil, nil

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

do
    for sec in pairs(SectionInfo)do
        CreateSection(sec,SectionOffsets[sec])
        for j,opt in ipairs(SectionInfo[sec])do
            local oy=SectionOffsets[sec]+39*j
            if opt=="Aimbot" then
                CreateButton(oy,opt,"Toggle",function(on)
                    if on then
                        DisconnectAll({globalCons.aimbot})
                        globalCons.aimbot=RSrv.RenderStepped:Connect(function()
                            if not Settings["Aimbot"] then return end
                            local enemy=getClosestEnemy()
                            if enemy and enemy.Character and enemy.Character:FindFirstChild("Head") then
                                CC.CFrame=CFrame.new(CC.CFrame.Position,enemy.Character.Head.Position)
                            end
                        end)
                        Notify("Aimbot Aktif")
                    else
                        DisconnectAll({globalCons.aimbot});Notify("Aimbot Kapalı")
                    end
                end)
            elseif opt=="SilentAim" then
                CreateButton(oy,opt,"Toggle",function(on)
                    if on then
                        if not globalCons.saimhook then
                            globalCons.saimhook = hookmetamethod(game,"__namecall",function(self,...)
                                local m=getnamecallmethod()local args={...}
                                if m=="FireServer" and Settings["SilentAim"] and type(args[1])=="Vector3" then
                                    local en=getClosestEnemy()
                                    if en and en.Character and en.Character:FindFirstChild("Head") then
                                        args[1]=en.Character.Head.Position
                                    end
                                end
                                return globalCons.saimhook(self,unpack(args))
                            end)
                        end
                        Notify("SilentAim Açık")
                    else
                        if globalCons.saimhook then
                            globalCons.saimhook=nil
                        end
                        Notify("SilentAim Kapalı")
                    end
                end)
            elseif opt=="Spinbot" then
                CreateButton(oy,opt,"Toggle",function(on)
                    if on then
                        DisconnectAll({globalCons.spinloop})
                        globalCons.spinloop=RSrv.RenderStepped:Connect(function(dt)
                            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                                LP.Character.HumanoidRootPart.CFrame=LP.Character.HumanoidRootPart.CFrame*CFrame.Angles(0,21*dt,0)
                            end
                        end)
                        Notify("Spinbot Açık")
                    else
                        DisconnectAll({globalCons.spinloop});Notify("Spinbot Kapalı")
                    end
                end)
            elseif opt=="Fov Changer" then
                Settings[opt]=CC.FieldOfView
                CreateButton(oy,opt,"Input",function(val)
                    if type(val)=="number" then CC.FieldOfView=val Notify("FOV: "..val) end
                end)
            elseif opt=="ESP" then
                CreateButton(oy,opt,"Toggle",function(on)
                    if on then
                        DisconnectAll({globalCons.esp})
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
                        DisconnectAll({globalCons.esp})
                        for _,obj in pairs(espTable)do pcall(function()obj:Remove()end)end
                        espTable={}
                        Notify("ESP Kapatıldı")
                    end
                end)
            elseif opt=="Spectate Player" then
                CreateButton(oy,opt,"Button",function()
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
                end)
            elseif opt=="Explode" then
                CreateButton(oy,opt,"Button",function()
                    PickPlayerPopup(function(pl)
                        if pl and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                            local ex=Instance.new("Explosion")
                            ex.Position=pl.Character.HumanoidRootPart.Position
                            ex.BlastRadius=8
                            ex.BlastPressure=1.4e7
                            ex.Parent=WSP
                            Notify(pl.Name.." Patlatıldı")
                        end
                    end)
                end)
            elseif opt=="Fly" then
                CreateButton(oy,opt,"Toggle",function(on)
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
                        Notify("Fly Aktif")
                    else
                        if FlyB then FlyB:Destroy();FlyB=nil end
                        if globalCons.flymove then globalCons.flymove:Disconnect()end
                        if globalCons.flystop then globalCons.flystop:Disconnect()end
                        Notify("Fly Kapatıldı")
                    end
                end)
            elseif opt=="Teleport" then
                CreateButton(oy,opt,"Button",function()
                    PickPlayerPopup(function(pl)
                        if pl and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                            LP.Character.HumanoidRootPart.CFrame=pl.Character.HumanoidRootPart.CFrame+Vector3.new(0,4,0)
                            Notify("Işınlandın > "..pl.Name)
                        end
                    end)
                end)
            elseif opt=="Yanına Teleport" then
                CreateButton(oy,opt,"Button",function()
                    PickPlayerPopup(function(pl)
                        if pl and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                            pl.Character.HumanoidRootPart.CFrame=LP.Character.HumanoidRootPart.CFrame+Vector3.new(2,3,0)
                            Notify(pl.Name.." yanınıza çekildi")
                        end
                    end)
                end)
            elseif opt=="Noclip" then
                CreateButton(oy,opt,"Toggle",function(on)
                    if on then
                        DisconnectAll({globalCons.noclip})
                        globalCons.noclip=RSrv.Stepped:Connect(function()
                            if LP.Character then
                                for _,v in ipairs(LP.Character:GetDescendants()) do
                                    if v:IsA("BasePart") then v.CanCollide=false end
                                end
                            end
                        end)
                        Notify("Noclip Aktif")
                    else
                        DisconnectAll({globalCons.noclip})
                        Notify("Noclip Kapalı")
                    end
                end)
            elseif opt=="No Reload" then
                CreateButton(oy,opt,"Toggle",function(on)
                        for _,itm in pairs(LP.Backpack:GetChildren()) do
                            if itm and itm:FindFirstChild("Ammo") and itm:FindFirstChild("Reload") then
                                 itm.Ammo.Value=99999999
                                 itm.Reload.Disabled=on
                            end
                        end
                        Notify(on and "No Reload Açık" or "No Reload Kapalı")
                    end)
            elseif opt=="Godmode" then
                CreateButton(oy,opt,"Toggle",function(on)
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
                end)
            elseif opt=="Rejoin" then
                CreateButton(oy,opt,"Button",function()
                    TS:Teleport(game.PlaceId)
                end)
            elseif opt=="Reset Character" then
                CreateButton(oy,opt,"Button",function()
                    if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
                        LP.Character:BreakJoints()
                        Notify("Resetlendi")
                    end
                end)
            end
        end
    end
end

local SelectAll=deepProtect(Instance.new("TextButton",MainFrm))
SelectAll.Size=UDim2.new(0,198,0,36)
SelectAll.Position=UDim2.new(0.53,0,0.915,0)
SelectAll.BackgroundColor3=Color3.fromRGB(77,25,25)
SelectAll.TextColor3=Color3.fromRGB(255,255,255)
SelectAll.TextSize=17;SelectAll.Font=Enum.Font.SourceSansBold
SelectAll.Text="TÜM HİLELERİ AÇ / KAPAT"
SelectAll.MouseButton1Click:Connect(function()
    local allActive=true
    for k,v in pairs(Settings)do if type(v)=="boolean" and not v then allActive=false break end end
    for name,btn in pairs(BtnUI)do
        if type(Settings[name])=="boolean" then
            Settings[name]=not allActive
            btn.Text=Settings[name] and "Açık" or "Kapalı"
            btn.BackgroundColor3=Settings[name] and Color3.fromRGB(255,36,60) or Color3.fromRGB(60,60,60)
        end
    end
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
