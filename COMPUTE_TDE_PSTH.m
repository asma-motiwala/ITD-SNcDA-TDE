

function psth = COMPUTE_TDE_PSTH(TASK, AGENT, labels)

T = AGENT.T_max;

for ireward = 0:1
        
    for istim = numel(TASK.stim_set):-1:1
        
        indx = find(labels.stim == TASK.stim_set(istim) & ...
            labels.reward == ...
            ((ireward==1)*TASK.feedback_correct + ...
            (ireward==0)*TASK.feedback_incorrect));
                
        if nargin > 3
            indx(indx < RANGE(1)) = [];
            indx(indx > RANGE(2)) = [];
        end
        
        temp = nan(T, numel(indx));
        
        for itrial = 1:numel(indx)
            
%             a = (labels.init(indx(itrial))/TASK.dt) + WIN_SIZE;
%             b = a(1)+1 : min(a(2),numel(tde));
            
            temp(:, itrial) = labels.tde(1:T,indx(itrial));
            
        end
                    
        if sum(indx) > 0
            psth(:, istim, ireward+1) = nanmean(temp, 2);

        else
            psth(:, istim, ireward+1) = zeros(T, 1);
        end
        
    end
        
end

end
