function [centroid, dimension_weight, class] = Subspace_Kmeans(data, iteration, K, beta, verbose)

% Pre-allocate weights
centroid = zeros(K,size(data,2)); % centroid for each class
class = zeros(size(data,1),1); % classification result for each observation
dimension_weight = ones(K,size(data,2)); % weights for each dimension in each class

% Initialization
n = size(data,1);
J = 0;

% First round
centroid = data(unidrnd(n,K,1),:); % randomly choose K initial centroids 
dimension_weight = 1/size(data,2) * dimension_weight; % initialize weights for each dimension using uniform distribution

% Partially optimization
for i = 1:iteration
    
    J0 = J;
    
    % body part
    class = classify(centroid,dimension_weight,data);
    centroid = centroid_update(centroid,data,class);
    [dimension_weight,J] = dimension_weight_update(K,centroid,class,dimension_weight,data,beta);
    
    if(verbose == 1)
        disp(['J Value: ',num2str(J)]);
    end
    
    % termination condition
    if(abs(J-J0)<1e-9)
        fprintf('*** Clustering terminates after %i iterations ***\n',i);
        break;
    end
end
end

function [alpha,J] = dimension_weight_update(K,m,c,alpha,data,beta)

all_matrix = zeros(size(data,1),size(data,2));
for i = 1:size(data,1)
    all_matrix(i,:) = (m(c(i,1),:)-data(i,:)) .* (m(c(i,1),:)-data(i,:));
end
J = 0;

for i = 1:K
    class_matrix = all_matrix(c==i,:); % pick out data in all_matrix that corresponds to class i
    t_sum = sum(class_matrix,1) + 1e-9; % adding a small positive constant to make weights computatable
    J = J + (alpha(i,:).^beta) * t_sum';
    if(size(class_matrix,1)>0)
        for j = 1:size(alpha,2)  
            % variables used to avoid redundant calculation
            tt_numerator = t_sum(1,j);
        
            t_denominator = sum(tt_numerator./t_sum,2);
            alpha(i,j) = 1/((t_denominator+1e-9)^(1/(beta-1)));
        end
    else
        continue;
    end
end

% Normalize
for i = 1:size(alpha,1)
    alpha(i,:) = alpha(i,:)./(sum(alpha(i,:),2));
end

end

function [result] = classify(m,alpha,data)

result = zeros(size(data,1),1);

% Construct temporary matrix for efficiently computing dimention-weighted distance
matrix = zeros(size(m,1),size(data,2));

for i = 1:size(result,1)
    for j = 1:size(m,1)
        matrix(j,:) = (m(j,:)-data(i,:)) .* (m(j,:)-data(i,:));
    end
    temp = sum(alpha .* matrix,2);
    
    % To avoid more than one class having the minimum distance.
    t_index = find(temp == min(temp));
    result(i,1) = t_index(1,1);
end
end

function [m] = centroid_update(m,data,c)
for i = 1:size(m,1)
    if(~isempty(data(c==i,:)))
        m(i,:) = mean(data(c==i,:),1);
    else
        continue;
    end
end
end




