import net.mileselvidge.neo.*;
/*
 * Neo: Java Machine Learning Library
 * A Machine Learning library for Java containing Neural Networks and Matrix Mathematics
 * by Miles Elvidge, 17
 * Contact: miles.elvidge@ntlworld.com
 * Started 01/05/17
 */
 
 // Example Project (MNIST)
 // Inspired by "Make Your Own Neural Network" by Tariq Rashid
 // https://github.com/makeyourownneuralnetwork/

NeuralNetwork nn;
String[] training;
String[] testing;

// Current iteration through the whole dataset
int epochs = 1;

// Configure network
int totIn = 784;
int totHid = 256;
int totOut = 10;

// Learning rate
double lr = 0.1;

// Network statistics
int totCorrect = 0;
int totGuess = 0;

// User drawn image 
PGraphics userPixels;
PImage smaller;
int ux = 16;
int uy = 100; // Position on sketch
int uw = 140;


// Progress Counters
int trainingIndex = 0;
int testingIndex = 0;

boolean isPaused = false;

void setup() {
  size(320, 280);
  // Load training and test data
  testing = loadStrings("mnist_test.csv");
  training = loadStrings("mnist_train.csv");
  
  nn = new NeuralNetwork(totIn, totHid, totOut, lr, "sigmoid");
   
  // Blank user canvas 
  userPixels = createGraphics(uw, uw);
  userPixels.beginDraw();
  userPixels.background(0);
    
  // Smaller image
  smaller = createImage(28, 28, RGB);
  
  PImage img = userPixels.get();
  smaller.copy(img, 0, 0, uw, uw, 0, 0, smaller.width, smaller.height);
}

void mouseDragged() {
  if(mouseX > ux && mouseY > uy && mouseX < ux + uw && mouseY < uy + uw) {
    // paint!
    userPixels.fill(255);
    userPixels.stroke(255);
    userPixels.ellipse(mouseX - ux, mouseY - uy, 14, 14);
    
    // Sample down
    PImage img = userPixels.get();
    smaller.copy(img, 0, 0, uw, uw, 0, 0, smaller.width, smaller.height);
  }
}

void draw() {
  if(!isPaused) {
      background(200);
  
      // Train the data (one image per frame)
      double[] trainingData = train();
  
      // Test the network at current
      TestResult result = test();
  
      double[] testData = result.inputs;
      int guess = result.guess;
      boolean correct = result.correct;
  
      // Draw the training and testing image
      drawImage(trainingData, ux, 16, 2, "training");
      drawImage(testData, 180, 16, 2, "test");
  
      // Draw guess
      fill(0);
      rect(246, 16, 2 * 28, 2 * 28);
      // Colour dependant on accuracy
      if (correct) {
        fill(0, 255, 0);
      } else {
        fill(255, 0, 0);
      }
  
      textSize(60);
      text(guess, 258, 64);
  
      if (correct) {
        totCorrect++;
      }
      totGuess++;
  
      // Display performance
      float percent = 100 * float(trainingIndex) / training.length;
      println("Epochs: ",epochs," (",percent,"%)");
      println("Performance: " + float(totCorrect)/totGuess); 
  }
  
  // Draw the users pixels
  image(userPixels, ux, uy);
  fill(0);
  textSize(12);
  text("Draw here: ",ux,uy+uw+16);
  image(smaller,180,uy,28*2,28*2);
  
  // Change pixels to input for neural network
  double[] inputs = new double[smaller.pixels.length];
  smaller.loadPixels();
  for(int i = 0; i < smaller.pixels.length; i++){
    inputs[i] = map(red(smaller.pixels[i]),0,255,0,0.99) + 0.01;
  }
  
  // Get the outputs
  double[] outputs = nn.query(inputs);
  // Determine best guess
  int g = findMax(outputs);
  
  fill(0);
  rect(246, uy, 2 * 28, 2 * 28);
  fill(255);
  textSize(60);
  text(g, 258, uy + 48);
}

double[] train(){
  // Get the next row of the CSV file
  String[] vals = training[trainingIndex].split(",");
  
  double[] inputs = new double[vals.length-1];
  
  // Construct input array for neural network
  for(int i = 1; i < vals.length; i++) {
    // Normalize data after converting to double
    double d = Double.parseDouble(vals[i]);
    inputs[i-1] = map(Float.parseFloat(d+""),0,255,0,0.99) + 0.01;
  }
  
  // Initialise targets array
  double[] targets = new double[totOut];
  for(int i = 0; i < totOut; i++) {
    targets[i] = 0.01;
  }
  
  // We need to classify the data...
  // ... this is the first index of the values array
  int l = Integer.parseInt(vals[0]);
  targets[l] = 0.99;
  
  nn.train(inputs, targets);
  
  trainingIndex++;
  if(trainingIndex == training.length) {
    trainingIndex = 0;
    // One training cycle complete: return to start of dataset
    epochs++;
  }
  
  // Return the inputs (for graphics)
  return inputs;
}

// Test the neural network
TestResult test() {
  // Get the next row of the CSV file
  if(testingIndex >= testing.length-1) {
      testingIndex = 0;
  }
  String[] vals = testing[testingIndex].split(",");
  
  double[] inputs = new double[vals.length-1];
  
  // Construct input array for neural network
  for(int i = 1; i < vals.length; i++) {
    // Normalize data after converting to double
    double d = Double.parseDouble(vals[i]);
    inputs[i-1] = map(Float.parseFloat(d+""),0,255,0,0.99) + 0.01;
  }
  
  // Get the location of the correct value
  int l = Integer.parseInt(vals[0]);
  
  // Run the data through the network
  double[] outputs = nn.query(inputs);
  
  // Find the index with the highest probability
  int guess = findMax(outputs);
  
  // Determine whether the computer guess is correct
  boolean correct = false;
  if(guess == l){
    correct = true;
  }
  
  // Frequently update test data
  if(frameCount % 30 == 0) {
    testingIndex++;
  }
  
  // Return data from test
  return new TestResult(inputs, guess, correct);
}

int findMax(double[] arr){
  // Find the maximum value in an array
  double record = 0;
  int index = 0;
  for(int i = 0; i < arr.length; i++) {
    if(arr[i] > record) {
      record = arr[i];
      index = i;
    }
  }
  
  return index;
}

// Draw the array of floats as an image
void drawImage(double[] values, float xoff, float yoff, float w, String txt) {
  // it's a 28 x 28 image
  int dim = 28;

  // For every value
  for (int k = 0; k < values.length; k++) {
    // Scale up to 256
    float brightness = Float.parseFloat(values[k]+"") * 256;
    // Find x and y
    int x = k % dim;
    int y = floor(k / dim);
    // Draw rectangle
    fill(brightness);
    noStroke();
    rect(xoff + x * w, yoff + y * w, w, w);
  }

  // Draw a label below
  fill(0);
  textSize(12);
  text(txt, xoff, yoff + w * 35);
}

void clearImage() {
  userPixels.endDraw();
  userPixels.beginDraw();
  userPixels.background(51);
}

void saveModel() {
  // TODO
}

void keyPressed() {
  if(keyCode == 32) { isPaused = !isPaused; } // Toggle paused (Space)
  if(keyCode == 67) { clearImage(); } // c
  if(keyCode == 83) { saveModel(); } // S
}