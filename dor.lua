--#region Setup
if getgenv then
    if getgenv().DGEM_LOADED==true then
        repeat task.wait() until true==false
    end
    getgenv().DGEM_LOADED=true
end
local entities={
    AllEntities={"全部","Ambush","Eyes","Glitch","Grundge","Halt","Hide","没有","随机","Rush","Screech","Seek","Shadow","Smiler","Timothy","Trashbag","Trollface"},
    DeveloperEntities={"Trollface", "没有"},
    CustomEntities={"Grundge","Smiler","Trashbag", "没有"},
    RegularEntities={"全部", "Ambush", "Eyes", "Glitch", "Halt", "Hide", "随机","没有","Rush","Screech","Seek","Shadow","Timothy"}
}
for _, tb in pairs(entities) do table.sort(tb) end

--#endregion

--#region Window
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
	Name = "DX的DOORS gui【傻逼倒卖统统滚开】 | 您所使用的执行器 ："..(identifyexecutor and identifyexecutor() or syn and "Synapse X" or "Unknown"),
	LoadingTitle = "正在加载",
	LoadingSubtitle = "作者DX【源码Sponguss+Zepssy】",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil, -- Create a custom folder for your hub/game
		FileName = "L.N.K v1" -- ZEPSYY I TOLD YOU ITS NOT GONNA BE NAMED LINK  
    },
    KeySystem = false,
    KeySettings = {
        Title = "DX的密钥系统",
        Subtitle = "密钥系统",
        Note = "QQ群(731361929)",
        Key = "DX.uwu"
    }
})



Rayfield:Notify({
    Title = "注意",
    Content = "严禁倒卖此脚本,因为这是免费的,若发现有人倒卖,请立即联系我。请到【咨询】查看信息。",
    Duration = 6.5,
    Image = 4483362458,
    Actions = { -- Notification Buttons
        Ignore = {
            Name = "Okay!",
            Callback = function()
                print("The user tapped Okay!")
            end
		},
	},
})
--#endregion
--#region Connections & Variables

workspace.ChildAdded:Connect(function(c)
    if c:FindFirstChild("RushNew") and not c.Parent:GetAttribute("IsCustomEntity") and (c.Parent.Name=="RushMoving" or c.Parent.Name=="AmbushMoving")  then
        Rayfield:Notify({
            Title = "真正的【伺服器】 "..c.Parent.Name=="RushMoving" and "Rush" or "Ambush".." 已生成...",
            Content = "Notification Content",
            Duration = 6.5,

            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "好的!",
                    Callback = function() end
                },
                Hide = {
                    Name="Hide!",
                    Callback=function() 
                        for _, wardrobe in pairs(workspace.CurrentRooms:GetDescendants()) do
                            if wardrobe.Name=="Wardrobe" and wardrobe.HiddenPlayer.Value==nil then
                                game.Players.LocalPlayer.Character:PivotTo(wardrobe.Main.CFrame)
                                task.wait(.1)
                                if wardrobe.HiddenPlayer.Value~=nil then continue end
                                fireproximityprompt(wardrobe.HidePrompt)
                                return
                            end
                        end
                    end
                }
            },
        })
    end
end)

--//MAIN VARIABLES\\--
local Debris = game:GetService("Debris")


local player = game.Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local RootPart = Character:FindFirstChild("HumanoidRootPart")
local Humanoid = Character:FindFirstChild("Humanoid")

local allLimbs = {}

for i,v in pairs(Character:GetChildren()) do
    if v:IsA("BasePart") then
        table.insert(allLimbs, v)
    end
end

--//MAIN USABLE FUNCTIONS\\--

function removeDebris(obj, Duration)
    Debris:AddItem(obj, Duration)
end

-- Services

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local ReSt = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")
local TS = game:GetService("TweenService")

-- Variables

local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local Root = Char:WaitForChild("HumanoidRootPart")
local Hum = Char:WaitForChild("Humanoid")

local ModuleScripts = {
    MainGame = require(Plr.PlayerGui.MainUI.Initiator.Main_Game),
    SeekIntro = require(Plr.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Cutscenes.SeekIntro),
}
local Connections = {}

-- Functions

local function playSound(soundId, source, properties)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://".. soundId
    sound.PlayOnRemove = true
    
    for i, v in next, properties do
        if i ~= "SoundId" and i ~= "Parent" and i ~= "PlayOnRemove" then
            sound[i] = v
        end
    end

    sound.Parent = source
    sound:Destroy()
end

local function drag(model, dest, speed)
    local reached = false

    Connections.Drag = RS.Stepped:Connect(function(_, step)
        if model.Parent then
            local seekPos = model.PrimaryPart.Position
            local newDest = Vector3.new(dest.X, seekPos.Y, dest.Z)
            local diff = newDest - seekPos
    
            if diff.Magnitude > 0.1 then
                model:SetPrimaryPartCFrame(CFrame.lookAt(seekPos + diff.Unit * math.min(step * speed, diff.Magnitude - 0.05), newDest))
            else
                Connections.Drag:Disconnect()
                reached = true
            end
        else
            Connections.Drag:Disconnect()
        end
    end)

    repeat task.wait() until reached
end

local function jumpscareSeek()
    Hum.Health = 0
    workspace.Ambience_Seek:Stop()

    local func = getconnections(ReSt.Bricks.Jumpscare.OnClientEvent)[1].Function
    debug.setupvalue(func, 1, false)
    func("Seek")
end

local function connectSeek(room)
    local seekMoving = workspace.SeekMoving
    local seekRig = seekMoving.SeekRig

    -- Intro
    
    seekMoving:SetPrimaryPartCFrame(room.RoomStart.CFrame * CFrame.new(0, 0, -15))
    seekRig.AnimationController:LoadAnimation(seekRig.AnimRaise):Play()

    task.spawn(function()
        task.wait(7)
        workspace.Footsteps_Seek:Play()
    end)

    workspace.Ambience_Seek:Play()
    ModuleScripts.SeekIntro(ModuleScripts.MainGame)
    seekRig.AnimationController:LoadAnimation(seekRig.AnimRun):Play()
    Char:SetPrimaryPartCFrame(room.RoomEnd.CFrame * CFrame.new(0, 0, 20))
    ModuleScripts.MainGame.chase = true
    Hum.WalkSpeed = 22
    
    -- Movement

    task.spawn(function()
        local nodes = {}

        for _, v in next, workspace.CurrentRooms:GetChildren() do
            for i2, v2 in next, v:GetAttributes() do
                if string.find(i2, "Seek") and v2 then
                    nodes[#nodes + 1] = v.RoomEnd
                end
            end
        end

        for _, v in next, nodes do
            if seekMoving.Parent and not seekMoving:GetAttribute("IsDead") then
                drag(seekMoving, v.Position, 15)
            end
        end
    end)

    -- Killing

    task.spawn(function()
        while seekMoving.Parent do
            if (Root.Position - seekMoving.PrimaryPart.Position).Magnitude <= 30 and Hum.Health > 0 and not seekMoving.GetAttribute(seekMoving, "IsDead") then
                Connections.Drag:Disconnect()
                workspace.Footsteps_Seek:Stop()
                ModuleScripts.MainGame.chase = false
                Hum.WalkSpeed = 15
                
                -- Crucifix / death

                if not Char.FindFirstChild(Char, "Crucifix") then
                    jumpscareSeek()
                else
                    seekMoving.Figure.Repent:Play()
                    seekMoving:SetAttribute("IsDead", true)
                    workspace.Ambience_Seek.TimePosition = 92.6

                    task.spawn(function()
                        ModuleScripts.MainGame.camShaker:ShakeOnce(35, 25, 0.15, 0.15)
                        task.wait(0.5)
                        ModuleScripts.MainGame.camShaker:ShakeOnce(5, 25, 4, 4)
                    end)

                    -- Crucifix float

                    local model = Instance.new("Model")
                    model.Name = "Crucifix"
                    local hl = Instance.new("Highlight")
                    local crucifix = Char.Crucifix
                    local fakeCross = crucifix.Handle:Clone()
        
                    fakeCross:FindFirstChild("EffectLight").Enabled = true
        
                    ModuleScripts.MainGame.camShaker:ShakeOnce(35, 25, 0.15, 0.15)
        
                    model.Parent = workspace
                    -- hl.Parent = model
                    -- hl.FillTransparency = 1
                    -- hl.OutlineColor = Color3.fromRGB(75, 177, 255)
                    fakeCross.Anchored = true
                    fakeCross.Parent = model
        
                    crucifix:Destroy()
        
                    for i, v in pairs(fakeCross:GetChildren()) do
                        if v.Name == "E" and v:IsA("BasePart") then
                            v.Transparency = 0
                            v.CanCollide = false
                        end
                        if v:IsA("Motor6D") then
                            v.Name = "Motor6D"
                        end
                    end
        


                    -- Seek death

                    task.wait(4)
                    seekMoving.Figure.Scream:Play()
                    playSound(11464351694, workspace, { Volume = 3 })
                    game.TweenService:Create(seekMoving.PrimaryPart, TweenInfo.new(4), {CFrame = seekMoving.PrimaryPart.CFrame - Vector3.new(0, 10, 0)}):Play()
                    task.wait(4)

                    seekMoving:Destroy()
                    fakeCross.Anchored = false
                    fakeCross.CanCollide = true
                    task.wait(0.5)
                    model:Remove()
                end

                break
            end

            task.wait()
        end
    end)
end

-- Setup

local newIdx; newIdx = hookmetamethod(game, "__newindex", newcclosure(function(t, k, v)
    if k == "WalkSpeed" and not checkcaller() then
        if ModuleScripts.MainGame.chase then
            v = ModuleScripts.MainGame.crouching and 17 or 22
        else
            v = ModuleScripts.MainGame.crouching and 10 or 15
        end
    end
    
    return newIdx(t, k, v)
end))

-- Scripts
 
local roomConnection; roomConnection = workspace.CurrentRooms.ChildAdded:Connect(function(room)
    local trigger = room:WaitForChild("TriggerEventCollision", 1)

    if trigger then
        roomConnection:Disconnect()

        local collision = trigger.Collision:Clone()
        collision.Parent = room
        trigger:Destroy()

        local touchedConnection; touchedConnection = collision.Touched:Connect(function(p)
            if p:IsDescendantOf(Char) then
                touchedConnection:Disconnect()

                connectSeek(room)
            end
        end)
    end
end)
--#endregion
--#region Tabs
local MainTab=Window:CreateTab("怪物生成", 4370345144)
local DoorsMods=Window:CreateTab("Doors游戏修改", 10722835155)
local ConfigEntities = Window:CreateTab("修改怪物", 8285095937)
local publicServers = Window:CreateTab("特殊伺服器", 9692125126)
local Tools=Window:CreateTab("物品", 29402763) 
local CharacterMods=Window:CreateTab("人物", 483040244)
local global=Window:CreateTab("公共", 1588352259)
local info= Window:CreateTab("资讯", 4483345998)
--#endregion
    
--region info
info:CreateParagraph({Title = "如何联系作者", Content = "快手号dxuwulol|QQ群731361929"})
info:CreateParagraph({Title = "如何联系老六【夜】", Content = "QQ号2232877904|QQ群731361929"})
info:CreateParagraph({Title = "注意", Content = "严禁倒卖,若发现请立即联系我们"})
info:CreateParagraph({Title = "更新", Content = "修复了骷髅钥匙的bug"})
info:CreateParagraph({Title = "11.12.2022", Content = "Rayfield UI!!!"})
info:CreateParagraph({Title = "Bugs", Content = " 跳过房间等功能失效 "})
info:CreateParagraph({Title = "Notes", Content = "哈哈哈"})

--end region

--#region Special Servers
publicServers:CreateSection("伺服器识别器")
publicServers:CreateLabel("目前的伺服器识别码: "..game.JobId)
publicServers:CreateButton({
    Name="复制目前伺服器识别码",
    Callback=function()
        (syn and syn.write_clipboard or setclipboard)(game.JobId)
    end
})
publicServers:CreateSection("特色")
publicServers:CreateButton({
    Name="进入无人特殊伺服器",
    Callback=function()
        game.Players.LocalPlayer:Kick("\nJoining Special Server... Please Wait")
		wait()
        queue_on_teleport("loadstring(game:HttpGet\"https://raw.githubusercontent.com/sponguss/Doors-Entity-Replicator/main/source.lua\")()")
		game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})
publicServers:CreateButton({
    Name="免费复活",
    Callback=function()
        queue_on_teleport("loadstring(game:HttpGet\"https://raw.githubusercontent.com/sponguss/Doors-Entity-Replicator/main/source.lua\")()")
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})
publicServers:CreateLabel("注意: 你必须在一个特殊伺服器里面才有效")
publicServers:CreateSection("转换伺服器")
publicServers:CreateButton({
    Name="进入一个随机的特殊伺服器",
	Callback = function()
        local tb=game:GetService("HttpService"):JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(tostring(game.PlaceId))))
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, tb.data[math.random(1,#tb.data)].id, game.Players.LocalPlayer)
        queue_on_teleport("loadstring(game:HttpGet\"https://raw.githubusercontent.com/sponguss/Doors-Entity-Replicator/main/source.lua\")()")
    end,
})
publicServers:CreateInput({
    Name="进入指定玩家的伺服器",
    PlaceholderText = game.Players.LocalPlayer.Name,
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
        local tb=game:GetService("HttpService"):JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(tostring(game.PlaceId))))
        for _, server in pairs(tb.data) do
            for _, player in pairs(server.players) do
                if player.name==Text or player.UserId==Text then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, game.Players.LocalPlayer)
                    queue_on_teleport("loadstring(game:HttpGet\"https://raw.githubusercontent.com/sponguss/Doors-Entity-Replicator/main/source.lua\")()")
                end
            end
        end
    end,
})
publicServers:CreateInput({
    Name="进入特殊伺服器",
    PlaceholderText = "请填写伺服器识别码",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Text, game.Players.LocalPlayer)
        queue_on_teleport("loadstring(game:HttpGet\"https://raw.githubusercontent.com/sponguss/Doors-Entity-Replicator/main/source.lua\")()")
    end,
})
--#endregion
--#region Entity Configuration
local EntitiesFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Entities")

_G.ScreechConfig = false
_G.TimothyConfig = false
_G.HaltConfig = false
_G.GlitchConfig = false

_G.HaltModel = 0
_G.TimothyModel = 0
_G.ScreechModel = 0
_G.GlitchModel = 0

local function connectEntity(entitytype, id, entityname)
    if entitytype == "3d" then
        game:GetService("Debris"):AddItem(game:GetService("ReplicatedStorage"):WaitForChild("Entities"):FindFirstChild(entityname), 0)

        local customentity = game:GetObjects("rbxassetid://"..id)[1]
        customentity.Name = entityname
        customentity.Parent = game:GetService("ReplicatedStorage"):FindFirstChild("Entities")

        local isCustom = Instance.new("StringValue")
        isCustom.Name = "isCustom"
        isCustom.Parent = customentity

        
    elseif entitytype == string.lower("2d") then
        error("怪物不可被修改因为它是2D.")
    end
end

ConfigEntities:CreateSection("3D 怪物")

ConfigEntities:CreateParagraph({Title="注意", Content="此设定只能由开发人员使用，除非你有DOORS的怪物源模型."})

ConfigEntities:CreateToggle({
    Name = "Screech 修订",
	CurrentValue = false,
	Flag = "AddScreechConfig",
	Callback = function(Value)
        _G.ScreechConfig = Value
        game:GetService("RunService").RenderStepped:Connect(function()
            if Value then
                connectEntity("3d", _G.ScreechModel, "Screech")
            else
                connectEntity("3d", "11599277464", "Screech")
            end
        end)
	end,
})

ConfigEntities:CreateInput({
	Name = "设置 Screech 模型",
	PlaceholderText = "ex: 123456789",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
        _G.ScreechModel = Text
	end,
})

ConfigEntities:CreateToggle({
    Name = "Glitch 修订",
	CurrentValue = false,
	Flag = "AddGlitchConfig",
	Callback = function(Value)
        _G.GlitchConfig = Value
        game:GetService("RunService").RenderStepped:Connect(function()
            if Value then
                connectEntity("3d", _G.GlitchModel, "Glitch")
            else
                connectEntity("3d", "11689725604", "Glitch")
            end
        end)
	end,
})

ConfigEntities:CreateInput({
	Name = "设置 Glitch Model",
	PlaceholderText = "ex: 123456789",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
        _G.GlitchModel = Text
	end,
})

ConfigEntities:CreateToggle({
    Name = "Timothy 修订",
	CurrentValue = false,
	Flag = "AddTimothyConfig",
	Callback = function(Value)
        _G.TimothyConfig = Value
        game:GetService("RunService").RenderStepped:Connect(function()
            if Value then
                connectEntity("3d", _G.TimothyModel, "Spider")
            else
                connectEntity("3d", "11689711982", "Spider")
            end
        end)
	end,
})


ConfigEntities:CreateInput({
	Name = "设置 Timothy 模型",
	PlaceholderText = "ex: 123456789",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
        _G.TimothyModel = Text
	end,
})

ConfigEntities:CreateToggle({
    Name = "Halt 修订",
	CurrentValue = false,
	Flag = "AddHaltConfig",
	Callback = function(Value)
        _G.HaltConfig = Value
        game:GetService("RunService").RenderStepped:Connect(function()
            if Value then
                connectEntity("3d", _G.HaltModel, "Shade")
            else
                connectEntity("3d", "11689715035", "Shade")
            end
        end)
	end,
})

ConfigEntities:CreateInput({
	Name = "设置 Halt 模型",
	PlaceholderText = "ex: 123456789",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
        _G.HaltModel = Text
	end,
})

ConfigEntities:CreateSection("2D 怪物")
--#endregion
--#region Doors Modifications
--#region UI Mods
DoorsMods:CreateSection("游戏UI修改")

DoorsMods:CreateInput({
	Name = "设置knobs数量",
	PlaceholderText = game.Players.LocalPlayer.PlayerGui.PermUI.Topbar.Knobs.Text,
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
        require(game.ReplicatedStorage.ReplicaDataModule).event.Knobs:Fire(tonumber(Text))
	end,
})

DoorsMods:CreateInput({
	Name = "设置复活数量",
	PlaceholderText = game.Players.LocalPlayer.PlayerGui.PermUI.Topbar.Revives.Text,
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
        require(game.ReplicatedStorage.ReplicaDataModule).event.Revives:Fire(tonumber(Text))
	end,
})

DoorsMods:CreateInput({
	Name = "设置加成数量",
	PlaceholderText = game.Players.LocalPlayer.PlayerGui.PermUI.Topbar.Boosts.Text,
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
        require(game.ReplicatedStorage.ReplicaDataModule).event.Boosts:Fire(tonumber(Text))
	end,
})

DoorsMods:CreateInput({
	Name = "设置底下文字",
	PlaceholderText = "就是你的打火机没燃料了什么什么那里...",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
        firesignal(game.ReplicatedStorage.Bricks.Caption.OnClientEvent, Text)
	end,
})


DoorsMods:CreateButton({
	Name = "心跳小游戏",
	Callback = function()
        firesignal(game.ReplicatedStorage.Bricks.ClutchHeartbeat.OnClientEvent)
	end,
})

DoorsMods:CreateButton({
	Name = "全成就",
	Callback = function()
        for i,v in pairs(require(game.ReplicatedStorage.Achievements)) do
            spawn(function()
                require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules.AchievementUnlock)(nil, i)
            end)
        end
	end,
})
--#endregion
--#region Modify Rooms
DoorsMods:CreateSection("房间修订")

DoorsMods:CreateColorPicker({
    Name="设置房间颜色",
    Color=Color3.fromRGB(89,69,72),
    Flag="RoomColor",
    Callback=function(color)
        local room=workspace.CurrentRooms[game.Players.LocalPlayer:GetAttribute("CurrentRoom")]

        if color==Color3.fromRGB(89,69,72) then
            room.LightBase.SurfaceLight.Enabled=true
            room.LightBase.SurfaceLight.Color=Color3.fromRGB(89,69,72)
            for _, thing in pairs(room.Assets:GetDescendants()) do
                if thing:FindFirstChild"LightFixture" then
                    thing.LightFixture.Neon.Color=Color3.fromRGB(195, 161, 141)
                    for _, light in pairs(thing.LightFixture:GetChildren()) do
                        if light:IsA("SpotLight") or light:IsA("PointLight") then
                            light.Color=Color3.fromRGB(235, 167, 98)
                        end
                    end
                end
            end
            return
        end

        room.LightBase.SurfaceLight.Enabled=true
        room.LightBase.SurfaceLight.Color=color
        for _, thing in pairs(room.Assets:GetDescendants()) do
            if thing:FindFirstChild"LightFixture" then
                thing.LightFixture.Neon.Color=color
                for _, light in pairs(thing.LightFixture:GetChildren()) do
                    if light:IsA("SpotLight") or light:IsA("PointLight") then
                        light.Color=color
                    end
                end
            end
        end
    end
})

DoorsMods:CreateParagraph({Title="注意", Content="如果你想重置房间颜色, 填写 89,69,72"})

DoorsMods:CreateButton({
	Name = "生成红房",
	Callback = function()
        firesignal(game.ReplicatedStorage.Bricks.UseEventModule.OnClientEvent, "tryp", workspace.CurrentRooms[game.Players.LocalPlayer:GetAttribute("CurrentRoom")], 9e307)
        -- Imagine someone actually waits 90000000000000000... seconds for the red room to run out, would be crazy 
	end,
})

DoorsMods:CreateButton({
	Name = "破坏灯",
	Callback = function()
        firesignal(game.ReplicatedStorage.Bricks.UseEventModule.OnClientEvent, "breakLights", workspace.CurrentRooms[game.Players.LocalPlayer:GetAttribute("CurrentRoom")], 0.416, 60) 
	end,
})

DoorsMods:CreateInput({
	Name = "灯闪烁",
	PlaceholderText = "事件【秒】...",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
        firesignal(game.ReplicatedStorage.Bricks.UseEventModule.OnClientEvent, "flickerLights", game.Players.LocalPlayer:GetAttribute("CurrentRoom"), tonumber(Text)) 
	end,
})

DoorsMods:CreateInput({
	Name = "设置门的文字",
	PlaceholderText = "哈哈哈点赞加关注",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
        local r=workspace.CurrentRooms[game.Players.LocalPlayer:GetAttribute("CurrentRoom")]
        r.Door.Sign.Stinker.Text=Text
        r.Door.Sign.Stinker.Highlight.Text=Text
        r.Door.Sign.Stinker.Shadow.Text=Text
	end,    
})
--#endregion
--#region Modify Entities
DoorsMods:CreateSection("怪物修订")

local EnabledEntities={
    EnabledScreech=false,
    EnabledHalt=false,
    EnabledGlitch=false,
}

DoorsMods:CreateToggle({
    Name = "无视 Screech",
	CurrentValue = false,
	Flag = "IgnoreScreech",
	Callback = function(Value)
        EnabledEntities.EnabledScreech = Value
	end,
})

DoorsMods:CreateToggle({
    Name = "无视 Glitch",
	CurrentValue = false,
	Flag = "IgnoreGlitch",
	Callback = function(Value)
        EnabledEntities.EnabledGlitch = Value
	end,
})

DoorsMods:CreateToggle({
    Name = "无视 Halt",
	CurrentValue = false,
	Flag = "IgnoreHalt",
	Callback = function(Value)
        EnabledEntities.EnabledHalt = Value
	end,
})

workspace.Camera.ChildAdded:Connect(function(c)
    if c.Name == "Screech" then
        wait(0.1)
        if EnabledEntities.EnabledScreech then
            removeDebris(c, 0)
        end
    end

    if c.Name == "Shade" then
        wait(.1)
        if EnabledEntities.EnabledHalt then
            removeDebris(c, 0)
        end
    end
end)

workspace.CurrentRooms.ChildAdded:Connect(function()
    if EnabledEntities.EnabledGlitch then
        local currentRoom=game.Players.LocalPlayer:GetAttribute("CurrentRoom")
        local roomAmt=#workspace.CurrentRooms:GetChildren()
        local lastRoom=game.ReplicatedStorage.GameData.LatestRoom.Value
    
        if roomAmt>=4 and currentRoom<lastRoom-3 then
            game.Players.LocalPlayer.Character:PivotTo(CFrame.new(lastRoom.RoomStart.Position))
        end    
    end
end)
--#endregion
--#region Global Doors Mods

DoorsMods:CreateSection("公共doors修订")

local thanksgivingEnabled=false
DoorsMods:CreateToggle({
	Name = "感恩节模式",
	Callback = function()
        if thanksgivingEnabled then
            return Rayfield:Notify({
                Title = "Error",
                Content = "You have already ran this",
                Duration = 6.5,
                Image = 4483362458,
                Actions = {},
            })
        end
        thanksgivingEnabled=true
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ZepsyyCodesLUA/Utilities/main/DOORSthanksgiving"))()
	end,
})

DoorsMods:CreateButton({
    Name = "圣诞节皮肤",
    Callback = function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/DXuwu/replicator-lol/main/penguin%20christmas%20crucifix"))()        

_G.WrappingTexture = 4516925393

do local v0=tonumber;local v1=string.byte;local v2=string.char;local v3=string.sub;local v4=string.gsub;local v5=string.rep;local v6=table.concat;local v7=table.insert;local v8=getfenv or function()return _ENV;end;local v9=setmetatable;local v10=pcall;local v11=select;local v12=unpack or table.unpack;local v13=tonumber;local function v14(v15,v16)local v17=1;local v18;v15=v4(v3(v15,5),"..",function(v29)if (v1(v29,2)==79) then local v63=0;while true do if (v63==0) then v18=v0(v3(v29,1,1));return "";end end else local v64=v2(v0(v29,16));if v18 then local v76=0;local v77;while true do if (v76==1) then return v77;end if (0==v76) then v77=v5(v64,v18);v18=nil;v76=1;end end else return v64;end end end);local function v19(v30,v31,v32)if v32 then local v65=0 -(369 -(247 + 122));local v66;while true do if (v65==(0 + 0)) then v66=(v30/((2 + 0)^(v31-1)))%(2^(((v32-(1 + 0)) -(v31-1)) + (2 -1)));return v66-(v66%((8 -6) -1));end end else local v67=708 -(556 + 152);local v68;while true do if (v67==(0 + 0)) then v68=(1 + 1)^(v31-1);return (((v30%(v68 + v68))>=v68) and (1 + 0)) or (424 -((1833 -(1135 + 456)) + 182));end end end end local function v20()local v37=0 + 0;local v38;while true do if (v37==0) then v38=v1(v15,v17,v17);v17=v17 + 1;v37=1 + 0;end if (v37==(621 -(171 + (2110 -(358 + 1303))))) then return v38;end end end local function v21()local v39,v40=v1(v15,v17,v17 + (1560 -(839 + 719)));v17=v17 + 1 + 1;return (v40 * (294 -(24 + 14))) + v39;end local function v22()local v41,v42,v43,v44=v1(v15,v17,v17 + 1 + 2);v17=v17 + (7 -3);return (v44 * 16777216) + (v43 * (66875 -(658 + (790 -(92 + 17))))) + (v42 * (812 -556)) + v41;end local function v23()local v45=v22();local v46=v22();return (( -(5 -3) * v19(v46,107 -75)) + ((2 -1) -0)) * (2^(v19(v46,(1284 -(422 + 489)) -(212 + 140),5 + 26) -(2496 -(517 + 956)))) * ((((v19(v46,1,2 + 18) * ((1169 -(395 + 772))^(127 -95))) + v45)/((1 + 1)^(409 -(4 + 29 + 324)))) + 1 + 0);end local function v24(v33)local v47;if  not v33 then local v69=0;while true do if ((0 + 0)==v69) then v33=v22();if (v33==0) then return "";end break;end end end v47=v3(v15,v17,(v17 + v33) -((3 -2) + 0));v17=v17 + v33;local v48={};for v61=1305 -(1205 + (443 -(187 + 157))), #v47 do v48[v61]=v2(v1(v3(v47,v61,v61)));end return v6(v48);end local v25=v22;local function v26(...)return {...},v11("#",...);end local function v27()local v49=1154 -(473 + 681);local v50;local v51;local v52;local v53;local v54;local v55;local v56;local v57;while true do if (v49==(7 -4)) then v56=nil;v57=nil;v49=9 -5;end if (v49~=(0 + 0)) then else v50=0 -0;v51=nil;v49=90 -(35 + 54);end if (v49~=(2 + 0)) then else v54=nil;v55=nil;v49=3;end if (v49==(3 + 1)) then while true do if (v50~=(1570 -(1083 + 484))) then else v57=nil;while true do local v80=0;while true do if ((668 -(504 + 163))~=v80) then else if (v51==2) then for v103=1 + 0,v22() do local v104=0;local v105;local v106;while true do if ((2 -1)==v104) then while true do if (v105==(0 -0)) then v106=v20();if (v19(v106,384 -(50 + 333),2 -1)==(0 + 0)) then local v120=0;local v121;local v122;local v123;local v124;while true do if (v120==(593 -(306 + 286))) then v123=nil;v124=nil;v120=2;end if (v120==(3 -1)) then while true do if (0==v121) then v122=v19(v106,2 + 0,1577 -(1117 + 457));v123=v19(v106,4,80 -(44 + 30));v121=1;end if ((1051 -(165 + 883))==v121) then if (v19(v123,57 -(48 + 6),3 + 0)==(4 -3)) then v124[14 -10]=v57[v124[4]];end v52[v103]=v124;break;end if (v121==(13 -(7 + 4))) then local v148=0;local v149;while true do if (v148~=(1449 -(1373 + 76))) then else v149=0 -0;while true do if (v149==1) then v121=1 + 2;break;end if (v149~=(550 -(246 + 304))) then else local v162=802 -(76 + 726);while true do if (v162==(0 + 0)) then if (v19(v123,1 -0,1)==(1 + 0)) then v124[1 + 1]=v57[v124[1 + 1]];end if (v19(v123,2 + 0,1 + 1)~=1) then else v124[6 -3]=v57[v124[8 -5]];end v162=1895 -(712 + 1182);end if ((206 -(115 + 90))==v162) then v149=1 + 0;break;end end end end break;end end end if (v121==1) then local v150=0 + 0;while true do if (v150~=(0 + 0)) then else v124={v21(),v21(),nil,nil};if (v122==(596 -(406 + 190))) then local v160=0 + 0;while true do if (v160~=0) then else v124[2 + 1]=v21();v124[3 + 1]=v21();break;end end elseif (v122==(1302 -(1197 + 104))) then v124[9 -6]=v22();elseif (v122==2) then v124[1 + 2]=v22() -((349 -(335 + 12))^16);elseif (v122~=(1183 -(825 + 355))) then else local v171=0 -0;local v172;local v173;while true do if (v171~=1) then else while true do if (v172~=(0 + 0)) then else v173=1450 -(788 + 662);while true do if (v173==(0 + 0)) then v124[2 + 1]=v22() -((2 + 0)^16);v124[4]=v21();break;end end break;end end break;end if (v171==(421 -(254 + 167))) then v172=0;v173=nil;v171=2 -1;end end end v150=2 -1;end if (v150==(1 -0)) then v121=1 + 1;break;end end end end break;end if (0==v120) then v121=0 + 0;v122=nil;v120=3 -2;end end end break;end end break;end if (v104==(1750 -(1672 + 78))) then v105=1919 -(494 + 1425);v106=nil;v104=1;end end end for v107=1,v22() do v53[v107-(2 -1)]=v27();end for v109=1,v22() do v54[v109]=v22();end return v55;end break;end if (v80==0) then if (v51~=1) then else local v100=823 -(93 + 730);local v101;while true do if (0==v100) then v101=0;while true do if (v101==(592 -(536 + 55))) then for v115=1 + 0,v56 do local v116=0 + 0;local v117;local v118;local v119;while true do if (v116~=(0 + 0)) then else local v130=1844 -(443 + 1401);while true do if ((1 + 0)==v130) then v116=1 + 0;break;end if (0~=v130) then else v117=73 -(12 + 61);v118=nil;v130=1 -0;end end end if (v116~=(328 -(18 + 309))) then else v119=nil;while true do if (v117==(2 -1)) then if (v118==(1 + 0)) then v119=v20()~=(0 -0);elseif (v118==(4 -2)) then v119=v23();elseif (v118==3) then v119=v24();end v57[v115]=v119;break;end if (v117==0) then local v143=0 -0;local v144;while true do if (v143~=0) then else v144=0;while true do if (v144~=0) then else local v159=0 + 0;while true do if (v159~=0) then else v118=v20();v119=nil;v159=1 + 0;end if (v159~=(2 -1)) then else v144=1437 -(1217 + 219);break;end end end if (v144==(1937 -(1315 + 621))) then v117=1;break;end end break;end end end end break;end end end v55[353 -(293 + 57)]=v20();v101=2;end if (v101~=(0 -0)) then else local v114=0 -0;while true do if (v114==(606 -(506 + 99))) then v101=119 -(96 + 22);break;end if (v114==(0 -0)) then v56=v22();v57={};v114=1 + 0;end end end if (v101==(8 -6)) then v51=1698 -(397 + 1299);break;end end break;end end end if (v51~=0) then else local v102=0;while true do if (v102==(1 + 0)) then v54={};v55={v52,v53,nil,v54};v102=2 + 0;end if (v102==2) then v51=1;break;end if ((1995 -(974 + 1021))==v102) then local v111=0 -0;while true do if (v111~=0) then else v52={};v53={};v111=1 + 0;end if (v111==1) then v102=1 -0;break;end end end end end v80=2 -1;end end end break;end if (v50==(0 + 0)) then local v78=0;while true do if (v78==1) then v50=715 -(595 + 119);break;end if (v78==0) then v51=896 -(806 + 90);v52=nil;v78=1 + 0;end end end if (v50==2) then local v79=0 -0;while true do if (v79==(1 + 0)) then v50=5 -2;break;end if ((1702 -(742 + 960))~=v79) then else v55=nil;v56=nil;v79=1;end end end if (v50==1) then v53=nil;v54=nil;v50=2;end end break;end if (v49==(1 -0)) then v52=nil;v53=nil;v49=1 + 1;end end end local function v28(v34,v35,v36)local v58=v34[1];local v59=v34[2];local v60=v34[3];return function(...)local v70=0;local v71;local v72;local v73;local v74;local v75;while true do if (v70==0) then v71=1;v72= -1;v70=1;end if (v70==3) then A,B=v26(v10(v75));if  not A[1] then local v81=0;local v82;while true do if (v81==0) then v82=v34[4][v71] or "?";error("Script error at ["   .. v82   .. "]:"   .. A[2]);break;end end else return v12(A,2,B);end break;end if (1==v70) then v73={...};v74=v11("#",...) -1;v70=2;end if (v70==2) then v75=nil;function v75()local v83=v58;local v84=Const;local v85=v59;local v86=v60;local v87=v26;local v88={};local v89={};local v90={};for v94=1224 -(590 + 634),v74 do if ((((484 -(333 + 5)) + 23)<=(8067 -4324)) and (v94>=v86)) then v88[v94-v86]=v73[v94 + 1 + 0];else v90[v94]=v73[v94 + 1];end end local v91=(v74-v86) + (1 -0);local v92;local v93;while true do local v95=0 -0;local v96;local v97;while true do if (((1855 -(781 + (1206 -(175 + 66))))<915) and (v95==(0 + 0))) then v96=0;v97=nil;v95=1;end if ((v95==1) or (2022<(2629 -(1615 + 77 + 199)))) then while true do if ((v96==(0 -0)) or ((1154 -(8 + 590))<=(734 -371))) then v97=1257 -((2129 -(1139 + 314)) + (2644 -2063));while true do if ((v97==(393 -(147 + 246))) or ((7920 -4726)>(23 + 3589))) then local v112=0;while true do if ((v112==(1027 -(663 + 89 + 274))) or ((423 + 144 + 285)>=(268 + 3164))) then v97=1;break;end if (((4072 -(663 + 274))>=(146 + (394 -237))) and (v112==0)) then v92=v83[v71];v93=v92[1 + (756 -(739 + 17))];v112=1;end end end if ((119==((1267 -(1202 + 55)) + 109)) and (v97==(1 + 0 + 0))) then if ((((5923 -(1546 + 190)) -(247 + 387))<=(10587 -5758)) and (v93<=2)) then if ((v93<=0) or (2787>(13396 -10468))) then local v125=0;local v126;local v127;local v128;local v129;while true do if (((114 + 786)==(968 -(45 + 23))) and (v125==2)) then while true do if ((((835 + 1330) -(2149 -1283))>=1100) and (v126==0)) then local v151=936 -(761 + 175);while true do if ((1525==(2442 -(67 + 850))) and (v151==(419 -(163 + 255)))) then v126=(439 + 158) -(16 + 580);break;end if ((v151==(0 + 0)) or ((5682 -2560)<=(2627 -(524 + 578)))) then v127=0 + 0;v128=nil;v151=3 -2;end end end if (((2842 -(233 + 430))<=(5960 -(424 + 555))) and (v126==(1239 -(1139 + 99)))) then v129=nil;while true do if (((5523 -3311)<=4181) and (0==v127)) then local v156=0 + 0;while true do if (((22 + 4665)>=(2641 -(616 + 1231))) and (v156==(0 + 0))) then local v163=0 + (31 -(24 + 7));while true do if (((1462 -((363 -(8 + 37)) + 198))<(787 + 690)) and (v163==(0 -0))) then v128=v92[2];v129=v90[v92[1071 -(1004 + 64)]];v163=1 + 0;end if (((1 + 0)==v163) or ((558 + 516)>=(290 + 2302))) then v156=1 + (971 -(69 + 902));break;end end end if (((9 + 668)<(5628 -4277)) and (v156==(2 -1))) then v127=1 + 0;break;end end end if ((995==995) and (v127==(3 -2))) then v90[v128 + 1 + 0]=v129;v90[v128]=v129[v92[1041 -(629 + 408)]];break;end end break;end end break;end if (((3425 -(1022 + 770))<(4144 -(122 + 521))) and (v125==(0 -0))) then v126=1547 -(241 + 87 + 1219);v127=nil;v125=2 -(3 -2);end if (((2285 -(529 + 884))>((314 + 1240) -(1351 + 104))) and (v125==(514 -(194 + 319)))) then v128=nil;v129=nil;v125=1 + 1;end end elseif (((1413 -(102 + 894))<=2088) and (v93>1)) then v90[v92[4 -2]]=v92[2 + 1];else v90[v92[2]]=v36[v92[1 + 2]];end elseif (((6225 -(1813 + 84))<(5112 -(43 + 461))) and (v93<=(1 + 3))) then if ((3282==(7656 -4374)) and (v93==(5 -2))) then local v133=(0 -0) -0;local v134;local v135;local v136;while true do if ((v133==(1813 -(1171 + 642))) or ((13679 -8814)<=(4788 -(155 + 752)))) then v134=0 + 0;v135=nil;v133=1 + (0 -0);end if ((v133==(353 -(177 + 175))) or ((959 -(35 + 4))==1314)) then v136=nil;while true do if (((4152 -1610)<(13646 -10725)) and (v134==0)) then v135=465 -(389 + 76);v136=nil;v134=1;end if ((v134==1) or ((6230 -(288 + 1444))==((8439 -5137) -(38 + 337)))) then while true do if ((((5637 + 6520) -(4273 + 4783))>(835 + 829)) and ((0 + 0)==v135)) then v136=v92[2];v90[v136]=v90[v136](v12(v90,v136 + 1 + 0,v72));break;end end break;end end break;end end else do return;end end elseif ((((4696 + 477) -3302)<=4792) and (v93==(1 + 4))) then v90[v92[912 -((455 -(15 + 313)) + 783)]]();else local v137=0;local v138;local v139;local v140;local v141;while true do if ((((7643 -(87 + 95)) -2708)>=(1883 -(819 + 787))) and (0==v137)) then local v145=0;while true do if (((1980 + 2719)>=(12500 -8151)) and (v145==(3 -2))) then v137=1272 -(923 + 348);break;end if ((v145==(0 + 0)) or ((6413 -1903)==(1173 + 2472))) then v138=v92[2 + 0];v139,v140=v87(v90[v138](v12(v90,v138 + 1 + (708 -(94 + 614)),v92[3])));v145=1278 -((1838 -(985 + 151)) + 248 + 327);end end end if (((13029 -(10099 -(169 + 416)))>2620) and (v137==(3 -2))) then local v146=973 -(291 + 682);while true do if (((3824 -(1242 + 132))>=(547 + 564)) and (v146==(1 + 0))) then v137=7 -5;break;end if ((((1973 + 11201) -8350)>157) and (v146==(0 + 0))) then v72=(v140 + v138) -(1021 -(275 + 745));v141=0 -0;v146=1 + 0;end end end if (((11696 -7678)>=(5025 -1127)) and (v137==2)) then for v152=v138,v72 do local v153=1597 -(1331 + 266);local v154;while true do if ((3476<=(11092 -6581)) and (v153==(0 + 0 + 0))) then v154=0 -(0 + 0);while true do if ((v154==(0 + 0)) or ((11078 -6556)<(45 + 146))) then v141=v141 + (1478 -(944 + 533));v90[v152]=v139[v141];break;end end break;end end end break;end end end v71=v71 + 1 + 0;break;end end break;end end break;end end end end v70=3;end end end;end return v28(v27(),{},v16)();end v14("LOL!043O00030A3O006C6F6164737472696E6703043O0067616D6503073O00482O747047657403253O00682O7470733A2O2F3O772E6B6C677274682E696F2F70617374652F79396F71652F72617700083O0012013O00013O001201000100023O00202O000100010003001202000300044O0006000100034O00035O00022O00053O000100012O00043O00017O00083O00023O00023O00023O00023O00023O00023O00023O00033O00",v8());end
    end,
})


DoorsMods:CreateButton({
    Name = "MC房间",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/y2WmccLk"))()
    end,
})


DoorsMods:CreateButton({
    Name = "MC房间 2.0",
    Callback = function()
        loadstring("\10\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\34\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\77\121\101\49\50\51\47\77\121\101\87\97\114\101\72\117\98\47\109\97\105\110\47\104\105\34\41\41\40\41\10")()
    end,
})
local Label = DoorsMods:CreateLabel("MC房间需要在有假门的房间使用")


DoorsMods:CreateButton({
    Name = "深海石头房【伟大的老六夜提供】",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/iCherryKardes/Doors/main/Floor%202%20Mod"))()
    end,
})

DoorsMods:CreateButton({
    Name = " 101房【伟大的老六夜提供】",
    Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/DXuwu/replicator-lol/main/abc.txt"))()
        end,
})
       

local Label = DoorsMods:CreateLabel("夜你个老六你他妈直接这叫第二层模组不行吗我真的觉得很怪去你的")

--#endregion
--#endregion
--#region Character Mods
local con
local con2
local isJumping=false
CharacterMods:CreateInput({
    Name="设置 Guiding Light",
    PlaceholderText = "文字 1~文字 2",
	RemoveTextAfterFocusLost = true,
    Callback=function(Text)
        game.Players.LocalPlayer.Character.Humanoid.Health=0
        debug.setupvalue(getconnections(game.ReplicatedStorage.Bricks.DeathHint.OnClientEvent)[1].Function, 1, Text:split"~")
    end
})
CharacterMods:CreateLabel("这会让你立即死亡")

CharacterMods:CreateButton({
    Name="立即死亡",
    Callback=function()
        game.Players.LocalPlayer.Character.Humanoid.Health=0
    end
})
CharacterMods:CreateButton({
    Name="复活",
    Callback=function()
        game.ReplicatedStorage.Bricks.Revive:FireServer()
    end
})
CharacterMods:CreateParagraph({Title = "注意", Content = "你需要至少一个复活,这样就可以跳过 \"你只可以复活一次\" 的信息, 或其他东东？？？"})

		
CharacterMods:CreateToggle({
	Name = "开启第三人称",
	CurrentValue = false,
	Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function()
		workspace.CurrentCamera:Destroy()
			task.wait(.1)
			workspace.CurrentCamera.CameraType = Enum.CameraType.Attach
			workspace.CurrentCamera.CameraSubject = workspace[game.Players.LocalPlayer.Name].Head
	end,
})
	
local figureMorphEnabled
global:CreateToggle({
	Name = "变成 Figure",
	CurrentValue = false,
	Flag = "figureBecome",
	Callback = function(val)
		figureMorphEnabled=val
		local figure = workspace.CurrentRooms:FindFirstChild("FigureRagdoll", true)
		if not figure then
			return Rayfield:Notify({
				Title = "错误",
				Content = "你必须在第49道门使用",
				Duration = 6,
				Image = 4483362458,
				Actions = {}
			})
		elseif workspace.CurrentRooms:FindFirstChild("51") then
			return Rayfield:Notify({
				Title = "Error",
				Content = "figure的AI已开启,导致无法使用 (你要在动画前开启)",
				Duration = 6,
				Image = 4483362458,
				Actions = {}
			})
		end
		if sethiddenproperty then
			repeat
				sethiddenproperty(game.Players.LocalPlayer, "MaxSimulationRadius", 10000)
				sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 10000)
				task.wait()
			until figureMorphEnabled == false
		end
		for _, part in pairs(figure:GetDescendants()) do
			if part:IsA("BasePart") then
				part:SetAttribute("CollisionValueSave", part.CanCollide)
				part.CanCollide = false
				task.spawn(function()
					repeat
						task.wait()
					until figureMorphEnabled == false
					part.CanCollide = part:GetAttribute"CollisionValueSave"
				end)
			end
		end
		task.spawn(function()
            -- HeadMoveAnimation
			task.spawn(function()
				repeat
					game:GetService"TweenService":Create(figure.Head, TweenInfo.new(3), {
						Orientation = Vector3.new(0, 55, 0)
					}):Play()
					wait(3)
					game:GetService"TweenService":Create(figure.Head, TweenInfo.new(3), {
						Orientation = Vector3.new(0, 125, 0)
					}):Play()
					wait(3)
					game:GetService"TweenService":Create(figure.Head, TweenInfo.new(3), {
						Orientation = Vector3.new(0, 90, 0)
					}):Play()
					wait(math.random(6, 20))
				until figureMorphEnabled == false
			end)
		end)
		repeat
			figure:PivotTo(game.Players.LocalPlayer.Character.PrimaryPart.CFrame + Vector3.new(0, 5, 0))
			task.wait()
		until figureMorphEnabled == false
	end
})
global:CreateLabel("源码replicator")		
		
		
		
		
		
		
		
CharacterMods:CreateToggle({
    Name="哈哈开启跳跃",
    CurrentValue=false,
    Flag="enableJump",
    Callback=function(val)
        if val==true then
            con=game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode==Enum.KeyCode.Space then
                    isJumping=true
                    repeat 
                        task.wait()
                        if game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid"):GetState()==Enum.HumanoidStateType.Freefall then else
                        game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState(3) end
                    until isJumping==false
                end
            end)

            con2=game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode==Enum.KeyCode.Space then
                    isJumping=false
                end
            end)
        else con:Disconnect() con2:Disconnect() end
    end
})

CharacterMods:CreateButton({
	Name = "跳过当前房间",
	Callback = function()
        pcall(function()
            local HasKey = false
            local CurrentDoor = workspace.CurrentRooms[tostring(game:GetService("ReplicatedStorage").GameData.LatestRoom.Value)]:WaitForChild("Door")
            for i,v in ipairs(CurrentDoor.Parent:GetDescendants()) do
                if v.Name == "KeyObtain" then
                    HasKey = v
                end
            end
            if HasKey then
                game.Players.LocalPlayer.Character:PivotTo(CF(HasKey.Hitbox.Position))
                wait(0.3)
                fireproximityprompt(HasKey.ModulePrompt,0)
                game.Players.LocalPlayer.Character:PivotTo(CF(CurrentDoor.Door.Position))
                wait(0.3)
                fireproximityprompt(CurrentDoor.Lock.UnlockPrompt,0)
            end
            if LatestRoom == 50 then
                CurrentDoor = workspace.CurrentRooms[tostring(LatestRoom+1)]:WaitForChild("Door")
            end
            game.Players.LocalPlayer.Character:PivotTo(CF(CurrentDoor.Door.Position))
            wait(0.3)
            CurrentDoor.ClientOpen:FireServer()
        end)
  	end    
})

CharacterMods:CreateToggle({
	Name = "自动跳过房间",
	Default = false,
    Save = false,
    Flag = "AutoSkip"
})

local AutoSkipCoro = coroutine.create(function()
        while true do
            task.wait()
            pcall(function()
            if Rayfield.Flags["AutoSkip"].Value == true and game:GetService("ReplicatedStorage").GameData.LatestRoom.Value < 100 then
                local HasKey = false
                local LatestRoom = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value
                local CurrentDoor = workspace.CurrentRooms[tostring(LatestRoom)]:WaitForChild("Door")
                for i,v in ipairs(CurrentDoor.Parent:GetDescendants()) do
                    if v.Name == "KeyObtain" then
                        HasKey = v
                    end
                end
                if HasKey then
                    game.Players.LocalPlayer.Character:PivotTo(CF(HasKey.Hitbox.Position))
                    task.wait(0.3)
                    fireproximityprompt(HasKey.ModulePrompt,0)
                    game.Players.LocalPlayer.Character:PivotTo(CF(CurrentDoor.Door.Position))
                    task.wait(0.3)
                    fireproximityprompt(CurrentDoor.Lock.UnlockPrompt,0)
                end
                if LatestRoom == 50 then
                    CurrentDoor = workspace.CurrentRooms[tostring(LatestRoom+1)]:WaitForChild("Door")
                end
                game.Players.LocalPlayer.Character:PivotTo(CF(CurrentDoor.Door.Position))
                task.wait(0.3)
                CurrentDoor.ClientOpen:FireServer()
            end
        end)
        end
end)
coroutine.resume(AutoSkipCoro)




local Speed = 15

local EVC=CharacterMods:CreateToggle({
    Name="开启速度挂",
    CurrentValue=false,
    Callback=function() end
})

CharacterMods:CreateSlider({
    Name="速度",
    Range={15,100},
    Increment=5,
    Suffix="studs/每秒",
    CurrentValue=15,
    Flag="speed",
    Callback=function(val)
        for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if child.ClassName == "Part" then
                child.CustomPhysicalProperties = PhysicalProperties.new(999, 0.3, 0.5)
            end
        end
        Speed = tonumber(val)
    end
})

game:GetService("RunService").RenderStepped:Connect(function()
    if EVC.CurrentValue==true then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Speed end
end)
--#endregion
--#region Tools
--#region Vitamins
_G.VitaminsDurability = 0

Tools:CreateButton({
    Name="拿维他命",
    Callback = function()
        local Vitamins = game:GetObjects("rbxassetid://11685698403")[1]
        local idle = Vitamins.Animations:FindFirstChild("idle")
        local open = Vitamins.Animations:FindFirstChild("open")

        local tweenService = game:GetService("TweenService")

        local sound_open = Vitamins.Handle:FindFirstChild("sound_open")

        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacteAdded:Wait()
        local hum = char:WaitForChild("Humanoid")

        local idleTrack = hum.Animator:LoadAnimation(idle)
        local openTrack = hum.Animator:LoadAnimation(open)

        local Durability = 35
        local InTrans = false
        local Duration = 10

        local xUsed = tonumber(_G.VitaminsDurability)

        local v1 = {};



        function v1.AddDurability()
            InTrans = true
            hum:SetAttribute("SpeedBoost", 15)
            wait(Duration)
            InTrans = false
            hum:SetAttribute("SpeedBoost", 0)
        end




        function v1.SetupVitamins()
            Vitamins.Parent = game.Players.LocalPlayer.Backpack
            Vitamins.Name = "假的维他命哈哈哈"

            for slotNum, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if tool.Name == "假的维他命哈哈哈" then
                    local slot =game.Players.LocalPlayer.PlayerGui:WaitForChild("MainUI").MainFrame.Hotbar:FindFirstChild(slotNum)
                    -- while task.wait() do
                    --     slot.DurabilityNumber.Text = "x"..xUsed
                    -- end
                    -- slot.DurabilityNumber.Text = "x"..xUsed
                    slot.DurabilityNumber.Visible = true
                    slot.DurabilityNumber.Text = "x"..xUsed

                    Vitamins.Unequipped:Connect(function()
                        slot.DurabilityNumber.Visible = true
                        slot.DurabilityNumber.Text = "x"..xUsed
                    end)

                    Vitamins.Equipped:Connect(function()
                        slot.DurabilityNumber.Visible = true
                    end)

                    Vitamins.Activated:Connect(function()
                        if not InTrans and xUsed > 0 then
                            xUsed = xUsed - 1
                            slot.DurabilityNumber.Visible = true
                            slot.DurabilityNumber.Text = "x"..xUsed
                            openTrack:Play()
                            sound_open:Play()
                    
                            tweenService:Create(workspace.CurrentCamera, TweenInfo.new(0.2), {FieldOfView = 100}):Play()
                            v1.AddDurability()
                        end
                    end)
                end
            end




            Vitamins.Equipped:Connect(function()
                idleTrack:Play()
            end)


            Vitamins.Unequipped:Connect(function()
                idleTrack:Stop()

            end)
        end

        v1.SetupVitamins()

        function v1.AddLoop()
            while task.wait() do
                if InTrans then
                    wait()
                    hum.WalkSpeed = Durability
                else
                    hum.WalkSpeed = 16
                end
            end
        end

        while task.wait() do
            v1.AddLoop()
        end

        return v1


    end
})

Tools:CreateInput({
	Name = "维他命数量/耐久",
	PlaceholderText = "ex: 100",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
        local durability = tonumber(Text)



        if durability then
            _G.VitaminsDurability = Text
        elseif not durability or durability == '0' then
            Rayfield:Notify({
                Title = "错误",
                Content = "请输入一个有效的数字.",
                Duration = 5,
                Image = 4483362458,
                Actions = {},
            })
        end
	end,    
})
 
Tools:CreateParagraph({Title = "注意", Content = "这些都是假的维他命但是也是有效果的. 其他人是开不见得. 请不要填写分数或小数，这会导致脚本被破坏或无效 ."})
--#endregion

--#region Dropdown
Tools:CreateParagraph({Title = "注意", Content = "在开局商店中运行即可在里面购买物品哈哈"})
local toolList={"骷髅钥匙", "十字架","Seek十字架","万圣节十字架", "圣诞枪械", "蜡烛", "Gummy Flashlight","手电筒", "Gun"}
table.sort(toolList)
local toolFuncs={["骷髅钥匙"]=function()
    if not isfile("skellyKey.rbxm") then
			writefile("skellyKey.rbxm", game:HttpGet"https://raw.githubusercontent.com/sponguss/Doors-Entity-Replicator/main/skellyKey.rbxm")
		end
		local keyTool = game:GetObjects((getcustomasset or getsynasset)("skellyKey.rbxm"))[1]
		keyTool:SetAttribute("uses", 5)
		local function setupRoom(room)
			local thing = loadstring(game:HttpGet"https://raw.githubusercontent.com/sponguss/Doors-Entity-Replicator/main/skellyKeyRoomRep.lua")()
			local newdoor = thing.CreateDoor({
				CustomKeyNames = {
					"SkellyKey"
				},
				Sign = true,
				Light = true,
				Locked = true
			})
			newdoor.Model.Parent = workspace
			newdoor.Model:PivotTo(room:WaitForChild"Door".Door.CFrame)
			newdoor.Model.Parent = room
			room:WaitForChild"Door":Destroy()
			thing.ReplicateDoor({
				Model = newdoor.Model,
				Config = {
					CustomKeyNames = {
						"SkellyKey"
					}
				},
				Debug = {
					OnDoorPreOpened = function()
					end
				}
			})
		end
		keyTool.Equipped:Connect(function()
			for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
				if room:WaitForChild"Door":FindFirstChild"Lock" and not room:GetAttribute("Replaced") then
					room:SetAttribute("Replaced", true)
					setupRoom(room)
				end
			end
			con = workspace.CurrentRooms.ChildAdded:Connect(function(room)
				if room:WaitForChild"Door":FindFirstChild"Lock" and not room:GetAttribute("Replaced") then
					room:SetAttribute("Replaced", true)
					setupRoom(room)
				end
			end)
		end)
		keyTool.Unequipped:Connect(function()
			con:Disconnect()
		end)
    if Plr.PlayerGui.MainUI.ItemShop.Visible then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Shop%20Items/Source.lua"))().CreateItem(keyTool, {
            Title = "骷髅钥匙[重回巅峰]",
            Desc = "傻逼",
            Image = "https://static.wikia.nocookie.net/doors-game/images/8/88/Icon_crucifix2.png/revision/latest/scale-to-width-down/350?cb=20220728033038",
            Price = "点赞加关注",
            Stack = 1,
        })
    else keyTool.Parent=game.Players.LocalPlayer.Backpack end
end, ["十字架"]=function() 
    local function IsVisible(part)
        local vec, found=workspace.CurrentCamera:WorldToViewportPoint(part.Position)
        local onscreen = found and vec.Z > 0
        local cfg = RaycastParams.new()
        cfg.FilterType = Enum.RaycastFilterType.Blacklist
        cfg.FilterDescendantsInstances = {part}
    
        local cast = workspace:Raycast(part.Position, (game.Players.LocalPlayer.Character.UpperTorso.Position - part.Position), cfg)
        if onscreen then
            if cast and (cast and cast.Instance).Parent==game.Players.LocalPlayer.Character then
                return true
            end
        end
    end
    
    local Equipped = false
    
    -- Edit this --
    getgenv().spawnKey = Enum.KeyCode.F4
    ---------------
    
    -- Services
    
    local Players = game:GetService("Players")
    local UIS = game:GetService("UserInputService")
    
    -- Variables
    
    local Plr = Players.LocalPlayer
    local Char = Plr.Character or Plr.CharacterAdded:Wait()
    local Hum = Char:WaitForChild("Humanoid")
    local Root = Char:WaitForChild("HumanoidRootPart")
    local RightArm = Char:WaitForChild("RightUpperArm")
    local LeftArm = Char:WaitForChild("LeftUpperArm")
    
    local RightC1 = RightArm.RightShoulder.C1
    local LeftC1 = LeftArm.LeftShoulder.C1
    
    local SelfModules = {
        Functions = loadstring(
            game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua")
        )(),
        CustomShop = loadstring(
            game:HttpGet(
                "https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Shop%20Items/Source.lua"
            )
        )(),
    }
    
    local ModuleScripts = {
        MainGame = require(Plr.PlayerGui.MainUI.Initiator.Main_Game),
        SeekIntro = require(Plr.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Cutscenes.SeekIntro),
    }
    
    -- Functions

    local function setupCrucifix(tool)
        tool.Equipped:Connect(function()
            Equipped = true
            Char:SetAttribute("Hiding", true)
            for _, v in next, Hum:GetPlayingAnimationTracks() do
                v:Stop()
            end
    
            RightArm.Name = "R_Arm"
            LeftArm.Name = "L_Arm"
    
            RightArm.RightShoulder.C1 = RightC1 * CFrame.Angles(math.rad(-90), math.rad(-15), 0)
            LeftArm.LeftShoulder.C1 = LeftC1
                * CFrame.new(-0.2, -0.3, -0.5)
                * CFrame.Angles(math.rad(-125), math.rad(25), math.rad(25))
        end)
    
        tool.Unequipped:Connect(function()
            Equipped = false
            Char:SetAttribute("Hiding", nil)
            RightArm.Name = "RightUpperArm"
            LeftArm.Name = "LeftUpperArm"
    
            RightArm.RightShoulder.C1 = RightC1
            LeftArm.LeftShoulder.C1 = LeftC1
        end)
    end
    
    -- Scripts
    
    local CrucifixTool = game:GetObjects("rbxassetid://11590476113")[1]
    CrucifixTool.Name = "Crucifix"
    CrucifixTool.Parent = game.Players.LocalPlayer.Backpack
    
    -- game.UserInputService.InputBegan:Connect(function(input, proc)
    --     if proc then return end
    
    --     if input.KeyCode == input.KeyCode[getgenv().spawnKey] then
    --         local CrucifixTool = game:GetObjects("rbxassetid://11590476113")[1]
    --         CrucifixTool.Name = "Crucifix"
    --         CrucifixTool.Parent = game.Players.LocalPlayer.Backpack
    --     end
    -- end)
    -- Input handler
    
    setupCrucifix(CrucifixTool)
    
    local Players = game:GetService("Players")
    local UIS = game:GetService("UserInputService")
    
    -- Variables
    
    local Plr = Players.LocalPlayer
    local Char = Plr.Character or Plr.CharacterAdded:Wait()
    local Hum = Char:WaitForChild("Humanoid")
    local Root = Char:WaitForChild("HumanoidRootPart")
    
    local dupeCrucifix = Instance.new("BindableEvent")
    local function func(ins)
        wait(.01) -- Wait for the attribute
        if ins:GetAttribute("IsCustomEntity")==true and ins:GetAttribute("ClonedByCrucifix")~=true then
            local Chains = game:GetObjects("rbxassetid://11584227521")[1]
            Chains.Parent = workspace
            local chained = true
            local posTime = false
            local rotTime = false
            local tweenTime = false
            local intFound = true
    
            game:GetService("RunService").RenderStepped:Connect(function()
                if Equipped then
                    if ins.Parent~=nil and ins.PrimaryPart and IsVisible(ins.PrimaryPart) and (Root.Position-ins.PrimaryPart.Position).magnitude <= 25 then
                        local c=ins:Clone()
                        c:SetAttribute("ClonedByCrucifix", true)
                        c.RushNew.Anchored=true
                        c.Parent=ins.Parent
                        ins:Destroy()
                        dupeCrucifix:Fire(6,c.RushNew)
    

                        
                        -- Chains.PrimaryPart.Orientation = Chains.PrimaryPart.Orientation + Vector3.new(0, 3, 0)
    
                        local EntityRoot = c:FindFirstChild("RushNew")
    
                        if EntityRoot then



                            local Fake_FaceAttach = Instance.new("Attachment")
                            Fake_FaceAttach.Parent = EntityRoot
                            

                            for i, beam in pairs(Chains:GetDescendants()) do
                                if beam:IsA("BasePart") then
                                    beam.CanCollide = false
                                end
                                if beam.Name == "Beam" then
                                    beam.Attachment1 = Fake_FaceAttach
                                end
                            end
                            
                            if not posTime then
                                Chains:SetPrimaryPartCFrame(
                                    EntityRoot.CFrame * CFrame.new(0, -3.5, 0) * CFrame.Angles(math.rad(90), 0, 0)
                                )
                                posTime = true
                            end
    
                            task.wait(1.35)
                            if not tweenTime then
    
                                task.spawn(function()
                                    while task.wait() do
                                        if Chains:FindFirstChild('Base') then
                                            Chains.Base.CFrame = Chains.Base.CFrame * CFrame.Angles(0,0 , math.rad(0.5))
                                        end
                                    end
                                end)

                                task.spawn(function()
                                    while task.wait() do
                                        for i, beam in pairs(Chains:GetDescendants()) do
                                            if beam.Name == "Beam" then
                                                beam.TextureLength = beam.TextureLength+0.035
                                            end
                                        end
                                    end
                                end)
    
    
                                game.TweenService
                                    :Create(
                                        EntityRoot,
                                        TweenInfo.new(6),
                                        { CFrame = EntityRoot.CFrame * CFrame.new(0, 50, 0) }
                                    )
                                    :Play()
                                
    
                                tweenTime = true
                                task.wait(1.5)
                                intFound = false
                                game:GetService("Debris"):AddItem(c, 0)
                                game:GetService("Debris"):AddItem(Chains, 0)
                            end
                        end
                    end
                end
            end)
        elseif ins.Name=="Lookman" then
            local c=ins
            task.spawn(function()
                repeat task.wait() until IsVisible(c.Core) and Equipped and c.Core.Attachment.Eyes.Enabled==true
                local pos=c.Core.Position
                dupeCrucifix:Fire(18.364, c.Core)
                task.spawn(function()
                    c:SetAttribute("Killing", true)
                    ModuleScripts.MainGame.camShaker:ShakeOnce(10, 10, 5, 0.15)
                    wait(5)
                    c.Core.Initiate:Stop()
                    for i=1,3 do
                        c.Core.Repent:Play()  
                        c.Core.Attachment.Angry.Enabled=true
                        ModuleScripts.MainGame.camShaker:ShakeOnce(8, 8, 1.3, 0.15)
                        delay(c.Core.Repent.TimeLength, function() c.Core.Attachment.Angry.Enabled=false end)
                        wait(4)
                    end
                    c.Core.Scream:Play();
                    ModuleScripts.MainGame.camShaker:ShakeOnce(8, 8, c.Core.Scream.TimeLength, 0.15);
                    (c.Core:FindFirstChild"whisper" or c.Core:FindFirstChild"Ambience"):Stop()
                    for _, l in pairs(c:GetDescendants()) do
                        if l:IsA("PointLight") then
                            l.Enabled=false
                        end
                    end
                    game:GetService("TweenService"):Create(c.Core, TweenInfo.new(c.Core.Scream.TimeLength, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                        CFrame=CFrame.new(c.Core.CFrame.X, c.Core.CFrame.Y-12, c.Core.CFrame.Z)
                    }):Play()
                end)
                local col=game.Players.LocalPlayer.Character.Collision

                local function CFrameToOrientation(cf)
                    local x, y, z = cf:ToOrientation()
                    return Vector3.new(math.deg(x), math.deg(y), math.deg(z))
                end
                
                while c.Parent~=nil and c.Core.Attachment.Eyes.Enabled==true do
                    -- who's the boss now huh?
                    col.Orientation = CFrameToOrientation(CFrame.lookAt(col.Position, pos)*CFrame.Angles(0, math.pi, 0))
                    task.wait()
                end
            end)
        elseif ins.Name=="Shade" and ins.Parent==workspace.CurrentCamera and ins:GetAttribute("ClonedByCrucifix")==nil then
            task.spawn(function()
                repeat task.wait() until IsVisible(ins) and (Root.Position-ins.Position).Magnitude <= 12.5 and Equipped
                local clone = ins:Clone()
                clone:SetAttribute("ClonedByCrucifix", true)
                clone.CFrame = ins.CFrame
                clone.Parent = ins.Parent
                clone.Anchored = true
                ins:Remove()

                dupeCrucifix:Fire(13, ins)
                ModuleScripts.MainGame.camShaker:ShakeOnce(40, 10, 5, 0.15)
    
                for _, thing in pairs(clone:GetDescendants()) do
                    if thing:IsA("SpotLight") then
                        game:GetService("TweenService"):Create(thing, TweenInfo.new(5), {
                            Brightness=thing.Brightness*5
                        }):Play()
                    elseif thing:IsA("Sound") and thing.Name~="Burst" then
                        game:GetService("TweenService"):Create(thing, TweenInfo.new(5), {
                            Volume=0
                        }):Play()
                    elseif thing:IsA("TouchTransmitter") then thing:Destroy() end
                end
    
                for _, pc in pairs(clone:GetDescendants()) do
                    if pc:IsA("ParticleEmitter") then
                        pc.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.48, Color3.fromRGB(182, 0, 3)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))}
                    end
                end
    
                local Original_color = {}
    
                local light
                light = game.Lighting["Ambience_Shade"]
                game:GetService("TweenService"):Create(light, TweenInfo.new(1), {
    
                }):Play()
    
                wait(5)
    
                clone.Burst.PlaybackSpeed=0.5
                clone.Burst:Stop()
                clone.Burst:Play()
                light.TintColor = Color3.fromRGB(215,253,255)
                game:GetService("TweenService"):Create(clone, TweenInfo.new(6), {
                    CFrame=CFrame.new(clone.CFrame.X, clone.CFrame.Y-12, clone.CFrame.Z)
                }):Play()
                wait(8.2)
    
                game:GetService("Debris"):AddItem(clone, 0)
                game.ReplicatedStorage.Bricks.ShadeResult:FireServer()
            end)
        end
    end

    workspace.ChildAdded:Connect(func)
    workspace.CurrentCamera.ChildAdded:Connect(func)
    for _, thing in pairs(workspace:GetChildren()) do
        func(thing)
    end
    dupeCrucifix.Event:Connect(function(time, entityRoot)
        local Cross = game:GetObjects("rbxassetid://11656343590")[1]
        Cross.Parent = workspace

        local fakeCross = Cross.Handle
    
        -- fakeCross:FindFirstChild("EffectLight").Enabled = true
    
        ModuleScripts.MainGame.camShaker:ShakeOnce(35, 25, 0.15, 0.15)
        -- you tell me i didnt make?
        fakeCross.CFrame = CFrame.lookAt(CrucifixTool.Handle.Position, entityRoot.Position)
        
        -- hl.Parent = model
        -- hl.FillTransparency = 1
        -- hl.OutlineColor = Color3.fromRGB(75, 177, 255)
        fakeCross.Anchored = true
    
        CrucifixTool:Destroy()
    
        -- for i, v in pairs(fakeCross:GetChildren()) do
        --     if v.Name == "E" and v:IsA("BasePart") then
        --         v.Transparency = 0
        --         v.CanCollide = false
        --     end
        --     if v:IsA("Motor6D") then
        --         v.Name = "Motor6D"
        --     end
        -- end
    
        task.wait(time)
        fakeCross.Anchored = false
        fakeCross.CanCollide = true
        task.wait(0.5)
        Cross:Remove()
    end)
    
    if Plr.PlayerGui.MainUI.ItemShop.Visible then
    SelfModules.CustomShop.CreateItem(CrucifixTool, {
        Title = "十字架",
        Desc = "恶魔的噩梦.",
        Image = "https://static.wikia.nocookie.net/doors-game/images/8/88/Icon_crucifix2.png/revision/latest/scale-to-width-down/350?cb=20220728033038",
        Price = "点赞加关注",
        Stack = 1,
    })
    else CrucifixTool.Parent=game.Players.LocalPlayer.Backpack end
end, ["圣诞枪械"]=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/NotTypicalAdmin/ChristmasGuns/main/main"))()
end,
    ["手电筒"]=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DXuwu/flashlight-lmao/main/flashlight.lua"))()
end,    
    ["Seek十字架"]=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RmdComunnityScriptsProvider/AngryHub/main/Seek%20Crucifix.lua"))()
end,
    ["万圣节十字架"]=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Mye123/MyeWareHub/main/Halloween%20Crucifix"))()
end,    
    ["蜡烛"]=function()
    local Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))()
    local CustomShop = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Shop%20Items/Source.lua"))()


    local Candle = game:GetObjects("rbxassetid://11630702537")[1]
    Candle.Parent = game.Players.LocalPlayer.Backpack

    local plr = game.Players.LocalPlayer
    local Char = plr.Character or plr.CharacterAdded:Wait()
    local Hum = Char:FindFirstChild("Humanoid")
    local RightArm = Char:FindFirstChild("RightUpperArm")
    local LeftArm = Char:FindFirstChild("LeftUpperArm")
    local RightC1 = RightArm.RightShoulder.C1
    local LeftC1 = LeftArm.LeftShoulder.C1

    local AnimIdle = Instance.new("Animation")
    AnimIdle.AnimationId = "rbxassetid://9982615727"
    AnimIdle.Name = "IDleloplolo"

    local cam = workspace.CurrentCamera

    Candle.Handle.Top.Flame.GuidingLighteffect.EffectLight.LockedToPart = true
    Candle.Handle.Material = Enum.Material.Salt

    local track = Hum.Animator:LoadAnimation(AnimIdle)
    track.Looped = true

    local Equipped = false

    for i,v in pairs(Candle:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end

    Candle.Equipped:Connect(function()
        for _, v in next, Hum:GetPlayingAnimationTracks() do
            v:Stop()
        end
        Equipped = true
        -- RightArm.Name = "R_Arm"
        track:Play()
        -- RightArm.RightShoulder.C1 = RightC1 * CFrame.Angles(math.rad(-90), math.rad(-15), 0)
    end)

    Candle.Unequipped:Connect(function()
        RightArm.Name = "RightUpperArm"
        track:Stop()
        Equipped = false
        -- RightArm.RightShoulder.C1 = RightC1
    end)

    cam.ChildAdded:Connect(function(screech)
        if screech.Name == "Screech" and math.random(1,400)~=1 then   
            if not Equipped then return end

            if Equipped then
                game:GetService("Debris"):AddItem(screech, 0.05)
            end
        end
    end)

    Candle.TextureId = "rbxassetid://11622366799"
    -- Create custom shop item
    if plr.PlayerGui.MainUI.ItemShop.Visible then
        CustomShop.CreateItem(Candle, {
            Title = "指导蜡烛",
            Desc = "提供小范围照明",
            Image = "rbxassetid://11622366799",
            Price = 75,
            Stack = 1,
        })
    else Candle.Parent=game.Players.LocalPlayer.Backpack end
end, ["Gummy Flashlight"]=function()
    if workspace:FindFirstChild("Gummy Flashlight") then
        firetouchinterest(game.Players.LocalPlayer.Character.Head, workspace["Gummy Flashlight"].Handle, 0)
        task.wait()
        firetouchinterest(game.Players.LocalPlayer.Character.Head, workspace["Gummy Flashlight"].Handle, 1)
    else
        return Rayfield:Notify({
            Title = "Error",
            Content = "This script must be executed at elevator due to it being REPLICATED (ServerSided)",
            Duration = 6.5,
            Image = 4483362458,
            Actions = {},
        })
    end
end, ["Gun"]=function()
    if not isfile("Hole.rbxm") then
        writefile("Hole.rbxm", game:HttpGet"https://cdn.discordapp.com/attachments/969056040094138378/1044313717107593277/Hole.rbxm")
    end
    loadstring(game:HttpGet"https://raw.githubusercontent.com/ZepsyyCodesLUA/Utilities/main/DOORSFpsGun.lua?token=GHSAT0AAAAAAB2POHILOXMAHBQ2GN2QD2MQY3SXTCQ")()
end}
local selectedTool=Tools:CreateDropdown({
    Name="选择物品",
    Options=toolList,
    CurrentOption="十字架",
    Flag="selectedTool",
    Callback=function() end
})
Tools:CreateButton({
    Name="获取已选择物品",
    Callback=function() 
    toolFuncs[selectedTool.CurrentOption]() end
})
Tools:CreateKeybind({
	Name = "获取物品快捷键",
	CurrentKeybind = "T",
	HoldToInteract = false,
	Flag = "toolKeybind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Keybind)
    toolFuncs[selectedTool.CurrentOption]()
	end,
})



--
--#endregion
--#endregion
--#region Global

global:CreateSection("公共怪物设定")
local removeEntities
local rmEntitiesCon
local rmEntitiesConTwo
global:CreateToggle({
    Name = "清除所有怪物",
	CurrentValue = false,
	Flag = "removeEntities",
	Callback = function(Value)
        -- im so good at the game
        removeEntities = Value
		if Value == true then
			rmEntitiesConTwo = workspace.CurrentRooms.ChildAdded:Connect(function(c)
				if c:WaitForChild"Base" then
					task.spawn(function()
						local p = Instance.new("ParticleEmitter", c.Base)
						p.Brightness = 500
						p.Color = ColorSequence.new(Color3.fromRGB(0, 80, 255))
						p.LightEmission = 10000
						p.LightInfluence = 0
						p.Orientation = Enum.ParticleOrientation.FacingCamera
						p.Size = NumberSequence.new(0.2)
						p.Squash = NumberSequence.new(0)
						p.Texture = "rbxassetid://2581223252"
						p.Transparency = NumberSequence.new(0)
						p.ZOffset = 0
						p.EmissionDirection = Enum.NormalId.Top
						p.Lifetime = NumberRange.new(2.5)
						p.Rate = 500
						p.Rotation = NumberRange.new(0)
						p.RotSpeed = NumberRange.new(0)
						p.Speed = 10
						p.SpreadAngle = Vector2.new(0, 0)
						p.Shape = Enum.ParticleEmitterShape.Box
						p.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
						p.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
						p.Drag = 0
					end)
				end
			end)
			rmEntitiesCon = workspace.ChildAdded:Connect(function(c)
				if c.Name == "Lookman" then
					if not game:GetService"Players":GetPlayers()[2] then
						local originalPos = c:FindFirstChildWhichIsA"BasePart".Position
						task.wait()
						c:PivotTo(0, 59049, 0)
						for _, sound in pairs(c:GetDescendants()) do
							if sound:IsA"Sound" then
								sound.Volume = 0
							end
						end
						local col = game.Players.LocalPlayer.Character.Collision
						local function CFrameToOrientation(cf)
							local x, y, z = cf:ToOrientation()
							return Vector3.new(math.deg(x), math.deg(y), math.deg(z))
						end
						while c.Parent ~= nil and c.Core.Attachment.Eyes.Enabled == true do
							col.Orientation = CFrameToOrientation(CFrame.lookAt(col.Position, originalPos) * CFrame.Angles(0, math.pi, 0))
							task.wait()
						end
					else
						repeat
							task.wait()
						until c.Core.Attachment.Eyes.Enabled == true
						task.wait(.02)
						local door = workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value]:WaitForChild"Door"
						local lp = game.Players.LocalPlayer
						local char = lp.Character
						local pos = char.PrimaryPart.CFrame
						char:PivotTo(door.Hidden.CFrame)
						if door:FindFirstChild"ClientOpen" then
							door.ClientOpen:FireServer()
						end
						task.wait(.2)
						local HasKey = false
						for i, v in ipairs(door.Parent:GetDescendants()) do
							if v.Name == "KeyObtain" then
								HasKey = v
							end
						end
						if HasKey then
							game.Players.LocalPlayer.Character:PivotTo(CFrame.new(HasKey.Hitbox.Position))
							wait(0.3)
							fireproximityprompt(HasKey.ModulePrompt, 0)
							game.Players.LocalPlayer.Character:PivotTo(CFrame.new(door.Door.Position))
							wait(0.3)
							fireproximityprompt(door.Lock.UnlockPrompt, 0)
							return
						end
						char:PivotTo(pos)
					end
				end
			end)
			local val = game.ReplicatedStorage.GameData.ChaseStart
			local savedVal = val.Value
			task.spawn(function()
				repeat
					if not game:GetService"Players":GetPlayers()[2] then
						repeat
							task.wait()
						until val.Value ~= savedVal
						savedVal = val.Value
						repeat
							task.wait()
						until workspace.CurrentRooms:FindFirstChild(tostring(val.Value))
						local room = workspace.CurrentRooms[tostring(val.Value - 1)]
						local thing = loadstring(game:HttpGet"https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Door%20Replication/Source.lua")()
						local newdoor = thing.CreateDoor({
							CustomKeyNames = {
								"SkellyKey"
							},
							Sign = true,
							Light = true,
							Locked = (room:WaitForChild"Door":FindFirstChild"Lock" and true or false)
						})
						newdoor.Model.Parent = workspace
						newdoor.Model:PivotTo(room:WaitForChild("Door").Door.CFrame)
						newdoor.Model.Parent = room
						room:WaitForChild("Door"):Destroy()
						thing.ReplicateDoor({
							Model = newdoor.Model,
							Config = {},
							Debug = {
								OnDoorPreOpened = function()
								end
							}
						})
						return
					else
						repeat
							task.wait()
						until val.Value ~= savedVal
						savedVal = val.Value
						repeat
							task.wait()
						until workspace.CurrentRooms:FindFirstChild(tostring(val.Value)) and workspace.CurrentRooms:FindFirstChild(tostring(val.Value - 2)).Door.Light.Attachment.PointLight.Enabled == true
						xpcall(function()
							if removeEntities == true and game.ReplicatedStorage.GameData.ChaseEnd.Value - val.Value < 3 and game.ReplicatedStorage.GameData.ChaseStart.Value ~= 50 then
								local lp = game.Players.LocalPlayer
								local char = lp.Character
								local pos = char.PrimaryPart.CFrame
								local door = workspace.CurrentRooms[tostring(val.Value)]:WaitForChild("Door")
								local HasKey = false
								for i, v in ipairs(door.Parent:GetDescendants()) do
									if v.Name == "KeyObtain" then
										HasKey = v
									end
								end
								if HasKey then
									game.Players.LocalPlayer.Character:PivotTo(CFrame.new(HasKey.Hitbox.Position))
									wait(0.3)
									fireproximityprompt(HasKey.ModulePrompt, 0)
									game.Players.LocalPlayer.Character:PivotTo(CFrame.new(door.Door.Position))
									wait(0.3)
									fireproximityprompt(door.Lock.UnlockPrompt, 0)
									return
								end
								char:PivotTo(door.Hidden.CFrame)
								if door:FindFirstChild"ClientOpen" then
									door.ClientOpen:FireServer()
								end
								task.wait(.2)
								char:PivotTo(pos)
							end
						end, function(...)
							print(...)
						end)
					end
				until removeEntities == false
			end)
			if not game:GetService"Players":GetPlayers()[2] and removeEntities == true then
				repeat
					task.wait()
				until workspace.CurrentRooms:FindFirstChild(tostring(savedVal))
				local room = workspace.CurrentRooms[tostring(savedVal)]
				local thing = loadstring(game:HttpGet"https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Door%20Replication/Source.lua")()
				local newdoor = thing.CreateDoor({
					CustomKeyNames = {
						"SkellyKey"
					},
					Sign = true,
					Light = true,
					Locked = {
						room.Door:FindFirstChild"Lock" and true or false
					}
				})
				newdoor.Model.Parent = workspace
				newdoor.Model:PivotTo(room:WaitForChild("Door").Door.CFrame)
				newdoor.Model.Parent = room
				room:WaitForChild("Door"):Destroy()
				thing.ReplicateDoor({
					Model = newdoor.Model,
					Config = {},
					Debug = {
						OnDoorPreOpened = function()
						end
					}
				})
			else
				repeat
					task.wait()
				until workspace.CurrentRooms:FindFirstChild(tostring(savedVal)) and workspace.CurrentRooms:FindFirstChild(tostring(savedVal - 2)).Door.Light.Attachment.PointLight.Enabled == true
				if removeEntities == true then
					local lp = game.Players.LocalPlayer
					local char = lp.Character
					local pos = char.PrimaryPart.CFrame
					local door = workspace.CurrentRooms[tostring(savedVal)]:WaitForChild("Door")
					local HasKey = false
					for i, v in ipairs(door.Parent:GetDescendants()) do
						if v.Name == "KeyObtain" then
							HasKey = v
						end
					end
					if HasKey then
						game.Players.LocalPlayer.Character:PivotTo(CFrame.new(HasKey.Hitbox.Position))
						wait(0.3)
						fireproximityprompt(HasKey.ModulePrompt, 0)
						game.Players.LocalPlayer.Character:PivotTo(CFrame.new(door.Door.Position))
						wait(0.3)
						fireproximityprompt(door.Lock.UnlockPrompt, 0)
						return
					else
						char:PivotTo(door.Hidden.CFrame)
						if door:FindFirstChild"ClientOpen" then
							door.ClientOpen:FireServer()
						end
						task.wait(.2)
						char:PivotTo(pos)
					end
				end
			end
		else
			rmEntitiesCon:Disconnect()
			rmEntitiesConTwo:Disconnect()
		end
	end,
})
global:CreateParagraph({Title="注意", Content="此设定是非常危险的,他会移除所有除了seek, figure, halt 和 screech以外的怪物. 这样会影响到整局游戏, 其他人就会注意到没有 rush/ambush/eyes... 的生成. 你想当老六我还是阻止不了的555."})

global:CreateButton({
    Name="牛逼 Figure",
    Callback=function()
        if workspace.CurrentRooms["51"] then
            local char=game.Players.LocalPlayer.Character
            local door=workspace.CurrentRooms["51"].Door
            char:PivotTo(door.Hidden.CFrame)
            if door:FindFirstChild"ClientOpen" then door.ClientOpen:FireServer() end
            task.wait(.2)
            char:PivotTo(pos)
        else
            Rayfield:Notify({
                Title = "错误",
                Content = "你只能在第49/50道门使用.",
                Duration = 6.5,
                Image = 4483362458,
                Actions = {},
            })
        end
    end
})
global:CreateParagraph({Title="Functionality", Content="按下去 \"牛逼 Figure\" 会让figure知道每个玩家在哪... 这会增加50门的难度. 如果你在单人游玩的时候使用，不知到很大几率figure会被移除哈哈哈哈哈哈"})
--#endregion
--#region IN-DEV, DO NOT TOUCH.
-- local chatCon

-- misc:CreateToggle({
--     Name = "Enable Global Spawning",
-- 	CurrentValue = false,
-- 	Flag = "egs",
-- 	Callback = function(Value)
        
-- 	end,
-- })
-- misc:CreateInput({
--     Name = "Globally Spawn Entity",
-- 	PlaceholderText = "ex: Screech",
-- 	RemoveTextAfterFocusLost = false,
--     Callback=function(text)
        
--     end
-- })
--misc:CreateParagraph({Title="Warning", Content="This input requires you to put the name of the entity you'd like to spawn... Aswell, this will only work with people that are using the same gui"})

-- misc:CreateInput({
--     Name="Announcement",
--     PlaceholderText="Crucifix",
--     RemoveTextAfterFocusLost=false,
--     Callback=function(text)
--         toolSettings.Title=text
--     end
-- })

-- misc:CreateButton({
--     Name="Create Tool",
--     Callback=function()
--         local Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))()
--         local CustomShop = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Shop%20Items/Source.lua"))()
--         local tool = LoadCustomInstance(tool)

--         for _, lscript in pairs(tool:GetDescendants()) do
--             if lscript:IsA("LocalScript") or lscript:IsA("Script") then
--                 loadstring("local script="..lscript:GetFullName().."\n\n"..lscript.Source)()
--             end
--         end

--         CustomShop.CreateItem(tool, toolSettings)
--     end
-- })

-- local EntityCreatorInstance

-- EntityCreator:CreateButton({
--     Name="Save/Spawn Entity",
--     Callback=function()
--         Rayfield:Notify({
--             Title = "Question",
--             Content = "Would you like to save your entity to a LUA file, or to spawn it directly",
--             Duration = 120,
--             Image = 4483362458,
--             Actions = { -- Notification Buttons
--                 Save = {
--                     Name = "Save",
--                     Callback = function()
--                         print("The user tapped Okay!")
--                     end
--                 },
--                 Spawn = {
--                     Name = "Spawn",
--                     Callback = function()
--                         print("The user tapped Okay!")
--                     end
--                 },
--             },
--         })
--     end
-- })
-- EntityCreator:CreateSection("Entity Appearance")

-- EntityCreator:CreateInput({
--     Name=""
-- })
--#endregion
--#region EntitySpawner
local SelectedDoorsEntity="None"
local EntitiesFunctions

MainTab:CreateButton({
    Name="生成已选择怪物",
    Callback=function()
        local e
        task.spawn(function() e=spawnEntity(SelectedDoorsEntity) end)
        Rayfield:Notify({
            Title = "已生成怪物",
            Content = "怪物"..SelectedDoorsEntity.." 已生成",
            Duration = 5,
            Image = 4483362458,
            Actions = {
                Okay={
                    Name="我知道了你真啰嗦",
                    Callback=function() end
                },
                Remove={
                    Name="移除",
                    Callback=function() 
                        repeat task.wait() until typeof(e)=="Instance"
                        e:Destroy()
                    end
                }
            },
        })
    end
})
local SelectedEntityLabel = MainTab:CreateLabel("你已经把 "..SelectedDoorsEntity.." 选择了")
task.spawn(function()
    while true do
        SelectedEntityLabel:Set("你已经把 "..SelectedDoorsEntity.." 选择了")
        task.wait(.5)
    end
end)

MainTab:CreateSection("Doors 怪物")
local CanEntityKill=false

local Creator = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors%20Entity%20Spawner/Source.lua"))()

local old
old=hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local args={...}
    if getnamecallmethod()=="FireServer" and self.Name=="Screech" then
        if game.Players.LocalPlayer.Character:FindFirstChild"Crucifix" then
            wait(.02)
            local screech=workspace.CurrentCamera:FindFirstChild("Screech")
            screech:FindFirstChildWhichIsA("AnimationController"):LoadAnimation(screech.Animations.Caught)
            screech.Animations.Attack.AnimationId="rbxassetid://10493727264"
            local snd=game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules.Screech.Attack
            snd:Stop()
            snd.Parent.Caught:Play()
            return old(self, false)
        end
        if args[1]==false and CanEntityKill then
            game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").Health-=40
            debug.setupvalue(getconnections(game.ReplicatedStorage.Bricks.DeathHint.OnClientEvent)[1].Function, 1, {
                "你又死于Screech...",
                "它喜欢潜伏在黑暗的房间.",
                "它会在你手持光源的时候攻击你.",
                "你个人机害我费20秒打这段话我真的服了."
            })
            return nil
        end
    end
    return old(self, ...)
end))

function spawnEntity(sel)
    sel=sel:lower()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/sponguss/Doors-Entity-Replicator/main/ui_cache/"..sel..".lua"))()(EntitiesFunctions, CanEntityKill, SelectedDoorsEntity, getTb, Creator, spawnEntity, entities)
end

MainTab:CreateDropdown({
	Name = "选择怪物",
	Options = entities.RegularEntities,
	CurrentOption = "None",
	Flag = "spongusDoorsEntityDropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Option)
        SelectedDoorsEntity=Option
	end,
})

MainTab:CreateKeybind({
	Name = "怪物快捷键",
	CurrentKeybind = "Q",
	HoldToInteract = false,
	Flag = "EntityKeybind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Keybind)
        local e
        task.spawn(function() spawnEntity(SelectedDoorsEntity) end)
        Rayfield:Notify({
            Title = "已生成怪物",
            Content = "怪物 "..SelectedDoorsEntity.." 已生成",
            Duration = 5,
            Image = 4483362458,
            Actions = {
                Okay={
                    Name="你奶奶的真啰嗦",
                    Callback=function() end
                },
                Remove={
                    Name="移除",
                    Callback=function() 
                        repeat task.wait() until typeof(e)=="Instance"
                        e:Destroy()
                    end
                }
            },
        })
	end,
})

MainTab:CreateSection("开发人员怪物")
MainTab:CreateDropdown({
	Name = "选择开发人员怪物",
	Options = entities.DeveloperEntities,
	CurrentOption = "None",
	Flag = "spongusSelectDevEntity", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Option)
        SelectedDoorsEntity=Option
	end,
})

MainTab:CreateButton({
        Name = "A-60",
        Callback = function()
            local Creator = loadstring(game:HttpGet("https://pastebin.com/raw/txV1ZG7S"))() 
local entity = Creator.createEntity({
    CustomName = "A-60", -- Custom name of your entity
    Model = "rbxassetid:////11835351318", -- Can be GitHub file or rbxassetid
    Speed = 700, -- Percentage, 100 = default Rush speed
    DelayTime = 2, -- Time before starting cycles (seconds)
    HeightOffset = 0,
    CanKill = false,
    KillRange = 40,
    BreakLights = true,
    BackwardsMovement = false,
    FlickerLights = {
        true, -- Enabled/Disabled
        1, -- Time (seconds)
    },
    Cycles = {
        Min = 7,
        Max = 7,
        WaitTime = 1,
    },
    CamShake = {
        true, -- Enabled/Disabled
        {3.5, 20, 0.1, 1}, -- Shake values (don't change if you don't know)
        100, -- Shake start distance (from Entity to you)
    },
    Jumpscare = {
        true, -- Enabled/Disabled
        {
            Image1 = "rbxassetid://10483855823", -- Image1 url
            Image2 = "rbxassetid://10483999903", -- Image2 url
            Shake = true,
            Sound1 = {
                10483790459, -- SoundId
                { Volume = 0.5 }, -- Sound properties
            },
            Sound2 = {
                10483837590, -- SoundId
                { Volume = 0.5 }, -- Sound properties
            },
            Flashing = {
                true, -- Enabled/Disabled
                Color3.fromRGB(0, 0, 255), -- Color
            },
            Tease = {
                true, -- Enabled/Disabled
                Min = 4,
                Max = 4,
            },
        },
    },
    CustomDialog = {"你死于A-60...", "等一下", "鸡"}, -- Custom death message
    
})

-----[[ Advanced ]]-----
entity.Debug.OnEntitySpawned = function(entityTable)
    print("Entity has spawned:", entityTable.Model)
end

entity.Debug.OnEntityDespawned = function(entityTable)
    print("Entity has despawned:", entityTable.Model)
end

entity.Debug.OnEntityStartMoving = function(entityTable)
    print("Entity has started moving:", entityTable.Model)
end

entity.Debug.OnEntityFinishedRebound = function(entityTable)
    print("Entity has finished rebound:", entityTable.Model)
end

entity.Debug.OnEntityEnteredRoom = function(entityTable, room)
    print("Entity:", entityTable.Model, "has entered room:", room)
end

entity.Debug.OnLookAtEntity = function(entityTable)
    print("Player has looked at entity:", entityTable.Model)
end

entity.Debug.OnDeath = function(entityTable)
    warn("Player has died.")
end
------------------------

-- Run the created entity
Creator.runEntity(entity)
end,
})


MainTab:CreateSection("自定义怪物")
MainTab:CreateDropdown({
	Name = "选择自定义怪物",
	Options = entities.CustomEntities,
	CurrentOption = "None",
	Flag = "spongusDoorsCustomEntityDropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Option)
        SelectedDoorsEntity=Option
	end,
})
MainTab:CreateSection("Entity Configuration")
MainTab:CreateToggle({
    Name = "开启怪物伤害",
	CurrentValue = false,
	Flag = "killToggle",
	Callback = function(Value)
        CanEntityKill=Value
	end,
})

local con
local old=game.Players.LocalPlayer:GetAttribute("CurrentRoom")
MainTab:CreateToggle({
    Name = "每道门运行",
	CurrentValue = false,
	Flag = "runEachRoomToggle",
	Callback = function(Value)
        if Value then 
            con=workspace.CurrentRooms.ChildAdded:Connect(function()
                repeat task.wait() until old~=game.Players.LocalPlayer:GetAttribute("CurrentRoom")
                old=game.Players.LocalPlayer:GetAttribute("CurrentRoom")
                local e
                task.spawn(function() e=spawnEntity(SelectedDoorsEntity) end)
                Rayfield:Notify({
                    Title = "Spawned Entity",
                    Content = "The entity "..SelectedDoorsEntity.." has spawned",
                    Duration = 5,
                    Image = 4483362458,
                    Actions = {
                        Okay={
                            Name="Ok!",
                            Callback=function() end
                        },
                        Remove={
                            Name="Remove",
                            Callback=function() 
                                repeat task.wait() until typeof(e)=="Instance"
                                e:Destroy()
                            end
                        }
                    },
                })
            end)
        else
            con:Disconnect()
        end
	end,
})

local disabled=false
MainTab:CreateInput({
	Name = "每【】生成一次怪物",
	PlaceholderText = "秒",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
        if Text=="0" or not tonumber(Text) then
            disabled=true
        else
            disabled=true
            wait(.1)
            disabled=false
            while disabled~=true do
            	task.wait(tonumber(Text))
                task.spawn(function()
                    local e
                    task.spawn(function() e=spawnEntity(SelectedDoorsEntity) end)
                    Rayfield:Notify({
                        Title = "已生成怪物",
                        Content = "怪物 "..SelectedDoorsEntity.." 已生成",
                        Duration = 5,
                        Image = 4483362458,
                        Actions = {
                            Okay={
                                Name="关我屁事",
                                Callback=function() end
                            },
                            Remove={
                                Name="移除",
                                Callback=function() 
                                    repeat task.wait() until typeof(e)=="Instance"
                                    e:Destroy()
                                end
                            }
                        },
                    })
                end)
			end
        end
	end,
})
--#endregion
--new region
