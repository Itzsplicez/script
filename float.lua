-- Float module (locks Y-position only, preserves normal movement)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local floatConnection
local floating = false
local targetY = nil

local FloatModule = {}

function FloatModule.Start()
    if floating then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    floating = true
    targetY = char.HumanoidRootPart.Position.Y

    floatConnection = RunService.RenderStepped:Connect(function()
        if not floating then return end
        local hrp = char.HumanoidRootPart
        local pos = hrp.Position

        -- Vertical movement
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            -- Space to move up
            if humanoid.MoveDirection.Magnitude > 0 then
                -- Keep horizontal movement natural
            end
        end

        -- Adjust targetY with input
        local UserInputService = game:GetService("UserInputService")
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            targetY = targetY + 1
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            targetY = targetY - 1
        end

        -- Only lock Y, leave X/Z untouched
        hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)
    end)
end

function FloatModule.Stop()
    floating = false
    if floatConnection then
        floatConnection:Disconnect()
        floatConnection = nil
    end
end

return FloatModule
