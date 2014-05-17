function [ lowDimData ] = projectToSubspace(data_matrix, vecRetained, meanMatrix)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

lowDimData = vecRetained' * (data_matrix - repmat (meanMatrix, 1, size (data_matrix ,2)));
end

