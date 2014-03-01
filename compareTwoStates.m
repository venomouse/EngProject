function [ dyskinetic_scores1, dyskinetic_scores2, normal_scores1, normal_scores2 ] = compareTwoStates(dyskinetic_samples, normal_samples, jointNum, sampleLength )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

indices = 3*jointNum-2:3*jointNum;

score1 = @(chainTable, chainLengths, chainDistances, chainNumbers, vectorLengths ) jointSpeed(chainTable);
score2 = @(chainTable) mean(chainTable(:,5));

dyskinetic_scores1 =  zeros(1, length(dyskinetic_samples));
dyskinetic_scores2 = zeros(1, length(dyskinetic_samples));

for i = 1:length(dyskinetic_samples)
    data = evalin ('base',dyskinetic_samples{i});
    [chainLengths, chainDistances, chainNumbers, chainTable, vectorLengths] =growMovements(data(:,indices), sampleLength);
    dyskinetic_scores1(i) = score1(chainTable,chainLengths, chainDistances, chainNumbers, vectorLengths );
    dyskinetic_scores2(i) = score2(chainTable);
end

normal_scores1 = zeros(1, length(normal_samples));
normal_scores2 = zeros(1, length(normal_samples));

for i = 1:length(normal_samples)
    data = evalin ('base', normal_samples{i});
    [chainLengths, chainDistances, chainNumbers, chainTable, vectorLengths] =growMovements(data(:,indices), sampleLength);
    normal_scores1(i) = score1(chainTable, chainLengths, chainDistances, chainNumbers, vectorLengths );
    normal_scores2(i) = score2(chainTable);
end

figure()
subplot(1,2,1);
scores1(1) = mean(dyskinetic_scores1);
errors1(1) = sqrt(var(dyskinetic_scores1));
scores1(2) = mean(normal_scores1);
errors1(2) = sqrt(var(normal_scores1));

hold on;
bar(1,scores1(1));
errorbar(1, scores1(1), errors1(1));
bar(2,scores1(2),'r')
errorbar(2, scores1(2), errors1(2));

legend('Dyskinetic movement', '', 'Normal movement');
title('Integral score');


subplot(1,2,2);
scores2(1) = mean(dyskinetic_scores2);
errors2(1) = sqrt(var(dyskinetic_scores2));
scores2(2) = mean(normal_scores2);
errors2(2) = sqrt(var(normal_scores2));

hold on;
bar(1,scores2(1));
errorbar(1, scores2(1), errors2(1));
bar(2,scores2(2),'r')
errorbar(2, scores2(2), errors2(2));

legend('Dyskinetic movement', '', 'Normal movement');
title('Mean movement length score');

end

