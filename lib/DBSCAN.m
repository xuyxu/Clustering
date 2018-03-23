function result = DBSCAN(data, epsilon, minPts)
% Main part of DBSCAN (Density-Based Spatial Clustering of Application with 
% Noise)clustering algorithm.
% 
% Args:
%   data: data to be clustered (n * p)
%   epsilon: distance threshold for finding neighbors
%   minPts: minimum required number of neighbor points for one core object
%
% Returns:
%   centroid: clustering centroids for all classes
%   result: corresponding class for each data points

% Initialization
core_object = [];
count = 1;
k = 1;
vmask = ones(size(data, 1), 1); % variable used to record whether one point has been visited (1: not visited, 0: visited)
result = zeros(size(data, 1), 1); % pre-allocate result

% Find all core objects
for i = 1:size(data, 1)
    x = data(i, :); % current point of interests
    [~, neighbors] = Find_Neighbor(data, x, epsilon);
    
    % Check if the number of points in neighbors of x is larger than minPts 
    if((size(neighbors,1)-1) >= minPts)
        
        % Add the index of x to the set of core object
        core_object(count, 1) = i;
        count = count + 1;
    end
end

while(~isempty(core_object))
    
    % Construct one queue for further use 
    queue = [];
    qcount = 1;
    
    % Update core_object, points have been visited should be deleted
    tcount = 1;
    list = [];
    for i = 1:size(core_object, 1)
        if(vmask(core_object(i, 1),1) == 0)
            list(tcount ,1) = i;
            tcount = tcount + 1;
        end
    end
    core_object(list,:) = [];
    
    if(isempty(core_object))
        break;
    end
    
    % Randomly select one core object
    index = core_object(randi(size(core_object, 1)), 1);
    queue(qcount, 1) = index; % add the selected core object into the queue
    qcount = qcount + 1;
    vmask(index, 1) = 0; % update vmask
    result(index, 1) = k; % assign result 
    core_object(core_object == index, :) = []; % remove the selected core object from the set
    
    while(~isempty(queue))
        pivot = queue(1, 1); 
        queue(1, :) = []; % remove the first element in queue
        qcount = qcount - 1;
        
        % Find neighbors for current point of interests 
        [tindex, tneighbors] = Find_Neighbor(data, data(pivot, :), epsilon);
        if(size(tneighbors, 1) >= minPts)
            for i = 1 : size(tindex, 1)
                % If one neighbor has not been visited, add it to the queue
                if(vmask(tindex(i, 1),1) == 1)
                    queue(qcount, 1) = tindex(i, 1);
                    qcount = qcount + 1;
                    vmask(tindex(i, 1),1) = 0; % update vmask
                    result(tindex(i, 1),1) = k; % assign result
                end
            end
        end   
    end
    
    k = k + 1; % next class
end
end

function d = Eculidean_Distance(x1, x2)
% Calculate eculidean distance between x1 and x2.
%
% Args:
%   x1: point1
%   x2: point2
%
% Returns:
%   d: Eculidean distance between x1 and x2

d = sqrt((x1 - x2) * (x1 - x2)');
end

function [index, neighbors] = Find_Neighbor(data, x, epsilon)
% Find neighbors for x, where neighbors are defined to be points in data
% with eculidean distance from x smaller than epsilon.
%
% Args:
%   data: all data points
%   x: current point of interests
%   epsilon: pre-defined distance threshold
%
% Returns:
%   index: the index of these neighbors in data
%   neighbors: neighbor set of x

neighbors = []; % pre-allocate neighbor result
count = 1;
for i = 1 : size(data,1)
    d = Eculidean_Distance(data(i,:), x);
    if(d <= epsilon)
        index(count, 1) = i;
        neighbors(count,:) = data(i,:);
        count = count + 1;
    end
end
end


