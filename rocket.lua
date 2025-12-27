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

    -- Countdown 3..2..1 said in chat
    for i = 3,1,-1 do
        if char:FindFirstChild("Head") then
            ChatService:Chat(char.Head, tostring(i), Enum.ChatColor.Red)
        end
        wait(1)
    end

    -- Lift player straight up
    local targetHeight = hrp.Position.Y + 300 -- lift 300 studs
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

    -- Say BOOM in chat
    if char:FindFirstChild("Head") then
        ChatService:Chat(char.Head, "BOOM!", Enum.ChatColor.Red)
    end

    -- Reset the player (simulate explosion)
    if char:FindFirstChild("Humanoid") then
        char:BreakJoints()
    end

    lifting = false
end

return RocketModule
