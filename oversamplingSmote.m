function overSamples = oversamplingSmote(Samples, N, resto)
	% Novos exemplos a serem criados
    Synthetic = [];
    
    % Separando a classe dos padroes
    Labels = Samples(:,end-1:end);
    Samples = Samples(:,1:end-2);
    
    % Neste caso, queremos um aumento de (N*100)%
    k=10;
    
    for i = 1:size(Samples,1)

        if i <= resto
            p = N+1;
        else
            p = N;
        end
        % K vizinhos mais proximos do exemplo atual

        Neighbors = KNN(Samples(i,:), Samples, k);
        
        for n = 1:p
            nn = mod(round(10*rand(1)),k)+1;
            diff = Samples(Neighbors(nn),:) - Samples(i,:);
            gap = rand(1,size(Samples,2));
            Synthetic = [Synthetic; [(Samples(i,:) + times(gap,diff)), Labels(i,:)]];
        end
    end
    
    overSamples = [[Samples,Labels];Synthetic];
end

