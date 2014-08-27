load grades_24_5
 aims_fh_grades = [aims_sit_fh_grades aims_stand_fh_grades];
 my_fh_grades = [my_sit_fh_grades my_stand_fh_grades ];
 
 true_labels = aims_fh_grades >0;
 
 [FPR,TPR] = ROC(my_fh_grades, true_labels);
 
 aims_fh_grades_BoW = [aims_sit_fh_grades_BoW aims_stand_fh_grades_BoW];
 my_fh_grades_BoW = [my_sit_fh_grades_BoW my_stand_fh_grades_BoW ];
 
 true_labels_BoW = aims_fh_grades_BoW >0;
 
 [FPR_BoW,TPR_BoW] = ROC(my_fh_grades_BoW, true_labels_BoW);
 
 
 aims_fh_grades_cascade = [aims_sit_fh_grades_cascade aims_stand_fh_grades_cascade];
 my_fh_grades_cascade = [my_sit_fh_grades_cascade my_stand_fh_grades_cascade];
 
 true_labels_cascade_BoW = aims_fh_grades_cascade >0;
 
 %[FPR_cascade_BoW,TPR_cascade_BoW] = ROC(my_fh_grades_cascade_BoW, true_labels_cascade_BoW);
 
 
 figure();
 hold on;
 plot(FPR,TPR,'b--.', 'LineWidth', 1.5, 'MarkerSize', 16) 

 xlabel('False Positive Ratio')
 ylabel('True Positive Ratio')
%  plot(FPR_BoW,TPR_BoW, 'r--.')
% plot(FPR_cascade_BoW,TPR_cascade_BoW, 'k--.')
  

 gradeRC = gradeRankCorr (my_fh_grades, aims_fh_grades)
 
% gradeRC_cascade = gradeRankCorr(my_fh_grades_cascade, aims_fh_grades_cascade)

 
 %%

 meanscores = zeros(1,4);
 meanscores_vars = zeros(1,4);
 for i = 0:3
     meanscores(i+1) = mean(my_fh_grades(aims_fh_grades ==i));
     meanscores_vars(i+1) = var(my_fh_grades(aims_fh_grades ==i));
 end
 
 figure()
 subplot (1,2,1)
 hold on;
 bar ([0:3], meanscores, 'r');
 h = errorbar([0:3], meanscores, meanscores_vars);
 title ('Binary chunk classification')
 xlabel ('AIMS dyskinesia severity score')
 ylabel ('Dyskinetic chunk percentage')
 set (gca, 'Xtick', [0:3])
set(h, 'LineStyle', 'none');
 

 meanscores = zeros(1,4);
 meanscores_vars = zeros(1,4);
 for i = 0:3
     meanscores(i+1) = mean(my_fh_grades_cascade(aims_fh_grades_cascade ==i));
     meanscores_vars(i+1) = var(my_fh_grades_cascade(aims_fh_grades_cascade ==i));
 end
 
 subplot (1,2,2)
 hold on;
 bar ([0:3], meanscores, 'g');
 h = errorbar([0:3], meanscores, meanscores_vars);
 title ('Trinary chunk classification')
 xlabel ('AIMS dyskinesia severity score')
 ylabel ('Dyskinetic chunk average')
 set (gca, 'Xtick', [0:3])
set(h, 'LineStyle', 'none');
 