/*------------------------------------------------------------
Copyright (c) 2013, friends of Ed (An Apress Company)
All rights reserved.

The code provided here accompanies the book:

Processing: Creative Coding and Generative Art in Processing 2
By Ira Greenberg, Dianna Xu, and Deepak Kumar
friends of Ed (An APress Company), 2013
ISBN-13 978-1430244646
Please refer to the associated README for a full disclaimer.
------------------------------------------------------------*/
// simple_house.pde, chapter 2
// Using Processing's 2D primitives.

void setup() {
  size(650, 600);
  noStroke();
  background(#0ABF26);
  stroke(0);
  fill(#2ADAF7);
  rect(0,0,width, 200);
  fill(100);
  rotate(.6);
  rect(0,280,900, 100);
  rotate(-.6);
  for(int i = 0; i < 10; i++){
    color houseColor = color(random(255),random(255),random(255));
    house(50+ i * 130, 900,.2 * pow(1.1,i), houseColor); 
  }
}

// Simple House
void house(float xTrans, float yTrans, float scale, color houseColor) {
  scale(scale);
  translate(xTrans, yTrans);
  fill(houseColor);
  strokeWeight(3);
  // house
  rect(50, 250, 300, 300);
  // roof
  triangle(50, 250, 350, 250, 200, 50);
  strokeWeight(1);
  // door
  fill(#5A2517);
  rect(175, 450, 50, 100);
  fill(255);
  // door knob
  ellipse(185, 515, 6, 6);
  // left windows
  rect(85, 300, 40, 40);
  rect(130, 300, 40, 40);
  rect(85, 345, 40, 40);
  rect(130, 345, 40, 40);
  // right windows
  rect(230, 300, 40, 40);
  rect(275, 300, 40, 40);
  rect(230, 345, 40, 40);
  rect(275, 345, 40, 40);
  translate(-xTrans, -yTrans);
  scale(1/scale);
}
