-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Load jump module
local success, jumpModule = pcall(function()
return loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/jump.lua"))()
end)

-- Fly module
local flyModule = {}
local flying = false
local flySpeed = 50
local flyConnection = nil

function flyModule.Start(speed)
    flySpeed = math.clamp(speed or 50, 1, 100)
    if flying then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    flying = true
    local hrp = char.HumanoidRootPart
    local cam = workspace.CurrentCamera
    local velocity = Instance.new("BodyVelocity")
    velocity.MaxForce = Vector3.new(400000,400000,400000)
    velocity.Velocity = Vector3.new(0,0,0)
    velocity.Parent = hrp

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying then return end
        local direction = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction = direction - Vector3.new(0,1,0)
        end

        if direction.Magnitude > 0 then
            direction = direction.Unit * flySpeed
        end
        velocity.Velocity = direction
    end)
end

function flyModule.Stop()
    flying = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        for _, v in ipairs(char.HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
end

-- GUI setup
local gui = Instance.new("ScreenGui")
gui.Name = "MilkyWayV1"
@@ -118,6 +182,7 @@ end)

unloadBtn.MouseButton1Click:Connect(function()
if jumpModule then jumpModule.Disable() end
    flyModule.Stop()
gui:Destroy()
end)

@@ -150,7 +215,7 @@ end
makeDraggable(main)
makeDraggable(mini)

-- Command list in alphabetical order (except /clear at top)
-- Commands
local commands = {
"/clear",
"/fly",
@@ -202,24 +267,26 @@ inputBox.FocusLost:Connect(function(enterPressed)
end
end

        elseif cmd == "/noclip" then
        elseif cmd == "/fly" then
            local num = tonumber(arg)
if arg == "off" then
                printToTerminal("Noclip disabled (manual stop required)")
                flyModule.Stop()
                printToTerminal("Fly disabled")
            elseif num and num >=1 and num <=100 then
                flyModule.Start(num)
                printToTerminal("Fly enabled at speed "..num)
else
                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/noclip.lua"))()
                end)
                printToTerminal("Noclip enabled")
                printToTerminal("Invalid fly speed! Use /fly 1-100 or /fly off")
end

        elseif cmd == "/fly" then
        elseif cmd == "/noclip" then
if arg == "off" then
                printToTerminal("Fly disabled (manual stop required)")
                printToTerminal("Noclip disabled (manual stop required)")
else
pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/fly.lua"))()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/noclip.lua"))()
end)
                printToTerminal("Fly enabled")
                printToTerminal("Noclip enabled")
end

elseif cmd == "/reset" then
