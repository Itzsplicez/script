-- noclip.lua
-- Toggleable Noclip Script (supports /noclip off)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Global state (prevents duplicates)
_G.MilkyWayNoclip = _G.MilkyWayNoclip or {
	Enabled = false,
	Connection = nil
}

local state = _G.MilkyWayNoclip

-- Apply noclip
local function applyNoclip(character)
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end
end

-- Restore collisions
local function restoreCollision(character)
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = true
		end
	end
end

-- Enable noclip
local function enable()
	if state.Enabled then return end
	state.Enabled = true

	state.Connection = RunService.Stepped:Connect(function()
		if not state.Enabled then return end
		local char = player.Character
		if char then
			applyNoclip(char)
		end
	end)
end

-- Disable noclip
local function disable()
	state.Enabled = false

	if state.Connection then
		state.Connection:Disconnect()
		state.Connection = nil
	end

	local char = player.Character
	if char then
		restoreCollision(char)
	end
end

-- Respawn support
player.CharacterAdded:Connect(function(char)
	if state.Enabled then
		task.wait(0.5)
		applyNoclip(char)
	end
end)

-- Global toggle function (used by GUI)
_G.ToggleNoclip = function(on)
	if on then
		enable()
	else
		disable()
	end
end

-- Auto-enable when script is run
enable()
