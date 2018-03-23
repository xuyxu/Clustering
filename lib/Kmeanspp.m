function [centroid, result] = Kmeanspp(data, k, iteration)

% Choose an initial centroid randomly
centroid = data(randperm(size(data,1),1)',:);

% Choose other centroids (a total number of k-1)
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
result = zeros(size(data,1),1);
distance_matrix = zeros(size(data,1), k);

for i = 1:iteration
    
    % Termination flag
    previous_result = result;
    
    % Calculate distance between each point and each centroid
    for j = 1:size(distance_matrix,1)
        for k = 1:size(centroid,1)
            distance_matrix(j,k) = sqrt(sum((data(j,:)-centroid(k,:)) .^ 2));
        end
    end
    
    % Assign each point to the nearest cluster controid
    [~,result] = min(distance_matrix,[],2);
    
    % Recalculate centroids after assignment
    for j = 1:k
        centroid(j,:) = mean(data(result(:,1) == j,:));
    end
    % If classified results on all points do not change after an iteration, 
    % the clustering process will quit immediately
    if(result == previous_result)
        fprintf('Clustering over after %i iterations...\n',i);
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
