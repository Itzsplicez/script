-- orbit.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Reuse module
if _G.OrbitModule then
    return _G.OrbitModule
end

local OrbitModule = {}
local orbiting = false
local orbitConnection

local radius = 6
local speed = 3
local angle = 0

local targetHRP
local myHRP

-- Save camera state
local oldCameraType
local oldCameraSubject

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

    -- Take FULL control of camera
    oldCameraType = camera.CameraType
    oldCameraSubject = camera.CameraSubject
    camera.CameraType = Enum.CameraType.Scriptable

    orbitConnection = RunService.RenderStepped:Connect(function(dt)
        if not orbiting or not targetHRP or not myHRP then return end

        angle += speed * dt * 60

        -- Orbit position
        local offset = Vector3.new(
            math.cos(angle) * radius,
            0,
            math.sin(angle) * radius
        )

        local orbitPos = targetHRP.Position + offset

        -- Move your character
        myHRP.CFrame = CFrame.new(orbitPos, targetHRP.Position)

        -- TRUE spectate (use target's perspective)
        camera.CFrame = CFrame.new(
            targetHRP.Position + Vector3.new(0, 2, 0),
            targetHRP.Position + targetHRP.CFrame.LookVector * 50
        )
    end)
end

function OrbitModule.Stop()
    orbiting = false

    if orbitConnection then
        orbitConnection:Disconnect()
        orbitConnection = nil
    end

    -- Restore camera
    if oldCameraType then
        camera.CameraType = oldCameraType
        camera.CameraSubject = oldCameraSubject
    end
end

_G.OrbitModule = OrbitModule
return OrbitModule
