/*
  Classifier Image Viewer - OSC output
  by Sergio Venancio
  Version 1.0b - 2019
  https://github.com/svenancio/classifierimageviewer
  
  This software is free; you can redistribute it and/or
  modify it under the terms of the GNU General Public
  License version 3 as published by the Free Software Foundation.
  
  This software is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  General Public License for more details.
  _______________________
  
  This software was custom made for my Machine Learning workshop.
  It reads 1 classifier output from Wekinator (www.wekinator.org)
  and shows a collection of images.
  
  For instructions, please refer to 
  https://github.com/svenancio/classifierimageviewer
*/

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;

//Variables
float msg;

PFont myFont;
int frameNum = 0;
int duration = 5;
double imgCounter;
int curPos;

String[] filenames;
PImage curImg;

//Main program setup
void setup() {
  fullScreen();
  frameRate(30);
  
  //Initialize OSC communication
  oscP5 = new OscP5(this, 12000); //listen for OSC messages on port 12000 (Wekinator default)
  //dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  
  colorMode(HSB);
  smooth();
  background(255);

  myFont = createFont("Arial", 36);
  imgCounter = -1;
  curPos = 0;
  
  filenames = listFileNames("/img");
  if(filenames == null) {
    println("Cannot find an image folder named 'img'");
    exit();
  }
}

//Main loop
void draw() {
  background(0);
  
  //read the current message from Wekinator and set interface accordingly
  if(msg == 1.0) {
    showText();
  } else if(msg > 1.0) {
    showImageCollection();
  }
}

//This is called automatically when an OSC message is received
void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/wek/outputs")) {
    if(theOscMessage.checkTypetag("f")) {
      msg = theOscMessage.get(0).floatValue();
    } else {
      println("Error: unexpected OSC message Type Tag received by Processing: ");
      theOscMessage.print();
    }
  } else {
    println("Error: unexpected OSC message Address Pattern received by Processing: ");
    theOscMessage.print();
  }
}

//show text on interface
void showText() {
  stroke(0);
  textFont(myFont);
  textAlign(CENTER, TOP); 
  fill(0, 0, 255);

  text("Sorria, uma inteligência artificial está treinando você!", 960, 500);
}

void showImageCollection() {
  if(imgCounter % duration == 0) {
    curImg = null;
    curImg = loadImage("img/"+filenames[curPos]);
    curImg.resize(curImg.width*(1080/curImg.height),1080);
    curPos++;
    if(curPos >= filenames.length) curPos = 0;
  }
  if(curImg != null) {
    image(curImg, width/2 - curImg.width/2, 0);
  }
  imgCounter++;
}

// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(sketchPath()+dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

void keyPressed(){
  if(key == ESC) {
    exit();
  }
}
