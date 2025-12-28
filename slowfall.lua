-- slowfall.lua
-- Module to slowly fall with swimming animation
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local SlowFall = {}
local falling = false
local connection = nil
local originalAnim = nil

-- Helper to get Humanoid
local function getHumanoid()
    local char = player.Character
    if char then
        return char:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

-- Start slowfall
function SlowFall.Start()
    if falling then return end
    falling = true

    local humanoid = getHumanoid()
    if not humanoid then return end

    -- Save original animation
    originalAnim = humanoid:FindFirstChildOfClass("Animator")

    -- Load swimming animation
    local swimAnim = Instance.new("Animation")
    swimAnim.AnimationId = "rbxassetid://182393976" -- default swim animation
    local animTrack = humanoid:LoadAnimation(swimAnim)
    animTrack:Play()

    -- Apply slow downward velocity
    connection = RunService.Heartbeat:Connect(function()
        if not falling then return end
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            if humanoid.FloorMaterial == Enum.Material.Air then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, -5, hrp.Velocity.Z)
            end
        end
    end)
end

-- Stop slowfall
function SlowFall.Stop()
    falling = false
    if connection then
        connection:Disconnect()
        connection = nil
    end

    local humanoid = getHumanoid()
    if humanoid and originalAnim then
        -- Stop swimming animation
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end
end

return SlowFall
