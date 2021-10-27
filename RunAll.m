function [] = RunAll(machineIdx)

VERSION     = 9;
fname = [ 'saved_variables_new/' 'v' num2str(VERSION) ];

CMPRS       =   0:.1 : 1;
ALPHA       =  .05:.1: 1;
EPS         =   0:.1:.2;
SIG         = .22:.02:.40;

if machineIdx == 1
    fname_ = [fname '_allParam'];
    parsaveparam(fname_, CMPRS, ALPHA, EPS, SIG)
end

numRepeats  = 20;
siz         = [numel(CMPRS) numel(ALPHA) numel(EPS) numel(SIG)];

numIter     = prod(siz); % siz(1)*siz(2);

%%

NUM_MACHINES = 3;
for ii = 1:NUM_MACHINES
    ITER_IDXS{ii} = 1 + floor( numIter*(ii-1)/NUM_MACHINES ): ...
        floor( numIter*(ii)/NUM_MACHINES ); %#ok<AGROW>
end

iterIdxs = ITER_IDXS{machineIdx};
disp(numel(iterIdxs))

%%

StartParPool(numIter);
parfor jj = 1:numel(iterIdxs)
    
ii = iterIdxs(jj);

[cmprsIdx, alphaIdx, epsIdx, sigIdx] = ind2sub(siz,ii);

TASK    = cell(numRepeats, 1);
AGENT   = cell(numRepeats, 1);
Agent   = cell(numRepeats, 1);
Labels  = cell(numRepeats, 1);

try

AGENT_ = [];
AGENT_.cmprs    = CMPRS(cmprsIdx); %#ok<*PFBNS>
AGENT_.alpha    = ALPHA(alphaIdx);
AGENT_.eps      = EPS(epsIdx);
AGENT_.dt_std   = SIG(sigIdx);

for runIdx = 1:numRepeats
    [TASK{runIdx}, AGENT{runIdx}, Agent{runIdx}, Labels{runIdx}] ...
        = RUN_MULTI(AGENT_);
end

[q,res] = COMPUTE_MAIN_EFFECT_QUANT(TASK, AGENT, Agent, Labels);

fname_ = [fname '_CMPRS_' num2str(cmprsIdx) '_ALPHA_' num2str(alphaIdx) ...
    '_EPS_' num2str(epsIdx) '_SIG_' num2str(sigIdx)];

parsave(fname_, CMPRS, ALPHA, EPS, SIG, q, res)

catch
    
    disp(['Error with parameters:' ...
        ' CMPRS ' num2str(CMPRS(cmprsIdx)) ...
        ', ALPHA ' num2str(ALPHA(alphaIdx)) ...
        ', EPS ' num2str(EPS(epsIdx)) ...
        ', SIG' num2str(SIG(sigIdx))])
    
end

end

end

function [] = parsave(fname_, CMPRS, ALPHA, EPS, SIG, q,res)

save(fname_, 'CMPRS', 'ALPHA', 'EPS', 'SIG', 'q', 'res')

end


%% 

function [] = parsaveparam(fname_, CMPRS, ALPHA, EPS, SIG)

save(fname_, 'CMPRS', 'ALPHA', 'EPS', 'SIG')

end