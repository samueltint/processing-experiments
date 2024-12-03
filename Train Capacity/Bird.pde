class Bird {
  float x, y; 
  float size;
  float speed;
  float angle;  
  boolean isIndependent; 

  Bird() {
    x = random(width, width * 2); 
    y = random(20, height / 2.5);  
    size = random(0.3, 0.4);  
    speed = random(2, 4);  
    angle = radians(random(-10, 10));  
  }

  void update() {
    if(!pause){
        x -= speed; 
    }
    if (x < -width) {
      x = width + random(100);  
      y = random(height / 2);  
      size = random(0.3, 0.4);  
      angle = radians(random(-10, 10));  
    }
  }

  void display() {
    pushMatrix();
    translate(x, y);
    scale(size);
    rotate(angle);  
    stroke(0);
    strokeWeight(2);
    noFill();
    arc(0, 0, 30, 15, PI, TWO_PI);
    arc(30, 0, 30, 15, PI, TWO_PI); 
    popMatrix();
  }
}
