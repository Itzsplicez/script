local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Load jump module
local success, jumpModule = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/jump.lua"))()
end)
if not success then
    warn("Failed to load jump.lua")
    return
end

local gui = Instance.new("ScreenGui")
gui.Name = "MilkyWayV1"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 320) -- increased height to fit new buttons
main.Position = UDim2.new(0.5, -180, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Milky Way V1"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.SourceSansBold
title.TextSize = 26
title.TextColor3 = Color3.new(1,1,1)
title.Parent = main

-- Minimize and unload buttons
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

-- Function to create a button row
local function createButtonRow(text, posY)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,-20,0,50)
    row.Position = UDim2.new(0,10,0,posY)
    row.BackgroundColor3 = Color3.fromRGB(35,35,35)
    row.Parent = main
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,10)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-70,1,0)
    label.Position = UDim2.new(0,15,0,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.SourceSans
    label.TextSize = 20
    label.TextColor3 = Color3.new(1,1,1)
    label.Parent = row

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0,40,0,40)
    toggle.Position = UDim2.new(1,-50,0.5,-20)
    toggle.Text = ""
    toggle.Font = Enum.Font.SourceSansBold
    toggle.TextSize = 20
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.BackgroundColor3 = Color3.fromRGB(255,0,0) -- red by default
    toggle.Parent = row
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,8)

    return toggle
end

-- InfJump row
local infJumpToggle = createButtonRow("InfJump", 70)
local infJumpEnabled = false
infJumpToggle.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    if infJumpEnabled then
        infJumpToggle.BackgroundColor3 = Color3.fromRGB(0,255,0)
        jumpModule.Enable()
    else
        infJumpToggle.BackgroundColor3 = Color3.fromRGB(255,0,0)
        jumpModule.Disable()
    end
end)

-- New buttons
local speedToggle = createButtonRow("Speed", 130)
local noclipToggle = createButtonRow("Noclip", 190)
local flyToggle = createButtonRow("Fly", 250)
local resetToggle = createButtonRow("Reset", 310)

-- Connect new buttons to scripts
speedToggle.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/speed.lua"))()
    end)
end)
noclipToggle.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/noclip.lua"))()
    end)
end)
flyToggle.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/fly.lua"))()
    end)
end)
resetToggle.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzsplicez/script/main/reset.lua"))()
    end)
end)

-- Mini button (black with 🌌 emoji)
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
    jumpModule.Disable()
    gui:Destroy()
end)

-- Draggable function (PC + mobile)
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
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(main)
makeDraggable(mini)

print("Milky Way V1 GUI with 4 new buttons loaded successfully")
