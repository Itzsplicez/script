-- Float module
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local floatConnection
local floating = false
local targetY = nil

local FloatModule = {}

function FloatModule.Start()
    if floating then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    floating = true
    targetY = char.HumanoidRootPart.Position.Y

    local hrp = char.HumanoidRootPart
    local velocity = Instance.new("BodyVelocity")
    velocity.MaxForce = Vector3.new(400000,400000,400000)
    velocity.Velocity = Vector3.new(0,0,0)
    velocity.Parent = hrp

    local cam = workspace.CurrentCamera

    floatConnection = RunService.RenderStepped:Connect(function()
        if not floating then return end
        local direction = Vector3.new(0,0,0)
        local pos = hrp.Position

        -- Horizontal movement
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + cam.CFrame.RightVector
        end

        -- Vertical movement
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            targetY = targetY + 1 -- move up
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            targetY = targetY - 1 -- move down
        end

        if direction.Magnitude > 0 then
            direction = direction.Unit * 16 -- horizontal speed
        end

        -- Apply velocity without changing WalkSpeed
        velocity.Velocity = Vector3.new(direction.X, (targetY - pos.Y) * 5, direction.Z)
    end)
end

function FloatModule.Stop()
    floating = false
    if floatConnection then
        floatConnection:Disconnect()
        floatConnection = nil
    end
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        for _, v in ipairs(char.HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
end

return FloatModule
