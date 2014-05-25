function [ BoW ] = bodyBoWFeatureVectorShort( allBodySample, sampleSize )
%BODYBOWFEATUREVECTOR Summary of this function goes here
%   Detailed explanation goes here

load jointGrades.mat
bodyGrades = jointGrades;
%Bag of words structure 
HEAD = 1;
SAMESIDE_SHOULDER = 2;
OPPOSITE_SHOULDER = 3;
SAMESIDE_KNEE = 4;
OPPOSITE_KNEE = 5;
SAMESIDE_ANKLE = 6;
OPPOSITE_ANKLE = 7;

featureVectorJoints = zeros(1,classification.BOW_NUM_OF_JOINTS);
featureVectorJoints(HEAD) = 1;
movingLimb = allBodySample(1).movingLimb;
numOfGrades = size(bodyGrades,2);

switch (movingLimb)
    case (bodyPartEnum.RIGHTHAND)
        featureVectorJoints(SAMESIDE_SHOULDER) = joints.SHOULDERIGHT;
        featureVectorJoints(OPPOSITE_SHOULDER) = joints.SHOULDERLEFT;
        featureVectorJoints(SAMESIDE_KNEE) = joints.KNEERIGHT;
        featureVectorJoints(SAMESIDE_ANKLE) = joints.ANKLERIGHT;
        featureVectorJoints(OPPOSITE_KNEE) = joints.KNEELEFT;
        featureVectorJoints(OPPOSITE_ANKLE) = joints.ANKLELEFT;
    case (bodyPartEnum.LEFTHAND)
        featureVectorJoints(SAMESIDE_SHOULDER) = joints.SHOULDERLEFT;
        featureVectorJoints(OPPOSITE_SHOULDER) = joints.SHOULDERIGHT;
        featureVectorJoints(SAMESIDE_KNEE) = joints.KNEELEFT;
        featureVectorJoints(SAMESIDE_ANKLE) = joints.ANKLELEFT;
        featureVectorJoints(OPPOSITE_KNEE) = joints.KNEERIGHT;
        featureVectorJoints(OPPOSITE_ANKLE) = joints.ANKLERIGHT;
end

BoW = zeros(1, classification.BOW_NUM_OF_JOINTS*(numOfGrades-1));

index = 1;
for j = featureVectorJoints
    jointFeatureVec = jointFeatureVector(allBodySample(j), bodyGrades(j,:));
    wordIndices = (0:numOfGrades - 2)*classification.BOW_NUM_OF_JOINTS + index;
    BoW(wordIndices) = jointFeatureVec(3:end);
    index = index+1;
end


end