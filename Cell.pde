import ddf.minim.*;

class Cell {
  int x;
  int y ;
  int w;
  int h;
  int state = 0;
  AudioSample error = minim.loadSample("error.wav", 2048);

  Cell(int tx, int ty, int tw, int th) {
    x = tx;
    y = ty;
    w = tw;
    h = th;
  }

  void click(int tx, int ty) {
    int mx = tx;
    int my = ty;
    if (mx > x && mx < x+w && my > y && my < y+h) {
      //player's turn
      if (player == 0 && state == 0) {
        state = 1;
        full -= 1;
        player = 1; //set to computer's turn
      } 
      //TODO make "ai" choose random available cell
      //computer's turn
      else if (player == 1 && state == 0) {
        state = 2;
        full -= 1;
        player = 0; // set to player's turn
      }
      else {
        error.trigger();
      }
    }
  }
  
  void clean(){
    state = 0;  
  }
  
  int checkState(){
    return state;  
  }
  
  int checkX(){
    return x;  
  }
  
  int checkY(){
    return y;  
  }

  void display() {
    noFill();
    stroke(0);
    strokeWeight(3);
    rect(x, y, w, h);
    if (state == 1) {
      ellipseMode(CORNER);
      stroke(0, 0, 0);
      ellipse(x + 7, y + 7, w - 14, h - 14);
    } 
    else if ( state == 2) {
      stroke(0, 0, 0);
      line(x, y, x+w, y+h); 
      line(x+w, y, x, y+h);
    } 
  }
}
