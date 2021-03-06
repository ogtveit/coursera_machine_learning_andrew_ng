function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%

for i = 1:m
	y_i = zeros(num_labels, 1); % 10x1
	y_i(y(i)) = 1;

	a1 = [1 X(i,:)]; 	% 1x401
	z2 = Theta1 * a1'; % 25x401 * 401x1 = 25x1

	a2 = [1; sigmoid(z2)]; % 26x1
	z3 = Theta2 * a2; %10x26 * 26x1 = 10x1

	a3 = sigmoid(z3); h = a3; % 10x1
	
	
	J +=  (-y_i' * log(h) - (1-y_i') * log(1 - h));
endfor

J = (1/m) * J;


% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%

for t  = 1:m
	y_t = zeros(num_labels, 1); % 10x1
	y_t(y(t)) = 1;
	
	a1 = [1 X(t,:)]; 	% 1x401
	z2 = Theta1 * a1'; % 25x401 * 401x1 = 25x1

	a2 = [1; sigmoid(z2)]; % 26x1
	z3 = Theta2 * a2; %10x26 * 26x1 = 10x1

	a3 = sigmoid(z3); 
	h = a3; % 10x1
	
	d3 = a3 - y_t; %10x1
	
	d2 = Theta2' * d3 .* sigmoidGradient([1; z2]); % = 26x1
	
	d2 = d2(2:end); % = 25x1
	
	
	Theta1_grad = Theta1_grad + d2 * a1; %25x401 = 25x1 * 1x401
	Theta2_grad = Theta2_grad + d3 * a2';  %10x26 = 10x1 * 1x26
endfor

Theta1_grad = Theta1_grad / m;
Theta2_grad = Theta2_grad / m;


% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% add regularization
regu1 = eye(size(Theta1,2)); %Size_2 x Size_2, skal ganges med f.eks ?xSize_2
regu1(1,1) = 0;

regu2 = eye(size(Theta2,2)); %Size_2 x Size_2, skal ganges med f.eks ?xSize_2
regu2(1,1) = 0;

% regu to cost
J += (lambda/(2 * m)) * (sum(sum( (Theta1 * regu1).^2 )') + sum(sum( (Theta2 * regu2).^2 )'));

% regu to grads
Theta1_grad = Theta1_grad + lambda/m * (Theta1 * regu1);
Theta2_grad = Theta2_grad + lambda/m * (Theta2 * regu2);

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
