% This function uses three different algorithms for clustering.
% Specifically, K-means, K-means++, and ISODATA are supported.
% 
% Syntax:
% [result] = Clustering(data, method, optionvalue...);
% (1)If method is kmeans or kmeans++:
%   [result] = Clustering(data, method, k, iteration);
%   Data is classified into k different classes within designated iteration 
%   time.
%   Input:
%   The input parameter data should be a matrix with each row corresponding 
%   to one sample represented by a vector.

function [result] = Clustering(data, method, varargin)

if((strcmp(method,'kmeans') || strcmp(method,'kmeans++')) && (size(varargin,2) ~= 2))
    error('The value of K should be predefined when using k-means and k-means++.');
elseif((strcmp(method,'isodata') || strcmp(method,'ISODATA')) && (size(varargin,2) < 5))
    error('Not enough input for ISODATA. Please use help for more information');
end

if(strcmp(method,'kmeans'))
    k = varargin{1,1};
    iteration = varargin{1,2};
    result = Kmeans(data, k, iteration);
elseif(strcmp(method,'kmeans++'))
    k = varargin{1,1};
    iteration = varargin{1,2};
    result = Kmeanspp(data, k, iteration);
elseif(strcmp(method,'ISODATA') || strcmp(method,'isodata'))
    iteration = varargin{1,1};
    desired_k = varargin{1,2};
    minimum_n = varargin{1,3};
    maximum_variance = varargin{1,4};
    minimum_d = varargin{1,5};
    result = ISODATA(data, iteration, desired_k, minimum_n, maximum_variance, minimum_d);
else
    error('Unknown method...');
end
end

%----------------------%
% main body of k-means %
%----------------------%
function [result] = Kmeans(data, k, iteration)
% Choose initial k cluster centroids randomly
centroid = data(randperm(size(data,1),k)', :);
% pre-allocate a variable to record distances between samples and centroids
distance_matrix = zeros(size(data,1), k);
% pre-allocate result
result = zeros(size(data,1),1);
% used to monitor changes on result
previous_result = zeros(size(data,1),1);
for i = 1:iteration
    previous_result = result;
    % calculate distance between each sample and each centroid
    for j = 1:size(distance_matrix,1)
        for k = 1:size(distance_matrix,2)
            distance_matrix(j,k) = sqrt(sum((data(j,:)-centroid(k,:)) .^ 2));
        end
    end
    % assign each sample to the nearest controid
    [~,result] = min(distance_matrix,[],2);
    % recalculate centroid locations after assignment
    for j = 1:k
        centroid(j,:) = mean(data(find(result(:,1) == j),:));
    end
    % if classified results on all samples do not change after an iteration, 
    % clustering process will quit earlier.
    if(result == previous_result)
        fprintf('Clustering over after %i iterations\n',i);
        break;
    end
end
end

%------------------------%
% main body of k-means++ %
%------------------------%
function [result] = Kmeanspp(data, k, iteration)
% choose an initial centroid at random from data
centroid = data(randperm(size(data,1),1)',:);
% choose rest centroids through roulette method
for i = 2:k
    distance_matrix = zeros(size(data,1),i-1);
    for j = 1:size(distance_matrix,1)
        for k = 1:size(distance_matrix,2)
            distance_matrix(j,k) = sum((data(j,:)-centroid(k,:)) .^ 2);
        end
    end
    % Choose next centroid according to distances between samples and
    % previous centroids.
    index = Roulettemethod(distance_matrix);
    centroid(i,:) = data(index,:);
    clear distance_matrix;
end
% following steps are same to original k-means
result = zeros(size(data,1),1);
previous_result = zeros(size(data,1),1);
distance_matrix = zeros(size(data,1), k);

for i = 1:iteration
    previous_result = result;
    % calculate distance between each sample and each centroid
    for j = 1:size(distance_matrix,1)
        for k = 1:size(centroid,1)
            distance_matrix(j,k) = sqrt(sum((data(j,:)-centroid(k,:)) .^ 2));
        end
    end
    % assign each sample to the nearest controid
    [~,result] = min(distance_matrix,[],2);
    % recalculate centroid locations after assignment
    for j = 1:k
        centroid(j,:) = mean(data(find(result(:,1) == j),:));
    end
    % if classified results on all samples do not change after an iteration, 
    % clustering process will quit earlier.
    if(result == previous_result)
        fprintf('Clustering over after %i iterations\n',i);
        break;
    end
end
end

% Roulette method used to select next cluster centroid
function [index] = Roulettemethod(distance_matrix)
% find shortest distance between one sample and its closest center
[min_distance,~] = min(distance_matrix,[],2);
% make sure the sum of min_distance is 1
min_distance = min_distance ./ sum(min_distance);
% construct roulette according to min_distance
temp_roulette = zeros(size(distance_matrix,1),1);
for i = 1:size(distance_matrix,1)
    temp_roulette(i,1) = sum(min_distance(1:i,:));
end
% generate a random number for final selection
temp_rand = rand();
% find its corresponding index
for i = 1:size(temp_roulette,1)
    if((i == 1) && temp_roulette(i,1) > temp_rand)
        index = 1;
    elseif((temp_roulette(i,1) > temp_rand) && (temp_roulette(i-1,1) < temp_rand))
        index = i;
    end
end
end

%------------------------%
%  main body of ISODATA  % 
%------------------------%
function [result] = ISODATA(data, iteration, desired_k, minimum_n, maximum_variance, minimum_d)
% same to traditional kmeans
centroid = data(randperm(size(data,1),desired_k)', :);
distance_matrix = zeros(size(data,1), desired_k);
result = zeros(size(data,1),1);
previous_result = zeros(size(data,1),1);

for i = 1 : iteration
    previous_result = result;
    for j = 1 : size(distance_matrix,1)
        for k = 1 : size(distance_matrix,2)
            distance_matrix(j,k) = sqrt(sum((data(j,:)-centroid(k,:)) .^ 2));
        end
    end
    [~,result] = min(distance_matrix,[],2);
    % judge whether the number of samples in each class is smaller than minimum_n
    for j = 1 : size(centroid, 1)
       if(isempty(find(result == j,1)) || (size(find(result == j),1) < minimum_n))
           % one class with number of samples in it less than minimum_n
           % should be deleted, along with records in the distance_matrix
           centroid(j,:) = [];
           distance_matrix(:,j) = [];
       end
    end
    % reassign each sample to its closet neighbor class
    [~,result] = min(distance_matrix,[],2);
       
    % recalculate centroid locations
    for j = 1:size(centroid,1)
       centroid(j,:) = mean(data(find(result(:,1) == j),:));
    end
    
    % judge if combine and split operations are needed
    if(size(centroid,1) <= (desired_k/2)) % too few classes
        
        [centroid] = ISODATA_split(centroid, result, minimum_n, maximum_variance);
        
    elseif(size(centroid,1) >= (2*desired_k)) % too many classes
        
        [centroid] = ISODATA_combine(centroid, result, minimum_d);
        
    end
    
end
end

% split operation of ISODATA
function [centroid] = ISODATA_split(centroid, current_result, minimum_n, maximum_variance)
centroid_x = size(centroid,1);
centroid_y = size(centroid,2);
variance_matrix = zeros(centroid_x, centroid_y); % pre-allocate the variance matrix

for i = 1 : centroid_x
    for j = 1 : centroid_y
        variance_matrix(i,j) = var(current_result(find(current_result == i),j));
    end
end

class_variance = max(variance_matrix,[],2); % find the greatest one-dimension variance per class 

for i = 1 : centroid_x
    if((class_variance(i,1) > maximum_variance) && size(find(current_result == i),1) > (2*minimum_n))
        % current class should be splitted into two different classes
        centroid(i,:) = centroid(i,:) + sqrt(maximum_variance);
        centroid(end+1,:) = centroid(i,:) - sqrt(maximum_variance); % add a new class at the end of centroid
    end
end

end

% combine operation of ISODATA
% the number of combine operation is restriced to one each time
function [centroid] = ISODATA_combine(centroid, current_result, minimum_d)
centroid_x = size(centroid,1);
class_distance_matrix = zeros(centroid_x, centroid_x);
% calculate distances between two different classes
for i = 1 : x
    for j = 1 : x
        if(i ~= j)
            class_distance_matrix(i,j) = sqrt(sum((centroid(i,:)-centroid(j,:)) .^ 2));
        end
    end
end

% combine two classes
for i = 1 : x
    for j = 1 : x
        if((i ~= j) && (class_distance_matrix(i,j) <  minimum_d))
            n1 = size(find(current_result == i),1);
            n2 = size(find(current_result == j),1);
            centroid(i,:) = (1/(n1+n2)) * (n1 * centroid(i,:) + n2 * centroid(j,:));
            centroid(j,:) = [];
        end
    end
end

end
