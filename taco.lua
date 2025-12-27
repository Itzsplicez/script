-- taco.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local TacoModule = {}
local tacoSound
local heartbeatConnection

-- Stops the taco sound
function TacoModule.Stop()
    if tacoSound then
        tacoSound:Stop()
        tacoSound:Destroy()
        tacoSound = nil
    end
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
end

-- Plays the taco sound
function TacoModule.Play()
    TacoModule.Stop() -- Stop any existing sound

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    tacoSound = Instance.new("Sound")
    tacoSound.SoundId = "rbxassetid://142376088" -- Raining Tacos
    tacoSound.Volume = 1
    tacoSound.Looped = true
    tacoSound.PlaybackSpeed = 1
    tacoSound.Parent = hrp -- attach to player so it follows

    -- Update sound position every frame (optional)
    heartbeatConnection = RunService.Heartbeat:Connect(function()
        if tacoSound and hrp then
            tacoSound.Position = hrp.Position
        end
    end)

    tacoSound:Play()
end

return TacoModule
