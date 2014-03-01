dataList = {'patient_afterMed_left', 'patient_afterMed_left2', ...
            'patient_afterMed_left_drink', 'patient_afterMed_left_fing'};
indices = indexConstants.ANKLELEFT;
        
distances = [];
for i = 1:length(dataList)
    data = eval (dataList{i});
    jointData = data(:,indices);
    currDist = sqrt(sum((jointData(1:end-1,:) - jointData(2:end,:)).^2,2));
    distances = [distances; currDist];
end

[nel, cent] = hist (distances, 50);
h = bar(cent,nel);
set (h, 'Xtick', cent);

