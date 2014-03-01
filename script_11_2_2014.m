load argi_sitting_samples 

dyskinetic_samples ={'afterMed_right_finger', ...
    'afterMed_right_handopen1', 'afterMed_left_finger', ... 
    'afterMed_left_drink'};
%%
dyskinetic_scores = zeros(1, length(dyskinetic_samples));
dyskinetic_distance_scores = zeros(1, length(dyskinetic_samples));
figure()
for i = 1:length(dyskinetic_samples)
    data = eval (dyskinetic_samples{i});
    [chainLengths, chainDistances, chainNumbers, chainTable] =growMovements(data(:,indexConstants.KNEERIGHT));
    dyskinetic_scores(i) = mean(chainLengths);
    dyskinetic_distance_scores(i) = mean(chainDistances);
    
    if (i ==1)
        subplot (1,3,2);
         plot(chainDistances);
         axis ([0 150 0 0.04])
    end
end

[chainLengths, chainDistances, chainNumbers, chainTable] =growMovements(afterMed_left_leg(:,indexConstants.KNEERIGHT));
moving_score = sum(chainLengths);
moving_distance_score = sum(chainDistances);
subplot(1,3,1)
plot(chainDistances)
 axis ([0 150 0 0.04])

[chainLengths, chainDistances, chainNumbers, chainTable] =growMovements(patient3_right_fing(:,indexConstants.KNEELEFT));
quiet_score = sum(chainLengths);
quiet_distance_score = sum(chainDistances);
subplot(1,3,3)
plot(chainDistances)
axis ([0 150 0 0.04])

scores = [moving_score, mean(dyskinetic_scores), quiet_score];
distance_scores = [moving_distance_score, mean(dyskinetic_distance_scores), quiet_distance_score];


figure();
subplot(1,2,1);
title('Score based on movement length(in frames)');
bar(1:3, scores)

subplot(1,2,2)
title('Score based on movement distance(sum of vector lengths)')
bar(1:3, distance_scores)