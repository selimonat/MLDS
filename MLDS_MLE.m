function [Estimate,ExitFlag,Likelihood]=MLDS_MLE(StimList,R,ModelDimen)
%[Estimate,ExitFlag]=MLDS_MLE(StimList, R, ModelDimen);
%
%
% This is the core optimization function. STIMLIST is the list of
% the stimulus indices. R is the binary response variable. MODELDIMEN can be 1, 2 or 3.
%
% ESTIMATE contains the coordinates of the perceptual scale values in (MODELDIMENx8) 
% matrix.
%
% Depends on MLDS_TriadLikelihood

plotting  = 0;
options   = optimset('Display','off','maxfunevals',10000,'tolfun',10^-12,'tolx',10^-12,'tolcon',10^-12,'maxiter',4000);
%Function that will be optimized... It is a wrapper aroudn
%TRIADLIKELIHOOD so that the initial values in [P0 sigm] are passed
%to it easily
funny     = @(x) MLDS_TriadLikelihood(StimList, R, x);
%
X    = [];

%define the upper and lower boundaries for the optimization as well
%as the initial paramters
if ModelDimen == 1
    p0          = linspace(0,1,8)+rand(1,8)*0.05;
    p0          = p0./max(p0);
    p0          = p0(:);%make a column vector
    %p0         = linspace(0,1,8)*2*pi;
    p0          = p0(2:end);%the first entry is inserted in the likelihood function and kept 0 position.           
    %
% %     LB          = [zeros(1,7)-0.1 0.01];%7 instead of 8 because we fix the first one to 0
% %     UB          = [ones(1,7)+0.1 2];
elseif ModelDimen == 2;
    p0          = [cos(linspace(0,2*pi-2*pi/8,8)) ; sin(linspace(0,2*pi-2*pi/8,8))];
    p0          = p0(:,2:end);%the first entry is inserted in the likelihood function and kept at [1 0] position.
    p0          = p0(:);%make it a column vector
    %
%     LB          = -ones(1,7)-0.1;
%     LB          = [LB(:) ;0.01];
%     UB          = ones(1,14)+0.1;
%     UB          = [UB(:) ;10];
elseif ModelDimen == 3;
    p0          = [cos(linspace(0,2*pi-2*pi/8,8)) ; sin(linspace(0,2*pi-2*pi/8,8)) ; rand(1,8)];
    p0          = p0(:,2:end);%the first entry is inserted in the likelihood function and kept 0.    
    p0          = p0(:);%make it a column vector   
    %
% %     LB          = repmat([-ones(1,7) 0.01],3,1);
% %     UB          = repmat([ones(1,7) 2],3,1);
end
%% estimate initial sigma value
c=0;
l = nan(1,100);
x = linspace(0.01,6,100);
for s = x;
    c=c+1;
    l(c) = [funny([p0 ;s])];
end
[mi i] = min(l);
figure(100);plot(x,l)
sigma  = x(i);
fprintf('Estimated Sigma is %03s\n',sigma);

%ML Estimate of perceptual scale values
[Estimate,Likelihood,ExitFlag]  = fminsearch(funny , [p0(:) ;sigma], options);%funny receives the STIMLIST AND Response vector automatically.

%Add the first point that is immobile
if ModelDimen == 2
    Estimate = [[1;0];Estimate];
elseif ModelDimen == 1
    Estimate = [0;Estimate];
end
    
    
    
    
    
    
    
    
    
    
    