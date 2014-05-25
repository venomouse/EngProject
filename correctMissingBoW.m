function [ clipVectorMat ] = correctMissingBoW( clipVectorMat )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

for i = 1:size(clipVectorMat,1)
    jointScores = clipVectorMat(i,:);
    meanScore = mean(jointScores(~isnan(jointScores)));
    for j = 1:size(clipVectorMat,2)
        if (isnan(clipVectorMat(i,j)))
            if (j==1)
                clipVectorMat(i,j) = meanScore;
                if (isnan(meanScore))
                    clipVectorMat(i,j) = min(clipVectorMat(:,j));
                end
            else
                clipVectorMat(i,j) = clipVectorMat(i,j-1);
            end
            
        end
    end
end



end

