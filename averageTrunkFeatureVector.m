function [ avScoreFeatureVector] = averageTrunkFeatureVector( allBodySample, sampleSize)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%   Format of the feature vector:
   HEAD = 1;
   MOVING_SHOULDER = 2;
   OPPOSITE_SHOULDER = 3;
   SAMESIDE_HIP = 4;
   OPPOSITE_HIP = 5;
   

   featureVectorJoints = zeros(1, classification.AVERAGE_TRUNK_FEATURE_VECTOR_LENGTH );
   featureVectorJoints(HEAD) = 1;
   movingLimb = allBodySample(1).movingLimb; 
   
   switch (movingLimb)
    case (bodyPartEnum.RIGHTHAND)
        featureVectorJoints(OPPOSITE_SHOULDER) = joints.SHOULDERLEFT;
        featureVectorJoints(MOVING_SHOULDER) = joints.SHOULDERIGHT;
        featureVectorJoints(SAMESIDE_HIP) = joints.HIPRIGHT;
        featureVectorJoints(OPPOSITE_HIP) = joints.HIPLEFT;
    case (bodyPartEnum.LEFTHAND)
        featureVectorJoints(OPPOSITE_SHOULDER) = joints.SHOULDERIGHT;
        featureVectorJoints(MOVING_SHOULDER) = joints.SHOULDERLEFT;
        featureVectorJoints(SAMESIDE_HIP) = joints.HIPLEFT;
        featureVectorJoints(OPPOSITE_HIP) = joints.HIPRIGHT;
    end

avScoreFeatureVector = zeros (1, classification.AVERAGE_TRUNK_FEATURE_VECTOR_LENGTH);
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

