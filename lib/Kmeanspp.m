function [centroid, class] = Kmeanspp(data, k, iteration)
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

% Choose the first inital centroid randomly
centroid = data(randperm(size(data,1),1)',:);

% Select remaining initial centroids (a total number of k-1)
for i = 2:k
    distance_matrix = zeros(size(data,1),i-1);
    for j = 1:size(distance_matrix,1)
        for k = 1:size(distance_matrix,2)
            distance_matrix(j,k) = sum((data(j,:)-centroid(k,:)) .^ 2);
        end
    end
    % Choose next centroid according to distances between points and
    % previous cluster centroids.
    index = Roulettemethod(distance_matrix);
    centroid(i,:) = data(index,:);
    clear distance_matrix;
end

% Following steps are same to kmeans
class = zeros(size(data,1),1);
distance_matrix = zeros(size(data,1), k);

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
    fprintf('---- %ith iteration completed---- \n',i);
    
    % If classified results on all points do not change after an iteration, 
    % the clustering process will quit immediately.
    if(class == previous_result)
        fprintf('**** Clustering over after %i iterations ****\n',i);
        break;
    end
end
end

function [index] = Roulettemethod(distance_matrix)

% Find shortest distance between one sample and its closest cluster centroid
[min_distance,~] = min(distance_matrix,[],2);

% Normalize for further operations
min_distance = min_distance ./ sum(min_distance);

% Construct roulette according to min_distance
temp_roulette = zeros(size(distance_matrix,1),1);
for i = 1:size(distance_matrix,1)
    temp_roulette(i,1) = sum(min_distance(1:i,:));
end

% Generate a random number for selection
temp_rand = rand();

% Find the corresponding index
for i = 1:size(temp_roulette,1)
    if((i == 1) && temp_roulette(i,1) > temp_rand)
        index = 1;
    elseif((temp_roulette(i,1) > temp_rand) && (temp_roulette(i-1,1) < temp_rand))
        index = i;
    end
end
end
