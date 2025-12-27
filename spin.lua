-- spin.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Only create one global SpinModule
if _G.SpinModule then
    return _G.SpinModule
end

local SpinModule = {}
local spinning = false
local spinConnection
local hrp

-- Ensure HRP is always valid (handles respawns)
local function getHRP()
    local char = player.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

function SpinModule.Start(speed)
    speed = speed or 500
    if spinning then return end
    spinning = true

    hrp = getHRP()
    if not hrp then
        player.CharacterAdded:Wait()
        hrp = getHRP()
        if not hrp then return end
    end

    spinConnection = RunService.RenderStepped:Connect(function()
        if spinning and hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(speed), 0)
        end
    end)
end

function SpinModule.Stop()
    spinning = false
    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end
end

-- Reattach HRP if character respawns
player.CharacterAdded:Connect(function(char)
    hrp = char:WaitForChild("HumanoidRootPart")
end)

-- Store globally so /spin off works
_G.SpinModule = SpinModule
return SpinModule
