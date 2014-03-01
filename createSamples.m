load 14_1_data
load 29_1_argi_data

sampleLength = 100;
overlap = 10;

interval = 1;
peakMed_drink_left1 = patient_afterMed_stand_drink(1:interval:sampleLength+overlap,:);
peakMed_drink_left2 = patient_afterMed_stand_drink(sampleLength:interval:2*sampleLength+overlap-1,:);
peakMed_drink_left3 = patient_afterMed_stand_drink(2*sampleLength:interval:3*sampleLength+overlap-1,:);

peakMed_drink_right1 = patient_afterMed_stand_drink_right(20:interval:20+sampleLength+overlap-1,:);
peakMed_drink_right2 = patient_afterMed_stand_drink_right(20+sampleLength:interval:20+2*sampleLength+overlap-1,:);
peakMed_drink_right3 = patient_afterMed_stand_drink_right(20+2*sampleLength:interval:20+3*sampleLength+overlap-1,:);

peakMed_handopen_left1 = patient_afterMed_stand_handopen(20:interval:20+sampleLength+overlap-1,:);
peakMed_handopen_left2 = patient_afterMed_stand_handopen(20+sampleLength:interval:20+2*sampleLength+overlap-1,:);

peakMed_finger_left1 = patient_afterMed_stand_handopen_find(1:interval:sampleLength+overlap,:);
peakMed_finger_left2 = patient_afterMed_stand_handopen_find(sampleLength:interval:2*sampleLength+overlap,:);
peakMed_finger_left3 = patient_afterMed_stand_handopen_find(end-sampleLength-overlap+1:interval:end,:);

peakMed_finger_right1 = patient_afterMed_stand_handopen_find_right(50:interval:50+sampleLength+overlap,:);
peakMed_finger_right2 = patient_afterMed_stand_handopen_find_right(50+sampleLength:interval:50+2*sampleLength+overlap,:);
peakMed_finger_right3 = patient_afterMed_stand_handopen_find_right(end-sampleLength-overlap+1:interval:end,:);

peakMed_handopen_right1 = patient_afterMed_stand_handopen_le(30:interval:29+sampleLength+overlap,:);
peakMed_handopen_right2 = patient_afterMed_stand_handopen_le(30+sampleLength:interval:29+2*sampleLength+overlap,:);

peakMed_supination_left1 = patient_afterMed_stand_handopen_sup(1:interval:1+sampleLength+overlap,:);
peakMed_supination_left2 = patient_afterMed_stand_handopen_sup(sampleLength:interval:2*sampleLength+overlap,:);
peakMed_supination_left3 = patient_afterMed_stand_handopen_sup(end-sampleLength-overlap+1:interval:end,:);

peakMed_supination_right1 = patient_afterMed_stand_handopen_sup_le(1:interval:1+sampleLength+overlap,:);
peakMed_supination_right2 = patient_afterMed_stand_handopen_sup_le(sampleLength:interval:2*sampleLength+overlap,:);
peakMed_supination_right3 = patient_afterMed_stand_handopen_sup_le(end-sampleLength-overlap+1:interval:end,:);

peakMed_still1 = patient_afterMed_stand_still(240:240+sampleLength+overlap -1, :);
peakMed_still2 = patient_afterMed_stand_still(end-sampleLength-overlap+1:interval:end,:);

nonPeak_still1 = patient_steady_stand1(1:interval:sampleLength+overlap,:);
nonPeak_still2 = patient_steady_stand1(end-sampleLength-overlap+1:interval:end,:);
nonPeak_still3 = patient_steady_stand2(1:interval:sampleLength+overlap,:);
nonPeak_stand4 = patient_steady_stand2(sampleLength:interval:2*sampleLength+overlap,:);
nonPeak_stand5 = patient_steady_stand2(end-sampleLength+1:interval:end,:);

nonPeak_supination_right1 = patient_supination(1:interval:sampleLength+overlap,:);
nonPeak_supination_right2 = patient_supination(sampleLength:interval:2*sampleLength+overlap,:);
nonPeak_supination_right3 = patient_supination(end-sampleLength-overlap+1:interval:end,:);

nonPeak_lift_hand_left1 = patient_lift_hand_left(1:interval:sampleLength+overlap-1,:);
nonPeak_lift_hand_left2 = patient_lift_hand_left(sampleLength:interval:2*sampleLength+overlap,:);
nonPeak_lift_hand_left3 = patient_lift_hand_left(2*sampleLength:interval:3*sampleLength+overlap,:);
nonPeak_lift_hand_left4 = patient_lift_hand_left(end+1-sampleLength-overlap:interval:end,:);

nonPeak_lift_hand_right1 = patient_lift_hand_right1(1:interval:sampleLength+overlap-1,:);
nonPeak_lift_hand_right2 = patient_lift_hand_right1(sampleLength:interval:2*sampleLength+overlap,:);
nonPeak_lift_hand_right3 = patient_lift_hand_right1(2*sampleLength:interval:3*sampleLength+overlap,:);
nonPeak_lift_hand_right4 = patient_lift_hand_right1(end+1-sampleLength-overlap:interval:end,:);

vars = who;
save('argi_stand_small_samples.mat',vars{1})
for i = 1:length(vars)
   if (~isempty(strfind(vars{i}, 'peakMed')) || ~isempty(strfind(vars{i}, 'nonPeak')))  
    save('argi_stand_small_samples.mat',vars{i}, '-append');
   end
end