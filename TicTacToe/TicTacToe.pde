import ddf.minim.*;
import java.util.Random;
import java.util.ArrayDeque;

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
AI ai = new AI(board, AINOBRAINS, aiMarker);
int wins = 0;
int losses = 0;
int ties = 0;
int cols = 3;
int rows = 3;
int player = 0; //0 = player1
boolean gameCounted = false;
static ArrayDeque<Cell> moveStack = new ArrayDeque<Cell>();
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
color purple = color(148, 0, 211); //shows ai forks
color grey = color(200, 200, 200); //default hover
color blue = color(0, 140, 255); //shows player forks

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
  //ai = new AI(board, AINOBRAINS, aiMarker);
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
    fill(green);
    text("Green highlight represents a square that wins you the game.", width/16, (height / 2) + 35);
    fill(orange);
    text("Orange highlight represents a square that blocks the opponent from winning.", width/16, (height / 2) + 55);
    fill(red);
    text("Red highlight represents a square that you cannot click.", width/16, (height / 2) + 75);
    fill(blue);
    text("Blue highlight represents a square that would create a fork for you.", width/16, (height / 2) + 95);
    fill(purple);
    text("Purple highlight represents a square that prevents the opponent from forking you.", width/16, (height / 2) + 115);
    fill(grey);
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
                  fork.setHighlight(blue);
                }
              } else {
                //check 4: show AI forks
                ArrayList<Cell> aiForks = ai.checkFork(aiMarker);
                if(aiForks.size() == 1){
                  aiForks.get(0).setHighlight(purple);
                } else if(aiForks.size() > 1){
                  
                  for(int y1 = 0; y1 < board.length; y1++){
                    for(int x1 = 0; x1 < board[y1].length; x1++){
                      Cell possibleOut = board[y1][x1];
                      if(possibleOut.checkState() == 0){
                        possibleOut.state = playerMarker;
                        ArrayList<Cell> oneStepAhead = ai.checkWinCondition(playerMarker);
                        //check if this particular cell gives 2 in a row
                        if(oneStepAhead.size() == 1){
                          for(Cell oSA : oneStepAhead){
                            boolean winnable = true;
                            for(Cell fork : aiForks){
                              if(fork.checkX() == oSA.checkX() && fork.checkY() == oSA.checkY()){
                                winnable = false;
                                break;
                              }
                            }
                            if(winnable){
                              possibleOut.state = 0;
                              possibleOut.setHighlight(purple);
                            }
                          }
                        }
                        possibleOut.state = 0;
                      }
                    }
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
  
  if (win == 1 || win == 2 || (win == 0 && full == 0) || win == 3){
    background(255);
    game = 4;
    on_button1.setDisplayed(true);
    on_button2.setDisplayed(true);
    on_button1.display();
    on_button2.display();
  }
  
  // player win
  if (win == 1) {
    fill(green);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("You won!", width / 2, height / 8);
    displayStats();
  }
  
  // ai win
  if (win == 2) {
    fill(red);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("You Lost!", width / 2, height / 8);
    displayStats();
  }
  
  // tie game
  if (win == 3) {
    fill(orange);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("You Tied!", width / 2, height / 8);
    displayStats();
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
    gameCounted = false;
    moveStack.clear();
    Random r = new Random(); // RANDOMLY ASSIGN MARKERS
    int rNum = r.nextInt((1-0)+1)+0;
    if(rNum == 0){
       playerMarker = MARKER_O;
       int diff = ai.difficulty;
       aiMarker = MARKER_X;
       ai = new AI(board, diff, aiMarker);
    }
    else{
       playerMarker = MARKER_X;
       int diff = ai.difficulty;
       aiMarker = MARKER_O;
       ai = new AI(board, diff, aiMarker);
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
      }
    } 
    if(playerMarker == MARKER_X){
      player = 0;
    } else {
      player = 1;
      ai.makeMove();
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

//ctrl+z undos the last 2 moves made
//can only be done on player turn
//cannot undo ai move if ai goes first
void keyPressed(){
  if(key == 26){
    if(full < 8 && player == 0){
      Cell clear1 = moveStack.pop();
      Cell clear2 = moveStack.pop();
      clear1.clean();
      clear2.clean();
      full += 2;
    } else {
      error.trigger();
    }
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
  if(win == 1 && !gameCounted){
    wins++;
    gameCounted = true;
  } else if(win == 2 && !gameCounted){
    losses++;
    gameCounted = true;
  } else if(win == 0 && full == 0){
    win = 3;
    if(!gameCounted){
      ties++;
      gameCounted = true;
    }
  }
}

void displayStats(){
  textSize(20);
  fill(green);
  text("Total wins: " + wins, width / 2, height / 2);
  fill(red);
  text("Total losses: " + losses, width / 2, height / 2 + 35);
  fill(orange);
  text("Total ties: " + ties, width / 2, height / 2 + 70);
  fill(green);
  int winrate = round((float)wins / ((float)wins + (float)losses + (float)ties) * 100.0);
  if(winrate >= 66){
    fill(green);
  } else if(winrate <= 33){
    fill(red);
  } else {
    fill(orange);
  }
  text("Winrate: " + winrate + "%", width / 2, height / 2 + 105);
  fill(0);
  text("Turns taken: " + ceil((float)moveStack.size() / 2.0), width / 2, height / 2 + 140);
}
