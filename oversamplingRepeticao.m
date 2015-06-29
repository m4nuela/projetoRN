function [cjtFinal] = oversamplingRepeticao(cjt, N, resto)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
m = size(cjt,1);
n = size(cjt,2);

cjtFinal = zeros (m*N + resto,n);
index = 1;
for i=1:N
    nextIndex = index+m-1;
    cjtFinal(index:nextIndex,:) = cjt;
    index = nextIndex+1;
end

cjtFinal(index,:) = cjt(resto,:);