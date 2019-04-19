class AI {
  int difficulty;
  Cell[][] cells;
  
  AI(Cell[][] cell, int diff){
    cells = cell;
    difficulty = diff;
  }
  
  void makeMove(){
    if(difficulty == 0){
      if(player == 1 && full > 0){
        while(player == 1){
          int cellX = int(random(cells[0].length));
          int cellY = int(random(cells.length));
          Cell toBeChecked = cells[cellX][cellY];
            if(toBeChecked.checkState() == 0){
              toBeChecked.click(toBeChecked.checkX() + 1, toBeChecked.checkY() + 1);
              System.out.println(toBeChecked.checkX());
              System.out.println(toBeChecked.checkY());
              System.out.println();
          }
        }
      }
    }
  }
}
