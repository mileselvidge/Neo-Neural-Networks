package net.mileselvidge.neo.exceptions;

public class MatrixMultiplicationException extends Exception {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public MatrixMultiplicationException() {
		System.out.println("Matrix Multiplication Exception: two matrices are of the wrong dimension and thus non-multiplicable!");
	}
}
