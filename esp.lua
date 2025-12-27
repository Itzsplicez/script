-- ESP Module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESP = {}
ESP.Active = false
ESP.Boxes = {}
ESP.Billboards = {}
ESP.Connections = {} -- Humanoid.Died connections

-- Helper: Create BillboardGui for name only
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
    textLabel.Text = plr.Name
    textLabel.Parent = billboard

    return billboard
end

-- Helper: Create SelectionBoxes for all body parts
local function createBoxes(char)
    local boxes = {}
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local box = Instance.new("SelectionBox")
            box.Adornee = part
            box.LineThickness = 0.05
            box.SurfaceTransparency = 0.8
            box.Color3 = Color3.fromRGB(0, 255, 0)
            box.Parent = part
            table.insert(boxes, box)
        end
    end
    return boxes
end

-- Remove ESP for a single player
local function removeESP(plr)
    if ESP.Connections[plr] then
        ESP.Connections[plr]:Disconnect()
        ESP.Connections[plr] = nil
    end

    if ESP.Boxes[plr] then
        for _, box in pairs(ESP.Boxes[plr]) do
            box:Destroy()
        end
        ESP.Boxes[plr] = nil
    end

    if ESP.Billboards[plr] then
        ESP.Billboards[plr]:Destroy()
        ESP.Billboards[plr] = nil
    end
end

-- Set up ESP for a single player
local function setupESP(plr)
    local char = plr.Character
    if not char then return end

    removeESP(plr) -- clean old ESP if any

    ESP.Boxes[plr] = createBoxes(char)
    ESP.Billboards[plr] = createLabel(plr, char)

    -- Remove ESP when player dies
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        ESP.Connections[plr] = humanoid.Died:Connect(function()
            removeESP(plr)
        end)
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

-- Automatically handle new players joining or respawning
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if ESP.Active and plr ~= Players.LocalPlayer then
            setupESP(plr)
        end
    end)
end)

Players.PlayerRemoving:Connect(removeESP)

return ESP
