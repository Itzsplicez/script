-- selfspin.lua
-- Spins your player around the Y-axis only

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

_G.MilkyWaySpin = _G.MilkyWaySpin or {
    Enabled = false,
    Connection = nil
}

local state = _G.MilkyWaySpin

local function enable()
    if state.Enabled then return end
    state.Enabled = true

    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Spin only around Y-axis
    state.Connection = RunService.Heartbeat:Connect(function(deltaTime)
        if not state.Enabled or not hrp then return end
        local currentCFrame = hrp.CFrame
        local rotation = CFrame.Angles(0, math.rad(200 * deltaTime), 0) -- 200 degrees per second
        hrp.CFrame = currentCFrame * rotation
    end)
end

local function disable()
    state.Enabled = false
    if state.Connection then
        state.Connection:Disconnect()
        state.Connection = nil
    end
end

player.CharacterAdded:Connect(function()
    if state.Enabled then
        task.wait(0.5)
        enable()
    end
end)

_G.ToggleSpin = function(on)
    if on then
        enable()
    else
        disable()
    end
end

-- Auto enable if desired
-- enable()
