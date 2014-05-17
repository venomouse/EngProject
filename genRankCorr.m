function [gamma] = genRankCorr (x,y )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
a = zeros(length(x));
b = zeros(length(y));

mone = 0;
sum_a_sq = 0;
sum_b_sq = 0;

for i = 1:length(x)
    for j= 1:length(x)
        a(i,j) = sign(x(i) - x(j));
        b(i,j) = sign(y(i) - y(j));
        mone = mone + a(i,j)*b(i,j);
        sum_a_sq = sum_a_sq + a(i,j)^2;
        sum_b_sq = sum_b_sq + b(i,j)^2;
    end
end

gamma = mone / sqrt (sum_a_sq * sum_b_sq);

end

