function [featureVector ] = jointFeatureVector(jointStruct, edges )
%JOINTFEATUREVECTOR Summary of this function goes here
%   Detailed explanation goes here
 
    [chainLengths, chainDistances, chainNumbers, chainTable, vectorLengths] = growMovements(jointStruct.data, jointStruct.jumpVector);
    featureVector = histc(chainTable(:,5), edges)';
    featureVector = featureVector(1:end-1);

end

