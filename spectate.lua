local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local Spectate = {}
local spectating = false
local oldSubject
local targetPlayer
local charConn

local function stop()
    spectating = false

    if charConn then
        charConn:Disconnect()
        charConn = nil
    end

    if oldSubject then
        camera.CameraSubject = oldSubject
        camera.CameraType = Enum.CameraType.Custom
    end

    targetPlayer = nil
end

local function spectateCharacter(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = humanoid
    end
end

function Spectate.Start(plr)
    if not plr or plr == player then return end

    stop()
    spectating = true
    targetPlayer = plr

    oldSubject = camera.CameraSubject

    if plr.Character then
        spectateCharacter(plr.Character)
    end

    charConn = plr.CharacterAdded:Connect(function(char)
        if spectating then
            spectateCharacter(char)
        end
    end)
end

function Spectate.Stop()
    stop()
end

function Spectate.IsSpectating()
    return spectating
end

return Spectate
