package net.mileselvidge.neo;

import java.util.Random;
import net.mileselvidge.neo.exceptions.*;
import java.lang.reflect.Method;

/*
 * Neo: Java Machine Learning Library
 * A Machine Learning library for Java containing Neural Networks and Matrix Mathematics
 * by Miles Elvidge, 17
 * Contact: miles.elvidge@ntlworld.com
 * Started 01/05/17
 */

public class NMatrix {
	// This is my Matrix implementation.
	// It is WIP so performance might not be optimal.
	// NOTE: for my implementation, matrices are zero based
	
	private int rows;
	private int columns;
	private double[][] values; // Data representation of the matrix
	
	// Constructors 
	public NMatrix(NMatrix M) {
		// Initialise a matrix from another matrix 
		this.rows = M.rows;
		this.columns = M.columns;
		
		this.values = M.values;
	}

	public NMatrix(double[][] v) {
		// Initialise a matrix from a two dimensional array
		this.rows = v.length;
		this.columns = v[0].length;
		
		this.values = v;
	}
	
	// Construct a matrix from a one dimensional array (vector)
	public NMatrix(double[] v) {
		this.rows = v.length;
		this.columns = 1;
		this.values = new double[this.rows][this.columns];
		for(int i = 0; i < this.rows; i++) {
			this.values[i][0] = v[i];
		}
	}
	
	public NMatrix(int r, int c) {
		// Null Matrix constructor (any dimension)
		this.rows = r;
		this.columns = c;
		this.values = new double[this.rows][this.columns];
		this.nullify();
	}
	
	public NMatrix(int d) {
		// Identity matrix constructor
		this.rows = d;
		this.columns = d;
		this.values = new double[this.rows][this.columns];
		this.nullify();
		for(int i = 0; i < d; i++) { this.values[i][i] = 1; }
	}
	
	
	// Matrix self methods (many have a static counterpart)
	// Return an duplicate matrix
	public NMatrix copy() {
		return new NMatrix(this);
	}
	
	// Since the values array is private, here are functions to retrieve the values...
	// Get and set values at indices in the matrix
	public double get(int r, int c) { return values[r][c]; }
	public void set(int r, int c, double v) { this.values[r][c] = v; }
	
	// Returns the values array (which is private)
	public double[][] asArray() { return NMatrix.asArray(this); }
	
	// Returns the number of rows/columns the matrix has
	public int getRows() { return this.rows; }
	public int getColumns() { return this.columns; }
	
	// Returns the dimension of the matrix as an array
	public int[] dimension() { return NMatrix.dimension(this); }
	
	// Returns matrix transpose
	public NMatrix transpose() {
		return NMatrix.transpose(this);
	}
	
	// Returns the determinant
	public double det() throws MatrixNonSquareException { return NMatrix.det(this); }
	public NMatrix cofactor() throws MatrixNonSquareException { return NMatrix.cofactor(this); }
	
	// Raise the matrix to a given integer power
	public NMatrix pow(int n) throws MatrixNonSquareException, MatrixMultiplicationException, MatrixSingularException { return NMatrix.pow(this, n); }
	
	// Invert the matrix
	public NMatrix inv() throws MatrixNonSquareException, MatrixSingularException { return NMatrix.inv(this); }

	// Multiply the matrix by a scalar 
	public NMatrix scale(double a){ return NMatrix.multiply(a, this); }
	public NMatrix multiply(double a) { return this.scale(a); }
	
	// Apply a given function to the matrix
	public NMatrix map(Object obj, Method func) {
		return NMatrix.map(this, obj, func);
	}
	
	// Matrix properties (self explanatory)
	public boolean isSquare() { return NMatrix.isSquare(this); } // rows == columns 
	public boolean isSingular() throws MatrixNonSquareException { return NMatrix.isSingular(this); } // det(M) = 0
	public boolean isVector() { return NMatrix.isVector(this); } // columns = 1 
	
	// Output methods 
	// Return the matrix as a single string
	public String toString() { return NMatrix.toString(this); } 
	
	// Return the matrix as an array of rows where columns are separated by commas (CSV format)
	public String[] toCSV() { return NMatrix.toCSV(this); }
	
	// Print Matrix to console
	public void display() {
		for(int i = 0; i < this.rows; i++) {
			String r = "";
			for(int j = 0; j < this.columns; j++) {
				r = r + this.values[i][j] + " ";
			}
			System.out.println(r);
		}
	}
	
	// Create null matrix: Set every index of the matrix to 0
	private void nullify() {
		for(int i = 0; i < this.rows; i++) {
			for(int j = 0; j < this.columns; j++) {
				this.values[i][j] = 0;
			}
		}
	}
	
	// Static Methods
	
	// Arithmetic Operations
	
	// Add one matrix to another
	public static NMatrix add(NMatrix A, NMatrix B) throws MatrixDimensionException {
		if(NMatrix.isSameDimention(A, B)) {
			NMatrix C = new NMatrix(A.rows, A.columns);
			for(int i = 0; i < C.rows; i++) {
				for(int j = 0; j < C.columns; j++) {
					C.values[i][j] = A.values[i][j] + B.values[i][j];
				}
			}
			return C;
		} else {
			throw new MatrixDimensionException();
		}
	}
	
	// Add a scalar value across a matrix 
	public static NMatrix add(double a, NMatrix M) {
		NMatrix A = M.copy();
		for(int i = 0; i < A.rows; i++) {
			for(int j = 0; j < A.columns; j++) {
				A.values[i][j] += a;
			}
		}
		return A;
	}
	
	// Subtract one matrix from another
	public static NMatrix subtract(NMatrix A, NMatrix B) throws MatrixDimensionException {
		NMatrix C = NMatrix.scale(-1, B);
		return NMatrix.add(A, C);
	}
	
	// Return the inverse of a matrix
	public static NMatrix inv(NMatrix M) throws MatrixNonSquareException, MatrixSingularException {
		if(M.isSquare()) {
			double d = M.det();
			if(d == 0)
				throw new MatrixSingularException();
			return NMatrix.multiply(1.0/M.det(), NMatrix.cofactor(M).transpose());
		} else {
			throw new MatrixNonSquareException();
		}
	}
	
	// Multiply a matrix by a scalar value 
	public static NMatrix multiply(double a, NMatrix B){
		NMatrix C = B.copy();
		for(int i = 0; i < B.rows; i++) {
			for(int j = 0; j < B.columns; j++) {
				C.values[i][j] *= a;
			}
		}	
		return C;
	}
	public static NMatrix scale(double a, NMatrix B) { return NMatrix.multiply(a, B); }
	
	// Multiply one matrix with another
	public static NMatrix multiply(NMatrix A, NMatrix B) throws MatrixMultiplicationException  {
		if(!canMultiply(A, B)) {
			throw new MatrixMultiplicationException();
		} else {
			NMatrix C = new NMatrix(A.rows, B.columns);
			for(int i = 0; i < C.rows; i++) {
				for(int j = 0; j < C.columns; j++) {
					for(int k = 0; k < B.rows; k++) {
						C.values[i][j] += A.values[i][k] * B.values[k][j];
					}
				}
			}
			return C;
		}
	}
	
	// Compute the transpose of a given matrix 
	public static NMatrix transpose(NMatrix M) {
		NMatrix R = new NMatrix(M.columns, M.rows);
		for(int i = 0; i < M.rows; i++) {
			for(int j = 0; j < M.columns; j++) {
				R.values[j][i] = M.values[i][j];
			}
		}
		return R;
	}
	
	// Dot Multiply (Multiply each index of the matrix by its corresponding counterpart in another Matrix of same dimension)
	public static NMatrix dotMultiply(NMatrix A, NMatrix B) throws MatrixDimensionException {
		if(!NMatrix.isSameDimention(A, B)) { 
			throw new MatrixDimensionException();
		} else {
			NMatrix C = A.copy();
			for(int i = 0; i < C.rows; i++) {
				for(int j = 0; j < C.columns; j++) {
					C.values[i][j] *= B.values[i][j];
				}
			}
			return C;
		}
	}
	
	// Compute the vector dot product of two vectors 
	public static double dot(NMatrix a, NMatrix b) throws MatrixDimensionException, MatrixMultiplicationException {
		if(a.isVector() && b.isVector()) {
			NMatrix y = a.transpose();
			return NMatrix.multiply(y, b).values[0][0];
		} else {
			throw new MatrixDimensionException();
		}
	}
	
	// Raise a matrix to any given integer power
	public static NMatrix pow(NMatrix A, int p) throws MatrixNonSquareException, MatrixMultiplicationException, MatrixSingularException {
		if(NMatrix.isSquare(A)) {
			NMatrix M = A.copy();
			if(p == 0) { return new NMatrix(A.rows); }
			if(p < 0) { M = M.inv(); }
			for(int i = 1; i < p; i++){
				M = NMatrix.multiply(A, M);
			}
			return M;
		} else {
			throw new MatrixNonSquareException();
		}
	}
	
	// Matrix properties
	
	// Compute the determinant of a matrix
	public static double det(NMatrix M) throws MatrixNonSquareException {
		if(M.isSquare()) {
			double d = 0;
			// First consider trivial examples
			if(M.rows == 1) { d = M.values[0][0]; }
			if(M.rows == 2) { d = M.values[0][0]*M.values[1][1] - M.values[1][0]*M.values[0][1]; }
			else {
				// More complicated ones...
				for(int i = 0; i < M.rows; i++) {
					d += NMatrix.getCoefficient(i) * M.values[0][i] * NMatrix.det(NMatrix.subMatrix(M, 0, i));
				}
			}
			return d;
		} else {
			throw new MatrixNonSquareException();
		}
	}
	
	// Compute the cofactor of a matrix 
	public static NMatrix cofactor(NMatrix M) throws MatrixNonSquareException {
		NMatrix m = new NMatrix(M.rows, M.columns);
		for(int i = 0; i < m.rows; i++) {
			for(int j = 0; j < m.columns; j++) {
				m.values[i][j] = NMatrix.getCoefficient(i) * NMatrix.getCoefficient(j) * NMatrix.subMatrix(M, i, j).det();
			}
		}
		return m;
	}
	
	// Return a sub matrix with an excluded row and column
	public static NMatrix subMatrix(NMatrix M, int exRow, int exCol) {
		NMatrix m = new NMatrix(M.rows-1, M.columns-1);
		int r = -1;
		for(int i = 0; i < M.rows; i++) {
			if(i == exRow)
				continue;
			r++;
			int c = -1;
			for(int j = 0; j < M.columns; j++) {
				if(j == exCol) 
					continue;
				c++;
				m.values[r][c] = M.values[i][j];
			}
		}
		return m;
	}
	
	// Manipulate matrices 
	
	// Append two matrices to each other (vertically or horizontally)
	public static NMatrix appendColumns(NMatrix A, NMatrix B) throws MatrixDimensionException {
		if(A.rows == B.rows) { 
			NMatrix C = new NMatrix(A.rows, A.columns+B.columns);
			for(int i = 0; i < C.rows; i++) {
				for(int j = 0; j < A.columns; j++) { C.values[i][j] = A.values[i][j]; }
				for(int j = 0; j < B.columns; j++) { C.values[i][j+A.columns] = B.values[i][j]; }
			}
			return C;
		} else {
			throw new MatrixDimensionException();
		}
	}
	public static NMatrix appendRows(NMatrix A, NMatrix B) throws MatrixDimensionException {
		if(A.columns == B.columns) { 
			NMatrix C = new NMatrix(A.rows+B.rows, A.columns);
			for(int i = 0; i < A.rows; i++) {
				for(int j = 0; j < C.columns; j++) { C.values[i][j] = A.values[i][j]; }
			}
			for(int i = 0; i < B.rows; i++) {
				for(int j = 0; j < C.columns; j++) { C.values[i+A.rows][j] = B.values[i][j]; }
			}
			return C;
		} else {
			throw new MatrixDimensionException();
		}
	}
	public static NMatrix append(NMatrix A, NMatrix B, int option) throws MatrixDimensionException {
		// Append one matrix to another
		// Option 1: Append columns (horizontal), 
		// Option 2: Append rows (vertical)
		switch(option) {
		case 1: return appendColumns(A, B);
		case 2: return appendRows(A, B);
		default: return null;
		}
	}
	
	// Apply a function to all values in the matrix
	// Function must take a single double and return another double
	public static NMatrix map(NMatrix M, Object obj, Method func) {
		Object[] parameters = new Object[1];
		NMatrix m = M.copy();
		for(int i = 0; i < m.rows; i++){
			for(int j = 0; j < m.columns; j++) {
				try {
					parameters[0] = m.values[i][j];
					m.values[i][j] = (double) func.invoke(obj, parameters);
				} catch (Exception e) {
					System.out.println("Error: Could not apply function to Matrix!");
					e.printStackTrace();
				}
			}
		}
		return m;
	}
	
	// Matrix Properties (Boolean functions)
	public static boolean isSquare(NMatrix A) { return A.rows == A.columns; } // Rows == columns	
	public static boolean canMultiply(NMatrix A, NMatrix B) { return A.columns == B.rows; } // Determine whether matrix multiplication is possible
	public static boolean isSameDimention(NMatrix A, NMatrix B) { return A.rows == B.rows && A.columns == B.columns; } // Determine whether matrices are of the same dimention
	public static boolean isSingular(NMatrix A) throws MatrixNonSquareException { return A.det() == 0; } // det(M) = 0
	public static boolean isVector(NMatrix A) { return A.columns == 1; } // Columns = 1
	
	// Common Matrices (for constructors)
	public static NMatrix identity(int d) { return new NMatrix(d); }
	public static NMatrix nullMatrix(int r, int c) { return new NMatrix(r, c); } // Matrix of all zeros
	// Matrix of all ones
	public static NMatrix onesMatrix(int r, int c) {
		NMatrix M = new NMatrix(r, c);
		M = NMatrix.add(1, M);
		return M;
	}
	
	public static NMatrix fromArray(double[] vals) { 
		return new NMatrix(vals);
	}
	
	// Gaussian random doubles (Mean = 0; standard deviation = 1) in a r by c matrix 
	public static NMatrix random(int r, int c) {
		NMatrix M = new NMatrix(r, c);
		for(int i = 0; i < M.rows; i++) {
			for(int j = 0; j < M.columns; j++) {
				M.values[i][j] = new Random().nextGaussian();
			}
		}
		return M;
	}
	
	// Output methods 
	
	// Return Matrix in CSV format
	public static String[] toCSV(NMatrix M) {
		String mCSV[] = new String[M.rows];
		for(int i = 0; i < M.rows; i++) {
			String str = "";
			for(int j = 0; j < M.columns; j++) {
				str += M.get(i, j) + ",";
			}
			mCSV[i] = str;
		}
		return mCSV;
	}
	
	// Return Matrix as a large string (formatted with tabs and spaces)
	public static String toString(NMatrix M) {
		String mCSV = "";
		for(int i = 0; i < M.rows; i++) {
			String str = "";
			for(int j = 0; j < M.columns; j++) {
				str += M.get(i, j) + " ";
			}
			mCSV += str;
		}
		return mCSV;
	}
	
	// Return the private values array
	public static double[][] asArray(NMatrix M) { return M.values; }
	
	// Return the dimensions of a matrix in array format
	public static int[] dimension(NMatrix M) {
		if(M.isVector()) {
			return new int[] { M.rows };
		} else {
			return new int[] { M.rows, M.columns };
		}
	}
	
	// Append all columns of a matrix into one large vector 
	public static NMatrix vectorize(NMatrix M) {
		double[][] vals = new double[M.rows*M.columns][1];
		for(int i = 0; i < M.rows; i++) {
			for(int j = 0; j < M.columns; j++) {
				vals[i*M.columns + j][0] = M.values[i][j];
			}
		}
		return new NMatrix(vals);
	}
	
	// Compute the sum of all elements of a matrix
	public static double sum(NMatrix M) {
		NMatrix m = NMatrix.vectorize(M);
		double sum = 0;
		for(int i = 0; i < m.rows; i++) {
			sum += m.values[i][0];
		}
		return sum;
	}
	
	// Private methods
	private static int getCoefficient(int i) {
		// Returns 1 for an even value and -1 for an odd value...
		// To be used for getting cofactors.
		return i % 2 == 0 ? 1 : -1; 
	}
}