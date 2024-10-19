class Body {
  float mass;
  float radius;
  PVector pos, vel;
  color col;
  float decay;
  
  Body() {
    mass = 0.1;
    pos = new PVector(mouseX + random( -spawnRadius, spawnRadius) ,mouseY + random( -spawnRadius, spawnRadius));
    vel = new PVector(0, 0);
    col = color(random(360),random(40, 80),random(50, 100));
    radius = 2;
    decay = -0.002;
  }
  
  void addForce(Body body) {
    PVector diff = PVector.sub(body.pos, this.pos);
    float dist = diff.mag();
    float forceMag = 0;
    
    if (body instanceof MouseBody) { // pull towards or away from the mouse depending on the distance
      if(dist > mouseRadius) { 
        forceMag =  gravityFactor * body.mass / (dist * dist);
      }
      else if (dist > 0.1) {
        forceMag = -0.001 *  gravityFactor * body.mass / (dist * dist);
      }
    } else { // pull towards other particles
      if(dist > 0.1) {
        forceMag = gravityFactor * body.mass / (dist * dist);
      }
    }
    
    // apply forces
    PVector acc = diff.normalize().mult(forceMag);
    this.vel.add(acc);
  }
  
  void update() {
    pos.add(vel.copy());
    // make the particle smaller and less heavy over time
    mass += decay;
    radius += decay;
  }
  
  void display() {
    fill(col);
    ellipse(pos.x, pos.y, radius * 2, radius * 2);
  }
  
  // the particle is dead if it is off screen or if has fully decayed
  Boolean isDead() {
    return pos.x < 0  || pos.x > width || pos.y < 0 || pos.y > height || mass < 0;
  }
}

// the mouse has it's own class as it behaves differently
class MouseBody extends Body {
  MouseBody() {
    mass = 10;
    pos = new PVector(mouseX, mouseY);
    vel = new PVector(0, 0);
    col = color(0,0,90);
    radius = mouseRadius;
  }
  
  void update() {
    pos = new PVector(mouseX, mouseY);
  }
  
  void addForce() {
    return;
  }
}
