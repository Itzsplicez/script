-- taco.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local TacoModule = {}
local tacoSound

function TacoModule.Stop()
    if tacoSound then
        tacoSound:Stop()
        tacoSound:Destroy()
        tacoSound = nil
    end
end

function TacoModule.Play()
    TacoModule.Stop() -- stop existing if any

    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    tacoSound = Instance.new("Sound")
    tacoSound.Name = "RainingTacos"
    tacoSound.SoundId = "rbxassetid://142376088" -- Raining Tacos
    tacoSound.Volume = 1
    tacoSound.Looped = true
    tacoSound.PlaybackSpeed = 1
    tacoSound.Parent = workspace -- put in workspace so others can hear

    -- Make sound follow player
    RunService.Heartbeat:Connect(function()
        if tacoSound and char and char:FindFirstChild("HumanoidRootPart") then
            tacoSound.Position = char.HumanoidRootPart.Position
        end
    end)

    tacoSound:Play()
end

return TacoModule
