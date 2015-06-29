function [cjtTreinamento,cjtValidacao] = oversamplingRepeticao(cjtT, cjtV,t,v)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[nLinT,nCol] = size(cjtT);
nLinV = size(cjtV,1);
cjtTreinamento = zeros(t,nCol);
cjtValidacao = zeros(v,nCol); 


%como o conjunto de treinamento é sempre maior o dobro do cjt de validacao passo por
%todo o conjunto de validacao primeiro e depois ajusto o restante do
%treinamento.

zerar=0;
contador =0;
contador2 = 0;


for i=1:v
    contador = contador+1;
    contador2 = contador2+1;
    
    
    if(contador<nLinV)  %copia os valores do conj de validacao para a nova matriz
       cjtValidacao(i,:) = cjtV(contador,:);
       if(contador2<nLinT)
            cjtTreinamento(i,:) = cjtT(contador2,:);
       else %zerar contador2 na proxima iteracao pq contador2 = nLinT
            cjtTreinamento(i,:) = cjtT(contador2,:);
            contador2=0;
       end
      
    else %contador=nLinV
         %zerar o contador para a proxima iteracao pq contador = nLinV
         
         cjtValidacao(i,:) = cjtV(contador,:);
         contador=0;
         if(contador2<nLinT)
            cjtTreinamento(i,:) = cjtT(contador2,:);
         else %zerar contador2 na proxima iteracao pq contador2 = nLinT
            cjtTreinamento(i,:) = cjtT(contador2,:);
            contador2=0;
         
         end
    end

end        
%continua para o restante do treinamento

for j=i+1:t
    contador2 = contador2+1; 
    
     if(contador2<nLinT)  %copia os valores do conj de validacao para a nova matriz
       cjtTreinamento(j,:) = cjtT(contador2,:);
      
      
    else %contador=nLinT
         %zerar o contador para a proxima iteracao
         cjtTreinamento(j,:) = cjtT(contador2,:);      
         contador2=0;
    end
    
    
end