-- double trigger button
-- if pressed first time a warning will be printed on screen on top of the content
content["warning"] = screen.addContent(0,((#scanner + 1) * 10), "<div style=\"font-family:ArialMT; font-size:10vh; color:red;\">WARNING, Pressing the Switch again within 2 Seconds will reset the timer!</div>") 
resettimer = system.getTime()