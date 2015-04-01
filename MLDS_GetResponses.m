function [Response]=MLDS_GetResponses(StimList,Subject,Noise)
%[Response]=MLDS_GetResponses(StimList,Subject,Noise)
%
%Simulate subject's perceptual responses to a quadruple stimuli organized
%as two pairs. SUBJECT contains the perceptual scale values and NOISE
%contaminates the final decision variable. NOISE is the standard deviation
%of the additive noise.
%




plotting = 0;
if plotting
    figure(1);
    plot(0:7,Subject,'r-o',0:7,[0:7]./7);
    drawnow;
end
%%
%Compute the responses of the simulated subject with a noise
%characterised with sigma...
for i = 1:size(StimList,1)
    %each call of NORM computes the euclidian distance between
    %NODES. Their differences are taken and a random noise is
    %added.
    if size(StimList,2) == 4
        D  = norm(Subject(:,StimList(i,2))'- Subject(:,StimList(i,1))') - norm(Subject(:,StimList(i,4))'-Subject(:,StimList(i,3))') + randn(1)*Noise;
    elseif size(StimList,2) == 3
        %first one is up, then left and right
        D  = norm(Subject(:,StimList(i,2))'- Subject(:,StimList(i,1))') - norm(Subject(:,StimList(i,3))'-Subject(:,StimList(i,1))') + randn(1)*Noise;
    end
    if D <= 0
        Response(i) = 0;
    else
        Response(i) = 1;
    end
    bla(i) = D;
end
%
%this alternative method uses Palamedes toolbox.
%R         = PAL_MLDS_SimulateObserver(StimList,ones(length(StimList)),Subject,sigma);
%
%[StimListG RG dummy] = PAL_MLDS_GroupTrialsbyX(StimList, R , ones(1,length(StimList))*2 );
%model = [Subject(1:end) sigma]';%full model
