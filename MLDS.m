function [data] = MLDS(trun,sigmas,repetitions,ModelDimension,ModelShape,StimListType,MaxIntervalSize,Percentage)
%[SubjectModel,Estimate,delta,parameter] = MLDS(ModelDimension,...
%
%data.SubjectModel
%data.Estimate
%data.delta ==> differences 
%type ==> 'random' OR 'power'
%
%
%See MLDS_BlackBoard for how to run this function


% % matlabpool local 2;

data.input.ModelDimention  = ModelDimension;
data.input.ModelShape      = ModelShape;
data.input.StimListType    = StimListType;
data.input.MaxIntervalSize = MaxIntervalSize;
data.input.Percentage      = Percentage;
%
t_sigmas      = length(sigmas);
t_repetitions = length(repetitions);
%
SubjectDimension = ModelDimension;
%
for r_i = 1:t_repetitions;%how many times the circle is repeated.    
    for s_i  = 1:t_sigmas;%subject's noise;
        for nrun = 1:trun;
            %
            fprintf('Run %d of %d, sigma %d of %d and repetition %d of %d\n',nrun,trun,s_i,t_sigmas,r_i,t_repetitions)
            %            
            %Get stimulus pairs for the quadruple experiment, this needs to
            %be a cell because the size changes with repetition
            stimlist{nrun,r_i,s_i}            = MLDS_GetStimlist(StimListType,repetitions(r_i),MaxIntervalSize,Percentage);
            %            
            %
            %Simulate observer
            phi                               = MLDS_CreateSubject(SubjectDimension,ModelShape);%phi is a MODELDIMENSION x 8 matrix
            %
            %Get the responses
            responses{nrun,r_i,s_i}           = MLDS_GetResponses(stimlist{nrun,r_i,s_i}, phi, sigmas(s_i));
            SubjectModel(:,nrun,r_i,s_i)      = [phi(:) ; sigmas(s_i)];
            tStim(r_i)                        = length(stimlist{nrun,r_i,s_i});
            %
            %MODEL is a column vector with the last entry being the stdd of
            %the decision noise.
            [Estimate(:,nrun,r_i,s_i) ExitFlag(:,nrun,r_i,s_i)]     = ...
                MLDS_MLE( stimlist{nrun,r_i,s_i}, responses{nrun,r_i,s_i} , ModelDimension);
            
            [diff_phi(:,nrun,r_i,s_i) diff_sig(:,nrun,r_i,s_i) EstimateAligned(:,nrun,r_i,s_i)]       = ...
                MLDS_ComputeDiff(SubjectModel(:,nrun,r_i,s_i),Estimate(:,nrun,r_i,s_i));
            
        end
    end
end

%
data.stimlist        = stimlist;
data.responses       = responses;
data.trun            = trun;
data.sigmas          = sigmas;
data.repetitions     = repetitions;
data.SubjectModel    = SubjectModel;
data.Estimate        = Estimate;
data.EstimateAligned = EstimateAligned;
data.ExitFlag        = ExitFlag;
data.diff_sig        = diff_sig;
data.diff_phi        = diff_phi;
data.tStim           = tStim;
data.filename        = sprintf('~/Documents/LabComputer/onat/MLDS/%s_%d_%s_%d_%g_%g.mat',mfilename,ModelDimension,ModelShape,StimListType,MaxIntervalSize,Percentage);

save(data.filename,'data');

% try
% matlabpool close;
% end
%%
% % %% real data
% % f = ListFiles('/home/onat/Documents/Experiments/Triads_LimitedTime/data/2012*');
% % %%% MLE 1 or 2 ModelDimensional starting points

% % R = [];
% % StimList = [];
% % ns = 9;
% % load(['/home/onat/Documents/Experiments/Triads_LimitedTime/data/' f{ns}]);
% % Response.SequenceSorted = sort(Response.Sequence')';
% % %find the middle stimulus
% % for i =1:size(Response.Green,1)
% % 	mid(i) = intersect( Response.Green(i,:), Response.Red(i,:) );
% % end
% % mid = mid(:);
% % %find how much we need to circshift to place it to the middle
% % [y x] = find(Response.Sequence == repmat(mid(:),1,3));
% %
% % %Align the stimulus order...
% % for i =1:size(Response.Green, 1);
% % 	Response.SequenceAligned(y(i),:) = circshift(Response.Sequence(y(i),:),[0 2-x(i)]);
% % end
% % %get the responses
% % [y x] = find(Response.SequenceAligned == repmat(Response.Red(Response.Red ~= repmat(mid,1,2)),1,3));
% % for t = 1:size(Response.Sequence,1)
% % 	R(t) = find(Response.SequenceAligned(t,:) == Response.Red(t,Response.Red(t,:) ~= mid(t)) ) < 2;
% % end
% % StimList = Response.SequenceAligned;
% % %group the trials
% % [StimListG RG dummy] = PAL_MLDS_GroupTrialsbyX(StimList, R , ones(1,length(StimList))*2 );

% % %% take real data and make it conform to a quadruplet formet
% % StimList = [ sort(Response.Green')' sort(Response.Red')'];
% % R        = ones(length(StimList),1);
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % %% make a linear model
% %
% % mat=[];
% % if size(StimListG,2) == 4
% %     for i = 1:size(StimListG,1);
% %         mat(i,StimListG(i,[1 4])) = 1;
% %         mat(i,StimListG(i,[2 3])) = -1;
% %     end
% % elseif size(StimListG,2) == 3
% %      for i = 1:size(StimListG,1);
% %         mat(i,StimListG(i,[1 3])) = -1;
% %         mat(i,StimListG(i,[ 2])) = 2;
% %     end
% % end
% %
% % mat(:,1)  = [];
% % betas     = glmfit(mat,[RG(:) dummy(:)],'binomial','link','probit');
% % predicted = glmval(betas,mat,'probit','size',dummy(:));
% % figure(1);
% % plot(predicted,'r');
% % hold on
% % plot(RG)
% % hold off
% % corr2(predicted,RG(:))
% % figure(2)
% % plot(betas./min(betas));
% % hold on
% % plot(phi,'r');
% % hold off
% %
% %
% %
