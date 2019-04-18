import ddf.minim.*;
Minim minim;
AudioSample click;
AudioSample error;
Button on_button0;
Button on_button1;
Button on_button2; 
Button on_button3;
Button on_button4;
Button on_button5;
Button on_button6;
Button on_button7;
Button on_button8;

Cell[][] board;
AI ai;
int cols = 3;
int rows = 3;
int player = 0; //0 = player1
static final int AINOBRAINS = 0; // easy AI
static final int AIDEFENSIVE_ONLY = 1; // AI plays defensively
static final int AIGONNAWHUPYA = 2; // hard AI
int win = 0;  // 1 = player1   2 = player2;
int game = 0;  // 1 = game started
int full = 9;
static final int MARKER_O = 0;
static final int MARKER_X = 1;
boolean showOptions; //for options menu
boolean showRules; // for rules menu

void settings() {
  size(400, 400);
}

void setup() {
  noStroke();
  smooth();
  minim = new Minim(this);
  click = minim.loadSample("click.wav", 2048);
  error = minim.loadSample("error.wav", 2048);
  on_button0 = new Button("Play", 80, 100, 100, 50, click, true); // create play button for menu
  on_button1 = new Button("Menu", 80, 100, 100, 50, click, true); // create play button for after game
  on_button2 = new Button("Quit", 210, 100, 100, 50, click, false); // create quit button object
  on_button3 = new Button("Options", 210, 100, 100, 50, click, true); // create options button object
  on_button4 = new Button("Rules", 145, 170, 100, 50, click, true); // create rules button object
  on_button5 = new Button("Back", 145, 100, 100, 50, click, true); // create back button object
  on_button6 = new Button("Easy", 145, 190, 100, 50, click, true); // create button for choosing difficulty
  on_button7 = new Button("Defensive", 145, 330, 100, 50, click, true); // create button for choosing difficulty
  on_button8 = new Button("Hard", 145, 260, 100, 50, click, true); // create button for choosing difficulty
  board = new Cell[cols][rows];
  for (int i = 0; i< cols; i++) {
    for ( int j = 0; j < rows; j++) {
      board[i][j] = new Cell(width/3*i, height/3*j, width/3, height/3);
    }
  }
  ai = new AI(board, AINOBRAINS);
}

void draw() {
  background(255);
  // main menu
  if (game == 0) {
    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("MAIN MENU", width / 2, height / 8);
    on_button0.setDisplayed(true);
    on_button3.setDisplayed(true);
    on_button4.setDisplayed(true);
    on_button0.display();
    on_button3.display();
    on_button4.display();
  }
  // difficulty options screen
  if(game == 2){
    fill(0);
    textSize(18);
    text("Please Choose From the Options", width/2, height / 7);
    on_button7.setDisplayed(true);
    on_button6.setDisplayed(true);
    on_button8.setDisplayed(true);
    on_button5.setDisplayed(true);
    on_button7.display();
    on_button6.display();
    on_button8.display();
    on_button5.display();
  }
  // rules screen
  if(game == 3){
    fill(0);
    textSize(18);
    text("RULES", width/2, height/8);
    textSize(15);
    text("The rules are as follows:", width/4, height / 2);
    textSize(13);
    text("Green cell highlight represents", width/3, (height / 2) + 20);
    text("Yellow cell highlight represents", width/3, (height / 2) + 40);
    text("Red cell highlight represents", width/3, (height / 2) + 60);
    on_button5.setDisplayed(true);
    on_button5.display();
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
    if (win == 0 && player == 1) {
      ai.makeMove();
    }
  }
  
  //if you click this button it starts the game
  if (on_button0.isInside()) {
    on_button0.press();
    game = 1; // start again
    for (int i = 0; i<cols; i++) {
      for (int j = 0; j<rows; j++) {
        board[i][j].clean();
        on_button0.setDisplayed(false);
        on_button1.setDisplayed(false);
        on_button2.setDisplayed(false); 
        on_button3.setDisplayed(false);
        on_button4.setDisplayed(false);
        on_button5.setDisplayed(false);
        on_button6.setDisplayed(false);
        on_button7.setDisplayed(false);
        on_button8.setDisplayed(false);
        win = 0;
        full = 9;
        player = 0;
      }
    } 
  }
  
  // if you click play button takes you back to main menu
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
        player = 0;
      }
    } 
  }
  // if you press quit button quits game
  if (on_button2.isInside()) {
    on_button2.press();
  }
  
  //options button
  if (on_button3.isInside()) {
    on_button3.press();
    game = 2; // take you to options screen
    on_button0.setDisplayed(false);
    on_button3.setDisplayed(false);
  }
  
   //rules button
  if (on_button4.isInside()) {
    on_button4.press();
    game = 3; // start again
    showRules = true; 
    on_button0.setDisplayed(false);
    on_button2.setDisplayed(false);
  }
  
  // back button
  if (on_button5.isInside()) {
    on_button5.press();
    showOptions = false; //stops displaying options menu
    showRules = false;
    game = 0; // takes you back to main menu
  }
  
    // EASY difficulty button
  if (on_button6.isInside()) {
    on_button6.press();
    //ai.setDifficulty(AINOBRAINS);
  }
  
    // DEFENSIVE ONLY difficulty button
  if (on_button7.isInside()) {
    on_button7.press();
    //ai.setDifficulty(AIDEFENSIVE_ONLY);
  }
  
    // HARD difficulty button
  if (on_button8.isInside()) {
    on_button8.press();
    //ai.setDifficulty(AIGONNAWHUPYA);
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
          on_button0.setDisplayed(false);
          on_button1.setDisplayed(false);
          on_button2.setDisplayed(false); 
          on_button3.setDisplayed(false);
          on_button4.setDisplayed(false);
          on_button5.setDisplayed(false);
          on_button6.setDisplayed(false);
          on_button7.setDisplayed(false);
          on_button8.setDisplayed(false);
          win = 0;
          full = 9;
          player = 0;
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
          on_button0.setDisplayed(false);
          on_button1.setDisplayed(false);
          on_button2.setDisplayed(false); 
          on_button3.setDisplayed(false);
          on_button4.setDisplayed(false);
          on_button5.setDisplayed(false);
          on_button6.setDisplayed(false);
          on_button7.setDisplayed(false);
          on_button8.setDisplayed(false);
          win = 0;
          full = 9;
          player = 0;
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
