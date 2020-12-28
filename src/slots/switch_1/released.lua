local print = system.print
print("resettimer: " .. resettimer .. "system.getTime() - resettimer" .. system.getTime() - resettimer )
if resettimer > 0 and system.getTime() - resettimer < 2 then
    print("resetting")
    for i=1, #scanner do
        if state[i] ~= "idle" then
            light[i].setRGBColor(colors["idle"]["R"], colors["idle"]["G"], colors["idle"]["B"])  
            state[i] = "idle"
            dbScan.setFloatValue("scanner_" .. i .. "_status", 0)
        end
    end
end