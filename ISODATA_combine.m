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
            break; % time of combine operation is limited to 1 through each loop
        end
    end
end

end