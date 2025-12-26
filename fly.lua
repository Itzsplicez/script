-- Fly module with shift lock support
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local flyModule = {}
local flying = false
local flySpeed = 50
local flyConnection = nil

local function startFly()
    if flying then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    flying = true
    local hrp = char.HumanoidRootPart
    local cam = workspace.CurrentCamera

    local velocity = Instance.new("BodyVelocity")
    velocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    velocity.Velocity = Vector3.new(0,0,0)
    velocity.Parent = hrp

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying then return end
        local direction = Vector3.new(0,0,0)

        -- Movement input
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
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction = direction - Vector3.new(0,1,0)
        end

        -- Apply shift lock camera
        if player.CameraMode == Enum.CameraMode.LockFirstPerson or player.CameraMode == Enum.CameraMode.Classic then
            direction = Vector3.new(direction.X, direction.Y, direction.Z)
        end

        if direction.Magnitude > 0 then
            velocity.Velocity = direction.Unit * flySpeed
        else
            velocity.Velocity = Vector3.new(0,0,0)
        end
    end)
end

local function stopFly()
    flying = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        for _, v in ipairs(char.HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
end

function flyModule.Start(speed)
    flySpeed = math.clamp(speed or 50, 1, 100)
    startFly()
end

function flyModule.Stop()
    stopFly()
end

return flyModule
