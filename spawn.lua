-- Spawn Module
local Players = game:GetService("Players")

-- Use persistent table inside _G to retain spawn
if not _G.SpawnModule then
    local SpawnModule = {}
    _G._spawnPosition = _G._spawnPosition or nil

    function SpawnModule.Set(player)
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            return false, "Character not loaded"
        end
        _G._spawnPosition = char.HumanoidRootPart.Position
        return true, "Spawn point set!"
    end

    function SpawnModule.Teleport(player)
        if not _G._spawnPosition then
            return false, "Spawn point not set"
        end
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(_G._spawnPosition)
            return true, "Teleported to spawn"
        else
            return false, "Character not loaded"
        end
    end

    _G.SpawnModule = SpawnModule
end

return _G.SpawnModule
