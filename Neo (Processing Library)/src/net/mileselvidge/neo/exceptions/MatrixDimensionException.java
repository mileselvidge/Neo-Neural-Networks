package net.mileselvidge.neo.exceptions;

public class MatrixDimensionException extends Exception {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public MatrixDimensionException(){
		System.out.println("Matrix Dimension Exception: an operation requires two matrices of the same dimension.");
	}
}
