% dyskinetic_samples = {'moderate_finger_left', ...
%                       'moderate_finger_right', ...
%                       'moderate_handopen_left',...
%                       'moderate_handopen_right', ...
%                       'moderate_supination_left', ...
%                       'moderate_supination_right', ...
%                       'moderate_sit_still'};

vars = who;

dyskinetic_samples = cell(0);
normal_samples = cell(0);
joint = joints.KNEELEFT;

for i = 1:length(vars)
    if(~isempty(strfind(vars{i}, 'healthy')) && isempty(strfind(vars{i}, 'stand')) )
        normal_samples = [normal_samples vars{i}];
    elseif (~isempty(strfind(vars{i}, 'nonPeak')) && ~isempty(strfind(vars{i}, 'sit')) && ...
             isempty(strfind(vars{i}, 'leg')) && isempty(strfind(vars{i}, 'heel')))
        dyskinetic_samples = [dyskinetic_samples vars{i}];
    end
end

sampleLength = 150;
numOfGrades = 5;
numBins = 45;
                 
dyskinetic_rightKneeSamples = samplesFromClipList(dyskinetic_samples, joint, sampleLength);                  
normal_rightKneeSamples =samplesFromClipList(normal_samples,joint, sampleLength );

figure();
subplot(1,2,1)
[featList_dys, grades_dys] =oneDimensionVocabularyFromSamples(dyskinetic_rightKneeSamples , numOfGrades );
[h, cent] = hist (featList_dys, numBins);
hold on;
bar (cent,h);
axis ([0 0.05 0 30])
stem (classification.EDGES_KNEE, 15*ones(1,length(classification.EDGES_KNEE)), 'r');
hold off;
title ('Dyskinetic knee movement length distribution')


subplot(1,2,2)
[featList_norm, grades_norm] =oneDimensionVocabularyFromSamples( normal_rightKneeSamples, numOfGrades );
[h, cent] = hist (featList_norm, numBins);
hold on;
bar (cent,h);
stem (classification.EDGES_KNEE, 10*ones(1,length(classification.EDGES_KNEE)), 'r');
axis ([0 0.05 0 30])
hold off;  
title ('Normal knee movement length distribution')
                  