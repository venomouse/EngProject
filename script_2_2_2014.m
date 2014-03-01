measName = 'patient_afterMed_left_fing';
data = eval(measName);
numPoints = size(data,1);

headData = data(:,indexConstants.HEAD);
kneeData = data(:,indexConstants.KNEELEFT);
bigMove =  patient_afterMed_stand_handopen_find_right(:, indexConstants.SPINE);
%headDist = sqrt(sum((headData(1:end-4,:) - headData(5:end,:)).^2,2));
%kneeDist = sqrt(sum((kneeData(1:end-4,:) - kneeData(5:end,:)).^2,2));
headDist = calculatePointDistances(headData);
kneeDist = calculatePointDistances(kneeData);
bigDist = calculatePointDistances(bigMove);

[nel_head,cent_head] = hist(headDist(:),40);
[nel_knee,cent_knee] = hist(kneeDist(:),40);
[nel_big,cent_big] = hist(bigDist(:),40);
figure(); subplot(1,3,1); bar (cent_head, nel_head/numPoints^2); subplot(1,3,2); bar (cent_knee, nel_knee/numPoints^2);
subplot(1,3,3); bar (cent_big, nel_big/numPoints^2)