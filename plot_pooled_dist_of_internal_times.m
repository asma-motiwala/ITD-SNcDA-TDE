

% fldr_name = ['/Users/asmaLisbon/Dropbox (Learning Lab)/My Matlab files/' ...
%     '2016 - Interval discrimination with RL agent/' ...
%     'v9 - POMDP sampling implementation/' ...
%     'saved_variables_test_RCEnC/'];

fldr_name = 'saved_variables_RCnE/';
v = 9; 

load([fldr_name 'v' num2str(v) '_allParam.mat'])

cmprsIdx = numel(CMPRS);
alphaIdx = 1;
epsIdx = 1;
sigIdx = 2;

fl_name = ['v' num2str(v) ...
    '_CMPRS_'   num2str(cmprsIdx) ...
    '_ALPHA_'   num2str(alphaIdx) ...
    '_EPS_'     num2str(epsIdx) ...
    '_SIG_'     num2str(sigIdx)];
fl_pth = [fldr_name fl_name '.mat'];

load(fl_pth, 'CMPRS', 'ALPHA', 'EPS', 'SIG', ...
    'TASK', 'AGENT', 'Agent', 'Labels')

%%

numRepeats_ = size(AGENT,1);
CENTERS = 0:.5:40;

C = nan(numel(CENTERS),numel(TASK{1}.stim_set),numRepeats_);

for ir = 1:numRepeats_
    
    P = COMPUTE_DIST_OF_INTRNL_TIME_AT_INTRV_OFF(AGENT{ir}, TASK{ir}, CENTERS);
    tempC = nan(numel(CENTERS),numel(TASK{ir}.stim_set));
    
    for istim = numel(TASK{1}.stim_set):-1:1
        
        subjTatIntOff = ...
            Labels{ir}.subj_delay(Labels{ir}.stim == ...
            TASK{ir}.stim_set(istim));
        
        subjTatIntOff(subjTatIntOff==0) = [];
        
        [tempC(:,istim), ~] = ...
            hist(subjTatIntOff, CENTERS);
        tempC(:,istim) = tempC(:,istim)/sum(tempC(:,istim));
        
    end
    
    C(:,:,ir) = tempC;
    
end

C = nanmean(C,3);

%

COLORS = flipud(cbrewer('div', 'PuOr', numel(TASK{1}.stim_set)));

figure
hold on

for istim = 1:size(C,2)
    
    plot(CENTERS, C(:,istim), 'color', COLORS(istim, :), 'linewidth', 2)
%     plot(CENTERS, P(:,istim), 'color', COLORS(istim, :), 'linewidth', 1)
    
end

xlabel('Subjective estimate of interval duration (sec)')
ylabel('Probability')

xticks([4 15 24])
xticklabels([4 15 24]/10)

axis square
box off


%% Plot softmax function for range of parameters used

figure
x = -10:.5:10;

ALL_ALPHA = .1:.1: 1;

temp_colors = cbrewer('div', 'RdBu', numel(ALL_ALPHA));

for alpha = ALL_ALPHA

y = exp( alpha*x );
y = y/sum(y);
plot(x, y, 'color', temp_colors(alpha==ALL_ALPHA,:), 'linewidth', 2)
hold on

end

YL = ylim;

for alpha = ALL_ALPHA
    
    indx_alpha = find(alpha == ALL_ALPHA);
    text(-8,YL(2)-(YL(2)-YL(1))*(.2+.025*indx_alpha),num2str(alpha),...
        'color', temp_colors(alpha==ALL_ALPHA,:))
    
end

% alpha = AGENT{1, 1}.alpha;
% y = exp( alpha*x );
% y = (y/sum(y));
% plot(x, y, 'k', 'linewidth', 2)

axis square
xlabel('Action advantage')
ylabel('Probability of selecting action')


%%