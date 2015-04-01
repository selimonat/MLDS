function [dm]=MLDS_Q2DM(q)
%[dm]=MLDS_Q2DM(q)
%
%   Will transform the questions to design matrix.

tq = length(q);
dm = zeros(tq,8);
for n = 1:tq;
    dm(n,q(n,:) ) = [-1 1 1 -1];
end