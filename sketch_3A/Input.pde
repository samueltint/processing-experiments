class Input {
  char character;
  float time;
  AudioPlayer sound;
  Boolean isLetter = false;

  Input(char c) {
    character = c;
    time = 0;
    for (char letter : letters) {
      if (Character.toLowerCase(c) == letter) {
        isLetter = true;
        break;
      }
    }
  }
}
