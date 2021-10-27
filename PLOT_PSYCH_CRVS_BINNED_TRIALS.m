
function [h, labels, psychCrvs] = ...
    PLOT_PSYCH_CRVS_BINNED_TRIALS(labels, tde, TASK, RANGE)
%
% Compatible with: v7
%
% Group trials by by magnitude of RPE at second tone and plot psychometric curves
% of each group 

% clearvars -except labels tde RANGE

%%

STIM_SET = TASK.stim_set;
NUM_BINS = 2;

%% Figure location and sizes

LEFT    = 0;
BOTTOM  = 0;
SCALE   = 300;
WIDTH   = 2*SCALE;
HEIGHT  = 1*SCALE;
UNITS   = 'points';

LINE_WIDTH   = 4;
MARKER_SIZE  = 30;

%%

if numel(labels.init) ~= numel(labels.choice)
    labels.init(end) = [];
    labels.stim(end) = [];
end

% indxSecTone = round((labels.init + labels.stim)/TASK.dt); % - 1;
% indxSecTone( indxSecTone > numel(tde) ) = numel(tde);
% labels.secToneTDE  = tde(indxSecTone)';

labels_stim = labels.stim;

if nargin > 3
    labels_stim(1:RANGE(1)) = nan;
    labels_stim(RANGE(2):end) = nan;
end

%%

% [bin, bounds] = COMPUTE_BINNED_PSYCHCRVS(labels.secToneTDE, labels_stim, NUM_BINS);
% disp(bounds)

bin = nan(1,numel(labels.secToneTDE));

for istim = 1:numel(STIM_SET)
    
    clear indx indx1 indx2 med
    indx = labels.stim == STIM_SET(istim) & labels.choice ~= 0 & labels.secToneTDE ~= 0;
    med  = nanmedian(labels.secToneTDE(indx));
    
    indx1 = labels.stim == STIM_SET(istim) & labels.choice ~= 0 ...
        & labels.secToneTDE <= med & labels.secToneTDE ~= 0;
    indx2 = labels.stim == STIM_SET(istim) & labels.choice ~= 0 ...
        & labels.secToneTDE > med & labels.secToneTDE ~= 0;
    
    bin(indx1) = 1;
    bin(indx2) = 2;
    
end



%%

choice_long = max(labels.choice);

fname = 'BinnedPsychCrvs';
h = figure('Name', fname, 'NumberTitle', 'off', 'WindowStyle', 'normal', ...
    'Position', [LEFT BOTTOM WIDTH HEIGHT], 'Units', UNITS);
subplot(1,2,1)
hold on

colors = GET_DEFAULT_MATLAB_LINE_COLORS;
colors = min((colors([3 5], :)) - 0.05,1);

psychCrvs = nan(numel(STIM_SET), NUM_BINS);

for ibin = [1 2] 
    
    for istim = 1:numel(STIM_SET)
        
        indx = labels.stim == STIM_SET(istim) & bin == ibin & labels.choice ~= 0;
        psychCrvs(istim, ibin) = nanmean(labels.choice(indx) == choice_long);
        
    end
    
    plot(STIM_SET, psychCrvs(:,ibin), ...
        'linewidth', LINE_WIDTH, 'color', colors(ibin, :))
    
end

legend('low DA','high DA')
legend('location', 'SouthEast')
legend('boxoff')
   
for ibin = [2 1]
    
    plot(STIM_SET, psychCrvs(:,ibin), '.', ...
        'markerSize', MARKER_SIZE, 'color', colors(ibin, :))
    
end

xlim([4 26])
ylim([-0.1 1.1])

set(gca,'XTick',[6 15 24])
set(gca,'YTick',[0 1])

xlabel('Elapsd time')
ylabel('Probability of categorising delay as long')

axis square

end

