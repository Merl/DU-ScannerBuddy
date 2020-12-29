-- config values
countTo = 900 -- export: Time from start to finish

colorIdleR = 0 -- export: Idle status R
colorIdleG = 255 -- export: Idle status G
colorIdleB = 0 -- export: Idle status B
colorScanningR = 255 -- export: Scanning status R
colorScanningG = 165 -- export: Scanning status G
colorScanningB = 0 -- export: Scanning status B
colorFinishedR = 127 -- export: Finished status R
colorFinishedG = 127 -- export: Finished status G
colorFinishedB = 0 -- export: Finished status B

refreshrate = 1 / 24 --export: Refreshrate, defaults to 1/24 seconds

-- if startup should ever take long enough to display a startup message:
containerStart = [[
<div style="font-family:Arial; font-size:10vh; width:100vw; height:100vh;">
]]
containerStop = [[</div>
]]
local html = containerStart .. "Starting" .. containerStop
screen.setHTML(html)

-- init variables
-- put colors in table for ease of access
colors = {
    ["idle"] = { ["R"] = colorIdleR,
                 ["G"] = colorIdleG,
                 ["B"] = colorIdleB
    },
    ["scanning"] = { ["R"] = colorScanningR,
                     ["G"] = colorScanningG,
                     ["B"] = colorScanningB
    },    
    ["finished"] = { ["R"] = colorFinishedR,
                     ["G"] = colorFinishedG,
                     ["B"] = colorFinishedB
    }
}

-- put elements in tables to be able to iterate
-- @TODO: make this autosearch elements
scanner = {button_1, button_2, button_3}
light = {light_1, light_2, light_3}

-- more globals to track the state
state = {}
content = { -1, -1, -1}
content["warning"] = -1
started = {0, 0, 0}
resettimer = 0

-- animation related variables
-- time each animation layer runs (currently two layers)
aniTime = {15, 25}
-- time past since the animation started
dueTime = {0, 0}
-- the animation pattern.
-- basically this is a partial rewrite of the SVG <animate>-tag to imitate its behavior in DU LUA ticks
pattern = {{
    ["M0"] = "67",
    ["C1"] = {"273", "183"},
    ["C2"] = {"822", "-40"},
    ["C3"] = {"1920", "106"},
    ["V1"] = "359",
    ["H"] = "0",
    ["V2"] = "67"
}, {
    ["M0"] = "77",
    ["C1"] = {"473", "283"},
    ["C2"] = {"822", "-40"},
    ["C3"] = {"1920", "116"},
    ["V1"] = "359",
    ["H"] = "0",
    ["V2"] = "67"
}, {
    ["M0"] = "77",
    ["C1"] = {"473", "-40"},
    ["C2"] = {"1222", "283"},
    ["C3"] = {"1920", "136"},
    ["V1"] = "359",
    ["H"] = "0",
    ["V2"] = "67"
}, {
    ["M0"] = "77",
    ["C1"] = {"973", "260"},
    ["C2"] = {"1722", "-53"},
    ["C3"] = {"1920", "120"},
    ["V1"] = "359",
    ["H"] = "0",
    ["V2"] = "67"
}, {
    ["M0"] = "77",
    ["C1"] = {"473", "283"},
    ["C2"] = {"822", "-40"},
    ["C3"] = {"1920", "116"},
    ["V1"] = "359",
    ["H"] = "0",
    ["V2"] = "67"
}}

-- has bp stopped midscan? if yes recover the state
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

-- change the current state, fired in the button events
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

-- init the animation start time
-- @TODO: at the moment the animation is global and the same for all 3 scanners. 
--        if the animation will be triggered by an event this has to be abstracted to 
--        a unique value per scanner.
aniStartTime = {system.getTime(), system.getTime()}

-- how long is the time between each keyframe per animation layer
-- keyframes are the number of #pattern
timeperKeyframe = {aniTime[1] / #pattern, aniTime[2] / #pattern}

-- make our double trigger button always the same state
switch_1.deactivate()

-- start the show
unit.setTimer("updateScreen", refreshrate)
-- clear the screen for the real content
screen.clear()

