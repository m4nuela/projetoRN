function [centroids] = undersamplingKmedias(cjt, k)

[m,n] = size(cjt);


%indica qual cluster cada padrão pertence
clusters = zeros(m,1); 


ec = floor(m/k); %qtd elementos por cluster 
sobra = mod(m,k); % qtd de elementos a mais no ultimo cluster

% contador para os clusters
numCluster = 1;


% contador para a quantidade de padrões em cada cluster
contador = 0;

          
for i=1:m %percorre todos os exemplos 
   contador = contador+1;
   if contador <= ec % se ainda n preencheu o cluster 
      clusters(i,1) = numCluster; %Padrão pertencerá aquele cluster
   else
       numCluster = numCluster+1; % passar pro próximo cluster
       clusters(i,1) = numCluster; % Padrão pertencerá ao novo cluster
       contador = 1;  % qnt de elementos do novo cluster = 1 
       if (numCluster == k) % se for o ultimo cluster
          ec = ec + sobra; % aumento o numero de elementos do ultimo cluster
       end
   end
   
end


%acabou de dividir o conjunto de treinamento e de validacao em clusters.
%O próximo passo é calcular os centróides de cada cluster

centroids = zeros(k,n);


for i=1:k %para cada cluster calcular o seu centroide

    achar = clusters(:,1) == i; %matriz com 1 no exemplo q encontrar
    padroes = cjt(achar,:); % todas as linhas dos padroes achados


    centroide = calculaCentroide(padroes);
    centroids(i,:) = centroide;

end
    
    
%todos os centroides foram calculados
%proximo passo é ajustar os clusters

continuar = 1; 
iteracoes = 0;

while continuar
    iteracoes = iteracoes+1;
    alteracoes = 0;   
    matrizDist = zeros(k,2); % 1 coluna = num. cluster ; 2 coluna = distância 
    
    for i=1:m  %verificar distancia de cada exemplo de validacao para cada cluster
        a = cjt(i,:);
        for j=1:k
           b = centroids(j,:);
           matrizDist(j,1) = j;  %qual cluster
           matrizDist(j,2) = distEuclidiana(a,b);  %distancia
        end
        
        %calculou a distancia do exemplo paratodos os cluster
        %proximo passo é pegar o cluster com menor distância para o padrão.
        
        matrizDist = sortrows(matrizDist,2);
        maisProximo = matrizDist(1,1);
        atual = clusters(i);
        
        
        %recalcular centroid dos clusters afetados
        if ~(maisProximo == atual)
            alteracoes = alteracoes +1;
            clusters(i) = maisProximo;
       
            achar = clusters(:,1) == maisProximo; %matriz com 1 no exemplo q encontrar
            padroes = cjt(achar,:); % todas as linhas dos padroes achados

            centroide = calculaCentroide(padroes);
            
            centroids(maisProximo,:) = centroide;
            
            
            
            achar = clusters(:,1) == atual; %matriz com 1 no exemplo q encontrar
            padroes = cjt(achar,:); % todas as linhas dos padroes achados

            centroide = calculaCentroide(padroes);
            
            centroids(atual,:) = centroide;          
        end
    end
    
    fprintf('Alteracoes : %d \n',alteracoes);
    if ((alteracoes <450) || (iteracoes>9))
        continuar = 0;
    end
end

   
disp('terminou ajuste');


% pegar o centroide de cada cluster para ser um padrão

    
end




