-- status counter
countTo = 900 --export: Time from start to finish

colorIdleR = 0    	 --export: Idle status R
colorIdleG = 255  	 --export: Idle status G
colorIdleB = 0        --export: Idle status B
colorScanningR = 255  --export: Scanning status R
colorScanningG = 127  --export: Scanning status G
colorScanningB = 0    --export: Scanning status B
colorFinishedR = 127  --export: Finished status R
colorFinishedG = 127  --export: Finished status G
colorFinishedB = 0    --export: Finished status B


colors = { }
colors["idle"] = {}
colors["scanning"] = {}
colors["finished"] = {}
colors["idle"]["R"] = colorIdleR
colors["idle"]["G"] = colorIdleG
colors["idle"]["B"] = colorIdleB
colors["scanning"]["R"] = colorScanningR
colors["scanning"]["G"] = colorScanningG
colors["scanning"]["B"] = colorScanningB
colors["finished"]["R"] = colorFinishedR
colors["finished"]["G"] = colorFinishedG
colors["finished"]["B"] = colorFinishedB

scanner = { button_1, button_2, button_3 }
state = { }
light = { light_1, light_2, light_3 }
content = { }
content["warning"] = -1
started = { 0, 0, 0 }
contentID = 0
resettimer = 0

screen.clear()
switch_1.deactivate()

for i = 1, #scanner do
    started[i] = dbScan.getFloatValue("scanner_" .. i .. "_status")
    if started[i] > 0 then
        state[i] = "scanning"
        light[i].setRGBColor(colors["scanning"]["R"], colors["scanning"]["G"], colors["scanning"]["B"]) 
    else
        state[i] = "idle"
        light[i].setRGBColor(colorIdleR, colorIdleG, colorIdleB)
    end
end

function changeState(pressedButton)
    if state[pressedButton] == "idle" then
        started[pressedButton] = system.getTime()
        dbScan.setFloatValue("scanner_" .. pressedButton .. "_status", started[pressedButton])
        light[pressedButton].setRGBColor(colors["scanning"]["R"], colors["scanning"]["G"], colors["scanning"]["B"])
        state[pressedButton] = "scanning"
    elseif state[pressedButton] == "finished" then
        dbScan.setFloatValue("scanner_" .. pressedButton .. "_status", 0)
        light[pressedButton].setRGBColor(colorIdleR, colorIdleG, colorIdleB)  
        state[pressedButton] = "idle"
    elseif state[pressedButton] == "scanning" then
        light[pressedButton].setRGBColor(colors["finished"]["R"], colors["finished"]["G"], colors["finished"]["B"])  
        state[pressedButton] = "finished"
    end
end

containerStart = [[
<div style="font-family:Arial; font-size:10vh; width:100vw; height:100vh;">
]]
containerStop = [[</div>
]]

local html = containerStart .. "Starting" .. containerStop
screen.setHTML(html)
unit.setTimer("updateScreen", 1)
screen.clear()

