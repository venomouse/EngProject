function [featureVector ] = jointFeatureVector(jointStruct, binCenters )
%JOINTFEATUREVECTOR Summary of this function goes here
%   Detailed explanation goes here
 
    [chainLengths, chainDistances, chainNumbers, chainTable, vectorLengths] = growMovements(jointStruct.data, jointStruct.jumpVector);
    
    meaningfulFeatures = chainTable(:,5);
    smallFeatureInd = find(chainTable(:,5) < thresholds.MOVEMENT_LENGTH_THRESH ...
              | chainTable(:,4) < thresholds.MOVEMENT_FRAMES_THRESH);
    smallFeatureNum = length(smallFeatureInd);
    meaningfulFeatures(smallFeatureInd) = [];
    featureVector = hist(meaningfulFeatures, binCenters)';
    featureVector = [smallFeatureNum; featureVector];
    
%     if (sum(featureVector) ~=0)
         featureVector = featureVector/sum(featureVector);
%     else
%         featureVector
%     end
    

end

