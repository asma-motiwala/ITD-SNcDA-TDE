

% RunAll_alt_reps(@RUN_MULTI_1, 1, 1)
% RunAll_alt_reps(@RUN_MULTI_2, 2, 1)
% RunAll_alt_reps(@RUN_MULTI_3, 3, 1)


%%

A = 1:3;

nRows = 4; 
nCol = 3;

q{nCol}    = [];
res{nCol}  = [];

for fldr_num = A

fname = ['saved_variables_A' num2str(fldr_num) '/' ...
            '_v9_CMPRS_1_ALPHA_1_EPS_1_SIG_1.mat'];
load(fname) % , 'TASK', 'AGENT', 'Agent', 'Labels')

[q{fldr_num}, res{fldr_num}] = ...
    COMPUTE_MAIN_EFFECT_QUANT(TASK, AGENT, Agent, Labels);

end


%%

figure

COLORS = flipud(cbrewer('div', 'PuOr', numel(TASK{1}.stim_set)));

num_Tsteps = 10;
gryscl = .5;

for a = 1:3
    
    subplot(nRows,nCol,a)
    hold on
    
    for t = 1:num_Tsteps-1
        
        plot([1 1]*t, [1 num_Tsteps], 'color', [1 1 1]*gryscl)
        % plot([1 num_Tsteps], [1 1]*t, 'color', [1 1 1]*gryscl)
        
    end
    
    if a < 3
        
        for t = 1:num_Tsteps-1
            plot([1 num_Tsteps], [1 1]*t, 'color', [1 1 1]*gryscl)
        end
        plot([1 6 7]+.5, [1 1 2]+.5, 'color', COLORS(1,:), 'linewidth', 2)
        
        if a == 1
            plot(7.5, 2.5, 'o', 'markerfacecolor', COLORS(1,:), ...
                'markeredgecolor', COLORS(1,:))
        end
        
    else
        
        plot([1 num_Tsteps], [1 1]*2, 'color', [1 1 1]*gryscl)
        plot([1 6 6]+.5, [1 1 5]+.5, 'color', COLORS(1,:), 'linewidth', 2)
        plot(6.5, 5.5, '^', 'markerfacecolor', COLORS(1,:), ...
            'markeredgecolor', COLORS(1,:))
        
    end
        
    xlim([1 num_Tsteps])
    ylim([1 num_Tsteps])
    axis square
    
    xticks([2 6 10]-.5)
    yticks([2 6 10]-.5)
    
    xticklabels([2 6 10]/10)
    yticklabels([2 6 10]/10)
    
    xlabel({'Estimated time since' 'interval onset (sec)'})
    ylabel({'Estimated time since' 'interval offset (sec)'})
    
end



% Plot TD-error PSTHs

for a = A
    
    subplot(nRows,nCol,a+nCol)
    hold on
    
    for istim = 1:numel(TASK{1}.stim_set)
        
        T = TASK{1}.stim_set(istim) + 2;
        plot(nanmean(res{a}.TDEpsth(3:T,istim,2,:),4), ...
            'color', COLORS(istim, :), 'linewidth', 2)
        
    end
        
    xlabel('Interval duration (sec)')
    ylabel('TDE')
    
    xticks([6 15 24]-2)
    xticklabels([6 15 24]/10)
    
    axis square

    
end

% Plot TDE-split psychometric curves
COLORS = GET_DEFAULT_MATLAB_LINE_COLORS;
COLORS(4,:) = [];

for a = A
    
    subplot(nRows,nCol,a+(nCol*2))
    hold on
    
    for ibin = 2:-1:1
        
        plot(TASK{1}.stim_set, nanmean(res{a}.psychCrvs(:,ibin,:),3), '.', ...
            'color', COLORS(ibin+2, :), 'markersize', 10)
        
        y = nanmean(res{a}.psychCrvs(:, ibin, :),3);        
        b = glmfit(TASK{1}.stim_set,y,'binomial','link','logit');
        
        fake_stim = linspace(TASK{1}.stim_set(1), TASK{1}.stim_set(end), 30);
        curve = glmval(b, fake_stim, 'logit');
        
        plot(fake_stim, curve, 'color', COLORS(ibin+2, :), ...
            'linewidth', 2)
        
    end
    
    axis square
    xlabel('Interval duration (sec)')
    ylabel('Probability of long choice')
    
    xticks([6 15 24])
    xticklabels([6 15 24]/10)
    
end

% Plot average response times

for a = A
    
    subplot(nRows,nCol,a+(nCol*3))
    hold on
    
    for ich = 1:2
        
        plot(TASK{1}.stim_set, nanmean(res{a}.avgRT(:,ich,:),3), ...
            'color', COLORS(ich, :), 'linewidth', 2)
        
    end
        
    xlabel('Interval duration (sec)')
    ylabel('Average response time')
    
    xlim([4 26])
    ylim([0 4.5])
    
    axis square
    
    xticks([6 15 24])
    xticklabels([6 15 24]/10)
    
end

