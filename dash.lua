-- dash_module.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local DashModule = {}
local dashSpeed = 100
local dashDuration = 0.2
local isDashing = false
local dashTime = 0
local forwardVector = Vector3.new(0,0,0)
local dashButton
local heartbeatConnection
local inputConnection

-- Helper to get HRP
local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- Start dash
local function startDash()
    if isDashing then return end
    local hrp = getHRP()
    if not hrp then return end

    forwardVector = hrp.CFrame.LookVector
    isDashing = true
    dashTime = 0
end

-- Create GUI button
local function createButton()
    local gui = player:WaitForChild("PlayerGui")
    if dashButton then dashButton:Destroy() end

    dashButton = Instance.new("TextButton")
    dashButton.Size = UDim2.new(0,120,0,60)
    dashButton.Position = UDim2.new(0.5, -60, 0.85, 0)
    dashButton.AnchorPoint = Vector2.new(0.5,0)
    dashButton.BackgroundColor3 = Color3.fromRGB(128,0,255)
    dashButton.Text = "Dash"
    dashButton.TextColor3 = Color3.new(1,1,1)
    dashButton.Font = Enum.Font.SourceSansBold
    dashButton.TextScaled = true
    dashButton.Parent = gui

    dashButton.MouseButton1Click:Connect(startDash)
end

-- Keyboard input
inputConnection = UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.LeftShift then
        startDash()
    end
end)

-- Heartbeat loop
heartbeatConnection = RunService.Heartbeat:Connect(function(delta)
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

-- Initialize button
createButton()

-- Stop function for /dash off
function DashModule.Stop()
    if dashButton then
        dashButton:Destroy()
        dashButton = nil
    end
    if inputConnection then
        inputConnection:Disconnect()
        inputConnection = nil
    end
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
    isDashing = false
end

return DashModule
