-- Waypoints Module
local Waypoints = {}
local Players = game:GetService("Players")

-- Table to store waypoints per player
local playerWaypoints = {}

-- Ensure table exists for a player
local function getPlayerTable(player)
    if not playerWaypoints[player.UserId] then
        playerWaypoints[player.UserId] = {}
    end
    return playerWaypoints[player.UserId]
end

-- Set a waypoint
function Waypoints.Set(player, name)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return false, "Character not loaded"
    end
    local pos = char.HumanoidRootPart.Position
    getPlayerTable(player)[name:lower()] = pos
    return true, "Waypoint '"..name.."' set!"
end

-- Teleport to a waypoint
function Waypoints.Teleport(player, name)
    local tableRef = getPlayerTable(player)
    local pos = tableRef[name:lower()]
    if not pos then
        return false, "Waypoint '"..name.."' does not exist"
    end
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
        return true, "Teleported to waypoint '"..name.."'"
    else
        return false, "Character not loaded"
    end
end

-- List all waypoints
function Waypoints.List(player)
    local tableRef = getPlayerTable(player)
    local names = {}
    for k,_ in pairs(tableRef) do
        table.insert(names, k)
    end
    return names
end

-- Delete a waypoint
function Waypoints.Delete(player, name)
    local tableRef = getPlayerTable(player)
    if tableRef[name:lower()] then
        tableRef[name:lower()] = nil
        return true, "Deleted waypoint '"..name.."'"
    else
        return false, "Waypoint '"..name.."' does not exist"
    end
end

return Waypoints
