-- orbit.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Reuse if already loaded
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
local oldCameraSubject

local function getHRP(plr)
    if plr and plr.Character then
        return plr.Character:FindFirstChild("HumanoidRootPart")
    end
end

local function getHumanoid(plr)
    if plr and plr.Character then
        return plr.Character:FindFirstChildOfClass("Humanoid")
    end
end

function OrbitModule.Start(targetPlayer, orbitSpeed, orbitRadius)
    OrbitModule.Stop()

    targetHRP = getHRP(targetPlayer)
    myHRP = getHRP(player)
    local targetHumanoid = getHumanoid(targetPlayer)

    if not targetHRP or not myHRP or not targetHumanoid then return end

    -- Save camera state
    oldCameraSubject = camera.CameraSubject
    camera.CameraSubject = targetHumanoid

    speed = orbitSpeed or 3
    radius = orbitRadius or 6
    angle = 0
    orbiting = true

    orbitConnection = RunService.RenderStepped:Connect(function(dt)
        if not orbiting or not targetHRP or not myHRP then return end

        angle += speed * dt * 60

        local offset = Vector3.new(
            math.cos(angle) * radius,
            0,
            math.sin(angle) * radius
        )

        myHRP.CFrame = CFrame.new(
            targetHRP.Position + offset,
            targetHRP.Position
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
    if oldCameraSubject then
        camera.CameraSubject = oldCameraSubject
        oldCameraSubject = nil
    end
end

_G.OrbitModule = OrbitModule
return OrbitModule
