-- Loopspeed module
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local loopConnection
local LoopSpeedModule = {}
local loopSpeedNum = 16

-- Start looping speed every 0.5 seconds
function LoopSpeedModule.Start(speed)
    local speedNum = tonumber(speed)
    if not speedNum or speedNum < 1 or speedNum > 100 then
        return false, "Invalid speed! Use 1-100"
    end

    loopSpeedNum = speedNum

    -- Stop previous loop if it exists
    if loopConnection then
        loopConnection:Disconnect()
        loopConnection = nil
    end

    loopConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not player.Character or not player.Character:FindFirstChild("Humanoid") then return end
        -- Only update every 0.5 seconds
        loopConnection = loopConnection or RunService.Heartbeat:Connect(function() end) -- dummy to keep connection
        player.Character.Humanoid.WalkSpeed = loopSpeedNum
    end)

    -- Use a simple timer for 0.5s interval
    spawn(function()
        while loopConnection do
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = loopSpeedNum
            end
            wait(0.5)
        end
    end)

    print("Loopspeed started at "..speedNum)
    return true
end

function LoopSpeedModule.Stop()
    if loopConnection then
        loopConnection:Disconnect()
        loopConnection = nil
    end

    -- Reset speed to default
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
    end

    print("Loopspeed stopped and speed reset to 16")
end

return LoopSpeedModule
