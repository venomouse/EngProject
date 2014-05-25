function [clipVectorMat ] = correctMissingAverage( clipVectorMat )
%CORRECTMISSINGAVERAGE corrects vectors that 

for i = 1:size(clipVectorMat,1)
    jointScores = clipVectorMat(i,:);
    meanScore = mean(jointScores(jointScores > 0));
    for j = 1:size(clipVectorMat,2)
        if (clipVectorMat(i,j) == 0)
            clipVectorMat(i,j) = meanScore;
            if (isnan(meanScore)) 
                clipVectorMat(i,j) = min(clipVectorMat(:,j));
            end
        end
    end
end

end

