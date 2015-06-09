function distanciaFinal = distEuclidiana(Aa,Bb)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

n = size(Aa,2);

somatorio = 0;
for i = 1:n-2 %até a antepenultima coluna (penultima e ultima são a classe)
   
    num = Aa(i)-Bb(i);
    somatorio = num + somatorio; 
 
    
end
distanciaFinal = sqrt(somatorio);



end