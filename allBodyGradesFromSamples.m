function [jointGrades] = allBodyGradesFromSamples (allBodySamples, numOfGrades)
%ALLBODYGRADESFROMSAMPLES Summary of this function goes here
%   Detailed explanation goes here

samples = cell(1, joints.NUM_OF_JOINTS);
jointGrades = zeros(joints.NUM_OF_JOINTS, numOfGrades);

for i = 1:joints.NUM_OF_JOINTS
    for j = 1:length(allBodySamples)
        samples{i} = [samples{i} allBodySamples{j}(i)];
    end
   
    [~,grades] = oneDimensionVocabularyFromSamples(samples{i}, numOfGrades);
    jointGrades(i, :) = grades;
end


end

