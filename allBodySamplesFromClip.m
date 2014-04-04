function [samples ] = allBodySamplesFromClip( allBodyData,sampleSize, overlapSize, frameOffset)
%ALLBODYSAMPLESFROMCLIP Summary of this function goes here
%   Detailed explanation goes here

[firstFrame, lastFrame] = clipRange(allBodyData);
sampleStart = firstFrame;
samples = cell(0);

if (lastFrame - firstFrame < sampleSize)
    return;
end

while (sampleStart + sampleSize - overlapSize < lastFrame)
   currSample = allBodySample(allBodyData, sampleStart, sampleStart + sampleSize);
   samples = [samples currSample];
   sampleStart = sampleStart + sampleSize - overlapSize;
end

if (abs(sampleStart - lastFrame) > sampleSize /2)
    currSample = allBodySample(allBodyData, - sampleSize-overlapSize +1 ,lastFrame);
    samples = [samples currSample];
end


end

function clipL = clipLength(allBodyData)
   clipL = size(allBodyData(1).data, 1);
    for i = 2:joints.NUM_OF_JOINTS
        clipL = max(clipL, size(allBodyData(i).data, 1));
    end
end
