function [centroid, result] = Clustering(data, method, varargin)
% Currently, following clustering algorithms are supported:
%   1. Kmeans
%   2. Kmeans++
%   3. ISODATA (Iterative Self-Organizing Data Analysis)
%   4. Mean Shift
%   5. DBSCAN (Density-Based Spatial Clustering of Application with Noise)

addpath('.\lib');

% Check input validity
if((strcmp(method,'kmeans') || strcmp(method,'kmeans++')) && (size(varargin,2) ~= 2))
    error('The value of K should be predefined when using k-means and k-means++.');
elseif((strcmp(method,'isodata') || strcmp(method,'ISODATA')) && (size(varargin,2) < 5))
    error('Not enough input for ISODATA. Please use help for more information.');
elseif((strcmp(method,'mean_shift') || strcmp(method,'Mean_Shift')) && (size(varargin,2) ~= 1))
    error('Invalid number of input for mean shift.');
elseif((strcmp(method,'dbscan') || strcmp(method,'DBSCAN')) && (size(varargin, 2) ~= 2))
    error('Invalid number of input for dbscan.');
end

% Method entries

% Kmeans
if(strcmp(method,'kmeans'))
    k = varargin{1,1};
    iteration = varargin{1,2};
    [centroid, result] = Kmeans(data, k, iteration);
% Kmeans++
elseif(strcmp(method,'kmeans++') || strcmp(method,'kmeanspp')) 
    k = varargin{1,1};
    iteration = varargin{1,2};
    [centroid, result] = Kmeanspp(data, k, iteration);  
% ISODATA
elseif(strcmp(method,'ISODATA') || strcmp(method,'isodata'))
    desired_k = varargin{1,1}; % desired number of classes
    iteration = varargin{1,2}; % maximum iteration time
    minimum_n = varargin{1,3}; % minimum number of samples in one class
    maximum_variance = varargin{1,4}; % maximum allowed variance of samples in one class
    minimum_d = varargin{1,5}; %  minimum distance between two classes
    [centroid, result] = ISODATA(data, iteration, desired_k, minimum_n, maximum_variance, minimum_d);
% Mean Shift
elseif(strcmp(method,'mean_shift') || strcmp(method,'Mean_Shift'))
    thr = varargin{1,1}; % distance threshold
    [centroid, result] = Mean_Shift(data, thr);
% DBSCAN
elseif(strcmp(method,'dbscan') || strcmp(method,'DBSCAN'))
    epsilon = varargin{1,1}; % distance threshold for finding neighbors
    minPts = varargin{1,2};% minimum required number of neighbor points for adding one core object
    centroid = nan; % DBSCAN will not calculate centroid
    result = DBSCAN(data, epsilon, minPts);
else
    error('Unknown method!');
end

end


