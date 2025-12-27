-- ESP Module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESP = {}
ESP.Active = false
ESP.Boxes = {}       -- {Player = {SelectionBoxes}}
ESP.Billboards = {}  -- {Player = BillboardGui}
ESP.CharacterConnections = {} -- CharacterAdded connections
ESP.HumanoidConnections = {}  -- Humanoid.Died connections

-- Helper: Create BillboardGui for name
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
    textLabel.Size = UDim2.new(1,0,1,0)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 14
    textLabel.TextColor3 = Color3.fromRGB(0,255,0)
    textLabel.TextStrokeTransparency = 0
    textLabel.Text = plr.Name
    textLabel.Parent = billboard

    return billboard
end

-- Create SelectionBoxes for all BaseParts
local function createBoxes(char)
    local boxes = {}
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local box = Instance.new("SelectionBox")
            box.Adornee = part
            box.LineThickness = 0.05
            box.SurfaceTransparency = 0.8
            box.Color3 = Color3.fromRGB(0,255,0)
            box.Parent = part
            table.insert(boxes, box)
        end
    end
    return boxes
end

-- Remove ESP for a player
local function removeESP(plr)
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

    if ESP.HumanoidConnections[plr] then
        ESP.HumanoidConnections[plr]:Disconnect()
        ESP.HumanoidConnections[plr] = nil
    end
end

-- Apply ESP to a character
local function setupESPForCharacter(plr, char)
    removeESP(plr)

    ESP.Boxes[plr] = createBoxes(char)
    ESP.Billboards[plr] = createLabel(plr, char)

    -- Connect to Humanoid.Died to remove ESP
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        ESP.HumanoidConnections[plr] = humanoid.Died:Connect(function()
            removeESP(plr)
        end)
    end
end

-- Apply ESP to a player (handles respawns)
local function setupESPForPlayer(plr)
    if plr.Character then
        setupESPForCharacter(plr, plr.Character)
    end

    -- Disconnect old connection if it exists
    if ESP.CharacterConnections[plr] then
        ESP.CharacterConnections[plr]:Disconnect()
    end

    ESP.CharacterConnections[plr] = plr.CharacterAdded:Connect(function(char)
        if ESP.Active then
            setupESPForCharacter(plr, char)
        end
    end)
end

-- Toggle ESP
function ESP.Toggle(state)
    ESP.Active = state

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer then
            if state then
                setupESPForPlayer(plr)
            else
                removeESP(plr)
                if ESP.CharacterConnections[plr] then
                    ESP.CharacterConnections[plr]:Disconnect()
                    ESP.CharacterConnections[plr] = nil
                end
            end
        end
    end
end

-- New players joining
Players.PlayerAdded:Connect(function(plr)
    if plr ~= Players.LocalPlayer and ESP.Active then
        setupESPForPlayer(plr)
    end
end)

-- Clean up when leaving
Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
    if ESP.CharacterConnections[plr] then
        ESP.CharacterConnections[plr]:Disconnect()
        ESP.CharacterConnections[plr] = nil
    end
end)

return ESP
