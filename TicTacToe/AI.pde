class AI {
  int difficulty;
  Cell[][] cells;
  int marker;
  
  AI(Cell[][] cell, int diff, int mark){
    cells = cell;
    difficulty = diff;
    marker = mark;
  }
  
  void makeMove(){
      if(player == 1 && full > 0){
          if(difficulty == 0){
            while(player == 1){
              int cellX = int(random(cells[0].length));
              int cellY = int(random(cells.length));
              Cell toBeChecked = cells[cellX][cellY];
              if(toBeChecked.checkState() == 0){
                toBeChecked.click(toBeChecked.checkX() + 1, toBeChecked.checkY() + 1);
              }
            }
          } else if(difficulty == 1){
            //TODO: MEDIUM
          } else if(difficulty == 2){
            int playerMarker = (marker == 1 ? 2 : 1);
            
            //1.) Check if AI can win
            ArrayList<Cell> aiWins = checkWinCondition(marker);
            if(aiWins.size() > 0){
              Cell firstWin = aiWins.get(0);
              firstWin.click(firstWin.checkX() + 1, firstWin.checkY() + 1);
              print("AI found win");
              return;
            }
            //2.) Check if AI needs to block
            if(player == 1){
              ArrayList<Cell> playerWins = checkWinCondition(playerMarker);
              if(playerWins.size() > 0){
                Cell firstBlock = playerWins.get(0);
                firstBlock.click(firstBlock.checkX() + 1, firstBlock.checkY() + 1);
                print("AI blocked win");
                return;
              }
            }
            //3.) Check if AI can fork
            if(player == 1){
              ArrayList<Cell> aiForkLocations = checkFork(marker);
              if(aiForkLocations.size() != 0){
                Cell forker = aiForkLocations.get(0);
                forker.click(forker.checkX() + 1, forker.checkY() + 1);
                print("AI found fork");
                return;
              }
            }
            //4.) Check if AI needs to block a fork
            if(player == 1){
              ArrayList<Cell> playerForkLocations = checkFork(playerMarker);
              if(playerForkLocations.size() == 1){
                Cell blocker = playerForkLocations.get(0);
                blocker.click(blocker.checkX() + 1, blocker.checkY() + 1);
                print("AI blocked 1 fork");
              } else if(playerForkLocations.size() > 1){
                print("AI found multiple forks, chose cell that gave 2 in a row & doesn't let player fork");
                for(int y = 0; y < cells.length; y++){
                  for(int x = 0; x < cells[y].length; x++){
                    Cell possibleOut = cells[y][x];
                    if(possibleOut.checkState() == 0){
                      possibleOut.state = marker;
                      ArrayList<Cell> oneStepAhead = checkWinCondition(marker);
                      //check if this particular cell gives 2 in a row
                      if(oneStepAhead.size() == 1){
                        for(Cell oSA : oneStepAhead){
                          boolean winnable = true;
                          for(Cell fork : playerForkLocations){
                            if(fork.checkX() == oSA.checkX() && fork.checkY() == oSA.checkY()){
                              winnable = false;
                              break;
                            }
                          }
                          if(winnable){
                            possibleOut.state = 0;
                            possibleOut.click(possibleOut.checkX() + 1, possibleOut.checkY() + 1);
                            return;
                          }
                        }
                      }
                      possibleOut.state = 0;
                    }
                  }
                }
              }
            }
            //5.) Check center
            if(player == 1){
              if(cells[1][1].checkState() == 0){
                cells[1][1].click(cells[1][1].checkX() + 1, cells[1][1].checkY() + 1);
                print("AI picked center");
                return;
              }
            }
            //6.) Check opposite corners
            if(player == 1){
              if(cells[0][0].checkState() == playerMarker && cells[2][2].checkState() == 0){
                cells[2][2].click(cells[2][2].checkX() + 1, cells[2][2].checkY() + 1);
                print("AI picked opposite corner");
                return;
              } else if(cells[0][2].checkState() == playerMarker && cells[2][0].checkState() == 0){
                cells[2][0].click(cells[2][0].checkX() + 1, cells[2][0].checkY() + 1);
                print("AI picked opposite corner");
                return;
              } else if(cells[2][0].checkState() == playerMarker && cells[0][2].checkState() == 0){
                cells[0][2].click(cells[0][2].checkX() + 1, cells[0][2].checkY() + 1);
                print("AI picked opposite corner");
                return;
              } else if(cells[2][2].checkState() == playerMarker && cells[0][0].checkState() == 0){
                cells[0][0].click(cells[0][0].checkX() + 1, cells[0][0].checkY() + 1);
                print("AI picked opposite corner");
                return;
              }
            }
            //7.) Check for an empty corner
            if(player == 1){
              if(cells[0][0].checkState() == 0){
                cells[0][0].click(cells[0][0].checkX() + 1, cells[0][0].checkY() + 1);
                print("AI picked empty corner");
                return;
              } else if(cells[0][2].checkState() == 0){
                cells[0][2].click(cells[0][2].checkX() + 1, cells[0][2].checkY() + 1);
                print("AI picked empty corner");
                return;
              } else if(cells[2][0].checkState() == 0){
                cells[2][0].click(cells[2][0].checkX() + 1, cells[2][0].checkY() + 1);
                print("AI picked empty corner");
                return;
              } else if(cells[2][2].checkState() == 0){
                cells[2][2].click(cells[2][2].checkX() + 1, cells[2][2].checkY() + 1);
                print("AI picked empty corner");
                return;
              }
            }
            //8.) Check for an empty side
            if(player == 1){
              if(cells[0][1].checkState() == 0){
                cells[0][1].click(cells[0][1].checkX() + 1, cells[0][1].checkY() + 1);
                print("AI picked empty side");
                return;
              } else if(cells[1][0].checkState() == 0){
                cells[1][0].click(cells[1][0].checkX() + 1, cells[1][0].checkY() + 1);
                print("AI picked empty side");
                return;
              } else if(cells[1][2].checkState() == 0){
                cells[1][2].click(cells[1][2].checkX() + 1, cells[1][2].checkY() + 1);
                print("AI picked empty side");
                return;
              } else if(cells[2][1].checkState() == 0){
                cells[2][1].click(cells[2][1].checkX() + 1, cells[2][1].checkY() + 1);
                print("AI picked empty side");
                return;
              }
            }
          }
      }
  }
  
  ArrayList<Cell> checkWinCondition(int marker){
    ArrayList<Cell> possibleWins = new ArrayList<Cell>();
    Cell cell1;
    Cell cell2;
    Cell cell3;
    for(int cellY = 0; cellY < cells.length; cellY++){
      //check rows
      cell1 = cells[cellY][0];
      cell2 = cells[cellY][1];
      cell3 = cells[cellY][2];
      if(cell1.checkState() == marker && cell2.checkState() == marker && cell3.checkState() == 0){
        possibleWins.add(cell3);
      } else if(cell1.checkState() == marker && cell2.checkState() == 0 && cell3.checkState() == marker){
        possibleWins.add(cell2);
      } else if(cell1.checkState() == 0 && cell2.checkState() == marker && cell3.checkState() == marker){
        possibleWins.add(cell1);
      }
    }
    for(int cellX = 0; cellX < cells.length; cellX++){
      //check columns
      cell1 = cells[0][cellX];
      cell2 = cells[1][cellX];
      cell3 = cells[2][cellX];
      if(cell1.checkState() == marker && cell2.checkState() == marker && cell3.checkState() == 0){
        possibleWins.add(cell3);
      } else if(cell1.checkState() == marker && cell2.checkState() == 0 && cell3.checkState() == marker){
        possibleWins.add(cell2);
      } else if(cell1.checkState() == 0 && cell2.checkState() == marker && cell3.checkState() == marker){
        possibleWins.add(cell1);
      }
    }
    //check diagonal 1
    cell1 = cells[0][0];
    cell2 = cells[1][1];
    cell3 = cells[2][2];
    if(cell1.checkState() == marker && cell2.checkState() == marker && cell3.checkState() == 0){
      possibleWins.add(cell3);
    } else if(cell1.checkState() == marker && cell2.checkState() == 0 && cell3.checkState() == marker){
      possibleWins.add(cell2);
    } else if(cell1.checkState() == 0 && cell2.checkState() == marker && cell3.checkState() == marker){
      possibleWins.add(cell1);
    }
    //check diagonal 2
    cell1 = cells[2][0];
    cell2 = cells[1][1];
    cell3 = cells[0][2];
    if(cell1.checkState() == marker && cell2.checkState() == marker && cell3.checkState() == 0){
      possibleWins.add(cell3);
    } else if(cell1.checkState() == marker && cell2.checkState() == 0 && cell3.checkState() == marker){
      possibleWins.add(cell2);
    } else if(cell1.checkState() == 0 && cell2.checkState() == marker && cell3.checkState() == marker){
      possibleWins.add(cell1);
    }
    return possibleWins;
  }
  
  //checks all possible fork locations for a given player, returns the enabling cells in an ArrayList
  ArrayList<Cell> checkFork(int marker){
    ArrayList<Cell> possibleForkLocations = new ArrayList<Cell>();
    
    //all other forks
    for(int y = 0; y < cells.length; y++){
      for(int x = 0; x < cells.length; x++){
        if(cells[y][x].checkState() == 0){
          cells[y][x].state = marker;
          ArrayList<Cell> wins = checkWinCondition(marker);
          if(wins.size() > 1){
            possibleForkLocations.add(cells[y][x]);
          }
          cells[y][x].state = 0;
        }
      }
    }
    
    return possibleForkLocations;
  }
  
  //function for checking forks, which always have 2 pre-filled cells, 1 fork-enabling cell, and 2 fork-winning cells, no matter the fork formation.
  boolean forkChecker(Cell pf1, Cell pf2, Cell fe, Cell fw1, Cell fw2, int marker){
    if(pf1.checkState() == marker && pf2.checkState() == marker && fe.checkState() == 0 && fw1.checkState() == 0 && fw2.checkState() == 0){
      return true;
    }
    return false;
  }
  
  void setDifficulty(int diff){
    difficulty = diff;
  }
}
