clear all 
close all

load argi_stand_samples
load patient1_standing_samples
peakStandingSamples = {'afterMed_drink_left', ...
    'afterMed_drink_right', 'afterMed_handopen_right', ...
    'afterMed_finger_left', 'afterMed_finger_right', ...
    'afterMed_handopen_right', 'afterMed_supination_left', ...
    'afterMed_supination_right', 'afterMed_still'};
 
nonPeakStandingSamples = {'nonPeak_stand_1', 'nonPeak_stand_2', ...
    'nonPeak_supination', 'nonPeak_lift_hand_left_1', ...
    'nonPeak_lift_hand_left_2', 'nonPeak_lift_hand_right_1',...
    'nonPeak_lift_hand_right_2'};
%%
normalStandingSamples = {'patient1_stand_still1', ...
    'patient1_stand_still2', 'patient1_finger_right', ...
    'patient1_finger_left', 'patient1_supination_right'};

sampleLength = 200;

afterMed_scores = zeros(1, length(peakStandingSamples));
afterMed_distance_scores = zeros(1, length(peakStandingSamples));
afterMed_distance_sums = zeros(1, length(peakStandingSamples));
afterMed_movement_num = zeros(1, length(peakStandingSamples));
figure()
numOfPlotsinRow = 4;
for i = 1:length(peakStandingSamples)
    data = eval (peakStandingSamples{i});
    [chainLengths, chainDistances, chainNumbers, chainTable, vectorLengths] =growMovements(data(:,indexConstants.SPINE),sampleLength);
    afterMed_scores(i) = mean(chainTable(:,4)); %chainLengths
    afterMed_distance_scores(i) = mean(chainTable(:,5)); %chainDistances 
    afterMed_movement_num(i) = size(chainTable,1);
    if (i <= numOfPlotsinRow)
        subplot(2, numOfPlotsinRow,i);
        plot(chainDistances);
    end
end

nonPeak_scores = zeros(1, length(nonPeakStandingSamples));
nonPeak_distance_scores = zeros(1, length(nonPeakStandingSamples));
nonPeak_distance_sums = zeros(1, length(nonPeakStandingSamples));
nonPeak_movement_num = zeros(1, length(nonPeakStandingSamples));

for i = 1:length(nonPeakStandingSamples)
    data = eval (nonPeakStandingSamples{i});
    [chainLengths, chainDistances, chainNumbers, chainTable, vectorLengths] =growMovements(data(:,indexConstants.SPINE), sampleLength);
    nonPeak_scores(i) = mean(chainTable(:,4));
    nonPeak_distance_scores(i) =mean(chainTable(:,5));
    nonPeak_movement_num(i) = size(chainTable,1);
    if (i <= numOfPlotsinRow)
        subplot(2, numOfPlotsinRow,i+numOfPlotsinRow);
        plot(chainDistances);
    end
end

normal_scores = zeros(1, length(normalStandingSamples));
normal_distance_scores = zeros(1, length(normalStandingSamples));

for i = 1:length(normalStandingSamples)
    data = eval (normalStandingSamples{i});
    [chainLengths, chainDistances, chainNumbers, chainTable] =growMovements(data(:,indexConstants.SPINE), sampleLength);
    normal_scores(i) = mean(chainTable(:,4));
    normal_distance_scores(i) = mean(chainTable(:,5));
%     if (i <= numOfPlotsinRow)
%         subplot(3, numOfPlotsinRow,i+numOfPlotsinRow);
%         plot(chainDistances);
%     end
end

%%
figure()
subplot(1,2,1);
scores(1) = mean(afterMed_scores);
errors(1) = sqrt(var(afterMed_scores));
scores(2) = mean(nonPeak_scores);
errors(2) = sqrt(var(nonPeak_scores));
scores(3) = mean(normal_scores);
errors(3) = sqrt(var(normal_scores));
hold on;
bar(scores);
h =errorbar(1:3, scores, errors);
set (h, 'Linestyle', 'None')

subplot(1,2,2);
scores(1) = mean(afterMed_distance_scores);
errors(1) = sqrt(var(afterMed_distance_scores));
scores(2) = mean(nonPeak_distance_scores);
errors(2) = sqrt(var(nonPeak_distance_scores));
scores(3) = mean(normal_distance_scores);
errors(3) = sqrt(var(normal_distance_scores));


hold on;
bar(scores);
h =errorbar(1:3, scores, errors);
set (h, 'Linestyle', 'None')
% close all

% figure()
% scores1(1) = mean(afterMed_movement_num);
% scores1(2) = mean(nonPeak_movement_num);
% errors1(1) = sqrt(var(afterMed_movement_num));
% errors1(2) = sqrt(var(nonPeak_movement_num));
% hold on;
% bar(scores1)
% h = errorbar(1:2, scores1, errors1);
% 
