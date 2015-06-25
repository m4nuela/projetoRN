function centroide = calculaCentroide (padroes)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


[m,n] = size(padroes);
centroide = zeros(1,n);
for j=1:n-2 %as duas ultimas colunas são as classes
    centroide(1,j) = sum(padroes(:,j))/m;
end

%se a utima coluna for 1
achar = padroes(:,end) == 1; %matriz com 1 no exemplo q encontrar
numPadroes1 = sum(achar); %qnt de padrõe da classe que tem 1 como ultima coluna

if numPadroes1>(m/2)  % se o que tem 1 na ultima coluna for maioria
    centroide(1,end-1:end) = [0,1];
else
    centroide(1,end-1:end) = [1,0];
end

