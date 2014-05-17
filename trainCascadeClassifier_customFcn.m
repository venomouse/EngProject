function [svmStruct, dyskinetic_svmStruct,  eigVectors, meanMatrix] = trainCascadeClassifier_customFcn(strong_dyskinetic_clip_list, weak_dyskinetic_clip_list, normal_clip_list, sampleLength, overlapLength, vectorFcn, pca, num_retain)
dyskinetic_clip_list = [strong_dyskinetic_clip_list, weak_dyskinetic_clip_list];

[strong_dyskinetic_matrix, ~, ~] = generateVectorMatrixFromClipList(strong_dyskinetic_clip_list,vectorFcn, sampleLength,overlapLength);
[weak_dyskinetic_matrix, ~, ~] = generateVectorMatrixFromClipList(weak_dyskinetic_clip_list,vectorFcn, sampleLength,overlapLength);
[normal_matrix, ~, ~] = generateVectorMatrixFromClipList(normal_clip_list, vectorFcn, sampleLength,overlapLength);

dyskinetic_matrix = [strong_dyskinetic_matrix, weak_dyskinetic_matrix];

if (pca)
    [all_lowerDim, eigVectors, meanMatrix] = pcaAnalysis([dyskinetic_matrix, normal_matrix], num_retain);
    dyskinetic_lowerDim = all_lowerDim(:, 1:size(dyskinetic_matrix,2));
    normal_lowerDim = all_lowerDim(:, size(dyskinetic_matrix,2)+1:end);
    strong_dyskinetic_lowerDim = dyskinetic_lowerDim(:, 1:size(strong_dyskinetic_matrix,2));
    weak_dyskinetic_lowerDim = dyskinetic_lowerDim(:, size(strong_dyskinetic_matrix,2)+1:end);
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
    scatter3(strong_dyskinetic_lowerDim(1,:), strong_dyskinetic_lowerDim(2,:), strong_dyskinetic_lowerDim(3,:),35, 'r', 'fill');
    scatter3(weak_dyskinetic_lowerDim(1,:), weak_dyskinetic_lowerDim(2,:), weak_dyskinetic_lowerDim(3,:),35, 'b', 'fill');
    scatter3(normal_lowerDim(1,:), normal_lowerDim(2,:), normal_lowerDim(3,:), 35,'g', 'fill' );
    hold off
end

%training the general classifier
labels = zeros(size(all_lowerDim,2),1);
labels(1:size(dyskinetic_matrix,2)) = 1;
labels(size(dyskinetic_matrix,2)+1:end) = -1;

svmStruct = svmtrain(all_lowerDim', labels, 'kernel_function', 'rbf');

%training the dyskinetic classifier
dyskinetic_labels = zeros (size(dyskinetic_lowerDim,2),1);
dyskinetic_labels(1:size(strong_dyskinetic_matrix,2)) = 2;
dyskinetic_labels(size(strong_dyskinetic_matrix,2)+1:end) = 1;

dyskinetic_svmStruct = svmtrain(dyskinetic_lowerDim', dyskinetic_labels, 'kernel_function', 'rbf');

