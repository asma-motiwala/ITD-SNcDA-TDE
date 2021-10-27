

function [h, avgRT, semRT] = PLOT_AVG_RESPONSE_TIMES(AGENT, labels)

% 

%% Figure location and sizes

LEFT    = 0;
BOTTOM  = 0;
SCALE   = 300;
WIDTH   = 2*SCALE;
HEIGHT  = 1*SCALE;
UNITS   = 'points';

LINE_WIDTH   = 4;
MARKER_SIZE  = 30;

%% Plot RTs for the model

a = labels.choiceTime - labels.init - labels.stim;
stimSet = unique(labels.stim);
stimSet(stimSet == 0) = [];

% colors = cbrewer('div','BrBG',3);
colors = GET_DEFAULT_MATLAB_LINE_COLORS;

if isfield(AGENT, 'nA')
    choices = [1 AGENT.nA];
else
    choices = [1 AGENT.num_actions];
end

avgRT = nan(numel(stimSet), 2);
semRT = nan(numel(stimSet), 2);

for istim = 1:numel(stimSet)
    
    indxS = (labels.stim == stimSet(istim)) & ...
        (labels.premature == 0) & (labels.choice == choices(1));
    avgRT(istim, 1) = mean(a(indxS));
    semRT(istim, 1) = std(a(indxS))/sqrt(sum(indxS));
    
    indxL = (labels.stim == stimSet(istim)) & ...
        (labels.premature == 0) & (labels.choice == choices(2));
    avgRT(istim, 2) = mean(a(indxL));
    semRT(istim, 2) = std(a(indxL))/sqrt(sum(indxL));
    
end

fname = 'AvgResponseTimes';
h = figure('Name', fname, 'NumberTitle', 'off', 'WindowStyle', 'normal', ...
    'Position', [LEFT BOTTOM WIDTH HEIGHT], 'Units', UNITS);

plot(stimSet, avgRT(:,1), ...
    'linewidth', LINE_WIDTH, 'color', colors(1, :))
hold on
plot(stimSet(2:end), avgRT(2:end,2), ...
    'linewidth', LINE_WIDTH, 'color', colors(2, :))

legend('Short choice', 'Long choice')
legend('boxoff')

plot(stimSet, avgRT(:,1), '.', ...
        'markerSize', MARKER_SIZE, 'color', colors(1, :))
plot(stimSet(1:end), avgRT(1:end,2), '.', ...
        'markerSize', MARKER_SIZE, 'color', colors(2, :))
% plot(stimSet, avgRT + stdRT, 'or')

xl = [4 26];
yl = [0 8];
xlim(xl)
ylim(yl)

plot([1 1]*15, yl, '--', 'color', [1 1 1]*.5 )
xlabel('Interval duration')
ylabel('Average response time')

axis square

box off


