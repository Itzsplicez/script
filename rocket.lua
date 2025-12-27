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
    local humanoid = char:FindFirstChild("Humanoid")

    -- Countdown 3..2..1 said in chat
    for i = 3,1,-1 do
        if char:FindFirstChild("Head") then
            ChatService:Chat(char.Head, tostring(i), Enum.ChatColor.Red)
        end
        wait(1)
    end

    -- BLASTOFF message
    if char:FindFirstChild("Head") then
        ChatService:Chat(char.Head, "BLASTOFF!", Enum.ChatColor.Red)
    end

    -- Lift player upwards continuously until death/reset
    local speed = 150 -- studs per second
    liftConnection = RunService.RenderStepped:Connect(function(dt)
        if hrp and hrp.Parent then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, speed * dt, 0)
        end
    end)

    -- Wait until humanoid dies / breaks
    if humanoid then
        humanoid.Died:Wait()
    end

    -- Stop the lift
    if liftConnection then
        liftConnection:Disconnect()
        liftConnection = nil
    end

    lifting = false
end

return RocketModule
