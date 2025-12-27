-- spin.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local SpinModule = {}
local spinning = false
local spinConnection

function SpinModule.Start(speed)
    speed = speed or 5 -- default spin speed
    if spinning then return end
    spinning = true

    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    spinConnection = RunService.RenderStepped:Connect(function(delta)
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

return SpinModule
