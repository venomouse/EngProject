clear all;

sampleLength = 50;
overlapLength = 25;

%% training
% first movement - sitting, small hand movements
load patient6_data_for_train_sit
load 13_3_data_for_training

vars = who;

dyskinetic_state_label = {'afterMed'};
normal_state_label = {'beforeMed'};
posture_label = 'sit';
movement_label = {'finger', 'handopen'};

dyskinetic_clip_list = combineClipList(vars, dyskinetic_state_label, ...
                            posture_label, movement_label);

normal_clip_list = combineClipList(vars, normal_state_label, ...
                            posture_label, movement_label);

svm_sitSmall =  trainClassifier_averageFeatureVector(dyskinetic_clip_list, normal_clip_list, ...
                            sampleLength, overlapLength);
                        
% second movement - sitting, large hand movements
dyskinetic_state_label = {'afterMed'};
normal_state_label = {'beforeMed'};
posture_label = 'sit';
movement_label = {'supination', 'drink'};

dyskinetic_clip_list = combineClipList(vars, dyskinetic_state_label, ...
                            posture_label, movement_label);

normal_clip_list = combineClipList(vars, normal_state_label, ...
                            posture_label, movement_label);

svm_sitLarge =  trainClassifier_averageFeatureVector(dyskinetic_clip_list, normal_clip_list, sampleLength, overlapLength);
                        
% third movement - standing, small hand movements

dyskinetic_state_label = {'afterMed'};
normal_state_label = {'beforeMed'};
posture_label = 'stand';
movement_label = {'finger', 'handopen'};

dyskinetic_clip_list = combineClipList(vars, dyskinetic_state_label, ...
                            posture_label, movement_label);

normal_clip_list = combineClipList(vars, normal_state_label, ...
                            posture_label, movement_label);

svm_standSmall =  trainClassifier_averageFeatureVector(dyskinetic_clip_list, normal_clip_list, ...
                            sampleLength, overlapLength);

% fourth movement - standing, large hand movements
dyskinetic_state_label = {'afterMed'};
normal_state_label = {'beforeMed'};
posture_label = 'stand';
movement_label = {'supination', 'drink'};

dyskinetic_clip_list = combineClipList(vars, dyskinetic_state_label, ...
                            posture_label, movement_label);

normal_clip_list = combineClipList(vars, normal_state_label, ...
                            posture_label, movement_label);

svm_standLarge =  trainClassifier_averageFeatureVector(dyskinetic_clip_list, normal_clip_list, ...
                            sampleLength, overlapLength);


%% classifying 

clearvars -except svm_sitSmall svm_sitLarge svm_standSmall svm_standLarge sampleLength overlapLength

load patient6_data_for_test_sit
vars = who;

% first movement
dyskinetic_state_label = {'afterMed', 'nonPeak'};
posture_label = 'sit';
movement_label = {'finger', 'handopen'};

sitSmall_clip_list = combineClipList(vars, dyskinetic_state_label, ...
                            posture_label, movement_label);

[test_labels, ~, dyskinetic_clipIndex, ~] = testClassifier_averageFeatureVector( svm_sitSmall, sitSmall_clip_list,  ... 
    {}, sampleLength, overlapLength );

% second movement
dyskinetic_state_label = {'afterMed', 'nonPeak'};
posture_label = 'sit';
movement_label = {'supination', 'drink'};

sitLarge_clip_list = combineClipList(vars, dyskinetic_state_label, ...
                            posture_label, movement_label);

[test_labels, ~, dyskinetic_clipIndex, ~] = testClassifier_averageFeatureVector( svm_sitLarge, sitLarge_clip_list,  ... 
    {}, sampleLength, overlapLength );
% third movement 

% fourth movement

