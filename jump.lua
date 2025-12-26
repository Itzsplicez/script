local Players = game:GetService("Players")
local player = Players.LocalPlayer

local jumpModule = {}
local enabled = false

local function forceJump()
	local character = player.Character
	if not character then return end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if humanoid and hrp then
		-- Apply upward velocity for infinite jump effect
		hrp.Velocity = Vector3.new(hrp.Velocity.X, 60, hrp.Velocity.Z)
	end
end

function jumpModule.Enable()
	if enabled then return end
	enabled = true

	local character = player.Character
	if not character then
		player.CharacterAdded:Wait()
		character = player.Character
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		-- Connect to Humanoid.Jumping to catch jump button on mobile
		jumpModule._jumpConn = humanoid.Jumping:Connect(function(active)
			if enabled and active then
				forceJump()
			end
		end)
	end
end

function jumpModule.Disable()
	enabled = false
	if jumpModule._jumpConn then
		jumpModule._jumpConn:Disconnect()
		jumpModule._jumpConn = nil
	end
end

function jumpModule.Jump()
	if enabled then
		forceJump()
	end
end

return jumpModule
