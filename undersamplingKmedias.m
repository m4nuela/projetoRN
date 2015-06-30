function [centroidsT,centroidsV] = undersamplingKmedias(cjtT, cjtV,kT,kV)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[mT,nT] = size(cjtT);
[mV,nV] = size(cjtV);


%indica qual cluster cada padrão pertence
clustersV = zeros(mV,1); 
clustersT = zeros(mT,1);


ecV = floor(mV/kV); %qtd elementos por cluster Validacao
sobraV = mod(mV,kV); % qtd de elementos a mais no ultimo cluster de Validacao

ecT = floor(mT/kT); %qtd elementos por cluster Treinamento
sobraT = mod(mT,kT); % qtd de elementos a mais no ultimo cluster de Treinamento


% contador para os clusters
numCluster = 1;
numClusterT = 1;

% contador para a quantidade de padrões em cada cluster
contadorT = 0;
contadorV = 0;

          
for i=1:mV %percorre todos os exemplos de validacao
   contadorV = contadorV+1;
   if contadorV <= ecV % se ainda n preencheu o cluster 
      clustersV(i,1) = numCluster; %Padrão pertencerá aquele cluster
   else
       numCluster = numCluster+1; % passar pro próximo cluster
       clustersV(i,1) = numCluster; % Padrão pertencerá ao novo cluster
       contadorV = 1;  % qnt de elementos do novo cluster = 1 
       if (numCluster == kV) % se for o ultimo cluster
          ecV = ecV + sobraV; % aumento o numero de elementos do ultimo cluster
       end
   end
   
   %ja faço pro treinamento tbm
   contadorT = contadorT+1;
   if contadorT <= ecT % se ainda n preencheu o cluster 
      clustersT(i,1) = numClusterT; %Padrão pertencerá aquele cluster
   else
       numClusterT = numClusterT+1; % passar pro próximo cluster
       clustersT(i,1) = numClusterT; %padrão pertencerá ao novo cluster
       contadorT = 1;  % qnt de elementos do novo cluster = 1 
   end
   
end


%Faz para o restante dos exemplos de treinamento
for j=i+1:mT
   contadorT = contadorT+1;
   if contadorT <= ecT % se ainda n preencheu o cluster 
      clustersT(j,1) = numClusterT; %padrão é adicionado ao cluster
   else
       numClusterT = numClusterT+1; % passar pro próximo cluster
       clustersT(j,1) = numClusterT; %padrão pertence ao novo cluster
       contadorT = 1;  % qnt de elementos do novo cluster = 1 
       if (numClusterT == kT) % se for o ultimo cluster
          ecT = ecT + sobraT; % aumento o numero de elementos do ultimo cluster
       end
   end
    
end


%acabou de dividir o conjunto de treinamento e de validacao em clusters.
%O próximo passo é calcular os centróides de cada cluster

centroidsV = zeros(kV,nV);
centroidsT = zeros(kT,nT);


for i=1:kV %para cada cluster de validacao calcular o seu centroide

    achar = clustersV(:,1) == i; %matriz com 1 no exemplo q encontrar
    padroes = cjtV(achar,:); % todas as linhas dos padroes achados


    centroide = calculaCentroide(padroes);
    centroidsV(i,:) = centroide;


    %ja faz pra o treinamento tbm
    achar = clustersT(:,1) == i; %matriz com 1 no exemplo q encontrar
    padroes = cjtT(achar,:); % todas as linhas dos padroes achados


    centroide = calculaCentroide(padroes);
    centroidsT(i,:) = centroide;

end

for j=i+1:kT  % calcula o centroide para o restante dos clusters do treinamento
    achar = clustersT(:,1) == j; %matriz com 1 no exemplo q encontrar
    padroes = cjtT(achar,:); % todas as linhas dos padroes achados


    centroide = calculaCentroide(padroes);
    centroidsT(j,:) = centroide;
end
    
    
%todos os centroides foram calculados
%proximo passo é ajustar os clusters

continuar = 1; 
iteracoes = 0;

while continuar
    iteracoes = iteracoes+1;
    alteracoes = 0;   
    matrizDistV = zeros(kV,2); % 1 coluna = num. cluster ; 2 coluna = distância 
    
    for i=1:mV  %verificar distancia de cada exemplo de validacao para cada cluster
        a = cjtV(i,:);
        for j=1:kV
           b = centroidsV(j,:);
           matrizDistV(j,1) = j;  %qual cluster
           matrizDistV(j,2) = distEuclidiana(a,b);  %distancia
        end
        
        %calculou a distancia do exemplo paratodos os cluster
        %proximo passo é pegar o cluster com menor distância para o padrão.
        
        matrizDistV = sortrows(matrizDistV,2);
        maisProximo = matrizDistV(1,1);
        atual = clustersV(i);
        
        
        %recalcular centroid dos clusters afetados
        if ~(maisProximo == atual)
            alteracoes = alteracoes +1;
            clustersV(i) = maisProximo;
       
            achar = clustersV(:,1) == maisProximo; %matriz com 1 no exemplo q encontrar
            padroes = cjtV(achar,:); % todas as linhas dos padroes achados

            centroide = calculaCentroide(padroes);
            
            centroidsV(maisProximo,:) = centroide;
            
            
            
            achar = clustersV(:,1) == atual; %matriz com 1 no exemplo q encontrar
            padroes = cjtV(achar,:); % todas as linhas dos padroes achados

            centroide = calculaCentroide(padroes);
            
            centroidsV(atual,:) = centroide;          
        end
    end
    
    fprintf('Validacao : %d \n',alteracoes);
    if ((alteracoes <350) || (iteracoes>9))
        continuar = 0;
    end
end

   
disp('terminou ajuste validacao');
    
    
%Fazer para o treinamento
    
continuar = 1; 
iteracoes = 0;

while continuar
    iteracoes = iteracoes+1;
    alteracoes = 0;   
    matrizDistT = zeros(kT,2); % 1 coluna = num. cluster ; 2 coluna = distância 
    for r=1:mT
         a = cjtT(r,:);
        for j=1:kT
           b = centroidsT(j,:);
           matrizDistT(j,1) = j;  %qual cluster
           matrizDistT(j,2) = distEuclidiana(a,b);  %distancia
        end
        
        %calculou a distancia do exemplo para todos os cluster
        %proximo passo é pegar o cluster com menor distância para o padrão.
        
        matrizDistT = sortrows(matrizDistT,2);
        maisProximo = matrizDistT(1,1);
        atual = clustersT(r);
        
        
        %recalcular centroid dos clusters afetados
        if ~(maisProximo == atual)
            alteracoes = alteracoes+1;
            clustersT(r) = maisProximo;
       
            achar = clustersT(:,1) == maisProximo; %matriz com 1 no exemplo q encontrar
            padroes = cjtT(achar,:); % todas as linhas dos padroes achados

            centroide = calculaCentroide(padroes);
            
            centroidsT(maisProximo,:) = centroide;
            
            
            
            achar = clustersT(:,1) == atual; %matriz com 1 no exemplo q encontrar
            padroes = cjtT(achar,:); % todas as linhas dos padroes achados

            centroide = calculaCentroide(padroes);
            
            centroidsT(atual,:) = centroide;
                       
        end
        
    end
    
    
    fprintf('Treinamento : %d \n',alteracoes);
    if ((alteracoes < 350) || (iteracoes>15))
       continuar = 0; 
    end
    
end


disp('Terminou o ajuste do treinamento');

% pegar o centroide de cada cluster para ser um padrão

end


