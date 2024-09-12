PImage img, output;
int offset = 1;

//sensitivity of edge detection
float borderThreshold;

//tints pixels towards #00ff00
float greenTint;

void setup() {
  img = loadImage("dog.jpg"); // Load the original image
  windowResize(img.width, img.height);
}

void draw() {
  greenTint = (float)mouseX / img.width / 4;
  borderThreshold = (float)mouseY / img.height * 10 + 10;

  output = createImage(img.width, img.height, RGB);
  output.loadPixels();
  
  // Loop through every pixel in the image
  for (int y = 1; y < img.height-1; y++) {   // Skip top and bottom edges
    for (int x = 1; x < img.width-1; x++) {  // Skip left and right edges
      //basic edge detection, 
      int pos = (y)*img.width + (x);
      int offsetPos = (y + offset)*img.width + (x - offset);

      if (offsetPos >= img.pixels.length) {
        offsetPos -= img.pixels.length;
      }
      
      color curColor = color(img.pixels[pos]);
      color offsetColor = color(img.pixels[offsetPos]);

      float dif = colorDifference(curColor, offsetColor);
      
      //either display black for an edge or a green tint of the original colour
      if (dif > borderThreshold){ 
        output.pixels[pos] = color(0);
      }
      else {
        output.pixels[pos] = lerpColor(curColor, #00ff00, greenTint); 
      }
    }
  }
  output.updatePixels();
  image(output, 0, 0);
}

//determine the maximum difference between the channels of two colours
float colorDifference(color curColor, color offsetColor){
  return max(red(curColor) - red(offsetColor), blue(curColor) - blue(offsetColor), green(curColor) - green(offsetColor));
}
