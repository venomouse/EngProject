function [svmStruct, eigVectors, meanMatrix] = trainClassifier_customFcn(dyskinetic_clip_list, normal_clip_list, sampleLength, overlapLength, vectorFcn, pca, num_retain)

% sampleLength = 50;
% overlapLength = 25;

%combine the clip list
vars = who;

[dyskinetic_matrix, dyskinetic_clipMat, dyskinetic_clipIndex] = generateVectorMatrixFromClipList(dyskinetic_clip_list,vectorFcn, sampleLength,overlapLength);
[normal_matrix, normal_clipMat, normal_clipIndex] = generateVectorMatrixFromClipList(normal_clip_list, vectorFcn, sampleLength,overlapLength);

if (pca)
    [all_lowerDim, eigVectors, meanMatrix] = pcaAnalysis([dyskinetic_matrix, normal_matrix], num_retain);
    dyskinetic_lowerDim = all_lowerDim(:, 1:size(dyskinetic_matrix,2));
    normal_lowerDim = all_lowerDim(:, size(dyskinetic_matrix,2)+1:end);
else
    all_lowerDim = [dyskinetic_matrix, normal_matrix];
    dyskinetic_lowerDim = dyskinetic_matrix;
    normal_lowerDim = normal_matrix;
    eigVectors = 0;
    meanMatrix = 0;
end
    
if (pca)
    figure()
    hold on;
    scatter3(dyskinetic_lowerDim(1,:), dyskinetic_lowerDim(2,:), dyskinetic_lowerDim(3,:),35, 'b', 'fill');
    scatter3(normal_lowerDim(1,:), normal_lowerDim(2,:), normal_lowerDim(3,:), 35,'g', 'fill' );
    hold off
end

labels = zeros(size(all_lowerDim,2),1);
labels(1:size(dyskinetic_matrix,2)) = 1;
labels(size(dyskinetic_matrix,2)+1:end) = -1;

svmStruct = svmtrain(all_lowerDim', labels, 'kernel_function', 'rbf');

