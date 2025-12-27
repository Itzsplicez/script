local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESP = {}
ESP.Active = false
ESP.Indicators = {} -- [Player] = {BillboardGui, BoxFrame, NameLabel}

-- Create ESP for a player
local function createESP(plr)
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if ESP.Indicators[plr] then return end -- already exists

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPLabel"
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.Adornee = hrp
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0,3,0)
    billboard.Parent = hrp

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0.5,0)
    nameLabel.Position = UDim2.new(0,0,0,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = Color3.fromRGB(0,255,0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Text = plr.Name
    nameLabel.Parent = billboard

    local boxFrame = Instance.new("Frame")
    boxFrame.Size = UDim2.new(0, 100, 0, 4)
    boxFrame.Position = UDim2.new(0.5, -50, 1, 0)
    boxFrame.BackgroundColor3 = Color3.fromRGB(0,255,0)
    boxFrame.BorderSizePixel = 0
    boxFrame.Parent = billboard

    ESP.Indicators[plr] = {Billboard = billboard, Box = boxFrame, Label = nameLabel}
end

local function removeESP(plr)
    if ESP.Indicators[plr] then
        if ESP.Indicators[plr].Billboard then
            ESP.Indicators[plr].Billboard:Destroy()
        end
        ESP.Indicators[plr] = nil
    end
end

-- Apply ESP to all players
local function applyESPToAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer then
            createESP(plr)
            plr.CharacterAdded:Connect(function(char)
                if ESP.Active then
                    createESP(plr)
                end
            end)
        end
    end
end

function ESP.Toggle(state)
    ESP.Active = state
    if not state then
        for _, plr in pairs(Players:GetPlayers()) do
            removeESP(plr)
        end
    else
        applyESPToAll()
    end
end

-- Update distance text every frame
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

Players.PlayerAdded:Connect(function(plr)
    if ESP.Active then
        plr.CharacterAdded:Connect(function(char)
            createESP(plr)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
end)

return ESP
