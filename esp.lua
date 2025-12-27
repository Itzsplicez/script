local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESP = {}
ESP.Active = false
ESP.Indicators = {} -- [Player] = {Billboard, Label}

-- Helper: create ESP for a player's character
local function createESPForChar(plr, char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Remove old billboard if exists
    if ESP.Indicators[plr] and ESP.Indicators[plr].Billboard then
        ESP.Indicators[plr].Billboard:Destroy()
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPLabel"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = hrp
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = hrp

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Text = plr.Name
    nameLabel.Parent = billboard

    ESP.Indicators[plr] = {Billboard = billboard, Label = nameLabel}
end

-- Remove ESP
local function removeESP(plr)
    if ESP.Indicators[plr] then
        if ESP.Indicators[plr].Billboard then
            ESP.Indicators[plr].Billboard:Destroy()
        end
        ESP.Indicators[plr] = nil
    end
end

-- Apply ESP to all current players
local function applyESPToAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer then
            local char = plr.Character
            if char then
                createESPForChar(plr, char)
            end

            -- Recreate ESP if character respawns
            plr.CharacterAdded:Connect(function(char)
                if ESP.Active then
                    createESPForChar(plr, char)
                end
            end)
        end
    end
end

-- Toggle ESP
function ESP.Toggle(state)
    ESP.Active = state
    if state then
        applyESPToAll()
    else
        for _, plr in pairs(Players:GetPlayers()) do
            removeESP(plr)
        end
    end
end

-- Update distances every frame
RunService.RenderStepped:Connect(function()
    if not ESP.Active then return end
    local localChar = Players.LocalPlayer.Character
    if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then return end
    local hrp = localChar.HumanoidRootPart

    for plr, data in pairs(ESP.Indicators) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            data.Label.Text = plr.Name .. " | " .. math.floor(dist) .. " studs"
        end
    end
end)

-- Ensure ESP for new players joining mid-game
Players.PlayerAdded:Connect(function(plr)
    if ESP.Active then
        plr.CharacterAdded:Connect(function(char)
            createESPForChar(plr, char)
        end)
        -- If they already have a character
        if plr.Character then
            createESPForChar(plr, plr.Character)
        end
    end
end)

-- Clean up when player leaves
Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
end)

return ESP
