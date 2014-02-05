function [chainLengths, chainDistances, chainNumbers] = growMovements(data )
%GROWMOVEMENTS This function aims to find sequences of consistent movements
% in a joint recording 

numPoints = size (data,1);
angleThreshold = 90;
historyLength = 6;
minChainLengthBeforeNoise = 4;
noiseThreshold = 4;

motionVectors = data(2:end,:) - data(1:end-1,:);
vectorLengths = sqrt(sum(motionVectors.^2,2));

angle = @(x,y) acosd(x*y'/(norm(x,2)*norm(y,2)));

chainLengths = zeros (1, numPoints-1);
chainLengths(1) = 1; 
chainDistances = zeros (1, numPoints -1);
chainDistances(1) = vectorLengths(1);
chainNumbers = zeros (1,numPoints); 
chainNumbers(1) = 1;
chainNumbers(2) = 1;

currChainStart = 1;
currChainNum = 1;
currChainDistance = vectorLengths(1);
currChainLength = 1;
noiseCounter = 0;

for i = 2:numPoints - 1
    currVec = motionVectors(i,:);
    historyStart = max(currChainStart, i - historyLength);
    for j = historyStart:i-1
        theta = angle (currVec, motionVectors(j,:));
        if (theta < angleThreshold)
            continue;
        else
%             if (currChainLength > minChainLengthBeforeNoise && noiseCounter)
%                 
%             end
            currChainStart = i;
            currChainLength = 0;
            currChainNum = currChainNum+1;
            currChainDistance = 0;
            break;
        end
    end
    currChainLength = currChainLength +1;
    chainLengths(i) = currChainLength;
    currChainDistance = currChainDistance + vectorLengths(i);
    chainDistances(i) = currChainDistance;
    chainNumbers(i+1) = currChainNum;    
end


end

