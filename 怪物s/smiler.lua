return function(_, CanEntityKill)
	local L_1_ = workspace.CurrentCamera
	local L_2_ = Instance.new("Sound")
	L_2_.SoundId = "rbxassetid://11567506327"
	L_2_.Parent = L_1_
	local L_3_ = game:GetService("Players")
	local L_4_ = game:GetService("RunService")
	local L_5_ = game:GetService("ReplicatedStorage")
	local L_6_ = game:GetService("CoreGui")
	local L_7_ = game:GetService("TweenService")
	local L_8_ = L_3_.LocalPlayer
	local L_9_ = L_8_.Character or L_8_.CharacterAdded:Wait()
	local L_10_ = L_9_:WaitForChild("HumanoidRootPart")
	local L_11_ = L_9_:WaitForChild("Humanoid")
	local L_12_ = workspace.CurrentCamera
	local L_13_ = workspace.FindPartOnRayWithIgnoreList
	local L_14_ = L_12_.WorldToViewportPoint
	local L_15_ = 50
	local L_16_ = 150
	local L_17_ = 300
	local L_18_ = {
		Functions = loadstring(
			game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua")
		)(),
	}
	local L_19_ = {
		MainGame = require(L_8_.PlayerGui.MainUI.Initiator.Main_Game),
		ModuleEvents = require(L_5_.ClientModules.Module_Events),
	}
	local L_20_ = {
		Speed = 100,
		DelayTime = 2,
		HeightOffset = 0,
		CanKill = CanEntityKill,
		KillRange = 50,
		BreakLights = true,
		BackwardsMovement = false,
		FlickerLights = {
			true,
			1
		},
		Cycles = {
			Min = 1,
			Max = 1,
			WaitTime = 2
		},
		CamShake = {
			true,
			{
				5,
				15,
				0.1,
				1
			},
			100
		},
		Jumpscare = {
			false,
			{}
		},
		CustomDialog = {},
	}
	local L_21_ = {}
	local L_22_ = {}
	local L_23_ = {}
	local function L_24_func(L_29_arg0, L_30_arg1, L_31_arg2)
		if L_21_[L_29_arg0].Drag then
			L_21_[L_29_arg0].Drag:Disconnect()
		end
		local L_32_ = false
		L_21_[L_29_arg0].Drag = L_4_.Stepped:Connect(function(L_33_arg0, L_34_arg1)
			if L_29_arg0.Parent then
				local L_35_ = L_29_arg0.PrimaryPart.Position
				local L_36_ = Vector3.new(L_30_arg1.X, L_30_arg1.Y, L_30_arg1.Z) - L_35_
				if L_36_.Magnitude > 0.1 then
					L_29_arg0:SetPrimaryPartCFrame(CFrame.new(L_35_ + L_36_.Unit * math.min(L_34_arg1 * L_31_arg2, L_36_.Magnitude)))
				else
					L_21_[L_29_arg0].Drag:Disconnect()
					L_32_ = true
				end
			else
				L_21_[L_29_arg0].Drag:Disconnect()
			end
		end)
		repeat
			task.wait()
		until L_32_
	end
	local function L_25_func(L_37_arg0, L_38_arg1)
		for L_40_forvar0, L_41_forvar1 in next, L_22_ do
			L_41_forvar1:Destroy()
			L_22_[L_40_forvar0] = nil
		end
		local L_39_ = Instance.new("Sound")
		L_39_.SoundId = "rbxassetid://" .. ({
			string.gsub(L_37_arg0, "%D", "")
		})[1]
		L_39_.Playing = true
		L_39_.Parent = workspace
		for L_42_forvar0, L_43_forvar1 in next, L_38_arg1 do
			if L_42_forvar0 ~= "SoundId" and L_42_forvar0 ~= "Playing" and L_42_forvar0 ~= "Parent" then
				L_39_[L_42_forvar0] = L_43_forvar1
			end
		end
		L_22_[#L_22_ + 1] = L_39_
		return L_39_
	end
	local function L_26_func(L_44_arg0)
		for L_45_forvar0, L_46_forvar1 in next, L_21_[L_44_arg0.Model] do
			L_46_forvar1:Disconnect()
		end
		L_21_[L_44_arg0.Model] = nil
		L_44_arg0.Model:Destroy()
		L_44_arg0.Debug.OnEntityDespawned(L_44_arg0)
	end
	local function L_27_func()
		if workspace:FindFirstChild("Doggo") then
			return true
		elseif L_9_:FindFirstChild("Crucifix") then
			return true
		end
		return false
	end
	L_23_.createEntity = function(L_47_arg0)
		assert(typeof(L_47_arg0) == "table")
		assert(L_47_arg0.Model)
		for L_49_forvar0, L_50_forvar1 in next, L_20_ do
			if L_47_arg0[L_49_forvar0] == nil then
				L_47_arg0[L_49_forvar0] = L_20_[L_49_forvar0]
			end
		end
		L_47_arg0.Speed = L_15_ / 100 * L_47_arg0.Speed
		local L_48_ = LoadCustomInstance(L_47_arg0.Model)
		if typeof(L_48_) == "Instance" and L_48_.ClassName == "Model" then
			local L_51_ = L_48_.PrimaryPart or L_48_:FindFirstChildWhichIsA("BasePart")
			if L_51_ then
				L_48_.PrimaryPart = L_51_
				L_51_.Anchored = true
				L_48_:SetAttribute("IsCustomEntity", true)
				if L_47_arg0.CustomName then
					L_48_.Name = L_47_arg0.CustomName
				end
				for L_52_forvar0, L_53_forvar1 in next, L_48_:GetDescendants() do
					if L_53_forvar1:IsA("BasePart") then
						L_53_forvar1.CanCollide = false
					end
				end
				L_21_[L_48_] = {}
				return {
					Model = L_48_,
					Config = L_47_arg0,
					Debug = {
						OnEntitySpawned = function()
						end,
						OnEntityDespawned = function()
						end,
						OnEntityStartMoving = function()
						end,
						OnEntityFinishedRebound = function()
						end,
						OnEntityEnteredRoom = function()
						end,
						OnLookAtEntity = function()
						end,
						OnDeath = function()
						end,
					},
				}
			else
				warn("Failure - Could not find model's PrimaryPart")
			end
		else
			warn("Failure - Could not obtain model")
		end
	end
	L_23_.runEntity = function(L_54_arg0)
		local L_55_ = {}
		for L_60_forvar0, L_61_forvar1 in next, workspace.CurrentRooms:GetChildren() do
			if L_61_forvar1:FindFirstChild("Nodes") then
				local L_62_ = L_61_forvar1.Nodes:GetChildren()
				table.sort(L_62_, function(L_63_arg0, L_64_arg1)
					return L_63_arg0.Name < L_64_arg1.Name
				end)
				for L_65_forvar0, L_66_forvar1 in next, L_62_ do
					L_55_[#L_55_ + 1] = L_66_forvar1
				end
			end
		end
		local L_56_ = workspace.CurrentRooms:GetChildren()[1]
		L_54_arg0.Model.Parent = workspace
		if L_54_arg0.Config.FlickerLights[1] then
			task.spawn(
				L_19_.ModuleEvents.flickerLights,
				workspace.CurrentRooms[L_5_.GameData.LatestRoom.Value],
				L_54_arg0.Config.FlickerLights[2]
			)
		end
		L_54_arg0.Debug.OnEntitySpawned(L_54_arg0)
		task.wait(L_54_arg0.Config.DelayTime or 0)
		local L_57_ = {}
		L_21_[L_54_arg0.Model].Movement = L_4_.Stepped:Connect(function()
			if L_54_arg0.Model.Parent and L_11_.Health > 0 then
				local L_67_ = L_54_arg0.Model.PrimaryPart.Position
				local L_68_ = L_10_.Position
				local L_69_ = L_13_(workspace, Ray.new(L_67_, L_68_ - L_67_), {
					L_54_arg0.Model,
					L_9_
				})
				local L_70_ = Ray.new(L_67_, Vector3.new(0, -4.5 - L_54_arg0.Config.HeightOffset))
				local L_71_ = L_13_(workspace, L_70_, {
					L_54_arg0.Model,
					L_9_
				})
				if L_71_ and (L_71_.Name == "Floor" or string.find(L_71_.Name, "Carpet")) then
					for L_72_forvar0, L_73_forvar1 in next, workspace.CurrentRooms:GetChildren() do
						if L_71_.IsDescendantOf(L_71_, L_73_forvar1) and not table.find(L_57_, L_73_forvar1) then
							L_57_[#L_57_ + 1] = L_73_forvar1
							L_54_arg0.Debug.OnEntityEnteredRoom(L_54_arg0, L_73_forvar1)
						end
					end
				end
				if not L_69_ then
					local L_74_, L_75_ = L_14_(L_12_, L_67_)
					if L_75_ then
						L_54_arg0.Debug.OnLookAtEntity(L_54_arg0)
					end
					if (L_10_.Position - L_54_arg0.Model.PrimaryPart.Position).Magnitude <= L_54_arg0.Config.KillRange then
						local L_76_ = workspace:FindFirstChild("Doggo")
						local L_77_ = L_9_:FindFirstChild("Crucifix")
						if L_76_ or L_77_ then
							L_21_[L_54_arg0.Model].Movement:Disconnect()
							L_21_[L_54_arg0.Model].Drag:Disconnect()
							L_54_arg0.Model:SetAttribute("StopMovement", true)
							if L_77_ then
								L_2_:Play()
								game.StarterGui:SetCore(
									"ChatMakeSystemMessage",
									{
									Text = "GET THAT AWAY FROM ME",
									Color = Color3.fromRGB(255, 0, 0),
									FontSize = Enum.FontSize.Size24,
								}
								)
								local L_78_, L_79_ = nil, math.huge
								for L_80_forvar0, L_81_forvar1 in next, L_55_ do
									local L_82_ = (L_81_forvar1.Position - L_67_).Magnitude
									if L_82_ < L_79_ then
										L_78_, L_79_ = L_80_forvar0, L_82_
									end
								end
								for L_83_forvar0 = L_78_, 1, -1 do
									L_24_func(L_54_arg0.Model, L_55_[L_83_forvar0].Position + Vector3.new(0, 3.5 + L_54_arg0.Config.HeightOffset, 0), 45)
								end
								L_26_func(L_54_arg0)
								return
							end
						end
						if L_54_arg0.Config.CanKill and not L_9_.GetAttribute(L_9_, "Hiding") and not L_27_func() then
							L_21_[L_54_arg0.Model].Movement:Disconnect()
							if L_54_arg0.Config.Jumpscare[1] then
								L_23_.runJumpscare(L_54_arg0.Config.Jumpscare[2])
							end
							L_11_.Health = 0
							L_54_arg0.Debug.OnDeath(L_54_arg0)
							if #L_54_arg0.Config.CustomDialog > 0 then
								L_5_.GameStats["Player_" .. L_8_.Name].Total.DeathCause.Value = L_54_arg0.Model.Name
								debug.setupvalue(
									getconnections(L_5_.Bricks.DeathHint.OnClientEvent)[1].Function,
									1,
									L_54_arg0.Config.CustomDialog
								)
							end
						end
					end
				end
				if L_10_ and L_54_arg0.Model.PrimaryPart then
					local L_84_ = L_54_arg0.Config.CamShake
					local L_85_ = (L_10_.Position - L_54_arg0.Model.PrimaryPart.Position).Magnitude
					if L_84_[1] and L_85_ <= L_84_[3] then
						local L_86_ = {}
						for L_87_forvar0, L_88_forvar1 in next, L_84_[2] do
							L_86_[L_87_forvar0] = L_88_forvar1
						end
						L_86_[1] = L_84_[2][1] / L_84_[3] * (L_84_[3] - L_85_)
						L_19_.MainGame.camShaker.ShakeOnce(L_19_.MainGame.camShaker, table.unpack(L_86_))
						L_86_ = nil
					end
				end
			else
				L_21_[L_54_arg0.Model].Movement:Disconnect()
			end
		end)
		L_54_arg0.Debug.OnEntityStartMoving(L_54_arg0)
		if L_54_arg0.Config.BackwardsMovement then
			local L_89_ = {}
			for L_90_forvar0 = #L_55_, 1, -1 do
				L_89_[#L_89_ + 1] = L_55_[L_90_forvar0]
			end
			L_55_ = L_89_
		end
		local L_58_ = L_54_arg0.Config.Cycles
		local L_59_ = 3.5 + L_54_arg0.Config.HeightOffset
		L_54_arg0.Model:SetPrimaryPartCFrame(L_55_[1].CFrame + Vector3.new(0, 3.5 + L_54_arg0.Config.HeightOffset, 0))
		for L_91_forvar0 = 1, math.random(L_58_.Min, L_58_.Max) do
			for L_92_forvar0 = 1, #L_55_, 1 do
				if not L_54_arg0.Model:GetAttribute("StopMovement") then
					if L_54_arg0.Config.BreakLights then
						L_19_.ModuleEvents.breakLights(L_55_[L_92_forvar0].Parent.Parent)
					end
					L_24_func(L_54_arg0.Model, L_55_[L_92_forvar0].Position + Vector3.new(0, L_59_, 0), L_54_arg0.Config.Speed)
				end
			end
			if L_58_.Max > 1 then
				for L_93_forvar0 = #L_55_, 1, -1 do
					if not L_54_arg0.Model:GetAttribute("StopMovement") then
						L_24_func(L_54_arg0.Model, L_55_[L_93_forvar0].Position + Vector3.new(0, L_59_, 0), L_54_arg0.Config.Speed)
					end
				end
			end
			L_54_arg0.Debug.OnEntityFinishedRebound(L_54_arg0)
			task.wait(L_58_.WaitTime or 0)
		end
		L_26_func(L_54_arg0)
	end
	L_23_.runJumpscare = function(L_94_arg0)
		local L_95_ = LoadCustomAsset(L_94_arg0.Image1)
		local L_96_ = LoadCustomAsset(L_94_arg0.Image2)
		local L_97_, L_98_ = nil, nil
		L_9_:SetPrimaryPartCFrame(CFrame.new(0, 387420489, 0))
		local L_99_ = Instance.new("ScreenGui")
		local L_100_ = Instance.new("Frame")
		local L_101_ = Instance.new("ImageLabel")
		L_99_.Name = "JumpscareGui"
		L_99_.IgnoreGuiInset = true
		L_99_.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		L_100_.Name = "Background"
		L_100_.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		L_100_.BorderSizePixel = 0
		L_100_.Size = UDim2.new(1, 0, 1, 0)
		L_100_.ZIndex = 999
		L_101_.Name = "Face"
		L_101_.AnchorPoint = Vector2.new(0.5, 0.5)
		L_101_.BackgroundTransparency = 1
		L_101_.Position = UDim2.new(0.5, 0, 0.5, 0)
		L_101_.ResampleMode = Enum.ResamplerMode.Pixelated
		L_101_.Size = UDim2.new(0, 150, 0, 150)
		L_101_.Image = L_95_
		L_101_.Parent = L_100_
		L_100_.Parent = L_99_
		L_99_.Parent = L_6_
		if L_94_arg0.Tease[1] then
			if typeof(L_94_arg0.Sound1) == "table" then
				L_97_ = L_25_func(L_94_arg0.Sound1[1], L_94_arg0.Sound1[2])
			end
			local L_102_ = math.random(L_94_arg0.Tease.Min, L_94_arg0.Tease.Max)
			for L_103_forvar0 = L_94_arg0.Tease.Min, L_102_ do
				task.wait(math.random(100, 200) / 100)
				local L_104_ = (L_17_ - L_16_) / L_102_
				L_101_.Size = UDim2.new(0, L_101_.AbsoluteSize.X + L_104_, 0, L_101_.AbsoluteSize.Y + L_104_)
			end
			task.wait(math.random(100, 200) / 100)
		end
		if L_94_arg0.Flashing[1] then
			task.spawn(function()
				while L_99_.Parent do
					L_100_.BackgroundColor3 = L_94_arg0.Flashing[2]
					task.wait(math.random(25, 100) / 1000)
					L_100_.BackgroundColor3 = Color3.new(0, 0, 0)
					task.wait(math.random(25, 100) / 1000)
				end
			end)
		end
		if L_94_arg0.Shake then
			task.spawn(function()
				local L_105_ = L_101_.Position
				while L_99_.Parent do
					L_101_.Position = L_105_ + UDim2.new(0, math.random(-10, 10), 0, math.random(-10, 10))
					L_101_.Rotation = math.random(-5, 5)
					task.wait()
				end
			end)
		end
		if typeof(L_94_arg0.Sound2) == "table" then
			L_98_ = L_25_func(L_94_arg0.Sound2[1], L_94_arg0.Sound2[2])
		end
		L_101_.Image = L_96_
		L_101_.Size = UDim2.new(0, 750, 0, 750)
		L_7_:Create(L_101_, TweenInfo.new(0.75), {
			Size = UDim2.new(0, 2000, 0, 2000),
			ImageTransparency = 0.5
		}):Play()
		task.wait(0.75)
		L_99_:Destroy()
		if L_97_ then
			L_97_:Stop()
		end
		if L_98_ then
			L_98_:Stop()
		end
	end
	local L_28_ = L_23_.createEntity({
		CustomName = "Smiler",
		Model = "https://github.com/PABMAXICHAC/doors-monsters-models/blob/main/Smiler.rbxm?raw=true",
		Speed = 850,
		DelayTime = 0.1,
		HeightOffset = 0,
		CanKill = CanEntityKill,
		BreakLights = true,
		FlickerLights = {
			false,
			10
		},
		Cycles = {
			Min = 2,
			Max = 20,
			WaitTime = 0
		},
		CamShake = {
			true,
			{
				5,
				15,
				0.1,
				1
			},
			100
		},
		Jumpscare = {
			true,
			{
				Image1 = "rbxassetid://11417375410",
				Image2 = "rbxassetid://11417375410",
				Shake = true,
				Sound1 = {
					5263560566,
					{
						Volume = 2.1
					}
				},
				Sound2 = {
					5263560566,
					{
						Volume = 2.1
					}
				},
				Flashing = {
					true,
					Color3.fromRGB(255, 0, 0)
				},
				Tease = {
					false,
					Min = 1,
					Max = 3
				},
			},
		},
		CustomDialog = {
			"I REMEMBER THAT SMILE ...",
			"It seems like u got access to an entity that isn't released yet.",
			"Please report to LSplash#1234 and Redibles#7070 if this happens again.",
		},
	})
	task.spawn(function() L_23_.runEntity(L_28_) end)
	return L_28_.Model
end