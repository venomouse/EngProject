function [ average_speed ] = jointSpeed( chainTable )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

movLengthThresh = 0.001;
indices = find(chainTable(:,5) > movLengthThresh);
movements = chainTable(indices,:);

if (isempty(movements))
    average_speed = 0;
else
    average_speed = mean (movements(:,5)./(movements(:,4)*0.03));
end

end

