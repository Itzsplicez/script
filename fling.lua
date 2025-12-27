-- Fling Module (Player-based, GUI-compatible)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local FlingModule = {}
FlingModule.Active = false
FlingModule.Connection = nil
FlingModule.Thrust = nil

-- Internal stop
function FlingModule.Stop()
    FlingModule.Active = false

    if FlingModule.Connection then
        FlingModule.Connection:Disconnect()
        FlingModule.Connection = nil
    end

    if FlingModule.Thrust then
        FlingModule.Thrust:Destroy()
        FlingModule.Thrust = nil
    end
end

-- Internal fling logic
local function aggressiveFling(targetPlayer)
    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not targetPlayer.Character then return end
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end

    -- Create thrust
    local thrust = Instance.new("BodyThrust")
    thrust.Name = "FlingThrust"
    thrust.Force = Vector3.new(9999, 9999, 9999)
    thrust.Location = hrp.Position
    thrust.Parent = hrp

    FlingModule.Thrust = thrust
    FlingModule.Active = true

    FlingModule.Connection = RunService.Heartbeat:Connect(function()
        if not FlingModule.Active then
            FlingModule.Stop()
            return
        end

        if not targetPlayer.Character
        or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            FlingModule.Stop()
            return
        end

        hrp.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        thrust.Location = targetPlayer.Character.HumanoidRootPart.Position
    end)
end

-- Public start (expects Player object)
function FlingModule.Start(targetPlayer)
    if FlingModule.Active then
        FlingModule.Stop()
    end

    if not targetPlayer or not targetPlayer:IsA("Player") then
        return false, "Invalid target"
    end

    aggressiveFling(targetPlayer)
    return true, "Flinging " .. targetPlayer.Name
end

-- 🔗 GUI Interface (what your terminal uses)
_G.ToggleFling = function(state, targetPlayer)
    if state then
        return FlingModule.Start(targetPlayer)
    else
        FlingModule.Stop()
        return true, "Fling stopped"
    end
end

return FlingModule
