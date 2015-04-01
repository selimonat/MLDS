%% 1D analysis
 
%[data] = MLDS(trun,sigmas,repet,ModelDimension,ModelShape,StimListType,MaxIntervalSize,Percentage)


%% run a 1D MLDS, same as in the Maloney paper.
ttrials = 100;
[data] = MLDS(ttrials,[0.01 0.3 0.9 1.8 ],[1 3 5 10],1,'power',1,6,101);
%I put 101 because otherwise the one below with the same input parameters

%% Vary the allowed intervals.
% this will call the palamedes_routine, where the MAXINTSIZE is the
% difference of intervals between both pairs. if it is equal to zero, same
% intervals are compared. if it is higher, than it will be likely to have
% easier questions. Furthermore, for each simulation run I am using a
% different set of questions so that I could at the end correlate the
% optimality measures with the recovery error.
ttrials = 100;
MaxIntSize = 0;%no more than 1 difference of interval (total of 22 trials)
Repet      = 12;%(=132 trials)
[data]     = MLDS(ttrials,[0.01 0.3 0.9 1.8 ],Repet,1,'power',1,MaxIntSize,50);

MaxIntSize = 1;%all differences included (this gives 70 trials)
Repet      = 6;%(=140 trials)
[data]     = MLDS(ttrials,[0.01 0.3 0.9 1.8 ],Repet,1,'power',1,MaxIntSize,50);

MaxIntSize = 3;%only differences of (this gives 68 trials)
Repet      = 4;%(=136 trials)
[data]     = MLDS(ttrials,[0.01 0.3 0.9 1.8 ],Repet,1,'power',1,MaxIntSize,50);

%% 2D business

%% Gaussian Distributed Intervals
for mu    = [0 1 2 3];
    for sigma = [.1 .75 100];
        %Gaussian Distributed Individual Intervals
        [data] = MLDS(ttrials,[0.01 0.3 0.9 1.8 ],[1 3 5 10],1,'power',5,sigma,mu);
        % Gaussian Distribution Interval Differences
        [data] = MLDS(ttrials,[0.01 0.3 0.9 1.8 ],[1 3 5 10],1,'power',6,sigma,mu);
        %
    end
end