function [StimList]=MLDS_GetStimlist(type,repetition,MaxIntervalSize,varargin)
%[StimList]=MLDS_GetStimlist(type,repetition,MaxIntervalSize,varargin)
%
%   This generates the questions that are going to be asked to the subject
%   or simulator.
%
%   VARARGIN can determine the percentage of trials to be randomly
%   selected. if not given 100 is used, that is all the trials are
%   included.
%
%
%   type = 1 ===> Stim list for the linear stimulus space, same as the MLDS
%   paper of Malooney
%
%   type = 2 ===> Stim list for the circular stimulus space. These consist of
%   two pairs that are selected to be non-overalapping.
%
%   type = 3 ===> Triad Stim list for the circular stimulus space.
%
%   type = 4 ===> Random creation of the stimulus space. Pure Random, no
%   filtering. MAXINTERVAL filters the distance of the faces within each
%   individual pair. (Int1 <= MaxIntervalSize) & (Int2 <= MaxIntervalSize).
%   For example, if MAXINTERVALSIZE is 1 only neigboring faces are selected as
%   pairs.
%
%   type = 5 ===> Probabilistic creation of the stimulus space. 
%   (Int1 <= MaxIntervalSize) & (Int2 <= MaxIntervalSize), however
%   MAXINTERVALSIZE is a probabilistic distribution, where PERCENTAGE
%   decides the location of the Gaussian distribution and MAXINTERVALSIZE
%   (varargin) the width.
%   prob       = normpdf([0 1 2 3],Percentage,MaxIntervalSize);
%
%
%   type = 6 ===> Random creation with constrained max interval
%   "differences". abs(Int1 - Int2) < D;
%   For example, if D is equal to 1, then only pairs with
%   same distances are compared e.g. [1 2;3 4] or [2 4; 5 7]. If M. is 2,
%   pairs such as [1 2; 3 5] are also allowed. However note that D has a
%   statistical distribution, it is a Gaussian controlled with Position (mu) and
%   MaxIntervalSize (sigma). It is better to play around with the desired
%   values before experimenting.
%   
%       
%
%repetition ===> how many times it is repeated.
%

BlockSize = 120;

if nargin > 3
    Percentage = varargin{1};%the percentage of the stimlist to be used.
else
    Percentage = 100;
end

%Generate a list of stimulus pairs
if type == 1
%% all possible quadruplets. in total it will be 70 trials, this is for linear space
    StimList  = PAL_MLDS_GenerateStimList(4,8,MaxIntervalSize,repetition);
    %the meaning of MaxIntervalSize is different here. it is the difference
    %of intervals between the first and second pairs. Same as in the case
    %of type 6. So bigger the MAXINTERVAL SIZE more likely to have easier
    %questions because bigger intervals will be compared to smaller
    %intervals. If MAXINTERVALSIZE is 0, always same intervals will be
    %compared. This is difficult but maybe more efficient
    
    %if percentage is different than zero remove randomly some trials.
    if Percentage ~= 100;
        i = randsample(1:size(StimList,1),floor(size(StimList,1)*Percentage/100));
        StimList = StimList(i,:);
    end   
    
elseif type == 2
% Return circular quadruplets that are non-overlapping. Excludes all the intervals
% that are bigger than the MAXINTERVALSIZE. Returns 120*repetition trials...    
% It follows the same constraints as in the Maloney Paper, that is no
% overlapping pairs.
    StimList  = CircularQuadruplets(repetition,MaxIntervalSize);        
    if Percentage ~= 100;
        i = randsample(1:size(StimList,1),floor(size(StimList,1)*Percentage/100));
        StimList = StimList(i,:);
    end   
elseif type == 3
%% triads type of questions.
    
    StimList  = PAL_MLDS_GenerateStimList(3, 8, MaxIntervalSize, repetition);
    
elseif type == 4
%% randomly create quadruplets. 
%% Exclude pairs which are more distant than MAXINTERVALSIZE.     
%% This is not constrained as in 2.
    StimList    = [];
    while size(StimList,1) < (BlockSize*repetition);
        new = randsample(1:8,4,0);   
        %transform the faces to angles
        new = (new-1).*360./8;
        %
        Int1 = abs(MinimumAngle( new(1), new(2)))/360*8;
        Int2 = abs(MinimumAngle( new(3), new(4)))/360*8;
        %
        if (Int1 <= MaxIntervalSize) & (Int2 <= MaxIntervalSize)
            new = new/360*8+1;
            StimList = [ StimList ; new ];            
        end    
    end
    
    
    
elseif type == 5
    %% similar to 4 but probabilistic
    %% PERCENTAGE controls the location of the Gaussian!!
    %% MAXINTERVALSIZE controls its width. With these two parameters you can control the distribution of MAXINTERVALSIZE
    StimList   = [];
    prob       = normpdf([0 1 2 3],Percentage,MaxIntervalSize);
    prob       = prob./sum(prob);
    while size(StimList,1) < (BlockSize*repetition);
        D = randsample(1:4,1,1,prob);
        while true
            new = randsample(1:8,4,0);
            %transform the faces to angles
            new = (new-1).*360./8;
            %
            Int1 = abs(MinimumAngle( new(1), new(2)))/360*8;
            Int2 = abs(MinimumAngle( new(3), new(4)))/360*8;
            %
            if (Int1 == D) & (Int2 == D)
                StimList = [StimList ; new/360*8+1 D]
                break
            end
        end
    end    


elseif type == 6
    %% This sounds similar to type 4 but actually, MAXINTERVALSIZE filters for 
    %% the differences of intervals. 
    %PERCENTAGE controls the location of the Gaussian!!
    %MAXINTERVALSIZE controls its width
    StimList   = [];
    prob       = normpdf([0 1 2 3],Percentage,MaxIntervalSize);
    prob       = prob./sum(prob);
    while size(StimList,1) <= (120*repetition);
        D = randsample(0:3,1,1,prob);
        while true
            new = randsample(1:8,4,0);
            %transform the faces to angles
            new = (new-1).*360./8;
            %
            Int1 = abs(MinimumAngle( new(1), ne2bflsww(2)))/360*8;
            Int2 = abs(MinimumAngle( new(3), new(4)))/360*8;
            %
            if abs(Int1 - Int2) == D;
                StimList = [StimList ; new/360*8+1];
                break
            end
        end
    end
    end

    
end


    
    
    
    
    
    
    
    
    
    
    
    