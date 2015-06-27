function overSamples = oversamplingSmote(Samples, N, resto)
	% Novos exemplos a serem criados
    Synthetic = [];
    
    % Separando a classe dos padroes
    Labels = Samples(:,end-1:end);
    Samples = Samples(:,1:end-2);
    
    % Neste caso, queremos um aumento de (N*100)%
    
    % Para cada exemplo, gerar N sintéticos
    for i = 1:size(Samples,1)
        if i <= resto
            k = N+1;
        else
            k = N;
        end
        % K vizinhos mais proximos do exemplo atual
        Neighbors = KNN(Samples(i,:), Samples, k);
        
        % Aleatorizando a ordem de escolha destes k vizinhos
        indexes = randperm(k);
        
        for n = 1:N
            % Vizinho escolhido
            nn = indexes(n);
            
            % Criação do novo exemplo, como vetor entre o padrão atual e
            % vizinho mais próximo escolhido
            diff = Samples(Neighbors(nn)) - Samples(i,:);
            gap = rand(1,size(Samples,2));
            new_synthetic = Samples(i,:) + times(gap,diff);
            
            % Adiciona o novo padrão ao conjunto, com a msma classe do
            % original
            Synthetic = [Synthetic; [new_synthetic, Labels(i,:)]];
        end
    end
    
    % Unindo o conjunto original e o novo
    overSamples = [[Samples,Labels] ; Synthetic];
end

