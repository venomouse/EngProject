patients = {'patient2', 'patient4', 'patient6np', 'patient6b', 'patient6d', 'patient6e', 'patient7a', 'patient7c', 'patient8', 'patient10a', 'patient11', 'me', 'patient6c','patient6am'};
%demo
aims_grades = [0,0,1,2,2,1, 0, 2,0,0,0,0,0,2];
true_labels = aims_grades > 0;
dyskinetic_patients = find(aims_grades >0);
normal_patients = find (aims_grades == 0);
num_retain = 3;

patient_label = [];
clip_lists = cell(size(patients));
for j =1:length(patients)
    clip_lists{j} = cell(0);
end

for i = 1:length(vars)
    patient_label(1) = ~isempty(strfind(vars{i}, 'patient2')); 
    patient_label(2) = ~isempty(strfind(vars{i}, 'patient4'));
    patient_label(3) = ~isempty(strfind(vars{i}, 'patient6np'));  
    patient_label(4) = ~isempty(strfind(vars{i}, 'patient6b'));
    patient_label(5) = ~isempty(strfind(vars{i}, 'patient6d'));
    patient_label(6) = ~isempty(strfind(vars{i}, 'patient6e'));
    patient_label(7) = ~isempty(strfind(vars{i}, 'patient7a'));
    patient_label(8) = ~isempty(strfind(vars{i}, 'patient7c'));
    patient_label(9) = ~isempty(strfind(vars{i}, 'patient8'));
    patient_label(10) = ~isempty(strfind(vars{i}, 'patient10a'));
    patient_label(11) = ~isempty(strfind(vars{i}, 'patient11'));
    patient_label(12) = ~isempty(strfind(vars{i}, 'healthy'));
    patient_label(13) = ~isempty(strfind(vars{i}, 'patient6c'));
    patient_label(14) = ~isempty(strfind(vars{i}, 'patient6am'));
    posture_label = ~isempty(strfind(vars{i}, 'sit'));
    movement_label = ~isempty(strfind(vars{i}, 'finger'))|| ~isempty(strfind(vars{i}, 'handopen')); 
    
    for j = 1:length(patients)
        if(patient_label(j) && posture_label && movement_label)
            clip_lists{j} = [clip_lists{j} vars{i}];
        end
    end
end