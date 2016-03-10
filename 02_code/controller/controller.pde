PImage img;
int dotsPerLine = 30;
DotController d;
Communication c;

int[] time = {0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1100};

int servo = 125;
int motorY = 0;
int motorX = 0;
int count = 0;

void setup() {
  size(400, 800);
  background(255);
  img = loadImage("testGradient.jpg"); 
  img.resize(width, 0);
  d = new DotController(img, dotsPerLine, time);
  c = new Communication(3, 57600);
}

void draw() {
  //println(d.dots.get(0));
  count++;
  image(img, 0, 0);

  pushMatrix();
  translate(0, img.height+20);

  for (int i = 0; i< d.dots.size(); i++) {
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
          c.sendData(servo, motorX, motorY);
        }
        servo = 0;
        delay(dot.time);    // grayscale
  
        c.sendData(servo, motorX, motorY);
        
        motorX = i;
        
        c.sendData(servo, i, motorY);
        delay(1400);  // wait for motor
  
        println(dot.time+"\t"+i);
      }
      
      
      
      println("line: "+j);
      delay(10000);
    }
    
    popMatrix();
  }
}

void test(int range) {
  image(img, 0, 0);

  pushMatrix();
  translate(0, img.height+20);

  for (int i = 0; i< range; i++) {
    d.renderIndividually(i, "SORTED");  
    // println(d.getTimeOfDot(i));
  }
  popMatrix();
}

void keyPressed() {
  if (count < d.size) count++;
}