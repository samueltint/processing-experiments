ArrayList<Input> inputs = new ArrayList<Input>();
int inputIndex = 0;
int lastKeyTime = 0;
Boolean animate = false;

void setup() {
  size(640, 360);
}

void draw() {
  if (!animate) {
    background(0);
    text(charsToString(inputs), 20, 50);
    text(timesToString(inputs), 20, 100);
    lastKeyTime++;
  } else {
    background(255);
    fill(0);
    text(charsToString(inputs), 20, 50);
    
  }
}

void keyPressed() {
  if (!animate) {
    if (key == '.' || keyCode == ENTER) {
      animate = true;
    }
    if (keyCode == BACKSPACE) {
      if (inputIndex > 0) {
        inputIndex--;
        inputs.remove(inputIndex);
      } 
    }
  }
}

void keyTyped() {
  if (!animate) {
    if (key == '.') {
      animate = true;
    }
    
    inputs.add(new Input(key));
    if (inputIndex > 0) {
      inputs.get(inputIndex - 1).time = lastKeyTime;
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
