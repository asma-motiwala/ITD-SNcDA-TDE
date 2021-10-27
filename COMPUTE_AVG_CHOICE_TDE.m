

function [avgChoiceTDE] = COMPUTE_AVG_CHOICE_TDE(TASK, labels)

avgChoiceTDE = nan(numel(TASK.stim_set), 1);

for istim = 1:numel(TASK.stim_set)
    
    indx = labels.stim == TASK.stim_set(istim) & ...
        labels.reward == TASK.Rc;
    avgChoiceTDE(istim) = nanmean(labels.choiceTDE(indx));
    
end

end


