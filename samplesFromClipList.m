function [ samples ] = samplesFromClipList(clips, neededJoint, sampleLength)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

 samples = [];
for i = 1:length(clips)
    clip= evalin ('base', clips{i});
    
    if(~isempty(strfind(clips{i}, 'left'))) 
        movingLimb = bodyPartEnum.LEFTHAND;
    elseif (~isempty(strfind(clips{i}, 'right')))
        movingLimb = bodyPartEnum.RIGHTHAND;
    end
    
    allBodyData = cleanNoise(clip, clips{i}, movingLimb);
    if (movingLimb == -1)
        currSamples = allBodySamplesFromClip(allBodyData, )
    else
        currSamples = jointSamplesFromClip(allBodyData, neededJoint, sampleLength);
    end
    samples = [samples, currSamples];
    
end


end

