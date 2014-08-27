load grades_24_5

 aims_fh_grades = [aims_sit_fh_grades aims_stand_fh_grades];
 my_fh_grades = [my_sit_fh_grades my_stand_fh_grades ];
 
 true_labels = aims_fh_grades >0;
 
 [FPR,TPR] = ROC(my_fh_grades, true_labels);
 
 aims_fh_grades_fullJointVector = [aims_sit_fh_grades_fullJointVector aims_stand_fh_grades_fullJointVector];
 my_fh_grades_fullJointVector = [my_sit_fh_grades_fullJointVector my_stand_fh_grades_fullJointVector ];
 
 true_labels_fullJointVector = aims_fh_grades_fullJointVector >0;
 
 [FPR_fullJointVector,TPR_fullJointVector] = ROC(my_fh_grades_fullJointVector, true_labels_fullJointVector);
 
 
 
 figure();
 hold on;
 plot(FPR,TPR,'b--.', 'LineWidth', 1.5, 'MarkerSize', 16) 

 xlabel('False Positive Ratio')
 ylabel('True Positive Ratio')
 plot(FPR_fullJointVector,TPR_fullJointVector, 'r--.')
% plot(FPR_cascade_BoW,TPR_cascade_BoW, 'k--.')
  

 gradeRC = gradeRankCorr (my_fh_grades, aims_fh_grades)
 
% gradeRC_cascade = gradeRankCorr(my_fh_grades_cascade, aims_fh_grades_cascade)

 
 %%

%  meanscores = zeros(1,4);
%  meanscores_vars = zeros(1,4);
%  for i = 0:3
%      meanscores(i+1) = mean(my_fh_grades(aims_fh_grades ==i));
%      meanscores_vars(i+1) = var(my_fh_grades(aims_fh_grades ==i));
%  end
%  
%  figure()
%  subplot (1,2,1)
%  hold on;
%  bar ([0:3], meanscores, 'r');
%  h = errorbar([0:3], meanscores, meanscores_vars);
%  title ('Binary chunk classification')
%  xlabel ('AIMS dyskinesia severity score')
%  ylabel ('Dyskinetic chunk percentage')
%  set (gca, 'Xtick', [0:3])
% set(h, 'LineStyle', 'none');
%  
% 
%  meanscores = zeros(1,4);
%  meanscores_vars = zeros(1,4);
%  for i = 0:3
%      meanscores(i+1) = mean(my_fh_grades_cascade(aims_fh_grades_cascade ==i));
%      meanscores_vars(i+1) = var(my_fh_grades_cascade(aims_fh_grades_cascade ==i));
%  end
%  
%  subplot (1,2,2)
%  hold on;
%  bar ([0:3], meanscores, 'g');
%  h = errorbar([0:3], meanscores, meanscores_vars);
%  title ('Trinary chunk classification')
%  xlabel ('AIMS dyskinesia severity score')
%  ylabel ('Dyskinetic chunk average')
%  set (gca, 'Xtick', [0:3])
% set(h, 'LineStyle', 'none');
%  