local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local Freecam = {}
local active = false
local speed = 1
local moveDir = Vector3.new(0,0,0)
local connection

-- Helper to get movement input
local function updateMoveDir()
    local dir = Vector3.new(0,0,0)
    local camCFrame = camera.CFrame
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        dir = dir + camCFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        dir = dir - camCFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        dir = dir - camCFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        dir = dir + camCFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        dir = dir + Vector3.new(0,1,0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        dir = dir - Vector3.new(0,1,0)
    end
    moveDir = dir
end

function Freecam.Start(camSpeed)
    if active then return end
    active = true
    speed = math.clamp(tonumber(camSpeed) or 1, 0.1, 10)

    local oldSubject = camera.CameraSubject
    local oldType = camera.CameraType

    camera.CameraType = Enum.CameraType.Scriptable

    connection = RunService.RenderStepped:Connect(function(dt)
        if not active then return end
        updateMoveDir()
        if moveDir.Magnitude > 0 then
            camera.CFrame = camera.CFrame + moveDir.Unit * speed
        end
    end)

    Freecam.Stop = function()
        active = false
        if connection then
            connection:Disconnect()
            connection = nil
        end
        camera.CameraType = oldType
        camera.CameraSubject = oldSubject
    end
end

Freecam.Stop = function() end

return Freecam
