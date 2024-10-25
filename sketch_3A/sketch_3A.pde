import controlP5.*;
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
float minSoundFactor = 0.4;
float maxSoundFactor = 2;

// manage recording
Minim minim;
boolean recording = false;
FilePlayer[] recordedAudios = new FilePlayer[26];
AudioInput in;
AudioRecorder recorder;
AudioOutput out;

// manage audio during simulation
int inputIndex = 0;
float nextSoundTrigger = 0;
float currentSoundLength = 0;
float soundStartTime = 0;
float baseSampleRate = 44100;

// manage animation
ArrayList<Ball> balls = new ArrayList<Ball>();
color circleCol;
float minBallSpeed = 2;
float maxBallSpeed = 10;
float ballSize = 10;

void setup() {
  size(600,500);
  //fullScreen();
  cp5 = new ControlP5(this);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048);
  out = minim.getLineOut( Minim.STEREO );

  ellipseMode(CENTER);
  colorMode(HSB,360,100,100);
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
      text(charsToString(inputs), 20, 50);
      text("Press each letter to record your voice for that sound", 20, 300);
      text("For now I am using pre recorded audio, this is skipped", 20, 350);
      break;
    
    case 2 : // animate
      background(#ffffff);  
      if(inputIndex < inputs.size()){
        Input currentInput = inputs.get(inputIndex);
        if (millis() >= nextSoundTrigger) {
          balls.add(new Ball(currentInput.character, ballSize, map(currentInput.speedFactor, minSoundFactor, maxSoundFactor, minBallSpeed, maxBallSpeed)));
          //play next sound
          if (currentInput.isLetter) {
            currentInput.playSound();
            currentSoundLength = currentInput.sound.length();
          } else {
            currentSoundLength = 500 * currentInput.speedFactor;
          }
          soundStartTime = millis();
          nextSoundTrigger = millis() + currentSoundLength;
          inputIndex++;
        }        
      }
      
      // ball animation logic
      for (Ball ball : balls) {
        ball.collide();
        ball.update();
        ball.display();  
      }
      
      // screen readouts
      fill(0);
      textSize(15);
      text("The speed of the balls and the audio are tied to how quickly you typed that letter", 20, 50);
      text("Input: " + charsToString(inputs), 20, 75);
      text("Current Letter: " + inputs.get(inputIndex - 1).character, 20, 100);
      text("Typing delay: " + inputs.get(inputIndex - 1).time, 20, 125);
      text("Speed multiplier: " + inputs.get(inputIndex - 1).speedFactor, 20, 150);
      
      break;
    
  }
}

// keyboard events
void keyPressed() {
  if (stage == 0) {
    if (key == '.' || keyCode == ENTER) {
      inputs.get(inputIndex - 1).time = lastKeyTime;
      average = sum / inputs.size() - 1;
      
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
    for(Input input : inputs){
      if(!requiredLetters.contains(input.character) && input.isLetter){
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
  } 
}

void recordLetter(char character){
  recordedAudios[getLetterIndex(character)] = new FilePlayer(minim.loadFileStream(Character.toLowerCase(character) + ".wav")); 
}
  
void stage2(){
  for(char letter : requiredLetters){
    recordLetter(letter);
  }
  for (Input input : inputs) {
    input.calculateSpeedFactor();
    if (input.isLetter) {
      input.sound = recordedAudios[getLetterIndex(input.character)];
      input.sound.patch(out);
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

public int getLetterIndex(char character){
 for(int i = 0; i < 26; i++){
   if (letters[i] == Character.toLowerCase(character)){
     return i;
   }
 }
 return -1;
}
