/* (cc) 2015 zambari  v.0.1 */
// 7000 is the  osc out port 
// 7001 is the  osc in port
// use http://processing.org to run this script
// you will need OscP5 and MidiBus libraries

// main concept of this sketch is to enable vj to trigger an unlimited number of clips, 
// so there is no need to swap decks - 

// the code maps APC mini as follows
// [ a ][ a ][ a ][ a ][ a ][ a ][ a ][ a ] (as1)
// [ a ][ a ][ a ][ a ][ a ][ a ][ a ][ a ] (as2)
// [ b ][ b ][ b ][ b ][ b ][ b ][ b ][ b ] (bs1)
// [ b ][ b ][ b ][ b ][ b ][ b ][ b ][ b ] (bs2)
// [ c ][ c ][ c ][ c ][ c ][ c ][ c ][ c ] (cs1)
// [ c ][ c ][ c ][ c ][ c ][ c ][ c ][ c ] (cs2)
// [ d ][ d ][ d ][ d ][ d ][ d ][ d ][ d ] (ds1)
// [ d ][ d ][ d ][ d ][ d ][ d ][ d ][ d ] (ds2)
//  ad1  ad2  bd1  bd2  cd1  cd2  dd1  dd2  (function butons)
//  af1  bf1  cf1  df1  af2  bf2  cf2  df2  mf (faders)

// The whole controller is split into four sections, controlling four first layers within Resolume
// the layout is explained using letters above - all the controls starting with 'a' control first (fourth?)
// layer in resolume, 'b', 'c', and 'd' control the others
// buttons on the right (*s1 and *s2) scroll the current 'window' of 16 clips available for triggering left
// and right. This is not reflected in resolume's display, but if a currently playing clip is within the
// 16 clip window it will be highlighted
// function buttons on the bottom control the direction of playing clip, enabling instant reverse
// faders control each layer's opacity and speed.
// master fader controls resolume master output
// direction change works on clips without audio

// mappings can be adjusted by editing the code
// the program has no clickable interface
// disable bundles in resolume interface!

// bugfixes and feedback welcome : zambari@gmail.com

//changelist
//0.1.1 - master fader now mapped to resolume master output fader rather than crossfader

int oscOutPort=7000;                // set to Resolume OSC In port !
int oscInPort=7001;                 // set to Resolume OSC Out port !
String remoteAddress="127.0.0.1";  // replace with remote address if not on the same machine


import themidibus.*; 
int debug=1;
MidiBus apcBus; 


 
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;
int[] layerOffset;
int[] currentClip;
int[] layerDirections;
int[] needupdate;

   void setup() {
       //0 blank
       //1 green
       //2 green flash
       //3 red
       //4 red flash
       //5 yellow
       //6 yellow flash

    layerOffset=new int[4];
    currentClip=new int[4];
    layerDirections=new int[4];
    needupdate=new int[4];

    size(250,330);
    oscP5 = new OscP5(this,oscInPort);
    myRemoteLocation = new NetAddress(remoteAddress,oscOutPort);

    background(0);
       apcBus=new MidiBus(this,"APC MINI","APC MINI");
    if (apcBus.attachedInputs().length==0)
       { println(" NO APC !!!!  ABORT ABORT");
          die("ABORT ABORT");
       }
    println("@@@ READY  ");

for (int i=0;i<64;i++)  // intro animation
  { apcBus.sendNoteOn(0,i+1,3);
    apcBus.sendNoteOn(0,i+1,5);
    apcBus.sendNoteOn(0,i,123);
    delay(10);
  }  
  
   updateViewOnLayer(2);
   updateViewOnLayer(1);
   updateViewOnLayer(0);
   updateViewOnLayer(3);
}

boolean clrScrl=false;
int lastMillis;
void draw()
{
       if (millis()-lastMillis>1000)
        { lastMillis=millis();
        fill (random(250));
          rect(10,10,10,10);  
        }
        for (int i=0;i<4;i++)
        
       {
        if (needupdate[i]==1) 
          
          {
            updateViewOnLayer(i);
            needupdate[i]=0;
            
          }
         
       }
        
}

void noteOn(int channel, int pitch, int velocity) {
    if (pitch<64)   // button on the main grid pressed
      {
        int l=(pitch/16);
        int c=(pitch%16)+layerOffset[l]+1;
        String addr="/layer"+(l+1)+"/clip"+c+"/connect";
       
       println("SENDING "+addr);
         OscMessage myMessage = new OscMessage(addr);
                        myMessage.add(1); 
                        oscP5.send(myMessage, myRemoteLocation); 
      }
      
      
  if ((pitch>=82)&&(pitch<=89)) { 
 
  int dir=1;
  int lay=0;
  if (pitch==82) { lay=3; dir=1;}
  if (pitch==83) { lay=3; dir=0;}
  if (pitch==84) { lay=2; dir=1;}
  if (pitch==85) { lay=2; dir=0;}
  if (pitch==86) { lay=1; dir=1;}
  if (pitch==87) { lay=1; dir=0;}
  if (pitch==88) { lay=0; dir=1;}
  if (pitch==89) { lay=0; dir=0;}
  
     if (dir==1)
     {
       layerOffset[lay]++;
       
     }
     if (dir==0)
     {
       layerOffset[lay]--;
       if (layerOffset[lay]<0) layerOffset[lay]=0;
      }
      //updateViewOnLayer(lay);
      needupdate[lay]=1;
      println(layerOffset);
    }
     
      
  if ((pitch>=64)&&(pitch<=71)) {
  int dir=1;
  int lay=0;
  if (pitch==64) { lay=0; dir=0;}
  if (pitch==65) { lay=0; dir=1;}
  if (pitch==66) { lay=1; dir=0;}
  if (pitch==67) { lay=1; dir=1;}
  if (pitch==68) { lay=2; dir=0;}
  if (pitch==69) { lay=2; dir=1;}
  if (pitch==70) { lay=3; dir=0;}
  if (pitch==71) { lay=3; dir=1;}
    
        String addr="/layer"+(lay+1)+"/video/position/direction";
       
if (debug==1)
     println("SENDING "+addr+" "+dir);
         OscMessage myMessage = new OscMessage(addr);
                        myMessage.add(dir); 
                        oscP5.send(myMessage, myRemoteLocation); 
      addr="/layer"+(lay+1)+"/audio/position/direction";   // to catch clips with audio too
                        myMessage = new OscMessage(addr);
                        myMessage.add(dir); 
                        oscP5.send(myMessage, myRemoteLocation); 
       

}
 
      
    if (debug==1)
    println(" MIDI Note IN "+pitch+" "+velocity);
   
}




void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange

  if ((number>=48)&&(number<=51))
  {
     int layer=number-48+1;
        OscMessage myMessage = new OscMessage("/layer"+layer+"/video/opacity/values");
        myMessage.add(constrain(map(value,4,123,0,127),0,127)/127.0); 
        oscP5.send(myMessage, myRemoteLocation); 
    
  }
  if ((number>=52)&&(number<=55))
  {
    
    int layer=number-52+1;
    
        OscMessage myMessage = new OscMessage("/layer"+layer+"/video/position/speed");
        myMessage.add(value/127.0); 
        oscP5.send(myMessage, myRemoteLocation); 
      
    }
  if (number==56)
  {
   
      OscMessage myMessage = new OscMessage("/composition/opacityandvolume");
                        myMessage.add(value/127.0); 
                        oscP5.send(myMessage, myRemoteLocation); 
                       
  }
  
}
      


void updateViewOnLayer(int layer)
{

  int odd=0;
  if (layer%2==1) odd=1;
    for (int i=layer*16;i<(layer+1)*16;i++)
          {
            
                 apcBus.sendNoteOn(0,i,odd);
    
           }
          int led=currentClip[layer]-layerOffset[layer];
          if ((led>=0)&&(led<16))
           if (odd==1)
               apcBus.sendNoteOn(0,layer*16+led,3);
            else 
               apcBus.sendNoteOn(0,layer*16+led,5);
            
  
  
      apcBus.sendNoteOn(0,89-layer*2-1,1); 
     if (layerOffset[layer]>0)
       apcBus.sendNoteOn(0,89-layer*2,1); else
       apcBus.sendNoteOn(0,89-layer*2,0);
               
  if (layerDirections[layer]==0)
        {
          apcBus.sendNoteOn(0,64+layer*2,0);
          apcBus.sendNoteOn(0,64+layer*2+1,1);  
      } else
      {
          apcBus.sendNoteOn(0,64+layer*2,1);
          apcBus.sendNoteOn(0,64+layer*2+1,0);  
      
      } 


}


void oscEvent(OscMessage theOscMessage) {
  
 //  if (debug==1)
 // println (theOscMessage.addrPattern()+"   "+theOscMessage.typetag());
 // if ((theOscMessage.addrPattern().indexOf("layer")>0)&&
 
  
  if ((theOscMessage.addrPattern().indexOf("connect")>0)
      &&(theOscMessage.get(0).intValue()==1))
  {
    
      String[]parts=split(theOscMessage.addrPattern(),"/");
       if (parts.length>3)
      {
        
        if ((parts[1].indexOf("layer")==0)&&
            (parts[2].indexOf("clip")==0)&&
            (parts[3].indexOf("connect")==0))
          {
          
          int layer=Integer.parseInt(parts[1].substring(5));
          int clip= Integer.parseInt(parts[2].substring(4));
           if (layer<=3) {
             
             currentClip[layer-1]=clip-1;
             //updateViewOnLayer(layer);
           needupdate[layer]=1;  
         }
        }
      }
   }
  
  
  if ((theOscMessage.addrPattern().indexOf("direction")>0))
   {
      String[]parts=split(theOscMessage.addrPattern(),"/");
       if (parts.length>3)
      { 
        if ((parts[1].indexOf("layer")==0))
          {   
          int layer=Integer.parseInt(parts[1].substring(5))-1;     
          layerDirections[layer]=1-theOscMessage.get(0).intValue();
          //updateViewOnLayer(layer);
          needupdate[layer]=1;  
      }
     }
   }
  
  
}
