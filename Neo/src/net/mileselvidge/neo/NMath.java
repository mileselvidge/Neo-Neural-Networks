package net.mileselvidge.neo;

import java.util.Random;

/*
 * Neo: Java Machine Learning Library
 * A Machine Learning library for Java containing Neural Networks and Matrix Mathematics
 * by Miles Elvidge, 17
 * Contact: miles.elvidge@ntlworld.com
 * Started 01/05/17
 */

public class NMath {
	// A collection of commonly used mathematical functions	
	public NMath() {
	}
	
	// Sigmoid function: used for activation and classification (Logistic Regression)
	public static final double Sigmoid(double z) {
		return 1.0 / (1 + Math.pow(Math.E, -z));
	}
	
	// Sigmoid derivative function
	public static final double dSigmoid(double z) {
		return z * (1 - z);
	}
	
	// Hyperbolic tan function
	public static final double tanh(double z) {
		return Math.tanh(z);
	}
	
	// Hyperbolic tan derivative 
	public static final double dtanh(double z) {
		return 1.0 / (Math.pow(Math.cosh(z), 2));
	}
	
	// Genetic Algorithms: Mutation function
	public static final double mutate(double z) {
		if(new Random().nextDouble() > 0.9) { // Arbitrary frequency
			double offset = 0.05 - (new Random().nextDouble() / 10.0); // +/- 0.1 (Arbitrary)
			return Math.abs(z + offset) > 1 ? new Random().nextGaussian() : z + offset;
		} else {
			return z;
		}
	}
}
