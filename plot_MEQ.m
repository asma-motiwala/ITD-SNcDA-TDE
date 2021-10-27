

% fname = ['saved_variables_MEQ/' 'v9' '_pooled_meq'];
% load(fname, 'meq')
% 
% alphaIdx = 5;
% sigIdx = 5;
% 
% load(['saved_variables_MEQ/v9_CMPRS_1_ALPHA_' num2str(alphaIdx) ...
%     '_EPS_1_SIG_' num2str(sigIdx) '.mat'])
% [~,res] = COMPUTE_MAIN_EFFECT_QUANT(TASK, AGENT, Agent, Labels);

%%

COLORS = flipud(cbrewer('div', 'PuOr', numel(TASK{1}.stim_set)));

epsIdx = 1;
CMPRS_LST = 1:numel(CMPRS);

nStim = size(res.TDEpsth,2);

numRows = numel(CMPRS_LST)+ 1;
numCol = 3;

figure

for iq = 1:3
    
    subplot(numRows,numCol,iq)
    hold on
    
    for istim = 1:nStim
        
        T = TASK{1}.stim_set(istim) + 2;
        plot(nanmean(res.TDEpsth(3:T,istim,2,:),4), ...
            'color', COLORS(istim, :), 'linewidth', 1)
        
        if iq == 1
            
            avgTDEshort = nanmean(nanmean(res.avgSecToneTDE(1:3,:)));
            avgTDElong = nanmean(nanmean(res.avgSecToneTDE(4:6,:)));
            
            plot(TASK{1}.stim_set(1:3), avgTDEshort*ones(3,1), '--', ...
                'color', COLORS(1, :), 'linewidth', 2)
            
            plot(TASK{1}.stim_set(4:6), avgTDElong*ones(3,1), '--', ...
                'color', COLORS(end, :), 'linewidth', 2)
            
            title({'(a) Difference in average TDE' ...
                'at interval offset between' 'all short and long intervals'})
            
        elseif iq == 2
            
            plot(TASK{1}.stim_set(1)-1, nanmean(res.avgSecToneTDE(1,:)), ...
                'o', 'markerfacecolor', COLORS(1, :), ...
                'markeredgecolor', COLORS(1, :), 'markersize', 10)
            
            plot(TASK{1}.stim_set(3)-1, nanmean(res.avgSecToneTDE(3,:)), ...
                'o', 'markerfacecolor', COLORS(3, :), ...
                'markeredgecolor', COLORS(3, :), 'markersize', 10)
            
            title({'(b) Difference in average TDE' ...
                'at interval offset between' 'easy and near-boundary' ...
                'long intervals'})
            
        elseif iq == 3
            
            plot(TASK{1}.stim_set(4)-1, nanmean(res.avgSecToneTDE(4,:)), ...
                'o', 'markerfacecolor', COLORS(4, :), ...
                'markeredgecolor', COLORS(4, :), 'markersize', 10)
            
            plot(TASK{1}.stim_set(6)-1, nanmean(res.avgSecToneTDE(6,:)), ...
                'o', 'markerfacecolor', COLORS(6, :), ...
                'markeredgecolor', COLORS(6, :), 'markersize', 10)
            
            title({'(c) Difference in average TDE' ...
                'at interval offset between' 'easy and near-boundary' ...
                'short intervals'})
            
        end
        
    end
    
    xlabel('Interval duration')
    ylabel('TDE')
    
    xticks([4 15 24])
    xticklabels([4 15 24]/10)
    
    axis square
    set(gca,'TickDir','out');
    
end

CAXES_LIST = {[2 4], [-1 3], [-1 3]};

cmprs_str = {'Efficient', 'Intermediate', 'Unambiguous'};
ttl_str = { '(d)', '(g)', '(j)', ...
            '(e)', '(h)', '(k)', ...
            '(f)', '(i)', '(l)'};
ttl_indx = 1;

for indxq = 1:3
    
    for cmprsIdx = CMPRS_LST
        
        subplot(numRows, numCol, ...
            indxq + ((find(cmprsIdx == CMPRS_LST))*numCol))
        
        imagesc(  squeeze(meq(indxq,cmprsIdx,:,epsIdx,1:end-2))   )
        
        if cmprsIdx == 1
        hold on
        plot(alphaIdx, sigIdx, 'r*')
        end
        
        axis square
        set(gca,'TickDir','out');
        
        xlabel('Temporal variability (\sigma)')
        ylabel('Stochasticity of policy (\alpha)')
        
        title(ttl_str{ttl_indx})
        
        % colormap([1 1 1; cbrewer('div', 'RdBu', 50)]) % 'YlGnBu'
        colormap([1 1 1; cbrewer('seq', 'YlGnBu', 50)]) % 'YlGnBu'
        colorbar
        caxis(CAXES_LIST{indxq})
        
        indx_xticks = [1 (ceil(size(meq,5)/2))-1 size(meq,5)-2];
        xticks(indx_xticks)
        xticklabels(SIG(indx_xticks))
        xtickangle(45)
        
        indx_yticks = [1 ceil(size(meq,3)/2) size(meq,3)];
        yticks(indx_yticks)
        yticklabels(ALPHA(indx_yticks))
        ytickangle(45)
        
        if indxq == 1
            
            XL = xlim;
            YL = ylim;
            text(XL(1)-(XL(2)-XL(1))*.6, YL(2), ...
                {cmprs_str{cmprsIdx} 'representation'}, ...
                'FontWeight', 'bold', 'rotation', 90)
        end
        
        ttl_indx = ttl_indx + 1;
        
    end
    
end



%%

COLORS = GET_DEFAULT_MATLAB_LINE_COLORS;
COLORS(4,:) = [];

numRows = numel(CMPRS_LST)+ 1;
numCol = 3;

figure

for iq = 1:3
    
    subplot(numRows,numCol,iq)
    hold on
    
    for ich = 1:2
        
        plot(TASK{1}.stim_set, nanmean(res.avgRT(:,ich,:),3), ...
            'color', COLORS(ich, :), 'linewidth', 1)
        
        if iq == 1
            
            avgRTshortCh = nanmean(nanmean(res.avgRT(:,1,:)));
            avgRTlongCh = nanmean(nanmean(res.avgRT(:,2,:)));
            
            plot(TASK{1}.stim_set, avgRTshortCh*ones(nStim,1), '--', ...
                'color', COLORS(1, :), 'linewidth', 2)
            
            plot(TASK{1}.stim_set, avgRTlongCh*ones(nStim,1), '--', ...
                'color', COLORS(2, :), 'linewidth', 2)
            
            title({'(a) Difference in average' 'response times between' ...
                'all long and short choices'})
            
        elseif iq == 2
            
            avgRTshortIlongC = nanmean(nanmean(res.avgRT(1:3,2,:)));
            avgRTlongIlongC = nanmean(nanmean(res.avgRT(4:6,2,:)));

            plot(TASK{1}.stim_set(1:3), avgRTshortIlongC*ones(3,1),  '--', ...
                'color', COLORS(2, :), 'linewidth', 2)
            
            plot(TASK{1}.stim_set(4:6), avgRTlongIlongC*ones(3,1),  '--', ...
                'color', COLORS(2, :), 'linewidth', 2)
                        
            title({'(b) Difference in average' 'response times between' ...
                'long and short intervals' 'for long choices'})
            
        elseif iq == 3
            
            avgRTshortIshortC = nanmean(nanmean(res.avgRT(1:3,1,:)));
            avgRTlongIshortC = nanmean(nanmean(res.avgRT(4:6,1,:)));
            
            plot(TASK{1}.stim_set(1:3), avgRTshortIshortC*ones(3,1),  '--', ...
                'color', COLORS(1, :), 'linewidth', 2)
            
            plot(TASK{1}.stim_set(4:6), avgRTlongIshortC*ones(3,1),  '--', ...
                'color', COLORS(1, :), 'linewidth', 2)
            
            title({'(c) Difference in average' 'response times between' ...
                'long and short intervals' 'for short choices'})
            
        end
        
    end
    
    xlabel('Interval duration')
    ylabel('Average response time')
    
    xlim([4 26])
    ylim([1 4.5])
    
    xticks([4 15 24])
    xticklabels([4 15 24]/10)
    
    axis square
    set(gca,'TickDir','out');
    
end


CAXES_LIST = {[-1 3], [-1 3], [-1 3]};
ttl_str = { '(d)', '(g)', '(j)', ...
            '(e)', '(h)', '(k)', ...
            '(f)', '(i)', '(l)'};
ttl_indx = 1;

for indxq = 1:3
    
    for cmprsIdx = CMPRS_LST
        
        subplot(numRows, numCol, ...
            indxq + ((find(cmprsIdx == CMPRS_LST))*numCol))
        
        imagesc(  squeeze(meq(indxq+5,cmprsIdx,:,epsIdx,1:end-2))   )
        
        if cmprsIdx == 1
        hold on
        plot(alphaIdx, sigIdx, 'r*')
        end
        
        axis square
        set(gca,'TickDir','out');
        
        xlabel('Temporal variability')
        ylabel('Stochasticity of policy')
        
        title(ttl_str{ttl_indx})
        
        colormap([1 1 1; cbrewer('seq', 'YlGnBu', 50)]) % 'YlGnBu'
        colorbar
        % c = colorbar('ticks', [0 .5 1], 'ticklabels', [0 .5 1], 'box', 'off');
        caxis([-.3 2])
        
        indx_xticks = [1 (ceil(size(meq,5)/2))-1 size(meq,5)-2];
        xticks(indx_xticks)
        xticklabels(SIG(indx_xticks))
        xtickangle(45)
        
        indx_yticks = [1 ceil(size(meq,3)/2) size(meq,3)];
        yticks(indx_yticks)
        yticklabels(ALPHA(indx_yticks))
        ytickangle(45)
        
        if indxq == 1
            
            XL = xlim;
            YL = ylim;
            text(XL(1)-(XL(2)-XL(1))*.6, YL(2), ...
                {cmprs_str{cmprsIdx} 'representation'}, ...
                'FontWeight', 'bold', 'rotation', 90)
        end
        
        ttl_indx = ttl_indx + 1;
        
    end
    
end


%%

COLORS = GET_DEFAULT_MATLAB_LINE_COLORS;
COLORS(4,:) = [];

figure

numRows = numel(CMPRS_LST) + 1;
numCol = 3;

for iq = 1:2
    
    subplot(numRows,numCol,numCol-iq)
    hold on
    
    for ibin = 2:-1:1
        
        plot(TASK{1}.stim_set, nanmean(res.psychCrvs(:,ibin,:),3), '.', ...
            'color', COLORS(ibin+2, :), 'markersize', 10)
        
        y = nanmean(res.psychCrvs(:, ibin, :),3);        
        b = glmfit(TASK{1}.stim_set,y,'binomial','link','logit');
        curve = glmval(b, TASK{1}.stim_set, 'logit');
        
        plot(TASK{1}.stim_set, curve, 'color', COLORS(ibin+2, :), ...
            'linewidth', 2)
        
        target = [.25 .5 .75];
        threshold = (log(target./(1-target))-b(1))/b(2);
        
        if iq == 1
            
            plot(threshold([1 3]), target([1 3]), ...
                'color', COLORS(ibin+2, :), 'linewidth', 5)
            
            for indx = [1 3]
                
                XL = xlim;
                plot([XL(1) threshold(indx)], target(indx)*ones(2,1), '--', ...
                    'color', COLORS(ibin+2, :))
                
                plot(threshold(indx)*ones(2,1), [0 target(indx)], '--', ...
                    'color', COLORS(ibin+2, :))
                
            end
            
            title({'(b) Difference in sensitivity of' 'psychometric functions for' ...
                'trials with high or low TDE'})
            
        elseif iq == 2
            
            plot(threshold(2), target(2), 'o', 'markersize', 10, ...
                'markeredgecolor', COLORS(ibin+2, :), ...
                'markerfacecolor', COLORS(ibin+2, :))
            
            XL = xlim;
            plot([XL(1) threshold(2)], target(2)*ones(2,1), '--', ...
                'color', COLORS(ibin+2, :))
            
            plot(threshold(2)*ones(2,1), [0 target(2)], '--', ...
                'color', COLORS(ibin+2, :))
            
            title({'(a) Difference in bias of' 'psychometric functions for' ...
                'trials with high or low TDE'})
            
        end
        
    end
    
    axis square
    set(gca,'TickDir','out');
    
    xlabel('Interval duration')
    ylabel('Probability of long choice')
    
    xticks([4 15 24])
    xticklabels([4 15 24]/10)
    
end

ttl_str = { '(d)', '(f)', '(h)', ...
            '(c)', '(e)', '(g)'};
ttl_indx = 1;
    
CAXES_LIST = {[0 4], [0 4]};

for indxq = 1:2
    
    for cmprsIdx = CMPRS_LST
        
        subplot(numRows, numCol, ...
            (numCol-indxq) + ((find(cmprsIdx == CMPRS_LST))*numCol))
        
        imagesc(  abs(squeeze(meq(indxq+3,cmprsIdx,:,epsIdx,1:end-2)))   )
        
        if cmprsIdx == 1
        hold on
        plot(alphaIdx, sigIdx, 'r*')
        end
        
        axis square
        set(gca,'TickDir','out');
        
        xlabel('Temporal variability')
        ylabel('Stochasticity of policy')
        
        title(ttl_str{ttl_indx})
        
        colormap([1 1 1; cbrewer('seq', 'YlGnBu', 50)]) % 'YlGnBu'
        colorbar
        caxis(CAXES_LIST{indxq})
        
        indx_xticks = [1 (ceil(size(meq,5)/2))-1 size(meq,5)-2];
        xticks(indx_xticks)
        xticklabels(SIG(indx_xticks))
        xtickangle(45)
        
        indx_yticks = [1 ceil(size(meq,3)/2) size(meq,3)];
        yticks(indx_yticks)
        yticklabels(ALPHA(indx_yticks))
        ytickangle(45)
        
        if indxq == 2
            
            XL = xlim;
            YL = ylim;
            text(XL(1)-(XL(2)-XL(1))*.6, YL(2), ...
                {cmprs_str{cmprsIdx} 'representation'}, ...
                'FontWeight', 'bold', 'rotation', 90)
        end
        
        ttl_indx = ttl_indx + 1;
        
    end
    
end


clc


