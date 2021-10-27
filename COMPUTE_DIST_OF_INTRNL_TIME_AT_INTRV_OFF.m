

function [P] = COMPUTE_DIST_OF_INTRNL_TIME_AT_INTRV_OFF(AGENT, TASK, T)

%%

SIG     = AGENT.dt_std;
P       = nan(numel(T), numel(TASK.stim_set));

for istim = 1:numel(TASK.stim_set)
    
    stim        = TASK.stim_set(istim);
    
%     P(:,istim)  = T .* exp( - (log(T/stim).^2) ./ ...
%                     (2*SIG^2) ); 
                
    P(:,istim)  = exp( - (T-stim).^2 ./ (2*(SIG*stim)^2) ); 
    P(:,istim)  = P(:,istim)/sum(P(:,istim));
    
end
