function [diff_phi,diff_sig,EstimateAligned]=MLDS_ComputeDiff(model,Estimate)
%[diff_phi,diff_sig,EstimateAligned]=MLDS_ComputeDiff(model,Estimate)
%
%   Computes the difference between estimation and perceptual model after
%   alignement (1D: scaling, 2D, procrustes);


%
paramperdimen     = 8;%the first point is located somewhere arbitrary, doesnt needt to float, can be fixed and it is fixed.
ModelDimen        = length(model(1:end-1))./paramperdimen;
%
plotting = 0;
%
%plot the thing
if ModelDimen == 1;
    %Alignment
    Estimate        = Estimate(1:end-1)./max(Estimate(1:end-1));
    %measure the diff
    %in the model ignore the first entry and last entry
    diff_phi = mean( (Estimate(1:end-1) - model(2:end-1)).^2 );
    diff_sig = (Estimate(end) - model(end)).^2;
    %
    if plotting
        figure(3);
        plot([0;Estimate],'ko');%
        hold on
        plot(model,'r-')
        hold off
        box off;
        drawnow;
    end
    
elseif ModelDimen == 2
    sig             = Estimate(end);
    diff_sig        = (sig - model(end)).^2;
    
    Estimate(end)   = [];
    Estimate        = reshape(Estimate,2,8);
    model           = reshape(model(1:end-1),2,8);
    %alignment
    [d z]           = procrustes(model',Estimate');
    z               = z';
    %sum of the distances after alignemnt
    diff_phi        = mean(sqrt(sum((model - z).^2)));
    
    Estimate        = z(:);%will be output
    Estimate        = [Estimate;sig];
    
    if plotting
        %
        figure(3);
        plot(z(1,:),z(2,:),'o-');%this is the fit data
        hold on
        plot(model(1,:),model(2,:),'ro-');%this is the original data
        hold off
        box off;
        drawnow
    end
end
EstimateAligned = Estimate;
