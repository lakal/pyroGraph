import processing.serial.*;
int[][] mPixels; 
PImage mImage;
Serial myPort;

int rowCount = 0;
int pixelCount = 0;
int runCount = 0;
int dots_pr_H = 0;
int row = 0;
int col = 0;
int dots = 100;      // only even numbers


int x = 0;
int y = 0;
int z = 0;

int[] time = {0, 100, 200, 350, 500, 750, 900, 1050, 1300, 1800, 3000};

boolean debug = false;

void setup() { 
  background(255);
  size(500, 1081);
  noStroke();
  printArray(Serial.list());
  
  if(debug == false){myPort = new Serial(this, Serial.list()[3], 115200);}
  mImage = loadImage("data/uss.jpg");
  
  int res = mImage.width/dots;
  dots_pr_H = mImage.height/res;
  
  mPixels = new int[dots_pr_H][dots];
  
  
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
      //println(y);
      mPixels[y][x] = avg/(res*res);
      pixelCount++;
    }
  }
  mImage.resize(width/2,0);
  image(mImage, 0, 0);
  
  // flip every secound row
  for(int i=0; i < mPixels.length; i++){
    if(i%2!=0){mPixels[i] = reverse(mPixels[i]);}
  } 
  row = rowCount-1;
  
  if(debug == true){
    int s = width/dots/2;
    translate(width/2+s/2, 0);
    for(int i=0; i<mPixels.length; i++){
       for(int j=0; j<dots; j++){
         fill(mPixels[i][j]); 
       
         if(i%2==0){ellipse(j*s, i*s, s, s);;}
         if(i%2!=0){ellipse((dots*s)-(j*s)-s, i*s, s, s);}
      }
    }
  }
}

void draw() {
  
  int s = width/dots/2;
  translate(width/2+s/2, 0);
  
  fill(mPixels[row][col]); 
  if(row%2==0){ellipse(col*s, row*s, s, s);}
  if(row%2!=0){ellipse((dots*s)-(col*s)-s, row*s, s, s);}
  
  y = runCount;
  x = 0;
  z = time[(int) map(mPixels[row][col],0,255,10,0)];
  
  if(mPixels.length%2==0){
    if(row%2!=0){x = col;}
    if(row%2==0){x = dots-col-1;}
  }
  if(mPixels.length%2!=0){
    if(row%2==0){x = col;}
    if(row%2!=0){x = dots-col-1;}
  }
   
  println("y "+y+"\t"+"x "+x+"\t"+1+"\t"+"t "+z);
  println("y "+y+"\t"+"x "+x+"\t"+0);
  
  if(debug == false){
    
    sendData(x,y,0);
    
    if(z != 0){
     delay(400);
     sendData(x,y,1);
    } 
    
    delay(150);
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