function [centroid, result] = ISODATA(data, iteration, desired_k, minimum_n, maximum_variance, minimum_d)

% Pre-allocate result
centroid = data(randperm(size(data,1),desired_k)', :);
distance_matrix = zeros(size(data,1), desired_k);
result = zeros(size(data,1),1);

for i = 1 : iteration
    previous_centroid = centroid;
    for j = 1 : size(distance_matrix,1)
        for k = 1 : size(distance_matrix,2)
            distance_matrix(j,k) = sqrt(sum((data(j,:)-centroid(k,:)) .^ 2));
        end
    end
    [~,result] = min(distance_matrix,[],2);
    
    % Whether the number of points in each class is smaller than minimum_n
    for j = 1 : size(centroid, 1)
       if(isempty(find(result == j,1)) || (size(find(result == j),1) < minimum_n))
           
           % One class with number of points in it less than minimum_n
           % should be deleted, along with records in the distance_matrix
           centroid(j,:) = [];
           distance_matrix(:,j) = [];
           
           % Re-assign each point to its closet neighbor class
           [~,result] = min(distance_matrix,[],2);
           
           % Recalculate centroids
           for k = 1:size(centroid,1)
               centroid(k,:) = mean(data(result(:,1) == k,:));
           end
       end 
    end
    
    % Check if combining and splitting are needed
    % Case 1: too few classes
    if(size(centroid,1) <= (desired_k/2)) 
        % Split
        [centroid] = ISODATA_split(data, centroid, result, minimum_n, maximum_variance);
    
    % Case 2: too many classes
    elseif(size(centroid,1) > (2*desired_k)) 
        % Combine
        [centroid] = ISODATA_combine(centroid, result, minimum_d);
        
    end
    
    if(previous_centroid == centroid)
        fprintf('Clustering over after %i iterations...\n', i);
        break;
    end
end
end

% Splitting
function [centroid] = ISODATA_split(data, centroid, current_result, minimum_n, maximum_variance)

[centroid_x, centroid_y] = size(centroid);

variance_matrix = zeros(centroid_x, centroid_y); % pre-allocate the variance matrix

for i = 1 : centroid_x
    for j = 1 : centroid_y
        variance_matrix(i,j) = var(data(current_result == i,j));
    end
end

class_variance = max(variance_matrix,[],2); % find the greatest one-dimension variance per class 

for i = 1 : centroid_x
    if((class_variance(i,1) > maximum_variance) && size(find(current_result == i),1) > (2*minimum_n))
        
        % The current class should be splitted into two different classes
        centroid(i,:) = centroid(i,:) + sqrt(maximum_variance);
        centroid(end+1,:) = centroid(i,:) - sqrt(maximum_variance); % add one new class to centroid set
    end
end
end

% Combining
function [centroid] = ISODATA_combine(centroid, current_result, minimum_d)
centroid_x = size(centroid,1);
class_distance_matrix = zeros(centroid_x, centroid_x);

% Calculate distances between two different classes
for i = 1 : x
    for j = 1 : x
        if(i ~= j)
            class_distance_matrix(i,j) = sqrt(sum((centroid(i,:)-centroid(j,:)) .^ 2));
        end
    end
end

% Combining two classes
for i = 1 : x
    for j = 1 : x
        if((i ~= j) && (class_distance_matrix(i,j) <  minimum_d))
            n1 = size(find(current_result == i),1);
            n2 = size(find(current_result == j),1);
            centroid(i,:) = (1/(n1+n2)) * (n1 * centroid(i,:) + n2 * centroid(j,:));
            centroid(j,:) = [];
            break; % the number of combining operation is limited to 1 within each iteration
        end
    end
end

end

