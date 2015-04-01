function [diff_phi_all]=MLDS_plot(data)
%MLDS_plot(filename)
%
%plots the error matrix and the results of the simulation at points R and
%S.

[base filename] = fileparts( data.filename);
savepath = [base '/figures/' filename '/'];
mkdir(savepath)
diff_phi = [];
dimen    = [];
tStim    = [];
ShowAndSave(data);
PlotRMSError(0);
PlotRMSError(1);%normalize to per trial

%PlotEstimatedVsRealSigma;
%PlotLikelihood;%actually this one, and PlotRMSError bla bla functions can all be fused
%PlotStimCircle;
    function PlotLikelihood
        %%Plot rms error per trial number
        figure(dimen+50);
        clf
        set(gcf,'position',[1120 784 1102 337]);
        subplot(1,2,1)
        likelihood = log10(squeeze(nanmedian(data.Likelihood,2)));
        %
        imagesc(likelihood );
        %
        set(gca,'ytick',1:length(data.repetitions),'yticklabel',data.repetitions,'xticklabel',data.sigmas);
        ylabel('repetitions');xlabel('sigma');
        colorbar
        title(['log10 median likelihood (dimen = ' mat2str(dimen) ')'])
        
        
        subplot(1,2,2)
        hold on;
        ts = size(tStim,1);
        for ii = 1:ts-1
            c = ii./ts;
            plot(tStim(:,ii),likelihood (:,ii),'o-','color',[c 0 1-c],'linewidth',2);
        end
        legend(strcat({''}, num2str(data.sigmas(:),'%.1f')));legend boxoff
        box off
        xlabel('repetition')
        ylabel('log10 likelihood')
        hold off
        
        %         SaveFigure(sprintf('%s/Likelihood.png' , savepath ));
        
    end

    function PlotEstimatedVsRealSigma
        figure(555);clf;set(gcf,'position',[440 440 850 330])
        sigmas      = repmat(data.sigmas,[length(data.repetitions) 1]);
        sigmas_est  = squeeze(nanmedian(data.Estimate(end,:,:,:),2));
        sigmas_est   = sigmas_est(:)';
        %
        subplot(1,2,1);
        ImageWithText((sigmas_est-sigmas)./sigmas*100,(sigmas_est-sigmas)./sigmas*100);colorbar;
        set(gca,'ytick',1:length(data.repetitions),'yticklabel',data.repetitions,'xticklabel',data.sigmas,'xtick',1:length(data.sigmas));
        axis square
        title('deviation of estimation','interpreter','none')
        %
        subplot(1,2,2);
        ImageWithText( sigmas_est, sigmas_est);%root part
        axis square;
        set(gca,'ytick',1:length(data.repetitions),'yticklabel',data.repetitions,'xticklabel',data.sigmas,'xtick',1:length(data.sigmas));
        colorbar
        title('sigma_est','interpreter','none')
        SaveFigure(sprintf('%s/SigmaError.png' , savepath ));
    end

%%
    function PlotRMSError(pertrial)
        %% PLOT THE RMS ERROR MATRIX
        dimen    = data.input.ModelDimention;
        tStim    = data.tStim(:);
        %[1 trun repetition sigmas];%1 because it is just a scalar
        % average across simulation runs, these are squared differences
        diff_phi = squeeze(sqrt( nanmean(data.diff_phi,2) ));
        if pertrial
            diff_phi = diff_phi./repmat(tStim,1,size(diff_phi,2));
        end
        
        figure(dimen);
        set(gcf,'position',[0 0 1102 337]);
        clf
        hold off
        subplot(1,2,1)
        %%                

        if size(diff_phi,2) == 1
            diff_phi = diff_phi';
        end
        %
        ImageWithText( diff_phi , repmat(tStim,1,size(diff_phi,2)));
        Beautify1;                
        %% PLOT RMS ERROR FOR EACH NOISE PARAMETER SEPARATELY AS A FUNCTION OF REPETITION
        subplot(1,2,2)
        hold on                               
        ts    = length(tStim);
        if dimen == 1
            tStim = repmat(tStim(:),1,size(diff_phi,2));
        end
        ts = length(tStim);
        for ii = 1:ts
            c = ii./ts;
            %errorbar(tStim(:,ii),diff_phi(:,ii),diff_phi_std(:,ii),'color',[c 0 1-c],'linewidth',2);
            plot(tStim(ii),diff_phi(:,ii),'o-','color',[c 0 1-c],'linewidth',2);
        end
        Beautify2;
        %
        SaveFigure(sprintf('%s/SquaredError_PerTrial_%d.png' , savepath,pertrial ));
        function Beautify1
            set(gca,'ytick',1:length(data.repetitions),'yticklabel',data.repetitions,'xticklabel',data.sigmas,'xtick',1:length(data.sigmas));
            ylabel('repetitions');xlabel('sigma');
            colorbar
            title(['median RMS error (dimen = ' mat2str(dimen) ')'])
        end
        function Beautify2
            %axis tight
        hold off
        legend(strcat({''}, num2str(data.sigmas(:),'%.1f')));
        legend boxoff
        box off
        xlabel('repetition');
        ylabel('RMS error');
        end
    end


   


    function PlotStimCircle
        if isfield(data,'stimlist');
            figure(123);
            MLDS_VisualizeStimList(data.stimlist{1,r,s});
            %             SaveFigure(sprintf('%s/StimListCircle.png' , savepath ));
        else
            fprintf('Stimulus data is not saved\n');
        end
    end


    function ShowAndSave(data)
        
        for s = 1:length(data.sigmas);
            for r = 1:length(data.repetitions);
                %% FOR EACH SIGMA AND REPETITION PRODUCE THE ESTIMATED RESULTS
                filename = sprintf('%s/r_%02d_s_%02d.png' , savepath , r , s );
                if 1%exist(filename) == 0;
                    Subject            = data.SubjectModel;
                    Estimate           = data.EstimateAligned;%this excludes the sigma already                    
                    %[parameter,simulation,repetition,sigma];
                    params.sigmas      = data.sigmas;
                    params.repetitions = data.repetitions;                    
                    ndimen             = data.input.ModelDimention;                    
                    %
                    fprintf('s:%02d of %02d, r: %02d of (%02d) \n',r,length(params.repetitions),s,length(params.sigmas));
                    %
                    figure(100);clf
                    subplot(1,2,1)
                    hold off
                    plot(1,1);
                    %% PLOT THE ESTIMATED RESULT FOR EACH SIMULATION
                    for i = 1:size(Estimate,2);
                        %
                        if ndimen == 2
                            
                            X = reshape(Estimate(1:end-1,i,r,s)',ndimen,8);
                            x = X(1,:);
                            y = X(2,:);
                            a = [-1.4 1.4 -1.4 1.4];
                            PlotCircles(x, y, 0.05, 'k', 0.02);
                        elseif ndimen == 1
                            x = 1:8;
                            y = Estimate(1:end,i,r,s)';%sigma entry already excluded
                            %
                            xflip = [x(1:end) fliplr(x(1:end))];
                            yflip = [y fliplr(y)];
                            a = [1 8 -0.5 1.2];
                            patch(xflip,yflip,'k','EdgeAlpha',1/5,'FaceColor','none');
                        end
                        %                        
                    end
                    %% PLOT ALSO THE AVERAGE OF THE ESTIMATIONS
                    hold on
                    plot(x,mean(Estimate(:,:,r,s),2),'m','linewidth',3);
                    %% PLOT THE SUBJECT MODEL                    
                    if ndimen == 2
                        plot(Subject(1:2:size(Subject,1)-1,1,1,1),Subject(2:2:size(Subject,1)-1,1,1,1),'r+','Markersize',20,'MarkerFaceColor','r','Linewidth',2);
                    elseif ndimen == 1
                        plot(x,Subject(1:end-1,1,1,1),'ro-','Markersize',20,'MarkerFaceColor','r','Linewidth',2);
                    end
                    hold off
                    title(['Repet: ' mat2str(params.repetitions(r)) '--- Sigma: ' mat2str(params.sigmas(s))]);
                    axis(a)
                    box off;
                    hold off;
                    %% PLOT THE SIGMA DISTRIBUTION
                    subplot(1,2,2)
                    boxplot(data.Estimate(end,:,r,s));
                    %
                    drawnow;
                    SaveFigure(filename);
                end
            end
        end
        
    end

end
