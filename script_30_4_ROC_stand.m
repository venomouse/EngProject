clear all;
load patient6_data_for_train_sit
load 13_3_data_for_training
%load patient11_finger_handopen
%load patient4_normal_clips_sit
%load patient7a_finger_handopen
%load patient7c_finger_handopen

% load patient6_finger_handopen
% load patient6e_finger_handopen
% load patient7a_finger_handopen
% load patient7c_finger_handopen
% load patient8_finger_handopen
%  load patient10a_finger_handopen
% load patient11_finger_handopen
% load patient4_normal_clips_stand
% load patient4_normal_clips_sit
% load patient2_dyskinetic_clips_sit
% load patient2_dyskinetic_clips_stand
load me_finger_handopen

sampleLength = 50;
overlapLength = 25;

%combine the clip list
vars = who;

dyskinetic_clip_list = cell(0);
normal_clip_list = cell(0);

for i = 1:length(vars)
  
  %  dyskinetic_state_label = ~isempty(strfind(vars{i}, 'patient7c'))
  % normal_state_label = ~isempty(strfind(vars{i}, 'patient7a'))% ||~isempty(strfind(vars{i}, 'patient11')) ;
 dyskinetic_state_label = ~isempty(strfind(vars{i}, 'afterMed')) %|| ~isempty(strfind(vars{i}, 'patient6e'))|| ~isempty(strfind(vars{i}, 'patient6d'));
 normal_state_label = ~isempty(strfind(vars{i}, 'beforeMed')) %||~isempty(strfind(vars{i}, 'healthy')) %|| ~isempty(strfind(vars{i}, 'healthy'))% || ~isempty(strfind(vars{i}, 'patient10a')) || ~isempty(strfind(vars{i}, 'healthy')) || ~isempty(strfind(vars{i}, 'patient8'));
    posture_label = ~isempty(strfind(vars{i}, 'stand'));
    movement_label = ~isempty(strfind(vars{i}, 'finger'))|| ~isempty(strfind(vars{i}, 'handopen')); 
    
    if(normal_state_label && posture_label && movement_label)
        normal_clip_list = [normal_clip_list vars{i}];
    elseif (dyskinetic_state_label && posture_label && movement_label)
        dyskinetic_clip_list = [dyskinetic_clip_list vars{i}];
    end
end

[svmStruct, eigVectors, meanMatrix] = trainClassifier_averageFeatureVector(dyskinetic_clip_list, normal_clip_list, sampleLength, overlapLength);



%%
clearvars -except svmStruct sampleLength overlapLength eigVectors meanMatrix

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

vars = who;

patients = {'patient2', 'patient4', 'patient6np', 'patient6b', 'patient6d', 'patient6e', 'patient8', 'patient10a', 'patient11'};
standing_labels = [1,0,1,1,1,1, 1, 0, 0 ];
%demo
%patients = {'patient2', 'patient6np'};

dyskinetic_patients = [1,3,4,5,6,7];
normal_patients = [2,8,9];
num_retain = 3;

patient_label = [];
clip_lists = cell(size(patients));
for j =1:length(patients)
    clip_lists{j} = cell(0);
end

for i = 1:length(vars)
    patient_label(1) = ~isempty(strfind(vars{i}, 'patient2')); 
    patient_label(2) = ~isempty(strfind(vars{i}, 'patient4'));
    patient_label(3) = ~isempty(strfind(vars{i}, 'patient6_'))&& ~isempty(strfind(vars{i}, 'nonPeak'));   
    patient_label(4) = ~isempty(strfind(vars{i}, 'patient6b'));
    patient_label(5) = ~isempty(strfind(vars{i}, 'patient6d'));
    patient_label(6) = ~isempty(strfind(vars{i}, 'patient6e'));
    patient_label(7) = ~isempty(strfind(vars{i}, 'patient8'));
    patient_label(8) = ~isempty(strfind(vars{i}, 'patient10a'));
    patient_label(9) = ~isempty(strfind(vars{i}, 'patient11'));
    posture_label = ~isempty(strfind(vars{i}, 'stand'));
    movement_label = ~isempty(strfind(vars{i}, 'finger'))|| ~isempty(strfind(vars{i}, 'handopen')); 
    
    for j = 1:length(patients)
        if(patient_label(j) && posture_label && movement_label)
            clip_lists{j} = [clip_lists{j} vars{i}];
        end
    end
end

labels = cell(size(patients));
lower_dims = cell(size(patients));
clip_indices = cell(size(patients));
clip_scores = cell(size(patients));
stand_grades = zeros(size(patients));

for i = 1:length(patients)
    [labels{i}, clip_indices{i},lower_dims{i}] = classifyClips_afv(svmStruct,eigVectors, meanMatrix, clip_lists{i}, sampleLength, overlapLength, num_retain); 
    clip_scores{i} = scoreClipsByBits(clip_indices{i}, labels{i});
    stand_grades(i) = mean (clip_scores{i});
end
%%
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




