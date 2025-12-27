-- rocket.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local RocketModule = {}
local lifting = false
local liftConnection

function RocketModule.Start(player)
    if lifting then return end
    lifting = true

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- Countdown 3..2..1 visible to everyone
    for i = 3,1,-1 do
        for _, plr in pairs(Players:GetPlayers()) do
            local gui = plr:FindFirstChild("PlayerGui")
            if gui then
                local screen = Instance.new("ScreenGui", gui)
                screen.Name = "RocketCountdown"
                local label = Instance.new("TextLabel", screen)
                label.Size = UDim2.new(0, 200, 0, 50)
                label.Position = UDim2.new(0.5, -100, 0.1, 0)
                label.Text = tostring(i)
                label.Font = Enum.Font.SourceSansBold
                label.TextSize = 48
                label.TextColor3 = Color3.fromRGB(255, 0, 0)
                label.BackgroundTransparency = 1
                delay(1, function() screen:Destroy() end)
            end
        end
        wait(1)
    end

    -- Lift player for 4 seconds
    local duration = 4
    local speed = 50
    local elapsed = 0
    liftConnection = RunService.RenderStepped:Connect(function(dt)
        if hrp then
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

    -- Reset player (simulate explosion)
    if char:FindFirstChild("Humanoid") then
        char:BreakJoints()
    end

    -- BOOM message to everyone
    for _, plr in pairs(Players:GetPlayers()) do
        local gui = plr:FindFirstChild("PlayerGui")
        if gui then
            local screen = Instance.new("ScreenGui", gui)
            screen.Name = "RocketBoom"
            local label = Instance.new("TextLabel", screen)
            label.Size = UDim2.new(0, 400, 0, 100)
            label.Position = UDim2.new(0.5, -200, 0.2, 0)
            label.Text = "BOOM!"
            label.Font = Enum.Font.SourceSansBold
            label.TextSize = 72
            label.TextColor3 = Color3.fromRGB(255, 0, 0)
            label.BackgroundTransparency = 1
            delay(2, function() screen:Destroy() end)
        end
    end

    lifting = false
end

return RocketModule
