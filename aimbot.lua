-- aimbot.lua (dynamic closest-player aimbot)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local Aimbot = {}
local enabled = false
local connection
local smoothness = 0.15 -- lower = faster snap
local maxDistance = 1000 -- studs (optional limit)

-- Get closest player by 3D distance
local function getClosestPlayer()
    local closestHRP = nil
    local closestDist = math.huge

    local camPos = camera.CFrame.Position

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChild("Humanoid")

            if hrp and hum and hum.Health > 0 then
                local dist = (hrp.Position - camPos).Magnitude
                if dist < closestDist and dist <= maxDistance then
                    closestDist = dist
                    closestHRP = hrp
                end
            end
        end
    end

    return closestHRP
end

function Aimbot.Start()
    if enabled then return end
    enabled = true

    connection = RunService.RenderStepped:Connect(function()
        if not enabled then return end

        local target = getClosestPlayer()
        if target then
            local camCFrame = camera.CFrame
            local newCFrame = CFrame.new(camCFrame.Position, target.Position)
            camera.CFrame = camCFrame:Lerp(newCFrame, smoothness)
        end
    end)
end

function Aimbot.Stop()
    enabled = false
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

function Aimbot.SetSmoothness(value)
    smoothness = math.clamp(tonumber(value) or 0.15, 0.05, 1)
end

function Aimbot.SetMaxDistance(dist)
    maxDistance = tonumber(dist) or maxDistance
end

return Aimbot
