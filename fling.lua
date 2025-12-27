-- Fling Module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local FlingModule = {}
FlingModule.Active = false
FlingModule.Connection = nil
FlingModule.Thrust = nil

local LocalPlayer = Players.LocalPlayer

-- Helper: Find players
local function findPlayers(searchString)
    local foundPlayers = {}
    local strl = searchString:lower()
    for _, player in ipairs(Players:GetPlayers()) do
        if strl == "all" or strl == "everyone" then
            table.insert(foundPlayers, player)
        elseif strl == "others" and player ~= LocalPlayer then
            table.insert(foundPlayers, player)
        elseif strl == "me" and player == LocalPlayer then
            table.insert(foundPlayers, player)
        elseif player.Name:lower():sub(1, #searchString) == strl then
            table.insert(foundPlayers, player)
        end
    end
    return foundPlayers
end

-- Aggressive Fling
local function aggressiveFling(target)
    local char = LocalPlayer.Character
    if not (char and target and target.Character) then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Create BodyThrust
    FlingModule.Thrust = Instance.new("BodyThrust")
    FlingModule.Thrust.Name = "FlingThrust"
    FlingModule.Thrust.Force = Vector3.new(9999,9999,9999)
    FlingModule.Thrust.Location = hrp.Position
    FlingModule.Thrust.Parent = hrp

    -- Start fling loop
    FlingModule.Connection = RunService.Heartbeat:Connect(function()
        if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
            FlingModule.Stop()
            return
        end
        hrp.CFrame = target.Character.HumanoidRootPart.CFrame
        FlingModule.Thrust.Location = target.Character.HumanoidRootPart.Position
    end)
end

-- Start fling (single target)
function FlingModule.Start(targetString)
    if FlingModule.Active then return end
    local targets = findPlayers(targetString)
    if #targets == 0 then return false, "Player not found" end
    aggressiveFling(targets[1])
    FlingModule.Active = true
    return true, "Fling started on "..targets[1].Name
end

-- Stop fling
function FlingModule.Stop()
    FlingModule.Active = false
    if FlingModule.Connection then
        FlingModule.Connection:Disconnect()
        FlingModule.Connection = nil
    end
    if FlingModule.Thrust then
        FlingModule.Thrust:Destroy()
        FlingModule.Thrust = nil
    end
end

return FlingModule
