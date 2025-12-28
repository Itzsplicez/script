-- aimbot.lua (camera assist)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local Aimbot = {}
local enabled = false
local connection
local smoothness = 0.15 -- lower = snappier

-- Get closest player to crosshair
local function getClosestPlayer()
    local closestPlayer
    local closestDist = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChild("Humanoid")

            if hrp and hum and hum.Health > 0 then
                local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = hrp
                    end
                end
            end
        end
    end

    return closestPlayer
end

function Aimbot.Start()
    if enabled then return end
    enabled = true

    connection = RunService.RenderStepped:Connect(function()
        if not enabled then return end

        local target = getClosestPlayer()
        if target then
            local camCFrame = camera.CFrame
            local targetCFrame = CFrame.new(camCFrame.Position, target.Position)
            camera.CFrame = camCFrame:Lerp(targetCFrame, smoothness)
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
    smoothness = math.clamp(value or 0.15, 0.05, 1)
end

return Aimbot
