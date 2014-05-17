function [ avScoreFeatureVector] = averageLowerHalfFeatureVector_withFoot( allBodySample, sampleSize)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%   Format of the feature vector:
   SAMESIDE_KNEE = 1;
   OPPOSITE_KNEE = 2;
   SAMESIDE_ANKLE = 3;
   OPPOSITE_ANKLE = 4;
   SAMESIDE_FOOT = 5;
   OPPOSITE_FOOT = 6;

   featureVectorJoints = zeros(1, classification.AVERAGE_LOWER_FEATURE_VECTOR_LENGTH_WITH_FOOT);
   movingLimb = allBodySample(1).movingLimb; 
   
   switch (movingLimb)
    case (bodyPartEnum.RIGHTHAND)
        featureVectorJoints(SAMESIDE_KNEE) = joints.KNEERIGHT;
        featureVectorJoints(SAMESIDE_ANKLE) = joints.ANKLERIGHT;
        featureVectorJoints(SAMESIDE_FOOT) = joints.FOOTRIGHT;
        featureVectorJoints(OPPOSITE_KNEE) = joints.KNEELEFT;
        featureVectorJoints(OPPOSITE_ANKLE) = joints.ANKLELEFT;
        featureVectorJoints(OPPOSITE_FOOT) = joints.FOOTLEFT;
        
    case (bodyPartEnum.LEFTHAND)
        featureVectorJoints(SAMESIDE_KNEE) = joints.KNEELEFT;
        featureVectorJoints(SAMESIDE_ANKLE) = joints.ANKLELEFT;
         featureVectorJoints(SAMESIDE_FOOT) = joints.FOOTLEFT;
        featureVectorJoints(OPPOSITE_KNEE) = joints.KNEERIGHT;
        featureVectorJoints(OPPOSITE_ANKLE) = joints.ANKLERIGHT;
         featureVectorJoints(OPPOSITE_FOOT) = joints.FOOTRIGHT;
    end

avScoreFeatureVector = zeros (1, classification.AVERAGE_LOWER_FEATURE_VECTOR_LENGTH_WITH_FOOT);
score = @(chainTable) mean(chainTable(:,5));

i = 1;
for j = featureVectorJoints
    if (size(allBodySample(j).data, 1) < sampleSize/2)
        avScoreFeatureVector(i) = 0;
    else
        [~,~,~,chainTable] = growMovements(allBodySample(j).data, allBodySample(j).jumpVector);
        avScoreFeatureVector(i) = score(chainTable);
    end
    i = i+1;
end

end
