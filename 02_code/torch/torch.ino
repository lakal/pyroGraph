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

AccelStepper stepperX(forwardstep1, backwardstep1);
AccelStepper stepperY(forwardstep2, backwardstep2);


char cmdBfr[] = {0, 0, 0};
uint8_t bfrIndx = 0;

int stepperXTarget = 0;
int stepperYTarget = 0;
int servoTarget = 0;
int servoPos = 30;
int linePos;
int line = 0;
int lineHight = 100;
int kerning = 30;
int c = 0;
int prevPos = 0;
int curPos = 0;

boolean test = false;

void setup()
{
  Serial.begin(115200);
  stepperX.setMaxSpeed(2000);
  stepperX.setAcceleration(1000);

  stepperY.setMaxSpeed(2000);
  stepperY.setAcceleration(1000);

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

 
  curPos = stepperYTarget;

  if (curPos != prevPos) {
    test = true;
    prevPos = curPos;
  }


  if (test == true) {

    stepperY.run();
    stepperY.moveTo(c * 30);


    if (stepperY.targetPosition() == stepperY.currentPosition()) { //on arrival
      test = false;
     // stepperY.stop();
      c++;
    }

  } else {
    
    

  stepperX.run();
  stepperX.moveTo(-stepperXTarget*kerning);
  }
}

void parseData()
{
  stepperXTarget = cmdBfr[0];
  stepperYTarget = cmdBfr[1];
  servoTarget = cmdBfr[2];


}



