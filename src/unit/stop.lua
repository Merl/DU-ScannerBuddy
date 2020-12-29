-- show an off message
screen.setCenteredText("Scannermonitor not running")
-- deactivate the button the bp is turned on with (doublesided link)
-- this is part of a setup involing a dedection zone and logical operators to keep the board running

--[[

dz -> manual switch (permanent) -> relais --> manual switch (permanent) <--> bp
                 ^                      \
                 |                       \--> delay line
                 |                                  /
                 ----------------------------------/

]]
button.deactivate()

