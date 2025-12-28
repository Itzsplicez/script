-- DashTool LocalScript (put inside StarterPlayerScripts or StarterPack if Tool is pre-made)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local dashSpeed = 100
local dashDuration = 0.2
local isDashing = false
local dashTime = 0
local forwardVector = Vector3.new(0,0,0)

-- Give player a Tool
local tool = Instance.new("Tool")
tool.Name = "Dash"
tool.RequiresHandle = false
tool.Parent = player:WaitForChild("Backpack")

-- Helper to get HRP
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- Dash function
local function startDash()
    if isDashing then return end
    local hrp = getHRP()
    if not hrp then return end
    forwardVector = hrp.CFrame.LookVector
    isDashing = true
    dashTime = 0
end

-- Tool activation
tool.Activated:Connect(startDash) -- works for clicks and taps

-- Heartbeat loop
RunService.Heartbeat:Connect(function(delta)
    if isDashing then
        local hrp = getHRP()
        if not hrp then return end
        hrp.Velocity = forwardVector * dashSpeed + Vector3.new(0, hrp.Velocity.Y, 0)
        dashTime = dashTime + delta
        if dashTime >= dashDuration then
            isDashing = false
        end
    end
end)
