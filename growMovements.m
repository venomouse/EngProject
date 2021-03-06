function [chainLengths, chainDistances, chainNumbers, chainTable, vectorLengths] = growMovements(data, jumpIndex)
%GROWMOVEMENTS This function aims to find sequences of consistent movements
% in a joint recording 

if (nargin < 2)
    jumpIndex = zeros(size(data,1));
end

jumpIndex = jumpIndex(2:end);
numPoints = size (data,1);
angleThreshold = 100;
historyLength = 8;


motionVectors = data(2:end,:) - data(1:end-1,:);
vectorLengths =  sqrt(sum(motionVectors.^2,2));

angle = @(x,y) acosd(x*y'/(norm(x,2)*norm(y,2)));

chainTable = zeros(0,5);
chainLengths = zeros (1, numPoints-1);
chainDistances = zeros (1, numPoints -1);
chainNumbers = zeros (1,numPoints); 

if (length(vectorLengths) < 1)
    return;
end


chainLengths(1) = 1; 
chainDistances(1) = vectorLengths(1);
chainNumbers(1) = 1;
chainNumbers(2) = 1;



currChainStart = 1;
currChainNum = 1;
currChainDistance = vectorLengths(1);
currChainLength = 1; 

for i = 2:numPoints - 1
    
    currVec = motionVectors(i,:);
    historyStart = max(currChainStart, i - historyLength);
    if (jumpIndex(i) == 1 || i == numPoints - 1)
        chainTable = [chainTable; currChainNum, currChainStart, i-1, currChainLength, currChainDistance];
        currChainStart = i;
        currChainLength = 0;
        chainLengths(i) = currChainLength;
        currChainNum = currChainNum+1;
        currChainDistance = 0;
        chainDistances(i) = currChainDistance;
        chainNumbers(i+1) = 0;
        continue;
    end
    
    
    %     if (jumpIndex(i) ==0)
%         if (jumpIndex(i-1) ==1)
%             %start new chain
%             currChainStart = i;
%             currChainLength = 0;
%             currChainNum = currChainNum+1;
%             currChainDistance = 0;
%             continue;
%         end
%     else
%         chainLengths(i) = 0;
%         chainDistances(i) = 0;
%         chainNumbers(i) = 0;
%         if (jumpIndex(i-1) == 0)
%                 %add the current chain to the table
%                 chainTable = [chainTable; currChainNum, currChainStart, i-1, currChainLength, currChainDistance];
%                 continue;
%         else 
%            continue;
%         end
%     end
    for j = historyStart:i-1
        theta = angle (currVec, motionVectors(j,:));
        if ( theta < angleThreshold)
            continue;
        else
            chainTable = [chainTable; currChainNum, currChainStart, i-1, currChainLength, currChainDistance];
            currChainStart = i;
            currChainLength = 0;
            currChainNum = currChainNum+1;
            currChainDistance = 0;
            break;
        end
    end
    currChainLength = currChainLength +1;
    chainLengths(i) = currChainLength;
    currChainDistance = currChainDistance + vectorLengths(i);
    chainDistances(i) = currChainDistance;
    chainNumbers(i+1) = currChainNum;    
end

minChainForCat = 10;
sumDistances = sum(vectorLengths);

%concatenating chanes separated by noise
% i = 2;
% numChains = max(chainNumbers);
% while i < numChains-1
%     if (chainTable(i-1,4) > minChainForCat && ...
%         chainTable(i+1,4) > minChainForCat)
%     maxNoiseForCat = min(chainTable(i-1,4),chainTable(i+1,4))/3;
%       if (chainTable(i,4) <= maxNoiseForCat)
%         historyStart = max(chainTable(i-1,2), chainTable(i-1,3) - historyLength);
%         toConcat = checkVectorFitting(motionVectors(chainTable(i+1,2),:), ...
%                                   motionVectors, historyStart, chainTable(i-1,3), ...
%                                   angleThreshold);
%          if (toConcat)
%              chainNumbers(chainTable(i,2):chainTable(i:3)) = i-1;
%              chainNumbers(chainTable(i+1,2):chainTable(i+1:3)) = i-1;
%              for j = chainTable(i,2)+1:chainTable(i+1:3)
%                 chainLengths(j) = chainLengths(j-1) +1;
%                 chainDistances(j) = chainDistances(j-1) + vectorLengths(j);
%              end
%              
%              chainTable(i-1,:) = 0;
%              chainTable(i,:) = 0;
%          end
%       
%          i = i+1;
%       end
%     end
%     i = i+1;
% end
% 
% %cleaning up the chain table
% ind = find(chainTable(:,1) ==0);
% chainTable(ind,:) = [];

end

    
    function toConcat = checkVectorFitting (checkVec, motionVecArr, startIndex, endIndex, threshold)
        angle = @(x,y) acosd(x*y'/(norm(x,2)*norm(y,2)));
        angleThreshold = 90;
        
        for j = startIndex:endIndex
            theta = angle(checkVec, motionVecArr(j,:));
            if (theta < angleThreshold)
                continue;
            else
                toConcat = false;
                return;
            end
        end
        toConcat = true;
    end
    


