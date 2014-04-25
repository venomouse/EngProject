function [data_lowerDim] = pcaAnalysis(data_matrix, num_retain)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

[covMat, eigVecCov, eigValCov] = covMatrix (data_matrix);
eigVals = diag (eigValCov);
[sortedEig, index] = sort (eigVals);

vecRetained = eigVecCov (:, index (end - num_retain+1:end));

data_lowerDim = vecRetained' * (data_matrix - repmat (mean (data_matrix,2), 1, size (data_matrix ,2)));

end

