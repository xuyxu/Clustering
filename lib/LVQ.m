function [centroid, label] = LVQ(data, q, neta, x, y, iter)
% function [centroid, label] = LVQ(data, q, x, y)
%   Unlike Kmeans, LVQ (Learning Vector Quantization) use labelled data 
% <x,y> to help clustering.After using LVQ, the feature space is split into
% a voronoi mesh.
% ----
% Args:
%   data: data to be clustered (n * p)
%   q: the number of prototypes (scalar)
%   neta: learning rate
%   x: training data (? * p, '?' is the size of training data)
%   y: label of training data (? * 1)
%   iter: maximum number of iterations (scalar)
% ----
%   centroid: clustering centroids (q * p)
%   label: corresponding class for each observation (n * 1)

% Initialization
centroid = x(randperm(size(x,1),q)', :); % randomly select q observations as initial prototypes
label = zeros(size(data, 1), 1);

for i = 1 : iter
    
    s = randperm(size(x,1),1); % ramdomly select one training sample
    tx = x(s, :); 
    
    % Calculate the distance between tx and all prototypes
    distance = zeros(q, 1);
    for j = 1 : q
        distance(j, 1) = Eculidean_Distance(tx, centroid(j, :));
    end
    [~, index] = min(distance); % find the index of the nearest prototype
    
    % Update the prototype
    if(index == y(s, 1))
        centroid(index, :) = centroid(index, :) + neta * (tx - centroid(index, :));
    else
        centroid(index, :) = centroid(index, :) - neta * (tx - centroid(index, :));
    end
end

% Classification
for i = 1 : size(data, 1)
    tx = data(i, :);
    distance = zeros(q, 1);
    for j = 1 : q
        distance(j, 1) = Eculidean_Distance(tx, centroid(j, :));
    end
    [~, index] = min(distance); % find the index of the nearest prototype
    label(i, 1) = index;
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

