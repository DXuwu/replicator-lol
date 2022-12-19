return function(...)
	local L_1_ = game.Players.LocalPlayer.PlayerGui.MainUI
	local L_2_ = L_1_.Initiator.Main_Game.RemoteListener.Modules.HideMonster
	local L_3_ = game:GetService("TweenService")
	local L_4_ = game.Players.LocalPlayer
	function G_1_(L_5_arg0, L_6_arg1)
		if L_5_arg0.dead then
			return
		end
		local L_7_ = game.Lighting.Sanity:Clone()
		L_7_.Name = "LiveSanity"
		L_7_.Enabled = true
		L_7_.Parent = game.Lighting
		local L_8_ = L_1_.SanityVignette:Clone()
		L_8_.Name = "LiveSanityVignette"
		L_8_.Visible = true
		L_8_.Parent = L_1_
		local L_9_ = game.SoundService.Main.SanityEqualizer:Clone()
		L_9_.Name = "SanityEqualizerLive"
		L_9_.Enabled = true
		L_9_.Parent = game.SoundService.Main
		local L_10_ = L_2_.Heartbeat:Clone()
		L_10_.Name = "LiveHeartbeat"
		L_10_.Parent = L_2_
		L_10_:Play()
		local L_11_ = L_2_.Whispers:Clone()
		L_11_.Name = "LiveWhispers"
		L_11_.Parent = L_2_
		L_11_:Play()
		local L_12_ = L_2_.Static:Clone()
		L_12_.Name = "LiveStatic"
		L_12_.Parent = L_2_
		L_12_:Play()
		L_3_:Create(
			L_7_,
			TweenInfo.new(L_6_arg1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
			{
			Saturation = -0.8,
			Contrast = 0.3,
			TintColor = Color3.new(1, 0.9, 0.92)
		}
		):Play()
		L_3_:Create(
			L_8_,
			TweenInfo.new(L_6_arg1 * 0.66, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{
			ImageTransparency = 0,
			Size = UDim2.new(1.2, 0, 1.2, 0)
		}
		):Play()
		L_3_:Create(
			L_8_.DamageVignette,
			TweenInfo.new(L_6_arg1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
			{
			ImageTransparency = 0
		}
		):Play()
		L_3_:Create(
			L_9_,
			TweenInfo.new(L_6_arg1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
			{
			LowGain = 0,
			MidGain = -20,
			HighGain = -40
		}
		):Play()
		L_3_:Create(L_10_, TweenInfo.new(L_6_arg1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			PlaybackSpeed = 2
		}):Play()
		L_3_:Create(L_11_, TweenInfo.new(L_6_arg1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			PlaybackSpeed = 2
		}):Play()
		L_3_:Create(L_10_, TweenInfo.new(L_6_arg1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Volume = 1.6
		}):Play()
		L_3_:Create(L_11_, TweenInfo.new(L_6_arg1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Volume = 1.6
		}):Play()
		local L_13_ = L_5_arg0.camShaker:StartShake(1, 16, L_6_arg1, Vector3.new(0, 0, 0))
		local L_14_ = L_5_arg0.camShaker:StartShake(8, 1, L_6_arg1, Vector3.new(0, 0, 0))
		local L_15_ = tick() + L_6_arg1
		local L_16_ = tick() + L_6_arg1 / 2
		local L_17_ = true
		local L_18_ = L_1_.Jumpscare_Hide
		task.spawn(function()
			pcall(function()
				while L_17_ do
					task.wait()
					local L_19_ = math.clamp(L_10_.PlaybackLoudness * L_10_.Volume / 1000, 0, 0.8)
					L_8_.DamageVignette.ImageColor3 = Color3.new(0.1 + L_19_, L_19_ / 4, L_19_ / 4)
					L_18_.Static.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
					L_18_.Static.Rotation = math.random(0, 1) * 180
					L_18_.Static.ImageTransparency = 1 - L_19_ - math.clamp(L_11_.PlaybackLoudness * L_11_.Volume / 1000, 0, 0.8)
				end
			end)
		end)
		L_18_.Visible = true
		for L_20_forvar0 = 1, 10000 do
			task.wait(0.03333333333333333)
			if L_16_ <= tick() then
				if math.random(1, 20) == 5 then
					L_18_.Overlay.Position = UDim2.new(math.random(30, 70) / 100, 0, math.random(30, 70) / 100, 0)
					L_18_.Overlay.Visible = true
					L_12_.Volume = 0.12
				else
					L_18_.Overlay.Visible = false
					L_12_.Volume = 0
				end
			end
			if L_15_ <= tick() then
			end
			if L_5_arg0.camlock == nil then
			end
			if L_5_arg0.dead then
				break
			end
		end
		L_13_:StartFadeOut(0.3)
		L_14_:StartFadeOut(0.3)
		if L_4_.Character:GetAttribute("HideSickness") and L_5_arg0.dead == false then
			L_5_arg0.camShaker:ShakeOnce(72, 22, 0, 2, Vector3.new(0, 0, 0))
			L_5_arg0.camShaker:ShakeOnce(3, 6, 0, 18, Vector3.new(0, 0, 0))
			L_5_arg0.camShaker:ShakeOnce(12, 0.5, 0, 18, Vector3.new(0, 0, 0))
			L_18_.Overlay.Visible = false
			L_12_.Volume = 0
			L_3_:Create(
				L_7_,
				TweenInfo.new(0.06, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true),
				{
				Brightness = 0.5
			}
			):Play()
			L_2_.Scare:Play()
			wait(2)
			L_3_:Create(
				L_7_,
				TweenInfo.new(15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{
				Saturation = 0,
				Contrast = 0,
				TintColor = Color3.new(1, 1, 1)
			}
			):Play()
			L_3_:Create(
				L_8_,
				TweenInfo.new(15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
				{
				ImageTransparency = 1,
				Size = UDim2.new(1.6, 0, 1.6, 0)
			}
			):Play()
			L_3_:Create(
				L_8_.DamageVignette,
				TweenInfo.new(15, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
				{
				ImageTransparency = 1
			}
			):Play()
			L_3_:Create(
				L_9_,
				TweenInfo.new(15, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
				{
				LowGain = 0,
				MidGain = 0,
				HighGain = 0
			}
			):Play()
			L_3_:Create(L_10_, TweenInfo.new(15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				PlaybackSpeed = 1.2
			})
				:Play()
			L_3_:Create(L_11_, TweenInfo.new(15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				PlaybackSpeed = 1
			}):Play()
			L_3_:Create(L_10_, TweenInfo.new(15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				Volume = 0
			}):Play()
			L_3_:Create(L_11_, TweenInfo.new(15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				Volume = 0
			}):Play()
			wait(15)
		else
			L_13_:StartFadeOut(0.3)
			L_14_:StartFadeOut(0.3)
		end
		L_17_ = false
		L_7_:Destroy()
		L_8_:Destroy()
		L_9_:Destroy()
		L_10_:Destroy()
		L_11_:Destroy()
		L_12_:Destroy()
		L_18_.Visible = false
	end
	G_1_(require(L_1_.Initiator.Main_Game), 0)
	return Instance.new("Model", game:GetService("CoreGui"))
end