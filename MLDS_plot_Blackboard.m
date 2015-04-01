%% plot the results we computed with tim together 
f = FilterF('~/MLDS','MLDS/MLDS_2_power_6.*0.mat','.mat')
f = f([1 2 3 4]);
diff_phi = [];
for ff = 1:length(f); 
     file = regexp(f{ff},'MLDS_2_.*','match');
     diff_phi(:,:,:,ff) = MLDS_plot(file{1},3,3);
end
load(f{1});
diff_ori = diff_phi;
%% plot the Mean and Error

diff_phi = diff_ori;
diff_phi = permute( diff_phi , [1 3 2 4] );%make the std dimension the second one, so that
%we can easily reshape...
diff_phi = reshape( diff_phi , [size(diff_phi,1).*size(diff_phi,2) size(diff_phi,3) size(diff_phi,4)]);
M = squeeze(mean(diff_phi));
S = squeeze( std(diff_phi))./sqrt(size(diff_phi,1));
%
figure(1);
color = {'y' 'r' 'k' 'b'}
for nc = 1:size(M,2)     
    errorbar(data.repetitions(:)*120+rand(7,1)*5, M(:,nc),S(:,nc),'color',color{nc},'linewidth',2);
    hold on;
end
hold off;
box off;
%
legend('0.3','0.7','1.2','4')
legend boxoff
xlabel('repetition');
ylabel('fit error');
axis square
axis tight
% 
%%
SaveFigure('~/MLDS/figures/general/SigmaD_.png');