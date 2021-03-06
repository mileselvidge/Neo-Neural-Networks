package net.mileselvidge.neo;
import java.lang.reflect.Method;

/*
 * Neo: Java Machine Learning Library
 * A Machine Learning library for Java containing Neural Networks and Matrix Mathematics
 * by Miles Elvidge, 17
 * Contact: miles.elvidge@ntlworld.com
 * Started 01/05/17
 */

public class NeuralNetwork {
	// A not so basic deep neural network structure
	
	// Number of nodes in different layers
	private int[] layers;
	
	// Functions for calculating activation and derivatives
	private Method activation;
	private Method derivative;
	private Method mut;
	
	// Weight Matrices
	private NMatrix[] weights;
	
	public double learningRate;
	
	// Constructors 

	// Initialise from scratch 
	public NeuralNetwork(int inputSize, int hiddenSizes[], int outputSize, double lr, String activationType) {
		// Initialise layers of neural network
		this.layers = new int[hiddenSizes.length+2];
		
		// Initialise input/output layers of the neural network
		this.layers[0] = inputSize;
		this.layers[this.layers.length-1] = outputSize;
		
		// Initialise hidden layers
		for(int i = 1; i < this.layers.length-1; i++) {
			this.layers[i] = hiddenSizes[i-1];
		}
		
		this.learningRate = lr;
		
		// Initialise weights with random gaussian values
		weights = new NMatrix[this.layers.length-1];
		for(int i = 0; i < weights.length; i++) {
			weights[i] = NMatrix.random(this.layers[i+1], this.layers[i]);
 		}
		
		// Initialise the activation/derivative functions
		NMath math = new NMath();
		try {
			mut = math.getClass().getMethod("mutate", Double.TYPE);
			if(activationType.toLowerCase() == "tanh"){
				activation = math.getClass().getMethod("tanh", Double.TYPE);
				derivative = math.getClass().getMethod("dtanh", Double.TYPE);
			} else {
				// Default
				activation = math.getClass().getMethod("Sigmoid", Double.TYPE);
				derivative = math.getClass().getMethod("dSigmoid", Double.TYPE);
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	
	// Initialise a neural network from a neural network
	public NeuralNetwork(NeuralNetwork net){
		this.layers = net.layers;
		this.learningRate = net.learningRate;
		this.weights = net.weights;
		this.activation = net.activation;
		this.derivative = net.derivative;
	}
	
	public NeuralNetwork copy() {
		return new NeuralNetwork(this); 
	}
	
	// Query the network
	public double[] query(double[] inputsArr){
		try {
			// Convert inputs array to a matrix
			NMatrix inputs = NMatrix.fromArray(inputsArr);
			NMatrix current = inputs.copy();
			
			for(int i = 0; i < weights.length; i++) {
				NMatrix hiddenLayer = NMatrix.multiply(weights[i], current);
				current = NMatrix.map(hiddenLayer, this, this.activation);
			}
			
			return current.transpose().asArray()[0]; // Outputs
		} catch (Exception e) {
			System.out.println("Fatal Error occoured: contact developer!");
			return new double[] {0};
		}
	}
	
	// Train the neural network
	public void train(double[] inputsArr, double[] targetArr) {
		try {
			// Turn inputs & targets as matrices
			NMatrix inputs = NMatrix.fromArray(inputsArr);
			NMatrix targets = NMatrix.fromArray(targetArr);
		
			NMatrix[] outputs = new NMatrix[this.weights.length];
			
			// Forward propagation
			for(int i = 0; i < this.weights.length; i++) {
				NMatrix L = inputs.copy();
				if(i != 0) { L = outputs[i-1].copy(); }
				NMatrix hiddenLayer = NMatrix.multiply(this.weights[i], L);
				outputs[i] = NMatrix.map(hiddenLayer, this, this.activation);
			}
			
			// Calculate error
			// This is target - output
			
			// Commence back propagation for all nodes
			NMatrix error = NMatrix.subtract(targets, outputs[weights.length-1]);
			NMatrix grads[] = new NMatrix[weights.length];
			for(int i = this.weights.length-1; i >= 0; i--) {
				NMatrix hidden_T = this.weights[i].transpose();
				NMatrix grad = NMatrix.map(outputs[i], this, this.derivative);
				grad = NMatrix.dotMultiply(grad, error);
				grad = grad.scale(this.learningRate);
				grads[i] = grad.copy();
				error = NMatrix.multiply(hidden_T, error);
			}
			
			// Change weights
			// Calculate delta in weight and add to existing weights
			for(int i = 0; i < this.weights.length; i++) {
				NMatrix layer_T = inputs.transpose();
				if(i != 0) { layer_T = outputs[i-1].transpose(); }
				NMatrix delta_hidden = NMatrix.multiply(grads[i], layer_T);
				this.weights[i] = NMatrix.add(this.weights[i], delta_hidden); // Update 
			}
		} catch (Exception e) {
			System.out.println("Fatal Error occoured: contact developer!");
			e.printStackTrace();
		}
	}
	
	// Return dimensions of neural network
	public NMatrix[] getNetwork() {
		return weights;	
	}
	
	public void mutate(){
		// For neural networks which involve genetic evolution I implemented a very simple function
		for(int i = 0; i < this.weights.length; i++){
			this.weights[i].map(this, mut);
		}
	}
	
}