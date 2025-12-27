-- Float module using invisible platform
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local floatConnection
local platform
local floating = false
local targetY = nil

local FloatModule = {}

function FloatModule.Start()
    if floating then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    floating = true

    targetY = char.HumanoidRootPart.Position.Y

    -- Create invisible anchored platform
    platform = Instance.new("Part")
    platform.Size = Vector3.new(6, 0.5, 6)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 1
    platform.Position = Vector3.new(char.HumanoidRootPart.Position.X, targetY - 3, char.HumanoidRootPart.Position.Z)
    platform.Parent = workspace

    floatConnection = RunService.RenderStepped:Connect(function()
        if not floating or not char or not char:FindFirstChild("HumanoidRootPart") then return end

        local hrp = char.HumanoidRootPart
        local UserInputService = game:GetService("UserInputService")

        -- Adjust targetY with input
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            targetY = targetY + 0.5
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            targetY = targetY - 0.5
        end

        -- Keep platform just under the player
        platform.Position = Vector3.new(hrp.Position.X, targetY - 3, hrp.Position.Z)
    end)
end

function FloatModule.Stop()
    floating = false
    if floatConnection then
        floatConnection:Disconnect()
        floatConnection = nil
    end
    if platform then
        platform:Destroy()
        platform = nil
    end
end

return FloatModule
