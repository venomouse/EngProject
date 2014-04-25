function [ data_matrix, clip_matrix, clipIndex] = generateAverageFeatureMatrixFromClipList(clipList, sampleLength, overlapLength)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

sampleClipsList = samplesFromClipList(clipList, -1, sampleLength, overlapLength);

data_matrix = [];
clip_matrix = cell(1, length(sampleClipsList));
clipIndex = zeros(0,2);


for i = 1:length(sampleClipsList)
    sampleClips = sampleClipsList{i};
    clipMatrix = [];
    for j = 1:length(sampleClips)
        featureVec = averageMotionFeatureVector (sampleClips{j}, sampleLength + overlapLength); 
        clipMatrix = [clipMatrix, featureVec'];
        clipIndex = [clipIndex; i,j];
    end
    clipMatrix = correctMissingAverage(clipMatrix);
    data_matrix = [data_matrix, clipMatrix];
    clip_matrix{i} = clipMatrix;
end

end

