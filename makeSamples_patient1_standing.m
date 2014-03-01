load 08_1_data
sampleLength = 220;

patient1_stand_still1 = patient1_steady_stand(1:sampleLength,:);
patient1_stand_still2 = patient1_steady1(1:sampleLength, :);
patient1_finger_right = patient1_steady1(300:300+sampleLength-1,:);
patient1_finger_left = patient1_steady1(900:900+sampleLength-1,:);
patient1_supination_right = patient1_steady_hand(1:sampleLength,:);

save('patient1_standing_samples.mat', 'patient1_stand_still1', ...
    'patient1_stand_still2', 'patient1_finger_right', ...
    'patient1_finger_left', 'patient1_supination_right');