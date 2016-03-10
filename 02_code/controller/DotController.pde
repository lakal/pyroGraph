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

    analyzeImage();
    sortDots();
    
    Collections.reverse(dots); // magic!
    Collections.reverse(dotsSorted); // magic!
  }
// ----- CONSTRUCTOR: START

// ----- GENERATE ARRAY FROM IMAGE: START
// ----- loop through the image and calculate average from sections
  private void analyzeImage() { 
    img.loadPixels();
    for (int y=0; y < heightOfImage; y += dotDistance) { 
      for (int x=0; x < widthOfImage; x += dotDistance) {
        float brightnessAvg = 0;
        for (int i = 0; i < dotDistance; i++) { //get the x average
          int locAvg = ((x+i)+ y * widthOfImage);
          brightnessAvg += int(brightness(img.pixels[locAvg]));
        }
        dots.add( new Dot(x, y, int(brightnessAvg/dotDistance), times) ); //initialize dot
      }
    }
  }
// ----- GENERATE ARRAY FROM IMAGE: END

// ----- SORTER: START
// ----- sort rows so that uneven lines are printed from right to left
  private void sortDots() {
    int rowCount = 0; // keep track of the rows
    for (int x=0; x < dots.size(); x+= dotsPerLine) {
      if ((rowCount % 2) == 0) { // 1,3,5,7,.. are just copied
       if(debug) println("--> "+ x + "-" + ((rowCount+1)*dotsPerLine-1));
        int dotRange = (rowCount+1)*dotsPerLine;

        for (int i=x; i< dotRange; i++ ) {
          dotsSorted.add( dots.get(i) );
        }
      } else { // 2,4,6,8,.. reverse!
        if(debug) println("<.. "+ x + "-" + ((rowCount+1)*dotsPerLine-1));
        int dotRange = (rowCount+1)*dotsPerLine;

        ArrayList<Dot> tempDots = new ArrayList<Dot>(); // create temporary array to flip

        for (int i=x; i < dotRange; i++) {
          tempDots.add(dots.get(i)); 
        }
        
        Collections.reverse(tempDots); // magic!

        for (int i=x; i < dotRange; i++) {
          dotsSorted.add(tempDots.get(i-x)); // add the reversed dots
        }   
        tempDots.clear(); //clean up, just in case
      }
      rowCount++;
    }
  }
// ----- SORTER: END

// ----- SORTER: START
// ----- sort rows so that uneven lines are printed from right to left
  private void sortDots2() {
    
  }
// ----- SORTER: END


// ----- RENDERING: START
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

  public Dot getDotFromSorted(int i) {
    Dot d = dotsSorted.get(i);  
    return d;
  }
// ----- GETTERS: END  
}