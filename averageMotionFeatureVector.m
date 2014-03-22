function [ avScoreFeatureVector] = averageMotionFeatureVector( allBodySample, movingLimb)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%   Format of the feature vector:
   HEAD = 1;
   MOVING_SHOULDER = 2;
   OPPOSITE_SHOULDER = 3;
   OPPOSITE_ELBOW = 4;
   OPPOSITE_WRIST = 5;
   SAMESIDE_HIP = 6;
   OPPOSITE_HIP = 7;
   SAMESIDE_KNEE = 8;
   OPPOSITE_KNEE = 9;
   SAMESIDE_ANKLE = 10;
   OPPOSITE_ANKLE = 11;

   featureVectorJoints = zeros(1, 11);
   featureVectorJoints(HEAD) = 1;
switch (movingLimb)
    case (bodyPartEnum.RIGHTHAND)
        featureVectorJoints(OPPOSITE_SHOULDER) = joints.SHOULDERLEFT;
        featureVectorJoints(OPPOSITE_ELBOW) = joints.ELBOWLEFT;
        featureVectorJoints(OPPOSITE_WRIST) = joints.WRISTLEFT;
        featureVectorJoints(MOVING_SHOULDER) = joints.SHOULDERIGHT;
        featureVectorJoints(SAMESIDE_HIP) = joints.HIPRIGHT;
        featureVectorJoints(SAMESIDE_KNEE) = joints.KNEERIGHT;
        featureVectorJoints(SAMESIDE_ANKLE) = joints.ANKLERIGHT;
        featureVectorJoints(OPPOSITE_HIP) = joints.HIPLEFT;
        featureVectorJoints(OPPOSITE_KNEE) = joints.KNEELEFT;
        featureVectorJoints(OPPOSITE_ANKLE) = joints.ANKLELEFT;
    case (bodyPartEnum.LEFTHAND)
        featureVectorJoints(OPPOSITE_SHOULDER) = joints.SHOULDERIGHT;
        featureVectorJoints(OPPOSITE_ELBOW) = joints.ELBOWRIGHT;
        featureVectorJoints(OPPOSITE_WRIST) = joints.WRISTRIGHT;
        featureVectorJoints(MOVING_SHOULDER) = joints.SHOULDERLEFT;
        featureVectorJoints(SAMESIDE_HIP) = joints.HIPLEFT;
        featureVectorJoints(SAMESIDE_KNEE) = joints.KNEELEFT;
        featureVectorJoints(SAMESIDE_ANKLE) = joints.ANKLELEFT;
        featureVectorJoints(OPPOSITE_HIP) = joints.HIPRIGHT;
        featureVectorJoints(OPPOSITE_KNEE) = joints.KNEERIGHT;
        featureVectorJoints(OPPOSITE_ANKLE) = joints.ANKLERIGHT;
end

avScoreFeatureVector = zeros (1, 11);
score = @(chainTable) mean(chainTable(:,5));

i = 1;
for j = featureVectorJoints
    [~,~,~,chainTable] = growMovements(allBodySample(j).data, allBodySample(j).jumpVector);
    avScoreFeatureVector(i) = score(chainTable);
    i = i+1;
end

end

