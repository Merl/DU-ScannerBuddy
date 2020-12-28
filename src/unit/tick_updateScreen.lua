local svg = {}

for i = 1,#scanner do
    local hours = 0
    local minutes = 0
    local seconds = 0
    local timedisplay = ""
    local percentScanned = 0
    local scanStarted = "--/--/-- --:--:--"
    local scanEnding = "--/--/-- --:--:--"
    local timedisplay = "--"
    local scanTimeLeft = "--"
    local extraStyle = ""
    if state[i] == "scanning" then
        local runningTime = system.getTime() - started[i]
        hours = math.floor(runningTime / 3600) % 60
        minutes = math.floor(runningTime / 60) % 60
        seconds = math.floor(runningTime % 60)
        timedisplay = ""

        if hours > 0 then
            timedisplay = hours .. "h "
        end
        
        if hours > 0 or minutes > 0 then
            timedisplay = timedisplay .. minutes .. "m "
        end
        
        timedisplay = timedisplay .. seconds .. "s"
        
        if runningTime > countTo then
            light[i].setRGBColor(colorFinishedR, colorFinishedG, colorFinishedB)
            state[i] = "finished"
            hours = 0
            minutes = 0
            seconds = 0
            timedisplay = ""
        end
        scanTimeLeft = math.floor(started[i] + countTo - system.getTime()) .. "s"
        percentScanned = math.floor(100 / countTo * runningTime)
        scanStarted = getDate(started[i]) .. " " .. getTime(started[i])
        scanEnding = getDate(started[i] + countTo) .. " " .. getTime(started[i] + countTo)
        
    elseif state[i] == "finished" then
        percentScanned = 100
        scanStarted = getDate(started[i]) .. " " .. getTime(started[i])
        scanEnding = getDate(started[i] + countTo) .. " " .. getTime(started[i] + countTo)
    end   

    --screen.deleteContent(content[i])
    --content[i] = screen.addContent(0,((i - 1) * 10), "<div style=\"font-family:Arial; font-size:10vh; color:rgb(" .. colors[state[i]]["R"] .. "," .. colors[state[i]]["G"] .. "," .. colors[state[i]]["B"] .. ")\">Gebietsscanner #".. i .. " " .. state[i] .. " " .. timedisplay .. "</div>") 

    if i == 3 then
        extraStyle = "margin-left:25vw; margin-right:auto; width:50%"
    end
    svg[i] = getMainSVG(percentScanned, scanStarted, scanEnding, timedisplay, scanTimeLeft, state[i], extraStyle)
end

screen.setHTML(getTable(svg[1], svg[2], svg[3]))


if content["warning"] > 0 then
    if system.getTime() - resettimer > 2 then
        screen.deleteContent(content["warning"])
        content["warning"] = -1
        resettimer = 0
        switch_1.deactivate()
    end
end



