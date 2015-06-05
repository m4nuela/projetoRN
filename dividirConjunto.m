function [cjtTreinamento, cjtTeste, cjtValidacao] = dividirConjunto(padroes)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

     separarSet = size(padroes,1) * 0.5; % 50% da base de dados
     cjtTreinamento = padroes(1:floor(separarSet),:);   % 50% para treinamento
     if(abs(separarSet)==separarSet)
        restante = padroes(ceil(separarSet)+1:end,:);
     else
         restante = padroes(ceil(separarSet):end,:);
     end
     
     separarSet = size(restante,1)* 0.5; % 50% dos 50% 
     
         
     cjtTeste = restante(1:floor(separarSet),:);   % 25% para teste
     if(abs(restante)==restante)
        cjtValidacao = restante(ceil(separarSet)+1:end,:);  % 25% para validação
     else
         cjtValidacao = restante(ceil(separarSet):end,:);  % 25% para validação
     end

end

