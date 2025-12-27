-- fling.lua
-- Touch-based fling (toggleable, does NOT fling yourself)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer

_G.MilkyWayFling = _G.MilkyWayFling or {
    Enabled = false,
    Connection = nil
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

    -- Connect touch event
    state.Connection = hrp.Touched:Connect(function(hit)
        local hitPlayer = Players:GetPlayerFromCharacter(hit.Parent)
        if hitPlayer and hitPlayer ~= player then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            bv.Velocity = (hit.Position - hrp.Position).Unit * 100
            bv.Parent = hit
            Debris:AddItem(bv, 0.2)
        end
    end)
end

local function disable()
    state.Enabled = false
    if state.Connection then
        state.Connection:Disconnect()
        state.Connection = nil
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
