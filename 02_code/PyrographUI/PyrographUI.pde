import processing.serial.*;

Serial myPort;

int servo = 125;
int time = 0;
int motorX = 0;
int motorY = 0;

boolean servoL = false;
boolean servoR = false;

// up = 125       down = 80

void setup(){
 
  size(200,200);
  println("Choose the USB port:");
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[3], 57600);
  
  if(myPort.available() > 0){
    println(myPort.read());
  }
  
}

void draw() {
  
  if(mousePressed){
    for(int i=0; i<3; i++){
      delay(2000); // time on paper
      servo = 1;   
      update(servo, motorX, motorY);
      servo = 0;
      motorX += 1;
      delay(1000);  // time up 
      update(servo, motorX, motorY);
      delay(1000);  // time up 
    }
  }
}


void update(int z, int x, int y){  
  myPort.write(x);
  myPort.write(y);
  myPort.write(z);
  println("servo: "+z+"\t"+"\t"+"motorX: "+motorX);
}