local Players = game:GetService("Players")
local player = Players.LocalPlayer
local defaultSpeed = 10

if player.Character and player.Character:FindFirstChild("Humanoid") then
    player.Character.Humanoid.WalkSpeed = defaultSpeed
end

local function sendSystemMessage(text)
    pcall(function()
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[System] "..text,
            Color = Color3.fromRGB(0, 255, 0),
            Font = Enum.Font.SourceSansBold,
            FontSize = Enum.FontSize.Size18
        })
    end)
end

sendSystemMessage("Type /speed [1-50] in chat to set your speed")

local function onChatted(msg)
    local lower = msg:lower()
    if lower:sub(1,6) == "/speed" then
        local arg = msg:match("/speed%s+(%d+)")
        local speedNum = tonumber(arg)
        if speedNum and speedNum >= 1 and speedNum <= 50 then
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local newSpeed = 10 + ((speedNum - 1) * (50-10)/49)
                player.Character.Humanoid.WalkSpeed = newSpeed
            end
            sendSystemMessage("Speed set to "..speedNum)
        else
            sendSystemMessage("Invalid number! Enter 1-50")
        end
        return true
    end
end

player.Chatted:Connect(function(msg)
    local handled = onChatted(msg)
    if handled then
        local chat = player:FindFirstChild("PlayerGui"):FindFirstChild("Chat")
        if chat then
        end
    end
end)
