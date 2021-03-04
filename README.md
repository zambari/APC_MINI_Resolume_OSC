# APC MINI Resolume OSC controller



![APC MIni](https://supersound.pl/media/catalog/product/cache/1/image/17f82f742ffe127f42dca9de82fb58b1/A/K/AKAI_APC_MINI_53a46ceb2e985.jpg)

This Processing (http://processing.org) sketch is a bi directional interface mapping between APC MINI and Resolume, using OSC.

To Use, enable OSC input and Output in Resolume, using ports 7000 and 7001 (swap them if you run into issues)

Each two rows of button representsa layer in resolume, you can click it to start playback, it also synces (highlights) the clip if you click in using a mouse in resolume.

Small round buttons are mapped to scrolling the visible 'window' of clips, so it supports infinite amount of clips per track, even if you use hundereds per track, you can still see a window of 16 clips and you can scroll each of the four sections independently.

TThe very bottom row of the buttons represent triggering forward and backward playback of clips.

Fades are grouped into four secion, with fader one in each section representing opacity, and fader two representing speed.


Main concept of this sketch is to enable vj to trigger an unlimited number of clips, 
so there is no need to swap decks - 


Layer4 clips
 [ a ]|[ a ]|[ a ]|[ a ]|[ a ]|[ a ]|[ a ]|[ a ] 
------|-----|-----|-----|-----|-----|-----|------------
 [ a ]|[ a ]|[ a ]|[ a ]|[ a ]|[ a ]|[ a ]|[ a ] 

Layer3 clips
 [ b ]|[ b ]|[ b ]|[ b ]|[ b ]|[ b ]|[ b ]|[ b ] 
 ------|-----|-----|-----|-----|-----|-----|------------
 [ b ]|[ b ]|[ b ]|[ b ]|[ b ]|[ b ]|[ b ]|[ b ] 

 Layer3 clips
 [ c ]|[ c ]|[ c ]|[ c ]|[ c ]|[ c ]|[ c ]|[ c ] 
 ------|-----|-----|-----|-----|-----|-----|------------
 [ c ]|[ c ]|[ c ]|[ c ]|[ c ]|[ c ]|[ c ]|[ c ] 

 
 Layer1 clips
 [ d ]|[ d ]|[ d ]|[ d ]|[ d ]|[ d ]|[ d ]|[ d ] 
 ------|-----|-----|-----|-----|-----|-----|------------
 [ d ]|[ d ]|[ d ]|[ d ]|[ d ]|[ d ]|[ d ]|[ d ] 

round buttons and sliders
  <<A | A>> | <<B | B>> | <<C | C>> | <<D | D>>
  ------|-----|-----|-----|-----|-----|-----|------------
  REV | FWD | REV | FWD | REV | FWD | REV | FWD

(OSC bundles must be disabled)

Dependencies:
You have to have OscP5 (http://www.sojamo.de/libraries/oscP5/download/oscP5-0.9.8.zip)  and MidiBus (http://www.smallbutdigital.com/projects/themidibus/) installed. Last time I checked there were some incompatibilities in Midibus, if you run into issues, download an older version
Libraries 

