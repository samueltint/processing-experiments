/**
 * Non-orthogonal Collision with Multiple Ground Segments 
 * by Ira Greenberg. 
 * 
 * Based on Keith Peter's Solution in
 * Foundation Actionscript Animation: Making Things Move!
 */
import controlP5.*;

ControlP5 cp5;
Orb orb;
float gravity = 0.05;
float background = 0;
float radius = 3;


// The ground is an array of "Ground" objects
int segments = 40;
Ground[] ground = new Ground[segments];

void setup(){
  size(640, 360);
  cp5 = new ControlP5(this);
  
  cp5.addSlider("gravity")
     .setPosition(50,30)
     .setRange(0,1)
     ;
     
  cp5.addSlider("radius")
     .setPosition(50,75)
     .setRange(0,10)
     ;
     
  cp5.addSlider("background")
     .setPosition(50,120)
     .setRange(0,255)
     ;
     
  cp5.addButton("reset")
     .setValue(100)
     .setPosition(500,50)
     .setSize(100,19)
     ;

  // Calculate ground peak heights 
  float[] peakHeights = new float[segments+1];
  for (int i=0; i<peakHeights.length; i++){
    peakHeights[i] = random(height-40, height-30);
  }

  /* Float value required for segment width (segs)
   calculations so the ground spans the entire 
   display window, regardless of segment number. */
  float segs = segments;
  for (int i=0; i<segments; i++){
    ground[i]  = new Ground(width/segs*i, peakHeights[i], width/segs*(i+1), peakHeights[i+1]);
  }
}


void draw(){

  // Background
  noStroke();
  background(background);

  
  // Move and display the orb
  orb.setR(radius);
  orb.move();
  orb.display();
  // Check walls
  orb.checkWallCollision();

  // Check against all the ground segments
  for (int i=0; i<segments; i++){
    orb.checkGroundCollision(ground[i]);
  }

  
  // Draw ground
  fill(127);
  beginShape();
  for (int i=0; i<segments; i++){
    vertex(ground[i].x1, ground[i].y1);
    vertex(ground[i].x2, ground[i].y2);
  }
  vertex(ground[segments-1].x2, height);
  vertex(ground[0].x1, height);
  endShape(CLOSE);


}

void reset() {
  orb = new Orb(50, 50, 3);
}
