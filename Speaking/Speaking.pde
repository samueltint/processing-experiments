import controlP5.*;
import processing.sound.*;

ControlP5 cp5;
Character[] letters = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};

// store inputs
ArrayList<Input> inputs = new ArrayList<Input>();
ArrayList<Character> requiredLetters = new ArrayList<Character>();
SoundFile[] recordedAudios = new SoundFile[26];

// calculate the typing speed for each character
int lastKeyTime = 0;
float sum = 0;
float average = 0;

//manage animation
int inputIndex = 0;
float nextSoundTrigger = 0;
float currentSoundLength = 0;
float soundStartTime = 0;
int stage = 0; // 0 - record inputs, 1 - record audio, 2 - animate
color circleCol;
void setup() {
  size(600,450);
  cp5 = new ControlP5(this);
  ellipseMode(CENTER);
  colorMode(HSB,360,100,100);
  textSize(20);
  noFill();
}

void draw() {
  switch(stage) {
    case 0 : // inputs
      background(0);
      text(charsToString(inputs), 20, 50);
      lastKeyTime++;
      break;
    
    case 1 : // record audio
      // skipping recording phase
      text("Press each letter to record your voice for that sound", 20, 300);
      for(char letter : requiredLetters){
      recordLetter(letter);
      }
      break;
    
    case 2 : // animate
      background(#ffffff);        
      if(inputIndex < inputs.size()){
        Input currentInput = inputs.get(inputIndex);
        if (millis() >= nextSoundTrigger) {
          circleCol = color(random(360),random(40, 80),random(50, 100));
          //play next sound
          if (currentInput.isLetter) {
            currentInput.playSound();
            currentSoundLength = currentInput.sound.duration() * 1000 * currentInput.speedFactor;
          } else {
            currentSoundLength = 500 * currentInput.speedFactor;
          }
          soundStartTime = millis();
          nextSoundTrigger = millis() + currentSoundLength;
          inputIndex++;
          
          
        } 
        
      }
      fill(circleCol);
      ellipse(width/2, map(millis() - soundStartTime, 0, currentSoundLength, 0, height), 50, 50);
      textSize(40);
      fill(0);
      text(inputs.get(inputIndex - 1).character, width/2 - 10, map(millis() - soundStartTime, 0, currentSoundLength, 0, height) + 10);
      
      textSize(15);
      text("Input: " + charsToString(inputs), 20, 100);
      text("Typing delay: " + inputs.get(inputIndex - 1).time, 20, 130);
      text("Speed multiplier: " + inputs.get(inputIndex - 1).speedFactor, 20, 160);
      
      break;
    
  }
}

void keyPressed() {
  if (stage == 0) {
    if (key == '.' || keyCode == ENTER) {
      inputs.get(inputIndex - 1).time = lastKeyTime;
      sum += lastKeyTime;
      average = sum / inputs.size();
      
      //add buttons for recording phase
      for (int i = 0; i < requiredLetters.size(); i++) {
        char letter = requiredLetters.get(i);
        cp5.addButton("Record " + letter)  // Unique ID for each button
         .setLabel("" + letter)   // Label with the corresponding letter
         .setPosition(20 + (i % 10) * 60, 70 + (i / 10) * 60)  // Position in rows
         .setSize(50, 50)
         .onClick((event) -> recordLetter(letter));  // Pass the letter to the function
      }
      
      cp5.addButton("stage2")  // Unique ID for each button
         .setLabel("Done")   // Label with the corresponding letter
         .setPosition(20, 200)  // Position in rows
         .setSize(60, 30);
       
      //move phases   
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

void recordLetter(char character){
 println(character);
 recordedAudios[getLetterIndex(character)] = new SoundFile(this, Character.toLowerCase(character) + ".wav");  
 println(character);
 println(getLetterIndex(character));
}

void stage2(){
  for (Input input : inputs) {
    input.calculateSpeedFactor();
    if (input.isLetter) {
      input.sound = recordedAudios[getLetterIndex(input.character)];
    }
  }
  cp5.hide();
  stage = 2;
}

public int getLetterIndex(char character){
 for(int i = 0; i < 26; i++){
   if (letters[i] == Character.toLowerCase(character)){
     return i;
   }
 }
 return -1;
}
