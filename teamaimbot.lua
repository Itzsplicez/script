-- teamaimbot.lua

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local TeamAimbot = {}
local enabled = false
local connection

local smoothness = 0.15
local maxDistance = 1000

local humanoid
local hrp
local oldAutoRotate

local function getClosestEnemy()
    local closestHRP
    local closestDist = math.huge
    local myTeam = player.Team
    local camPos = camera.CFrame.Position

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Team ~= myTeam and plr.Character then
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

function TeamAimbot.Start()
    if enabled then return end
    enabled = true

    local char = player.Character or player.CharacterAdded:Wait()
    humanoid = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")

    oldAutoRotate = humanoid.AutoRotate
    humanoid.AutoRotate = false

    connection = RunService.RenderStepped:Connect(function()
        if not enabled then return end

        local target = getClosestEnemy()
        if target and hrp then
            local lookPos = Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z)
            local targetCF = CFrame.new(hrp.Position, lookPos)
            hrp.CFrame = hrp.CFrame:Lerp(targetCF, smoothness)
        end
    end)
end

function TeamAimbot.Stop()
    enabled = false

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if humanoid then
        humanoid.AutoRotate = oldAutoRotate ~= false
    end
end

return TeamAimbot
