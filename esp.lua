-- ESP Module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESP = {}
ESP.Active = false
ESP.Boxes = {}  -- {Player = {Part = SelectionBox}}
ESP.Billboards = {} -- {Player = BillboardGui}

-- Create BillboardGui
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

-- Remove all ESP for a player
local function removeESP(plr)
    if ESP.Boxes[plr] then
        for _, box in pairs(ESP.Boxes[plr]) do
            if box and box.Parent then
                box:Destroy()
            end
        end
        ESP.Boxes[plr] = nil
    end

    if ESP.Billboards[plr] then
        ESP.Billboards[plr]:Destroy()
        ESP.Billboards[plr] = nil
    end
end

-- Apply ESP continuously
local function updateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            -- Billboard
            if not ESP.Billboards[plr] then
                ESP.Billboards[plr] = createLabel(plr, plr.Character)
            end

            -- SelectionBoxes
            if not ESP.Boxes[plr] then ESP.Boxes[plr] = {} end
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") and not ESP.Boxes[plr][part] then
                    local box = Instance.new("SelectionBox")
                    box.Adornee = part
                    box.LineThickness = 0.05
                    box.SurfaceTransparency = 0.8
                    box.Color3 = Color3.fromRGB(0,255,0)
                    box.Parent = part
                    ESP.Boxes[plr][part] = box
                end
            end
        end
    end
end

-- Toggle ESP
function ESP.Toggle(state)
    ESP.Active = state

    if not state then
        for _, plr in pairs(Players:GetPlayers()) do
            removeESP(plr)
        end
    end
end

-- Run loop every frame to update ESP
RunService.RenderStepped:Connect(function()
    if ESP.Active then
        updateESP()
    end
end)

-- Auto-apply to new players
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if ESP.Active then
            updateESP()
        end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
end)

return ESP
