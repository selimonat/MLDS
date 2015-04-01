function MLDS_OptimizeSequence
%
tRun            = 10;
tSeq            = 1000;
StimListType    = 4;
MaxIntervalSize = 5;
%Subject Model
ModelDimension  = 2;
ModelShape      = 'power';
phi             = MLDS_CreateSubject(ModelDimension,ModelShape);%phi is a MODELDIMENSION x 8 matrix
sigma           = 0.7;
SubjectModel    = [phi(:) ; sigma];
%
 matlabpool local 5;
%
for nSequence = 1:tSeq;
    %
    stimlist                     = MLDS_GetStimlist(StimListType, 2, MaxIntervalSize);
    StimList(:,:,nSequence)      = uint8(stimlist);
    %
    parfor nRun = 1:tRun                
        %
        fprintf('Sequence: %d - %d',nSequence,nRun)
        %Get the responses
        responses(:,nRun,nSequence)     = MLDS_GetResponses(stimlist, phi, sigma );        
        tStim(:,nRun,nSequence)         = length( stimlist );
        %
        %MODEL is a column vector with the last entry being the stdd of
        %the decision noise.
        [Estimate(:,nRun,nSequence) ExitFlag(:,nRun,nSequence)]     = ...
            MLDS_MLE( stimlist, responses(:,nRun,nSequence) , ModelDimension);
        
        [delta(:,nRun,nSequence) EstimateAligned(:,nRun,nSequence)] = ...
            MLDS_ComputeDiff(SubjectModel,Estimate(:,nRun,nSequence));
                
    end
end

data.stimlist        = StimList;
data.responses       = responses;
data.sigmas          = sigma;
data.SubjectModel    = SubjectModel;
data.Estimate        = Estimate;
data.EstimateAligned = EstimateAligned;
data.ExitFlag        = ExitFlag;
data.delta           = delta;
data.tRun            = tRun;
data.tSeq            = tSeq;

save(sprintf('~/MLDS/%s_%d_%s_%d_%d.mat',mfilename, ModelDimension, ModelShape, StimListType, MaxIntervalSize),'data')

try
matlabpool close;
end