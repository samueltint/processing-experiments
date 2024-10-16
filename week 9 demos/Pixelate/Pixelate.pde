/**
 * Pixelate  
 *  * 
 * Load a QuickTime file and display the video signal 
 * using rectangles as pixels by reading the values stored 
 * in the current video frame pixels array. 
 */

import processing.video.*;

int blockSize = 10;
Movie mov;

void setup() {
  size(640, 360);
  noStroke();
  mov = new Movie(this, "transit.mov");
  mov.loop();
}

// Display values from movie
void draw() {
  if (mov.available() == true) {
    mov.read();
    mov.loadPixels();
    
    for (int x = 0; x < width; x+= blockSize) {
      for (int y = 0; y < height; y+=blockSize) {     
        fill(mov.pixels[(y*width) + x]);
        rect(x, y, blockSize, blockSize);
      }
    }
  }
}