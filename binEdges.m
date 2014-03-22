function [ bin_edges ] = binEdges(bin_centers )
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here

for i = 1:length(bin_centers)-1
    bin_edges(i+1) = (bin_centers(i)+bin_centers(i+1))/2;
end

bin_edges(1) = 0.005;
bin_edges(i+2) = 0.12;
end

