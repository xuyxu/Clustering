function [centroid, result] = Mean_Shift(data, thr)
% Main part of mean shift clustering algorithm.
%
% Args:
%   data: data to be clustered (n * p)
%   thr: distance threshold used to find neighbors
%
% Returns:
%   centroids: clustering centroids for all classes
%   result: corresponding class for each data point
%
% Comment:
%    Note that there is no need to specify the number of classes in mean
%  shift. In this function , I first record the destination point after
%  shifting for each data point. Data points with same destination point
%  are considered to be in the same class.

destination = zeros(size(data)); % variable used to record destination points
result = zeros(size(data,1),1); % pre-allocate classifying result

% Conduct shift for each data point
for i = 1 : size(data,1)
    x = data(i, :); % current point of interests
    mv_new = x;
    mv_old = x * 10;
    
    while(Eculidean_Distance(mv_new, mv_old) ~= 0)
        mv_old = mv_new;
        neighbors = Find_Neighbor(data, x, thr);
        mv_new = Mean_Vector(neighbors, x, thr, '0/1'); % other weighting mechanisms are under writing
    end
    
    destination(i, :) = mv_new;
    
    % display
    fprintf('Shifting for %ith point finishes\n', i);
end

centroid = unique(destination, 'rows');

% Calssification
for i = 1 : size(centroid,1)
    mask = destination == centroid(i,:); % logical index
    mask = mask(:,1);
    result(mask, 1) = i;
end

% Display
fprintf('Clustering over, a total number of %i classes\n', size(centroid,1));

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

function mv = Mean_Vector(neighbors, x, thr, method)
% Use neighbor set to calculate the mean vector for x.
%
% Args:
%   neighbors: neighbor set of x
%   x: current point of interests
%   thr: distance threshold. In this case, also standrad deviation of Gaussean kernal 
%   method: weighting mechanism ('0/1' or 'Gaussian')
%
% Returns:
%   mv: mean vector of x

flag = 1; % method index

% Check designated weighting machanism
if(strcmp(method, '0/1'))
    flag = 0;
elseif(strcmp(method, 'Gaussian') || strcmp(method, 'gaussian'))
    flag = 1;
else
    fprintf('Unknown method, use default Gaussian weighting mechanism\n')
end

mv = zeros(1, size(x,2)); % pre-allocate result

% Calculate mean vector
if(flag == 0)
    mv = mean(neighbors, 1);
elseif(flag == 1)
    denominator = 0;
    for i = 1 : size(neighbors,1)
        weight = exp(-(Eculidean_Distance(neighbors(i,:), x)^2) / (2*thr^2));
        denominator = denominator + weight;
        mv = mv + weight * neighbors(i, :);
    end
    mv = mv / denominator;
end
end

function neighbors = Find_Neighbor(data, x, thr)
% Find neighbors for x, where neighbors are defined to be points in data
% with eculidean distance from x smaller than thr.
% 
% Args:
%   data: all data points
%   x: current point of interests
%   thr: pre-defined distance threshold
%
% Returns:
%   neighbors: neighbor set of x

neighbors = []; % pre-allocate neighbor result
count = 1;
for i = 1 : size(data,1)
    d = Eculidean_Distance(data(i,:), x);
    if(d <= thr)
        neighbors(count,:) = data(i,:);
        count = count + 1;
    end
end
end


