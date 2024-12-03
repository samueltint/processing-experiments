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
      col = color(map(getLetterIndex(character), 0, 26, 0, 360), 30, 90);
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
    // loop through all other balls to check colission, only check balls with a higher id to reduce repeated calculations
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
    // make sure speed is fixed to the initial value 
    vel = vel.normalize().mult(speed);
    pos.add(vel.copy());
    
    //check walls
    if (pos.x + diameter/2 > width - padding) {
      pos.x = width - padding - diameter/2;
      vel.x = -vel.x;
    }
    else if (pos.x - diameter/2 < padding) {
      pos.x = padding + diameter/2;
      vel.x = -vel.x;
    }
    if (pos.y + diameter/2 > height - padding) {
      pos.y = height - padding - diameter/2;
      vel.y = -vel.y;
    } 
    else if (pos.y - diameter/2 < padding) {
      pos.y = padding + diameter/2;
      vel.y = -vel.y;
    }
  }
  
  void display() {
    noStroke();
    fill(col);
    ellipse(pos.x, pos.y, diameter, diameter);
    fill(0);
    textSize(15);
    textAlign(CENTER);
    text(character, pos.x, pos.y+5);
  }
}
