-- orbit.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Reuse module if already loaded
if _G.OrbitModule then
    return _G.OrbitModule
end

local OrbitModule = {}
local orbiting = false
local orbitConnection

local radius = 6
local speed = 2
local angle = 0
local targetHRP
local myHRP

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

    speed = orbitSpeed or 2
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

        myHRP.CFrame = CFrame.new(targetHRP.Position + offset, targetHRP.Position)
    end)
end

function OrbitModule.Stop()
    orbiting = false
    if orbitConnection then
        orbitConnection:Disconnect()
        orbitConnection = nil
    end
end

_G.OrbitModule = OrbitModule
return OrbitModule
