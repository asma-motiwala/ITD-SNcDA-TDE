

function [task, cue, history] = UPDATE_TASK(TASK, task, action, history)

% Compatible with task versions: v11

if sum(TASK.choices == action) > 0 && ... % If a non-wait action is registered,
        isnan(task.tsl_rw) && ...         % no rewards have been delivered yet,
        numel(history.init) > 0              % the first trial has been initiated.
    
    cue.reward = ...                            % Specify rewards for:
        ~isnan(task.tsl_st)*(  ...              % Valid, 
        (action==task.goal)*TASK.Rc + ...       % correct choice
        ( 1-(action==task.goal) )*TASK.Ri ...   % incorrect choice
                                    ) + ...
        isnan(task.tsl_st)*TASK.Rp;             % Premature choice.
    
    % Record trial labels
    history.choice(numel(history.init))       = action;
    history.choiceTime(numel(history.init))   = task.t;
    history.reward(numel(history.init))       = cue.reward;
    history.premature(numel(history.init))    = isnan(task.tsl_st)*task.tsl_ti;
    
    task.tsl_rw = 0; % TASK.dt;
    
else
    
    cue.reward = 0;
    
end

if task.tsl_rw > 0 || ...   % If a reward is delivered or 
        ...                 % if no choice was made before allowed choice time 
        task.tsl_ti > (task.delay + TASK.max_resp_time) 
    
    % Record missed trial
    if task.tsl_ti > (task.delay + TASK.max_resp_time) 
        history.choice(numel(history.init))       = action;
        history.choiceTime(numel(history.init))   = task.t;
        history.reward(numel(history.init))       = cue.reward;
        history.premature(numel(history.init))    = isnan(task.tsl_st)*task.tsl_ti;
        task.t = task.t + TASK.dt;
    end
    
    % Start new episode
    cue.trialInit = 1;
    cue.secTone = 0;
    
    task.tsl_ti = 0;
    task.tsl_st = nan;
    task.tsl_rw = nan;
    
    task.n = task.n + 1;
    
    % Determine stimulus (delay length) and correct action (goal) for new trial
    task.delay  = TASK.stim_set( ceil(rand * numel(TASK.stim_set)) );
    task.goal   = TASK.choices( (task.delay > (TASK.ref_delay)) + 1 );
    
    % Record trial labels
    history.init                     = [history.init task.t];
    history.stim(numel(history.init)) = task.delay;
    
elseif isnan(task.tsl_rw) && ...    % If no choice has been detected, 
        isnan(task.tsl_st) && ...   % the second tone has not yet been presented,
        task.tsl_ti >= task.delay   % delay duration has been exceeded
    
    cue.trialInit   = 0;
    cue.secTone     = 1;
    
    task.tsl_st     = 0; 
    
else
    
    cue.trialInit   = 0;
    cue.secTone     = 0;

end

task.t      = task.t + TASK.dt;
task.tsl_ti = task.tsl_ti   + TASK.dt;
task.tsl_st = task.tsl_st   + TASK.dt;
task.tsl_rw = task.tsl_rw   + TASK.dt;

end



