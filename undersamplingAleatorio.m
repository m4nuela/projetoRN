function [cjtTreinamento,cjtValidacao] = undersamplingAleatorio (cjtT, cjtV,t,v)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

cjtTreinamento = cjtT(1:t,:);
cjtValidacao = cjtV(1:v,:); 

end

