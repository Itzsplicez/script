-- jump.lua
-- Infinite Jump Module

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local jumpModule = {}
local infJumpEnabled = false
local connection = nil

function jumpModule.Enable()
    if connection then return end
    infJumpEnabled = true
    connection = UserInputService.JumpRequest:Connect(function()
        if infJumpEnabled then
            local char = Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

function jumpModule.Disable()
    infJumpEnabled = false
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

return jumpModule
