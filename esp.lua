-- Simple Name + Distance ESP with Green Box
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function createESP(player)
    if player == LocalPlayer then return end

    local connections = {} -- To store RenderStepped per player

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

        -- Text Label
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 0.6, 0)
        text.Position = UDim2.new(0, 0, 0, 0)
        text.BackgroundTransparency = 1
        text.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green
        text.TextStrokeTransparency = 0
        text.TextScaled = true
        text.Font = Enum.Font.SourceSansBold
        text.Text = player.Name
        text.Parent = billboard

        -- Green box below name
        local box = Instance.new("Frame")
        box.Size = UDim2.new(0, 100, 0, 4)
        box.Position = UDim2.new(0.5, -50, 0.6, 0)
        box.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        box.BorderSizePixel = 0
        box.Parent = billboard

        -- Update distance every frame
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not character or not character.Parent then
                billboard:Destroy()
                if conn then conn:Disconnect() end
                return
            end

            local distance = 0
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                distance = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            end

            text.Text = player.Name .. "\n" .. math.floor(distance) .. " studs"
        end)

        connections[player] = conn
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

-- Apply ESP to all existing players
for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

-- Apply ESP to new players joining
Players.PlayerAdded:Connect(createESP)
