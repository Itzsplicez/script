elseif cmd:sub(1,6) == "/speed" then
    local arg = inputBox.Text:match("/speed%s+(%d+)")
    local speedNum = tonumber(arg)
    if speedNum and speedNum >= 1 and speedNum <= 100 then
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local newSpeed = speedNum -- directly use the number for WalkSpeed
            player.Character.Humanoid.WalkSpeed = newSpeed
        end
        printToTerminal("Speed set to "..speedNum)
    else
        printToTerminal("Invalid speed! Use /speed 1-100")
    end
