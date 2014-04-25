function [svmStruct] = trainClassifier_averageFeatureVector(dyskinetic_clip_list, normal_clip_list, sampleLength, overlapLength)

% sampleLength = 50;
% overlapLength = 25;

%combine the clip list
vars = who;

% dyskinetic_clip_list = cell(0);
% normal_clip_list = cell(0);
% 
% for i = 1:length(vars)
%     dyskinetic_state_label = ~isempty(strfind(vars{i}, 'afterMed'))|| ~isempty(strfind(vars{i}, 'afterMed'));
%     normal_state_label = ~isempty(strfind(vars{i}, 'beforeMed'));
%     posture_label = ~isempty(strfind(vars{i}, 'sit'));
%     movement_label = ~isempty(strfind(vars{i}, 'finger'))|| ~isempty(strfind(vars{i}, 'handopen')); 
%     
%     if(normal_state_label && posture_label && movement_label)
%         normal_clip_list = [normal_clip_list vars{i}];
%     elseif (dyskinetic_state_label && posture_label && movement_label)
%         dyskinetic_clip_list = [dyskinetic_clip_list vars{i}];
%     end
% end

[dyskinetic_matrix, dyskinetic_clipMat, dyskinetic_clipIndex] = generateAverageFeatureMatrixFromClipList(dyskinetic_clip_list, sampleLength,overlapLength);
[normal_matrix, normal_clipMat, normal_clipIndex] = generateAverageFeatureMatrixFromClipList(normal_clip_list,sampleLength,overlapLength);

num_retain = 3;
all_lowerDim = pcaAnalysis([dyskinetic_matrix, normal_matrix], num_retain);
dyskinetic_lowerDim = all_lowerDim(:, 1:size(dyskinetic_matrix,2));
normal_lowerDim = all_lowerDim(:, size(dyskinetic_matrix,2)+1:end);

labels = zeros(size(all_lowerDim,2),1);
labels(1:size(dyskinetic_matrix,2)) = 1;
labels(size(dyskinetic_matrix,2)+1:end) = -1;

svmStruct = svmtrain(all_lowerDim', labels, 'kernel_function', 'rbf');

