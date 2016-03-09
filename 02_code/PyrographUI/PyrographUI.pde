import processing.serial.*;

Serial myPort;

int servo = 125;
int time = 0;
int motorX = 0;
int motorY = 0;

boolean servoL = false;
boolean servoR = false;

int[] times = {0, 1000, 900, 800, 700, 600, 500, 400, 300, 200, 100, 0};

// up = 125       down = 80

void setup(){
 
  size(200,200);
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[3], 57600);
  
}

void draw() {
  
  //100 dots
  if(mousePressed){
    
    for(int i=0; i<5; i++){
      
     if(times[i] != 0){
        servo = 1;   
        update(servo, motorX, motorY);
      }
      servo = 0;
      delay(times[i]);    // grayscale
      
      update(servo, motorX, motorY);
      motorX += 1;
      update(servo, motorX, motorY);
      delay(1000);  // wait for motor 
    }
  }
  
}

void update(int z, int x, int y){  
  myPort.write(x);
  myPort.write(y);
  myPort.write(z);
  println("servo: "+z+"\t"+"\t"+"motorX: "+motorX+"\t"+"\t"+"motorX: "+motorX);
}