function [ avScoreFeatureVector, featureVectorJoints] = averageMotionFeatureVectorForStatistics( allBodySample, sampleSize)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%   Format of the feature vector:
   HEAD = 1;
   MOVING_SHOULDER = 2;
   OPPOSITE_SHOULDER = 3;
   OPPOSITE_ELBOW = 4;
   SAMESIDE_HIP = 5;
   OPPOSITE_HIP = 6;
   SAMESIDE_KNEE = 7;
   OPPOSITE_KNEE = 8;
   SAMESIDE_ANKLE = 9;
   OPPOSITE_ANKLE = 10;
   
   OPPOSITE_WRIST = 11;
   OPPOSITE_HAND = 12;
   SAMESIDE_FOOT = 13;
   OPPOSITE_FOOT = 14;
   SHOULDER_CENTER = 15;
   SPINE = 16;
   HIP_CENTER = 17;

   featureVectorJoints = zeros(1, 10);
   featureVectorJoints(HEAD) = joints.HEAD;
   featureVectorJoints(SHOULDER_CENTER) = joints.SHOULDERCENTER;
   featureVectorJoints(SPINE) = joints.SPINE;
   featureVectorJoints(HIP_CENTER) = joints.HIPCENTER;
   
   movingLimb = allBodySample(1).movingLimb; 
   
   switch (movingLimb)
    case (bodyPartEnum.RIGHTHAND)
        featureVectorJoints(OPPOSITE_SHOULDER) = joints.SHOULDERLEFT;
        featureVectorJoints(OPPOSITE_ELBOW) = joints.ELBOWLEFT;
        featureVectorJoints(MOVING_SHOULDER) = joints.SHOULDERIGHT;
        featureVectorJoints(SAMESIDE_HIP) = joints.HIPRIGHT;
        featureVectorJoints(SAMESIDE_KNEE) = joints.KNEERIGHT;
        featureVectorJoints(SAMESIDE_ANKLE) = joints.ANKLERIGHT;
        featureVectorJoints(OPPOSITE_HIP) = joints.HIPLEFT;
        featureVectorJoints(OPPOSITE_KNEE) = joints.KNEELEFT;
        featureVectorJoints(OPPOSITE_ANKLE) = joints.ANKLELEFT;
        featureVectorJoints(OPPOSITE_WRIST) = joints.WRISTLEFT;
        featureVectorJoints(OPPOSITE_HAND) = joints.HANDLEFT;
        featureVectorJoints(OPPOSITE_FOOT) = joints.FOOTLEFT;
        featureVectorJoints(SAMESIDE_FOOT) = joints.FOOTRIGHT;
    case (bodyPartEnum.LEFTHAND)
        featureVectorJoints(OPPOSITE_SHOULDER) = joints.SHOULDERIGHT;
        featureVectorJoints(OPPOSITE_ELBOW) = joints.ELBOWRIGHT;
        featureVectorJoints(MOVING_SHOULDER) = joints.SHOULDERLEFT;
        featureVectorJoints(SAMESIDE_HIP) = joints.HIPLEFT;
        featureVectorJoints(SAMESIDE_KNEE) = joints.KNEELEFT;
        featureVectorJoints(SAMESIDE_ANKLE) = joints.ANKLELEFT;
        featureVectorJoints(OPPOSITE_HIP) = joints.HIPRIGHT;
        featureVectorJoints(OPPOSITE_KNEE) = joints.KNEERIGHT;
        featureVectorJoints(OPPOSITE_ANKLE) = joints.ANKLERIGHT;
        featureVectorJoints(OPPOSITE_WRIST) = joints.WRISTRIGHT;
        featureVectorJoints(OPPOSITE_HAND) = joints.HANDRIGHT;
        featureVectorJoints(OPPOSITE_FOOT) = joints.FOOTRIGHT;
        featureVectorJoints(SAMESIDE_FOOT) = joints.FOOTLEFT;
    end

avScoreFeatureVector = zeros (1, classification.AVERAGE_MOVEMENT_VECTOR_LENGTH);
score = @(chainTable) mean(chainTable(:,5));

i = 1;
for j = featureVectorJoints
    if (size(allBodySample(j).data, 1) < sampleSize/2)
        avScoreFeatureVector(i) = -0.005;
    else
        [~,~,~,chainTable] = growMovements(allBodySample(j).data, allBodySample(j).jumpVector);
        avScoreFeatureVector(i) = score(chainTable);
    end
    i = i+1;
end

end

