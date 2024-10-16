/**
 * Movie. 
 * 
 * Shows how to load and manipulate a QuickTime movie file.  
 *
 */

import processing.video.*;

Movie movie;

void setup() {
  size(640, 360);
  background(0);
  // Load and play the video in a loop
  movie = new Movie(this, "transit.mov");
  movie.loop();
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  image(movie, 0, 0, width, height);
}

void mousePressed() {
  movie.pause();
}

void mouseReleased() {
  movie.play();
}

void keyPressed() {
  if(key == '1') movie.speed(1);
  if(key == '2') movie.speed(200);
  if(key == 'r') movie.speed(0.1);
}