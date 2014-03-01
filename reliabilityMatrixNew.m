function [ relMat, jointReliability ] = reliabilityMatrixNew( data, movingJoints )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

numPoints = size(data,1);
relMat = zeros (numPoints, indexConstants.NUMOFJOINTS);
jointReliability = zeros(indexConstants.NUMOFJOINTS,1);

timePeriod = 5;

distThresh = 0.008;
distThreshMoving = 0.015;
errorScoreThresh = 0.25;
jointReliabilityThresh = 0.5;


for i = 1:indexConstants.NUMOFJOINTS
   jointData = data(:,3*i-2:3*i);
   errorScore = zeros(1, size(jointData,1));
   distances = [0; sqrt(sum((jointData(1:end-1,:) - jointData(2:end,:)).^2,2))];
   if (~ismember (i, movingJoints))
       for t = 1:numPoints
            if (distances(t) > distThresh)
                lowBound = max (t-timePeriod-1, 1);
                highBound = min (numPoints, lowBound+2*timePeriod);
                for k = lowBound:highBound
                    errorScore(k) = errorScore(k) + 1/(3^(abs(k-t)));
                end
            end
       end
       relMat(errorScore > errorScoreThresh ,i) = 1;
       
   else
       
   end
   
    if (nnz(relMat(:,i) > jointReliabilityThresh))
        jointReliability(i) = 1;
    end
end

end

