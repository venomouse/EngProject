[new_FPR, new_TPR] = ROC (new_grades, new_labels);

means = zeros(1,2);
vars = zeros(1,2);

means(1) = mean(new_grades(new_labels ==1));
means(2) =  mean(new_grades(new_labels ==0));

vars(1) = var(new_grades(new_labels ==1));
vars(2) =  var(new_grades(new_labels ==0));

vars = sqrt(vars);
figure();
subplot(1,2,1)
plot(new_FPR,new_TPR, 'b--.')
xlabel ('False Positive Ratio');
ylabel ('True Positive Ratio');
title ('(a)')
subplot(1,2,2)
hold on
bar([1],means(1), 'r');
bar([2],means(2), 'b');
h = errorbar ([1,2], means, vars);
set(h, 'LineStyle', 'none')
set(h,'Color', 'k');
set(h, 'LineWidth', 2)
title('(b)')


ticks = {'Dyskinetic recordings', 'Non-Dyskinetic recordings'}
set(gca,'Xtick', [1,2]);
set(gca, 'XTickLabel', ticks);


grades_ranks = [3 1 11 14 16 1 1 10 4 6 5 7 9 1 12 17 15 2 13 8 1];