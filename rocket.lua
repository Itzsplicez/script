local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RocketModule = {}
local lifting = false
local liftConnection

local player = Players.LocalPlayer
local chatEvent = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")

function RocketModule.Start()
    if lifting then return end
    lifting = true

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")

    -- Countdown
    for i = 3,2,1 do
        chatEvent:FireServer(tostring(i), "All")
        wait(1)
    end
    chatEvent:FireServer("BLASTOFF!", "All")

    -- Lift player for 4 seconds
    local duration = 4
    local speed = 150
    local elapsed = 0
    liftConnection = RunService.RenderStepped:Connect(function(dt)
        if hrp and hrp.Parent then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, speed * dt, 0)
        end
    end)

    while elapsed < duration do
        wait(0.1)
        elapsed = elapsed + 0.1
    end

    if liftConnection then
        liftConnection:Disconnect()
        liftConnection = nil
    end

    -- Reset character
    if humanoid then
        humanoid.Health = 0
    end

    -- Say BOOM! in normal chat
    chatEvent:FireServer("BOOM!", "All")

    lifting = false
end

return RocketModule
