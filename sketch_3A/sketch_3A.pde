import controlP5.*;
import ddf.minim.*;

// Audio
Minim minim;

char[] letters = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
ArrayList<Input> inputs = new ArrayList<Input>();
int inputIndex = 0;
int lastKeyTime = 0;
float timeScale = 20;
int stage = 0; // 0 - record inputs, 1 - process audio, 2 - animate

void setup() {
  size(640, 360);
  minim = new Minim(this);
}

void draw() {
  switch(stage) {
    case 0 : // inputs
      background(0);
      text(charsToString(inputs), 20, 50);
      text(timesToString(inputs), 20, 100);
      lastKeyTime++;
      break;
    
    case 1 : // load audio
      if (inputIndex < inputs.size()) {
        
        Input currentInput = inputs.get(inputIndex);
        if (currentInput.isLetter) {
          currentInput.sound = minim.loadFile(Character.toLowerCase(currentInput.character) + ".wav");
        }
        inputIndex++;
      } else{
        inputIndex = 0;
        stage = 2;
        println("stage 2");
        background(0);
      }
      break;
    
    case 2 : // animate
      if (inputIndex < inputs.size()) {
        Input currentInput = inputs.get(inputIndex);
        if (currentInput.isLetter) {
          println("play");
          currentInput.sound.play();
          text(currentInput.character, 5 * (inputIndex+1), 100);
        }
        delay((int)currentInput.time);
        inputIndex++;
      }
      break;
    
  }
}

void keyPressed() {
  if (stage == 0) {
    if (key == '.' || keyCode == ENTER) {
      stage = 1;
      inputIndex = 0;
      println("stage 1");
    }
    else if (keyCode == BACKSPACE && inputIndex > 0) {
      inputIndex--;
      inputs.remove(inputIndex);
    }
  }
}

void keyTyped() {
  if (stage == 0 && keyCode != ENTER) {
    
    inputs.add(new Input(key));
    if (inputIndex > 0) {
      inputs.get(inputIndex - 1).time = lastKeyTime * timeScale;
    }
    
    lastKeyTime = 0;
    inputIndex++;
  }
}

String charsToString(ArrayList<Input> list) {
  String output = "";
  for (Input item : list) {
    output += item.character;
  }
  return output;
}

String timesToString(ArrayList<Input> list) {
  String output = "";
  for (Input item : list) {
    output += item.time + ",";
  }
  return output;
}
