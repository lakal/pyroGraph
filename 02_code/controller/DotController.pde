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

  private boolean debug = false;

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

    analyzeImage();
    sortDots();
  }

  private void analyzeImage() { 
    img.loadPixels();
    for (int y=0; y < heightOfImage; y += dotDistance) {
      for (int x=0; x < widthOfImage; x += dotDistance) {
        float brightnessAvg = 0;
        for (int i = 0; i < dotDistance; i++) {
          int locAvg = ((x+i)+ y * widthOfImage);
          brightnessAvg += int(brightness(img.pixels[locAvg]));
        }
        dots.add( new Dot(x, y, int(brightnessAvg/dotDistance), times) );
      }
    }
  }

  private void sortDots() {
    int rowCount = 0;
    for (int x=0; x < dots.size(); x+= dotsPerLine) {
      if ((rowCount % 2) == 0) {
       if(debug) println("--> "+ x + "-" + ((rowCount+1)*dotsPerLine-1));
        int dotRange = (rowCount+1)*dotsPerLine;

        for (int i=x; i< dotRange; i++ ) {
          dotsSorted.add( dots.get(i) );
        }
      } else {
        if(debug) println("<.. "+ x + "-" + ((rowCount+1)*dotsPerLine-1));
        int dotRange = (rowCount+1)*dotsPerLine;

        ArrayList<Dot> tempDots = new ArrayList<Dot>();

        for (int i=x; i < dotRange; i++) {
          tempDots.add(dots.get(i));
        }
        
        Collections.reverse(tempDots);

        for (int i=x; i < dotRange; i++) {
          dotsSorted.add(tempDots.get(i-x));
        }   
        tempDots.clear(); //clean up, just in case
      }
      rowCount++;
    }
  }

  public void render() { 
    for (Dot d : dots) {
      d.display(dotDistance);
    }
  }

  public void renderIndividually(int i, String mode) {
    if (mode == "SORTED") {
      dotsSorted.get(i).display( dotDistance );
    } else if (mode == "UNSORTED") { 
      dots.get(i).display( dotDistance );
    }
  }

  public Dot getDot(int i) {
    Dot d = dots.get(i);  
    return d;
  }
  
  public int getTimeOfDot(int i) {
    int t = dots.get(i).time;  
    return t;
  }

  public Dot getDotFromSorted(int i) {
    Dot d = dotsSorted.get(i);  
    return d;
  }

  public void sendData() {
  }
}