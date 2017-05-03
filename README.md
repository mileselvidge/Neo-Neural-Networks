# Neo
### _A basic Java Matrix Operations Library_

Neo is a mathematic library for Java containing a few useful and common matrix operations for a matrix datatype. It is written entirely from scratch and can be implemented into any project which requires large matrix operations. Most significantly, Neo was written with the intent of being used for my personal Machine Learning projects in the Processing IDE.

I intend to take this project further, realsing a further Machine Learning framework, specifically for Java and the Processing Environment. I am 17 years old and eager to gain insight and expertise from others, so any contributions to this project is welcomed! 

***

## The name

The 1999 Matrix introduced many of us into the beautiful term 'Matrix' for the first time. A term so powerful; at the core of liniar algebra, machine learning, and one of my favourite films. The film inspired me to name this library after Thomas A. Anderson, Neo.

***

## Functionality
* Create abstract Matrices or Vectors using the `JMatrix` datatype. 
* Initilize a variety of different common matrices, such as the null-matrix, ones-matrix and identity matrix.
* Perform arithmetic operations such as adding, subtracting, multiplying, and scaling matrices.
* Raise a matrix to any integer power, calculate the inverse, or any negetive integer power.
* Calculate the determinant and cofactors of a matrix.
* Calculate the transpose of a matrix and calculate sub-matrices.
* Append two matrices by row or by column.
* Determine whether a `JMatrix` is a vector and Vectorize a matrix.
* Dot-multiply each element of matrices of the same dimention. 
* Calculate the dot-product of two vectors.
* Display a matrix to the console.
* Output a matrix as a String or an array of strings to be stored in a CSV file.

*** 

## Repository contents 
Currently the repository contains:
1. The source code for the Matrix Operations library, Neo, named `JMatrix`.
2. The exported jar file for the Neo library.
3. A ready-to-go processing library folder, `Neo`.
4. A basic example of Neo in action, `Processing-Neo-Testing`, which contains a trivial linear regression with gradient descent/the normal equation problem (likely to be poorly optimised), written in Processing.

**Note: due to the poor optimisation of the inverse method, the normal equation solution to the example listed above is slow and unresponsive (the matrix is 47x47). I would recommend just testing gradient descent until updated.**

### Install: Processing
1. Install the `Neo` folder from the repo.
2. Place the folder in the libraries folder within your Processing folder (likely in the install location, mine was in my documents).
3. Whilst in Processing click on `Sketch` and then `Import Library` followed by `Neo`.
  - Alternatively, import `net.mileselvidge.neo.*; ` at the top of your code.

***

## Usage
**Note: In this implementation matrices are 1 indexed** 

### Creating a Matrix: 
There are a few different ways to initilize a matrix (of dimentions m x n).
```java
// 1. Create a matrix from a two dimentional array of double values.
JMatrix M = new JMatrix(new double[][] {{10, 2, -4.2}}, {2, 2.2, 3}, {-1, 3, 4}});

// 2. Create an empty m x n matrix containing zeros.
JMatrix N = new JMatrix(3, 2); // Creates a 3x2 null matrix

// 3. Create an identity matrix of dimention n x n
JMatrix P = new JMatrix(10); 

// 4. Create a matrix from another matrix.
JMatrix Q = new JMatrix(P);

// ... or just copy an existing matrix.
JMatrix Q = P.copy();

// Set or get values in a matrix
double topCorner = M.get(0, 0); // Returns the top element of the matrix
M.set(1, 2, 3.1415); // M(1,2) = 3.1415

```
Additionally, you may create one of the following matrices using any of the following static methods:
```java
JMatrix I = JMatrix.identity(3); // Creates a 3x3 identity matrix.
JMatrix Zeros = JMatrix.nullMatrix(4,1); Creates a 4-dimentional null vector.
JMatrix Ones = JMatrix.onesMatrix(2,10); // Creates a 2x10 ones matrix.
JMatrix Random = JMatrix.random(100,100); // Creates an 100x100 matrix containing random doubles (-1 to 1)!
```

### Arithmetic Operations on a Matrix:
Examples:
```java
// Simple
JMatrix C = JMatrix.add(A, B); // C = A+B (works only if A and B have the same dimention).
JMatric D = JMatrix.subtract(A,C); // D = A-C ('')

// Matrix-Matrix multiplication (Note: for this project, Vectors are included as matrices). 
JMatrix E = JMatrix.multiply(A,D); // E = A*D (standard rules of matrix multiplication, the number of columns in A must equal the number of rows in D for it to be possible; the output matrix, E, will have the A's number of rows and D's number of columns).

// Scalar-Matrix multiplication
JMatrix X = JMatrix.multiply(3, Y); // X = 3Y

JMatrix Z = JMatrix.dotMultiply(X, Y); // Only works for identical dimentions, multiplies each element of one matrix with its corresponding element in another.

// Powers and inverse matrices (only works on square matrices).
M = JMatrix.pow(M, 3); // M^3
M = M.pow(3); // Alternative writing

R = JMatrix.inv(M); // R = M^-1
R = M.inv(); // Alternative writing

S = M.pow(-3); // S = M^-3
```

### Matrix features
```java
double det = A.det(); // The determinant of A.
JMatrix Atranspose = A.transpose(); // The transpose matrix of A.
JMatrix Acofactor = JMatrix.cofactor(A); // Return the cofactor of A.
JMatrix Asub = JMatrix.subMatrix(A, 0, 0); // Returns a matrix which exludes the column 0 and row 0.

double dot JMatrix.dot(x, y); // Compute the dot product of two vectors.

int[] dimention = A.dimension(); // Returns the dimension of a matrix [number of rows, number of columns] or [number of rows] for a vector.

A.isSquare(); // Returns whether A is a square matrix.
A.isSingular(); // Returns whether A is a singular matrix.
A.isVector(); // Returns whether A is a vector.
JMatrix.canMultiply(A, B); // Returns whether two matracies can multiply.
JMatrix.isSameDimention(A, B); // Returns whether two matrices are of the same dimention.
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
JMatrix C = JMatrix.append(A, B, 1); // Example: append the contents of B to the end of A vertically.
```

***

## Todo
* Optimise the inverse function as this is particularly slow.
* Optimise multiplication, like above, perhaps using the `Strassen Algorithm`.

***

## References
* Wikipedia, Matrix: https://en.wikipedia.org/wiki/Matrix_(mathematics)
* The Strassen Algorithm: https://en.wikipedia.org/wiki/Strassen_algorithm



# Neo-Neural-Network
