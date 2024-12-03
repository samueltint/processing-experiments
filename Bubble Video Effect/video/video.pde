import processing.video.*;   
import controlP5.*;

ControlP5 cp5;
Capture vid;                  //Capture object for our video
int dotCount = 2000;
int minSize = 10;
int maxSize = 50;

void setup() {
  size(640, 480);
  ellipseMode(CENTER);
  noStroke();
  cp5 = new ControlP5(this);
  cp5.addSlider("dotCount")
     .setPosition(30, 30)
     .setRange(0, 5000)
     .setSize(300,40)
     ;
     
  vid = new Capture(this, width, height); 
  vid.start();
  
}

void draw() {
  background(255);
  if (vid.available()) {  
    vid.read();            
  }
  for (int i = 0; i < dotCount; i++) {
    int x = (int)random(width);
    int y = (int)random(height);
    fill(vid.pixels[(y*width) + x]);
    float size = random(minSize, maxSize);
    ellipse(x, y, size, size);
  }
}
