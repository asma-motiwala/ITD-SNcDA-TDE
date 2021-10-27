

function [q,res] = COMPUTE_MAIN_EFFECT_QUANT(TASK, AGENT, Agent, Labels)


STIM_SET = TASK{1}.stim_set;

nSTIM       = numel(STIM_SET);
numRepeats  = numel(Agent);

res.avgSecToneTDE = nan(nSTIM, numRepeats);
res.avgChoiceTDE  = nan(nSTIM, numRepeats);
res.psychCrvs     = nan(nSTIM, 2, numRepeats);
res.psychCrvsDiff = nan(nSTIM, numRepeats);
res.avgRT         = nan(nSTIM, 2, numRepeats);
res.avgV          = nan(AGENT{1}.T_max*2, numRepeats);
res.avgLP         = nan(AGENT{1}.T_max*2, 3, numRepeats);
res.TDEpsth       = nan(AGENT{1}.T_max, nSTIM, 2, numRepeats);

%%

for irun = 1:numRepeats
    
    avgSecToneTDE = COMPUTE_AVG_SEC_TONE_TDE(...
        TASK{irun}, Labels{irun});
    
    avgChoiceTDE = COMPUTE_AVG_CHOICE_TDE(...
        TASK{irun}, Labels{irun});
    
    psychCrvs = COMPUTE_BINNED_PSYCH_CRVS( ...
        TASK{irun}, Labels{irun});
    psychCrvsDiff = psychCrvs(:,1) - psychCrvs(:,2);
    
    avgRT = COMPUTE_AVG_RESPONSE_TIMES(...
        AGENT{irun}, Labels{irun});
    
    psth = COMPUTE_TDE_PSTH(TASK{irun}, AGENT{irun}, Labels{irun});
    
    res.avgSecToneTDE(:, irun) = avgSecToneTDE;
    res.avgChoiceTDE(:, irun)  = avgChoiceTDE;
    res.psychCrvs(:, :, irun)  = psychCrvs;
    res.psychCrvsDiff(:, irun) = psychCrvsDiff;
    res.avgRT(:, :, irun)      = avgRT;
    res.TDEpsth(:, :, :, irun) = psth;
    
    res.avgV(:, irun) = Labels{irun}.Vavg(:,end);
    
end

%% Compute quantifications for main effects

q = nan(8,1);

%  Difference in average TDEs at interval offset between short and long
%   intervals

avgTDEshort = mean(mean(res.avgSecToneTDE(1:3,:)));
avgTDElong = mean(mean(res.avgSecToneTDE(4:6,:)));
q(1) = avgTDEshort - avgTDElong;

%  Difference in average TDEs at interval offset between easy and
%   near-boundary intervals for short intervals

avgTDEeasyShort = mean(res.avgSecToneTDE(1,:));
avgTDEnearBoundaryShort = mean(res.avgSecToneTDE(3,:));

q(2) = avgTDEeasyShort - avgTDEnearBoundaryShort;

%  Difference in average TDEs at interval offset between easy and
%   near-boundary intervals for long intervals

avgTDEeasyLong = mean(res.avgSecToneTDE(6,:));
avgTDEnearBoundaryLong = mean(res.avgSecToneTDE(4,:));

q(3) = avgTDEeasyLong - avgTDEnearBoundaryLong;

% Fit a psychometric function 

y1 = nanmean(res.psychCrvs(:, 1, :),3);
y2 = nanmean(res.psychCrvs(:, 2, :),3);

b1 = glmfit(STIM_SET,y1,'binomial','link','logit');
b2 = glmfit(STIM_SET,y2,'binomial','Link','logit');

targets = [.25 .5 .75]; 

thresholds1 = (log(targets./(1-targets))-b1(1))/b1(2);
thresholds2 = (log(targets./(1-targets))-b2(1))/b2(2);

%  Difference in discrimination sensitivity between psychometric curve for 
%   low and high TDE at interval offset

senstv1 = (thresholds1(3) - thresholds1(1));
senstv2 = (thresholds2(3) - thresholds2(1));

q(4) = senstv2 - senstv1; %%%% TO DO: CHECK, this a placeholder

%  Difference in offset between psychometric curve for low and high TDE at
%   interval offset

q(5) = thresholds2(2) - thresholds1(2); 

%  Difference in average RTs for all long vs short choices

avgRTshortCh = nanmean(nanmean(res.avgRT(:,1,:)));
avgRTlongCh = nanmean(nanmean(res.avgRT(:,2,:)));

q(6) = avgRTlongCh - avgRTshortCh;

%  Difference between average RTs for all long vs short intervals 
%   for long choices 

avgRTshortIlongC = nanmean(nanmean(res.avgRT(1:3,2,:)));
avgRTlongIlongC = nanmean(nanmean(res.avgRT(4:6,2,:)));

q(7) = avgRTshortIlongC - avgRTlongIlongC;

%  Difference between average RTs for all long vs short intervals 
%   for short choices 

avgRTshortIshortC = nanmean(nanmean(res.avgRT(1:3,1,:)));
avgRTlongIshortC = nanmean(nanmean(res.avgRT(4:6,1,:)));

q(8) = avgRTshortIshortC - avgRTlongIshortC;

end




