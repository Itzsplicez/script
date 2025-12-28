-- dash.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local Dash = {}
local canDash = true
local dashSpeed = 100
local dashDuration = 0.2
local cooldown = 1
local dashConnection
local dashButton
local inputConnection

-- Helper to get HumanoidRootPart
local function getHRP()
    local char = player.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

-- Dash function
local function doDash()
    if not canDash then return end
    local hrp = getHRP()
    if not hrp then return end

    canDash = false
    local forward = hrp.CFrame.LookVector
    local startTime = tick()

    dashConnection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        if elapsed > dashDuration then
            dashConnection:Disconnect()
            dashConnection = nil
        else
            hrp.Velocity = forward * dashSpeed + Vector3.new(0, hrp.Velocity.Y, 0)
        end
    end)

    -- Cooldown
    spawn(function()
        wait(cooldown)
        canDash = true
    end)
end

-- Keyboard dash (Shift key)
inputConnection = UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.LeftShift then
        doDash()
    end
end)

-- Mobile GUI button
local function createButton()
    if dashButton then return end

    local gui = player:WaitForChild("PlayerGui")
    dashButton = Instance.new("TextButton")
    dashButton.Size = UDim2.new(0, 100, 0, 50)
    dashButton.Position = UDim2.new(0.5, -50, 0.8, 0)
    dashButton.AnchorPoint = Vector2.new(0.5, 0)
    dashButton.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    dashButton.Text = "Dash"
    dashButton.TextColor3 = Color3.new(1, 1, 1)
    dashButton.Font = Enum.Font.SourceSansBold
    dashButton.TextScaled = true
    dashButton.ZIndex = 10
    dashButton.Parent = gui
    dashButton.Visible = true

    dashButton.MouseButton1Click:Connect(doDash)
end

-- Only show button if on mobile
if UserInputService.TouchEnabled then
    createButton()
end

-- Stop function
function Dash.Stop()
    -- Disconnect dash heartbeat
    if dashConnection then
        dashConnection:Disconnect()
        dashConnection = nil
    end

    -- Disconnect keyboard input
    if inputConnection then
        inputConnection:Disconnect()
        inputConnection = nil
    end

    -- Destroy mobile button
    if dashButton then
        dashButton:Destroy()
        dashButton = nil
    end
end

return Dash
