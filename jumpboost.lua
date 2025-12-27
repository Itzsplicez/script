-- jumpboost.lua
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local JumpBoost = {}
JumpBoost.Active = false
JumpBoost.OriginalJumpPower = nil

function JumpBoost.Enable(power)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    local humanoid = char.Humanoid

    -- Save original jump power if not saved
    if not JumpBoost.OriginalJumpPower then
        JumpBoost.OriginalJumpPower = humanoid.JumpPower
    end

    humanoid.JumpPower = math.clamp(power, 10, 500) -- Limit power between 10 and 500
    JumpBoost.Active = true
end

function JumpBoost.Disable()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    local humanoid = char.Humanoid

    if JumpBoost.OriginalJumpPower then
        humanoid.JumpPower = JumpBoost.OriginalJumpPower
    else
        humanoid.JumpPower = 50 -- default Roblox jump power
    end
    JumpBoost.Active = false
end

return JumpBoost
