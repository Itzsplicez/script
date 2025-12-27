-- orbit.lua (freecam)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Reuse module
if _G.OrbitModule then
    return _G.OrbitModule
end

local OrbitModule = {}
local orbiting = false
local orbitConnection

-- Orbit settings
local radius = 6
local speed = 3
local angle = 0

-- Freecam settings
local camYaw = 0
local camPitch = 0
local sensitivity = 0.002

local targetHRP
local myHRP

-- Save camera state
local oldCameraType
local oldCameraCFrame
local oldMouseBehavior

local function getHRP(plr)
    if plr and plr.Character then
        return plr.Character:FindFirstChild("HumanoidRootPart")
    end
end

function OrbitModule.Start(targetPlayer, orbitSpeed, orbitRadius)
    OrbitModule.Stop()

    targetHRP = getHRP(targetPlayer)
    myHRP = getHRP(player)
    if not targetHRP or not myHRP then return end

    speed = orbitSpeed or 3
    radius = orbitRadius or 6
    angle = 0
    orbiting = true

    -- Save camera + mouse
    oldCameraType = camera.CameraType
    oldCameraCFrame = camera.CFrame
    oldMouseBehavior = UserInputService.MouseBehavior

    -- Enable freecam
    camera.CameraType = Enum.CameraType.Scriptable
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

    orbitConnection = RunService.RenderStepped:Connect(function(dt)
        if not orbiting or not targetHRP or not myHRP then return end

        -- Orbit movement
        angle += speed * dt * 60
        local offset = Vector3.new(
            math.cos(angle) * radius,
            0,
            math.sin(angle) * radius
        )
        myHRP.CFrame = CFrame.new(targetHRP.Position + offset, targetHRP.Position)

        -- Mouse freecam
        local delta = UserInputService:GetMouseDelta()
        camYaw -= delta.X * sensitivity
        camPitch = math.clamp(camPitch - delta.Y * sensitivity, -1.4, 1.4)

        local camOffset = CFrame.Angles(0, camYaw, 0) * CFrame.Angles(camPitch, 0, 0)
        camera.CFrame = CFrame.new(
            targetHRP.Position + Vector3.new(0, 2, 0)
        ) * camOffset * CFrame.new(0, 0, -10)
    end)
end

function OrbitModule.Stop()
    orbiting = false

    if orbitConnection then
        orbitConnection:Disconnect()
        orbitConnection = nil
    end

    -- Restore camera + mouse
    if oldCameraType then
        camera.CameraType = oldCameraType
        camera.CFrame = oldCameraCFrame
    end

    UserInputService.MouseBehavior = oldMouseBehavior or Enum.MouseBehavior.Default
end

_G.OrbitModule = OrbitModule
return OrbitModule
