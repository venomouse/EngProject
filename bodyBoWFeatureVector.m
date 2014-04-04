function [ BoW ] = bodyBoWFeatureVector( allBodySample, bodyGrades )
%BODYBOWFEATUREVECTOR Summary of this function goes here
%   Detailed explanation goes here

%Bag of words structure 
HEAD = 1;
OPPOSITE_SHOULDER = 2;
SAMESIDE_KNEE = 3;
OPPOSITE_KNEE = 4;
SAMESIDE_ANKLE = 5;
OPPOSITE_ANKLE = 6;

featureVectorJoints = zeros(1,classification.BOW_NUM_OF_JOINTS);
featureVectorJoints(HEAD) = 1;
movingLimb = allBodySample(1).movingLimb;
numOfGrades = size(bodyGrades,2);

switch (movingLimb)
    case (bodyPartEnum.RIGHTHAND)
        featureVectorJoints(OPPOSITE_SHOULDER) = joints.SHOULDERLEFT;
        featureVectorJoints(SAMESIDE_KNEE) = joints.KNEERIGHT;
        featureVectorJoints(SAMESIDE_ANKLE) = joints.ANKLERIGHT;
        featureVectorJoints(OPPOSITE_KNEE) = joints.KNEELEFT;
        featureVectorJoints(OPPOSITE_ANKLE) = joints.ANKLELEFT;
    case (bodyPartEnum.LEFTHAND)
        featureVectorJoints(OPPOSITE_SHOULDER) = joints.SHOULDERIGHT;
        featureVectorJoints(SAMESIDE_KNEE) = joints.KNEELEFT;
        featureVectorJoints(SAMESIDE_ANKLE) = joints.ANKLELEFT;
        featureVectorJoints(OPPOSITE_KNEE) = joints.KNEERIGHT;
        featureVectorJoints(OPPOSITE_ANKLE) = joints.ANKLERIGHT;
end

BoW = zeros(1, classification.BOW_NUM_OF_JOINTS*numOfGrades);

index = 1;
for j = featureVectorJoints
    jointFeatureVec = jointFeatureVector(allBodySample(j), bodyGrades(j,:));
    wordIndices = (0:numOfGrades - 1)*classification.BOW_NUM_OF_JOINTS + index;
    BoW(wordIndices) = jointFeatureVec(2:end);
    index = index+1;
end







end

