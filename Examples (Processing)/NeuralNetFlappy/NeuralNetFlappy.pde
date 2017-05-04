import net.mileselvidge.neo.*;
import java.util.Collections;

// Flappy Bird Artificial Neural Network Example
// Miles Elvidge, 17, 04/05/17

int populationSize = 250;

ArrayList<Bird> activeBirds;
ArrayList<Bird> allBirds;
ArrayList<Pipe> pipes;
Bird bestBird;

int counter = 0;
int generation = 0;

int speed = 1;
int highscore = 0;
PGraphics birdCanvas;

boolean runBest = false;

void setup() {
  size(840, 500);
  birdCanvas = createGraphics(600,400);
  reset();
}

void reset(){
  activeBirds = new ArrayList<Bird>();
  allBirds = new ArrayList<Bird>();
  pipes = new ArrayList<Pipe>();
  
  for(int i = 0; i < populationSize; i++){
    Bird b = new Bird();
    activeBirds.add(b);
    allBirds.add(b);
  }
  
  bestBird = activeBirds.get(0);
}

void toggleState(){
  runBest = !runBest;
  if(runBest){
    resetGame();
    bestBird.score = 0;
    bestBird.y = height/2;
    println("Playing best!"); // TODO: add label to display state
  } else {
    nextGeneration();
    println("Training birds!");
  }
}

void draw() {
  background(51);
  birdCanvas.beginDraw();
  birdCanvas.background(50,100,200);
  
  // Run for as long as the speed states
  for(int i = 0; i < speed; i++){
    // Display all pipes + update
    for(int j = pipes.size()-1; j >= 0; j--){
      pipes.get(j).update();
      if(pipes.get(j).offscreen()){
        pipes.remove(j);
      }
    }
    
    // Determine whether it is just the best bird or all birds
    if(runBest){
      // Display on the best bird
      bestBird.think(pipes);
      bestBird.update();
      for(int j = 0; j < pipes.size(); j++){
        if(pipes.get(j).hits(bestBird)) {
          // Bird hit pipe
          resetGame();
          break;
        }
      }
    } else {
      // Run for all birds
      for(int j = activeBirds.size()-1; j >= 0; j--){
        Bird b = activeBirds.get(j);
        // Call for neural network
        b.think(pipes);
        b.update();
        for(int k = 0; k < pipes.size(); k++){
          if(pipes.get(k).hits(b)) {
            // Bird hit pipe
            activeBirds.remove(j);
            break;
          }  
        }
      }
    }
    
    // Add a new pipe every 75 frames
    if(counter % 75 == 0){
      pipes.add(new Pipe());
    }
    counter++;
  }
  
  // Determine the best current bird
  int temphs = 0; // Temporary high score
  if(!runBest){
    Bird tempBestBird = null;
    for(int i = 0; i < activeBirds.size(); i++){
      int s = activeBirds.get(i).score;
      if(s > temphs){
        temphs = s;
        tempBestBird = activeBirds.get(i);
      }
    }
    
    if(temphs > highscore){
      bestBird = tempBestBird;
      highscore = temphs;
    }
  } else {
    int tempHighscore = bestBird.score;
    if(tempHighscore > highscore){
      highscore = tempHighscore;
    }
  }
  
  // Drawing
  for(int i = 0; i < pipes.size(); i++){
    pipes.get(i).show(birdCanvas);
  }
  
  if(runBest) {
    bestBird.show(birdCanvas);
  } else {
    for(Bird b : activeBirds){
      b.show(birdCanvas);
    }
    if(activeBirds.size() == 0){
      nextGeneration();
    }
  }
  birdCanvas.endDraw();
  image(birdCanvas, 0, 0);
  displayStats();
  println(bestBird.score);
}


void displayStats(){
  translate(width-230,40);
  textSize(40);
  text("Statistics", 0, 0);
  textSize(15);
  translate(0, 20);
  text("Generation: "+generation,0,0);
  translate(0, 20);
  text("Population Remaining: "+activeBirds.size(),0,0);
  translate(0, 20);
  text("Highscore: "+highscore,0, 0);
  translate(0, 20);
  text("Score: "+counter,0, 0);
  translate(0, 20);
  text("Mean Fitness: "+meanFitness(),0, 0);
  translate(0, 40);
  text("Best Neural Network: ",0,0);
  NMatrix[] hidden = bestBird.nn.getNetwork();
  translate(0, 20);
  text("Hidden layers: "+hidden.length,0,0);
  for(int i = 0; i < hidden.length; i++){
    translate(0, 20);
    text("Hidden "+(i+1)+": "+hidden[i].dimension()[0]+" nodes",0,0);
  }
}

float meanFitness(){
  // Calculate mean fitness
  float sum = 0;
  for(int i = 0; i < activeBirds.size(); i++){
    sum += activeBirds.get(i).fitness();
  }
  return sum / activeBirds.size();
}

void resetGame(){
  pipes = new ArrayList<Pipe>();
  counter = 0;
}

// Genetic algorithms 
void nextGeneration(){
  generation++;
  resetGame();
  
  allBirds = normalizeFitness(allBirds);
  activeBirds = new ArrayList<Bird>(generate(allBirds));
  allBirds = new ArrayList<Bird>(activeBirds);
  bestBird = allBirds.get(0);
}

// Generate new population
ArrayList<Bird> generate(ArrayList<Bird> oldPopulation){
  ArrayList<Bird> newPopulation = new ArrayList<Bird>();
  for(int i = 0; i < oldPopulation.size(); i++){
    Bird b = poolSelection(oldPopulation);
    newPopulation.add(b);
  }
  
  return newPopulation;
}

ArrayList<Bird> normalizeFitness(ArrayList<Bird> birds){
  float sum = 0;
  for(int i = 0; i < birds.size(); i++){
    sum += birds.get(i).fitness();
  }
  for(int i = 0; i < birds.size(); i++){
    birds.get(i).normFitness = birds.get(i).score / sum;
  }
  
  return birds;
}

Bird poolSelection(ArrayList<Bird> birds){
  // Natural Selection algorithm for selecting next bird
  float r = random(1);
  int i = 0;
  do {
    i = int(random(birds.size()-1));
    r -= birds.get(i).normFitness;
  } while(r > 0);
  return birds.get(i).copy();
}

void mousePressed(){
  // Toggle best bird
  //toggleState();
}