function [ labels, clipIndex, all_lowerDim ] = classifyClips_afv(svmStruct, eigVectors, meanMatrix, clip_list, sampleLength, overlapLength, num_retain)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[matrix, clipMat, clipIndex] = generateAverageFeatureMatrixFromClipList(clip_list, sampleLength,overlapLength);

%all_lowerDim = pcaAnalysis(matrix, num_retain);

all_lowerDim = projectToSubspace(matrix, eigVectors, meanMatrix);

labels = svmclassify(svmStruct, all_lowerDim');




end

