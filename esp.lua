-- Simple Name ESP Module (Green, Toggleable)
-- Executor: Delta

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESP = {}
ESP.Active = false
ESP.Connections = {} -- To store RenderStepped connections
ESP.Billboards = {} -- To store player billboards

-- Create ESP for a player
local function createESP(player)
    if player == LocalPlayer then return end
    if ESP.Billboards[player] then return end -- Already exists

    local function onCharacterAdded(character)
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
        text.TextColor3 = Color3.fromRGB(0, 255, 0) -- GREEN
        text.TextStrokeTransparency = 0
        text.TextScaled = true
        text.Font = Enum.Font.SourceSansBold
        text.Parent = billboard

        -- Update distance every frame
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not ESP.Active then return end
            if not character or not character.Parent then
                billboard:Destroy()
                if conn then conn:Disconnect() end
                ESP.Billboards[player] = nil
                return
            end

            local distance = 0
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                distance = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            end

            text.Text = player.Name .. "\n" .. math.floor(distance) .. " studs"
        end)

        ESP.Connections[player] = conn
        ESP.Billboards[player] = billboard
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

-- Remove ESP for a player
local function removeESP(player)
    if ESP.Billboards[player] then
        ESP.Billboards[player]:Destroy()
        ESP.Billboards[player] = nil
    end
    if ESP.Connections[player] then
        ESP.Connections[player]:Disconnect()
        ESP.Connections[player] = nil
    end
end

-- Toggle ESP
function ESP.Toggle(state)
    ESP.Active = state
    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
        Players.PlayerAdded:Connect(createESP)
    else
        for player, _ in pairs(ESP.Billboards) do
            removeESP(player)
        end
    end
end

return ESP
