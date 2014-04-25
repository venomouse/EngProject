load 13_3_data_for_training
load('05_3_2014_patient6.mat')
load('12_3_2014_patient6.mat')
load('19_3_2014_patient6.mat')


vars = who;

dyskinetic_clip_list = cell(0);
normal_clip_list = cell(0);

for i = 1:length(vars)
    if(~isempty(strfind(vars{i}, 'afterMed')) && ~isempty(strfind(vars{i}, 'stand')) ...
            && (~isempty(strfind(vars{i}, 'finger'))|| ~isempty(strfind(vars{i}, 'handopen'))) )
        normal_clip_list = [normal_clip_list vars{i}];
    elseif (( ~isempty(strfind(vars{i}, 'afterMed'))) && ~isempty(strfind(vars{i}, 'stand')) ...
            && (~isempty(strfind(vars{i}, 'finger'))|| ~isempty(strfind(vars{i}, 'handopen'))) )
        dyskinetic_clip_list = [dyskinetic_clip_list vars{i}];
    end
end

%%
%split every clip to bits and combine two sample lists
%make feature vector from each bit 

sampleLength = 50;
overlapLength = 10;

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
        featureVec = averageMotionFeatureVectorForStatistics (sampleClips{j}, sampleLength + overlapLength); 
        clipMatrix = [clipMatrix, featureVec'];
        dyskinetic_clipIndex = [dyskinetic_clipIndex; i,j];
    end
 %   clipMatrix = correctMissingAverage(clipMatrix);
    dyskinetic_matrix = [dyskinetic_matrix, clipMatrix];
    dyskinetic_clipMat{i} = clipMatrix;
end

for i = 1:length(normal_sampleClips)
    sampleClips = normal_sampleClips{i};
    clipMatrix = [];
    for j = 1:length(sampleClips)
        featureVec = averageMotionFeatureVectorForStatistics (sampleClips{j}, sampleLength + overlapLength); 
        clipMatrix = [clipMatrix, featureVec'];
        normal_clipIndex = [normal_clipIndex; i,j];
    end
 %   clipMatrix = correctMissingAverage(clipMatrix);
    normal_matrix = [normal_matrix, clipMatrix];
    normal_clipMat{i} = clipMatrix;
end
%%
   HEAD = 1;
   MOVING_SHOULDER = 2;
   OPPOSITE_SHOULDER = 3;
   OPPOSITE_ELBOW = 4;
   SAMESIDE_HIP = 5;
   OPPOSITE_HIP = 6;
   SAMESIDE_KNEE = 7;
   OPPOSITE_KNEE = 8;
   SAMESIDE_ANKLE = 9;
   OPPOSITE_ANKLE = 10;
   
   OPPOSITE_WRIST = 11;
   OPPOSITE_HAND = 12;
   SAMESIDE_FOOT = 13;
   OPPOSITE_FOOT = 14;
   SHOULDER_CENTER = 15;
   SPINE = 16;
   HIP_CENTER = 17;
%%
upper = [HEAD MOVING_SHOULDER OPPOSITE_SHOULDER];
titles = {'head', 'moving shoulder', 'opposite shoulder'};
figure();
for i = 1:3
    dyst_data = dyskinetic_matrix(upper(i),:);
    norm_data = normal_matrix(upper(i),:);
    [dyst_h, dyst_binc] = hist(dyst_data, 30);
    [normal_h, normal_binc] = hist(norm_data, dyst_binc);
    
    dyst_mean = mean(dyst_data(dyst_data>0));
    dyst_var = var(dyst_data(dyst_data > 0));
    normal_mean = mean(norm_data(norm_data>0));
    normal_var = var(norm_data(norm_data>0));
    subplot(1,3,i)
    hold on;
    bar(dyst_binc, dyst_h,'r')
    bar(normal_binc, normal_h,'b');
    str =  {titles{i},['dyst\_mean=' num2str(dyst_mean,'%2.4f') ' norm\_mean=' num2str(normal_mean,'%2.4f') ]};
    title(str)
end

%%
upper = [OPPOSITE_ELBOW OPPOSITE_WRIST OPPOSITE_HAND];
titles = {'opposite elbow', 'opposite wrist', 'opposite hand'};
figure();
for i = 1:3
    dyst_data = dyskinetic_matrix(upper(i),:);
    norm_data = normal_matrix(upper(i),:);
    [dyst_h, dyst_binc] = hist(dyst_data, 30);
    [normal_h, normal_binc] = hist(norm_data, dyst_binc);
    
    dyst_mean = mean(dyst_data(dyst_data>0));
    dyst_var = var(dyst_data(dyst_data > 0));
    normal_mean = mean(norm_data(norm_data>0));
    normal_var = var(norm_data(norm_data>0));
    subplot(1,3,i)
    hold on;
    bar(dyst_binc, dyst_h,'r')
    bar(normal_binc, normal_h,'b');
    str =  {titles{i},['dyst\_mean=' num2str(dyst_mean,'%2.4f') ' norm\_mean=' num2str(normal_mean,'%2.4f') ]};
    title(str)
end

%%
upper = [OPPOSITE_KNEE OPPOSITE_ANKLE OPPOSITE_FOOT];
titles = {'opposite knee', 'opposite ankle', 'opposite foot'};
figure();
for i = 1:3
    dyst_data = dyskinetic_matrix(upper(i),:);
    norm_data = normal_matrix(upper(i),:);
    [dyst_h, dyst_binc] = hist(dyst_data, 30);
    [normal_h, normal_binc] = hist(norm_data, dyst_binc);
    
    dyst_mean = mean(dyst_data(dyst_data>0));
    dyst_var = var(dyst_data(dyst_data > 0));
    normal_mean = mean(norm_data(norm_data>0));
    normal_var = var(norm_data(norm_data>0));
    subplot(1,3,i)
    hold on;
    bar(normal_binc, normal_h,'b');
    bar(dyst_binc, dyst_h,'r')
    str =  {titles{i},['dyst\_mean=' num2str(dyst_mean,'%2.4f') ' norm\_mean=' num2str(normal_mean,'%2.4f') ]};
    title(str)
end

%%
upper = [SPINE SAMESIDE_HIP OPPOSITE_HIP];
titles = {'spine', 'sameside hip', 'opposite hip'};
figure();
for i = 1:3
    dyst_data = dyskinetic_matrix(upper(i),:);
    norm_data = normal_matrix(upper(i),:);
    [dyst_h, dyst_binc] = hist(dyst_data, 30);
    [normal_h, normal_binc] = hist(norm_data, dyst_binc);
    
    dyst_mean = mean(dyst_data(dyst_data>0));
    dyst_var = var(dyst_data(dyst_data > 0));
    normal_mean = mean(norm_data(norm_data>0));
    normal_var = var(norm_data(norm_data>0));
    subplot(1,3,i)
    hold on;
    bar(normal_binc, normal_h,'b');
    bar(dyst_binc, dyst_h,'r')
    str =  {titles{i},['dyst\_mean=' num2str(dyst_mean,'%2.4f') ' norm\_mean=' num2str(normal_mean,'%2.4f') ]};
    title(str)
end
%%
upper = [SAMESIDE_KNEE SAMESIDE_ANKLE SAMESIDE_FOOT];
titles = {'same side knee', 'same side ankle', 'same side foot'};
figure();
for i = 1:3
    dyst_data = dyskinetic_matrix(upper(i),:);
    norm_data = normal_matrix(upper(i),:);
    [dyst_h, dyst_binc] = hist(dyst_data, 30);
    [normal_h, normal_binc] = hist(norm_data, dyst_binc);
    
    dyst_mean = mean(dyst_data(dyst_data>0));
    dyst_var = var(dyst_data(dyst_data > 0));
    normal_mean = mean(norm_data(norm_data>0));
    normal_var = var(norm_data(norm_data>0));
    subplot(1,3,i)
    hold on;
    bar(normal_binc, normal_h,'b');
    bar(dyst_binc, dyst_h,'r')
    str =  {titles{i},['dyst\_mean=' num2str(dyst_mean,'%2.4f') ' norm\_mean=' num2str(normal_mean,'%2.4f') ]};
    title(str)
end
