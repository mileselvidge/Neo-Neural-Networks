class TestResult {
  boolean correct;
  double[] inputs;
  int guess;
  
  TestResult(double[] i, int g, boolean c){
    inputs = i;
    guess = g;
    correct = c;
  }
}