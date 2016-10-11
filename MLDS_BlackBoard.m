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
%% logistic with 2D a majestic try out

%% Subject
%get a subject with known 2D Psi values, where the distance increases with
%a power law. Create also a 1D subject.
Subject2D = MLDS_CreateSubject(2,'power');
plot(Subject2D(1,:),Subject2D(2,:),'ro-');
Subject1D = MLDS_CreateSubject(1,'power');
plot(Subject1D(1,:),'ro-');
%% get stimuli: 
%Circularly organized 8 stimuli, repeat 1000 times so that we dont have issues on not enough data.
StimList = MLDS_GetStimlist(2,1000,5);
X        = MLDS_Q2DM(StimList);% a beautiful design matrix

%% get responses
R1D = MLDS_GetResponses(StimList,Subject1D,0.25)';%noise is Gaussian(0,0.25), we have to think whether this is a good noise model, coz responses should never because less than 0.
R2D = MLDS_GetResponses(StimList,Subject2D,0.25)';

%% use TK magic, first proof of concept
% PsiValues = glmfit(X,R1D,'binomial','link','logit','constant','on');%this will not work because the rank of X is 7, however it has 8 columns.
%here we remove one column from X, this means we set that psi to 0.
PsiValues = glmfit(X(:,2:end),R1D,'binomial','link','logit','constant','on');%Constant=Off, gives crap results, think about it.
%plot the results.
clf;plot(zscore([0 ;PsiValues(2:end)]),'o');hold on;plot(zscore(Subject1D),'r-');hold off;%looks perfect.
%% so now let's try the SO magic with 2D.
PsiValues = glmfit(X(:,2:end),R2D,'binomial','link','logit','constant','off');%Constant=Off, gives crap results, think about it.
clf;plot(zscore([0 ;PsiValues(2:end)]),'o');hold on;plot(zscore(Subject2D(1,:)),'r-');hold off;%looks like we get the 1 cycle of oscilation.
%% now we would like to project distances in X to two orthognal spaces and re-run the same analysis...
PsiValues = glmfit(X(:,2:end),R2D,'binomial','link','logit','constant','off');%Constant=Off, gives crap results, think about it.
clf;plot(zscore([0 ;PsiValues(2:end)]),'o');hold on;plot(zscore(Subject2D(1,:)),'r-');hold off;%looks like we get the 1 cycle of oscilation.
