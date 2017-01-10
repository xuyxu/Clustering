function [centroid, result] = ISODATA(data, iteration, desired_k, minimum_n, maximum_variance, minimum_d)

% also same to traditional kmeans
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
    
    % decide whether the number of samples in each class is smaller than minimum_n
    for j = 1 : size(centroid, 1)
       if(isempty(find(result == j,1)) || (size(find(result == j),1) < minimum_n))
           
           % one class with number of samples in it less than minimum_n
           % should be deleted, along with records in the distance_matrix
           centroid(j,:) = [];
           distance_matrix(:,j) = [];
           
           % reassign each sample to its closet neighbor class
           [~,result] = min(distance_matrix,[],2);
           
           % recalculate centroid locations
           for k = 1:size(centroid,1)
               centroid(k,:) = mean(data(result(:,1) == k,:));
           end
          
       end 
    end
    
    % decide if combine and split operations are needed
    % 1st: too few classes
    if(size(centroid,1) <= (desired_k/2)) 
        
        [centroid] = ISODATA_split(data, centroid, result, minimum_n, maximum_variance);
    
    % 2nd: too many classes
    elseif(size(centroid,1) > (2*desired_k)) 
        
        [centroid] = ISODATA_combine(centroid, result, minimum_d);
        
    end
    
    if(previous_centroid == centroid)
        fprintf('Clustering over after %i iterations...\n',i);
        break;
    end
end

end

