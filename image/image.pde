PImage img, output;
int offset = 1;
float borderThreshold;
float greenTint;

void setup() {
  img = loadImage("dog.jpg"); // Load the original image
  windowResize(img.width, img.height);
}

void draw() {
  greenTint = (float)mouseX / img.width / 4;
  borderThreshold = (float)mouseY / img.height * 10 + 5;
  println(borderThreshold);
  output = createImage(img.width, img.height, RGB);
  output.loadPixels();
  // Loop through every pixel in the image
  for (int y = 1; y < img.height-1; y++) {   // Skip top and bottom edges
    for (int x = 1; x < img.width-1; x++) {  // Skip left and right edges
      int pos = (y)*img.width + (x);
      int offsetPosA = (y + offset)*img.width + (x + offset);
      int offsetPosB = (y + offset)*img.width + (x - offset);
      
      if (offsetPosA >= img.pixels.length) {
        offsetPosA -= img.pixels.length;
      }      
      if (offsetPosB >= img.pixels.length) {
        offsetPosB -= img.pixels.length;
      }
      
      color curColor = color(img.pixels[pos]);
      color offsetColorA = color(img.pixels[offsetPosA]);
      color offsetColorB = color(img.pixels[offsetPosB]);

      float difA = colorDifference(curColor, offsetColorA);
      float difB = colorDifference(curColor, offsetColorB);
      if (difA > borderThreshold || difB > borderThreshold){ 
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

float colorDifference(color curColor, color offsetColor){
  return max(red(curColor) - red(offsetColor), blue(curColor) - blue(offsetColor), green(curColor) - green(offsetColor));
}
