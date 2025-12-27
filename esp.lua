-- ESP Module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESP = {}
ESP.Active = false
ESP.Boxes = {}
ESP.Billboards = {}
ESP.Connections = {} -- Humanoid.Died connections
ESP.CharacterConnections = {} -- CharacterAdded connections

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

-- Set up ESP for a single character
local function setupESPForCharacter(plr, char)
    removeESP(plr) -- Remove old ESP if any
    ESP.Boxes[plr] = createBoxes(char)
    ESP.Billboards[plr] = createLabel(plr, char)

    -- Remove ESP when humanoid dies
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        ESP.Connections[plr] = humanoid.Died:Connect(function()
            removeESP(plr)
        end)
    end
end

-- Set up ESP for a player (handles current character and future respawns)
local function setupESPForPlayer(plr)
    -- Current character
    if plr.Character then
        setupESPForCharacter(plr, plr.Character)
    end

    -- Listen for respawns
    if not ESP.CharacterConnections[plr] then
        ESP.CharacterConnections[plr] = plr.CharacterAdded:Connect(function(char)
            if ESP.Active then
                setupESPForCharacter(plr, char)
            end
        end)
    end
end

-- Toggle ESP on/off
function ESP.Toggle(state)
    ESP.Active = state

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer then
            if state then
                setupESPForPlayer(plr)
            else
                removeESP(plr)
                -- Disconnect CharacterAdded connection if exists
                if ESP.CharacterConnections[plr] then
                    ESP.CharacterConnections[plr]:Disconnect()
                    ESP.CharacterConnections[plr] = nil
                end
            end
        end
    end
end

-- Automatically handle new players joining
Players.PlayerAdded:Connect(function(plr)
    if plr ~= Players.LocalPlayer and ESP.Active then
        setupESPForPlayer(plr)
    end
end)

-- Clean up when player leaves
Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
    if ESP.CharacterConnections[plr] then
        ESP.CharacterConnections[plr]:Disconnect()
        ESP.CharacterConnections[plr] = nil
    end
end)

return ESP
