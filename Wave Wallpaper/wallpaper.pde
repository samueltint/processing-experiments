Table wavesTable, cloudsTable;

// parameters
int cloudBaseColor = 100;
int cloudColorRandomness = 10;
int cloudHeight = 400; //100-400
int waterLevel = 125; //100-130

// initial values are set to skip over parts of the data that are too low (these should stay fixed)
int columns = 80;
int wavesIndex = columns + 20;
int cloudsIndex = 0;
int cloudCount = 20;

void setup() {
  size(1200, 800);
  frameRate(8);
  
  // The water is based on Humidity and the clouds on Air Pollutants
  wavesTable = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2024-08-19T15%3A40%3A43&rToDate=2024-08-21T15%3A40%3A43&rFamily=wasp&rSensor=ES_C_13_302_C88E&rSubSensor=HUMA", "csv");
  cloudsTable = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2024-08-20T18%3A09%3A34&rToDate=2024-08-22T18%3A09%3A34&rFamily=wasp&rSensor=ES_C_13_302_C88E&rSubSensor=AP2", "csv");
  
  ellipseMode(CENTER);
  colorMode(HSB,360,100,100);
  noStroke();
}

void draw() {
  background(#55B8C9);
  
  //loop to the beginning once the data runs out
  if (wavesIndex >= wavesTable.getRowCount() - 40){
    wavesIndex = columns + 20;
  }
  if (cloudsIndex >= cloudsTable.getRowCount()){
    cloudsIndex = 0;
  }
  
  //CLOUDS
  float cloudsData = cloudsTable.getFloat(cloudsIndex, 1);
  cloudsData = cloudBaseColor + (cloudsData*100);
  
  //generate clouds
  for(int i = 0; i < cloudCount; i++){
     //color is based on the data value 
     fill(cloudsData + random(cloudColorRandomness));
     ellipse(random(width),random(80),width+random(80),cloudHeight*random(.5,1.5));
  }
  
  //WATER
  //generate enough columns to fill up the screen width
  for(int i = 0; i < columns; i++){
    
    //convert the float data into the right range
    float wavesData = wavesTable.getFloat(wavesIndex - i, 1) * 2 - waterLevel;
    
    //loop to create a circle representing value of each value
    for(int j = 0; j < wavesData; j++){
      
      //randomised radius and colour of each circle
      float radius = random(30,50);
      color waterColor = color(random(210,240),random(60,99),random(60,99));
      fill(waterColor);
      ellipse(0, height-j*20, radius, radius);
      
    }
    
    translate(20,0);
    
  }
  
  //increment indeces to load next data
  wavesIndex++;
  cloudsIndex++;
}
