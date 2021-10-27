

function [avgSecToneTDE] = COMPUTE_AVG_SEC_TONE_TDE(TASK, labels)

avgSecToneTDE = nan(numel(TASK.stim_set), 1);

for istim = 1:numel(TASK.stim_set)
    
    indx = labels.stim == TASK.stim_set(istim) & ...
        labels.reward == TASK.Rc;
    avgSecToneTDE(istim) = nanmean(labels.secToneTDE(indx));
    
end

end

