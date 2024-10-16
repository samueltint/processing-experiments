class Tree {
  float x, y; 
  float size;  
  color treeColor;  

  Tree() {
    x = random(width * 1.2);
    y = height * 0.65 + random(30);
    size = random(.8, 1.2);
    treeColor = color(random(100,120),random(50,100),random(50,70));
  }

  void update() {
    x -= backgroundSpeed;
    if (x < -150){
      x = width + random(20);
      y = height * 0.7 + random(20);
      size = random(.8, 1.2);
      treeColor = color(random(100,120),random(50,100),random(50,70));
    }
  }

  void display() {
    pushMatrix();
    translate(x, y);
    noStroke();
    scale(size);
    fill(treeColor);
    triangle(0, 20, 40, -100, 80, 20);
    fill(#6C402F);
    rect(30, 20, 20, 20);
    popMatrix();
  }  
}
