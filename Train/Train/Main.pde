import java.util.HashMap;

String baseUrl = "https://eif-research.feit.uts.edu.au/api/csv";
String rFamily = "people";

// Default values for the date
String rFromDate = "2020-07-22T00%3A00";
String rToDate = "2020-010-22T00%3A00";

// Floors and their respective sensor codes
HashMap<String, String[]> floors = new HashMap<>();
  // To store IN and OUT data for selected floor


int numCarriages = 10;
int index = 0;

String[] carriageNames = {"0","1","2","3","4","5","8","9","10","11"};
Carriage[] train = new Carriage[numCarriages];

//styling params
color background = #A2F2FA;
float carriageLength = 80;
float carriageHeight = 45;
int rounding = 5;

void setup(){
  
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
  
  size(1200, 600);
  colorMode(HSB, 360, 100, 100);
  noStroke();
  textAlign(CENTER);
  for(int i = 0; i < numCarriages; i++){
    train[i] = new Carriage(i == numCarriages - 1, i==0, true, (int)random(0,100), carriageNames[i]);
    fetchData(i);
  }
  
  frameRate(4);
  
}

void draw(){
  background(#A2F2FA);
  fill(#20a020);
  rect(0,height*0.8,width, height*0.2);
  textSize(40);
  fill(0);
  text(train[0].inData.getString(index,0),200,100); 
  for(int i = 0; i < numCarriages; i++){
    train[i].setCapacity(index);
    pushMatrix();
    translate((i) * (carriageLength + 10) + 20, 450); 
    drawCarriage(train[i]);
    popMatrix();
  } 
  index++;
}


void drawCarriage(Carriage carriage) {
  fill(#d5d5d5);
  rect(0, 0, carriageLength , carriageHeight, carriage.last ? carriageHeight/2 : rounding, carriage.first ? carriageHeight/2 : rounding, rounding, rounding); 
  fill(carriage.getColor());
  rect(10, 10, 15 , 15, 10); 
  textSize(20);
  fill(#ffffff);
  text(carriage.name, carriageLength/2, carriageHeight + 20); 

}

void fetchData(int i) {

  String[] sensors = floors.get(carriageNames[i]);

  for (String sensor : sensors) {
    // Construct the URL for each sensor (In and Out)
    String urlIn = baseUrl + "?rFromDate=" + rFromDate + "&rToDate=" + rToDate + "&rFamily=" + rFamily + "&rSensor=" + "+PC" + sensor + "+%28In%29";
    String urlOut = baseUrl + "?rFromDate=" + rFromDate + "&rToDate=" + rToDate + "&rFamily=" + rFamily + "&rSensor=" + "+PC" + sensor + "+%28Out%29";

    println("Fetching data from: IN -> " + urlIn);
    println("Fetching data from: OUT -> " + urlOut);
    
    try {
      train[i].inData = loadTable(urlIn, "csv");
      train[i].outData = loadTable(urlOut, "csv");

    } catch (Exception e) {
      println("Error loading or parsing data for sensor " + sensor + ": " + e.getMessage());
      e.printStackTrace();
    }
  }
}
