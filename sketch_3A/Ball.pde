class Ball {
  char character;
  color col;
  float diameter;
  PVector pos, vel;
  int id;

  Ball(char _character, float _diameter, float speed){
    character = _character;
    diameter = _diameter;
    col = color(random(360),random(40, 80),random(50, 100));
    pos = new PVector(width/2, 100);
    float dir = random(TWO_PI);
    vel = new PVector(cos(dir) * speed, sin(dir) * speed);
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
        
        // Calculate spring-like response for collision
        //float ax = (targetX - other.pos.x) * spring;
        //float ay = (targetY - other.pos.y) * spring;
        float ax = (targetX - other.pos.x);
        float ay = (targetY - other.pos.y);
  
        // Apply force to both balls' velocities
        this.vel.sub(new PVector(ax, ay));
        other.vel.add(new PVector(ax, ay));
      }
    }
  }
  
  void addForce(Ball ball) {
    PVector diff = PVector.sub(ball.pos, this.pos);
    float dist = diff.mag();
    float forceMag = 0;
    
    if(dist > 0.1) {
      forceMag = G * ball.diameter / (dist * dist);
    }
    
    
    // apply forces
    PVector acc = diff.normalize().mult(forceMag);
    this.vel.add(acc);
  }
  
  void update() {
    vel.y += downwardsG;
    pos.add(vel.copy());
    if (pos.x + diameter/2 > width) {
      pos.x = width - diameter/2;
      vel.x *= friction;
    }
    else if (pos.x - diameter/2 < 0) {
      pos.x = diameter/2;
      vel.x *= friction;
    }
    if (pos.y + diameter/2 > height) {
      pos.y = height - diameter/2;
      vel.y *= friction;
    } 
    else if (pos.y - diameter/2 < 0) {
      pos.y = diameter/2;
      vel.y *= friction;
    }
  }
  
  void display() {
    fill(col);
    ellipse(pos.x, pos.y, diameter, diameter);
  }
}
