-- float.lua
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local FloatModule = {}
local floating = false
local floatConnection
local bodyPosition

local flySpeed = 50 -- movement speed in air

function FloatModule.Start()
    if floating then return end
    floating = true

    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
    local hrp = char.HumanoidRootPart
    local humanoid = char.Humanoid

    -- Disable default gravity movement
    humanoid.PlatformStand = true

    -- BodyPosition to hold height
    bodyPosition = Instance.new("BodyPosition")
    bodyPosition.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyPosition.D = 10
    bodyPosition.P = 3000
    bodyPosition.Position = hrp.Position
    bodyPosition.Parent = hrp

    floatConnection = RunService.RenderStepped:Connect(function()
        if not floating then return end

        local cam = workspace.CurrentCamera
        local moveDirection = Vector3.new(0,0,0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + cam.CFrame.RightVector
        end

        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * flySpeed
        end

        -- Keep same Y height
        local targetPos = hrp.Position + Vector3.new(moveDirection.X, 0, moveDirection.Z)
        bodyPosition.Position = targetPos
    end)
end

function FloatModule.Stop()
    floating = false
    if floatConnection then
        floatConnection:Disconnect()
        floatConnection = nil
    end

    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if hrp then
            if bodyPosition then
                bodyPosition:Destroy()
                bodyPosition = nil
            end
        end
        if humanoid then
            humanoid.PlatformStand = false -- restore normal movement
        end
    end
end

return FloatModule
