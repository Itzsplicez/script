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
main.Size = UDim2.new(0, 360, 0, 300)
main.Position = UDim2.new(0.5, -180, 0.5, -150)
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

-- Scrollable frame for buttons
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -60)
scrollFrame.Position = UDim2.new(0,10,0,50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 8
scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollFrame.Parent = main

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0,10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

-- Function to create a button row
local function createButtonRow(text)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,0,0,50)
    row.BackgroundColor3 = Color3.fromRGB(35,35,35)
    row.Parent = scrollFrame
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
    toggle.BackgroundColor3 = Color3.fromRGB(255,0,0)
    toggle.Parent = row
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,8)

    return toggle
end

-- InfJump
local infJumpToggle = createButtonRow("InfJump")
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

-- Other buttons
local speedToggle = createButtonRow("Speed")
local noclipToggle = createButtonRow("Noclip")
local flyToggle = createButtonRow("Fly")
local resetToggle = createButtonRow("Reset")

-- Connect buttons to scripts
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

-- Update canvas size automatically
scrollFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0,0,0,scrollFrame.UIListLayout.AbsoluteContentSize.Y)
end)
scrollFrame.CanvasSize = UDim2.new(0,0,0,scrollFrame.UIListLayout.AbsoluteContentSize.Y)

print("Milky Way V1 GUI with scrollable buttons loaded successfully")
