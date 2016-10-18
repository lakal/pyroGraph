import processing.serial.*;
int[][] mPixels; 
PImage mImage;
Serial myPort;

int rowCount = 0;
int pixelCount = 0;
int runCount = 0;
int row = 0;
int col = 0;
int dots = 100;      // only even numbers

int x = 0;
int y = 0;
int z = 0;

int[] time = {0, 100, 200, 350, 500, 750, 900, 1050, 1300, 1500, 2000};

boolean debug = true;

void setup() { 
  background(255);
  size(400, 800);
  noStroke();
  printArray(Serial.list());
  
  if(debug == false){myPort = new Serial(this, Serial.list()[3], 115200);}

  mImage = loadImage("data/city+human2.jpg");
  mPixels = new int[dots][dots];
  int res = mImage.width/dots;
  for (int y = 0; y < mImage.height/res; y++) {
    rowCount++;
    for (int x = 0; x < mImage.width/res; x++) {     
      int loc = (x*res) + (y*res) * mImage.width;
      
      int avg = 0;
      for(int i = 0; i < res; i++){
        for(int j = 0; j < res; j++){
          avg += (int) brightness(mImage.pixels[loc+i+(j*mImage.width)]);
        }
      }
      mPixels[y][x] = avg/(res*res);
      pixelCount++;
    }
  }
  image(mImage, 0, 0, mImage.width/res,mImage.height/res);
  
  // flip every secound row
  for(int i=0; i < mPixels.length; i++){
    if(i%2!=0){mPixels[i] = reverse(mPixels[i]);}
  } 
  row = rowCount-1;
}

void draw() {
  
  int s = width/dots;
  translate(s/2, dots*s+s/2);
  
  fill(mPixels[row][col]); 
  if(row%2==0){ellipse(col*s, row*s, s, s);}
  if(row%2!=0){ellipse((dots*s)-(col*s)-s, row*s, s, s);}
  
  y = runCount;
  x = 0;
  z = time[(int) map(mPixels[row][col],0,255,10,0)];
  
  if(row%2!=0){x = col;}
  if(row%2==0){x = dots-col-1;}
  
  println("y "+y+"\t"+"x "+x+"\t"+1+"\t"+"t "+z);
  println("y "+y+"\t"+"x "+x+"\t"+0);
  
  if(debug == false){
    
    sendData(x,y,0);
    
    if(z != 0){
     delay(500);
     sendData(x,y,1);
    } 
    
    delay(200);
    delay(z);
  }
  
  col++;
  if(col == dots){
    row--; 
    col=0;
    runCount++;
  }
  
  if (runCount == rowCount){
    noLoop();
  }
}

void sendData(int x, int y, int z) {
  if(debug == false){
    myPort.write(x);
    myPort.write(y);
    myPort.write(z);
  }
}