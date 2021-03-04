# APC MINI Resolume OSC controller



This Processing (http://processing.org) sketch is a bi directional interface mapping between APC MINI and Resolume, using OSC.

To Use, enable OSC input and Output in Resolume, using ports 7000 and 7001 (swap them if you run into issues)

![APC MINI Resolume mapping Mapping](https://github.com/zambari/APC_MINI_Resolume_OSC/blob/master/apc_mini_resolume/apc_resolume_mapping.png?raw=true)


Each two rows of button representsa layer in resolume, you can click it to start playback, it also synces (highlights) the clip if you click in using a mouse in resolume.

Small round buttons are mapped to scrolling the visible 'window' of clips, so it supports infinite amount of clips per track, even if you use hundereds per track, you can still see a window of 16 clips and you can scroll each of the four sections independently.

TThe very bottom row of the buttons represent triggering forward and backward playback of clips.

Fades are grouped into four secion, with fader one in each section representing opacity, and fader two representing speed of each of the four supported layers


![APC MIni](https://supersound.pl/media/catalog/product/cache/1/image/17f82f742ffe127f42dca9de82fb58b1/A/K/AKAI_APC_MINI_53a46ceb2e985.jpg)


(OSC bundles must be disabled)

Dependencies:
You have to have OscP5 (http://www.sojamo.de/libraries/oscP5/download/oscP5-0.9.8.zip)  and MidiBus (http://www.smallbutdigital.com/projects/themidibus/) installed. Last time I checked there were some incompatibilities in Midibus, if you run into issues, download an older version
Libraries 

This was written back in 2015 and I think resolume might have changed their addressing pattern a little bit, let me know if I need to dig out my APC

Happy Vjing
