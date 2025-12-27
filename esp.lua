-- Simple Name ESP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESP = {}
ESP.Active = false
ESP.Indicators = {} -- [Player] = {Billboard, TextLabel}

-- Create ESP for a player
local function createESP(player)
    if player == LocalPlayer then return end
    if ESP.Indicators[player] then return end -- Already exists

    local function onCharacterAdded(character)
        local hrp = character:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end

        -- Billboard
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP"
        billboard.Adornee = hrp
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = hrp

        -- Text label
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green
        text.TextStrokeTransparency = 0
        text.TextScaled = true
        text.Font = Enum.Font.SourceSansBold
        text.Text = player.Name
        text.Parent = billboard

        ESP.Indicators[player] = {Billboard = billboard, Label = text}

        -- Remove if character is gone
        RunService.RenderStepped:Connect(function()
            if not character or not character.Parent then
                if ESP.Indicators[player] then
                    ESP.Indicators[player].Billboard:Destroy()
                    ESP.Indicators[player] = nil
                end
            end
        end)
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

-- Toggle ESP on/off
function ESP.Toggle(state)
    ESP.Active = state
    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
        ESP.PlayerAddedConnection = Players.PlayerAdded:Connect(createESP)
    else
        for player, data in pairs(ESP.Indicators) do
            if data.Billboard then
                data.Billboard:Destroy()
            end
        end
        ESP.Indicators = {}
        if ESP.PlayerAddedConnection then
            ESP.PlayerAddedConnection:Disconnect()
            ESP.PlayerAddedConnection = nil
        end
    end
end

return ESP
