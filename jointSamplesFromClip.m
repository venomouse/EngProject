function [jointSamples ] = jointSamplesFromClip (bodyData, requiredJoint, sampleSize, overlapSize) 
%UNTITLED6 This function cuts the clip into samples of even length

missedFramesThreshold = sampleSize;

jointSamples = [];
jointStruct = bodyData(requiredJoint);
jointData = bodyData(requiredJoint).data;

currStart = 1;
numSamples = 1;
while (size(jointData,1) - currStart > sampleSize)
    jointSamples(numSamples).data = jointData(currStart: currStart + sampleSize-1, :);
    jointSamples(numSamples).frameNums = jointStruct.frameNums(currStart: currStart + sampleSize-1);
    jointSamples(numSamples).jumpVector = jointStruct.jumpVector(currStart: currStart + sampleSize-1);
    if (jointStruct.frameNums(currStart + sampleSize-1) - jointStruct.frameNums(currStart) > sampleSize+ missedFramesThreshold)
        jointSamples(numSamples).isReliable = 0;
    else
         jointSamples(numSamples).isReliable = 1;
    end
    jointSamples(numSamples).name = jointStruct.name;
    currStart = currStart + sampleSize;
    numSamples = numSamples+1;
end

if (size(jointData,1) - currStart > sampleSize/2)
    jointSamples(numSamples).data = jointData (end-sampleSize +1: end, :);
    jointSamples(numSamples).frameNums = jointStruct.frameNums (end-sampleSize +1: end);
    jointSamples(numSamples).jumpVector = jointStruct.jumpVector(end-sampleSize +1: end);
    if (jointStruct.frameNums(end) - jointStruct.frameNums(end-sampleSize +1) > sampleSize+ missedFramesThreshold)
        jointSamples(numSamples).isReliable = 0;
    else
         jointSamples(numSamples).isReliable = 1;
    end
    
end
end

