getDate = function(unix)
    -- Given unix date, return string date
    local tabIndexOverflow = function(seed, table)
        for i = 1, #table do
            if seed - table[i] <= 0 then
                return i, seed
            end
            seed = seed - table[i]
        end
    end
    local unix =  unix or system.getTime()

    local dayCount = function(yr) return (yr % 4 == 0 and (yr % 100 ~= 0 or yr % 400 == 0)) and 366 or 365 end
    local year, days, month = 2017, math.ceil(unix/86400) + 272
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

function getMainSVG(percentScanned, started, ending, running, timeleft, scannerState, extraStyle)
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
                    style="font-size:8vw; font-size: 100; font-weight: bold; fill: orange; stroke: #dfac20; stroke-width: 1;">]] ..
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
                            M0 67
                            C 273,183
                                822,-40
                                1920.00,106 
    
                            V 359 
                            H 0 
                            V 67
                            Z" transform="matrix(-1 0 0 1 1600 0)">

                        <animate repeatCount="indefinite" fill="#454599" attributeName="d" dur="25s" values="
                                M0 77 
                                C 473,283
                                822,-40
                                1920,116 
    
                                V 359 
                                H 0 
                                V 67 
                                Z; 
    
                                M0 77 
                                C 473,-40
                                1222,283
                                1920,136 
    
                                V 359 
                                H 0 
                                V 67 
                                Z; 
    
                                M0 77 
                                C 973,260
                                1722,-53
                                1920,120 
    
                                V 359 
                                H 0 
                                V 67 
                                Z; 
    
                                M0 77 
                                C 473,283
                                822,-40
                                1920,116 
    
                                V 359 
                                H 0 
                                V 67 
                                Z
                                    ">
                    </path>
                    <path fill="url(#b)" fill-rule="evenodd" d="
                            M0 67
                            C 273,183
                                822,-40
                                1920.00,106 
    
                            V 359 
                            H 0 
                            V 67
                            Z" transform="matrix(-1 0 0 1 1600 0)">
                        <animate repeatCount="indefinite" fill="#454599" attributeName="d" dur="15s" values="
                                    M0 77 
                                    C 473,283
                                    822,-40
                                    1920,116 
    
                                    V 359 
                                    H 0 
                                    V 67 
                                    Z; 
    
                                    M0 77 
                                    C 473,-40
                                    1222,283
                                    1920,136 
    
                                    V 359 
                                    H 0 
                                    V 67 
                                    Z; 
    
                                    M0 77 
                                    C 973,260
                                    1722,-53
                                    1920,120 
    
                                    V 359 
                                    H 0 
                                    V 67 
                                    Z; 
    
                                    M0 77 
                                    C 473,283
                                    822,-40
                                    1920,116 
    
                                    V 359 
                                    H 0 
                                    V 67 
                                    Z
                                        ">
                    </path>
                </svg>
                <rect x="40" y="700" rx="10" ry="10" width="700" height="320"
                    style="fill:none;stroke:#0E2835;stroke-width:10;opacity:1;" />
                <text x="50" y="760" text-anchor="left"
                    style="font-size:8vw; font-size: 60; font-weight: bold; fill: #46C2FF; stroke: #46C2FF; stroke-width: 1;">Scanner
                    status</text>
                <text x="50" y="970" text-anchor="left"
                    style="font-size:8vw; font-size: 140; font-weight: bold; fill: orange; stroke: orange; stroke-width: 1;">]].. scannerState ..[[</text>
            </svg>
]]
end

function getTable(cont1, cont2, cont3)
    return [[
    <table width="100%" height="100%" style="font-family: ArialMT;">
    <tr style="height:50vh">
        <td style="width:50vw; border: 1px none solid; vertical-align:top;">]].. cont1 ..[[</td>
        <td style="width:50vw; border: 1px none solid; vertical-align:top;">]] .. cont2 .. [[</td>
    </tr>
    <tr>
        <td style="width:100vw; border: 1px none solid; vertical-align:top;" colspan="2">]].. cont3 ..[[</td>
    </tr>
</table> ]]
end
