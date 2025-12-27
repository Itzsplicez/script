-- ESP Module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESP = {}
ESP.Active = false
ESP.Boxes = {}

-- Create or remove ESP
function ESP.Toggle(state)
    ESP.Active = state

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                if state then
                    -- Create ESP box
                    local box = Instance.new("SelectionBox")
                    box.Adornee = char.HumanoidRootPart
                    box.LineThickness = 0.1
                    box.SurfaceTransparency = 0.8
                    box.Color3 = Color3.fromRGB(0,255,0)
                    box.Parent = char.HumanoidRootPart
                    ESP.Boxes[plr] = box
                else
                    -- Remove ESP box
                    if ESP.Boxes[plr] then
                        ESP.Boxes[plr]:Destroy()
                        ESP.Boxes[plr] = nil
                    end
                end
            end
        end
    end
end

-- Auto-update for new players
Players.PlayerAdded:Connect(function(plr)
    if ESP.Active then
        plr.CharacterAdded:Connect(function(char)
            if char:FindFirstChild("HumanoidRootPart") then
                local box = Instance.new("SelectionBox")
                box.Adornee = char.HumanoidRootPart
                box.LineThickness = 0.1
                box.SurfaceTransparency = 0.8
                box.Color3 = Color3.fromRGB(0,255,0)
                box.Parent = char.HumanoidRootPart
                ESP.Boxes[plr] = box
            end
        end)
    end
end)

return ESP
