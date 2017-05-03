package net.mileselvidge.neo.exceptions;

public class MatrixNonSquareException extends Exception {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public MatrixNonSquareException() {
		System.out.println("Non-Square Matrix Exception: an operation which requires a square matrix is being parsed a non-square matrix!");
	}
}
