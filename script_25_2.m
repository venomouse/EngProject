load argi_stand_small_samples

data = who;

peak_samples = cell(0);
nonPeak_samples = cell(0);

for i=1:length(data)
    if (~isempty(strfind(data{i}, 'peakMed')))
        peak_samples = [peak_samples, data{i}];
    elseif (~isempty(strfind(data{i}, 'nonPeak')))
        nonPeak_samples = [nonPeak_samples, data{i}];
    end
end

[dys_sc1, dys_sc2, norm_sc1, norm_sc2] = compareTwoStates (peak_samples, nonPeak_samples, joints.SPINE, 105);