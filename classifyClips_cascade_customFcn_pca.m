function [ labels, clipIndex, all_lowerDim ] = classifyClips_cascade_customFcn_pca(svmStruct, dyskinetic_svmStruct,  eigVectors, meanMatrix, clip_list, sampleLength, overlapLength,vectorFcn)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[matrix, clipMat, clipIndex] = generateVectorMatrixFromClipList(clip_list, vectorFcn, sampleLength,overlapLength);
all_lowerDim = projectToSubspace(matrix, eigVectors, meanMatrix);
labels = svmclassify(svmStruct, all_lowerDim');

dyskinetic_labels = svmclassify(dyskinetic_svmStruct, all_lowerDim');

labels(labels > 0) = dyskinetic_labels(labels > 0);


end

