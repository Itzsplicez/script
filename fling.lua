-- fling.lua for MilkyWay Terminal
-- Touch/mouse fling (toggleable)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

_G.MilkyWayFling = _G.MilkyWayFling or {
    Enabled = false,
    HeartbeatConnection = nil
}

local state = _G.MilkyWayFling
local fakePart, mouse, w, a, s, d, isDown

-- Send notification
local function send(text)
    StarterGui:SetCore("SendNotification", {
        Title = "Fling by MilkyWay",
        Text = text,
        Duration = 5
    })
end

local function setup()
    if state.Enabled then return end
    state.Enabled = true
    mouse = player:GetMouse()
    w, a, s, d = false, false, false, false
    isDown = false

    -- Fake part for controlling fling
    fakePart = Instance.new("Part")
    fakePart.Size = Vector3.new(5,5,5)
    fakePart.Anchored = true
    fakePart.CanCollide = false
    fakePart.Transparency = 0.5
    fakePart.Material = Enum.Material.ForceField
    fakePart.Position = player.Character.HumanoidRootPart.Position
    fakePart.Parent = workspace

    local att1 = Instance.new("Attachment", fakePart)
    local att2 = Instance.new("Attachment", player.Character.HumanoidRootPart)
    local body = Instance.new("AlignPosition", fakePart)
    body.Attachment0 = att2
    body.Attachment1 = att1
    body.RigidityEnabled = true
    body.Responsiveness = math.huge
    body.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    body.MaxVelocity = math.huge
    body.MaxAxesForce = Vector3.new(math.huge, math.huge, math.huge)
    body.Mode = Enum.PositionAlignmentMode.TwoAttachment

    -- Notification
    send("Fling enabled, loading...")

    -- Handle WASD movement for fakePart
    mouse.KeyDown:Connect(function(key)
        if key == "w" then w = true end
        if key == "a" then a = true end
        if key == "s" then s = true end
        if key == "d" then d = true end
    end)
    mouse.KeyUp:Connect(function(key)
        if key == "w" then w = false end
        if key == "a" then a = false end
        if key == "s" then s = false end
        if key == "d" then d = false end
    end)
    mouse.Button1Down:Connect(function() isDown = true end)
    mouse.Button1Up:Connect(function() isDown = false end)

    -- Main Heartbeat
    state.HeartbeatConnection = RunService.Heartbeat:Connect(function()
        local hrp = player.Character.HumanoidRootPart
        if not hrp or not state.Enabled then return end

        -- Move fakePart based on keys
        local cam = workspace.CurrentCamera
        local moveVec = Vector3.new()
        if w then moveVec = moveVec + cam.CFrame.LookVector end
        if s then moveVec = moveVec - cam.CFrame.LookVector end
        if a then moveVec = moveVec - cam.CFrame.RightVector end
        if d then moveVec = moveVec + cam.CFrame.RightVector end
        fakePart.Position = fakePart.Position + moveVec * 2

        -- Fling others when mouse down
        if isDown then
            for _, target in pairs(Players:GetPlayers()) do
                if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHRP = target.Character.HumanoidRootPart
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(1e6,1e6,1e6)
                    bv.Velocity = (targetHRP.Position - hrp.Position).Unit * 200
                    bv.Parent = targetHRP
                    Debris:AddItem(bv, 0.2)
                end
            end
        end

        -- Keep your HumanoidRootPart synced
        if not isDown then
            hrp.CFrame = fakePart.CFrame
        end

        -- Small random velocity for chaos effect
        hrp.Velocity = Vector3.new(math.random(-50,50), math.random(-50,50), math.random(-50,50))
    end)
end

local function cleanup()
    state.Enabled = false
    if state.HeartbeatConnection then
        state.HeartbeatConnection:Disconnect()
        state.HeartbeatConnection = nil
    end
    if fakePart then
        fakePart:Destroy()
        fakePart = nil
    end
end

-- Respawn support
player.CharacterAdded:Connect(function()
    if state.Enabled then
        task.wait(0.5)
        setup()
    end
end)

_G.ToggleFling = function(on)
    if on then
        setup()
    else
        cleanup()
    end
end

-- Auto enable
setup()
