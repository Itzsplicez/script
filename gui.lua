-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local activeLoops = {}
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
-- Player finder with autocomplete / partial match
local function getPlayerFromArg(arg)
    if not arg or arg == "" then
        return nil
    end

    arg = arg:lower()
    local players = Players:GetPlayers()

    if arg == "me" then
        return player
    elseif arg == "others" then
        for _, plr in ipairs(players) do
            if plr ~= player then
                return plr
            end
        end
    elseif arg == "all" or arg == "everyone" then
        return players[1]
    end

    -- Exact name match (case-insensitive)
    for _, plr in ipairs(players) do
        if plr.Name:lower() == arg then
            return plr
        end
    end

    -- Partial / autocomplete match
    for _, plr in ipairs(players) do
        if plr.Name:lower():sub(1, #arg) == arg then
            return plr
        end
    end

    return nil
end

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
gui.Name = "Itzsplicez"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -200, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Itzsplicez Terminal"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.SourceSansBold
title.TextSize = 26
title.TextColor3 = Color3.new(1,1,1)
title.Parent = main

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,30,0,30)
minimizeBtn.Position = UDim2.new(1,-70,0,10)
minimizeBtn.Text = "−"
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 22
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(128,0,128)
minimizeBtn.Parent = main
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,8)

local unloadBtn = Instance.new("TextButton")
unloadBtn.Size = UDim2.new(0,30,0,30)
unloadBtn.Position = UDim2.new(1,-35,0,10)
unloadBtn.Text = "X"
unloadBtn.Font = Enum.Font.SourceSansBold
unloadBtn.TextSize = 18
unloadBtn.TextColor3 = Color3.new(1,1,1)
unloadBtn.BackgroundColor3 = Color3.fromRGB(128,0,128)
unloadBtn.Parent = main
Instance.new("UICorner", unloadBtn).CornerRadius = UDim.new(0,8)

-- Terminal output
local outputFrame = Instance.new("ScrollingFrame")
outputFrame.Size = UDim2.new(1, -20, 1, -100)
outputFrame.Position = UDim2.new(0, 10, 0, 50)
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
    outputFrame.CanvasPosition = Vector2.new(0, outputFrame.CanvasSize.Y.Offset)
end

-- Input box
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -20, 0, 40)
inputBox.Position = UDim2.new(0, 10, 1, -50)
inputBox.PlaceholderText = "Type a command and press Enter"
inputBox.ClearTextOnFocus = false
inputBox.Text = ""
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

minimizeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    mini.Visible = true
end)
mini.MouseButton1Click:Connect(function()
    main.Visible = true
    mini.Visible = false
end)

unloadBtn.MouseButton1Click:Connect(function()
    if jumpModule then jumpModule.Disable() end
    if _G.ToggleNoclip then _G.ToggleNoclip(false) end
    flyModule.Stop()
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
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
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

-- Commands
local commands = {
    "/clear",
    "/doors",
    "/esp",
    "/fly",
    "/float",
    "/fling",
    "/help",
    "/infjump",
    "/jumpboost",
    "/noclip",
    "/reset",
    "/spin",
    "/speed",
    "/teleport",
    "/tacos",
    "/swimfly",
}

-- Terminal command execution
inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local text = inputBox.Text:lower():gsub("^%s*(.-)%s*$", "%1")
        local cmd, arg = text:match("^(%S+)%s*(%S*)$")

        if cmd == "/clear" then
            for _, child in ipairs(outputFrame:GetChildren()) do
                if child:IsA("TextLabel") then child:Destroy() end
            end
            outputFrame.CanvasPosition = Vector2.new(0,0)
            printToTerminal("Terminal cleared")

        elseif cmd == "/infjump" then
            if arg == "off" then
                if jumpModule then jumpModule.Disable() end
                printToTerminal("InfJump disabled")
            else
                if jumpModule then jumpModule.Enable() end
                printToTerminal("InfJump enabled")
            end

        elseif cmd == "/speed" then
            local char = player.Character
            if arg == "off" then
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = 16
                end
                printToTerminal("Speed reset to default (16)")
            else
                local num = tonumber(arg)
                if num and num >= 1 and num <= 500 then
                    if char and char:FindFirstChild("Humanoid") then
                        char.Humanoid.WalkSpeed = num
                    end
                    printToTerminal("Speed set to "..num)
                else
                    printToTerminal("Invalid speed! Use /speed 1-500")
                end
            end

        elseif cmd == "/fly" then
            local num = tonumber(arg)
            if arg == "off" then
                flyModule.Stop()
                printToTerminal("Fly disabled")
            elseif num and num >=1 and num <=100 then
                flyModule.Start(num)
                printToTerminal("Fly enabled at speed "..num)
            else
                printToTerminal("Invalid fly speed! Use /fly 1-100 or /fly off")
            end

        elseif cmd == "/noclip" then
            if arg == "off" then
                if _G.ToggleNoclip then
                    _G.ToggleNoclip(false)
                    printToTerminal("Noclip disabled")
                else
                    printToTerminal("Noclip is not running")
                end
            else
                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/noclip.lua"))()
                end)
                if _G.ToggleNoclip then _G.ToggleNoclip(true) end
                printToTerminal("Noclip enabled")
            end

        elseif cmd == "/reset" then
            if arg == "off" then
                printToTerminal("Reset cannot be turned off")
            else
                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/reset.lua"))()
                end)
                printToTerminal("Reset executed")
            end

        elseif cmd == "/help" then
            printToTerminal("Available commands:")
            for _, v in ipairs(commands) do
                printToTerminal("  "..v)
            end
            printToTerminal("To turn off a command, type /command off (if supported)")

elseif cmd == "/fling" then
    if arg == "off" then
        if _G.ToggleFling then
            _G.ToggleFling(false)
            printToTerminal("Fling disabled")
        else
            printToTerminal("Fling is not running")
        end
    else
        local targetPlayer = getPlayerFromArg(arg)

        if targetPlayer then
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/fling.lua"))()
            end)

            if _G.ToggleFling then
                _G.ToggleFling(true, targetPlayer)
                printToTerminal("Flinging "..targetPlayer.Name)
            else
                printToTerminal("Fling module failed to load")
            end
        else
            printToTerminal("Player not found: "..arg)
        end
    end

elseif cmd == "/swimfly" then
    if arg == "off" then
        if _G.ToggleSwim then
            _G.ToggleSwim(false)
            printToTerminal("Swim disabled")
        else
            printToTerminal("Swim module is not running")
        end
    else
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/swim.lua"))()
        end)
        if _G.ToggleSwim then
            _G.ToggleSwim(true)
            printToTerminal("Swim enabled")
        else
            printToTerminal("Swim module failed to load")
        end
    end

elseif cmd == "/jumpboost" then
    local success, jumpBoostModule = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/jumpboost.lua"))()
    end)

    if not success or not jumpBoostModule then
        printToTerminal("Failed to load jumpboost module")
    else
        if arg == "off" then
            jumpBoostModule.Disable()
            printToTerminal("JumpBoost disabled")
        else
            local num = tonumber(arg)
            if num and num >= 10 and num <= 500 then
                jumpBoostModule.Enable(num)
                printToTerminal("JumpBoost enabled with power " .. num)
            else
                printToTerminal("Invalid jump power! Use /jumpboost 10-500 or /jumpboost off")
            end
        end
    end

elseif cmd == "/teleport" then
    local success, teleportModule = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/teleport.lua"))()
    end)

    if not success or not teleportModule then
        printToTerminal("Failed to load teleport module")
    else
        local targetPlayer = getPlayerFromArg(arg)
        if targetPlayer then
            teleportModule.ToPlayer(targetPlayer)
            printToTerminal("Teleported to " .. targetPlayer.Name)
        else
            printToTerminal("Player not found: " .. arg)
        end
    end

elseif cmd == "/float" then
    -- Load the float module when command is run
    local success, floatModule = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/float.lua"))()
    end)

    if not success or not floatModule then
        printToTerminal("Failed to load float module")
    else
        if arg == "off" then
            floatModule.Stop()
            printToTerminal("Float disabled")
        else
            floatModule.Start()
            printToTerminal("Float enabled")
        end
    end

elseif cmd == "/tacos" then
    -- Persistent module
    if not _G.TacoModule then
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer

        local TacoModule = {}
        local tacoSound
        local heartbeatConnection

        -- Make sure the sound attaches to the current character
        local function getHRP()
            local char = player.Character
            if char then
                return char:FindFirstChild("HumanoidRootPart")
            end
            return nil
        end

        function TacoModule.Stop()
            if tacoSound then
                tacoSound:Stop()
                tacoSound:Destroy()
                tacoSound = nil
            end
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end
        end

        function TacoModule.Play()
            TacoModule.Stop() -- stop previous if exists

            local hrp = getHRP()
            if not hrp then
                -- Wait for character
                hrp = player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")
            end

            tacoSound = Instance.new("Sound")
            tacoSound.SoundId = "rbxassetid://142376088"
            tacoSound.Volume = 1
            tacoSound.Looped = true
            tacoSound.PlaybackSpeed = 1
            tacoSound.Parent = hrp

            heartbeatConnection = RunService.Heartbeat:Connect(function()
                if tacoSound and hrp then
                    tacoSound.Position = hrp.Position
                end
            end)

            tacoSound:Play()
        end

        -- Store globally
        _G.TacoModule = TacoModule
        _G.tacoPlaying = false

        -- Stop the sound automatically if player respawns
        player.CharacterAdded:Connect(function(char)
            if _G.tacoPlaying and _G.TacoModule then
                -- Delay to let HRP exist
                char:WaitForChild("HumanoidRootPart")
                _G.TacoModule.Play()
            end
        end)
    end

    -- Toggle sound
    if arg == "off" then
        if _G.TacoModule then
            _G.TacoModule.Stop()
            _G.tacoPlaying = false
            printToTerminal("Raining Tacos stopped")
        end
    else
        if not _G.tacoPlaying then
            _G.TacoModule.Play()
            _G.tacoPlaying = true
            printToTerminal("Raining Tacos playing")
        else
            printToTerminal("Raining Tacos already playing")
        end
    end
                
elseif cmd == "/esp" then
    if not _G.ESPModule then
        local success, esp = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/esp.lua", true))() -- Or load from URL
        end)
        if success then _G.ESPModule = esp end
    end

    if arg == "off" then
        if _G.ESPModule then _G.ESPModule.Toggle(false) end
        printToTerminal("ESP disabled")
    else
        if _G.ESPModule then _G.ESPModule.Toggle(true) end
        printToTerminal("ESP enabled")
    end
                
elseif cmd == "/doors" then
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/doors.lua", true))()
    end)
    if success then
        printToTerminal("Doors script loaded")
    else
        printToTerminal("Failed to load Doors script: " .. tostring(err))
    end

elseif cmd == "/spin" then
    local success, spinModule = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/spin.lua"))()
    end)

    if not success or not spinModule then
        printToTerminal("Failed to load spin module")
    else
        if arg == "off" then
            spinModule.Stop()
            printToTerminal("Spin disabled")
        else
            local speed = tonumber(arg) or 5
            if speed < 1 or speed > 50 then speed = 5 end
            spinModule.Start(speed)
            printToTerminal("Spinning enabled at speed "..speed)
        end
    end

        else
            printToTerminal("Unknown command: "..inputBox.Text)
        end

        inputBox.Text = ""
    end
end)

print("Itzsplicez Terminal loaded successfully")
