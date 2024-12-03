int max = 8;

class Carriage {
  boolean first, last;
  int capacity;
  String name;
  // array of tables for each sensor
  Table[] inData, outData;  
  
  Carriage(boolean first, boolean last, int capacity, String name, int numSensors) {
    this.first = first;
    this.last = last;
    this.capacity = capacity;  
    this.name = name;
    this.inData = new Table[numSensors];
    this.outData = new Table[numSensors];
  }
  
  void setCapacity(int index) {
    int inCount = 0, outCount = 0;
    
    for (int i = 0; i < inData.length; i++){
      inCount = inData[i].getInt(index, 1);  // Column 1 is the IN value
      outCount = outData[i].getInt(index, 1);  // Column 1 is the OUT value
    }
    capacity = max(0, inCount - outCount);  // Calculate occupancy as IN - OUT
  }
  
  color getColor() {
    return color(map(capacity,0,max,100,20), 100, 100);
  }
  
}
