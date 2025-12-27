-- rocket.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ChatService = game:GetService("Chat")

local RocketModule = {}
local lifting = false
local liftConnection

function RocketModule.Start(player)
    if lifting then return end
    lifting = true

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- Lift player straight up to a high Y position
    local targetHeight = hrp.Position.Y + 300 -- go 300 studs up
    local speed = 200 -- studs per second

    liftConnection = RunService.RenderStepped:Connect(function(dt)
        if hrp and hrp.Parent then
            local currentY = hrp.Position.Y
            if currentY < targetHeight then
                local newY = math.min(currentY + speed * dt, targetHeight)
                hrp.CFrame = CFrame.new(hrp.Position.X, newY, hrp.Position.Z)
            end
        end
    end)

    -- Wait until reaching target height
    repeat wait(0.05) until hrp.Position.Y >= targetHeight

    -- Stop the lift
    if liftConnection then
        liftConnection:Disconnect()
        liftConnection = nil
    end

    -- Make the character say BOOM in chat
    if char and char:FindFirstChild("Head") then
        ChatService:Chat(char.Head, "BOOM!", Enum.ChatColor.Red)
    end

    -- Reset the player
    if char and char:FindFirstChild("Humanoid") then
        char:BreakJoints()
    end

    lifting = false
end

return RocketModule
