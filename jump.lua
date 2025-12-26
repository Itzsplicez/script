local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local jumpModule = {}
local enabled = false
local jumpConn

local function forceJump()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if humanoid and hrp then
        -- This applies upward velocity, allowing jumps mid-air
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 60, hrp.Velocity.Z)
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

function jumpModule.Enable()
    if enabled then return end
    enabled = true

    -- Connect to Heartbeat to force jump every frame if enabled (works better cross-device)
    jumpConn = RunService.Heartbeat:Connect(function()
        if enabled then
            forceJump()
        end
    end)
end

function jumpModule.Disable()
    enabled = false
    if jumpConn then
        jumpConn:Disconnect()
        jumpConn = nil
    end
end

function jumpModule.Jump()
    if enabled then
        forceJump()
    end
end

return jumpModule
