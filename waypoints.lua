-- Waypoints Module
local Players = game:GetService("Players")

-- Only create the module once globally
if not _G.WaypointsModule then
    local Waypoints = {}
    local playerWaypoints = {}

    local function getPlayerTable(player)
        if not playerWaypoints[player.UserId] then
            playerWaypoints[player.UserId] = {}
        end
        return playerWaypoints[player.UserId]
    end

    function Waypoints.Set(player, name)
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            return false, "Character not loaded"
        end
        local pos = char.HumanoidRootPart.Position
        getPlayerTable(player)[name:lower()] = pos
        return true, "Waypoint '"..name.."' set!"
    end

    function Waypoints.Teleport(player, name)
        local tableRef = getPlayerTable(player)
        local pos = tableRef[name:lower()]
        if not pos then return false, "Waypoint '"..name.."' does not exist" end
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(pos)
            return true, "Teleported to waypoint '"..name.."'"
        else
            return false, "Character not loaded"
        end
    end

    function Waypoints.List(player)
        local tableRef = getPlayerTable(player)
        local names = {}
        for k,_ in pairs(tableRef) do
            table.insert(names, k)
        end
        return names
    end

    function Waypoints.Delete(player, name)
        local tableRef = getPlayerTable(player)
        if tableRef[name:lower()] then
            tableRef[name:lower()] = nil
            return true, "Deleted waypoint '"..name.."'"
        else
            return false, "Waypoint '"..name.."' does not exist"
        end
    end

    _G.WaypointsModule = Waypoints
end

return _G.WaypointsModule
