function [index] = Roulettemethod(distance_matrix)

% find shortest distance between one sample and its closest cluster centroid
[min_distance,~] = min(distance_matrix,[],2);

% make sure the sum of min_distance is 1
min_distance = min_distance ./ sum(min_distance);

% construct roulette according to min_distance
temp_roulette = zeros(size(distance_matrix,1),1);
for i = 1:size(distance_matrix,1)
    temp_roulette(i,1) = sum(min_distance(1:i,:));
end

% generate a random number for final selection
temp_rand = rand();

% find its corresponding index
for i = 1:size(temp_roulette,1)
    if((i == 1) && temp_roulette(i,1) > temp_rand)
        index = 1;
    elseif((temp_roulette(i,1) > temp_rand) && (temp_roulette(i-1,1) < temp_rand))
        index = i;
    end
end

end