// Natalie Group 11
// youtube url: https://youtu.be/4Sf3PF0A45E

import controlP5.*;
import java.util.HashMap;
import ddf.minim.*;

// URL params
String baseUrl = "https://eif-research.feit.uts.edu.au/api/csv";
String rFamily = "people";

String rFromDate = "2020-07-22T00%3A00";
String rToDate = "2020-07-23T00%3A00";

// Floors and their respective sensor codes
HashMap<String, String[]> floors = new HashMap<>();
int index = 0; //counter to cycle through data

int numCarriages = 10;

String[] carriageNames = {"0","1","2","3","4","5","8","9","10","11"};
Carriage[] train = new Carriage[numCarriages];

// Speed controls
ControlP5 cp5;
int framecounter = 0;
float framespeed = 60;
float speed = 1;
boolean pause = true;
float lastknownspeed = 60;
float lastknownbgspeed = 10;
Slider abc;

// Audio
Minim minim;
AudioPlayer trainHorn;

//background
ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<Tree> trees = new ArrayList<Tree>();
ArrayList<Bird> birds = new ArrayList<Bird>();  

float sunSize = 100;  // Size of the sun
int scene = 2; 
float backgroundSpeed = 10;

//styling params
float carriageLength = 80;
float carriageHeight = 45;
int rounding = 5;
int fullCarriageIndex;


void setup(){
  size(1200, 600);
  colorMode(HSB, 360, 100, 100);
  noStroke();
  textAlign(CENTER);
  
  // Initialize Minim and load the train horn sound
  minim = new Minim(this);
  trainHorn = minim.loadFile("Train Horn - Sound Effect (HD).WAV");
  
  // Define floor and sensor mapping
  floors.put("0", new String[]{"00.05", "00.06", "00.07", "00.08", "00.09"});
  floors.put("1", new String[]{"01.11", "01.12", "01.13"});
  floors.put("2", new String[]{"02.14", "02.15", "02.16"});
  floors.put("3", new String[]{"03.17"});
  floors.put("4", new String[]{"04.20"});
  floors.put("5", new String[]{"05.21", "05.22", "05.23", "05.24"});
  floors.put("8", new String[]{"08.25"});
  floors.put("9", new String[]{"09.26", "09.27", "09.28", "09.29"});
  floors.put("10", new String[]{"10.30"});
  floors.put("11", new String[]{"11.31", "11.32", "11.33"});
 
 
  // Initialise stars for the night scene
  int starCount = 20;
  for (int i = 0; i < starCount; i++) { 
    stars.add(new Star());
  }

  // Initialise trees
  int treeCount = 10;
  for (int i = 0; i < treeCount; i++) { 
    trees.add(new Tree());
  }
 
 
  // Initialise birds
  int birdCount = 4;
  for (int i = 0; i < birdCount; i++) { 
    birds.add(new Bird());
  }
  
  //create train carriages and fetch data
  for(int i = 0; i < numCarriages; i++){
    train[i] = new Carriage(i == numCarriages - 1, i==0, (int)random(0,100), carriageNames[i], floors.get(carriageNames[i]).length);
    fetchData(i);
  }
  
  frameRate(60); 
  
  cp5 = new ControlP5(this);
  cp5.addSlider("speed")
     .setPosition(400,height-60)
     .setRange(0.5, 4)
     .setSize(200,20)
     .setValue(1)
     .setNumberOfTickMarks(8)
     ;
     
     cp5.addButton("pause")
     .setPosition(650,height-65)
     .setSize(200,30)
     .setValue(0)
     .setSwitch(true)
     .setCaptionLabel("Play/Pause")
     ;
  
}

void draw(){
  // reset iterator once data has run out
  if (index >= train[0].inData[0].getRowCount()){
    index = 0;
  }
  
  //background
  int hour = getHour();
  
  //determine which scene to use based on hour
  if (hour <= 5 || hour > 20){
    scene = 3;
  } else if (hour < 15) {
    scene = 1;
  } else {
    scene = 2;
  }
    
  //generate scene specific elements
  switch (scene) {
    case 1:  // Morning
      background(#8dcef2); 
      animateSun(); 
      fill(#20a020);
      rect(0, height*0.7, width, height*0.3);      
      break;
      
    case 2:  // Afternoon
      background(#deab0b); 
      animateSun(); 
      fill(#20a020);
      rect(0, height*0.7, width, height*0.3);      
      break;
      
    case 3:  // Night
      background(#1b3542); 
      fill(#20a020);
      rect(0, height*0.7, width, height*0.3);  
      for (Star star : stars) {
        star.update();
        star.display();
      }
      break;
  }  

  for (Bird bird : birds) {
    bird.update();
    bird.display();
  }
  
  for (Tree tree : trees) {
    tree.update();
    tree.display();
  }
  
  //UI
  textSize(40);
  fill(#ffffff);
  text(train[0].inData[0].getString(index,0),200,height-30); 
  if(trainHorn.isPlaying()){
    fill(#DE4A4A);
    text("FLOOR " + carriageNames[fullCarriageIndex] + " IS FULL", 1000, 70); 
  }
  if(pause){
    fill(0, 0, 80);
    rect(10, 10, 20, 50);
    rect(40, 10, 20, 50);
  }
  
  //Train tracks
  stroke(0);
  strokeWeight(4);
  line(0,500,width,500);
  line(0,485,width,485);
  for(int i = 0; i < 2 * width; i+=30){
    line(i-framecounter*backgroundSpeed,500,i+3-framecounter*backgroundSpeed,485);
  }
  noStroke();
  
  //Train
  for(int i = 0; i < numCarriages; i++){
    train[i].setCapacity(index);
    pushMatrix();
    translate((i) * (carriageLength + 10) + 20, 450); 
    drawCarriage(train[i]);
    popMatrix();
    
    // Check if the carriage color is red and play sound
    if (train[i].getColor() == color(0, 100, 100)) {
      playTrainHorn();
      fullCarriageIndex = i;
    }
  } 
  
  framecounter++;
  //update iterators
  if(framecounter > framespeed){
    index++;
    framecounter = 0;
  }
  
}


void drawCarriage(Carriage carriage) {
  fill(#d5d5d5);
  rect(0, 0, carriageLength , carriageHeight, carriage.last ? carriageHeight/2 : rounding, carriage.first ? carriageHeight/2 : rounding, rounding, rounding); 
  fill(carriage.getColor());
  rect(10, 10, 15 , 15, 10); 
  textSize(30);
  fill(0,0,20);
  text(carriage.name, carriageLength - 25, 33); 

}

void fetchData(int i) {
  String[] sensors = floors.get(carriageNames[i]);
  for (int j = 0; j < sensors.length; j++) {
    // Construct the URL for each sensor (In and Out)
    String urlIn = baseUrl + "?rFromDate=" + rFromDate + "&rToDate=" + rToDate + "&rFamily=" + rFamily + "&rSensor=" + "+PC" + sensors[j] + "+%28In%29";
    String urlOut = baseUrl + "?rFromDate=" + rFromDate + "&rToDate=" + rToDate + "&rFamily=" + rFamily + "&rSensor=" + "+PC" + sensors[j] + "+%28Out%29";
    
    try {
      train[i].inData[j] = loadTable(urlIn, "csv");
      train[i].outData[j] = loadTable(urlOut, "csv");
    } catch (Exception e) {
      println("Error loading or parsing data for sensor " + sensors[j] + ": " + e.getMessage());
      e.printStackTrace();
    }
  }
}


void animateSun() {
  pushMatrix();  
  // hour adjusted to start animation at dawn
  float hour = getHour() - 5;
  translate(hour * width / 13 - 200, hour * hour * height / 225);  // Position the sun in the top left corner
  fill(54, 100, 100);  // Sun colour
  noStroke();
  ellipse(0, 0, sunSize, sunSize);  // Draw the sun
  popMatrix();
}

int getHour(){
  return (int) (((float)index % 48) / 2);
}

void speed(float input) {
  if(pause){
    lastknownspeed = 60 / input;
    lastknownbgspeed = 10 * input;
  } else {
  framespeed = 60 / input;
  lastknownspeed = framespeed;
  backgroundSpeed = 10 * input;
  lastknownbgspeed = backgroundSpeed;
  println("Setting speed to "+ framespeed + "frames");
  }
}

void pause(boolean value){
  if(value == true){
    pause = false;
    framespeed = lastknownspeed;
    backgroundSpeed = lastknownbgspeed;
  }
  if(value == false){
    pause = true;
    backgroundSpeed = 0;
    framespeed = 999999;
  }
}

// Function to play the train horn when a carriage turns red
void playTrainHorn() {
  if (!trainHorn.isPlaying()) {
    trainHorn.rewind();
    trainHorn.play();
  }
}
