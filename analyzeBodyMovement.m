function [ output_args ] = analyzeBodyMovement( data )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

torsoJoints = [joints.SPINE; joints.HIPCENTER; joints.HIPLEFT; joint.HIPRIGHT];
score = @(chainTable) mean(chainTable(:,5));

torsoScores = zeros(1, length(torsoJoints));
jointNum = 1;
for i = torsoJoints
    indices = 3*i-2:3*i;
    [chainLengths, chainDistances, chainNumbers, chainTable, vectorLengths] = growMovements(data, sampleLength);
    torsoScores (jointNum) = score(chainTable);
end

torsoFeature = mean(torsoScores);

leftLegJoints = [joints.KNEELEFT, joints.ANKLELEFT, joints.ANKLERIGHT];
for i = leftLegJoints
end


end

