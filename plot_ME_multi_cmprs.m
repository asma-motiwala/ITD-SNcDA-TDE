

% load('POOLED_RES_v9_alpha_300_gamma_98_dt_scale_25.mat')

nSTIM   = numel(TASK_.stim_set);
nX      = numel(CMPRS);

LEFT    = 0;
BOTTOM  = 0;
SCALE   = 300;
WIDTH   = 2*SCALE;
HEIGHT  = 1*SCALE;
UNITS   = 'points';

DPI = 600;

%% PLOT_AVG_SEC_TONE_TDE_MULTI_CMPRS

h_avg_offset_rpe = figure('NumberTitle', 'off', ... 'Name', fname, 
    'WindowStyle', 'normal', 'Position', [LEFT BOTTOM 2*SCALE SCALE], ...
    'Units', UNITS);

indx_Xtick = [1 ceil(nX*.3)+1 ceil(nX*.6)+1 nX];

avgSecToneTDE = squeeze(mean(res.avgSecToneTDE, 3));
avgSecToneTDE(isnan(avgSecToneTDE)) = 0;
imagesc(fliplr(avgSecToneTDE))

set(gca, 'Xtick', indx_Xtick)
set(gca, 'Xticklabels', CMPRS(indx_Xtick))

set(gca, 'Ytick', 1:nSTIM)
set(gca, 'Yticklabels', TASK_.stim_set/10)

xlabel('Degree of compression along second dimension of latent variable (\lambda)')
ylabel('Interval duration (sec)')

title('Average RPE at interval offset')

colormap(cbrewer('seq', 'BuGn', 50))
caxis([1 4])
colorbar    
box off

ax = gca;
ax.TickDir = 'out';

% save2pdf([FIGS_FOLDER 'AvgOffsetRPE_' fname], h_avg_offset_rpe, DPI)

%% PLOT_PSYCH_CRVS_DIFF_MULTI_CMPRS

h_psych_crvs_diff = figure('NumberTitle', 'off', ... 'Name', fname, 
    'WindowStyle', 'normal', 'Position', [LEFT BOTTOM WIDTH HEIGHT], ...
    'Units', UNITS);

indx_Xtick = [1 ceil(nX*.3)+1 ceil(nX*.6)+1 nX];

psychCrvsDiff = squeeze(mean(res.psychCrvsDiff, 3));
psychCrvsDiff(isnan(psychCrvsDiff)) = 0;
imagesc(fliplr(psychCrvsDiff))

set(gca, 'Xtick', indx_Xtick)
set(gca, 'Xticklabels', CMPRS(indx_Xtick))

set(gca, 'Ytick', 1:nSTIM)
set(gca, 'Yticklabels', TASK_.stim_set/10)

xlabel('Degree of compression along second dimension of latent variable (\lambda)')
ylabel('Interval duration (sec)')

title('Difference between psychometric function')

colormap(cbrewer('div', 'BrBG', 50))
caxis([-.15 .15])
colorbar
box off

ax = gca;
ax.TickDir = 'out';

% save2pdf([FIGS_FOLDER 'PsychCrvs_' fname], h_psych_crvs_diff, DPI)

%% PLOT_AVG_RT_MULTI_CMPRS

h_avg_rts = figure('NumberTitle', 'off', ... 'Name', fname, 
    'WindowStyle', 'normal', 'Position', [LEFT BOTTOM WIDTH HEIGHT], ...
    'Units', UNITS);

indx_Xtick = [1 ceil(nX*.3)+1 ceil(nX*.6)+1 nX];

avgRT = squeeze(mean(res.avgRT, 3));
% avgRT(isnan(avgRT)) = 0;
avgRT((nSTIM+1):end, :) = - avgRT((nSTIM+1):end, :);

imagesc(fliplr(avgRT))

set(gca, 'Xtick', indx_Xtick)
set(gca, 'Xticklabels', CMPRS(indx_Xtick))

set(gca, 'Ytick', [1:nSTIM nSTIM+(1:nSTIM)])
set(gca, 'Yticklabels', [TASK_.stim_set/10 TASK_.stim_set/10])

xlabel('Degree of compression along second dimension of latent variable (\lambda)')
ylabel('Interval duration (sec)')

title('Average response times')

colormap(cbrewer('div', 'RdBu', 50))
caxis([-1 1]*5)
colorbar
box off

ax = gca;
ax.TickDir = 'out';

% save2pdf([FIGS_FOLDER 'AvgRTs_' fname], h_avg_rts, DPI)




