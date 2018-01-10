function [centroid, result] = Kmeanspp(data, k, iteration)

% choose an initial cluster centroid randomly from data
centroid = data(randperm(size(data,1),1)',:);

% choose other centroids (a total number of k-1) through roulette method
for i = 2:k
    distance_matrix = zeros(size(data,1),i-1);
    for j = 1:size(distance_matrix,1)
        for k = 1:size(distance_matrix,2)
            distance_matrix(j,k) = sum((data(j,:)-centroid(k,:)) .^ 2);
        end
    end
    % choose next centroid according to distances between samples and
    % previous cluster centroids.
    index = Roulettemethod(distance_matrix);
    centroid(i,:) = data(index,:);
    clear distance_matrix;
end

% following steps are same to original k-means
result = zeros(size(data,1),1);
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
        centroid(j,:) = mean(data(result(:,1) == j,:));
    end
    
    % if classified results on all samples do not change after an iteration, 
    % clustering process will quit immediately
    if(result == previous_result)
        fprintf('Clustering over after %i iterations...\n',i);
        break;
    end
end
end

function [index] = Roulettemethod(distance_matrix)

% find shortest distance between one sample and its closest cluster centroid
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
