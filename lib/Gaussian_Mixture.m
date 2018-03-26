function [label, alpha, miu, sigma] = Gaussian_Mixture(data, k, iter)
% function [label, alpha, miu, sigma] = Gaussian_Mixture(data, k)
%   Use gaussian mixture model (GMM) to conduct data clustering. GMM uses
% probability model to characterize prototypes for each class.
% ----
% Args:
%   data: data to be clustered (n * p)
%   k: the number of guassian components (scalar)
%   iter: maximum number of iterations (scalar)
% ----
% Returns:
%   label: corresponding class for each observation (n * 1)
%   alpha: mixing coefficient for each gaussian component (k * 1) && (sum(alpha) == 1)
%   miu: mean value for each gaussian component (k * p)
%   sigma: coefficient matrix for each gaussian component (cell: k * n * n)

% Initialization
alpha = ones(k, 1) / k;
miu = randn(k, size(data, 2));
for i = 1 : k
    sigma{i, 1} = rand * eye(size(data, 2));
end
label = zeros(size(data, 1), 1);

p = Posteriori(data, k, alpha, miu, sigma); % calculate posteriori probability
[~, label] = max(p,[], 2); % classification

for i = 1 : iter
    % M-Step
    for j = 1 : k
        sump = sum(p(:, j));
        % Update parameters
        miu(j, :) = (p(:, j)' * data) / sump; % mean value
        
        tsigma = zeros(size(data, 2));
        for num = 1 : size(data, 1)
            tsigma  = tsigma + p(i, j) * (data(i, :) - miu(j, :))' * (data(i, :) - miu(j, :));
        end
        sigma{j, 1} = tsigma / sump;
        
        alpha(j, 1) = sump / size(data, 1); % mixing coefficient
    end
    % E-Step
    p = Posteriori(data, k, alpha, miu, sigma);
    
    fprintf('%i\n',i);
end
[~, label] = max(p,[], 2); % classification
end

function p = Posteriori(data, k, alpha, miu, sigma)
% function p = Posteriori(data, alpha, miu, sigma)
%   Calculate posteriori probability for each observation and each class. The
% output p is of the size n * p, the entry (i,j) represents the probability
% that observation i belongs to class j.
% ----
% Args:
%   data, k, alpha, miu, sigma: same to the function Gaussian_Mixture
% ----
% Returns:
%   p: posteriori probability for each observation and each class (n * k)

% Pre-allocate result
p = zeros(size(data, 1), k);

for i = 1 : size(data, 1)
    sump = 0; % normalizing factor 
    for j = 1 : k
        tx = data(i, :) - miu(k, :);
        sigma{j,1} = sigma{j,1} + 1e-5*eye(size(data,2));
        inv_sigma = inv(sigma{j, 1});
        upper = tx * inv_sigma * tx';
        p(i, j) = exp(-0.5 * upper) / sqrt((2*pi)^(size(data,2))*abs(det(sigma{j,1})+1e-5));
        sump = sump + p(i, j);
    end
    if(sump ~= 0)
        p(i, :) = p(i, :) / sump;
    end
end

end

