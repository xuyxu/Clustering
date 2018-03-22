function [centroid, result] = Clustering(data, method, varargin)

addpath('.\lib');

% Check validity
if((strcmp(method,'kmeans') || strcmp(method,'kmeans++')) && (size(varargin,2) ~= 2))
    error('The value of K should be predefined when using k-means and k-means++.');
elseif((strcmp(method,'isodata') || strcmp(method,'ISODATA')) && (size(varargin,2) < 5))
    error('Not enough input for ISODATA. Please use help for more information.');
elseif((strcmp(method,'mean_shift') || strcmp(method,'Mean_Shift')) && (size(varargin,2) ~= 1))
    error('Invalid number of input for mean shift.');
end

% Entrance
if(strcmp(method,'kmeans')) 
    k = varargin{1,1};
    iteration = varargin{1,2};
    [centroid, result] = Kmeans(data, k, iteration);
elseif(strcmp(method,'kmeans++')) 
    k = varargin{1,1};
    iteration = varargin{1,2};
    [centroid, result] = Kmeanspp(data, k, iteration);   
elseif(strcmp(method,'ISODATA') || strcmp(method,'isodata'))
    desired_k = varargin{1,1}; % desired number of classes
    iteration = varargin{1,2}; % maximum iteration time
    minimum_n = varargin{1,3}; % minimum number of samples in one class
    maximum_variance = varargin{1,4}; % maximum allowed variance of samples in one class
    minimum_d = varargin{1,5}; %  minimum distance between two classes
    [centroid, result] = ISODATA(data, iteration, desired_k, minimum_n, maximum_variance, minimum_d);
elseif(strcmp(method,'mean_shift') || strcmp(method,'Mean_Shift'))
    thr = varargin{1,1}; % distance threshold
    [centroid, result] = Mean_Shift(data, thr);
else
    error('Unknown method...');
end

end


