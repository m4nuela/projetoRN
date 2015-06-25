function overSamples = SMOTE(Samples, N)
    Synthetic = [];
    Labels = Samples(:,end-1:end);
    Samples = Samples(:,1:end-2);
    
    k = 5;
    
    %Neighbors = zeros(size(Samples,1),5);
    
    for i = 1:size(Samples,1)
        Neighbors = KNN(Samples(i,:), Samples, k);
        
        for n = 1:N
            nn = mod(round(10*rand(1)),k)+1;
            diff = Samples(Neighbors(nn)) - Samples(i,:);
            gap = rand(1,size(Samples,2));
            Synthetic = [Synthetic; [(Samples(i,:) + times(gap,diff)), Labels(i,:)]];
        end
    end
    
    overSamples = [[Samples,Labels];Synthetic];
        
end