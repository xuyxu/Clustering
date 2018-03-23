function [centroid, result] = Kmeans(data, k, iteration)

% Choose initial k centroids randomly
centroid = data(randperm(size(data,1),k)', :);

% One variable used to record distances between points and centroids
distance_matrix = zeros(size(data,1), k);

% Pre-allocate result
result = zeros(size(data,1),1);

for i = 1:iteration
    
    % Termination flag
    previous_result = result;
    
    % Calculate distance between each point and each centroid
    for j = 1:size(distance_matrix,1)
        for k = 1:size(distance_matrix,2)
            distance_matrix(j,k) = sqrt(sum((data(j,:)-centroid(k,:)) .^ 2));
        end
    end
    
    % Assign each point to the nearest cluster controid
    [~,result] = min(distance_matrix,[],2);
    
    % Recalculate centroids after assignment
    for j = 1:k
        centroid(j,:) = mean(data(result(:,1) == j,:));
    end
    fprintf('%i iteration completed\n',i);
    % If classified results on all points do not change after an iteration, 
    % the clustering process will quit immediately
    if(result == previous_result)
        fprintf('Clustering over after %i iterations...\n',i);
        break;
    end
end

end
