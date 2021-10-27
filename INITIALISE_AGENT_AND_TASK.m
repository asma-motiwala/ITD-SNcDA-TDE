

function [AGENT, agent, task, action] = INITIALISE_AGENT_AND_TASK(AGENT, TASK)

%  Agent's internal variables

agent.dt = TASK.dt;
agent.t  = agent.dt;
agent.t2 = 0;

agent.s  = nan;     % Current state % agent.cs
agent.ss = [1, 1];  % Future state  % agent.fs

agent.sT = [AGENT.T_max + 1, AGENT.T_max + 1];    % Terminal state

agent.V  = zeros( AGENT.T_max + 1, AGENT.T_max + 1 );
agent.A  = zeros(AGENT.nA,  AGENT.T_max + 1, AGENT.T_max + 1 );
agent.p  = ones(AGENT.nA,  AGENT.T_max + 1, AGENT.T_max + 1 )/AGENT.nA;

% agent.history_V = [];

% Log number of updates for each state and state-action pair
agent.nuV  = zeros( AGENT.T_max + 1, AGENT.T_max + 1 );
agent.nuA  = zeros(AGENT.nA,  AGENT.T_max + 1, AGENT.T_max + 1 );
agent.nuZ  = zeros( AGENT.T_max + 1, AGENT.T_max + 1 );

agent.st = 0;
agent.ch = 0;

agent.tde = 0;
agent.TDE = [];

% Agent's actions
min_ = .01;
max_ = AGENT.nA - min_;
action = ceil( min_ + rand*(max_-min_) );

%%

% Task's internal variables

task.t = TASK.dt;
task.n = 1;
    
task.tsl_ti = 1;
task.tsl_st = 0;
task.tsl_rw = nan;

task.delay  = TASK.stim_set(1);
task.goal   = 1;


end

