clear;
close all;

load clipMaps;

sampleLength = 50;
overlapLength = 25;
movement = {'finger', 'handopen'};
posture = {'sit'};
pca = true;
num_retain = 3;
grade_type = Patient.AIMS_OVERALL;
vectorType = @averageMotionFeatureVectorForStatistics;

map = sittingFSClipMap;

dyskinetic_train = {'patient6am'};
normal_train = {'patient6c'};

for i = 1:length(dyskinetic_train);
    eval (['load ' map(dyskinetic_train{i}).fileName]);
end

for i = 1:length(normal_train);
    eval (['load ' map(normal_train{i}).fileName]);
end

vars = who;
dyskinetic_clip_list = combineClipList(vars, dyskinetic_train, posture, movement);
normal_clip_list = combineClipList(vars, normal_train, posture, movement);

[svmStruct, eigVectors, meanMatrix] = trainClassifier_customFcn(dyskinetic_clip_list, normal_clip_list, sampleLength, overlapLength,vectorType,pca,num_retain);

%%

clearvars -except svmStruct sampleLength overlapLength ...
    eigVectors meanMatrix map pca grade_type vectorType ...
    posture movement


load 15_6_demonstration_long  
posture = {'_'};

patients = {'mild'};
vars = who;
clip_lists = cell(size(patients));
for i =1:length(patients)
    clip_lists{i} = combineClipList(vars, patients{i}, posture, movement); 
end

labels = cell(size(patients));
lower_dims = cell(size(patients));
clip_indices = cell(size(patients));
clip_scores = cell(size(patients));
grades = zeros(size(patients));

for i = 1:length(patients)
    if (pca)
        [labels{i}, clip_indices{i},lower_dims{i}] = classifyClips_customFcn_pca(svmStruct,eigVectors, meanMatrix, clip_lists{i}, sampleLength, overlapLength, vectorType);
    else
        [labels{i}, clip_indices{i},lower_dims{i}] = classifyClips_customFcn_noPCA(svmStruct,clip_lists{i}, sampleLength, overlapLength, vectorType);
    end
    clip_scores{i} = scoreClipsByBits(clip_indices{i}, labels{i});
    grades(i) = mean (clip_scores{i});
end
