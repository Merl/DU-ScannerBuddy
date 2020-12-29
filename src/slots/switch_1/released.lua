-- double trigger button
-- if pressed a second time within two seconds all scanner staes will be resetted
if resettimer > 0 and system.getTime() - resettimer < 2 then
    for i=1, #scanner do
        if state[i] ~= "idle" then
            light[i].setRGBColor(colors["idle"]["R"], colors["idle"]["G"], colors["idle"]["B"])  
            state[i] = "idle"
            dbScan.setFloatValue("scanner_" .. i .. "_status", 0)
        end
    end
end