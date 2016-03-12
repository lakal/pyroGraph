#include <AccelStepper.h>
#include <AFMotor.h>
#include <Servo.h>
Servo servo;



AF_Stepper motor1(200, 1);
AF_Stepper motor2(200, 2);

void forwardstep1()  {
  motor1.onestep(BACKWARD, SINGLE);
}
void backwardstep1() {
  motor1.onestep(FORWARD, SINGLE);
}

void forwardstep2()  {
  motor2.onestep(BACKWARD, SINGLE);
}
void backwardstep2() {
  motor2.onestep(FORWARD, SINGLE);
}

AccelStepper stepper1(forwardstep1, backwardstep1);
AccelStepper stepper2(forwardstep2, backwardstep2);


char cmdBfr[] = {0, 0, 0};
uint8_t bfrIndx = 0;

int stepper1Target = 0;
int stepper2Target = 0;
int servoTarget = 0;
int servoPos = 30;
int linePos;
int line = 0;
int lineHight = 100;
int kerning = 300;
int c = 0;
int prevPos = 0;
int curPos = 0;

boolean test = false;

void setup()
{
  Serial.begin(115200);
  stepper1.setMaxSpeed(1000);
  stepper1.setAcceleration(500);
  stepper1.setSpeed(1000);

  stepper2.setMaxSpeed(2000);
  stepper2.setAcceleration(1000);

  servo.attach(10);
  servo.write(70);
}

void loop() { 

  if (Serial.available() > 2) {
    for (uint8_t indx = 0; indx < 3; indx++) {
      cmdBfr[indx] = Serial.read();
      bfrIndx++;
    } 
  }
  if (bfrIndx == 3) {
    parseData();
    bfrIndx = 0;
  }

  // ----- SERVO: START
  if (servoTarget == 1) {
    servoPos = 0;
  }
  else {
    servoPos = 70;
  } 
  servo.write(servoPos);
  // ----- SERVO: END

  
  curPos = stepper2Target;
  
  if(curPos != prevPos) {
     test = true;
     prevPos = curPos;
  }
 

  if(test == true) {
    
   stepper2.run();
   stepper2.moveTo(c*30); 
   
   
   if (stepper2.targetPosition() == stepper2.currentPosition()) {
      test=false;
      stepper2.stop();  
      c++;
    }
    
  }


  stepper1.run();
  stepper1.moveTo(-stepper1Target * kerning);
  
}

void parseData()
{
  stepper1Target = cmdBfr[0];
  stepper2Target = cmdBfr[1];
  servoTarget = cmdBfr[2];

  
}


