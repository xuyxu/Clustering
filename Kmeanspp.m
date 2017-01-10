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
