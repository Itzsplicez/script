local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local TeleportTool = {}

function TeleportTool.Give()
    -- Check if player already has the tool
    local backpack = player:WaitForChild("Backpack")
    if backpack:FindFirstChild("TeleportTool") then return end

    local tool = Instance.new("Tool")
    tool.Name = "TeleportTool"
    tool.RequiresHandle = false
    tool.CanBeDropped = false

    -- Tool activation (click to teleport)
    tool.Activated:Connect(function()
        if not mouse.Target then return end
        local targetPos = mouse.Hit.Position
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0,3,0))
        end
    end)

    tool.Parent = backpack
end

return TeleportTool
