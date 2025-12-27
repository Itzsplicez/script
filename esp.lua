local ESP = {}
ESP.Active = false
ESP.Indicators = {} -- {Player = {Billboard, BoxFrame}}
ESP.Indicators = {} -- [Player] = {BillboardGui, BoxFrame, NameLabel}

-- Create persistent ESP indicator
local function createESPIndicator(plr, char)
    local hrp = char:WaitForChild("HumanoidRootPart")
-- Create ESP for a player
local function createESP(plr)
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if ESP.Indicators[plr] then return end -- already exists

    -- Billboard for name
local billboard = Instance.new("BillboardGui")
billboard.Name = "ESPLabel"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Size = UDim2.new(0,200,0,50)
billboard.Adornee = hrp
billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0,3,0)
billboard.Parent = hrp

local nameLabel = Instance.new("TextLabel")
@@ -29,15 +33,14 @@ local function createESPIndicator(plr, char)
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
    ESP.Indicators[plr] = {Billboard = billboard, Box = boxFrame, Label = nameLabel}
end

local function removeESP(plr)
@@ -49,11 +52,17 @@ local function removeESP(plr)
end
end

-- Apply ESP to a player
local function applyESP(plr)
    local char = plr.Character
    if char and char:FindFirstChild("HumanoidRootPart") and not ESP.Indicators[plr] then
        createESPIndicator(plr, char)
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

@@ -64,38 +73,30 @@ function ESP.Toggle(state)
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
        applyESPToAll()
end
end

-- Update positions every frame (optional if using BillboardGui, mostly to update distance)
-- Update distance text every frame
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
    plr.CharacterAdded:Connect(function(char)
        if ESP.Active then
            applyESP(plr)
        end
    end)
    if ESP.Active then
        plr.CharacterAdded:Connect(function(char)
            createESP(plr)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
