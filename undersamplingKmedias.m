function [cjtTreinamento,cjtValidacao] = undersamplingKmedias(cjtT, cjtV,kT,kV)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[mT,nT] = size(cjtT);
[mV,nV] = size(cjtV);

cjtTreinamento = zeros(kT,nT);
cjtValidacao = zeros(kV,nV); 


clustersV = zeros(mV,1);  %qual cluster
clustersT = zeros(mT,1);

contadorT = 0;
contadorV = 0;


ecV = floor(mV/kV); %qtd elementos por cluster Validacao
sobraV = mod(mV,kV);

ecT = floor(mT/kT); %qtd elementos por cluster Treinamento
sobraT = mod(mT,kT);


numCluster = 1;
numClusterT = 1;


          
for i=1:mV %percorre todos os exemplos de validacao
   contadorV = contadorV+1;
   if contadorV <= ecV % se ainda n preencheu o cluster 
      clustersV(i,1) = numCluster;
   else
       numCluster = numCluster+1; % passar pro próximo cluster
       clustersV(i,1) = numCluster;
       contadorV = 1;  % qnt de elementos do novo cluster = 1 
       if (numCluster == kV)
          ecV = ecV + sobraV; % aumento o numero de elementos do ultimo cluster
       end
   end
   
   %ja faço pro treinamento tbm
   contadorT = contadorT+1;
   if contadorT <= ecT % se ainda n preencheu o cluster 
      clustersT(i,1) = numClusterT;
   else
       numClusterT = numClusterT+1; % passar pro próximo cluster
       clustersT(i,1) = numClusterT;
       contadorT = 1;  % qnt de elementos do novo cluster = 1 
   end
   
end



for j=i+1:mT
   contadorT = contadorT+1;
   if contadorT <= ecT % se ainda n preencheu o cluster 
      clustersT(j,1) = numClusterT;
   else
       numClusterT = numClusterT+1; % passar pro próximo cluster
       clustersT(j,1) = numClusterT;
       contadorT = 1;  % qnt de elementos do novo cluster = 1 
       if (numClusterT == kT)
          ecT = ecT + sobraT; % aumento o numero de elementos do ultimo cluster
       end
   end
    
end


%acabou de dividir o conjunto de treinamento e de validacao em clusters.

centroidsV = zeros(kV,nV);
centroidsT = zeros(kT,nT);

%ajustar os clusteres

continuar = 1; 
while continuar
    for i=1:kV %para cada cluster de validacao calcular o seu centroid
        
        achar = clustersV(:,1) == i; %matriz com 1 no exemplo q encontrar
        numPadroes = sum(achar); %qnt de padrõe da classe c 
        padroes = cjtV(achar,:); % todas as linhas dos padroes achados
        
        
        centroide = calculaCentroide(padroes);
        centroidsV(i,:) = centroide;
        
        
        %ja faz pra o treinamento tbm
        achar = clustersT(:,1) == i; %matriz com 1 no exemplo q encontrar
        numPadroes = sum(achar); %qnt de padrõe da classe c 
        padroes = cjtT(achar,:); % todas as linhas dos padroes achados
        
        
        centroide = calculaCentroide(padroes);
        centroidsT(i,:) = centroide;
     
        for j=i+1:kT  % calcula o centroide para o restante dos clusters do treinamento
            achar = clustersT(:,1) == j; %matriz com 1 no exemplo q encontrar
            numPadroes = sum(achar); %qnt de padrõe da classe c 
            padroes = cjtT(achar,:); % todas as linhas dos padroes achados


            centroide = calculaCentroide(padroes);
            centroidsT(j,:) = centroide;
        end
        
    end
    
    
    
    matrizDistV = zeros(kV,2);
    matrizDistT = zeros(kT,2);
    
    for i=1:mV  %verificar distancia de cada exemplo de validacao para cada cluster
        a = cjtV(i,:);
        for j=1:kV
           b = centroidsV(j,:);
           matrizDistV(j,1) = j;
           matrizDistV(j,2) = distEuclidiana(a,b); 
        end
        
        
        matrizDistV = sortrows(matrizDistV,2);
        maisProximo = matrizDistV(1,1);
        atual =clustersV(i);
        
        
        %recalcular centroid dos clusters afetados
        if ~(maisProximo == atual)
            clustersV(i) = maisProximo;
       
            achar = clustersV(:,1) == maisProximo; %matriz com 1 no exemplo q encontrar
            padroes = cjtV(achar,:); % todas as linhas dos padroes achados

            centroide = calculaCentroide(padroes);
            
            centroidsV(maisProximo) = centroide;
            
            
            
            achar = clustersV(:,1) == atual; %matriz com 1 no exemplo q encontrar
            padroes = cjtV(achar,:); % todas as linhas dos padroes achados

            centroide = calculaCentroide(padroes);
            
            centroidsV(atual) = centroide;
            
            
            
        end
       
        disp('haha');
    end
    
   
end

