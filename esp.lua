local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESP = {}
ESP.Active = false
ESP.Billboards = {}   -- [Player] = BillboardGui
ESP.Connections = {}  -- [Player] = {RenderStepped, CharacterAdded}
ESP.PlayerAddedConn = nil

local function createESP(player)
    if player == LocalPlayer then return end
    if ESP.Billboards[player] then return end

    local function onCharacterAdded(character)
        -- Remove old ESP for safety
        if ESP.Billboards[player] then
            ESP.Billboards[player]:Destroy()
            ESP.Billboards[player] = nil
        end

        local hrp = character:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP"
        billboard.Adornee = hrp
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = hrp

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.TextColor3 = Color3.fromRGB(0, 255, 0)
        text.TextStrokeTransparency = 0
        text.TextScaled = true
        text.Font = Enum.Font.SourceSansBold
        text.Text = player.Name
        text.Parent = billboard

        -- Update loop
        local rsConn
        rsConn = RunService.RenderStepped:Connect(function()
            if not ESP.Active or not character or not character.Parent then
                if rsConn then rsConn:Disconnect() end
                if billboard then billboard:Destroy() end
                ESP.Billboards[player] = nil
                ESP.Connections[player] = nil
                return
            end
            text.Text = player.Name
        end)

        ESP.Billboards[player] = billboard
        ESP.Connections[player] = ESP.Connections[player] or {}
        ESP.Connections[player].RenderStepped = rsConn
    end

    -- Disconnect old CharacterAdded connection
    if ESP.Connections[player] and ESP.Connections[player].CharacterAdded then
        ESP.Connections[player].CharacterAdded:Disconnect()
    end

    local charConn = player.CharacterAdded:Connect(onCharacterAdded)
    ESP.Connections[player] = ESP.Connections[player] or {}
    ESP.Connections[player].CharacterAdded = charConn

    if player.Character then
        onCharacterAdded(player.Character)
    end
end

local function removeESP(player)
    if ESP.Billboards[player] then
        ESP.Billboards[player]:Destroy()
        ESP.Billboards[player] = nil
    end
    if ESP.Connections[player] then
        if ESP.Connections[player].RenderStepped then
            ESP.Connections[player].RenderStepped:Disconnect()
        end
        if ESP.Connections[player].CharacterAdded then
            ESP.Connections[player].CharacterAdded:Disconnect()
        end
        ESP.Connections[player] = nil
    end
end

function ESP.Toggle(state)
    ESP.Active = state
    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
        ESP.PlayerAddedConn = Players.PlayerAdded:Connect(createESP)
    else
        if ESP.PlayerAddedConn then
            ESP.PlayerAddedConn:Disconnect()
            ESP.PlayerAddedConn = nil
        end
        for player, _ in pairs(ESP.Billboards) do
            removeESP(player)
        end
        ESP.Billboards = {}
        ESP.Connections = {}
    end
end

return ESP
