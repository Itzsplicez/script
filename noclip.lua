-- Noclip module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local noclipEnabled = false
local noclipConnection
local descendantConnection

-- Helper to safely get the player's character
local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

-- Start noclip
local function startNoclip()
    if noclipEnabled then return end
    noclipEnabled = true

    local char = getCharacter()
    if not char then return end

    -- Disable collisions for all current parts
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    -- Continuously disable collisions during movement
    noclipConnection = RunService.Stepped:Connect(function()
        if not char or not char.Parent then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)

    -- Disable collisions for any new parts added
    descendantConnection = char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end)
end

-- Stop noclip
local function stopNoclip()
    if not noclipEnabled then return end
    noclipEnabled = false

    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end

    if descendantConnection then
        descendantConnection:Disconnect()
        descendantConnection = nil
    end

    local char = player.Character
    if not char then return end

    -- Re-enable collisions for all parts
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- Module interface
local module = {}
module.Enable = startNoclip
module.Disable = stopNoclip
module.Enabled = function() return noclipEnabled end

return module
