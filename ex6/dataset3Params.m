function [C, sigma] = dataset3Params(X, y, Xval, yval)
%DATASET3PARAMS returns your choice of C and sigma for Part 3 of the exercise
%where you select the optimal (C, sigma) learning parameters to use for SVM
%with RBF kernel
%   [C, sigma] = DATASET3PARAMS(X, y, Xval, yval) returns your choice of C and 
%   sigma. You should complete this function to return the optimal C and 
%   sigma based on a cross-validation set.
%

% You need to return the following variables correctly.
C = 1;
sigma = 0.1;

% ====================== YOUR CODE HERE ======================
% Instructions: Fill in this function to return the optimal C and sigma
%               learning parameters found using the cross validation set.
%               You can use svmPredict to predict the labels on the cross
%               validation set. For example, 
%                   predictions = svmPredict(model, Xval);
%               will return the predictions on the cross validation set.
%
%  Note: You can compute the prediction error using 
%        mean(double(predictions ~= yval))
%

%{
c_vec = [0.01; 0.03; 0.1; 0.3; 1; 3; 10; 30];
sig_vec = [0.01; 0.03; 0.1; 0.3; 1; 3; 10; 30];

errors = zeros(length(c_vec),length(sig_vec));

for cc = 1:length(c_vec)

  for sigs = 1:length(sig_vec)

    in_c = c_vec(cc);
    in_sig = sig_vec(sigs);

    model = svmTrain(X, y, in_c, @(x1, x2) gaussianKernel(x1, x2, in_sig));
    % model= svmTrain(X, y, C, @(x1, x2) gaussianKernel(x1, x2, sigma)); 
    predictions = svmPredict(model, Xval);
    errors(cc, sigs) = mean(double(predictions ~= yval));

  endfor

endfor

[~, sig_i] = min(min(errors));
[~, c_i] = min(errors(:,sig_i));

C = c_vec(c_i)
sigma = sig_vec(sig_i)

%}

% =========================================================================

end
