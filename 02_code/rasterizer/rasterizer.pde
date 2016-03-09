PImage img;
String pathToImage = "";

int dotsPerLine = 100;
int dotDistance = 0;

void setup() {
  background(240);
  size(600, 1000);
  dotDistance = width/dotsPerLine;
  //  selectInput("Select a file to process:", "getImage"); 
  img = loadImage("test.jpg");
  img.resize(width, 0);
  analyzeImage();
  image(img, 0, img.height);
}

void draw() {
}

void getImage(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    pathToImage = selection.getAbsolutePath();
  }
}

void analyzeImage() {
  pushStyle();
  noStroke();
  img.loadPixels();  
  for (int x = 0; x < img.width; x+=dotDistance) {
    for (int y = 0; y < img.height; y+=dotDistance) {
      int loc = x + y * img.width;
      
      float brightnessAvg = 0;
      int c = 0;
      for (int i = 0; i < dotDistance; i++) {
        for (int j=0; j < dotDistance; j++) {
          int locAvg = ((x+i)+ (y+j) * img.width);
          brightnessAvg += int(brightness(img.pixels[locAvg]));
          
          c++;
        }
      }
      println(img.pixels.length);
      println(c);
      int br = int(brightnessAvg/c);
      //println(c);
      //int br = int(brightness(img.pixels[loc]));

      fill(br);
      rect(x, y, dotDistance, dotDistance);
    }
  }  
  popStyle();
}