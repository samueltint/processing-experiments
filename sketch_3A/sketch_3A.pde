import controlP5.*;
import processing.sound.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

ControlP5 cp5;
int stage = 0; // 0 - record inputs, 1 - record audio, 2 - animate

// store inputs
Character[] letters = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
ArrayList<Input> inputs = new ArrayList<Input>();
ArrayList<Character> requiredLetters = new ArrayList<Character>();


// calculate the typing speed for each character
int lastKeyTime = 0;
float sum = 0;
float average = 0;
float minSoundFactor = 0.6;
float maxSoundFactor = 2;

// manage recording
Minim minim;
boolean recording = false;
SoundFile[] recordedAudios = new SoundFile[26];
SoundFile emptySound;
AudioInput in;
AudioRecorder recorder;

// manage animation
float padding = 60;
int inputIndex = 0;
ArrayList<Ball> balls = new ArrayList<Ball>();
color circleCol;
float minBallSpeed = 2;
float maxBallSpeed = 10;
float ballSize = 10;

void setup() {
  size(600, 500);
  //fullScreen();
  cp5 = new ControlP5(this);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048);
  ellipseMode(CENTER);
  colorMode(HSB, 360, 100, 100);
  textSize(20);
  noFill();
  noStroke();
}

void draw() {
  switch(stage) {
  case 0 : // inputs
    background(0);
    text("Type a sentence \nPress ENTER or \'.\' to finish", 20, 350);
    text(charsToString(inputs), 20, 50);
    lastKeyTime++;
    break;

  case 1 : // record audio
    background(0);
    fill(0, 0, 100);
    text(charsToString(inputs), 20, 50);
    text("Press each letter to record your voice for that sound", 20, 80);
    
    String requiredLettersOutput = "";
    if(requiredLetters.size() > 0){
      for (char letter : requiredLetters) {
        requiredLettersOutput += letter + ", ";
      }
    }
    else {
      requiredLettersOutput = "None";
    }
    
    text("Letters to record for: " + requiredLettersOutput, 20, 110);
    
    if (recording) {
      fill(0, 90, 90);
      text("Currently Recording: " + key , 20, 140);
    } else {
      text("Currently Recording: Nothing", 20, 140);
    }
    break;

  case 2 : // animate
    background(0, 0, 100);
    // Fixed elements
    fill(0);
    textSize(15);
    text("The speed of the balls and the audio are relative to how quickly you typed that character", 20, 20);
    text("Input: " + charsToString(inputs), 20, 40);
    fill(0, 0, 100);
    strokeWeight(2);
    stroke(0, 0, 70);
    rect(padding, padding, width - 2 * padding, height - 2 * padding);
    
    if (inputIndex < inputs.size()) {
      Input currentInput = inputs.get(inputIndex);
      //play next sound
      if (inputIndex == 0 || !inputs.get(inputIndex - 1).sound.isPlaying()) {
        balls.add(new Ball(currentInput.character, ballSize, map(currentInput.speedFactor, minSoundFactor, maxSoundFactor, minBallSpeed, maxBallSpeed)));
        currentInput.playSound();
        inputIndex++;
      }
    }

    // ball animation logic
    for (Ball ball : balls) {
      ball.collide();
      ball.update();
      ball.display();
    }
    break;    
  }
}

// keyboard events
void keyPressed() {
  if (stage == 0) {
    if (key == '.' || keyCode == ENTER) {
      inputs.get(inputIndex - 1).time = lastKeyTime;
      sum += lastKeyTime;
      average = sum / inputs.size();

      cp5.addButton("stage2")
        .setLabel("Done")
        .setPosition(20, 200)
        .setSize(60, 30);

      // next phase
      stage = 1;
      inputIndex = 0;
      println("stage 1");
    } else if (keyCode == BACKSPACE && inputIndex > 0) {
      inputs.remove(inputIndex);
      inputIndex--;
    }
  }
}

void keyTyped() {
  if (stage == 0 && keyCode != ENTER && key != '.') {
    inputs.add(new Input(key));
    if (inputIndex > 0) {
      inputs.get(inputIndex - 1).time = lastKeyTime;
      sum += lastKeyTime;
    }
    for (Input input : inputs) {
      if (!requiredLetters.contains(input.character) && input.isLetter) {
        requiredLetters.add(input.character);
      }
    }
    lastKeyTime = 0;
    inputIndex++;
  } else if (stage == 1 && getLetterIndex(key) != -1 && !recording) {
    recording = true;
    recorder = minim.createRecorder(in, key + ".wav");
    recorder.beginRecord();
    println("begin recording " + key);
  }
}

void keyReleased() {
  if (stage == 1 && getLetterIndex(key) != -1 && recording) {
    recording = false;
    recorder.endRecord();
    println("end recording " + key);
    recorder.save();
    requiredLetters.remove((Character)key);
  }
}

void stage2() {
  // end audio inputs
  in.close();
  
  // empty sound for spaces and punctuation
  emptySound = new SoundFile(this, "empty.wav");
  
  for (char letter : letters) {
    recordedAudios[getLetterIndex(letter)] = new SoundFile(this, Character.toLowerCase(letter) + ".wav");
  }
  
  for (Input input : inputs) {
    input.calculateSpeedFactor();
    if (input.isLetter) {
      input.sound = recordedAudios[getLetterIndex(input.character)];
    } else {
      input.sound = emptySound;
    }
  }

  cp5.hide();
  stage = 2;
}

//util functions
String charsToString(ArrayList<Input> list) {
  String output = "";
  for (Input item : list) {
    output += item.character;
  }
  return output;
}

public int getLetterIndex(char character) {
  for (int i = 0; i < 26; i++) {
    if (letters[i] == Character.toLowerCase(character)) {
      return i;
    }
  }
  return -1;
}
