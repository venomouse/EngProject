figure();
hold on;
for j = 1:length(patients)
   data = lower_dims{j};
   if (ismember(j, dyskinetic_patients))
       scatter3 (data(1,:), data (2,:), data(3,:), 'b'); 
   else
        scatter3 (data(1,:), data (2,:), data(3,:), 'g');
   end
end


[FPR,TPR] = ROC(grades, true_labels);

grc = genRankCorr(grades, aims_grades)

