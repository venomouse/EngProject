function [ featureList, grades ] = oneDimensionVocabularyFromSamples( samples, numOfGrades )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

numOfSamples = length(samples);

featureList = [];

for i = 1:numOfSamples
    jointData = samples(i).data;
    [~, ~, ~, chainTable] =growMovements(jointData, samples(i).jumpVector);
    ind = find(chainTable(:,5) > thresholds.MOVEMENT_LENGTH_THRESH ...
              & chainTable(:,4) > thresholds.MOVEMENT_FRAMES_THRESH);
    featureList = [featureList; chainTable(ind, 5)];    
end

[IDX,grades] = kmeans(featureList, numOfGrades);

% figure()
% [h, cent] = hist (featureList,100);
% hold on;
% bar (cent,h);
% stem (grades, ones(1,length(grades)));

end

