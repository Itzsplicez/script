-- dash.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Dash = {}
local dashSpeed = 100
local dashDuration = 0.2
local isDashing = false
local dashTime = 0
local forwardVector = Vector3.new(0,0,0)
local inputConnection
local dashButton
local originalCFrame

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
    originalCFrame = Camera.CFrame
end

-- Create GUI button
local function createButton()
    if dashButton then return end

    local gui = player:WaitForChild("PlayerGui")
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

createButton()

-- Keyboard input
inputConnection = UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.LeftShift then
        startDash()
    end
end)

-- Heartbeat loop
local heartbeatConnection
heartbeatConnection = RunService.Heartbeat:Connect(function(delta)
    if isDashing then
        local hrp = getHRP()
        if not hrp then return end

        -- Move player
        hrp.Velocity = forwardVector * dashSpeed + Vector3.new(0, hrp.Velocity.Y, 0)

        -- Screen shake
        local magnitude = 0.1
        local shakeX = (math.random() - 0.5) * magnitude
        local shakeY = (math.random() - 0.5) * magnitude
        local shakeZ = (math.random() - 0.5) * magnitude
        Camera.CFrame = originalCFrame * CFrame.new(shakeX, shakeY, shakeZ)

        dashTime = dashTime + delta
        if dashTime >= dashDuration then
            isDashing = false
            Camera.CFrame = originalCFrame -- reset camera
        end
    end
end)

-- Stop function
function Dash.Stop()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end

    if inputConnection then
        inputConnection:Disconnect()
        inputConnection = nil
    end

    if dashButton then
        dashButton:Destroy()
        dashButton = nil
    end

    isDashing = false
    if Camera and originalCFrame then
        Camera.CFrame = originalCFrame
    end
end

return Dash
