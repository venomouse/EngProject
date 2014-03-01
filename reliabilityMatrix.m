function [relMat, jointReliability] = reliabilityMatrix(data, movingJoints )
%RELIABILITYMAT This function calculates the reliability matrix 
% of a given Kinect measurement
% We'll be checking two things:
% 1) Whether there are "jumps" (too fast movements 

distThreshStill = 0.008;
jumpNumThresh = 3;
timePeriod = 20;
reliabilityThresh = 0.3;

numPoints = size(data,1);
relMat = zeros (numPoints, indexConstants.NUMOFJOINTS);
jointReliability = zeros(indexConstants.NUMOFJOINTS,1);

for i = 1:indexConstants.NUMOFJOINTS
   jointData = data(:,3*i-2:3*i);
   distances = sqrt(sum((jointData(1:end-1,:) - jointData(2:end,:)).^2,2));
   if (~ismember (i, movingJoints))
       for t = 1:numPoints
            lowBound = max (t-timePeriod-1, 1);
            highBound = min (numPoints, lowBound+timePeriod);
            numOfJumps = nnz(distances (lowBound:highBound) > distThreshStill);
            relMat(t,i) = numOfJumps > jumpNumThresh;
       end
   else
       
   end
   
   if (nnz(relMat(:,i)) < reliabilityThresh)
        jointReliability(i) = 1;
   end
    
end

end

