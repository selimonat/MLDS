%%
ii = 406
stimlist = data.stimlist(:,:,ii);
stimlist = [fliplr(sort(stimlist(:,[1 2]),2)) fliplr(sort(stimlist(:,[3 4]),2))];
[n m] = hist3(double(stimlist(:,[1 2])),{1:8 1:8});
imagesc(n)

%% entropy of the pairs
entropy = [];
error   = mean(reshape([data.delta(1,:,:).phi],10,500));%error of fit
for ii    = 1:500;
    stimlist = data.stimlist(:,:,ii);    
    stimlist = [sort(stimlist(:,[1 2]),2) sort(stimlist(:,[3 4]),2)];
    %
    [n m] = hist3(double([stimlist(:,1:2);stimlist(:,3:4)]),{1:8 1:8});   
    n = n./sum(n(:)) + eps;
    entropy(1,ii) = -sum(log2(n(:)).*n(:));   
end
plot(entropy,error,'o')
corrcoef(entropy,error)
%

%%
entropy = [];
error   = mean(reshape([data.delta(1,:,:).phi],10,500));%error of fit
for ii    = 1:500;
    stimlist = data.stimlist(:,:,ii);
    stimlist = [fliplr(sort(stimlist(:,[1 2]),2)) fliplr(sort(stimlist(:,[3 4]),2))];
    pair1 = sub2ind([8 8],stimlist(:,1),stimlist(:,2));
    pair2 = sub2ind([8 8],stimlist(:,3),stimlist(:,4));

    [n m] = hist3(double(sort([pair1 pair2],2)),{1:56 1:56});

    n = n./sum(n(:)) + eps;
    entropy(1,ii) = -sum(log2(n(:)).*n(:));   
    %entropy(1,ii) = std(n(:));   
    %
end
plot(entropy,error,'o')
corrcoef(entropy,error)