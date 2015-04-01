function [Sc,Rc]=MLDS_collapse(S,R)
%[Sc,Rc]=MLDS_collapse(S,R)
%
%   Will collapse the responses to same questions, thus making the
%   MLE estimation much quicker.

[Ss i j] = unique([sort(S(:,1:2),2) sort(S(:,3:4),2)],'rows');
Rc       = NaN(length(unique(j)),1);
Sc       = repmat(NaN,1,4);
for qtype = unique(j(:)');%run over all question types
    i  = find(j == qtype);
    Rc(qtype)   = mean(R(i,:));
    Sc(qtype,:) = S(i(1),:);
end