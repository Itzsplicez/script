-- jump.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local jumpModule = {}
local infJumpEnabled = false
local connection = nil

local function setup()
    if connection then return end
    connection = UserInputService.JumpRequest:Connect(function()
        if infJumpEnabled then
            local char = Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

function jumpModule.Enable()
    infJumpEnabled = true
    setup()
end

function jumpModule.Disable()
    infJumpEnabled = false
end

-- Auto-setup on respawn
Players.LocalPlayer.CharacterAdded:Connect(function()
    wait(0.1)
    if infJumpEnabled then
        setup()
    end
end)

return jumpModule
