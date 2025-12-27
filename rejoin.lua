local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local rejoinModule = {}

function rejoinModule.Rejoin()
    local player = Players.LocalPlayer
    local placeId = game.PlaceId
    local teleportData = {} -- optional, you can send info here if needed

    -- Teleport the player to the same place (current server)
    TeleportService:Teleport(placeId, player, teleportData)
end

return rejoinModule
