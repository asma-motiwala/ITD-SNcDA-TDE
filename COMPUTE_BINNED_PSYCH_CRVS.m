

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

