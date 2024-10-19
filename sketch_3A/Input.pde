class Input {
  char character;
  float time = 0;
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
  
  void playSound(){
    sound.rate((sound.duration() * 1000) / time);
    sound.play();
  }
}