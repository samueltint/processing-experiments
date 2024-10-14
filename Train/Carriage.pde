int max = 100;

class Carriage {
  boolean first, last, hasData;
  int capacity;
  String name;
  Table inData, outData;  
  
  Carriage(boolean first, boolean last, boolean hasData, int capacity, String name) {
    this.first = first;
    this.last = last;
    this.hasData = hasData;
    if (this.hasData) {
      this.capacity = capacity;  
    }  
    this.name = name;
  }
  
  void setCapacity(int index) {
    int inCount = inData.getInt(index, 1);  // Column 1 is the IN value
    int outCount = outData.getInt(index, 1);  // Column 1 is the OUT value
    capacity += inCount - outCount;  // Calculate occupancy as IN - OUT
  }
  
  color getColor() {
    if (hasData) {
      return color(map(capacity,0,max,100,20), 100, 100);
    }
    else {
      return color(0, 0, 60);
    }
  }
  
}
