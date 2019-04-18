import ddf.minim.*;

class Cell {
  int x;
  int y ;
  int w;
  int h;
  int state = 0;
  String highlight;
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
        if (full != 0){
          error.trigger();
        }
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
  
  void setHighlight(){
    if(highlight.equalsIgnoreCase("Green")){
       stroke(0, 77, 13); 
    }
    if(highlight.equalsIgnoreCase("Yellow")){
      stroke(255, 215, 0);
    }
    if(highlight.equalsIgnoreCase("Red")){
      stroke(139, 128, 0);
    }
    rect(x,y,w,h);
  }

  void display() {
    noFill();
    stroke(0);
    strokeWeight(5);
    rect(x, y, w, h);
    if (state == 1) {
      ellipseMode(CORNER);
      stroke(0, 0, 0);
      ellipse(x + 9, y + 9, w - 18, h - 18);
    } 
    else if ( state == 2) {
      stroke(0, 0, 0);
      line(x+9, y+9, (x+w)-9, (y+h)-9); 
      line((x+w)-9, y+9, x+9, (y+h)-9);
    } 
  }
}
