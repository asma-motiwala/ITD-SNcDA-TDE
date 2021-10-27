

function [h_psths, h_nb_tde, avgTde] = ...
    PLOT_AVG_TDE(labels, tde, TASK, RANGE)

% Compatible with task versions: v7, v8

WIN_SIZE = [2 26]/TASK.dt; % round(TASK.iti * [-.1 1]); 
X = WIN_SIZE(1):WIN_SIZE(2)-1;

COLORS = flipud(cbrewer('div', 'PuOr', numel(TASK.stim_set)));

avgTde = nan(WIN_SIZE(2)-WIN_SIZE(1), numel(TASK.stim_set), 2);

%% Figure location and sizes

LEFT    = 0;
BOTTOM  = 0;
SCALE   = 300;
WIDTH   = 2*SCALE;
HEIGHT  = 1*SCALE;
UNITS   = 'points';

LINE_WIDTH   = 4;

%%

if numel(labels.init) ~= numel(labels.choice)
    
    labels.init(end) = [];
    labels.stim(end) = [];
    
end

%%

fname = 'PSTHs';
h_psths = figure('Name', fname, 'NumberTitle', 'off', 'WindowStyle', 'normal', ...
    'Position', [LEFT BOTTOM WIDTH HEIGHT], 'Units', UNITS);

for ireward = 0:1
    
%     figure
%     clf
    subplot(1,2,2-ireward)
    hold on
    
    for istim = numel(TASK.stim_set):-1:1
        
        indx = find(labels.stim == TASK.stim_set(istim) & ...
            labels.reward == ...
            ((ireward==1)*TASK.feedback_correct + ...
            (ireward==0)*TASK.feedback_incorrect));
        
%         indx = find(labels.stim == TASK.stim_set(istim));
        
        if nargin > 3
            indx(indx < RANGE(1)) = [];
            indx(indx > RANGE(2)) = [];
        end
        
        temp = nan(WIN_SIZE(2)-WIN_SIZE(1), numel(indx));
        
        for itrial = 1:numel(indx)
            
            a = (labels.init(indx(itrial))/TASK.dt) + WIN_SIZE;
            b = a(1)+1 : min(a(2),numel(tde));
            temp(1:numel(b), itrial) = tde( round(b) );
            
        end
        
        % temp(temp < -2) = -2; % rectification
            
        if sum(indx) > 0
            avgTde(:, istim, ireward+1) = nanmean(temp, 2);

        else
            avgTde(:, istim, ireward+1) = zeros(WIN_SIZE(2)-WIN_SIZE(1), 1);
        end
        
        plot( X(X <= TASK.stim_set(istim)/TASK.dt + 1/TASK.dt), ...
            avgTde(X <= TASK.stim_set(istim)/TASK.dt + 1/TASK.dt, istim, ireward+1), ...
            'color', COLORS(istim, :), 'linewidth', LINE_WIDTH )
               
    end
    
    xlabel('Time since trial initiation')
    ylabel('Average RPE')
    
    xlim([WIN_SIZE(1)-3 WIN_SIZE(2)])
    ylim([-.1 .8]*TASK.feedback_correct)
    
    set(gca,'XTick',[4 15 26]/TASK.dt)
    set(gca,'YTick',[0 .5]*TASK.feedback_correct)
    
    box off
    axis square
    
    % title(['Reward = ' num2str(ireward)])
    
end

%%

fname = 'PSTHsNBv1';
h_nb_tde = figure('Name', fname, 'NumberTitle', 'off', 'WindowStyle', 'normal', ...
    'Position', [LEFT BOTTOM WIDTH HEIGHT], 'Units', UNITS);

subplot(1,2,1)
hold on

gr = .7;

for istim = [(numel(TASK.stim_set)/2),((numel(TASK.stim_set)/2)+1)]
    
    indx = X <= TASK.stim_set(istim) + 1;
    
    a = avgTde(indx, istim, 2);
    plot( X(indx) + 1, a, 'color', [1 1 1]*gr, 'linewidth', LINE_WIDTH )
    
    a = avgTde(indx, istim, 1);
    plot( X(indx) + 1, a, 'color', ...
        COLORS(numel(TASK.stim_set),:)*(istim==3) ...
        + COLORS(1,:)*(istim==4), ...
        'linewidth', LINE_WIDTH )
    
end
xlim([11 19])
ylim([-1.5 3])

set(gca,'XTick',[11 14 16])
set(gca,'YTick',[-1 0 1 2])

xlabel('Elapsed time')
ylabel('Average RPE')

axis square
box off


%%

end

