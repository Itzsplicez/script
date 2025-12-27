local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local RocketModule = {}
local lifting = false
local liftConnection

local player = Players.LocalPlayer

-- Get SayMessageRequest safely
local chatEvent
pcall(function()
    chatEvent = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
end)

local function sayMessage(msg)
    if chatEvent then
        chatEvent:FireServer(msg, "All")
    else
        warn("SayMessageRequest not found, cannot send chat messages.")
    end
end

function RocketModule.Start()
    if lifting then return end
    lifting = true

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")

    -- Countdown
    for i = 3, 1, -1 do
        sayMessage(tostring(i))
        wait(1)
    end
    sayMessage("BLASTOFF!")

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

    -- Say BOOM! in chat
    sayMessage("BOOM!")

    lifting = false
end

return RocketModule
