-- init variable for screen output
local svg = {}

-- build the SVG per scanner
for i = 1, #scanner do
    -- set defaults to variables
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
    -- if the scanner is running update time display and percent gauge
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
        
        -- if scan time is over set state to finished and set according light color
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
    -- if the scan is finished still display 100%, start and end time
    elseif state[i] == "finished" then
        percentScanned = 100
        scanStarted = getDate(started[i]) .. " " .. getTime(started[i])
        scanEnding = getDate(started[i] + countTo) .. " " .. getTime(started[i] + countTo)
    --nothing to do if state is idle, stay at defaults
    --elseif state[i] == "idle" then
    end

    -- animation related stuff
    -- time each animation layer is currently running
    dueTime = {system.getTime() - aniStartTime[1], system.getTime() - aniStartTime[2]}
    -- if animation layer running time hits the end reset to start (infinite animation loop)
    -- @TODO: make this a for loop
    if dueTime[1] > aniTime[1] then
        aniStartTime[1] = system.getTime()
        dueTime[1] = system.getTime() - aniStartTime[1]
    end
    if dueTime[2] > aniTime[2] then
        aniStartTime[2] = system.getTime()
        dueTime[2] = system.getTime() - aniStartTime[2]
    end

    -- determine which pattern is next (number of keyframes = #pattern)
    local goalFrame = {}
    -- if we devide the already running time of the animation by the time we got per frame and round up we know in which keyframe we are currently
    currentframe = {math.ceil(dueTime[1] / timeperKeyframe[1]), math.ceil(dueTime[2] / timeperKeyframe[2])}
    -- if the next keyframe would exceed the number of patterns restart at pattern 1
    -- @TODO: make this a for loop
    if currentframe[1] >= #pattern then
        goalFrame[1] = 1
    else
        goalFrame[1] = currentframe[1] + 1
    end
    if currentframe[2] >= #pattern then
        goalFrame[2] = 1
    else
        goalFrame[2] = currentframe[2] + 1
    end

    -- print current keyframe number to LUA chat
    -- print("Keyframe for layer 1: " .. currentframe[1] .. "Keyframe for layer 2: " .. currentframe[2])

    -- calculate the values based on the time between keyframes
--     -- example only for one value:
--     -- number of keyframes is the numer of items in pattern
--     keyframes = #pattern
--     -- time per animation layer (aniTime) divided by the number of keyframes gives us the time we got per keyframe
--     timeperKeyframe = aniTime / keyframes
--     -- time each animation layer is currently running (aniStartTime is the system.getTime() of the moment the animation of the layer started)
--     dueTime = system.getTime() - aniStartTime
--     -- our currently active keyframe is the time elapsed in the current frame divided by the overall time we got per keyframe
--     currentframe = math.ceil(dueTime / timeperKeyframe)
--     -- we start with the value from the current keyframe 
--     M0_start = pattern[currentframe].M0
--     -- then we get the value of the next frame, if we exceed number of patterns we go back to 1. by doing so we achieve an infinite animation loop
--     if currentframe >= keyframes then
--         M0_end = pattern[1].M0
--         goalFrame = 1
--     else
--         M0_end = pattern[currentframe + 1].M0
--         goalFrame = currentframe + 1
--     end
--     -- the difference of the next keyframes value and the current frames value equals a 100% animation step
--     M0_diff = M0_end - M0_start
--     -- as we do not make a full step we check where the current frame is between the two keyframes
--     -- we get the time between the two keyframes if we modulo the elapsed time in the animation by the time we got per keyframe
--     M0_diffpercent = 100 / timeperKeyframe * (dueTime % timeperKeyframe)
--     -- now we can calculate the value for the current frame by taking the difference between the two keyframes divided by 100 and multiplying it with the percent
--     M0_step = M0_diff / 100 * M0_diffpercent
--     --finaly add our frame step to the keyframes value
--     M0_goal = M0_start + M0_step

    local target = {{}}
    -- this is just the above with less variables
    -- we have two animation layers so we do this two times
    -- @TODO: Maybe make this loop based on # of a table, allowing for more flexibility and layers?
    for i = 1, 2 do
        target[i] = {
            ["M0"] = pattern[currentframe[i]].M0 + ((pattern[goalFrame[i]].M0 - pattern[currentframe[i]].M0) / 100 *
                (100 / timeperKeyframe[i] * (dueTime[i] % timeperKeyframe[i]))),
            ["C1"] = {pattern[currentframe[i]].C1[1] +
                ((pattern[goalFrame[i]].C1[1] - pattern[currentframe[i]].C1[1]) / 100 *
                    (100 / timeperKeyframe[i] * (dueTime[i] % timeperKeyframe[i]))),
                      pattern[currentframe[i]].C1[2] +
                ((pattern[goalFrame[i]].C1[2] - pattern[currentframe[i]].C1[2]) / 100 *
                    (100 / timeperKeyframe[i] * (dueTime[i] % timeperKeyframe[i])))},
            ["C2"] = {pattern[currentframe[i]].C2[1] +
                ((pattern[goalFrame[i]].C2[1] - pattern[currentframe[i]].C2[1]) / 100 *
                    (100 / timeperKeyframe[i] * (dueTime[i] % timeperKeyframe[i]))),
                      pattern[currentframe[i]].C2[2] +
                ((pattern[goalFrame[i]].C2[2] - pattern[currentframe[i]].C2[2]) / 100 *
                    (100 / timeperKeyframe[i] * (dueTime[i] % timeperKeyframe[i])))},
            ["C3"] = {pattern[currentframe[i]].C3[1] +
                ((pattern[goalFrame[i]].C3[1] - pattern[currentframe[i]].C3[1]) / 100 *
                    (100 / timeperKeyframe[i] * (dueTime[i] % timeperKeyframe[i]))),
                      pattern[currentframe[i]].C3[2] +
                ((pattern[goalFrame[i]].C3[2] - pattern[currentframe[i]].C3[2]) / 100 *
                    (100 / timeperKeyframe[i] * (dueTime[i] % timeperKeyframe[i])))},
            ["V1"] = pattern[currentframe[i]].V1 + ((pattern[goalFrame[i]].V1 - pattern[currentframe[i]].V1) / 100 *
                (100 / timeperKeyframe[i] * (dueTime[i] % timeperKeyframe[i]))),
            ["H"] = pattern[currentframe[i]].H + ((pattern[goalFrame[i]].H - pattern[currentframe[i]].H) / 100 *
                (100 / timeperKeyframe[i] * (dueTime[i] % timeperKeyframe[i]))),
            ["V2"] = pattern[currentframe[i]].V2 + ((pattern[goalFrame[i]].V2 - pattern[currentframe[i]].V2) / 100 *
                (100 / timeperKeyframe[i] * (dueTime[i] % timeperKeyframe[i])))
        }
    end

    -- a workaround needed back when I was using a table to position the SVGs. Not really needed anymore but I leave it here just for the case
    -- extraStyle allows to apply an extra style attribute to the outer SVG that getMainSVG returns
    if i == 3 then
        extraStyle = "margin-left:25vw; margin-right:auto; width:50%"
    end

    -- set screen position for the current SVG
    local x, y = 0
    if i == 2 then
        x = 50
    elseif i == 3 then
        y = 50
    end

    -- delete the previous frame and set new frame
    -- by doing so we can change only parts of the screen and do not have to do a full screenrefresh
    screen.deleteContent(content[i])
    content[i] = screen.addContent(x, y, getMainSVG(percentScanned, scanStarted, scanEnding, timedisplay, scanTimeLeft, state[i], target, extraStyle))
end

-- if the double trigger reset button has been pushed a warnign will be written to the screen
-- if the button has not been pushed again within 2 seconds reset the state of the button and remove the warning
if content["warning"] > 0 then
    if system.getTime() - resettimer > 2 then
        screen.deleteContent(content["warning"])
        content["warning"] = -1
        resettimer = 0
        switch_1.deactivate()
    end
end