import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
PImage src, canny, scharr, sobel;

void setup() {
  size(640,480);
  
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  
  video.start();


}


void draw() {
  opencv.loadImage(video);
  opencv.findSobelEdges(1,0);
  sobel = opencv.getSnapshot();
  
  opencv.loadImage(video);
  opencv.findScharrEdges(OpenCV.HORIZONTAL);
  scharr = opencv.getSnapshot();
  
  opencv.loadImage(video);
  opencv.findCannyEdges(20,75);
  canny = opencv.getSnapshot();
  
  image(video, 0, 0);
  image(sobel, 320, 0);
  image(scharr, 0, 240);
  image(canny, 320, 240);
}

void captureEvent(Capture c) {
  c.read();
}

