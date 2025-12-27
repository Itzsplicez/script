-- Loopspeed module
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local loopConnection
local LoopSpeedModule = {}
local loopSpeedNum = 16
local tempDefaultTimer

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

    loopConnection = RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = loopSpeedNum
        end
    end)

    print("Loopspeed started at "..speedNum)
    return true
end

-- Stop looping speed and optionally enforce default for 6 seconds
function LoopSpeedModule.Stop()
    if loopConnection then
        loopConnection:Disconnect()
        loopConnection = nil
    end

    -- If a previous timer exists, cancel it
    if tempDefaultTimer then
        tempDefaultTimer:Disconnect()
        tempDefaultTimer = nil
    end

    -- Enforce default speed (16) for 6 seconds
    local startTime = tick()
    tempDefaultTimer = RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
        if tick() - startTime >= 6 then
            tempDefaultTimer:Disconnect()
            tempDefaultTimer = nil
        end
    end)

    print("Loopspeed stopped. Default speed enforced for 6 seconds")
end

return LoopSpeedModule
-- Loopspeed module
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local loopConnection
local LoopSpeedModule = {}
local loopSpeedNum = 16
local tempDefaultTimer

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

    loopConnection = RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = loopSpeedNum
        end
    end)

    print("Loopspeed started at "..speedNum)
    return true
end

-- Stop looping speed and optionally enforce default for 6 seconds
function LoopSpeedModule.Stop()
    if loopConnection then
        loopConnection:Disconnect()
        loopConnection = nil
    end

    -- If a previous timer exists, cancel it
    if tempDefaultTimer then
        tempDefaultTimer:Disconnect()
        tempDefaultTimer = nil
    end

    -- Enforce default speed (16) for 6 seconds
    local startTime = tick()
    tempDefaultTimer = RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
        if tick() - startTime >= 6 then
            tempDefaultTimer:Disconnect()
            tempDefaultTimer = nil
        end
    end)

    print("Loopspeed stopped. Default speed enforced for 6 seconds")
end

return LoopSpeedModule
