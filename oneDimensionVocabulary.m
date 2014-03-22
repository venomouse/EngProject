function [featureList, grades ] = oneDimensionVocabularyFromSamples( samples, jointNum )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

numOfSamples = length(samples);
lengthThreshold = 0.008;
numFramesThreshold = 3;
numOfGrades = 5;

featureList = [];

for i = 1:numOfSamples
    jointData = samples(i)
    [~, ~, ~, chainTable] =testGrowMove(jointData);
    ind = find(chainTable(:,5) > lengthThreshold);
    featureList = [featureList; chainTable(ind, 5)];    
end

[IDX,grades] = kmeans(featureList, numOfGrades);

figure()
[h, cent] = hist (featureList,100);
hold on;
bar (cent,h);
stem (grades, ones(1,length(grades)));

end

