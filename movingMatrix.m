function [ movingMat ] = movingMatrix( data, clipName, minMotionDistance )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if(~isempty(strfind(clipName, 'left')))
    movingLimb = bodyPartEnum.LEFTHAND;
elseif (~isempty(strfind(clipName, 'right')))
    movingLimb = bodyPartEnum.RIGHTHAND;
end
    
allBodyData = cleanNoise(data, movingLimb, clipName);
movingMat = [];
for i = 1:length(allBodyData)
   [~, chainDistances, chainNumbers, chainTable, ~] = growMovements(allBodyData(i).data, allBodyData(i).jumpVector);
   movingVector = zeros(size(data,1),1);
   for j = 1:length(chainNumbers)
       if ((chainNumbers(j)~=0) && chainTable(chainNumbers(j), 5) > minMotionDistance)
           movingVector(j) = 1;
       else
           movingVector(j) = 0;
       end
       
   end
   movingMat = [movingMat, movingVector];
end

end

