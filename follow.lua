-- follow.lua
-- Module to make a player follow another player
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local FollowModule = {}
local following = false
local targetPlayer = nil
local conn = nil

-- Helper function to get HumanoidRootPart safely
local function getHRP(plr)
    local char = plr.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

-- Start following a player
function FollowModule.Start(plr)
    if not plr or plr == player then return end
    following = true
    targetPlayer = plr

    local hrp = getHRP(player)
    if not hrp then return end

    -- Disconnect previous connection if exists
    if conn then conn:Disconnect() end

    conn = RunService.RenderStepped:Connect(function()
        if not following or not hrp or not targetPlayer.Character then return end
        local targetHRP = getHRP(targetPlayer)
        if targetHRP then
            local direction = targetHRP.Position - hrp.Position
            local distance = direction.Magnitude
            if distance > 2 then
                -- Smoothly rotate towards target and move forward
                local moveCFrame = CFrame.new(hrp.Position, targetHRP.Position) * CFrame.new(0,0,-math.min(distance, 10))
                hrp.CFrame = hrp.CFrame:Lerp(moveCFrame, 0.1)
            end
        end
    end)
end

-- Stop following
function FollowModule.Stop()
    following = false
    targetPlayer = nil
    if conn then
        conn:Disconnect()
        conn = nil
    end
end

-- Toggle follow
function FollowModule.Toggle(plr)
    if plr then
        FollowModule.Start(plr)
    else
        FollowModule.Stop()
    end
end

return FollowModule
