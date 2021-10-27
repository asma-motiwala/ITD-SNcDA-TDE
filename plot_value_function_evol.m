

fldr_name = 'saved_variables_RCnE/';
v = 9; 

load([fldr_name 'v' num2str(v) '_allParam.mat'])

N_COLMN = 2;
N_ROWS  = 2;

LEFT    = 0;
BOTTOM  = 0;
SCALE   = 250;
WIDTH   = 1.25*N_COLMN*SCALE;
HEIGHT  = N_ROWS*SCALE;
UNITS   = 'points';

fig_name = 'val_func_evol';

DPI = 800;
figure('Name', fig_name, 'NumberTitle', 'off', ...
    'WindowStyle', 'normal', 'Position', [LEFT BOTTOM WIDTH HEIGHT], ...
    'Units', UNITS);

cmpr_str = {'efficient representation', 'unambiguous representation'};

for ic = [1 numel(CMPRS)]

cmprsIdx = ic;
alphaIdx = 1;
epsIdx = 1;
sigIdx = 2;

fl_name = ['v' num2str(v) ...
    '_CMPRS_'   num2str(cmprsIdx) ...
    '_ALPHA_'   num2str(alphaIdx) ...
    '_EPS_'     num2str(epsIdx) ...
    '_SIG_'     num2str(sigIdx)];
fl_pth = [fldr_name fl_name '.mat'];

load(fl_pth, ...'CMPRS', 'ALPHA', 'EPS', 'SIG', ...
    'TASK', ... 'Agent', ...
    'AGENT', 'Labels')

%% Plot evolution of value function through learning 

numRepeats_ = 1; % size(AGENT,1);
Ns = size(Labels{1, 1}.Vavg,2);

temp_Vavg = nan(AGENT{1, 1}.T_max*2, Ns, numRepeats_);

for ir = 1:numRepeats_
    
    temp_Vavg(:,:,ir) = Labels{ir}.Vavg;
    
end

temp_Vavg = nanmean(temp_Vavg,3);

temp_colors = cbrewer('div', 'BrBG', Ns);

subplot(2,2,1 + (ic>1)*2)

for s = 1:Ns
    
    plot(temp_Vavg(1:30,s), 'color', temp_colors(s,:), ...
        'linewidth', 1)
    hold on
    
end

xlim([0 30])
ylim([-2 10])
xlabel({'Estimated time' 'during the interval (sec)'}')
ylabel({'Estimated state value using' cmpr_str{1+(ic>1)}}')
xticks([4 15 24])
xticklabels([4 15 24]/10)
axis square
box off
set(gca,'TickDir','out');
  
subplot(2,2,2 + (ic>1)*2)

for s = 1:Ns
    
    plot(temp_Vavg((1:30)+34,s), 'color', temp_colors(s,:), ...
        'linewidth', 1)
    hold on
    
end

xlim([0 30])
ylim([-2 10])
xlabel({'Estimated time since' 'interval offset (sec)'}')
ylabel('Estimated state value')
xticks([4 15 24])
xticklabels([4 15 24]/10)
axis square
box off
set(gca,'TickDir','out');

%%

for s = 5:5:Ns
    
    text(32,s/6,num2str(TASK{1,1}.N*s),'color',temp_colors(s,:))
    
end

  

end




