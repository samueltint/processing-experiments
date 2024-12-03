float gravityFactor = 100;
float spawnRadius = 50;
float maxParticles =  2000;
float mouseRadius = 20;
int spawnNumber = 0;
Boolean destructionActive = true;
ArrayList<Body> bodies;

void setup() {
  background(#ffffff);
  size(800,800);
  ellipseMode(CENTER);
  colorMode(HSB,360,100,100);
  noStroke();
  
  bodies = new ArrayList<Body>();
  
  //Set custom values for the mouse body
  bodies.add(new MouseBody());
}

void draw() {
  background(#ffffff);
  
  //spawn new particles
  for (int i = 0; i < spawnNumber && bodies.size() < maxParticles; i++) {
    bodies.add(new Body());
  }
  
  // update and display all particles
  for (int i = 0; i < bodies.size(); i++) {
    Body curBody = bodies.get(i);
    if (!(curBody instanceof MouseBody)) {
      
      //add force for each other particle
      for (int j = 0; j < bodies.size(); j++) {
        curBody.addForce(bodies.get(j));
      }
    }
    curBody.update();
    
    //check if the particle should be removed
    if (curBody.isDead()) {
      bodies.remove(i);
    } else {
      curBody.display();
    }
  }
  
  // display number of bodies
  fill(#000000);
  text("Particles spawned per frame: " + spawnNumber , 10, 10);
}

// change the number of new particles every frame with the arrow keys
void keyPressed() {
  if (keyCode == UP) {
    spawnNumber++;
  }  
  if (keyCode == DOWN) {
    spawnNumber--;
  }
}
