public class Cell {
  private int exp; // Value of the cells exponent
  
  public Cell(){
    this.exp = 0;
  }
  
  public Cell(Cell c){
    this.exp = c.exp;
  }
  
  public Cell copy() { return this; }
  
  public int getValue() {
    if(this.isEmpty()) { return 0; }
    return int(pow(2, this.exp));
  }
  
  public boolean isEmpty() { return this.exp == 0; }
  public int getExponent() { return this.exp; }
  public void incExponent() { this.exp++; }
  
  public void populate() {
    this.exp = random(1) < 0.8 ? 1 : 2;
  }
  
  public float getNormal(int max) { return float(exp) / max; }
  
  public void display(int max) {
    gameCanvas.noFill();
    if(!this.isEmpty()){ 
      gameCanvas.fill(CELL_COLOR, 255*this.getNormal(max));
    }
    gameCanvas.rect(0, 0, CELL_WIDTH, CELL_WIDTH);
    if(!this.isEmpty()){
      gameCanvas.fill(255);
      gameCanvas.text(""+this.getValue(),CELL_WIDTH / 2 -15, CELL_WIDTH / 2);
    }
  }
}