function MLDS_DesignOptimality(data)
%%
for ns = 1:size(data.stimlist,3)%run over sigma values
    for nrun = 1:length(data.stimlist)%run over simulations
        %get the questions
        q  = data.stimlist{nrun,1,ns};
        tq = size(q,1);
        %prepare the design matrix
        dm = MLDS_Q2DM(q);
        %information matrix
        im                = dm'*dm;
        %im_det(nrun,ns)   = det(inv(im));
        im_trace(nrun,ns) = trace(im);
        e = eig(dm'*dm);
        im_sel(nrun,ns)   = e(end);
        %        
    end
end
%%
diff_phi = squeeze(data.diff_phi);

%plot(log10(im_det(:,1)),diff_phi(:,1),'o')
%plot(im_trace(:,1),diff_phi(:,1),'o')
plot(im_sel(:,1),diff_phi(:,1),'o')
