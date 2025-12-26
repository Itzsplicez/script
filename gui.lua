local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

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
main.Size = UDim2.new(0, 360, 0, 200)
main.Position = UDim2.new(0.5, -180, 0.5, -100)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

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

local row = Instance.new("Frame")
row.Size = UDim2.new(1,-20,0,50)
row.Position = UDim2.new(0,10,0,70)
row.BackgroundColor3 = Color3.fromRGB(35,35,35)
row.Parent = main
Instance.new("UICorner", row).CornerRadius = UDim.new(0,10)

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,-70,1,0)
label.Position = UDim2.new(0,15,0,0)
label.BackgroundTransparency = 1
label.Text = "InfJump"
label.TextXAlignment = Enum.TextXAlignment.Left
label.Font = Enum.Font.SourceSans
label.TextSize = 20
label.TextColor3 = Color3.new(1,1,1)
label.Parent = row

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,40,0,40)
toggle.Position = UDim2.new(1,-50,0.5,-20)
toggle.Text = "ON"
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 20
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BackgroundColor3 = Color3.fromRGB(128,0,128)
toggle.Parent = row
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,8)

local mini = Instance.new("ImageButton")
mini.Size = UDim2.new(0,50,0,50)
mini.Position = UDim2.new(0,50,0,50)
mini.Image = "https://raw.githubusercontent.com/Itzsplicez/script/main/icon.png"
mini.Visible = false
mini.Parent = gui
Instance.new("UICorner", mini).CornerRadius = UDim.new(0,12)

local infJumpEnabled = false
toggle.MouseButton1Click:Connect(function()
	infJumpEnabled = not infJumpEnabled
	if infJumpEnabled then
		toggle.BackgroundColor3 = Color3.fromRGB(160,0,160)
		jumpModule.Enable()
	else
		toggle.BackgroundColor3 = Color3.fromRGB(128,0,128)
		jumpModule.Disable()
	end
end)

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

local function makeDraggable(frame)
	local dragging, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

makeDraggable(main)
makeDraggable(mini)

print("Milky Way V1 GUI loaded successfully")
