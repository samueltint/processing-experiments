class Ball {
  char character;
  color col;
  float diameter;
  float speed;
  PVector pos, vel;
  int id;

  Ball(char _character, float _diameter, float _speed){
    character = _character;
    diameter = _diameter;
    if(getLetterIndex(character) != -1){
      col = color(map(getLetterIndex(character),0,26,0,360),50,90);
    } else {
      col = color(0, 0, 50);
    }
    pos = new PVector(width/2, 100);
    speed = _speed;
    float dir = random(TWO_PI);
    vel = new PVector(cos(dir) * speed, sin(dir) * speed);
    id = balls.size();
  }
  
  
  void collide() {
    for (int i = id + 1; i < balls.size(); i++) {
      Ball other = balls.get(i);
      PVector diff = PVector.sub(other.pos, this.pos);
      float dist = diff.mag();
      float minDist = other.diameter/2 + this.diameter/2;
  
      if (dist < minDist) {
        float angle = atan2(diff.y, diff.x);
  
        // Calculate target position to resolve overlap
        float targetX = this.pos.x + cos(angle) * minDist;
        float targetY = this.pos.y + sin(angle) * minDist;
        
        float ax = (targetX - other.pos.x);
        float ay = (targetY - other.pos.y);
  
        // Apply force to both balls' velocities
        this.vel.sub(new PVector(ax, ay));
        other.vel.add(new PVector(ax, ay));
      }
    }
  }
  

  
  void update() {
    vel = vel.normalize().mult(speed);
    pos.add(vel.copy());
    if (pos.x + diameter/2 > width) {
      pos.x = width - diameter/2;
      vel.x *= -1;
    }
    else if (pos.x - diameter/2 < 0) {
      pos.x = diameter/2;
      vel.x *= -1;
    }
    if (pos.y + diameter/2 > height) {
      pos.y = height - diameter/2;
      vel.y *= -1;
    } 
    else if (pos.y - diameter/2 < 0) {
      pos.y = diameter/2;
      vel.y *= -1;
    }
  }
  
  void display() {
    fill(col);
    ellipse(pos.x, pos.y, diameter, diameter);
    fill(#000000);
    textSize(25);
    text(character, pos.x, pos.y-10);
  }
}
