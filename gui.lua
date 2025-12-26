-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Safely load jump module
local jumpModule
pcall(function()
    jumpModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/jump.lua"))()
end)

-- Fly module
local flyModule = {}
local flying = false
local flySpeed = 50
local flyConnection

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
        local direction = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction -= Vector3.new(0,1,0) end
        if direction.Magnitude > 0 then direction = direction.Unit * flySpeed end
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

-- Safely load noclip module
local noclipModule
pcall(function()
    local mod = game:GetService("ReplicatedStorage"):FindFirstChild("noclip")
    if mod then noclipModule = require(mod) end
end)

-- GUI setup
local gui = Instance.new("ScreenGui")
gui.Name = "MilkyWayV1"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0,400,0,300)
main.Position = UDim2.new(0.5,-200,0.5,-150)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-100,0,40)
title.Position = UDim2.new(0,10,0,10)
title.BackgroundTransparency = 1
title.Text = "MilkyWay Terminal"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.SourceSansBold
title.TextSize = 26
title.TextColor3 = Color3.new(1,1,1)
title.Parent = main

-- Minimize and unload buttons
local function makeButton(text, posX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,30,0,30)
    btn.Position = UDim2.new(1,posX,0,10)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 22
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(128,0,128)
    btn.Parent = main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    return btn
end

local minimizeBtn = makeButton("−",-70)
local unloadBtn = makeButton("X",-35)

-- Terminal output
local outputFrame = Instance.new("ScrollingFrame")
outputFrame.Size = UDim2.new(1,-20,1,-100)
outputFrame.Position = UDim2.new(0,10,0,50)
outputFrame.BackgroundTransparency = 1
outputFrame.ScrollBarThickness = 8
outputFrame.CanvasSize = UDim2.new(0,0,0,0)
outputFrame.Parent = main
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0,5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = outputFrame

local function printToTerminal(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0,20)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Text = text
    label.Parent = outputFrame
    outputFrame.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y)
    outputFrame.CanvasPosition = Vector2.new(0,outputFrame.CanvasSize.Y.Offset)
end

-- Input box
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1,-20,0,40)
inputBox.Position = UDim2.new(0,10,1,-50)
inputBox.PlaceholderText = "Type a command and press Enter"
inputBox.ClearTextOnFocus = false
inputBox.Font = Enum.Font.SourceSans
inputBox.TextSize = 18
inputBox.TextColor3 = Color3.fromRGB(0,0,0)
inputBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
inputBox.Parent = main
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0,8)

-- Mini button
local mini = Instance.new("TextButton")
mini.Size = UDim2.new(0,50,0,50)
mini.Position = UDim2.new(0,50,0,50)
mini.BackgroundColor3 = Color3.fromRGB(0,0,0)
mini.Text = "🌌"
mini.TextScaled = true
mini.TextColor3 = Color3.fromRGB(255,255,255)
mini.Visible = false
mini.Parent = gui
Instance.new("UICorner", mini).CornerRadius = UDim.new(0,12)

-- Minimize and restore
minimizeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    mini.Visible = true
end)
mini.MouseButton1Click:Connect(function()
    main.Visible = true
    mini.Visible = false
end)

-- Unload
unloadBtn.MouseButton1Click:Connect(function()
    if jumpModule then pcall(jumpModule.Disable) end
    pcall(flyModule.Stop)
    if noclipModule then pcall(noclipModule.Disable) end
    gui:Destroy()
end)

-- Draggable
local function makeDraggable(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
makeDraggable(main)
makeDraggable(mini)

-- Commands list
local commands = {"/clear","/fly","/help","/jump","/noclip","/reset","/speed"}

-- Terminal command execution
inputBox.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    local text = inputBox.Text:lower():gsub("^%s*(.-)%s*$","%1")
    local cmd,arg = text:match("^(%S+)%s*(%S*)$")
    arg = arg or ""

    if cmd == "/clear" then
        for _, child in ipairs(outputFrame:GetChildren()) do if child:IsA("TextLabel") then child:Destroy() end end
        outputFrame.CanvasPosition = Vector2.new(0,0)
        printToTerminal("Terminal cleared")

    elseif cmd == "/jump" then
        if arg == "off" then pcall(function() if jumpModule then jumpModule.Disable() end end)
        else pcall(function() if jumpModule then jumpModule.Enable() end end)
        printToTerminal("InfJump "..(arg=="off" and "disabled" or "enabled"))

    elseif cmd == "/speed" then
        local char = player.Character
        if arg == "off" then
            if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 20 end
            printToTerminal("Speed reset to default (20)")
        else
            local num = tonumber(arg)
            if num and num>=1 and num<=100 then
                if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed=num end
                printToTerminal("Speed set to "..num)
            else
                printToTerminal("Invalid speed! Use /speed 1-100")
            end
        end

    elseif cmd == "/fly" then
        local num = tonumber(arg)
        if arg=="off" then pcall(flyModule.Stop); printToTerminal("Fly disabled")
        elseif num then pcall(flyModule.Start,num); printToTerminal("Fly enabled at speed "..num)
        else printToTerminal("Invalid fly command") end

    elseif cmd == "/noclip" then
        if noclipModule then
            if arg=="off" then pcall(noclipModule.Disable); printToTerminal("Noclip disabled")
            else pcall(noclipModule.Enable); printToTerminal("Noclip enabled") end
        else
            printToTerminal("Noclip module not found")
        end

    elseif cmd == "/reset" then
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/reset.lua"))() end)
        printToTerminal("Reset executed")

    elseif cmd == "/help" then
        printToTerminal("Available commands:")
        for _,v in ipairs(commands) do printToTerminal("  "..v) end
        printToTerminal("Use /command off to disable (if supported)")

    else
        printToTerminal("Unknown command: "..text)
    end

    inputBox.Text=""
end)

print("MilkyWay Terminal loaded successfully")
