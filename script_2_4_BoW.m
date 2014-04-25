clear all
load patient6_data_for_train_sit
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


%jointGrades = allBodyGradesFromSamples(dyskinetic_samples, numOfGrades);
load jointGrades.mat

dyskinetic_matrix = [];
normal_matrix = [];
labelVector = [];
dyskinetic_clipIndex = [];
normal_clipIndex = [];

for i = 1:length(dyskinetic_sampleClips)
    sampleClips = dyskinetic_sampleClips{i};
    clipMatrix = [];
    for j = 1:length(sampleClips)
        featureVec = bodyBoWFeatureVector(sampleClips{j}, jointGrades); 
        clipMatrix = [clipMatrix, featureVec'];
        dyskinetic_clipIndex = [dyskinetic_clipIndex; i,j];
        labelVector = [labelVector;1];
    end
    dyskinetic_matrix = [dyskinetic_matrix, clipMatrix];
    dyskinetic_clipMat{i} = clipMatrix;
end


for i = 1:length(normal_sampleClips)
    sampleClips = normal_sampleClips{i};
    clipMatrix = [];
    for j = 1:length(sampleClips)
        featureVec = bodyBoWFeatureVector(sampleClips{j}, jointGrades); 
        clipMatrix = [clipMatrix, featureVec'];
        normal_clipIndex = [normal_clipIndex; i,j];
        labelVector = [labelVector; -1];
    end
    normal_matrix = [normal_matrix, clipMatrix];
    normal_clipMat{i} = clipMatrix;
end

featureMatrix = [dyskinetic_matrix normal_matrix]';

%training the classifier 
svmStruct = svmtrain(featureMatrix, labelVector);

%%
%testing
clearvars -except svmStruct jointGrades  
load patient6_data_for_test_sit
load 13_3_data_for_testing

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

dyskinetic_sampleClips = samplesFromClipList(dyskinetic_clip_list, -1, sampleLength, overlapLength, 200);
normal_sampleClips = samplesFromClipList(normal_clip_list, -1, sampleLength, overlapLength, 400);


%jointGrades = allBodyGradesFromSamples(dyskinetic_samples, numOfGrades);
load jointGrades.mat

dyskinetic_matrix = [];
normal_matrix = [];
true_labels = [];
dyskinetic_clipIndex = [];
normal_clipIndex = [];

for i = 1:length(dyskinetic_sampleClips)
    sampleClips = dyskinetic_sampleClips{i};
    clipMatrix = [];
    for j = 1:length(sampleClips)
        featureVec = bodyBoWFeatureVector(sampleClips{j}, jointGrades); 
        clipMatrix = [clipMatrix, featureVec'];
        dyskinetic_clipIndex = [dyskinetic_clipIndex; i,j];
        true_labels = [true_labels;1];
    end
    dyskinetic_matrix = [dyskinetic_matrix, clipMatrix];
    dyskinetic_clipMat{i} = clipMatrix;
end


for i = 1:length(normal_sampleClips)
    sampleClips = normal_sampleClips{i};
    clipMatrix = [];
    for j = 1:length(sampleClips)
        featureVec = bodyBoWFeatureVector(sampleClips{j}, jointGrades); 
        clipMatrix = [clipMatrix, featureVec'];
        normal_clipIndex = [normal_clipIndex; i,j];
        true_labels = [true_labels; -1];
    end
    normal_matrix = [normal_matrix, clipMatrix];
    normal_clipMat{i} = clipMatrix;
end

test_featureMatrix = [dyskinetic_matrix normal_matrix]';

%%
test_labels = svmclassify(svmStruct, test_featureMatrix);

figure()
stem(abs(test_labels -true_labels))
disp('Error rate:')
nnz(test_labels -true_labels)/length(true_labels)