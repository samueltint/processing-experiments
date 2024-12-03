class Star {
  float x, y;  // Position
  float size;  // Size of the star
  float angle;  // Angle of rotation
  float twinkleSpeed;  // Speed of twinkle
  float brightness;  // Brightness of the star

  Star() {
    x = random(width);
    y = random(height / 2);
    size = random(5, 15);
    angle = random(TWO_PI);
    twinkleSpeed = random(0.12, 0.91);  // Random twinkle speed
    brightness = random(100, 255);  // Initial brightness
  }

  void update() {
    angle += 0.1;  // Slow rotation
    brightness += twinkleSpeed;  // Adjust brightness
    if (brightness > 255 || brightness < 100) {
      twinkleSpeed *= -1;  // Reverse direction of twinkle
    }
  }

  void display() {
    pushMatrix();
    translate(x, y);
    rotate(angle);
    noStroke();
    fill(255, brightness);  // White colour with varying brightness for twinkle effect
    star(0, 0, size / 2, size, 5);  // Draw a 5-pointed star
    popMatrix();
  }

  // Function to draw a star with npoints
  void star(float x, float y, float radius1, float radius2, int npoints) {
    float angle = TWO_PI / npoints;
    float halfAngle = angle / 2.0;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius2;
      float sy = y + sin(a) * radius2;
      vertex(sx, sy);
      sx = x + cos(a + halfAngle) * radius1;
      sy = y + sin(a + halfAngle) * radius1;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}
