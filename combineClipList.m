function [clip_list ] = combineClipList(vars, state_labels, posture_label, movement_labels)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
clip_list = cell(0);

for i = 1:length(vars)
    state = ~isempty(strfind(vars{i}, state_labels{1}));
    for j = 2:length(state_labels)
        state = state || ~isempty(strfind(vars{i}, state_labels{j}));
    end
    posture = ~isempty(strfind(vars{i}, posture_label));
    movement = ~isempty(strfind(vars{i}, movement_labels{1}));
    for j = 2: length(movement_labels)
        movement = movement || ~isempty(strfind(vars{i}, movement_labels{j}));
    end
    if (state && posture && movement)
        clip_list = [clip_list vars{i}];
    end
end


end

