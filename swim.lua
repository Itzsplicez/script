-- Swim Module
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local SwimModule = {}
SwimModule.Active = false
SwimModule.Connection = nil

function SwimModule.Start()
    if SwimModule.Active then return end
    local char = player.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    local humanoid = char.Humanoid
    SwimModule.Active = true

    SwimModule.Connection = RunService.RenderStepped:Connect(function()
        if not SwimModule.Active then return end
        if humanoid and humanoid.Parent then
            humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
        end
    end)
end

function SwimModule.Stop()
    SwimModule.Active = false
    if SwimModule.Connection then
        SwimModule.Connection:Disconnect()
        SwimModule.Connection = nil
    end
end

-- Set global toggle so gui.lua can call it
_G.ToggleSwim = function(state)
    if state then
        SwimModule.Start()
    else
        SwimModule.Stop()
    end
end
