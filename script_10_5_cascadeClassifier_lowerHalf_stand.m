clear all;
load patient6_data_for_train_sit
load patient6_finger_handopen
load patient6e_finger_handopen
load patient7a_finger_handopen
load patient7c_finger_handopen
load patient8_finger_handopen
load patient10a_finger_handopen
load patient11_finger_handopen
load patient4_normal_clips_stand
load patient4_normal_clips_sit
load patient2_dyskinetic_clips_sit
 load patient2_dyskinetic_clips_stand
load me_finger_handopen

sampleLength = 50;
overlapLength = 25;

%combine the clip list
vars = who;

strong_dyskinetic_clip_list = cell(0);
normal_clip_list = cell(0);
weak_dyskinetic_clip_list = cell(0);


for i = 1:length(vars)
  
    strong_dyskinetic_state_label = ~isempty(strfind(vars{i}, 'patient6b'));
    weak_dyskinetic_state_label = ~isempty(strfind(vars{i}, 'patient6e'));
    normal_state_label = ~isempty(strfind(vars{i}, 'patient6c'));
    posture_label = ~isempty(strfind(vars{i}, 'stand'));
    movement_label = ~isempty(strfind(vars{i}, 'finger'))|| ~isempty(strfind(vars{i}, 'handopen')); 
    
    if(normal_state_label && posture_label && movement_label)
        normal_clip_list = [normal_clip_list vars{i}];
    elseif (strong_dyskinetic_state_label && posture_label && movement_label)
        strong_dyskinetic_clip_list = [strong_dyskinetic_clip_list vars{i}];
    elseif (weak_dyskinetic_state_label && posture_label && movement_label)
        weak_dyskinetic_clip_list = [weak_dyskinetic_clip_list vars{i}];
    end
end

[svmStruct,dyskinetic_svmStruct, eigVectors, meanMatrix] = trainCascadeClassifier_customFcn(strong_dyskinetic_clip_list, weak_dyskinetic_clip_list,normal_clip_list, sampleLength, overlapLength,@averageLowerHalfFeatureVector,1,3);

%%
 clearvars -except svmStruct dyskinetic_svmStruct sampleLength overlapLength eigVectors meanMatrix

 loadAllData;
 vars = who;

 load_lowerHalf_stand;

 
labels = cell(size(patients));
lower_dims = cell(size(patients));
clip_indices = cell(size(patients));
clip_scores = cell(size(patients));
grades = zeros(size(patients));

for i = 1:length(patients)
    [labels{i}, clip_indices{i},lower_dims{i}] = classifyClips_cascade_customFcn_pca(svmStruct,dyskinetic_svmStruct, eigVectors, meanMatrix, clip_lists{i}, sampleLength, overlapLength, @averageLowerHalfFeatureVector); 
    clip_scores{i} = scoreClipsByBits(clip_indices{i}, labels{i});
    grades(i) = mean (clip_scores{i});
end
%%
%scatter plot the pca
figure();
hold on;
for j = 1:length(patients)
   data = lower_dims{j};
   if (ismember(j, dyskinetic_patients))
       scatter3 (data(1,:), data (2,:), data(3,:), 'b'); 
   else
      scatter3 (data(1,:), data (2,:), data(3,:), 'g');
   end
end

[FPR,TPR] = ROC(grades, true_labels);

grc = genRankCorr(grades, aims_grades)
