import controlP5.*;
import processing.sound.*;


char[] letters = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
ArrayList<Input> inputs = new ArrayList<Input>();
int inputIndex = 0;

// calculate the typing speed for each character
int lastKeyTime = 0;
float sum = 0;
float average = 0;

int stage = 0; // 0 - record inputs, 1 - record audio, 2 - animate

void setup() {
  size(800, 400);
}

void draw() {
  switch(stage) {
    case 0 : // inputs
      background(0);
      text(charsToString(inputs), 20, 50);
      text(timesToString(inputs), 20, 100);
      lastKeyTime++;
      break;
    
    case 1 : // record audio
      stage = 2;
      println("skipping recording stage");     
      break;
    
    case 2 : // animate
      
      if (inputIndex < inputs.size()) {
        //println(currentInput.speedFactor());
        Input currentInput = inputs.get(inputIndex);
        if (currentInput.isLetter) {
          currentInput.playSound();
          text(currentInput.character, 5 * (inputIndex + 1), 100);
          delay((int)(currentInput.sound.duration() * 1000 * currentInput.speedFactor));
        } else {
          delay((int)(500 * currentInput.speedFactor));
        }
        inputIndex++;
      }
      background(255);
      fill(0);
      text(charsToString(inputs), 20, 50);
      text(timesToString(inputs), 20, 100);
      break;
    
  }
}

void keyPressed() {
  if (stage == 0) {
    if (key == '.' || keyCode == ENTER) {
      inputs.get(inputIndex - 1).time = lastKeyTime;
      sum += lastKeyTime;
      average = sum / inputs.size();
      for (Input input : inputs) {
        input.calculateSpeedFactor();
        if (input.isLetter) {
          input.sound = new SoundFile(this, Character.toLowerCase(input.character) + ".wav");
        }
      }
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
      inputs.get(inputIndex - 1).time = lastKeyTime;
      sum += lastKeyTime;
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
    output += (float)round(item.speedFactor * 100) / 100 + ", ";
  }
  return output;
}
