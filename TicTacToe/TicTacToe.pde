import ddf.minim.*;
import java.util.Random;
Minim minim;
AudioSample click;
AudioSample error;
Button on_button0;
Button on_button1; // create button 1
Button on_button2; // create button 2
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
static final int AINOBRAINS = 0; // easy aAi
static final int AIDEFENSIVE_ONLY = 1; // AI plays defensively
static final int AIGONNAWHUPYA = 2; // hard AI
static final int MARKER_O = 1;
static final int MARKER_X = 2;
static int playerMarker = MARKER_O;
static int aiMarker = MARKER_X;
int win = 0;  // 1 = player1   2 = player2;
int game = 0;  // 1 = game started
int full = 9;
boolean showOptions;
boolean showRules;
boolean pause;
boolean pause1;
color orange = color(255, 165, 0); //shows blocker cells
color green = color(0, 255, 0); //shows winning cells
color red = color(255, 0, 0); //hovering over filled cell
color purple = color(148, 0, 211); //shows player forks
color grey = color(200, 200, 200); //default hover
color redOrange = color(255, 69, 0); //shows AI forks

void settings() {
  size(400, 400);
}

void setup() {
  noStroke();
  smooth();
  pause = false;
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
  on_button8 = new Button("Hard", 145, 260, 100, 50, click, true); // create button for choosing difficulty  board = new Cell[cols][rows];
  board = new Cell[cols][rows];
  for (int i = 0; i< cols; i++) {
    for ( int j = 0; j < rows; j++) {
      board[i][j] = new Cell(width/3*i, height/3*j, width/3, height/3);
    }
  }
  ai = new AI(board, AINOBRAINS, aiMarker);
}

void draw() {
  background(255);
  
  if(pause){
    delay(1000);
    pause = false;
  }
  
  if (game == 0) {
    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("TIC TAC TOE", width / 2, height / 14);
    text("Main Menu", width / 2, height / 7);
    on_button0.setDisplayed(true);
    on_button3.setDisplayed(true);
    on_button4.setDisplayed(true);
    on_button0.display();
    on_button3.display();
    on_button4.display();  
  }
  //difficulty options screen
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
  //rules screen
  if(game == 3){
    fill(0);
    textSize(18);
    text("Game Rules", width/2, height/8);
    textSize(15);
    text("The rules are as follows:", width/4, height / 2);
    textSize(9);
    textAlign(LEFT);
    text("Green highlight represents a winning square.", width/16, (height / 2) + 35);
    text("Orange highlight represents a square that needs to be blocked.", width/16, (height / 2) + 55);
    text("Red highlight represents a square that you cannot click.", width/16, (height / 2) + 75);
    text("Purple highlight represents a square that would create a fork for you.", width/16, (height / 2) + 95);
    text("Red-orange highlight represents a square that the opponent could create a fork in.", width/16, (height / 2) + 115);
    text("Grey highlight represents the square you are hovering over.", width/16, (height / 2) + 135);
    textSize(18);
    on_button5.setDisplayed(true);
    on_button5.display();
  }
  
  //game start!
  if (game == 1) {
    if(pause){
      delay(250);
    }
    checkGame();  // check if  player win
    for (int y = 0; y<cols; y++) {
      for (int x = 0; x<rows; x++) {
        board[y][x].display();
        if(board[y][x].isInside()){
          if(board[y][x].checkState() != 0){
            board[y][x].setHighlight(red);
          } else {
            board[y][x].setHighlight(grey);
          }
          ArrayList<Cell> playerWins = ai.checkWinCondition(playerMarker);
          if(playerWins.size() > 0){
            //display winning cells in green
            for(Cell win : playerWins){
              win.setHighlight(green);
            }
          } else {
            //check 2: block ai wins
            ArrayList<Cell> aiWins = ai.checkWinCondition(aiMarker);
            if(aiWins.size() > 0){
              for(Cell block : aiWins){
                block.setHighlight(orange);
              }
            } else {
              //check 3: show possible forks
              ArrayList<Cell> forks = ai.checkFork(playerMarker);
              if(forks.size() > 0){
                for(Cell fork : forks){
                  fork.setHighlight(purple);
                }
              } else {
                //check 4: show AI forks
                ArrayList<Cell> aiForks = ai.checkFork(aiMarker);
                if(aiForks.size() > 0){
                  for(Cell aiFork: aiForks){
                    aiFork.setHighlight(redOrange);
                  }
                }
              }
            }
          }
        }
      }
    }
    pause = false;
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
          checkGame();
        }
      }
    }
    if (win == 0 && player == 1) {
      draw();
      for(int y = 0; y < board.length; y++){
        for(Cell cell : board[y]){
          cell.setHighlight(color(255, 255, 255));
        }
      }
      pause = true;
      ai.makeMove();
    }
  }
  
  //if you click this button it starts the game
  if (on_button0.isInside()) {
    on_button0.press();
    Random r = new Random(); // RANDOMLY ASSIGN MARKERS
    int rNum = r.nextInt((1-0)+1)+0;
    System.out.println(rNum);
    if(rNum == 0){
       playerMarker = MARKER_O;
       aiMarker = MARKER_X;
    }
    else{
       playerMarker = MARKER_X;
       aiMarker = MARKER_O;
    }
    game = 1; // start game and hide buttons
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
        //if(playerState == MARKER_O){
        //  ai.makeMove();
        //}
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
    on_button4.setDisplayed(false);
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
    ai.setDifficulty(AINOBRAINS);
  }
  
    // DEFENSIVE ONLY difficulty button
  if (on_button7.isInside()) {
    on_button7.press();
    ai.setDifficulty(AIDEFENSIVE_ONLY);
  }
  
    // HARD difficulty button
  if (on_button8.isInside()) {
    on_button8.press();
    ai.setDifficulty(AIGONNAWHUPYA);
  }
}

void checkGame() {
  int row = 0;
  //check horizontal and vertical cells
  for (int col = 0; col< cols; col++) {
    if (board[col][row].checkState() == 1 && board[col][row+1].checkState() == 1 && board[col][row+2].checkState() == 1) {
      if(playerMarker == MARKER_O){
        win = 1;
      } else {
        win = 2;
      }
    } 
    else if (board[row][col].checkState() == 1 && board[row+1][col].checkState() == 1 && board[row+2][col].checkState() == 1) {
      if(playerMarker == MARKER_O){
        win = 1;
      } else {
        win = 2;
      }
    } 
    else if (board[row][col].checkState() == 2 && board[row+1][col].checkState() == 2 && board[row+2][col].checkState() == 2) {
      if(playerMarker == MARKER_O){
        win = 2;
      } else {
        win = 1;
      }
    }
    else if (board[col][row].checkState() == 2 && board[col][row+1].checkState() == 2 && board[col][row+2].checkState() == 2) {
      if(playerMarker == MARKER_O){
        win = 2;
      } else {
        win = 1;
      }
    }
  }

  //check diagonal cells
  if (board[row][row].checkState() == 1 && board[row+1][row+1].checkState() == 1 && board[row+2][row+2].checkState() == 1) {
    if(playerMarker == MARKER_O){
      win = 1;
    } else {
      win = 2;
    }
  } 
  else if (board[row][row].checkState() == 2 && board[row+1][row+1].checkState() == 2 && board[row+2][row+2].checkState() == 2) {
    if(playerMarker == MARKER_O){
      win = 2;
    } else {
      win = 1;
    }
  }
  else if (board[0][row+2].checkState() == 1 && board[1][row+1].checkState() == 1 && board[2][row].checkState() == 1) {
    if(playerMarker == MARKER_O){
      win = 1;
    } else {
      win = 2;
    }
  } 
  else if (board[0][row+2].checkState() == 2 && board[1][row+1].checkState() == 2 && board[2][row].checkState() == 2) {
    if(playerMarker == MARKER_O){
      win = 2;
    } else {
      win = 1;
    }
  }

}
