void setup() {
  size(400,400);
  background(100);
  ellipseMode(CENTER);
  fill(255);
  
  // feet
  beginShape();
  curveVertex(140,330);
  curveVertex(130,270);
  curveVertex(180,270);
  curveVertex(170,330);
  curveVertex(140,330);
  curveVertex(130,270);
  curveVertex(180,270);
  endShape();
  
  // body
  ellipse(200, 230, 220,160);
  
  // head
  beginShape();
  curveVertex(70,200);
  curveVertex(100,100);
  curveVertex(200,100);
  curveVertex(230,200);
  curveVertex(150,240);
  curveVertex(70,200);
  curveVertex(100,100);
  curveVertex(200,100); 
  endShape();
}
