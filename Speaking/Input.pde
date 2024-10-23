class Input {
  char character;
  float time = 0;
  float speedFactor = 0;
  SoundFile sound;
  Boolean isLetter = false;
  
  Input(char c) {
    character = c;
    for (char letter : letters) {
      if (Character.toLowerCase(c) == letter) {
        isLetter = true;
        break;
      }
    }
  }
  
  void playSound() {
    sound.rate(speedFactor);
    sound.play();
  }
  
  void calculateSpeedFactor() {
    speedFactor = constrain(average / time, 0.6, 1.5);
  }
}
