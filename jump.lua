local Players = game:GetService("Players")
local player = Players.LocalPlayer

local jumpModule = {}
local enabled = false
local jumpConnection

local function forceJump()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if humanoid and hrp then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 60, hrp.Velocity.Z)
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

function jumpModule.Enable()
    if enabled then return end
    enabled = true

    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        jumpConnection = humanoid.Jumping:Connect(function(active)
            if enabled and active then
                forceJump()
            end
        end)
    end
end

function jumpModule.Disable()
    enabled = false
    if jumpConnection then
        jumpConnection:Disconnect()
        jumpConnection = nil
    end
end

function jumpModule.Jump()
    if enabled then
        forceJump()
    end
end

return jumpModule
