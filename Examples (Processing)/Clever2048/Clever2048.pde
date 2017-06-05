// Clever 2048 (with AI)
// by Miles Elvidge, 22/05/17

final float WINDOW_HEIGHT = 600;
final float WINDOW_WIDTH = 600;
final float MARGIN = 10;
final float CANVAS_SIZE = WINDOW_WIDTH - 2*MARGIN; // Same as width for square canvas
final float FRAME_RATE = 60;
final color CELL_COLOR = color(100, 100, 240);
final color BACKGROUND_COLOR = color(250);
final color MARGIN_COLOR = color(55);
final int DIMENSION = 4;
final int STARTING_CELLS = 2;
final float CELL_WIDTH = CANVAS_SIZE / DIMENSION;

PGraphics gameCanvas;
Game g;

void setup(){ 
  size(600, 600);
  frameRate(FRAME_RATE);
  strokeWeight(4);
  
  gameCanvas = createGraphics(int(CANVAS_SIZE),int(CANVAS_SIZE), JAVA2D);  
  gameCanvas.beginDraw();
  gameCanvas.stroke(255);
  gameCanvas.smooth();
  gameCanvas.textSize(50);
  gameCanvas.endDraw();
  
  g = new Game(); 
}

void draw() {
  background(BACKGROUND_COLOR);
  gameCanvas.beginDraw();
  gameCanvas.background(MARGIN_COLOR);
  
  g.display();
  
  gameCanvas.endDraw();
  image(gameCanvas, MARGIN, MARGIN);
  println(g.getMaxValue());
}

void keyPressed() {
  if(keyCode == 38) { g.move(Direction.UP); }
  if(keyCode == 37) { g.move(Direction.LEFT); }
}