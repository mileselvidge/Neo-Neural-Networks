class Button {
  float w;
  float h;
  float x;
  float y;
  String text;
  color c;
  
  Button(String txt, float x_, float y_, float w_, float h_){
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    text = txt;
    c = color(50, 100, 100);
  }
  
  void display() {
    fill(c);
    stroke(255);
    rect(x, y, w, h);
    fill(255);
    text(text,x+w/2,y+h/2);
  }
  
  boolean withinBounds(float x_, float y_){
    return x_ > x - w/2 && x_ < x + w/2 && y_ > y - h/2 && y_ < y + h/2; 
  }
  
}