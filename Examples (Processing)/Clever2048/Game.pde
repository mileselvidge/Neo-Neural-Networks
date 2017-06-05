public class Game {
  private Cell[][] board;
  
  public Game() {
    // Setup 
    this.board = new Cell[DIMENSION][DIMENSION];
    for(int i = 0; i < DIMENSION; ++i) {
      for(int j = 0; j < DIMENSION; ++j) { this.board[i][j] = new Cell(); }
    }
    
    for(int i = 0; i < STARTING_CELLS; ++i) { this.spawnNextCell(); }
  }
  
  public Game(Game g) {
    this.board = g.board;
  }
  
  public Game copy() { return this; }
  
  public boolean canSpawnNextCell() { 
    for(int i = 0; i < DIMENSION; ++i) {
      for(int j = 0; j < DIMENSION; ++j) { 
        if(this.board[i][j].isEmpty()){ return true; }
      }
    }
    return false;
  }
  
  public void spawnNextCell(){
    if(!this.canSpawnNextCell()){ 
      println("Error: No Empty Cells on board!");
    } else {
      int i = 0;
      int j = 0;
      do {
        i = int(random(DIMENSION));
        j = int(random(DIMENSION));
      } while(!this.board[i][j].isEmpty());
      
      this.board[i][j].populate();
    }
  }
  
  public int getMaxValue() {
    int max = 0;
    for(int i = 0; i < DIMENSION; ++i) {
      for(int j = 0; j < DIMENSION; ++j) {
        if(this.board[i][j].getValue() > max){ max = this.board[i][j].getValue(); }
      }
    }
    return max;
  }
  
  public void display(){
    gameCanvas.pushMatrix();
    int max = this.getMaxValue();
    for(int i = 0; i < DIMENSION; ++i){
      for(int j = 0; j < DIMENSION; ++j) {
        this.board[i][j].display(max);
        gameCanvas.translate(CELL_WIDTH, 0);
      }
      gameCanvas.translate(-CELL_WIDTH*DIMENSION, CELL_WIDTH);
    } 
    gameCanvas.popMatrix();
  }
  
  public boolean canMove() {
    for(int i = 0; i < DIMENSION; ++i) {
      for(int j = 0; j < DIMENSION; ++j) {
        if(this.board[i][j].isEmpty()) { return true; }
      }
    }
    
    return false;
  }
  
  public void move(Direction dir){
    for(int k = 0; k < DIMENSION; k++){
      if(dir == Direction.UP) {
        for(int i = 0; i < DIMENSION-1; ++i){
        for(int j = 0; j <= DIMENSION-1; ++j){
          if(this.board[i+1][j].getExponent() == this.board[i][j].getExponent() && !this.board[i][j].isEmpty()){
            this.board[i][j].incExponent();
            this.board[i+1][j] = new Cell();
          }
          else if(!this.board[i+1][j].isEmpty() && this.board[i][j].isEmpty()){
          this.board[i][j] = this.board[i+1][j].copy();
          this.board[i+1][j] = new Cell();
          }
        }
      }
      } else if (dir == Direction.LEFT){
        for(int i = 0; i < DIMENSION-1; ++i){
        for(int j = 0; j <= DIMENSION-1; ++j){
          if(this.board[j][i+1].getExponent() == this.board[j][i].getExponent() && !this.board[j][i].isEmpty()){
            this.board[j][i].incExponent();
            this.board[j][i+1] = new Cell();
          }
          else if(!this.board[j][i+1].isEmpty() && this.board[j][i].isEmpty()){
          this.board[j][i] = this.board[j][i+1].copy();
          this.board[j][i+1] = new Cell();
          }
        }
      }
      }
    }
    this.spawnNextCell();
  }
}