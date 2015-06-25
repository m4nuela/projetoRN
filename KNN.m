function neighbors = KNN(X, T, k)
    
    % Inicializando uma matrix de distâncias.
    distances = zeros(size(T,1),2);

    % Calcula a distancia de X para todos os vetores de treinamento
    for z = 1:size(T,1)
        Y = T(z,:);
        distance = euclidean(X,Y);
        distances(z,:) = [z,distance];
    end

    %Ordenando pelas distâncias
    distances = sortrows(distances, 2);
    
    % Selecionando os indices dos k vizinhos mais proximos
    if (distances(1,2) == 0)
        neighbors = distances(2:k+1,1);
    else
        neighbors = distances(1:k,1);
    end
    
end

