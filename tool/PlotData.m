function PlotData(data, label, varargin)
% PlotData(data, label, varargin)
%   Plot data, with different classes correspond to different colors.
% ----
% Args:
%   data: original data (n * p)
%   label: clustering result (n * 1), '-1' in label corresponds to noisy data
%   varargin{1,1}: clustering centroid (k * p), k the number of classes
%   varargin{1,...}: other parameters
% ----
% Returns: <None>

isc = 0; % whether plot centroid
k = max(label); % the number of classes
p = size(data ,2); % the number of features

if(~isempty(varargin))
    isc = 1;
    centroid = varargin{1, 1};
end

if((p > 3) || (p < 1))
    error('Unable to plot data exceeds 3-deminsion');
end

% Data
if(p == 2)
    for i = 1 : k
        scatter(data(label==i,1), data(label==i,2), 'filled', 'DisplayName', strcat('Class-',num2str(i)));
        hold on;
    end
elseif(p == 3)
    for i = 1 : k
        scatter3(data(label==i,1), data(label==i,2), data(label==i,3), 'filled', 'DisplayName', strcat('Class-',num2str(i)));
        hold on;
    end
end

% Centroid
if(isc == 1)
    if(p == 2)
        scatter(centroid(:,1), centroid(:,2), 150, 'd', 'filled', 'DisplayName', 'Centroid');
    elseif(p == 3)
        scatter3(centroid(:,1), centroid(:,2), centroid(:,3), 150, 'd', 'filled', 'DisplayName', 'Centroid');
    end
end

% Legend
if(k < 10)
    legend('show');
end

% Others
grid on;
end

