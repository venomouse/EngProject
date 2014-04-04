function [ covData, EigVecCov, EigValCov ] = covMatrix ( data )
% Receives a data  dimXnumPoints matrix, where dim is the data dimension
% and numPoints is the number of measurements
% Returns is covariance matrix, its eigenvectors and eigenvalues

dim = size (data,1);
numPoints = size (data, 2);

meanData = mean (data, 2);
covData = cov ((data - repmat (meanData, 1, numPoints))');

[EigVecCov, EigValCov] = eig (covData);

end

