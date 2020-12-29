-- time and date functions to calculate the current time based on DUs epoch variant
-- DU time starts at 30.09.2017 00:00:00 
-- remember DU time is determined by the client and localized. no universal DU time :/
-- @src: https://scriptinghelpers.org/questions/25121/how-do-you-get-the-date-and-time-from-unix-epoch-time#28674
getDate = function(duepoch)
    -- Given DU date, return string date
    local tabIndexOverflow = function(seed, table)
        for i = 1, #table do
            if seed - table[i] <= 0 then
                return i, seed
            end
            seed = seed - table[i]
        end
    end
    local duepoch =  duepoch or system.getTime()

    local dayCount = function(yr) return (yr % 4 == 0 and (yr % 100 ~= 0 or yr % 400 == 0)) and 366 or 365 end
    -- for unix time this is 1970/01/01 00:00:00
    -- in DU it is 2017/09/30 00:00:00
    local year, days, month = 2017, math.ceil(duepoch/86400) + 272
    while days >= dayCount(year) do days = days - dayCount(year) year = year + 1 end -- Calculate year and days into that year

    month, days = tabIndexOverflow(days, {31,(dayCount(year) == 366 and 29 or 28),31,30,31,30,31,31,30,31,30,31}) 

    return string.format("%d/%d/%d", month, days, year)
end

getTime = function(seconds)
    local seconds = seconds or system.getTime()
    local hours = math.floor(seconds / 3600 % 24)
    hours = hours > 12 and hours - 12 or hours == 0 and 12 or hours
    return string.format("%d:%d:%d %s", hours, math.floor(seconds / 60 % 60), math.floor(seconds % 60), hours > 12 and "pm" or "am")
end

-- function to get the SVG, does nothing but returning the SVG with passed variables
function getMainSVG(percentScanned, started, ending, running, timeleft, scannerState, target, extraStyle)
    return [[
<svg class="scanner-progress" style="background-color:none; font-family: monospace; ]].. extraStyle ..[["
                width="50%" height="50%" viewBox="0 0 1920 1080" preserveAspectRatio="xMaxYMin meet">
                <rect x="20" y="20" rx="20" ry="20" width="1870" height="1100"
                    style="fill:none;stroke:#0E2835;stroke-width:20;opacity:1" />
                <!--circle class="s1_progress" style="transform-origin: 392px 365px; stroke-dasharray: 1633.6282px 1633.6282px; stroke-dashoffset:555.4336;" stroke="#46C2FF" stroke-width="60" stroke-opacity="1" fill="transparent"
                    r="260" cx="390" cy="360" /-->
                <svg viewBox="0 0 36 36" x=100 y=-180 width="580">
                  <path
                    d="M18 2.0845
                      a 15.9155 15.9155 0 0 1 0 31.831
                      a 15.9155 15.9155 0 0 1 0 -31.831"
                    fill="none"
                    stroke="#46C2FF";
                    stroke-width="3.2";
                    stroke-dasharray="]] .. percentScanned .. [[, 100"
                  />
                </svg>
                
                
                <circle class="s1_progress" stroke="#0E2835" stroke-width="10" stroke-opacity="1" fill="transparent"
                    r="285" cx="390" cy="360" />
                <circle class="s1_progress" stroke="#0E2835" stroke-width="10" stroke-opacity="1" fill="transparent"
                    r="235" cx="390" cy="360" />



                <text x="400" y="395" text-anchor="middle"
                    style="font-size:8vw; font-size: 100; font-weight: bold; fill:rgb(]] .. colors[scannerState].R .. [[,]] .. colors[scannerState].G .. [[,]] .. colors[scannerState].B .. [[); stroke:rgb(]] .. colors[scannerState].R .. [[,]] .. colors[scannerState].G .. [[,]] .. colors[scannerState].B .. [[); stroke-width: 1;">]] ..
               percentScanned .. [[%</text>
                <rect x="760" y="40" rx="10" ry="10" width="1110" height="470"
                    style="fill:none;stroke:#0E2835;stroke-width:10;opacity:1;">

                </rect>

                <text x="770" y="110" text-anchor="left"
                    style="font-size: 60; font-weight: bold; fill: #46C2FF; stroke: #46C2FF; stroke-width: 1;">Detail</text>

                <text x="770" y="180" text-anchor="left"
                    style="font-size: 45; font-weight: bold; fill: #ffffff; stroke: #ffffff; stroke-width: 1;">Start:
                </text>
                <text x="1100" y="180" text-anchor="left"
                    style="font-size: 45; font-weight: bold; fill: #ffffff; stroke: #ffffff; stroke-width: 1;">]] ..
               started .. [[</text>

                <text x="770" y="230" text-anchor="left"
                    style="font-size: 45; font-weight: bold; fill: #ffffff; stroke: #ffffff; stroke-width: 1;">End:
                </text>
                <text x="1100" y="230" text-anchor="left"
                    style="font-size: 45; font-weight: bold; fill: #ffffff; stroke: #ffffff; stroke-width: 1;">]] ..
               ending .. [[</text>

                <text x="770" y="280" text-anchor="left"
                    style="font-size: 45; font-weight: bold; fill: #ffffff; stroke: #ffffff; stroke-width: 1;">Running:
                </text>
                <text x="1100" y="280" text-anchor="left"
                    style="font-size: 45; font-weight: bold; fill: #ffffff; stroke: #ffffff; stroke-width: 1;">]] ..
               running .. [[</text>

                <text x="770" y="330" text-anchor="left"
                    style="font-size: 45; font-weight: bold; fill: #ffffff; stroke: #ffffff; stroke-width: 1;">Time
                    left: </text>
                <text x="1100" y="330" text-anchor="left"
                    style="font-size: 45; font-weight: bold; fill: #ffffff; stroke: #ffffff; stroke-width: 1;">]] ..
               timeleft .. [[</text>

                <rect x="760" y="530" rx="10" ry="10" width="1110" height="490"
                    style="fill:none;stroke:#0E2835;stroke-width:10;opacity:1;" />
                <text x="770" y="590" text-anchor="left"
                    style="font-size:8vw; font-size: 60; font-weight: bold; fill: #46C2FF; stroke: #46C2FF; stroke-width: 1;">Vis</text>
                <svg x=765 y=660 width=1100>
                    <defs>
                        <linearGradient id="a" x1="50%" x2="50%" y1="-10.959%" y2="100%">
                            <stop stop-color="#57BBC1" stop-opacity=".75" offset="0%" />
                            <stop stop-color="#015871" offset="100%" />
                        </linearGradient>
                        <linearGradient id="b" x1="50%" x2="50%" y1="-10.959%" y2="100%">
                            <stop stop-color="#11FFC1" stop-opacity=".25" offset="0%" />
                            <stop stop-color="#7aFF71" offset="100%" />
                        </linearGradient>
                    </defs>
                    <path fill="url(#a)" fill-rule="evenodd" d="
                    M0 ]] .. target[1].M0 .. [[
                    C  ]] .. target[1].C1[1] .. [[,]] .. target[1].C1[2] .. [[
                       ]] .. target[1].C2[1] .. [[,]] .. target[1].C2[2] .. [[
                       ]] .. target[1].C3[1] .. [[,]] .. target[1].C3[2] .. [[
     
                    V  ]] .. target[1].V1 .. [[ 
                    H  ]] .. target[1].H .. [[ 
                    V  ]] .. target[1].V2 .. [[
                    Z" transform="matrix(-1 0 0 1 1600 0)">
           
                    </path>
                    <path fill="url(#b)" fill-rule="evenodd" d="
                            M0 ]] .. target[2].M0 .. [[
                            C  ]] .. target[2].C1[1] .. [[,]] .. target[2].C1[2] .. [[
                            ]] .. target[2].C2[1] .. [[,]] .. target[2].C2[2] .. [[
                            ]] .. target[2].C3[1] .. [[,]] .. target[2].C3[2] .. [[
            
                            V  ]] .. target[2].V1 .. [[ 
                            H  ]] .. target[2].H .. [[ 
                            V  ]] .. target[2].V2 .. [[
                            Z" transform="matrix(-1 0 0 1 1600 0)">
                        
                    </path>
                </svg>
                <rect x="40" y="700" rx="10" ry="10" width="700" height="320"
                    style="fill:none;stroke:#0E2835;stroke-width:10;opacity:1;" />
                <text x="50" y="760" text-anchor="left"
                    style="font-size:8vw; font-size: 60; font-weight: bold; fill: #46C2FF; stroke: #46C2FF; stroke-width: 1;">Scanner
                    status</text>
                <text x="50" y="970" text-anchor="left"
                    style="font-size:8vw; font-size: 140; font-weight: bold; fill:rgb(]] .. colors[scannerState].R .. [[,]] .. colors[scannerState].G .. [[,]] .. colors[scannerState].B .. [[); stroke:rgb(]] .. colors[scannerState].R .. [[,]] .. colors[scannerState].G .. [[,]] .. colors[scannerState].B .. [[); stroke-width: 1;">]].. scannerState ..[[</text>
            </svg>
]]
end
