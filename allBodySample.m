function [bodySample ] = allBodySample(allBodyData, firstFrame, lastFrame )

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

frameOffset = 0;

for i = 1:joints.NUM_OF_JOINTS
    frames = allBodyData(i).frameNums;
    bodySample(i).data = allBodyData(i).data(frames >= firstFrame + frameOffset & frames < lastFrame + frameOffset,:);
    bodySample(i).jumpVector = allBodyData(i).jumpVector(frames >= firstFrame + frameOffset & frames < lastFrame + frameOffset,:);
    bodySample(i).frameNums = allBodyData(i).frameNums(frames >= firstFrame + frameOffset & frames < lastFrame + frameOffset,:);
    bodySample(i).name = allBodyData(i).name;
    bodySample(i).movingLimb = allBodyData(i).movingLimb;
    
    if (length(bodySample(i).jumpVector/(lastFrame - firstFrame)) < thresholds.FRAME_PERCENTAGE_THRESH)
        bodySample(i).isReliable = 0;
    else
        bodySample(i).isReliable = 1;
    end
end


end

