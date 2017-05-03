package net.mileselvidge.neo.exceptions;

public class MatrixSingularException extends Exception {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public MatrixSingularException() {
		System.out.println("Singular Matrix Exception: an operation could not be completed as a matrix is singular!");
	}
}
