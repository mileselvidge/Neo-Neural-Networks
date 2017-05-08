// Class for the Bird Object

class Bird {
  NeuralNetwork nn;
  float x = 64;
  float y = birdCanvas.height / 2;
  float r = 10;
  int energyExpended = 0;
  
  // All in y-axis as bird static 
  float gravity = 0.4;
  float lift = -12;
  float velocity = 0;
  
  int score = 0; // Frames on screen
  float normFitness;
  
  int[] hidden; // Brain information
  
  Bird(){
    this.score = 0;
    this.normFitness = 0;
    int hiddenLayers = int(random(2)) + 1;
    hidden = new int[hiddenLayers];
    for(int i = 0; i < hiddenLayers; i++){
      hidden[i] = 6 + int(random(-2, 2));
    }
    this.nn = new NeuralNetwork(4, hidden , 2, 0.1, "sigmoid");
  }
  
  Bird(NeuralNetwork n, int[] hid){
    this.score = 0;
    this.normFitness = 0;
    this.energyExpended = 0;
    this.hidden = hid;
    this.nn = n;
    this.nn.mutate();
  }
  
  Bird(Bird b){
    this.nn = b.nn;
    this.hidden = b.hidden;
  }
  
  Bird copy(){
    return new Bird(this.nn, this.hidden);
  }
  
  color getColor(){
    float r = 0;
    float g = 0;
    float b = 0;
    if(hidden.length >= 1){
      r = map(this.hidden[0], 0, 8, 0, 255);
        if(hidden.length >= 2){ 
          g = map(this.hidden[1], 0, 8, 0, 255);
            if(hidden.length >= 3){
          b = map(this.hidden[2], 0, 8, 0, 255);
        }
      }
    }
    return color(r, g, b);
  }
  
  void show(PGraphics canvas){
    canvas.fill(this.getColor(), 100);
    canvas.stroke(255);
    canvas.ellipse(this.x, this.y, this.r * 2, this.r *2);
  }
  
  float fitness() {
    return this.score - 1.5*this.energyExpended;
  }
  
  void think(ArrayList<Pipe> pipes){
    // Find closest pipe
    Pipe closest = null;
    float record = 1000000;
    for(int i = 0; i < pipes.size(); i++){
      float diff = pipes.get(i).x - this.x;
      if(diff > 0 && diff < record){
        record = diff;
        closest = pipes.get(i);
      }
    }
    
    if(closest != null){
      double[] inputs = new double[4]; // Inputs for NN
      inputs[0] = map(closest.x, this.x, birdCanvas.width, -1, 1); // Distance from pipe
      inputs[1] = map(closest.top, 0, birdCanvas.height, -1, 1); // Top of gap
      inputs[2] = map(closest.bottom, 0, birdCanvas.height, -1, 1);
      inputs[3] = map(this.y, 0, birdCanvas.height, -1, 1); // Current y position of bird
      
      double[] outputs = this.nn.query(inputs);
      // Determine whether to jump!
      if(outputs[1] > outputs[0]){
        this.jump();
      }
      
    }
  }
  
  void jump(){
    this.velocity += this.lift;
    energyExpended++;
  }
  
  
  void update(){
    // Update physics 
    this.velocity += this.gravity;
    this.velocity *= 0.9;
    this.y += this.velocity;
    
    if(this.y < 0){
      this.velocity = 0;
      this.y = 0;
      this.score -= 200;  
    } else if(this.y > birdCanvas.height){
      this.velocity = 0;
      this.y = birdCanvas.height;
      this.score -= 200;
    }
    
    this.score++; // Increment every frame
  }
}