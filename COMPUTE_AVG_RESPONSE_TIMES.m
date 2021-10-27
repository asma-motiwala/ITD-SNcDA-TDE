

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
    
    indxStim = (labels.stim == stimSet(istim)) & ...
        (labels.premature == 0);
    
    indxS = (labels.stim == stimSet(istim)) & ...
        (labels.premature == 0) & (labels.choice == choices(1));
    if sum(indxS)/sum(indxStim) > AGENT.eps
        avgRT(istim, 1) = mean(a(indxS));
    end
    
    indxL = (labels.stim == stimSet(istim)) & ...
        (labels.premature == 0) & (labels.choice == choices(2));
    if sum(indxL)/sum(indxStim) > AGENT.eps
        avgRT(istim, 2) = mean(a(indxL));
    end
    
end

end


