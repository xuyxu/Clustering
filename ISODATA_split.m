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
        
        % current class should be splitted into two different classes
        centroid(i,:) = centroid(i,:) + sqrt(maximum_variance);
        centroid(end+1,:) = centroid(i,:) - sqrt(maximum_variance); % add a new class at the end of centroid
    end
end

end