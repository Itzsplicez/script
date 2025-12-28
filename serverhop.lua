local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local ServerHop = {}

-- Get a list of public servers for the place
local function getServers(cursor)
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    if cursor then
        url = url.."&cursor="..cursor
    end
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    if not success then return {} end
    local data = HttpService:JSONDecode(response)
    return data
end

function ServerHop.Hop(mode)
    local servers = getServers()
    if not servers or not servers.data then
        warn("Failed to get server list")
        return
    end

    local chosenServer
    for _, server in ipairs(servers.data) do
        local maxPlayers = server.maxPlayers
        local playing = server.playing
        local id = server.id

        if mode == "full" and (maxPlayers - playing) <= 2 and (maxPlayers - playing) > 0 then
            chosenServer = id
            break
        elseif mode == "small" and playing == 1 then
            chosenServer = id
            break
        end
    end

    if chosenServer then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, chosenServer, Players.LocalPlayer)
    else
        warn("No suitable server found for mode: "..mode)
    end
end

return ServerHop
