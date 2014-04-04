function [allBodyData]=cleanNoise (clip, movingLimb, clipName)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if (nargin < 3)
    clipName = inputname(1);
end

if (size(clip,2) < 62)
    frameNumsAvailable = 0;
else
    frameNumsAvailable = 1;
end

switch (movingLimb)
    case (bodyPartEnum.RIGHTHAND)
        movingJoints = [joints.ELBOWRIGHT joints.WRISTRIGHT joints.HANDRIGHT];
    case (bodyPartEnum.LEFTHAND)
        movingJoints = [joints.ELBOWLEFT joints.WRISTLEFT joints.HANDLEFT];
    case (bodyPartEnum.RIGHTLEG)
        movingJoints = [joints.KNEERIGHT joints.ANKLERIGHT joints.FOOTRIGHT];
    case (bodyPartEnum.LEFTLEG)
        movingJoints = [joints.KNEELEFT joints.ANKLELEFT joints.FOOTLEFT];
    case (bodyPartEnum.NONE)
        movingJoints = [];
end
try
[relMat, jointReliability] = reliabilityMatrixNew(clip, movingJoints);
catch exception
   clipName
     exception
end


allBodyData = repmat(struct('data', [],'frameNums', [], 'jumpVector', [], 'isReliable', 0, 'name', ' '), 1,  indexConstants.NUMOFJOINTS);

for i = 1:indexConstants.NUMOFJOINTS
   jointData = clip(:,3*i-2:3*i);
   relVector = relMat(:,i);
   if (frameNumsAvailable)
    frameNums = clip (:,62);
   else 
    frameNums = (1:size(clip,1))';
   end
   relJumps = [0; diff(relVector)];
   jumpVector = relVector;
   jumpVector(relJumps == -1) = 1;
   frameNums(relVector ==1) = [];
   jointData(relVector ==1, :) =[];
   jumpVector(relVector ==1) = [];
   
   allBodyData(i).data = jointData;
   allBodyData(i).frameNums = frameNums;
   allBodyData(i).jumpVector = jumpVector;
   allBodyData(i).isReliable = 1- jointReliability(i);
   allBodyData(i).name = clipName;
   allBodyData(i).movingLimb = movingLimb;
end

end

