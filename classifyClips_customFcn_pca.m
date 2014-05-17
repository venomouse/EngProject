function [ labels, clipIndex, all_lowerDim ] = classifyClips_customFcn_pca(svmStruct, eigVectors, meanMatrix, clip_list, sampleLength, overlapLength,vectorFcn)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[matrix, clipMat, clipIndex] = generateVectorMatrixFromClipList(clip_list, vectorFcn, sampleLength,overlapLength);

all_lowerDim = projectToSubspace(matrix, eigVectors, meanMatrix);

labels = svmclassify(svmStruct, all_lowerDim');

end

