function [ test_labels, true_labels, dyskinetic_clipIndex, normal_clipIndex] = testClassifier_averageFeatureVector( svmStruct, dyskinetic_clip_list, normal_clip_list, sampleLength, overlapLength )
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

[dyskinetic_matrix, dyskinetic_clipMat, dyskinetic_clipIndex] = generateAverageFeatureMatrixFromClipList(dyskinetic_clip_list, sampleLength,overlapLength);
[normal_matrix, normal_clipMat, normal_clipIndex] = generateAverageFeatureMatrixFromClipList(normal_clip_list,sampleLength,overlapLength);

num_retain = 3;
all_lowerDim = pcaAnalysis([dyskinetic_matrix, normal_matrix], num_retain);


true_labels = zeros(size(all_lowerDim,2),1);
true_labels(1:size(dyskinetic_matrix,2)) = 1;
true_labels(size(dyskinetic_matrix,2)+1:end) = -1;

test_labels = svmclassify(svmStruct, all_lowerDim');


end

