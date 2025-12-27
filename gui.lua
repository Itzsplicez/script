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
            local speed = tonumber(arg) or 500
            if speed < 1 then speed = 1 end
            if speed > 500 then speed = 500 end
            spinModule.Start(speed)
            printToTerminal("Spinning enabled at speed "..speed)
        end
    end
