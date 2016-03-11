#include <AccelStepper.h>
#include <AFMotor.h>
#include <Servo.h>
Servo servo;



AF_Stepper motor1(48, 1);
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

void setup()
{
  Serial.begin(57600);
  stepper1.setMaxSpeed(3000);
  stepper1.setAcceleration(2000);

  stepper2.setMaxSpeed(2000);
  stepper2.setAcceleration(1000);

  servo.attach(10);
  servo.write(30);
}

void loop()
{
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

  if (servoTarget == 1) {
    servoPos = 0;
  }
  else {
    servoPos = 30;
  }
  /*

  servo.write(servoPos);
  stepper1.run();
  stepper1.moveTo(stepper1Target * kerning);
*/
  if (line == 0) {
    linePos = stepper2Target;
    stepper2.moveTo(100);
    
  }


  if (stepper2Target == linePos) {

    /*
    if (stepper2.targetPosition() == stepper2.currentPosition()) {
      line++;
      linePos = stepper2Target;
    }
    */
  }
  if(stepper2Target < linePos){
    stepper2.run();
    stepper2.moveTo(300);
  }

}

void parseData()
{
  stepper1Target = cmdBfr[0];
  stepper2Target = cmdBfr[1];
  servoTarget = cmdBfr[2];
}


