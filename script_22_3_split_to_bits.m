clear all
load patient6_data_for_train_sit
load 13_3_data_for_training

%combine the clip list
vars = who;

dyskinetic_clip_list = cell(0);
normal_clip_list = cell(0);

for i = 1:length(vars)
    if(~isempty(strfind(vars{i}, 'beforeMed')) && ~isempty(strfind(vars{i}, 'stand')) ...
            && (~isempty(strfind(vars{i}, 'finger'))|| ~isempty(strfind(vars{i}, 'handopen'))) )
        normal_clip_list = [normal_clip_list vars{i}];
    elseif ((~isempty(strfind(vars{i}, 'afterMed'))|| ~isempty(strfind(vars{i}, 'afterMed'))) && ~isempty(strfind(vars{i}, 'sit')) ...
            && (~isempty(strfind(vars{i}, 'supination'))|| ~isempty(strfind(vars{i}, 'drink'))) )
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
all_matrix = [dyskinetic_matrix, normal_matrix];

[covMat, eigVecCov, eigValCov] = covMatrix (all_matrix);
eigVals = diag (eigValCov);
[sortedEig, index] = sort (eigVals);
flipedEig = flipud (sortedEig);
flipedIndex = flipud (index);

num_retain = 3;

vecRetained = eigVecCov (:, index (end - num_retain+1:end));

all_LowerDim = vecRetained' * (all_matrix - repmat (mean (all_matrix,2), 1, size (all_matrix ,2)));

dyskinetic_lowerDim = all_LowerDim(:, 1:size(dyskinetic_matrix,2));
normal_lowerDim = all_LowerDim(:, size(dyskinetic_matrix,2)+1:end);

figure()
hold on
scatter3(dyskinetic_lowerDim(1,:), dyskinetic_lowerDim(2,:), dyskinetic_lowerDim(3,:));
scatter3(normal_lowerDim(1,:), normal_lowerDim(2,:), normal_lowerDim(3,:));

[IDX] = kmeans(all_matrix',3);

%%
%try to classify the vectors 

labels = zeros(size(all_LowerDim,2),1);
labels(1:size(dyskinetic_matrix,2)) = 1;
labels(size(dyskinetic_matrix,2)+1:end) = -1;

svmStruct = svmtrain(all_LowerDim', labels, 'kernel_function', 'rbf');

%%
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
    elseif ((~isempty(strfind(vars{i}, 'nonPeak'))|| ~isempty(strfind(vars{i}, 'afterMed'))) && ~isempty(strfind(vars{i}, 'sit')) ...
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
dyskinetic_clipScores = scoreClipsByBits(dyskinetic_clipIndex, dyskinetic_labels);
normal_clipScores = scoreClipsByBits(normal_clipIndex, normal_labels);

recordScores = zeros(1,4);
clipNumbers = zeros(1,4);
recordTimes = {'10:30', '11:30', '15:00', '17:00'};  

for i =1:length(dyskinetic_clip_list)
    clipName = dyskinetic_clip_list{i};
    if (~isempty(strfind(clipName, 'patient6_')) && ~isempty(strfind(clipName, 'afterMed')))
        recordScores(3) = recordScores(3) + dyskinetic_clipScores(i);
        clipNumbers(3) = clipNumbers(3) + 1;
    elseif (~isempty(strfind(clipName, 'patient6_')) && ~isempty(strfind(clipName, 'nonPeak')))
        recordScores(1) = recordScores(1) + dyskinetic_clipScores(i);
           clipNumbers(1) = clipNumbers(1) + 1;
    elseif (~isempty(strfind(clipName, 'patient6b')))
        recordScores(2) = recordScores(2) + dyskinetic_clipScores(i);
           clipNumbers(2) = clipNumbers(2) + 1;
    elseif (~isempty(strfind(clipName, 'patient6d')))
        recordScores(4) = recordScores(4) + dyskinetic_clipScores(i);
           clipNumbers(4) = clipNumbers(4) + 1;
    end
end

recordScores = recordScores ./clipNumbers;

figure();
plot ([1, 1.5, 3.5, 4.5], recordScores);
title ('Average level of dyskinesia using dyskinetic particle percentage in small hand movements');
xlabel ('Hour of the day');
ylabel('Dyskinetic particle percentage');
set(gca,'Xtick', [1, 1.5, 3.5, 4.5]);
set(gca, 'XTickLabel', recordTimes);