import ddf.minim.*;
Minim minim;
AudioSample click;
AudioSample error;
Button on_button1; // create button 1
Button on_button2; // create button 2
Cell[][] board;
AI ai;
int cols = 3;
int rows = 3;
int player = 0; //0 = player1
int difficulty = 0; //0 = easy AI
int win = 0;  // 1 = player1   2 = player2;
int game = 0;  // 1 = game started
int full = 9;

void settings() {
  size(400, 400);
}

void setup() {
  noStroke();
  smooth();
  minim = new Minim(this);
  click = minim.loadSample("click.wav", 2048);
  error = minim.loadSample("error.wav", 2048);
  on_button1 = new Button("Play", 80, 80, 100, 50, click, true); // create button object
  on_button2 = new Button("Quit", 210, 80, 100, 50, click, false); // create second button object
  board = new Cell[cols][rows];
  for (int i = 0; i< cols; i++) {
    for ( int j = 0; j < rows; j++) {
      board[i][j] = new Cell(width/3*i, height/3*j, width/3, height/3);
    }
  }
  ai = new AI(board, difficulty);
}

void draw() {
  background(255);
  if (game == 0) {
    fill(0);
    textSize(20);
    text("Press ENTER to Start", width / 2, height / 2);
  }

  //game start!
  if (game == 1) {
    checkGame();  // check if  player win
    for (int i = 0; i<cols; i++) {
      for (int j = 0; j<rows; j++) {
        board[i][j].display();
      }
    }
  }
  
  if (win == 1 || win == 2 || (win == 0 && full == 0)){
    background(255);
    on_button1.setDisplayed(true);
    on_button2.setDisplayed(true);
    on_button1.display();
    on_button2.display();
  }
  
    // player win
  if (win == 1) {
    fill(255, 140, 0);
    textSize(20);
    textAlign(CENTER, CENTER);
    //text(" You won! \nPress Enter \nto play again.", width/2-width/2+23, height/2-height/6-20);
    text("You won!\nPlay again?", width / 2, height / 2);
  }
  
  // ai win
  if (win == 2) {
    fill(255, 140, 0);
    textSize(20);
    textAlign(CENTER, CENTER);
    //text(" You Lost! \nPress Enter \nto play again.", width/2-width/2+23, height/2-height/6-20);
    text("You Lost!\nPlay again?", width / 2, height / 2);
  }
  
  // tie game
  if ( win == 0 && full == 0) {
    fill(255, 140, 0);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("You Tied!\nPlay again?", width / 2, height / 2);
  }
}

//mouse & key functions
void mousePressed() {
  if (game == 1) {
    if (win == 0) {
      for (int i = 0; i<cols; i++) {
        for (int j = 0; j<rows; j++) {
          board[i][j].click(mouseX, mouseY);
        }
      }
    }
    ai.makeMove();
  }
  // if you click play button restart game
  if (on_button1.isInside()) {
    on_button1.press();
    game = 0; // start again
    for (int i = 0; i<cols; i++) {
      for (int j = 0; j<rows; j++) {
        board[i][j].clean();
        on_button1.setDisplayed(false);
        on_button2.setDisplayed(false);
        win = 0;
        full = 9;
      }
    } 
  }
  // if you press quit button quits game
  if (on_button2.isInside()) {
    on_button2.press();
  }
}

void keyPressed() {
  if (game == 0) {
    if (key == ENTER) {
      game =1; //let's play
      full = 9;
    }
  } 
  else if (game == 1 && win == 0 && full == 0 ) {
    if (key == ENTER) {
      game = 0; // start again
      for (int i = 0; i<cols; i++) {
        for (int j = 0; j<rows; j++) {
          board[i][j].clean();
          on_button1.setDisplayed(false);
          on_button2.setDisplayed(false);
          win = 0;
          full = 9;
        }
      }
    }
  }
  else if (game == 1 && (win == 1 || win ==2)) {
    if (key == ENTER) {
      game = 0; // start again
      for (int i = 0; i<cols; i++) {
        for (int j = 0; j<rows; j++) {
          board[i][j].clean();
          on_button1.setDisplayed(false);
          on_button2.setDisplayed(false);
          win = 0;
          full = 9;
        }
      }
    }
  }
}

void checkGame() {
  int row = 0;
  //check horizontal and vertical cells
  for (int col = 0; col< cols; col++) {
    if (board[col][row].checkState() == 1 && board[col][row+1].checkState() == 1 && board[col][row+2].checkState() == 1) {
      win = 1;
    } 
    else if (board[row][col].checkState() == 1 && board[row+1][col].checkState() == 1 && board[row+2][col].checkState() == 1) {
      win = 1;
    } 
    else if (board[row][col].checkState() == 2 && board[row+1][col].checkState() == 2 && board[row+2][col].checkState() == 2) {
      win = 2;
    }
    else if (board[col][row].checkState() == 2 && board[col][row+1].checkState() == 2 && board[col][row+2].checkState() == 2) {
      win = 2;
    }
  }

  //check diagonal cells
  if (board[row][row].checkState() == 1 && board[row+1][row+1].checkState() == 1 && board[row+2][row+2].checkState() == 1) {
    win = 1;
  } 
  else if (board[row][row].checkState() == 2 && board[row+1][row+1].checkState() == 2 && board[row+2][row+2].checkState() == 2) {
    win = 2;
  } 
  else if (board[0][row+2].checkState() == 1 && board[1][row+1].checkState() == 1 && board[2][row].checkState() == 1) {
    win = 1;
  } 
  else if (board[0][row+2].checkState() == 2 && board[1][row+1].checkState() == 2 && board[2][row].checkState() == 2) {
    win = 2;
  }

}
