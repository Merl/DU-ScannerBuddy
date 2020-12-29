# DU-ScannerBuddy

A simple timer to show running time of territorry scans. Changes light color as indicator and shows running time on screen. 

> As there is no LUA API for territory scanners there is no way to show if a scan error occured. If at any time we get a scanner API it should be simple to integrate.

## How to install
### Prerequisites
1 programingboard, 1 manual switch (switch), 3 manual switches (button), 1 databank, 3 lights, 1 screen

### Linking and installation
1. Link the elements to the bp in the following order:
   - bp -> databank
   - bp -> screen
   - bp -> first button
   - bp -> first light
   - bp -> second button
   - bp -> second light
   - bp -> third button
   - bp -> third light
   - bp -> switch
   - optional: bp <-> second switch (link in both directions) to enable bp and restart it if e.g. distance was to big
2. Copy the content of DU-ScannerBuddy.json to your clipboard. 
3. Right click Programming Board and choose "Paste content from clipboard"

### Bonus: restart bp automatically
Here is what I do to have my bps restart if I lost connection and return in the detection zone.

    dz -> manual switch (switch) -> relais --> manual switch (switch) <--> bp
                 ^                      \
                 |                       \--> delay line
                 |                                  /
                 ----------------------------------/

The dz fires all the time anyone is inside. The first switch is turned on by the dz, then imidiatly turned off again which results in it constantly flipflopping. The second switch turns on the bp. If the bp is turned off because you left its range it will gracefully shutdown and execute the deactivate() method on the second switch.
This still does not help if the bp is stopped because of disconnects though. In that case the second switch must be turned off manualy, the dz flipflop will start it again.

## Roadmap
- add optional HUD element to show remaining scantime
- make the Viz animation something usefull. Ideas are welcome. :)
