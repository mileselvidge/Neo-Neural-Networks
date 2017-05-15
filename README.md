# Neo Neural Networks (NNN)
### _Neural Networks and Matrix Mathematics for Java_

Neo is a basic machine learning library for Java written from the ground up. Neo has the ability to cretae and operate on large abstract matrices, including powerful operations like the matrix power and inverse functions. Central to Neo is a easy and effective way to write multi-layered Artificial Neural Networks that can easily be created, trained and queried in any Java project, and has been adapted with the Processing IDE in mind. 

This project is just beginning and I intend to perusing it much further. Many of the concepts I explored whilst creating this project are new and exciting to me as I am 17 years old. Any input, suggests or help will be welcome!

***

## The name

The 1999 Matrix introduced many of us into the beautiful term 'Matrix' for the first time. A term so powerful; at the core of liniar algebra, machine learning, and one of my favourite films. The film inspired me to name this library after Thomas A. Anderson, Neo.

***

## Functionality
* Create three layered artificial neural networks using the `NeuralNetwork` datatype.
* Train (back propagate) neural networks with any number of inputs, outputs and hidden layers.
* Query neural networks for predictions from input data.
* Make use of the `sigmoid` and `tanh` functions.
* Create abstract Matrices or Vectors using the `NMatrix` datatype. 
* Initilize a variety of different common matrices, such as the null-matrix, ones-matrix and identity matrix.
* Perform arithmetic operations such as adding, subtracting, multiplying, and scaling matrices.
* Raise a matrix to any integer power, calculate the inverse, or any negetive integer power.
* Calculate the determinant, transpose and cofactors of a matrix.
* Append two matrices by row or by column or create a sub-matrix.
* Dot-multiply each element of matrices of the same dimention. 
* Calculate the dot-product of two vectors.
* Display a matrix to the console.
* Output a matrix as a String or an array of strings to be stored in a CSV file.

*** 

## Repository contents 
Currently the repository contains:
1. The source code for the Neo Neural Network (NNN) library, Neo, named `Neo`.
2. The exported jar file for the Neo library.
3. A ready-to-go processing library folder, `Neo (Processing Library)`.
4. A basic example of Neo in action, `Examples (Processing)/Testing_Neo`, which contains the MNIST handwriting classification problem solved using the Neo Neural Network library and MNIST dataset (referenced below). Inspired by Traiq Rashid and Dan Shiffman (referenced below).

### Install: Processing
1. Install the `Neo` folder from the repo.
2. Place the folder in the libraries folder within your Processing folder (likely in the install location, mine was in my documents).
3. Whilst in Processing click on `Sketch` and then `Import Library` followed by `Neo`.
  - Alternatively, import `net.mileselvidge.neo.*; ` at the top of your source code.

***

## Usage (Neural Networks)
Creating an artificial neural network in Java with Neo (NNN) is quick and simple and may be done in a few lines of code. For an applied example with visuals see the Examples folder in the repository. Neural networks can have multiple layers of hidden nodes!

**NOTE: all operations and functions are written for using the double data type within matricies for the largest range of possible values.**

### Creating a Neural Network
```java
// Create a neural network with a specific number of input, hidden and output nodes/neurons.
NeuralNetwork nn = new NeuralNetwork(inputNodes, hiddenNodes[], outputNodes, learningRate, "sigmoid"); 

// NOTE: The fifth parameter refers to the activation function and may be either "sigmoid" or "tanh"

// EG: 
NeuralNetwork tanhNet = new NeuralNetwork(10, new double[] {20, 10}, 5, 0.1, "tanh");
// Tanh Neural Network with: 10 input nodes, 20, 10 hidden nodes, 5 output nodes, a learning rate of 0.1

// Intialise a NeuralNetwork through copying another
NeuralNetwork nn2 = nn.copy();

NMatrix[] hiddenWeights = nn.getNetwork(); // TODO: Change this to return actual hidden layers for a query!
```

### Using a Neural Network
It is even simple to train your neural network and and query it for outputs!
```java
// Training a neural network
for(int i = 0; i < inputTrainingData.length; i++){  
  // Loop through every element of a two dimensional array of training data
  // The neural network train function takes two arrays of double values as inputs.
  // These correspond to input training data and the target values the NN is to achive.
  // Through back-propogation, the weights of the NN are adjucted to fit the data.
  // The input training data must be the same length as the number of input nodes, the target must be the same length as the output node size.
  
  nn.train(inputTrainingData[i], targetTrainingData[i]);
}

// Test a neural network with a query
// Example: 
double[] inputs = new double[4] {1.0, 2.0, -1.0, 2};

double[] outputs = nn.query(inputs); // Returns the array of probabilities for the output nodes


NOTE: for optimal usage of the Neo Neural Networks library ensure all data is normalized.
```

***

### Usage (Matrices)
This is a little more barebones than the Neural Network implementation. Using Matrices in your program should be fairly simple although many exceptions, while handled, might occour or need to be catered for if the dimensions of Matrices operated on is not thought out.

**Note: In this implementation matrices are 0 indexed** 
### Creating a Matrix: 
There are a few different ways to initilize a matrix (of dimentions m x n).
```java
// 1. Create a matrix from a two dimentional array of double values.
NMatrix M = new NMatrix(new double[][] {{10, 2, -4.2}}, {2, 2.2, 3}, {-1, 3, 4}});

// 2. Create an empty m x n matrix containing zeros.
NMatrix N = new NMatrix(3, 2); // Creates a 3x2 null matrix

// 3. Create an identity matrix of dimention n x n
NMatrix P = new NMatrix(10); 

// 4. Create a matrix from another matrix.
NMatrix Q = new NMatrix(P);

// ... or just copy an existing matrix.
NMatrix Q = P.copy();

// Set or get values in a matrix
double topCorner = M.get(0, 0); // Returns the top element of the matrix
M.set(1, 2, 3.1415); // M(1,2) = 3.1415

```
Additionally, you may create one of the following matrices using any of the following static methods:
```java
NMatrix I = NMatrix.identity(3); // Creates a 3x3 identity matrix.
NMatrix Zeros = NMatrix.nullMatrix(4,1); // Creates a 4-dimentional null vector.
NMatrix Ones = NMatrix.onesMatrix(2,10); // Creates a 2x10 ones matrix.
NMatrix Random = NMatrix.random(100,100); // Creates an 100x100 matrix containing random doubles (-1 to 1)!
```

### Arithmetic Operations on a Matrix:
Examples:
```java
// Simple
NMatrix C = NMatrix.add(A, B); // C = A+B (works only if A and B have the same dimention).
NMatrix D = NMatrix.subtract(A,C); // D = A-C ('')

// Matrix-Matrix multiplication (Note: for this project, Vectors are included as matrices). 
NMatrix E = NMatrix.multiply(A,D); // E = A*D (standard rules of matrix multiplication, the number of columns in A must equal the number of rows in D for it to be possible; the output matrix, E, will have the A's number of rows and D's number of columns).

// Scalar-Matrix multiplication
NMatrix X = NMatrix.multiply(3, Y); // X = 3Y

NMatrix Z = NMatrix.dotMultiply(X, Y); // Only works for identical dimentions, multiplies each element of one matrix with its corresponding element in another.

// Powers and inverse matrices (only works on square matrices).
M = NMatrix.pow(M, 3); // M^3
M = M.pow(3); // Alternative writing

R = NMatrix.inv(M); // R = M^-1
R = M.inv(); // Alternative writing

S = M.pow(-3); // S = M^-3
```

### Matrix features
```java
double det = A.det(); // The determinant of A.
NMatrix Atranspose = A.transpose(); // The transpose matrix of A.
NMatrix Acofactor = JMatrix.cofactor(A); // Return the cofactor of A.
NMatrix Asub = JMatrix.subMatrix(A, 0, 0); // Returns a matrix which exludes the column 0 and row 0.

double dot NMatrix.dot(x, y); // Compute the dot product of two vectors.

int[] dimention = A.dimension(); // Returns the dimension of a matrix [number of rows, number of columns] or [number of rows] for a vector.

A.isSquare(); // Returns whether A is a square matrix.
A.isSingular(); // Returns whether A is a singular matrix.
A.isVector(); // Returns whether A is a vector.
NMatrix.canMultiply(A, B); // Returns whether two matracies can multiply.
NMatrix.isSameDimention(A, B); // Returns whether two matrices are of the same dimention.
```

### Output functionality
```java
M.display(); // Print the contents of a matrix to the console.
String[] CSVStrings = M.toCSV(); // Returns a CSV formatted array strings (line per row).
String matrixString = M.toString(); // A large string containing the matrix

// Append two matrices
// The option parameter can either be 1 or 2.
// 1 = Append Rows (Horizontally)
// 2 = Append Columns (Vertically)
NMatrix C = NMatrix.append(A, B, 1); // Example: append the contents of B to the end of A vertically.
```

***

## Flappy Bird
This is another ongoing project (which I will publish a seperate repository for this shortly). I decided to see whether I could apply a genetic aglorithm, which mutates the weights on a neural network; and the best neural networks are selected after a generation of "birds" based on a fitness function.

This example runs in Processing and can be found within the repository "Examples" directory. It is fairly simple to use. Buttons can toggle the performance of the best bird of all generations and generating new generations and buttons for alterating the speed of the simulation.

Currently, birds are generated with Neural Networks with a random number (between 1 and 3) of layers and a random number (4-12) of nodes in each layer. The best birds are selected at the end of a generation based on their distance played and energy expended (number of flaps). Entirely new birds are also generated between generations. Birds are coloured based on their Neural Network's complexity.

![alt text](http://i.imgur.com/UV7IXV5.png "Flappy AI with Neo Neural Networks")

## Example in Processing
For a more detailed and involved look into how to use Neo Neural Networks (NNN) look no further than the implementation in the Processing IDE to solve the MNIST handwriting letters problem. There is a nice visual (inspired by Dan Shiffman) to watch the program in action and statistics (performance, epochs etc) are printed to the console.

I intend on writing many more examples in the near future to showcase NNN in action!
![alt text](http://i.imgur.com/3apd0zk.png "GUI training in action")
![alt text](http://i.imgur.com/pfqlaPB.png "Console output while in training (2 hours)")

Inspiration for the visuals comes from _Dan Shiffman's "Nature of Code 2: Intelligence and Learning" (Chapter 6)_ and concept, problem and data from _Tariq Rashid's "Make Your Own Neural Network"_.

***

## Updates

### 04/05/17
1. Added support for Artificial Neural Networks with multiple hidden layers.
2. Added a few genetic/evolutionary algorithm functions for the weights of the NN, these are poorly optimised and still a WIP; thus are not documented.
3. Added a new example of AI Flappy Bird with a NN at the core to show off new multi-layered functionalities.

### 08/05/17
1. Implemented an example of my Artifical Neural Network in Processing with neural evolution to produce an AI to play the popular game "Flappy Bird".

***

## Todo
* Optimise the inverse function as this is particularly slow.
* Optimise multiplication, like above, perhaps using the `Strassen Algorithm`.

***

## References
* Tariq Rashid's: "Make Your Own Neural Network"
  - https://github.com/makeyourownneuralnetwork/
* Dan Shiffman's "Nature of Code 2: Intelligence and Learning (Chapter 6 Bonus)
  - https://github.com/shiffman/NOC-S17-2-Intelligence-Learning/tree/master/week6bonus-reinforcement-neuroevolution
* Wikipedia, Matrix: https://en.wikipedia.org/wiki/Matrix_(mathematics)
* The Strassen Algorithm: https://en.wikipedia.org/wiki/Strassen_algorithm



