function centroide = calculaCentroide (padroes)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


[m,n] = size(padroes);
centroide = zeros(1,n);
for j=1:n
    centroide(1,j) = sum(padroes(:,j))/m;
end

