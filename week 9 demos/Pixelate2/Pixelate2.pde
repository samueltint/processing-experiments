import processing.video.*;

Capture vid;
int s = 10; // down sampling resolution

void setup() {
  size(1600, 1000);
  vid = new Capture(this, width/s, height/s);
  vid.start();
} // end setup()

void draw() {
  if (vid.available()) {
    vid.read();
    vid.loadPixels();
    
    for (int y=0; y<height/s; y++) {
      for (int x=0; x<width/s; x++) {
        color c = vid.pixels[y*vid.width+x]; fill(c);
        text(x%2, x*s, y*s); 
        //rect(x*s, y*s, s, s);
      }
    }
  }
} // end draw()