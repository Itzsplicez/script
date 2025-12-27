-- ESP Module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local ESP = {}
ESP.Active = false
ESP.Indicators = {} -- [Player] = {BillboardGui, Box, Label, Connection}

-- Create ESP for a player
local function createESP(player)
    if player == LocalPlayer then return end

    local function onCharacterAdded(character)
        local hrp = character:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end

        -- If ESP already exists, reassign Adornee (respawn)
        if ESP.Indicators[player] then
            ESP.Indicators[player].Billboard.Adornee = hrp
            return
        end

        -- Billboard
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP"
        billboard.Adornee = hrp
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = hrp

        -- Name label
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 0.6, 0)
        text.Position = UDim2.new(0, 0, 0, 0)
        text.BackgroundTransparency = 1
        text.TextColor3 = Color3.fromRGB(0, 255, 0)
        text.TextStrokeTransparency = 0
        text.TextScaled = true
        text.Font = Enum.Font.SourceSansBold
        text.Text = player.Name
        text.Parent = billboard

        -- Green box under name
        local box = Instance.new("Frame")
        box.Size = UDim2.new(0, 100, 0, 4)
        box.Position = UDim2.new(0.5, -50, 0.6, 0)
        box.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        box.BorderSizePixel = 0
        box.Parent = billboard

        -- Store indicator
        ESP.Indicators[player] = {Billboard = billboard, Box = box, Label = text}
    end

    -- Connect to character
    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

-- Remove ESP for a player
local function removeESP(player)
    if ESP.Indicators[player] then
        ESP.Indicators[player].Billboard:Destroy()
        ESP.Indicators[player] = nil
    end
end

-- Toggle ESP
function ESP.Toggle(state)
    ESP.Active = state
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            createESP(player)
        end
        ESP.PlayerAddedConnection = Players.PlayerAdded:Connect(function(player)
            if ESP.Active then
                createESP(player)
            end
        end)
    else
        for player, _ in pairs(ESP.Indicators) do
            removeESP(player)
        end
        if ESP.PlayerAddedConnection then
            ESP.PlayerAddedConnection:Disconnect()
            ESP.PlayerAddedConnection = nil
        end
    end
end

return ESP
