function [clip_list ] = combineClipList(vars, patient_labels, posture_label, movement_labels)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
clip_list = cell(0);

for i = 1:length(vars)
    if (iscell(patient_labels))
        state = ~isempty(strfind(vars{i}, patient_labels{1}));
        for j = 2:length(patient_labels)
            state = state || ~isempty(strfind(vars{i}, patient_labels{j}));
        end
    else
        state = ~isempty(strfind(vars{i}, patient_labels));
    end
    posture = ~isempty(strfind(vars{i}, posture_label{1}));
    movement = ~isempty(strfind(vars{i}, movement_labels{1}));
    for j = 2: length(movement_labels)
        movement = movement || ~isempty(strfind(vars{i}, movement_labels{j}));
    end
    if (state && posture && movement)
        clip_list = [clip_list vars{i}];
    end
end


end

