class Dot {
  int x;
  int y;
  int fill;
  int[] times;
  int time; //milliseconds
  
  Dot(int _x, int _y, int _brightnessAvg, int[] _times) {
    x = _x;
    y = _y;
    fill = _brightnessAvg;
    times = _times;
    time = times[int(map(fill, 0, 255, 0, times.length))];
  }
  
  public void display(int size) {
    pushStyle();
      noStroke();
      fill(fill);
      rect(x,y,size,size);
    popStyle();
  }

}