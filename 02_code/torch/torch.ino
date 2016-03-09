#include <AccelStepper.h>
#include <AFMotor.h>
#include <Servo.h>
Servo servo;



AF_Stepper motor1(48, 1);

void forwardstep1()  { motor1.onestep(BACKWARD, SINGLE);}
void backwardstep1() { motor1.onestep(FORWARD, SINGLE);}
AccelStepper stepper1(forwardstep1, backwardstep1);


char cmdBfr[] = {0, 0, 0};
uint8_t bfrIndx = 0;

int stepper1Target = 0;
int stepper2Target = 0;
int servoTarget = 0;
int servoPos = 120;

void setup()
{  
  Serial.begin(57600);
  stepper1.setMaxSpeed(3000);
  stepper1.setAcceleration(2000); 
  servo.attach(10);
  //servo.write(120);
}

void loop()
{
  if(Serial.available() > 2){
    for(uint8_t indx = 0; indx < 3; indx++){
      cmdBfr[indx] = Serial.read();
      bfrIndx++;
    }
  }
  if(bfrIndx == 3){
    parseData();
    bfrIndx = 0;
    
  }
  
  if(servoTarget > 0){servoPos = 80;}
  else {servoPos = 120;}
  
  int kerning = 300;
  servo.write(servoPos);
  stepper1.run();
  stepper1.moveTo(stepper1Target*kerning);
  
}

void parseData()
{  
  stepper1Target = cmdBfr[0];
  stepper2Target = cmdBfr[1];
  servoTarget = cmdBfr[2];
}


