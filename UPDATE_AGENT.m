

function [agent, history] = UPDATE_AGENT(AGENT, agent, cue, action, history)

% Determine state updates in response to task cues
if cue.trialInit == 1
    
    agent.dt    = 1;
    agent.t     = 0;
    agent.t2    = 0;
    agent.st    = 0; 
    agent.ch    = 0;
    
    history.V   = [history.V [agent.V(1:34,1);agent.V(1:34,2)]];
    history.tde(1:numel(agent.TDE), numel(history.choice)) = agent.TDE;
    
    agent.TDE   = [];
    
else
    
    agent.dt    = 1 + randn*AGENT.dt_std*sqrt(agent.t);
    agent.t     = agent.t  + agent.dt;
    agent.t2    = agent.t2 + agent.st*(1 + randn*AGENT.dt_std*sqrt(agent.t));
    
    if cue.secTone == 1
        agent.st = 1;
        agent.t2 = 0;
        history.subj_delay(numel(history.init)) = agent.t;
        
    elseif cue.reward ~= 0
        agent.ch = 1;
    end
        
%     agent.dt    = 1 + randn*AGENT.dt_std*sqrt(agent.t);
%     agent.t     = agent.t  + agent.dt;
%     agent.t2    = agent.t2 + agent.st*(1 + randn*AGENT.dt_std*sqrt(agent.t));
%     
end

% Counter for number of updates
agent.nuZ(   min(ceil(agent.t)+1, AGENT.T_max), ...
            max(min(ceil(agent.t2)+1, AGENT.T_max),1)   ) = ...
    agent.nuZ(   min(ceil(agent.t)+1, AGENT.T_max), ...
            max(min(ceil(agent.t2)+1, AGENT.T_max),1)   ) + 1;


% Determine successor state 
s1 = max(round(agent.t), 1);
t2 = round(agent.t2 * AGENT.cmprs);
s2 = 1 + ...                                % Before interval offset,
    agent.st * (  1 + max(t2,0) );          % after interval offset.

s1 = min(s1, AGENT.T_max); 
s2 = min(s2, AGENT.T_max); 

ss =    ((1-agent.ch) * [s1 s2]) ...        % Before choice,
        + (agent.ch * agent.sT);            % after choice.

agent.s  = agent.ss; % Current state
agent.ss = ss;       % Future state

% Compute RPEs and update state value estimates
[agent] = UPDATE_CRITIC(AGENT, agent, cue);

% Update policy/action-value estimates
[agent] = UPDATE_ACTOR(AGENT, agent, action);

% Record TDE at interval offset and choice
if cue.secTone == 1
    history.secToneTDE(numel(history.init)) = agent.tde;
elseif cue.reward ~= 0
    history.choiceTDE(numel(history.init)) = agent.tde;
end

if sum(isnan(agent.V(:))) + sum(isnan(agent.A(:))) + sum(isnan(agent.p(:))) > 0
    disp('WARNING: NaN detected')
    disp(agent)
end

end

function [agent] = UPDATE_CRITIC(AGENT, agent, cue) 

V = agent.V;
s = agent.s;
ss = agent.ss;

% Compute tde
tde = cue.reward + AGENT.gamma*V(ss(1),ss(2)) - V(s(1),s(2)); 

% Set tde to zero at trial initiation and terminal state
tde = tde * (1-cue.trialInit) * (1-(s(1) == agent.sT(1)));

if cue.trialInit == 1 && tde ~= 0
    disp(tde)
end

% Increment counter for number of updates
agent.nuV(agent.s(1), agent.s(2)) = agent.nuV(agent.s(1), agent.s(2)) + 1;

% Update state value
eta = ( max( [1/AGENT.N_V  1/agent.nuV(agent.s(1), agent.s(2))] ) );
V(s(1),s(2)) = V(s(1),s(2)) + eta*tde;

agent.V = V;
agent.tde = tde;
agent.TDE = [agent.TDE; tde];

end

function [agent] = UPDATE_ACTOR(AGENT, agent, action)

A = agent.A; 
p = agent.p;
s = agent.s;
tde = agent.tde;

% Increment counter for number of updates
agent.nuA(action, s(1), s(2)) = agent.nuA(action, s(1), s(2)) + 1;

% Update action preference
beta = (  max( [1/AGENT.N_A  1/agent.nuA(action, s(1), s(2))] )  );
A(action, s(1), s(2)) = (1-beta)*A(action, s(1), s(2)) + beta*tde;

% % Update policy
% p(:, s(1), s(2)) = exp( AGENT.alpha*A(:, s(1), s(2)) ) ./ ...
%     sum(exp( AGENT.alpha*A(:, s(1), s(2)) ));

% Update policy to be epsilon-softmax of the advantage function
p_ = (1 - AGENT.eps) * exp( AGENT.alpha*A(:, s(1), s(2)) ) ./ ...
    sum(exp( AGENT.alpha*A(:, s(1), s(2)) ));
p(:, s(1), s(2)) = p_ + (AGENT.eps/numel(p_)); 

agent.A = A;
agent.p = p;

end
