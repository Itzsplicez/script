-- reset.lua
-- Forces character death to trigger respawn

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function resetCharacter()
    local char = player.Character
    if not char then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- Force death
        humanoid.Health = 0
        humanoid:ChangeState(Enum.HumanoidStateType.Dead)
    else
        -- Fallback: destroy character
        char:BreakJoints()
    end
end

resetCharacter()
