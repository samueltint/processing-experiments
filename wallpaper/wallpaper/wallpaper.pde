Table table;
int columns = 35;
int index = columns;

void setup() {
  size(600, 600);
  frameRate(10);
  // load the data for a humidity censor in csv format.
  table = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2024-08-19T15%3A40%3A43&rToDate=2024-08-21T15%3A40%3A43&rFamily=wasp&rSensor=ES_C_13_302_C88E&rSubSensor=HUMA", "csv");
  ellipseMode(CENTER);
  noStroke();
  fill(#0014DB);
}

void draw() {
  background(#50DDF7);
  if (index >= table.getRowCount()){
    index = columns;
  }
  for(int i = 0; i < columns; i++){
    float data = table.getFloat(index - i, 1) * 2 - 125; 
    println(data);
    for(int j = 0; j < data; j++){
      rect(0, width-j*20, 20, 20); 
    }
    translate(20,0);
  }
  index++;
}
