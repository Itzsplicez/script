-- rocket.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local RocketModule = {}
local lifting = false
local liftConnection

-- Helper: show a message on all players' screens
local function showMessageForAll(text, duration, size, position)
    for _, plr in pairs(Players:GetPlayers()) do
        local gui = plr:FindFirstChild("PlayerGui")
        if gui then
            local screen = Instance.new("ScreenGui")
            screen.Name = "RocketMessage"
            screen.Parent = gui

            local label = Instance.new("TextLabel")
            label.Size = size or UDim2.new(0, 400, 0, 100)
            label.Position = position or UDim2.new(0.5, -200, 0.2, 0)
            label.Text = text
            label.Font = Enum.Font.SourceSansBold
            label.TextSize = 72
            label.TextColor3 = Color3.fromRGB(255, 0, 0)
            label.BackgroundTransparency = 1
            label.Parent = screen

            delay(duration or 2, function()
                if screen then screen:Destroy() end
            end)
        end
    end
end

function RocketModule.Start(player)
    if lifting then return end
    lifting = true

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- Countdown 3..2..1 visible to everyone
    for i = 3, 1, -1 do
        showMessageForAll(tostring(i), 1, UDim2.new(0, 200, 0, 50), UDim2.new(0.5, -100, 0.1, 0))
        wait(1)
    end

    -- Lift player for 4 seconds
    local duration = 4
    local speed = 50
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

    -- Reset player (simulate explosion)
    if char and char:FindFirstChild("Humanoid") then
        char:BreakJoints()
    end

    -- Show BOOM to everyone
    showMessageForAll("BOOM!", 2)

    lifting = false
end

return RocketModule
