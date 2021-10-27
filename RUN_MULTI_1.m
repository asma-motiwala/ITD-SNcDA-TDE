

function [TASK, AGENT, agent, labels] = RUN_MULTI_1(AGENT_, NUM_SESSIONS)

if nargin < 2
    NUM_SESSIONS = 40;
end

Vdiff = [];
Vevol = [];

%%

AGENT_.dummy = [];
agent_.dummy = [];

for ii = 1:NUM_SESSIONS
    
[TASK, AGENT, agent, labels] = RUN_TASK_V9_1(AGENT_, agent_);

AGENT_ = AGENT;
agent_ = agent;

if ii < NUM_SESSIONS
    
agent_.nuZ  = zeros( AGENT.T_max + 1, AGENT.T_max + 1 );
    
end

disp(['Completed session ' num2str(ii)])

% Vdiff = [Vdiff nanmean((abs(labels.V(:,2:end) - labels.V(:,1:(end-1)))))];
Vevol = [Vevol nanmean(labels.V,2)];

end

%%

% labels.Vdiff = Vdiff;
labels.Vavg  = Vevol; % mean(labels.V,2); 

labels = rmfield(labels,'V');


end