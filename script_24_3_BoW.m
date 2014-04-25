clear all
load patient6_data_for_training
load 13_3_data_for_training

%combine the clip list
vars = who;

dyskinetic_clip_list = cell(0);
normal_clip_list = cell(0);

for i = 1:length(vars)
    if(~isempty(strfind(vars{i}, 'beforeMed')) && ~isempty(strfind(vars{i}, 'sit')) ...
            && (~isempty(strfind(vars{i}, 'finger'))|| ~isempty(strfind(vars{i}, 'handopen'))) )
        normal_clip_list = [normal_clip_list vars{i}];
    elseif ((~isempty(strfind(vars{i}, 'nonPeak'))|| ~isempty(strfind(vars{i}, 'afterMed'))) && ~isempty(strfind(vars{i}, 'sit')) ...
            && (~isempty(strfind(vars{i}, 'finger'))|| ~isempty(strfind(vars{i}, 'handopen'))) )
        dyskinetic_clip_list = [dyskinetic_clip_list vars{i}];
    end
end

%
%split every clip to pieces

sampleLength = 100;
overlapLength = 50;
numOfGrades = 3;

dyskinetic_sampleClips = samplesFromClipList(dyskinetic_clip_list, -1, sampleLength, overlapLength);
normal_sampleClips = samplesFromClipList(normal_clip_list, -1, sampleLength, overlapLength);

all_samples = [dyskinetic_samples normal_samples];

%jointGrades = allBodyGradesFromSamples(dyskinetic_samples, numOfGrades);
load jointGrades.mat

featureMatrix = zeros(length(dyskinetic_samples) + length(normal_samples),numOfGrades*classification.BOW_NUM_OF_JOINTS);

labelVector = zeros(length(dyskinetic_samples) + length(normal_samples),1);
meanDysVector = zeros(1,numOfGrades*classification.BOW_NUM_OF_JOINTS);
meanNormVector = zeros(1,numOfGrades*classification.BOW_NUM_OF_JOINTS);

for i = 1:length(dyskinetic_sampleClips)
    sampleClips = dyskinetic_sampleClips{i};
    clipMatrix = [];
    for j = 1:length(sampleClips)
        featureVec = bodyBoWFeatureVector(sampleClips{j}, jointGrades); 
        clipMatrix = [clipMatrix, featureVec'];
        dyskinetic_clipIndex = [dyskinetic_clipIndex; i,j];
    end
    dyskinetic_matrix = [dyskinetic_matrix, clipMatrix];
    dyskinetic_clipMat{i} = clipMatrix;
end

meanDysVector = meanDysVector/length(dyskinetic_samples);

for i =length(dyskinetic_samples)+1:length(dyskinetic_samples) + length(normal_samples)
    featureVec = bodyBoWFeatureVector(normal_samples{i-length(dyskinetic_samples)}, jointGrades);
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
%
%training the classifier 
svmStruct = svmtrain(featureMatrix, labelVector);

%%
%testing
clearvars -except svmStruct labelVector jointGrades featureMatrix 
load 12_3_2014_patient6
load 13_3_data_for_testing

%combine the clip list
vars = who;

dyskinetic_clip_list = cell(0);
normal_clip_list = cell(0);

for i = 1:length(vars)
    if(~isempty(strfind(vars{i}, 'beforeMed')) && ~isempty(strfind(vars{i}, 'sit')) ...
            && (~isempty(strfind(vars{i}, 'finger'))|| ~isempty(strfind(vars{i}, 'handopen')) || ~isempty(strfind(vars{i}, 'supination')) || ~isempty(strfind(vars{i}, 'drink'))) )
        normal_clip_list = [normal_clip_list vars{i}];
    elseif ((~isempty(strfind(vars{i}, 'nonPeak'))|| ~isempty(strfind(vars{i}, 'afterMed'))) && ~isempty(strfind(vars{i}, 'sit')) ...
            && (~isempty(strfind(vars{i}, 'finger'))|| ~isempty(strfind(vars{i}, 'handopen')) || ~isempty(strfind(vars{i}, 'supination')) || ~isempty(strfind(vars{i}, 'drink'))) )
        dyskinetic_clip_list = [dyskinetic_clip_list vars{i}];
    end
end

%%
%split every clip to pieces

sampleLength = 100;
overlapLength = 50;
numOfGrades = 3;

dyskinetic_samples = samplesFromClipList(dyskinetic_clip_list, -1, sampleLength, overlapLength);
normal_samples = samplesFromClipList(normal_clip_list, -1, sampleLength, overlapLength, 400);

all_samples = [dyskinetic_samples normal_samples];

test_featureMatrix = zeros(length(dyskinetic_samples) + length(normal_samples),numOfGrades*classification.BOW_NUM_OF_JOINTS);
true_labels = zeros(length(dyskinetic_samples) + length(normal_samples),1);

for i = 1:length(dyskinetic_samples) 
    featureVec = bodyBoWFeatureVector(dyskinetic_samples{i}, jointGrades);
    test_featureMatrix(i,:) = featureVec; 
    true_labels(i) = 1;
end


for i =length(dyskinetic_samples)+1:length(dyskinetic_samples) + length(normal_samples)
    featureVec = bodyBoWFeatureVector(all_samples{i}, jointGrades);
    test_featureMatrix(i,:) = featureVec;
    true_labels(i) = -1;
end

%%
test_labels = svmclassify(svmStruct, test_featureMatrix);

disp('Error rate:')
nnz(test_labels -true_labels)/length(true_labels)