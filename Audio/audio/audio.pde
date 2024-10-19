import processing.sound.*;

SinOsc sineWave;

void setup() {
  size(800, 800);
  background(0);

  sineWave = new SinOsc(this);
  sineWave.play();
  
  textSize(32);
  text("High pitched", 40, 120); 
  text("Speed = Amplitude", 500, 400); 
  text("Low pitched", 40, 680); 
}

void draw() {
  // convert mouseY into reasonable range of frequencies
  float adjMouseY = map(mouseY, 0, height, 1, 0);
  float frequency = pow(1000, adjMouseY) + 150;
  
  //calculate mouse speed
  float xDif = mouseX - pmouseX;
  float yDif = mouseX - pmouseX;
  float speed = sqrt(xDif * xDif + yDif * yDif);
  // convert into reaasonable range of amplitudes
  float amplitude = map(speed, 0, 300, 0.1, 1);

  // apply to the sinewave
  sineWave.freq(frequency);
  sineWave.amp(amplitude);
}
