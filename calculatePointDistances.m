function [distances] = calculatePointDistances( data )
%CALCULATEPOINTDISTANCES Summary of this function goes here
%   Detailed explanation goes here
numPoints = size (data,1);
distances = zeros(numPoints);

distToI = @(x) sqrt(sum((data - repmat (x,numPoints,1)).^2,2));

for i = 1:numPoints
    distances(i,:) = distToI (data(i,:));
end


end

