clear all;
load patient6_data_for_train_sit
load 13_3_data_for_training

sampleLength = 50;
overlapLength = 25;

%combine the clip list
vars = who;

dyskinetic_clip_list = cell(0);
normal_clip_list = cell(0);

for i = 1:length(vars)
    dyskinetic_state_label = ~isempty(strfind(vars{i}, 'afterMed'))|| ~isempty(strfind(vars{i}, 'afterMed'));
    normal_state_label = ~isempty(strfind(vars{i}, 'beforeMed'));
    posture_label = ~isempty(strfind(vars{i}, 'stand'));
    movement_label = ~isempty(strfind(vars{i}, 'finger'))|| ~isempty(strfind(vars{i}, 'handopen')); 
    
    if(normal_state_label && posture_label && movement_label)
        normal_clip_list = [normal_clip_list vars{i}];
    elseif (dyskinetic_state_label && posture_label && movement_label)
        dyskinetic_clip_list = [dyskinetic_clip_list vars{i}];
    end
end

svmStruct = trainClassifier_averageFeatureVector(dyskinetic_clip_list, normal_clip_list, sampleLength, overlapLength);







clearvars -except svmStruct all_matrix labels all_LowerDim

load patient6_data_for_test_sit
load 13_3_data_for_testing





%%
%classify the clips according to percentage of moving clips

vars = who;

dyskinetic_clip_list = cell(0);
normal_clip_list = cell(0);

for i = 1:length(vars)
    if(~isempty(strfind(vars{i}, 'beforeMed')) && ~isempty(strfind(vars{i}, 'stand')) ...
            && (~isempty(strfind(vars{i}, 'finger'))|| ~isempty(strfind(vars{i}, 'handopen'))) )
        normal_clip_list = [normal_clip_list vars{i}];
    elseif ((~isempty(strfind(vars{i}, 'nonPeak'))|| ~isempty(strfind(vars{i}, 'afterMed'))) && ~isempty(strfind(vars{i}, 'stand')) ...
            && (~isempty(strfind(vars{i}, 'finger'))|| ~isempty(strfind(vars{i}, 'handopen'))) )
        dyskinetic_clip_list = [dyskinetic_clip_list vars{i}];
    end
end

%%
%split every clip to bits and combine two sample lists
%make feature vector from each bit 

sampleLength = 50;
overlapLength = 25;

dyskinetic_sampleClips = samplesFromClipList(dyskinetic_clip_list, -1, sampleLength, overlapLength);
normal_sampleClips = samplesFromClipList(normal_clip_list, -1, sampleLength, overlapLength);

dyskinetic_matrix = [];
normal_matrix = [];
dyskinetic_clipMat = cell(1, length(dyskinetic_sampleClips));
normal_clipMat = cell(1, length(normal_sampleClips));
dyskinetic_clipIndex = zeros(0,2);
normal_clipIndex = zeros (0,2);


for i = 1:length(dyskinetic_sampleClips)
    sampleClips = dyskinetic_sampleClips{i};
    clipMatrix = [];
    for j = 1:length(sampleClips)
        featureVec = averageMotionFeatureVector (sampleClips{j}, sampleLength + overlapLength); 
        clipMatrix = [clipMatrix, featureVec'];
        dyskinetic_clipIndex = [dyskinetic_clipIndex; i,j];
    end
    clipMatrix = correctMissingAverage(clipMatrix);
    dyskinetic_matrix = [dyskinetic_matrix, clipMatrix];
    dyskinetic_clipMat{i} = clipMatrix;
end

for i = 1:length(normal_sampleClips)
    sampleClips = normal_sampleClips{i};
    clipMatrix = [];
    for j = 1:length(sampleClips)
        featureVec = averageMotionFeatureVector (sampleClips{j}, sampleLength + overlapLength); 
        clipMatrix = [clipMatrix, featureVec'];
        normal_clipIndex = [normal_clipIndex; i,j];
    end
    clipMatrix = correctMissingAverage(clipMatrix);
    normal_matrix = [normal_matrix, clipMatrix];
    normal_clipMat{i} = clipMatrix;
end
%%
%perform principal component analysis on all the vectors 
all_matrix_test = [dyskinetic_matrix, normal_matrix];

[covMat, eigVecCov, eigValCov] = covMatrix (all_matrix_test);
eigVals = diag (eigValCov);
[sortedEig, index] = sort (eigVals);
flipedEig = flipud (sortedEig);
flipedIndex = flipud (index);

num_retain = 3;

vecRetained = eigVecCov (:, index (end - num_retain+1:end));

all_LowerDim_test = vecRetained' * (all_matrix_test - repmat (mean (all_matrix_test,2), 1, size (all_matrix_test ,2)));

test_labels = svmclassify(svmStruct, all_LowerDim_test');
dyskinetic_labels = test_labels(1:size(dyskinetic_matrix,2));
normal_labels = test_labels(size(dyskinetic_matrix,2)+1:end);

true_labels = zeros(size(all_LowerDim_test,2),1);
true_labels(1:size(dyskinetic_matrix,2)) = 1;
true_labels(size(dyskinetic_matrix,2)+1:end) = -1;

% figure()
% stem(abs(true_labels - test_labels));
% nnz(true_labels-test_labels)/length(test_labels)

%%
%give a score to a clip 
samePatient_dyskinetic_clipScores = scoreClipsByBits(dyskinetic_clipIndex, dyskinetic_labels);
samePatient_normal_clipScores = scoreClipsByBits(normal_clipIndex, normal_labels);







%%
clearvars -except svmStruct sampleLength overlapLength samePatient_dyskinetic_clipScores samePatient_normal_clipScores

load patient2_dyskinetic_clips_stand
load patient4_normal_clips_stand

vars = who;

dyskinetic_clip_list = cell(0);
normal_clip_list = cell(0);

for i = 1:length(vars)
    dyskinetic_state_label = ~isempty(strfind(vars{i}, 'afterMed'))&& ~isempty(strfind(vars{i}, 'patient2'));
    normal_state_label = ~isempty(strfind(vars{i}, 'patient4'));
    posture_label = ~isempty(strfind(vars{i}, 'stand'));
    movement_label = ~isempty(strfind(vars{i}, 'finger'))|| ~isempty(strfind(vars{i}, 'handopen')); 
    
    if(normal_state_label && posture_label && movement_label)
        normal_clip_list = [normal_clip_list vars{i}];
    elseif (dyskinetic_state_label && posture_label && movement_label)
        dyskinetic_clip_list = [dyskinetic_clip_list vars{i}];
    end
end
%%


[test_labels, true_labels, dyskinetic_clipIndex, normal_clipIndex] = testClassifier_averageFeatureVector(svmStruct, dyskinetic_clip_list, normal_clip_list, sampleLength, overlapLength );

dyskinetic_labels = test_labels(1:size(dyskinetic_clipIndex,1));
normal_labels = test_labels(size(dyskinetic_clipIndex, 1)+1:end);

dyskinetic_clipScores = scoreClipsByBits(dyskinetic_clipIndex, dyskinetic_labels);
normal_clipScores = scoreClipsByBits(normal_clipIndex, normal_labels);

%%
figure()
ticks  = {'Patient6 - dyskinetic state', 'Patient2 - dyskinetic state(average)', 'Patient4 - non-dyskinetic', 'Patient6 - Off-state'};
bar([mean(samePatient_dyskinetic_clipScores) mean(dyskinetic_clipScores) mean(normal_clipScores) mean(samePatient_normal_clipScores)])
set(gca, 'Xtick', [1:4])
set (gca,'Xticklabel', ticks)
title('Dyskinesia degree classification by analyzing small hand movements in standing position')



