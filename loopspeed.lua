-- Loopspeed module
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local loopConnection
local LoopSpeedModule = {}

function LoopSpeedModule.Start(speed)
    local speedNum = tonumber(speed)
    if not speedNum or speedNum < 1 or speedNum > 100 then
        return false, "Invalid speed! Use 1-100"
    end

    -- Stop previous loop if it exists
    if loopConnection then
        loopConnection:Disconnect()
        loopConnection = nil
    end

    -- Start looping
    loopConnection = RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = speedNum
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
