function [scores, amounts ] = scoreClipsByBits(clipIndex, labels)
%SCORECLIPSBYBITS Summary of this function goes here
%   Detailed explanation goes here

assert (size(clipIndex, 1) == length(labels));
numClips = max(clipIndex(:,1));

scores = zeros(1, numClips);
amounts = zeros(2, numClips);

for i = 1:numClips
    ind = find(clipIndex(:,1) == i);
    scores(i) = nnz(labels(ind) == 1)/length(ind);
    amounts(1,i) = nnz(labels(ind) == 1);
    amounts(2,i) = length(ind);
end

end

