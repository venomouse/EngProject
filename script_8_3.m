clear all
load 01_3_2014_me_smooth
load 05_3_2014_patient6

sampleLength = 150;
numGrades = 5;
joint = joints.KNEELEFT;

vars = who;

dyskinetic_clip_list = cell(0);
normal_clip_list = cell(0);

for i = 1:length(vars)
    if(~isempty(strfind(vars{i}, 'healthy')) && isempty(strfind(vars{i}, 'stand')) )
        normal_clip_list = [normal_clip_list vars{i}];
    elseif (~isempty(strfind(vars{i}, 'nonPeak')) && ~isempty(strfind(vars{i}, 'sit')) && ...
             isempty(strfind(vars{i}, 'leg')) && isempty(strfind(vars{i}, 'heel')))
        dyskinetic_clip_list = [dyskinetic_clip_list vars{i}];
    end
end



dyskinetic_samples = samplesFromClipList(dyskinetic_clip_list, joint, sampleLength);
normal_samples = samplesFromClipList(normal_clip_list, joint, sampleLength);


featureMatrix = zeros(length(dyskinetic_samples) + length(normal_samples),numGrades);
labelVector = zeros(length(dyskinetic_samples) + length(normal_samples),1);
meanDysVector = zeros(1,5);
meanNormVector = zeros(1,5);

for i = 1:length(dyskinetic_samples) 
    featureVec = jointFeatureVector(dyskinetic_samples(i), classification.EDGES_KNEE);
    featureMatrix(i,:) = featureVec;
    labelVector(i) = 1;  
    meanDysVector = meanDysVector + featureVec;
end

meanDysVector = meanDysVector/length(dyskinetic_samples);

for i =length(dyskinetic_samples)+1:length(dyskinetic_samples) + length(normal_samples)
    featureVec = jointFeatureVector(normal_samples(i-length(dyskinetic_samples)), classification.EDGES_KNEE);
    featureMatrix(i,:) = featureVec;
    labelVector(i) = -1;
    meanNormVector = meanNormVector + featureVec;
end

meanNormVector = meanNormVector/length(normal_samples);

figure()
subplot(1,2,1)
bar(meanDysVector)
title('Mean dyskinetic motion feature vector')
subplot(1,2,2)
bar(meanNormVector)
title('Mean normal motion feature vector')
%%
svmStruct = svmtrain(featureMatrix, labelVector);

%%

load 18_2_2014_full_data

afterMed_clip_list = cell(0);
normal2_clip_list = cell(0);

for i = 1:length(vars)
    if(~isempty(strfind(vars{i}, 'healthy')) && isempty(strfind(vars{i}, 'stand')) )
        normal2_clip_list = [normal2_clip_list vars{i}];
    elseif (~isempty(strfind(vars{i}, 'nonPeak')) && ~isempty(strfind(vars{i}, 'sit')) && ...
             isempty(strfind(vars{i}, 'leg')) && isempty(strfind(vars{i}, 'heel')))
        afterMed_clip_list = [afterMed_clip_list vars{i}];
    end
end

dyskinetic_test_samples = samplesFromClipList(afterMed_clip_list, joint, sampleLength);
normal_test_samples = samplesFromClipList(normal2_clip_list, joint, sampleLength);


featureMatrix_test = zeros(length(dyskinetic_test_samples) + length(normal_test_samples),numGrades);
true_labels = zeros(length(dyskinetic_test_samples) + length(normal_test_samples),1);
for i = 1:length(dyskinetic_test_samples) 
    featureVec = jointFeatureVector(dyskinetic_test_samples(i), classification.EDGES_KNEE);
    featureMatrix_test(i,:) = featureVec; 
    true_labels(i) = 1;
end

for i =length(dyskinetic_test_samples)+1:length(dyskinetic_test_samples) + length(normal_test_samples)
    featureVec = jointFeatureVector(normal_test_samples(i-length(dyskinetic_test_samples)), classification.EDGES_KNEE);
    featureMatrix_test(i,:) = featureVec;
    true_labels(i) = -1;
end

test_labels = svmclassify(svmStruct, featureMatrix_test);

nnz( true_labels - test_labels)



