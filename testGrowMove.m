function [chainLengths, chainDistances, chainNumbers, chainTable] =  testGrowMove(data, jumpIndex)
%TESTGROWMOVE Summary of this function goes here
%   Detailed explanation goes here


if (nargin < 2)
    jumpIndex = zeros(size(data,1));
end
[chainLengths, chainDistances, chainNumbers, chainTable] = growMovements(data, jumpIndex);
numChains = max(chainNumbers);
thresholdLength = 7;
colors = {'r.','g.','k.','y.','c.','m.'};
colorNum = length(colors);
colorCounter = 1;
 
figure();
subplot(1,2,1)
plot3(data(:,1), data(:,2), data(:,3))
hold on;
for i = 1:numChains
    ind = find (chainNumbers ==i);
    if (length(ind) > thresholdLength)
        motion = data(ind, :);
        plot3(motion(:,1), motion(:,2), motion(:,3), colors{colorCounter});
        colorCounter = mod(colorCounter, colorNum)+1;
    end
end

hold off;

subplot(1,2,2)
plot (chainDistances);
 


end

