elseif cmd:sub(1,6) == "/speed" then
    local arg = inputBox.Text:match("/speed%s+(%d+)")
    local speedNum = tonumber(arg)
    if arg == "off" then
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 20
        end
        printToTerminal("Speed reset to default (20)")
    elseif speedNum and speedNum >= 1 and speedNum <= 100 then
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local newSpeed = 20 + ((speedNum - 1) * (100 - 20)/99)
            player.Character.Humanoid.WalkSpeed = newSpeed
        end
        printToTerminal("Speed set to "..speedNum)
    else
        printToTerminal("Invalid speed! Use /speed 1-100 or /speed off")
    end
