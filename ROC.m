function [FPR, TPR ] = ROC(grades, true_labels)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

range = 0:0.01:1;

TPR = zeros(size(range));
labels = zeros(size(true_labels));

for i = 1:length(range)
    tau = range(i);
    labels = grades >= tau;
    TP = size(find(labels == 1 & true_labels ==1 ));
    TN = size(find(labels == 0 & true_labels ==0));
    FP = size(find(labels == 1 & true_labels ==0));
    FN = size(find(labels == 0 & true_labels ==1));
    
    FPR(i) = FP /(FP + TN);
    TPR(i) = TP /(TP + FN);
end



end

