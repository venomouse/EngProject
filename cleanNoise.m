function [allBodyData]=cleanNoise (clip, movingLimb)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

switch (movingLimb)
    case (bodyPartEnum.RIGHTHAND)
        movingJoints = [joints.ELBOWRIGHT joints.WRISTRIGHT joints.HANDRIGHT];
    case (bodyPartEnum.LEFTHAND)
        movingJoints = [joints.ELBOWLEFT joints.WRISTLEFT joints.HANDLEFT];
    case (bodyPartEnum.RIGHTLEG)
        movingJoints = [joints.KNEERIGHT joints.ANKLERIGHT joints.FOOTRIGHT];
    case (bodyPartEnum.LEFTLEG)
        movingJoints = [joints.KNEELEFT joints.ANKLELEFT joints.FOOTLEFT];
end

[relMat, jointReliability] = reliabilityMatrixNew(clip, movingJoints);

allBodyData = repmat(struct('data', [],'frameNums', [], 'jumpVector', [], 'isReliable', 0), 1,  indexConstants.NUMOFJOINTS);

for i = 1:indexConstants.NUMOFJOINTS
   jointData = clip(:,3*i-2:3*i);
   relVector = relMat(:,i);
   frameNums = (1:size(jointData,1))';
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
end

end

