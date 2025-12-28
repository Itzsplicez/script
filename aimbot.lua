local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local Aimbot = {}
local enabled = false
local connection
local smoothness = 0.15
local maxDistance = 1000

local humanoid
local hrp
local oldAutoRotate

-- Find closest player by 3D distance
local function getClosestTarget()
    local closestHRP
    local closestDist = math.huge
    local camPos = camera.CFrame.Position

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local targetHRP = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChild("Humanoid")

            if targetHRP and hum and hum.Health > 0 then
                local dist = (targetHRP.Position - camPos).Magnitude
                if dist < closestDist and dist <= maxDistance then
                    closestDist = dist
                    closestHRP = targetHRP
                end
            end
        end
    end

    return closestHRP
end

function Aimbot.Start()
    if enabled then return end
    enabled = true

    local char = player.Character or player.CharacterAdded:Wait()
    humanoid = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")

    -- Disable AutoRotate so we can control character rotation
    oldAutoRotate = humanoid.AutoRotate
    humanoid.AutoRotate = false

    connection = RunService.RenderStepped:Connect(function()
        if not enabled then return end

        local target = getClosestTarget()
        if target and hrp then
            -- Rotate player toward target (Y-axis only)
            local direction = (Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z) - hrp.Position).Unit
            local lookCFrame = CFrame.new(hrp.Position, hrp.Position + direction)
            hrp.CFrame = hrp.CFrame:Lerp(lookCFrame, smoothness)
        end
    end)
end

function Aimbot.Stop()
    enabled = false

    if connection then
        connection:Disconnect()
        connection = nil
    end

    -- Restore AutoRotate
    if humanoid then
        humanoid.AutoRotate = oldAutoRotate ~= false
    end
end

function Aimbot.SetSmoothness(value)
    smoothness = math.clamp(tonumber(value) or smoothness, 0.05, 1)
end

function Aimbot.SetMaxDistance(dist)
    maxDistance = tonumber(dist) or maxDistance
end

return Aimbot
