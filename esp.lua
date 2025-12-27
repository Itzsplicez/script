-- ESP Module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local ESP = {}
ESP.Active = false
ESP.Boxes = {}
ESP.Billboards = {}

-- Helper: Create BillboardGui for name + distance
local function createLabel(plr, char)
    local hrp = char:WaitForChild("HumanoidRootPart")

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPLabel"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = hrp
    billboard.AlwaysOnTop = true
    billboard.Parent = hrp

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 14
    textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.Text = plr.Name -- initial name
    textLabel.Parent = billboard

    return billboard, textLabel
end

-- Create ESP for a single player
local function setupESP(plr)
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    -- SelectionBox
    local box = Instance.new("SelectionBox")
    box.Adornee = char.HumanoidRootPart
    box.LineThickness = 0.1
    box.SurfaceTransparency = 0.8
    box.Color3 = Color3.fromRGB(0, 255, 0)
    box.Parent = char.HumanoidRootPart
    ESP.Boxes[plr] = box

    -- Billboard
    local billboard, label = createLabel(plr, char)
    ESP.Billboards[plr] = {Billboard = billboard, Label = label}
end

-- Remove ESP for a single player
local function removeESP(plr)
    if ESP.Boxes[plr] then
        ESP.Boxes[plr]:Destroy()
        ESP.Boxes[plr] = nil
    end
    if ESP.Billboards[plr] then
        ESP.Billboards[plr].Billboard:Destroy()
        ESP.Billboards[plr] = nil
    end
end

-- Toggle ESP on/off
function ESP.Toggle(state)
    ESP.Active = state

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer then
            if state then
                setupESP(plr)
            else
                removeESP(plr)
            end
        end
    end
end

-- Update distances every frame
RunService.RenderStepped:Connect(function()
    if not ESP.Active then return end
    local localChar = Players.LocalPlayer.Character
    if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then return end
    local hrp = localChar.HumanoidRootPart

    for plr, data in pairs(ESP.Billboards) do
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local distance = (char.HumanoidRootPart.Position - hrp.Position).Magnitude
            data.Label.Text = plr.Name .. " | " .. math.floor(distance) .. " studs"
        end
    end
end)

-- Auto-update for new players
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if ESP.Active then
            setupESP(plr)
        end
    end)
end)

Players.PlayerRemoving:Connect(removeESP)

return ESP
