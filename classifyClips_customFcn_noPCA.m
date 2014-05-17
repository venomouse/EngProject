function [ labels, clipIndex, matrix ] = classifyClips_customFcn_noPCA(svmStruct, clip_list, sampleLength, overlapLength,vectorFcn)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[matrix, clipMat, clipIndex] = generateVectorMatrixFromClipList(clip_list, vectorFcn, sampleLength,overlapLength);

labels = svmclassify(svmStruct, matrix');

end

