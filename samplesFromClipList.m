function [ sampleClips ] = samplesFromClipList(clips, neededJoint, sampleLength, overlapSize)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

 sampleClips = cell(0);
for i = 1:length(clips)
    clip= evalin ('base', clips{i});
    
    if(~isempty(strfind(clips{i}, 'left'))) 
        movingLimb = bodyPartEnum.LEFTHAND;
    elseif (~isempty(strfind(clips{i}, 'right')))
        movingLimb = bodyPartEnum.RIGHTHAND;
    end
    
    allBodyData = cleanNoise(clip, movingLimb, clips{i});
    if (neededJoint == -1)
        currSamples = allBodySamplesFromClip(allBodyData,sampleLength, overlapSize );
    else
        currSamples = jointSamplesFromClip(allBodyData, neededJoint, sampleLength);
    end
    sampleClips{i} =  currSamples;
    
end


end

