return function()
	local L_1_
	local L_4_
	L_1_ = game.ReplicatedStorage.GameData.LatestRoom.Changed:connect(function()
		task.wait(0.8)
		local L_2_ = game.ReplicatedStorage.GameData.LatestRoom.Value - 1
		local L_3_ = workspace.CurrentRooms[L_2_].Door.Door.OriginalCFrameValue.Value
		L_4_ = Instance.new("Part", workspace)
		L_4_.Transparency = 1
		L_4_.CanCollide = false
		L_4_.Anchored = true
		L_4_.CFrame = L_3_ + (L_3_.LookVector * 6) + Vector3.new(0, 3, 0)
		local L_5_ = Instance.new("BillboardGui", L_4_)
		L_5_.Size = UDim2.new(6, 0, 6, 0)
		local L_6_ = Instance.new("ImageLabel", L_5_)
		L_6_.Image = "rbxassetid://10981095221"
		L_6_.Size = UDim2.new(1, 0, 1, 0)
		L_6_.BackgroundTransparency = 1
		L_6_.ImageTransparency = 0.4
		L_6_.Rotation = -5
		local L_7_ = Instance.new("Sound", L_4_)
		if not isfile("shadow.mp3") then
			writefile("shadow.mp3", game:HttpGet("https://github.com/sponguss/storage/raw/main/shadowJumpscare.mp3"))
		end
		L_7_.SoundId = (getsynasset or getcustomasset)("shadow.mp3")
		L_7_:Play()
		require(game.ReplicatedStorage.ClientModules.Module_Events).flickerLights(L_2_ + 1, 0.75)
		task.wait(L_7_.TimeLength)
		L_4_:Destroy()
		L_1_:Disconnect()
	end)
	repeat task.wait() until L_4_~=nil
	return L_4_
end