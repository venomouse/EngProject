load 14_1_data
load 29_1_patient3_data
sampleLength = 150;

%dyskinetic movements
afterMed_right_finger = patient_afterMed_rigth_fing(1:sampleLength,:);
afterMed_right_handopen1 = patient_afterMed_left2(1:sampleLength, :);
afterMed_left_finger = patient_afterMed_left_fing(1:sampleLength,:);

%big movements - lifting the leg
afterMed_left_leg = patient_afterMed_let_leg(1:sampleLength, :);


%lesser movements
afterMed_right_handopen2 = patient_afterMed_left(1:sampleLength, :);
afterMed_left_drink = patient_afterMed_left_drink(3:2+sampleLength, :);

patient3_right_fing = patient_fing_right(1:sampleLength,:);


save('argi_sitting_samples', 'afterMed_right_finger', ...
    'afterMed_right_handopen1', 'afterMed_left_finger', ...
    'afterMed_left_leg', 'afterMed_right_handopen2', ...
    'afterMed_left_drink', 'patient3_right_fing');
clear all

