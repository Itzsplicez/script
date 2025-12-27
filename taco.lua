-- taco.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local TacoModule = {}
local tacoSound

-- Stops existing taco sound
function TacoModule.Stop()
    if tacoSound then
        tacoSound:Stop()
        tacoSound:Destroy()
        tacoSound = nil
    end
end

-- Plays the taco sound
function TacoModule.Play()
    TacoModule.Stop() -- stop existing if any

    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    tacoSound = Instance.new("Sound")
    tacoSound.Name = "RainingTacos"
    tacoSound.SoundId = "rbxassetid://142376088" -- Raining Tacos
    tacoSound.Volume = 1
    tacoSound.Looped = true
    tacoSound.Parent = char.HumanoidRootPart
    tacoSound:Play()
end

return TacoModule
