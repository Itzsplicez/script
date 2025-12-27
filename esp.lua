local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESP = {}
ESP.Active = false
ESP.Indicators = {} -- {Player = {Billboard, BoxFrame}}

-- Create persistent ESP indicator
local function createESPIndicator(plr, char)
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- Billboard for name
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPLabel"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = hrp
    billboard.AlwaysOnTop = true
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

    -- Green box below name
    local boxFrame = Instance.new("Frame")
    boxFrame.Size = UDim2.new(0, 100, 0, 4)
    boxFrame.Position = UDim2.new(0.5, -50, 1, 0)
    boxFrame.BackgroundColor3 = Color3.fromRGB(0,255,0)
    boxFrame.BorderSizePixel = 0
    boxFrame.Parent = billboard

    ESP.Indicators[plr] = {Billboard = billboard, Box = boxFrame}
end

local function removeESP(plr)
    if ESP.Indicators[plr] then
        if ESP.Indicators[plr].Billboard then
            ESP.Indicators[plr].Billboard:Destroy()
        end
        ESP.Indicators[plr] = nil
    end
end

-- Apply ESP to a player
local function applyESP(plr)
    local char = plr.Character
    if char and char:FindFirstChild("HumanoidRootPart") and not ESP.Indicators[plr] then
        createESPIndicator(plr, char)
    end
end

function ESP.Toggle(state)
    ESP.Active = state
    if not state then
        for _, plr in pairs(Players:GetPlayers()) do
            removeESP(plr)
        end
    else
        for _, plr in pairs(Players:GetPlayers()) do
            applyESP(plr)
            plr.CharacterAdded:Connect(function(char)
                if ESP.Active then
                    applyESP(plr)
                end
            end)
        end
    end
end

-- Update positions every frame (optional if using BillboardGui, mostly to update distance)
RunService.RenderStepped:Connect(function()
    if ESP.Active then
        local localChar = Players.LocalPlayer.Character
        if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then return end
        local hrp = localChar.HumanoidRootPart
        for plr, data in pairs(ESP.Indicators) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                data.Billboard.TextLabel.Text = plr.Name .. " | " .. math.floor(dist) .. " studs"
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if ESP.Active then
            applyESP(plr)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
end)

return ESP
