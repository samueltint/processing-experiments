String baseUrl = "https://eif-research.feit.uts.edu.au/api/csv";
String rFamily = "people";
String sensorIn = "+PC00.05+%28In%29";  // Correct encoding for "PC00.05 (In)"
String sensorOut = "+PC00.05+%28Out%29";  // Correct encoding for "PC00.05 (Out)"

// Default values for the date
String rFromDate = "2020-03-22T00%3A00";
String rToDate = "2020-03-23T00%3A00";

Table inData;
Table outData;
int[] occupancyLevels;
String[] timestamps;

// For date input
String userInput = "";
boolean isEnteringDate = false;

void setup() {
  size(1000, 400);
  // Call the function to fetch and display data
  fetchAndDisplayData();
}

void fetchAndDisplayData() {
  // Construct the URL for "In" and "Out" data
  String urlIn = baseUrl + "?rFromDate=" + rFromDate + "&rToDate=" + rToDate + "&rFamily=" + rFamily + "&rSensor=" + sensorIn;
  String urlOut = baseUrl + "?rFromDate=" + rFromDate + "&rToDate=" + rToDate + "&rFamily=" + rFamily + "&rSensor=" + sensorOut;

  // Load CSV data
  inData = loadTable(urlIn, "csv");
  outData = loadTable(urlOut, "csv");

  // Ensure data is loaded
  if (inData == null || outData == null) {
    println("Error loading data.");
    exit();
  }

  // Initialize arrays to store occupancy levels and timestamps
  int rowCount = inData.getRowCount();
  occupancyLevels = new int[rowCount];
  timestamps = new String[rowCount];

  // Calculate occupancy for each hour
  for (int i = 0; i < rowCount; i++) {
    String datetime = inData.getString(i, 0); // Assuming column 0 is the datetime
    int inCount = inData.getInt(i, 1); // Assuming column 1 is the "in" reading_value
    int outCount = outData.getInt(i, 1); // Assuming column 1 is the "out" reading_value

    // Calculate occupancy (In - Out)
    occupancyLevels[i] = inCount - outCount;
    timestamps[i] = datetime;
  }
}

void draw() {
  background(255);

  // Display instructions for the user to enter a date
  fill(0);
  textAlign(LEFT);
  textSize(16);
  text("Enter Date in format YYYY-MM-DD and press Enter:", 20, 20);
  text("Current From Date: " + rFromDate, 20, 50);
  text("Current To Date: " + rToDate, 20, 70);
  
  // Display user input if they're entering a date
  if (isEnteringDate) {
    text("Date: " + userInput, 20, 100);
  }

  // Draw occupancy levels with color representation
  if (occupancyLevels != null) {
    textAlign(CENTER, CENTER);
    textSize(12);
    
    // Set up a higher max occupancy threshold for color scaling
    int maxOccupancyThreshold = 100;  // You can adjust this to match expected high values
    
    for (int i = 0; i < occupancyLevels.length; i++) {
      int occupancy = occupancyLevels[i];

      // Map the occupancy level to a color scale (green -> yellow -> red)
      float occupancyColor = map(occupancy, 0, maxOccupancyThreshold, 0, 255);  // Scale occupancy to color range
      int colorValue = color(255 - occupancyColor, occupancyColor, 0);  // Green to red gradient

      // Draw rectangles for each hour
      float rectWidth = width / occupancyLevels.length;  // Calculate width of each rectangle
      fill(colorValue);
      rect(i * rectWidth, 150, rectWidth, 100);  // Draw the rectangle

      // Display the occupancy value above each rectangle
      fill(0);
      text(occupancy, i * rectWidth + rectWidth / 2, 130);  // Display occupancy above the rectangle

      // Display the timestamp
      text(timestamps[i], i * rectWidth + rectWidth / 2, 270);
    }
  }
}

void keyPressed() {
  // Handle user input for the date
  if (isEnteringDate) {
    // Allow typing characters
    if (key != ENTER && key != BACKSPACE) {
      userInput += key;
    } else if (key == BACKSPACE && userInput.length() > 0) {
      userInput = userInput.substring(0, userInput.length() - 1);
    }
    
    // When the user presses Enter, finalize the date input
    if (key == ENTER) {
      rFromDate = userInput + "T00%3A00";  // Format date with time for URL
      rToDate = calculateNextDay(userInput) + "T00%3A00";  // Set rToDate to 24 hours after rFromDate
      userInput = "";
      isEnteringDate = false;
      
      // Fetch new data based on the entered date
      fetchAndDisplayData();
    }
  }
  
  // Start entering the date if 'D' is pressed
  if (key == 'd' || key == 'D') {
    userInput = "";
    isEnteringDate = true;
  }
}

String calculateNextDay(String date) {
  // Parse the date and add one day to it
  String[] parts = split(date, "-");
  int year = int(parts[0]);
  int month = int(parts[1]);
  int day = int(parts[2]);

  day += 1;
  if (day > daysInMonth(month, year)) {
    day = 1;
    month += 1;
    if (month > 12) {
      month = 1;
      year += 1;
    }
  }

  return year + "-" + nf(month, 2) + "-" + nf(day, 2);
}

int daysInMonth(int month, int year) {
  if (month == 2) {
    if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
      return 29;  // Leap year
    }
    return 28;
  } else if (month == 4 || month == 6 || month == 9 || month == 11) {
    return 30;
  } else {
    return 31;
  }
}
