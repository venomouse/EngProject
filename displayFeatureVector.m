function [ featureVec] = displayFeatureVector( raw_clip, joint)
%DISPLAYFEATUREVECTOR Summary of this function goes here
%   Detailed explanation goes here

 allBodyData = cleanNoise(raw_clip, bodyPartEnum.NONE);
 featureVec = jointFeatureVector(allBodyData(joint), classification.EDGES_KNEE);
 
 figure()
 bar(featureVec)
 

end

