

function [TASK, AGENT, agent, labels] =  RUN_TASK_V9_3(AGENT_, agent_)


[AGENT, TASK] = SET_PARAMETERS;

%% INITIALISE

[AGENT, agent, task, action] = INITIALISE_AGENT_AND_TASK(AGENT, TASK);

% Initialise logs
labels.init = 1;
labels.tde  = nan(AGENT.T_max, TASK.N);
labels.V    = [];
% tde         = [];

%% OVERWRITE ANY RELEVANT PARAMETERS OR VARIABLES

if nargin > 0
    AGENT = OVERWRITE(AGENT, AGENT_);
    agent = OVERWRITE(agent, agent_);
end

%% RUN TASK

while task.n < TASK.N
    
    %% UPDATE TASK VARIABLES AND DETERMINE TASK FEEDBACK
    
    [task, cue, labels] = UPDATE_TASK(TASK, task, action, labels);
    
    %% UPDATE AGENT VARIABLES
    
    [agent, labels] = UPDATE_AGENT_A3(AGENT, agent, cue, action, labels);
    
    %% SAMPLE AN ACTION FROM THE POLICY DISTRIBUTION 
    
    p_ = [0; agent.p(:,agent.ss(1),agent.ss(2))];
    p_(end) = [];
    
    action = sum( cumsum(p_) < rand );
    
end

[labels]    = FIX_NUM_ELEMENTS(labels);

end

