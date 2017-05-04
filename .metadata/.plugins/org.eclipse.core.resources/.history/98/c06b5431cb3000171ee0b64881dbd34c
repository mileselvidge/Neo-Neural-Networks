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
	// A basic neural network structure
	
	// Number of nodes in different layers
	private int inputSize;
	private int hiddenSize; // TODO: Multiple layers (currently limited to 3)
	private int outputSize;
	
	// Functions for calculating activation and derivatives
	private Method activation;
	private Method derivative;
	
	// Weight Matrices
	private NMatrix wIH;
	private NMatrix wHO;
	
	public double learningRate;
	
	// Constructors 

	// Initialise from scratch 
	public NeuralNetwork(int inputN, int hiddenN, int outputN, double lr, String activationType) {
		this.inputSize = inputN;
		this.hiddenSize = hiddenN;
		this.outputSize = outputN;
		
		this.learningRate = lr;
		
		// Initialise weights with random gaussian values
		wIH = NMatrix.random(this.hiddenSize, this.inputSize);
		wHO = NMatrix.random(this.outputSize, this.hiddenSize);
		
		// Initialise the activation/derivative functions
		NMath math = new NMath();
		try {
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
		this.inputSize = net.inputSize;
		this.hiddenSize = net.hiddenSize;
		this.outputSize = net.outputSize;
		this.learningRate = net.learningRate;
		this.wHO = net.wHO;
		this.wIH = net.wIH;
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
			
			// Move from input to hidden layer by multiplying weights (wIH) and inputs
			NMatrix hiddenInputs = NMatrix.multiply(this.wIH, inputs);
			
			// Move from hidden layer to outputs using sigmoid activation function
			NMatrix hiddenOutputs = NMatrix.map(hiddenInputs, this, this.activation);
			
			// The input-output layer is the weights (wHO) * the hidden layer
			NMatrix outputInputs = NMatrix.multiply(this.wHO, hiddenOutputs);
			
			// The output of the network must once more be passed through the sigmoid/tanh activation function
			NMatrix outputs = NMatrix.map(outputInputs, this, this.activation);
			
			return outputs.transpose().asArray()[0]; // as regular 1D array like inputs
		} catch (Exception e) {
			System.out.println("Fatal Error occoured: contact developer!");
			return new double[] {0};
		}
	}
	
	// Train the neural network
	public void train(double[] inputsArr, double[] targetArr) {
		try {
			// Turn inputs & targets in matrices
			NMatrix inputs = NMatrix.fromArray(inputsArr);
			NMatrix targets = NMatrix.fromArray(targetArr);
			
			// Input to hidden layer is wIH multiplied by the inputs
			NMatrix hiddenInputs = NMatrix.multiply(this.wIH, inputs);
			
			// Then the outputs of the hidden layer are passed through the activation function
			NMatrix hiddenOutputs = NMatrix.map(hiddenInputs, this, this.activation);
			
			// Input-to-output layer is weights (wHO) multiplied by hidden layer
			NMatrix outputInputs = NMatrix.multiply(this.wHO, hiddenOutputs);
			
			// The output of the network passes through the sigmoid function oncemore...
			NMatrix outputs = NMatrix.map(outputInputs, this, this.activation);
			
			// Calculate error
			// This is target - output
			NMatrix outputErrors = NMatrix.subtract(targets, outputs);
			
			// Commence back propagation (Output <-> Hidden)
			// Transpose hidden to output layer
			NMatrix wHO_T = this.wHO.transpose();
			
			// Multiply output error by weights (wHO) for hidden errors
			NMatrix hiddenErrors = NMatrix.multiply(wHO_T, outputErrors);
			
			// Calculate the gradient of high dimensional surface...
			NMatrix grad_out = NMatrix.map(outputs, this, this.derivative);
			
			// Weigh by error and learning rate
			grad_out = NMatrix.dotMultiply(grad_out, outputErrors);
			grad_out = grad_out.scale(this.learningRate);
			
			// Continue back propagating (Hidden <-> Input)
			NMatrix grad_hidden = NMatrix.map(hiddenOutputs, this, this.derivative);
			grad_hidden = NMatrix.dotMultiply(grad_hidden, hiddenErrors);
			grad_hidden = grad_hidden.scale(this.learningRate);
			
			// Change weights
			// Calculate delta (Input -> Hidden)
			NMatrix inputs_T = inputs.transpose();
			NMatrix delta_hidden = NMatrix.multiply(grad_hidden, inputs_T);
			this.wIH = NMatrix.add(this.wIH, delta_hidden); // Update 
			
			// Calculate delta (Hidden -> Output)
			NMatrix hidden_outputs_T = hiddenOutputs.transpose();
			NMatrix delta_output = NMatrix.multiply(grad_out, hidden_outputs_T);
			this.wHO = NMatrix.add(this.wHO, delta_output);
		} catch (Exception e) {
			System.out.println("Fatal Error occoured: contact developer!");
			e.printStackTrace();
		}
	}
}
