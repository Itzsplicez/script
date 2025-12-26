local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local infiniteJumpEnabled = true

UserInputService.JumpRequest:Connect(function()
	if infiniteJumpEnabled then
		local character = player.Character
		if character and character:FindFirstChild("Humanoid") then
			character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)
