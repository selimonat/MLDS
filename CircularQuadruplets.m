function [valid]=CircularQuadruplets(repetition,IntervalSize)
%[valid]=CircularQuadruplets(repetition,IntervalSize)
%
%Selects two pairs of non-overlapping intervals in a circular stimulus
%space. INTERVALSIZE is the maximum interval that you want to include.
%Excludes any intervals that are bigger than INTERVALSIZE. iF you 
%want to include all possible intervals than use [] for INTERVALSIZE
%
%


tStim = 8;
if isempty(IntervalSize)
    IntervalSize = 100;
end

%all possible pairs of faces
pairs  = nchoosek(1:tStim,2);%*2*pi/8;
%the angles associated which each face.
x      = linspace(0,2*pi-2*pi/tStim,tStim);
%we need to translate the face pairs to angle pairs with the constraint
%that the angle is the smallest of the two possible angles.
S      = [];
%will keep the new pairs which are adapted to the smallest distances.
%S contains the intervals as a logical array. this will be used to select
%interval pairs that are not overlapping...
c = 0;
for p = pairs'%run through all pairs
    c = c+1;
    i1 = p(1):1:p(2);%interval 1
    i2 = mod((p(1):-1:(p(2)-8))-1,8)+1;%interval 2
    [dummy i] = min([length(i1), length(i2)]);
    if i == 1
        S(c,i1) = 1;
    elseif i == 2
        S(c,i2) = 1;
    end    
end
%S now contains all the intervals.... and pairs contains all the pairs,
%they both have the same size and their entries corresponds to each other.

% % %show it
% % imagesc(S);
% % axis image;
% % xlabel('stimuli');
% % ylabel('intervals');
% % colormap gray;

%Remove those intervals which are bigger than IntervalSize
i          = sum(S,2) > IntervalSize;
S(i,:)     = [];
pairs(i,:) = [];%update the pairs as well.

%
valid = [];
%for all intervals that are contained in S we detect all the non-overlapping
%intervals.
for i = 1:size(S,1)   
    interval = S(i,:);
    %detect all non overlapping pairs.
    indices = find(sum(repmat(interval,size(S,1),1).*S,2) == 0);
    %remove all the indices that have already been selected.
    indices = indices( indices > i );
    valid   = [valid ; [repmat(pairs(i,:),length(indices),1) pairs(indices,:)]];    
end
%quadruplets...
valid = repmat(valid,[repetition 1]);
