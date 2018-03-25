function dataset = GenerateDataset(n, p, k, pd, varargin)
% dataset = GenerateDataset(n, p, k, pd, varargin)
%   Generate synthetic dataset for further use.
% ----
% Args:
%   n: the number of samples in each class (scalar)
%   p: the number of features (scalar)
%   k: the number of classes (scalar)
%   pd: probability distribution of generated data (string)
%   varargin: parameters on p 
% ----
% Returns:
%   dataset: generated dataset

% Pre-allocate dataset to avoid memory overflow
dataset = zeros(n * k, p);

% Generate dataset from gaussian distribution
if((strcmp(pd, 'Gaussian')) || strcmp(pd, 'gaussian'))
    
    % Get parameters on gaussian distribution
    mu = varargin{1, 1}; % (k * p)
    sigma = varargin{1, 2}; % (k * p)
    
    for i = 1 : k
        dataset(n*(i-1)+1:n*i, :) = mvnrnd(mu(i,:), sigma(i,:), n);
    end   
end

% Random permutation
dataset = dataset(randperm(size(dataset, 1)), :);

end

