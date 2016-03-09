PImage img;
int dotsPerLine = 50;
DotController d;

int[] time = {0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100};

int count = 0;

void setup() {
  size(400,800);
  background(255);
  img = loadImage("test.jpg"); 
  img.resize(width, 0);
  d = new DotController(img, dotsPerLine, time);
}

void draw() {
  
    test(count);
  if(count < d.size) count++;

}

void test(int range) {
  image(img, 0,0);
  
  pushMatrix();
  translate(0, img.height+20);
  
  for(int i = 0; i< range; i++) {
    d.renderIndividually(i, "SORTED");  
   // println(d.getTimeOfDot(i));
  }
  popMatrix();
}

void keyPressed() {
  if(count < d.size) count++;
}