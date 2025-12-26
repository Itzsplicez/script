-- Noclip module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local noclipEnabled = false
local noclipConnection
local descendantConnection

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function startNoclip()
    if noclipEnabled then return end
    noclipEnabled = true

    local char = getCharacter()

    -- Disable collisions for existing parts
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    -- Keep collisions disabled while moving
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
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- Return module for terminal
local module = {}
module.Enable = startNoclip
module.Disable = stopNoclip
module.Enabled = function() return noclipEnabled end

return module
