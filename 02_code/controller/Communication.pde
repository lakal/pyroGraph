import processing.serial.*;

Serial myPort;

class Communication {

  Communication( int port, int baudrate ) {
    printArray(Serial.list());
    myPort = new Serial(controller.this, Serial.list()[port], baudrate);
  }
  void sendData(int z, int x, int y) {
    myPort.write(x);
    myPort.write(y);
    myPort.write(z);
   // println("servo: "+z+"\t"+"\t"+"motorX: "+motorX+"\t"+"\t"+"motorX: "+motorX);
  }
}