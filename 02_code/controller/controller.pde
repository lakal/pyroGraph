PImage img;
int dotsPerLine = 40;
DotController d;
Communication c;

int[] time = {0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1100};

int servo = 125;
int motorY = 0;
int motorX = 0;

int count = 0;
float estimatedTime = 0;

boolean debug = true;

void setup() {
  size(400, 800);
  
  background(255);
  img = loadImage("testGradient.jpg"); 
  img.resize(width, 0);
  d = new DotController(img, dotsPerLine, time);
  
  for(int i=0; i< d.dotsSorted.size(); i++) {
    estimatedTime += d.getTime(i, "SORTED");
    estimatedTime += 1400;
  }
  
  println("\n\n------------------------ \nEstimated Time: "+nf((estimatedTime/1000)/60, 0, 2)+" Minutes\n------------------------\n\n");
  
  if(debug) { println("DEBUG MODE"); } else { c = new Communication(3, 57600); }
  
  tint(255, 100, 100, 200);
  image(img, 0, 0);
}

void draw() {
  burnImage();
}

void burnImage() {
  if ( count < d.dotsSorted.size() ) {

    d.renderIndividually(count, "SORTED");  

    motorY = d.getY(count, "SORTED");
    motorX = d.getX(count, "SORTED");
    servo = 1;

    if ( d.getTime(count, "SORTED" ) != 0) {
      servo = 1;   
      //c.sendData(servo, motorX, motorY);
      if(debug) { println(servo+"  "+motorX+"  "+motorY); } else { c.sendData(servo, motorX, motorY); }; 
    }
    servo = 0;
    delay( d.getTime(count, "SORTED" ));
    
    if(debug) { println(servo+"  "+motorX+"  "+motorY); } else { c.sendData(servo, motorX, motorY); }; 

    delay(1400);  // wait for motor
  } else { 
   // println("done");
  }
  count++;
}




/*
void draw() {
 
 //println(d.dots.get(0));
 count++;
 image(img, 0, 0);
 
 pushMatrix();
 translate(0, img.height+20);
 
 for (int i = 0; i< d.dotsSorted.size(); i++) {
 d.renderIndividually(i, "SORTED");  
 // println(d.getTimeOfDot(i));
 }
 popMatrix();
 
 if (count==10) {
 
 pushMatrix();
 translate(0, img.height+20);
 print();
 
 for(int j = 0; j<d.dotsPerColumn; j++){
 motorY = j;
 for (int i = 1; i<dotsPerLine; i++) {
 
 Dot dot = d.dots.get(i);
 d.renderIndividually(i, "SORTED");  
 
 if (dot.time != 0) {
 servo = 1;   
 //  c.sendData(servo, motorX, motorY);
 }
 servo = 0;
 delay(dot.time);    // grayscale
 
 // c.sendData(servo, motorX, motorY);
 
 motorX = i;
 
 //  c.sendData(servo, i, motorY);
 delay(1400);  // wait for motor
 
 println(dot.time+"\t"+i);
 }
 
 
 
 println("line: "+j);
 delay(10000);
 }
 
 popMatrix();
 } 
 }*/