local Players = game:GetService("Players")
local soundId = "rbxassetid://142376088" -- Raining Tacos

local function playTacos()
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if not char.HumanoidRootPart:FindFirstChild("RainingTacos") then
                local tacoSound = Instance.new("Sound")
                tacoSound.Name = "RainingTacos"
                tacoSound.SoundId = soundId
                tacoSound.Volume = 1
                tacoSound.Looped = true
                tacoSound.Parent = char.HumanoidRootPart
                tacoSound:Play()
            end
        end
    end
end

local function stopTacos()
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local tacoSound = char.HumanoidRootPart:FindFirstChild("RainingTacos")
            if tacoSound then
                tacoSound:Stop()
                tacoSound:Destroy()
            end
        end
    end
end

-- Example usage
-- playTacos()  -- /tacos
-- stopTacos()  -- /tacos off
