


fldr_name = 'saved_variables_RCnE/';
v = 9; 

load([fldr_name 'v9' '_allParam.mat'])

fname = [fldr_name 'v' num2str(v) '_pooled_rcne'];
load(fname, 'rcne', 'allV_hat', 'allP_hat')

LEFT    = 0;
BOTTOM  = 0;
SCALE   = 250;
UNITS   = 'points';
DPI     = 800;

%%

clrs = GET_DEFAULT_MATLAB_LINE_COLORS;
clrmp = [1 1 1; cbrewer('seq', 'Greens', 50)];

N_COLMN = 2;
N_ROWS  = 4;
WIDTH   = 1.25*N_COLMN*SCALE;
HEIGHT  = N_ROWS*SCALE;

fig_name = 'pooled_RCnE';

figure('Name', fig_name, 'NumberTitle', 'off', ...
    'WindowStyle', 'normal', 'Position', [LEFT BOTTOM WIDTH HEIGHT], ...
    'Units', UNITS);

subplot(4,2,2)
imagesc(flipud(allV_hat{1}(1:end-1,1:end-1)'))
colormap(clrmp)
axis square
box off

ytcks = 35 - [24 15 6];
xticks([6 15 24])
yticks(ytcks)

xticklabels([6 15 24]/10)
yticklabels(ytcks/10)

colorbar
xlabel({'Estimated time since' 'interval onset (sec)'}')
ylabel({'Estimated time since' 'interval offset (sec)'}')
set(gca,'TickDir','out');

title({'Value function approximation' 'using efficent representation'}')

subplot(4,2,1)
imagesc(flipud(allV_hat{numel(CMPRS)}(1:end-1,1:end-1)'))
colormap(clrmp)
axis square
box off

xticks([6 15 24])
yticks(ytcks)

xticklabels([6 15 24]/10)
yticklabels(ytcks/10)

colorbar
xlabel({'Estimated time since' 'interval onset (sec)'}')
ylabel({'Estimated time since' 'interval offset (sec)'}')
set(gca,'TickDir','out');

title({'Value function approximation' 'using unambiguous representation'}')

subplot(4,2,[3 4])
hold on

im_list = [1 3:5];

for im = im_list 
    
    for ic = 1: numel(CMPRS)
    errorbar(1-CMPRS(ic), mean(rcne{ic}(:,im)) / mean(rcne{1}(:,im)), ...
        std((rcne{ic}(:,im))) / mean(rcne{1}(:,im)), ...
        'color', clrs(im == im_list,:))
    plot(1-CMPRS(ic), mean(rcne{ic}(:,im)) / mean(rcne{1}(:,im)), ... 
        'o', 'color', clrs(im == im_list,:), ...
        'markerfacecolor', clrs(im == im_list,:))
    end
    
end

xlabel('Compression paramter')
ylabel('Normalised MSE')
set(gca,'TickDir','out');

YL = ylim;
YL(1) = max(YL(1),0);
ylim(YL)
text(.0, YL(2)-(YL(2)-YL(1))*.10,'Value function','color',clrs(1,:))
text(.0, YL(2)-(YL(2)-YL(1))*.20,'Short choice','color',clrs(2,:))
text(.0, YL(2)-(YL(2)-YL(1))*.30,'Wait action','color',clrs(3,:))
text(.0, YL(2)-(YL(2)-YL(1))*.40,'Long choice','color',clrs(4,:))
xlim([-.1 1.1])

subplot(4,2,[5 6])
hold on 

im_list = 9;

for im = im_list 

    for ic = 1: numel(CMPRS)
    errorbar(1-CMPRS(ic), mean(rcne{ic}(:,im)), ... 
        std((rcne{ic}(:,im))), ... 
        'color', 'k')
    plot(1-CMPRS(ic), mean(rcne{ic}(:,im)), ... 
        'o', 'markerfacecolor', 'k', 'color', 'k')
    end
    
end

xlabel('Compression paramter')
ylabel('Overall rewards obtained')
set(gca,'TickDir','out');

xlim([-.1 1.1])
ylim([2 3])

subplot(4,2,[7 8])
hold on

im_list = [2 6:8];

for im = im_list % 1:3
    
    for ic = 1: numel(CMPRS)
    errorbar(1-CMPRS(ic), mean(rcne{ic}(:,im)), std((rcne{ic}(:,im))), ...
        'color', clrs(im == im_list,:))
    plot(1-CMPRS(ic), mean(rcne{ic}(:,im)), ... 
        'o', 'color', clrs(im == im_list,:), ...
        'markerfacecolor', clrs(im == im_list,:))
    end
    
end

xlabel('Compression paramter')
ylabel('Entropy of coefficients')
set(gca,'TickDir','out');

xlim([-.1 1.1])
YL = ylim;
text(.9, YL(2)-(YL(2)-YL(1))*.10,'Value function','color',clrs(1,:))
text(.9, YL(2)-(YL(2)-YL(1))*.20,'Short choice','color',clrs(2,:))
text(.9, YL(2)-(YL(2)-YL(1))*.30,'Wait action','color',clrs(3,:))
text(.9, YL(2)-(YL(2)-YL(1))*.40,'Long choice','color',clrs(4,:))



%% Plot two example loss functions as a function of compression parameter


indx = {[1 2], [9 2]};
sgn = [1 -1];

a = 0:.05:1;
temp_colors = cbrewer('div', 'BrBG', numel(a));

fig_name = 'exmpl_loss';

N_COLMN = 2;
N_ROWS  = 1;
WIDTH   = 1.25*N_COLMN*SCALE;
HEIGHT  = N_ROWS*SCALE;

figure('Name', fig_name, 'NumberTitle', 'off', ...
    'WindowStyle', 'normal', 'Position', [LEFT BOTTOM WIDTH HEIGHT], ...
    'Units', UNITS);


for id = 1:numel(indx)
    
    subplot(1,2,id)
    hold on
    
    for iw = 1:numel(a)
        
        l1 = nan(numel(CMPRS),1);
        
        for ic = 1: numel(CMPRS)
            
            % Compute loss
            l1(ic) = sgn(id) * (1-a(iw))*mean(rcne{ic}(:,indx{id}(1))) + ...
                (a(iw) * mean(rcne{ic}(:,indx{id}(2))));
            
        end
        
        plot(1-CMPRS, l1, 'color', temp_colors(iw,:), 'linewidth',1)
        
    end
    
    axis square
    set(gca,'TickDir','out');
    
    xlabel('Compression paramter')
    ylabel('Loss function')
    
    xticks([0 .5 1])
    xticklabels([0 .5 1])
    
    xlim([-.02 1])
    
    YL = ylim;
    yticks(YL)
    yticklabels(YL)
    
    colormap(temp_colors)
    c = colorbar('ticks', [0 .5 1], 'ticklabels', [0 .5 1], 'box', 'off');
    c.Label.String = 'Weight (a)';
end