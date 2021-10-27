

function [res] = POOL_RESULTS()

load output.mat
clearvars -except CMPRS numRepeats TASK AGENT agent labels

nSTIM   = numel(TASK{1,1}.stim_set);

res.avgSecToneTDE = nan(nSTIM, numel(CMPRS), numRepeats);
res.avgChoiceTDE  = nan(nSTIM, numel(CMPRS), numRepeats);
res.psychCrvsDiff = nan(nSTIM, numel(CMPRS), numRepeats);
res.avgRT         = nan(nSTIM*2, numel(CMPRS), numRepeats);
res.valueFunction = nan((AGENT{1,1}.T_max+1)*2, numel(CMPRS), numRepeats);
res.avgV          = nan(AGENT{1,1}.T_max+1, AGENT{1,1}.T_max+1, numel(CMPRS));

for icmprs = 1:numel(CMPRS)
    
    temp = nan(AGENT{1,1}.T_max+1, AGENT{1,1}.T_max+1, numRepeats);
    
    for irun = 1:numRepeats
        
        avgSecToneTDE = COMPUTE_AVG_SEC_TONE_TDE(...
            TASK{icmprs, irun}, labels{icmprs, irun});
        
        avgChoiceTDE = COMPUTE_AVG_CHOICE_TDE(...
            TASK{icmprs, irun}, labels{icmprs, irun});
        
        psychCrvs = COMPUTE_BINNED_PSYCH_CRVS( ...
            TASK{icmprs, irun}, labels{icmprs, irun});
        psychCrvsDiff = psychCrvs(:,1) - psychCrvs(:,2);
        
        avgRT = COMPUTE_AVG_RESPONSE_TIMES(...
            AGENT{icmprs, irun}, labels{icmprs, irun});
        avgRT = reshape(avgRT, [nSTIM*2 1]);
        
        res.avgSecToneTDE(:, icmprs, irun) = avgSecToneTDE;
        res.avgChoiceTDE(:, icmprs, irun)  = avgChoiceTDE;
        res.psychCrvsDiff(:, icmprs, irun) = psychCrvsDiff;
        res.avgRT(:, icmprs, irun)         = avgRT;
        
        res.valueFunction(:, icmprs, irun) = ...
            [   agent{icmprs, irun}.V(:,1);  ...
                agent{icmprs, irun}.V(:,2)  ];
            
        temp(:,:,irun) = agent{icmprs, irun}.V;
        
    end
    
    res.avgV(:,:,icmprs) = nanmean(temp,3);
    
end

TASK_ = TASK{1,1};
AGENT_ = AGENT{1,1};

VERSION     = 9;
fname = [ 'POOLED_RES_v' num2str(VERSION) '_alpha_' num2str(AGENT{1,1}.alpha*100) ...
    '_gamma_'       num2str(AGENT{1,1}.gamma*100) ...
    '_dt_scale_'    num2str(AGENT{1,1}.dt_std*100)];

save(fname, 'res', 'CMPRS', 'TASK_', '-v7.3')

end

%%

function [avgSecToneTDE] = COMPUTE_AVG_SEC_TONE_TDE(TASK, labels)

avgSecToneTDE = nan(numel(TASK.stim_set), 1);

for istim = 1:numel(TASK.stim_set)
    
    indx = labels.stim == TASK.stim_set(istim) & ...
        labels.reward == TASK.Rc;
    avgSecToneTDE(istim) = nanmean(labels.secToneTDE(indx));
    
end

end

function [avgChoiceTDE] = COMPUTE_AVG_CHOICE_TDE(TASK, labels)

avgChoiceTDE = nan(numel(TASK.stim_set), 1);

for istim = 1:numel(TASK.stim_set)
    
    indx = labels.stim == TASK.stim_set(istim) & ...
        labels.reward == TASK.Rc;
    avgChoiceTDE(istim) = nanmean(labels.choiceTDE(indx));
    
end

end

function [psychCrvs] = COMPUTE_BINNED_PSYCH_CRVS(TASK, labels)

STIM_SET = TASK.stim_set;
NUM_BINS = 2;

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

choice_long = max(labels.choice);

psychCrvs = nan(numel(STIM_SET), NUM_BINS);

for ibin = [1 2] 
    
    for istim = 1:numel(STIM_SET)
        
        indx = labels.stim == STIM_SET(istim) & bin == ibin & labels.choice ~= 0;
        psychCrvs(istim, ibin) = nanmean(labels.choice(indx) == choice_long);
        
    end
    
end

end

function [avgRT] = COMPUTE_AVG_RESPONSE_TIMES(AGENT, labels)

a = labels.choiceTime - labels.init - labels.stim;
stimSet = unique(labels.stim);
stimSet(stimSet == 0) = [];

if isfield(AGENT, 'nA')
    choices = [1 AGENT.nA];
else
    choices = [1 AGENT.num_actions];
end

avgRT = nan(numel(stimSet), 2);

for istim = 1:numel(stimSet)
    
    indxS = (labels.stim == stimSet(istim)) & ...
        (labels.premature == 0) & (labels.choice == choices(1));
    avgRT(istim, 1) = mean(a(indxS));
    
    indxL = (labels.stim == stimSet(istim)) & ...
        (labels.premature == 0) & (labels.choice == choices(2));
    avgRT(istim, 2) = mean(a(indxL));
    
end

end



