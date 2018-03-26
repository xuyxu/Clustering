function label = DBSCAN(data, eps, minPts)
% label = DBSCAN(data, epsilon, minPts)
%   Main part of DBSCAN (Density-Based Spatial Clustering of Application with 
% Noise)clustering algorithm.
% ----
% Args:
%   data: data to be clustered (n * p)
%   eps: distance threshold for finding neighbors
%   minPts: minimum required number of neighbor observations for one core object
% ----
% Returns:
%   label: corresponding class for each observation

% Initialization
core_object = [];
count = 1;
k = 1; % label index
vmask = ones(size(data, 1), 1); % variable used to record whether one observation has been visited (1: not visited, 0: visited)
label = zeros(size(data, 1), 1); % pre-allocate result

% Find core objects
for i = 1:size(data, 1)
    x = data(i, :); % current observation of interests
    [~, neighbors] = Find_Neighbor(data, x, eps);
    
    % Check if the number of observations in neighbors of x is larger than minPts 
    if((size(neighbors,1)-1) >= minPts)
        
        % Add the index of x to the set of core object
        core_object(count, 1) = i;
        count = count + 1;
    end
end

fprintf('---- DBSCAN finds a total number of %i core objects ----\n', size(core_object, 1));

while(~isempty(core_object))
    
    % Construct one queue for further use 
    queue = [];
    qcount = 1;
    
    % Update core_object, observations have been visited should be deleted
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
    
    % Randomly choose one core object
    index = core_object(randi(size(core_object, 1)), 1);
    queue(qcount, 1) = index; % add the selected core object to the queue
    qcount = qcount + 1;
    vmask(index, 1) = 0; % update vmask
    label(index, 1) = k; % assign result 
    core_object(core_object == index, :) = []; % remove the selected core object from the set
    
    while(~isempty(queue))
        pivot = queue(1, 1); 
        queue(1, :) = []; % remove the first element in queue
        qcount = qcount - 1;
        
        % Find neighbors for current observation of interests 
        [tindex, tneighbors] = Find_Neighbor(data, data(pivot, :), eps);
        if(size(tneighbors, 1) >= minPts)
            for i = 1 : size(tindex, 1)
                % If one neighbor has not been visited, add it to the queue
                if(vmask(tindex(i, 1),1) == 1)
                    queue(qcount, 1) = tindex(i, 1);
                    qcount = qcount + 1;
                    vmask(tindex(i, 1),1) = 0; % update vmask
                    label(tindex(i, 1),1) = k; % assign result
                end
            end
        end   
    end
    
    fprintf('---- Finish finding observations for class %i ----\n', k);
    k = k + 1; % next class
end
end

function d = Eculidean_Distance(x1, x2)
% Calculate eculidean distance between x1 and x2.
%
% Args:
%   x1: observation 1
%   x2: observation 2
%
% Returns:
%   d: Eculidean distance between x1 and x2

d = sqrt((x1 - x2) * (x1 - x2)');
end

function [index, neighbors] = Find_Neighbor(data, x, eps)
% Find neighbors for x, where neighbors are defined to be observations in data
% with eculidean distance from x smaller than epsilon.
%
% Args:
%   data: dataset
%   x: current observation of interests
%   eps: pre-defined distance threshold
%
% Returns:
%   index: the index of these neighbors in data
%   neighbors: neighbor set of x

neighbors = []; % pre-allocate neighbor result
count = 1;
for i = 1 : size(data,1)
    d = Eculidean_Distance(data(i,:), x);
    if(d <= eps)
        index(count, 1) = i;
        neighbors(count,:) = data(i,:);
        count = count + 1;
    end
end
end


