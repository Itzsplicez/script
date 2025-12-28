-- sit.lua
local SitModule = {}

function SitModule.Toggle(player)
    local char = player.Character
    if not char or not char:FindFirstChild("Humanoid") then
        return false, "Character not loaded"
    end
    local humanoid = char.Humanoid
    humanoid.Sit = not humanoid.Sit
    return true, humanoid.Sit and "Sitting now" or "Standing up"
end

return SitModule
