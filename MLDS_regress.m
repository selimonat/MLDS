%%
nrep  = 1;
ns    = 1;
beta=  [];
% figure(1);clf;hold on;
for ns = 1%:size(data.stimlist,3)%run over sigma values
    d = [];
    error = [];
    beta= [];
    for nrun = 1:length(data.stimlist)%run over simulations
        %get the questions
        q  = data.stimlist{nrun,nrep,ns};
        r  = data.responses{nrun,nrep,ns};
        tq = size(q,1);
        %prepare the design matrix
        dm = MLDS_Q2DM(q);
        %
        beta_int      = dm(:,2:8)\r(:);
        beta(:,nrun)  = [0 ; cumsum(beta_int(:))];
        beta(:,nrun)  = zscore(beta(:,nrun));
        error(:,nrun) = sqrt(mean((beta(:,nrun) - zscore(data.SubjectModel(1:8,nrun,nrep,ns))).^2));
        %v             = eig(dm'*dm);
        %d(nrun)       = max(v)-min(v);
        d(nrun)       = trace(dm'*dm);
        
    end    
    plot(d,error,'o','color',rand(1,3))
    corrcoef(d,error)
end
