-- fling.lua
-- Touch-based fling (toggleable)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

_G.MilkyWayFling = _G.MilkyWayFling or {
	Enabled = false,
	Connection = nil,
	Angular = nil
}

local state = _G.MilkyWayFling

local function getHRP()
	local char = player.Character
	if not char then return end
	return char:FindFirstChild("HumanoidRootPart")
end

local function enable()
	if state.Enabled then return end
	state.Enabled = true

	local hrp = getHRP()
	if not hrp then return end

	local bav = Instance.new("BodyAngularVelocity")
	bav.AngularVelocity = Vector3.new(0, 1e5, 0)
	bav.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
	bav.P = 1e9
	bav.Parent = hrp
	state.Angular = bav

	state.Connection = RunService.Stepped:Connect(function()
		if not state.Enabled then return end
		if hrp then
			hrp.AssemblyAngularVelocity = Vector3.new(0, 1e5, 0)
		end
	end)
end

local function disable()
	state.Enabled = false

	if state.Connection then
		state.Connection:Disconnect()
		state.Connection = nil
	end

	if state.Angular then
		state.Angular:Destroy()
		state.Angular = nil
	end

	local hrp = getHRP()
	if hrp then
		hrp.AssemblyAngularVelocity = Vector3.zero
	end
end

-- Respawn support
player.CharacterAdded:Connect(function()
	if state.Enabled then
		task.wait(0.5)
		enable()
	end
end)

_G.ToggleFling = function(on)
	if on then
		enable()
	else
		disable()
	end
end

-- Auto enable when loaded
enable()
