function MLDS_VisualizeStimList(stimlist)
%MLDS_VisualizeStimList(stimlist)
%
%Produces a graphic representation of the stimuli pairs used. Joint
%histogram on the hand and connectivity of the nodes on the other.

%
stimlist = [sort(stimlist(:,[1 2]),2) sort(stimlist(:,[3 4]),2)];
%
x        = cos(((stimlist-1)./8)*2*pi);
y        = sin(((stimlist-1)./8)*2*pi);
%%
figure;
hold on;

for i = 1:length(x);
   
    x1 = [x(i,1),x(i,2)]+rand*0.1;
    y1 = [y(i,1),y(i,2)]+rand*0.1;
    %
    xflip1 = [ x1 fliplr(x1)];
    yflip1 = [ y1 fliplr(y1)];
    
    y2 = [x(i,3),x(i,4)]+rand*0.1;
    x2 = [y(i,3),y(i,4)]+rand*0.1;
    
    xflip2 = [ x2 fliplr(x2)];
    yflip2 = [ y2 fliplr(y2)];
    
    plot([x(i,1),x(i,2)]+rand*0.1 , [y(i,1),y(i,2)]+rand*0.1 ,'ro-', ...
         [x(i,3),x(i,4)]+rand*0.1 , [y(i,3),y(i,4)]+rand*0.1,'ko-');
   
   %patch(xflip1,yflip1,'r','EdgeAlpha',1/20,'FaceColor','none');
   %patch(xflip2,yflip2,'k','EdgeAlpha',1/20,'FaceColor','none');
   
   
end
%%

figure
imagesc(hist3([[stimlist(:,1) stimlist(:,2)];[stimlist(:,2) stimlist(:,1)]],{1:8 1:8}));
hold on
for i = 1:length(stimlist)
    plot([stimlist(i,1)+rand*0.2 stimlist(i,3)+rand*0.2],[stimlist(i,2)+rand*0.2 stimlist(i,4)+rand*0.2],'o-','color',rand(1,3))
end
xlabel('stim id');ylabel('stim id');
hold off

