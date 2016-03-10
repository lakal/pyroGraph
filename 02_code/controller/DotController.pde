import java.util.Collections;

class DotController {
  PImage img;
  int dotsPerLine;
  int dotsPerColumn;
  int widthOfImage;
  float heightOfImage;
  int dotDistance;
  int size;
  int[] times;

  ArrayList<Dot> dots = new ArrayList<Dot>();
  ArrayList<Dot> dotsSorted = new ArrayList<Dot>();

// ----- CONSTRUCTOR: START
  DotController(PImage _img, int _dotsPerLine, int[] _times) {
    img = _img;
    dotsPerLine = _dotsPerLine;
    widthOfImage = img.width;
    heightOfImage = img.height;
    dotDistance = widthOfImage/dotsPerLine;
    dotsPerColumn = int(ceil(heightOfImage/dotDistance));
    size = dotsPerLine * dotsPerColumn;
    times = _times;

    println("Dots per line: "+dotsPerLine);
    println("Dots per Column: "+dotsPerColumn);
    println("Dots total: "+dotsPerLine*dotsPerColumn);

    unsortedImage();
    sortedImage();

  }
// ----- CONSTRUCTOR: END

// ----- UNSORTED IMAGE: START
  private void unsortedImage() {
    img.loadPixels();
    
    for (int y=0; y < heightOfImage; y += dotDistance) { 
      int tempY = int(y/dotDistance);
      for (int x=0; x < widthOfImage; x += dotDistance) {
        int tempX = int(x/dotDistance);
        dots.add( new Dot(tempX, tempY, int(getBrightness(x, y)/dotDistance), times) ); //initialize dot
      }
    }
  }
// ----- UNSORTED IMAGE: END
  
// ----- SORTED IMAGE: START
  private void sortedImage() {
    img.loadPixels();
    for (int y=0; y < heightOfImage; y += dotDistance) { 
      int tempY = int(y/dotDistance);
      
      if((y/dotDistance) % 2 == 0) { // 1,3,5,7,..
        for (int x=0; x < widthOfImage; x += dotDistance) {
          int tempX = int(x/dotDistance);
          dotsSorted.add( new Dot(tempX, tempY, int(getBrightness(x, y)/dotDistance), times) ); //initialize dot
        }
      } else {
        for (int x=widthOfImage; x >= 0; x -= dotDistance) {
          int tempX = int(x/dotDistance);
          dotsSorted.add( new Dot(tempX, tempY, int(getBrightness(x, y)/dotDistance), times) ); //initialize dot
        }
      }
    }
  }
// ----- SORTED IMAGE: END

// ----- HELPER AVERAGE BRIGHTNESS: START
  private int getBrightness(int _x, int _y) {
    int brightnessAvg = 0;
    for (int i = 0; i < dotDistance; i++) { //get the x average
      int locAvg = (_x+i)+ _y * widthOfImage;
      brightnessAvg += int(brightness(img.pixels[locAvg]));
    }
    return brightnessAvg;
  }
// ----- HELPER AVERAGE BRIGHTNESS: END

// ----- RENDERING: START
  public void render(String mode) { 
    if (mode == "SORTED") { 
      for (Dot d : dotsSorted) d.display(dotDistance, dotDistance);
    } else if(mode == "UNSORTED") {
      for (Dot d : dots) d.display(dotDistance, dotDistance);
    }
  }

  public void renderIndividually(int i, String mode) {
    if (mode == "SORTED") {
      dotsSorted.get(i).display( dotDistance, dotDistance );
    } else if (mode == "UNSORTED") { 
      dots.get(i).display( dotDistance, dotDistance );
    }
  }
// ----- RENDERING: END

// ----- GETTERS: START
  public Dot getDot(int i) {
    Dot d = dots.get(i);  
    return d;
  }

  public int getTimeOfDot(int i) {
    int t = dots.get(i).time;  
    return t;
  }
  
  public int getXOfDot(int i) {
    int x = dots.get(i).x;  
    return x;
  }
  
  public int getYOfDot(int i) {
    int y = dots.get(i).y;  
    return y;
  }
  public Dot getDotFromSorted(int i) {
    Dot d = dotsSorted.get(i);  
    return d;
  }
// ----- GETTERS: END
}