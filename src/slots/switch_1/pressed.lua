-- double trigger button
-- if pressed first time a warning will be printed on screen on top of the content
myHTML = [[
    <div style="font-family:ArialMT; font-size:10vh; color:red; width:80vw; margin-right:10vw; margin-left:10vw; border: 1vh red solid; background-color:white; border-radius: 3vw;">
    WARNING, Pressing the Switch again within 2 Seconds will reset the timer!
    </div>
]]
content["warning"] = screen.addContent(0,((#scanner + 1) * 10), myHTML) 
resettimer = system.getTime()