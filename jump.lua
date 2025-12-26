local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local jumpModule = {}
local enabled = false

local function forceJump()
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.Velocity = Vector3.new(hrp.Velocity.X, 60, hrp.Velocity.Z)
	end
end

function jumpModule.Enable()
	enabled = true
end

function jumpModule.Disable()
	enabled = false
end

function jumpModule.Jump()
	if enabled then
		forceJump()
	end
end

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if enabled and input.KeyCode == Enum.KeyCode.Space then
		forceJump()
	end
end)

return jumpModule
