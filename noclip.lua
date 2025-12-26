-- Noclip module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local noclipEnabled = false
local noclipConnection

local function startNoclip()
    if noclipEnabled then return end
    noclipEnabled = true
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- Turn off collisions for all parts
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    -- Keep updating CanCollide while moving
    noclipConnection = RunService.Stepped:Connect(function()
        if not char or not char.Parent then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
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
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

-- Optional: toggle noclip with a key (like N)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.N then
        if noclipEnabled then
            stopNoclip()
        else
            startNoclip()
        end
    end
end)

-- Return module for terminal
local module = {}
module.Enable = startNoclip
module.Disable = stopNoclip
module.Enabled = function() return noclipEnabled end

return module
