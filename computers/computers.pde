String[] computers = {
  "E1-04201",
  "E1-05204",
  "E1-05300",
  "E1-053L0",
  "E1-053V0",
  "E1-05402",
  "E1-06101",
  "E1-06102",
  "E1-06103",
  "E1-061V2",
  "E1-07403",
  "E1-07404",
  "E1-07405",
  "E1-07406",
  "E1-08409",
  "E1-09405",
  "E1-10104",
  "E1-10403",
  "E1-11300",
  "E1-11403",
  "E1-B1102",
  "E1-B1103",
  "E1-B11V2",
  "E1-B11V3",
  "E1-B1203",
  "E1-B1204",
  "E1-B1400",
  "E1-B1401",
  "E1-B1402",
  "E1-B1403",
  "E1-B14V0",
  "E1-B14V1",
  "E1-B14V2",
  "E1-B14V3"
};

Table xy;
int index = 0;
int dataIndex = 0;
String url = "https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2018-01-26T14%3A30%3A44&rToDate=2018-01-28T14%3A30%3A44&rFamily=logins&rSensor=";


void setup() {
  size(1000, 1000);
}

void draw() {
 for(int i = 0; i < computers.length; i++){
   loadNewTable(i);
   for(int j = 0; j < 50; j++){
     int y = xy.getInt(0+j,1);
     fill(y*30);
     rect(0,0,20,20);
     translate(0,20);
   }
  translate(20,-1000);
 }
}

void loadNewTable(int comp){
   xy = loadTable(url + computers[comp], "csv"); 
}
