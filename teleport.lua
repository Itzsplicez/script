-- teleport.lua
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local TeleportModule = {}

function TeleportModule.ToPlayer(target)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = char.HumanoidRootPart
    local targetHRP = target.Character.HumanoidRootPart

    hrp.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0) 
end

return TeleportModule
