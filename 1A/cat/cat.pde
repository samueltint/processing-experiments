//multiplier for the length of the tail
float tailLength = .4;
//multiplier for the body width
float chonkiness = 1.5;

color bodyColour = #F5C43E;
color bodyAccent = lerpColor(bodyColour, color(0,0,0), .1);

void setup() {
  scale(2);
  size(800,800);
  ellipseMode(CENTER);
  
  //background
  background(#F0E679);
  fill(0,160,200);
  ellipse(200,300,300,170);
  fill(bodyColour);
  
  foot(110,230 + 30 * chonkiness);
  foot(210,230 + 30 * chonkiness);
  
  //tail
  strokeWeight(30);
  stroke(bodyAccent);
  beginShape();
  curveVertex(230,200);
  curveVertex(280,200);
  curveVertex(330,150 - 50 * tailLength);
  curveVertex(330,100 - 100 * tailLength); 
  endShape();
  stroke(0);
  strokeWeight(1);
  
  // body
  ellipse(200, 230, 220,160 * chonkiness);
  
  foot(150,230 + 40 * chonkiness);
  foot(250,230 + 35 * chonkiness);
  
  
  ear(60,85,-.5);
  ear(190,60,.5);
  
  // head
  beginShape();
  curveVertex(70,200);
  curveVertex(100,110);
  curveVertex(200,110);
  curveVertex(230,200);
  curveVertex(150,240);
  curveVertex(70,200);
  curveVertex(100,110);
  curveVertex(200,110); 
  endShape();
  
  eye(120,170);
  eye(180,170);
  
  fill(0);
  triangle(150,205,155,200,145,200);
  fill(255);
  
  
}

void foot(float xTrans, float yTrans) {
  translate(xTrans, yTrans);
  fill(bodyAccent);
  beginShape();
  curveVertex(25,0);
  curveVertex(50,0);
  curveVertex(40,50);
  curveVertex(10,50);
  curveVertex(0,0);
  curveVertex(25,0);
  endShape();
  fill(bodyColour);
  translate(-xTrans, -yTrans);
}

void whiser(int xTrans, int yTrans, float angle) {
  translate(xTrans, yTrans);
  rotate(angle);
  beginShape();
  curveVertex(25,0);
  curveVertex(50,0);
  curveVertex(40,50);
  curveVertex(10,50);
  curveVertex(0,0);
  curveVertex(25,0);
  endShape();
  rotate(-angle);
  translate(-xTrans, -yTrans);
}

void ear(float xTrans, float yTrans, float angle) {
  translate(xTrans, yTrans);
  rotate(angle);
  triangle(30,0,0,50,60,50);
  fill(#FFBFE9);
  triangle(30,10,10,50,50,50);
  fill(bodyColour);
  rotate(-angle);
  translate(-xTrans, -yTrans);
}

void eye(float xTrans, float yTrans) {
  translate(xTrans, yTrans);
  fill(0);
  ellipse(0,0,30,40);
  fill(255);
  ellipse(-3,-6,21,21);
  ellipse(5,9,12,12);
  translate(-xTrans, -yTrans);
}
