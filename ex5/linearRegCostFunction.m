function [J, grad] = linearRegCostFunction(X, y, theta, lambda)
%LINEARREGCOSTFUNCTION Compute cost and gradient for regularized linear 
%regression with multiple variables
%   [J, grad] = LINEARREGCOSTFUNCTION(X, y, theta, lambda) computes the 
%   cost of using theta as the parameter for linear regression to fit the 
%   data points in X and y. Returns the cost in J and the gradient in grad

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost and gradient of regularized linear 
%               regression for a particular choice of theta.
%
%               You should set J to the cost and grad to the gradient.
%

regu = eye(length(theta));
regu(1,1) = 0;

% cost
J = 1/(2*m) * sum((X*theta - y).^2 );

% cost + regu
J = J + lambda/(2*m) * sum((regu * theta).^2);

% grad
grad = 1/m * sum((X*theta - y) .* X)';

% grad + regu
grad = grad + lambda/m * (regu * theta);



% =========================================================================

grad = grad(:);

end