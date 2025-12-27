local speedNum = tonumber(arg)
if speedNum and speedNum >= 1 and speedNum <= 100 then
if player.Character and player.Character:FindFirstChild("Humanoid") then
            local newSpeed = 20 + ((speedNum - 1) * (100 - 20)/99)
            local newSpeed = speedNum -- directly use the number for WalkSpeed
player.Character.Humanoid.WalkSpeed = newSpeed
end
printToTerminal("Speed set to "..speedNum)
