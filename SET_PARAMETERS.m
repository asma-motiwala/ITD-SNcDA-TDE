

function [AGENT, TASK] = SET_PARAMETERS()

%%

TASK.N = 10000; % Number of trials

TASK.ref_delay      = 15;
TASK.stim_set       = [6 11 13 17 19 24]; % [6 9 12 13 17 18 21 24]; % 
TASK.max_resp_time  = 15;

TASK.dt = 1; % .25;

TASK.Rc = 10;
TASK.Ri = -2;
TASK.Rp = -5; % -1;

TASK.feedback_correct   = TASK.Rc;
TASK.feedback_incorrect = TASK.Ri;
TASK.iti = TASK.stim_set(end) + TASK.max_resp_time;

%%

AGENT.dt_std    = .35; % .08;
AGENT.T_max     = 34; % ceil(  max_iti * AGENT.dt_range(2)  ) + 1;

AGENT.cmprs     = 1; % 0;

AGENT.gamma = .95;  % Temporal discounting factor
AGENT.eps   = .10;  % Random exploration probability
AGENT.alpha = .45; % 3;    % Stochasticity parameter for policy softmax function

AGENT.N_V   = 100;  % Number of trials over which to estimate state value function 
AGENT.N_A   = 1000; % Number of trials over which to estimate advantage function 

% NOTE: Updates of the actor should operate on a slower time scale than
% those of the critic to ensure that the critic has enough time to evaluate
% the current policy.

AGENT.psp   = 0.00; % .001; % Premature switch probability

% Determine which actions of the agent register as choices.
AGENT.nA        = 5;
TASK.choices    = [1 AGENT.nA];

end



