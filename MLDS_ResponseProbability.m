function [d]=MLDS_ResponseProbability(data,rep,sigs,varargin)
%d = MLDS_ResponseProbability(data,rep,sig)
%
%   This plots the response probability for a given interval as a function
%   of the
%
%   VARARGIN goes to the plot function.
%
%   D is the differences of differences according to a linear model of the
%   perceptual scales (naive situation)


c = {'k' 'r' 'g' 'b'};
figure(1);clf;hold on;
for sig = sigs
    %get all the questions
    q = cat(3,[],data.stimlist{:,rep,sig});
    %get all the responses and average them
    r = squeeze(cat(3,[],data.responses{:,rep,sig}));
    r = mean(r,2);
    %get the subject model
    sm = data.SubjectModel(1:8,1,sig);
    %transform questions to the perceptual scale values
    %sm_diff = sm(q);
    sm_diff = q;
    %compute the perceptual difference
    sm_diff = abs([sm_diff(:,2)-sm_diff(:,1) sm_diff(:,3)-sm_diff(:,4)]);
    %compute the difference of differences
    d = diff(sm_diff,1,2);
    %plot the shit
    plot(d,r,'linestyle','none','marker','o','color',c{sig},varargin{:})
end
ylim([0 1]);