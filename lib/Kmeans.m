function [centroid, class] = Kmeans(data, k, iteration)
% Main part of Kmeans clustering algorithm.
%
% Args:
%   data: data to be clustered (n * p)
%   k: the number of classes
%   iteration: maximum number of iterations
%
% Returns:
%   centroid: clustering centroids for all classes
%   class: corresponding class for all samples

% Choose k initial centroids randomly
centroid = data(randperm(size(data,1),k)', :);

% Record distances between samples and centroids
distance_matrix = zeros(size(data,1), k);

% Pre-allocate result
class = zeros(size(data,1),1);

for i = 1:iteration
    
    previous_result = class; % for early termination
    
    % Calculate eculidean distance between each sample and each centroid
    for j = 1:size(distance_matrix,1)
        for k = 1:size(distance_matrix,2)
            distance_matrix(j,k) = sqrt((data(j,:)-centroid(k,:)) * (data(j,:)-centroid(k,:))');
        end
    end
    
    % Assign each sample to the nearest controid
    [~,class] = min(distance_matrix,[],2);
    
    % Recalculate centroids
    for j = 1:k
        centroid(j,:) = mean(data(class(:,1) == j,:));
    end
    
    % Display
    fprintf('---- %ith iteration completed ----\n',i);
    
    % If classified results on all points do not change after an iteration, 
    % the clustering process will quit immediately.
    if(class == previous_result)
        fprintf('**** Clustering over after %i iterations ****\n',i);
        break;
    end
end
end
