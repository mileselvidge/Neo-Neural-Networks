class Pipe {
  float spacing;
  float center;
  
  float top;
  float bottom;
  
  float x;
  float w;
  float speed;
  
  Pipe(){
    this.spacing = random(120, birdCanvas.height / 2.5);
    this.center = random(spacing, birdCanvas.height - spacing);
    this.top = center - spacing / 2;
    this.bottom = birdCanvas.height - (center + spacing / 2);
    this.x = birdCanvas.width;
    this.w = 50;
    this.speed = 4;
  }
  
  // Determine whether a b has hit the pipe
  boolean hits(Bird b){
    if ((b.y - b.r) < this.top || (b.y + b.r) > (birdCanvas.height - this.bottom)) {
      if (b.x > this.x && b.x < this.x + this.w) {
        return true;
      }
    }
    return false;
  }
  
  boolean offscreen(){
    if (this.x < -this.w) {
      return true;
    } else {
      return false;
    }
  }
  
  void show(PGraphics canvas){
    canvas.stroke(20,200,100);
    canvas.fill(20,200,100);
    canvas.rect(this.x, 0, this.w, this.top);
    canvas.rect(this.x, birdCanvas.height - this.bottom, this.w, this.bottom);
  }
  
  void update() {
    this.x -= this.speed;
  } 
}