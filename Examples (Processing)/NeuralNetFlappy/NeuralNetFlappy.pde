import net.mileselvidge.neo.*;
import java.util.Collections;

// Flappy Bird Artificial Neural Network Example
// Miles Elvidge, 17, 04/05/17

int populationSize = 300;
Button SpeedBtn, plusSpeed, minusSpeed, bestBtn;

ArrayList<Bird> activeBirds;
ArrayList<Bird> allBirds;
ArrayList<Pipe> pipes;
Bird bestEver;

int counter = 0;
int generation = 0;
ArrayList<Integer> scoreHistory = new ArrayList<Integer>();

int speed = 2;
int highscore = 0;
PGraphics birdCanvas;

boolean runBest = false;

void setup() {
  size(860, 500);
  textAlign(CENTER);
  birdCanvas = createGraphics(600,400);
  SpeedBtn = new Button("Speed: ",162, height-70,90,50);
  bestBtn = new Button("Run Best",15,height-70,90,50);
  plusSpeed = new Button("+",135,height-70,25,50);
  plusSpeed.c = color(50,200,100);
  minusSpeed = new Button("-",107,height-70,25,50);
  minusSpeed.c = color(255,50,100);
 
  resetAll();
}

void resetAll(){
  activeBirds = new ArrayList<Bird>();
  allBirds = new ArrayList<Bird>();
  pipes = new ArrayList<Pipe>();
  highscore = 0;
  scoreHistory = new ArrayList<Integer>();
  scoreHistory.add(0);
  
  for(int i = 0; i < populationSize; i++){
    Bird b = new Bird();
    activeBirds.add(b);
    allBirds.add(b);
  }
  
  bestEver = activeBirds.get(0);
}

void toggleState(){
  runBest = !runBest;
  if(runBest){
    resetGame();
    bestBtn.text = "Generate";
  } else {
    nextGeneration();
    bestBtn.text = "Run Best";
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
      bestEver.think(pipes);
      bestEver.update();
      for(int j = 0; j < pipes.size(); j++){
        if(pipes.get(j).hits(bestEver)) {
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
    Bird tempbestEver = null;
    for(int i = 0; i < activeBirds.size(); i++){
      int s = activeBirds.get(i).score;
      if(s > temphs){
        temphs = s;
        tempbestEver = activeBirds.get(i);
      }
    }
    
    if(temphs > highscore){
      bestEver = tempbestEver;
      highscore = temphs;
    }
  } else {
    int tempHighscore = bestEver.score;
    if(tempHighscore > highscore){
      highscore = tempHighscore;
    }
  }
  
  // Drawing
  for(int i = 0; i < pipes.size(); i++){
    pipes.get(i).show(birdCanvas);
  }
  
  if(runBest) {
    bestEver.show(birdCanvas);
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
  scoreHistory.set(generation, counter); // For current mean value
  displayStats();
}


void displayStats(){ 
  SpeedBtn.text = "Speed: "+speed;
  SpeedBtn.display();
  minusSpeed.display();
  plusSpeed.display();
  bestBtn.display();
  fill(255);
  translate(width-135,40);
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
  text("Mean Fitness (Alive): "+round(meanFitness()),0, 0);
  translate(0, 20);
  text("Mean lifespan (Alltime): "+round(meanLifespan()),0,0);
  translate(0, 40);
  text("Best Neural Network: ",0,0);
  translate(0, 20);
  text("Hidden layers: "+bestEver.hidden.length,0,0);
  for(int i = 0; i < bestEver.hidden.length; i++){
    translate(0, 20);
    text("Hidden "+(i+1)+": "+bestEver.hidden[i]+" nodes",0,0);
  }
  translate(0, 20);
}

float meanLifespan(){
  if(scoreHistory.size() == 0){
    return 0;
  } else {
    float sum = 0;
    for(int score : scoreHistory){
      sum += score;
    }
    return sum / scoreHistory.size();
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
  bestEver.y = birdCanvas.height/2;
  counter = 0;
}

// Genetic algorithms 
void nextGeneration(){
  generation++;
  resetGame();
  scoreHistory.add(counter);
  
  allBirds = normalizeFitness(allBirds);
  activeBirds = new ArrayList<Bird>(generate(allBirds));
  allBirds = new ArrayList<Bird>(activeBirds);
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
    if(birds.get(i).fitness() > 0){
      sum += sq(birds.get(i).fitness());
    }
  }
  for(int i = 0; i < birds.size(); i++){
    birds.get(i).normFitness = birds.get(i).score > 0 ? birds.get(i).score / sum : 0;
  }
  
  return birds;
}

Bird poolSelection(ArrayList<Bird> birds){
  // Natural Selection algorithm for selecting next bird
  float r = random(1);
  int i = 0;
  int j = 0;
  do {
    j = int(random(birds.size()));
    r -= birds.get(j).normFitness;
    i++;
  } while(r > 0 && i < birds.size());
  i--;
  if(i >= birds.size()/2) { return new Bird(); }
  return birds.get(j).copy();
}

void mousePressed(){
  if(plusSpeed.withinBounds(mouseX, mouseY) && speed <= 256) {
    if(speed == 0) { speed = 1; }
    else { speed *= 2; }
  }
  if(minusSpeed.withinBounds(mouseX, mouseY)){
    if(speed == 1){ speed = 0; }
    else { speed /= 2; }
  }
  if(bestBtn.withinBounds(mouseX,mouseY)){
    toggleState();
  }
}