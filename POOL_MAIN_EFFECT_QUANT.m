

function [meq] = POOL_MAIN_EFFECT_QUANT(fldr_name,v)

load([fldr_name 'v' num2str(v) '_allParam.mat'])

%%

siz = [numel(CMPRS) numel(ALPHA) numel(EPS) numel(SIG)];
meq = nan([8 siz]);

numIter = prod(siz); % siz(1)*siz(2);

for i = 1:numIter
    
    [cmprsIdx, alphaIdx, epsIdx, sigIdx] = ind2sub(siz,i);
    
    %%
    
    fl_name = ['v' num2str(v) ...
        '_CMPRS_'   num2str(cmprsIdx) ...
        '_ALPHA_'   num2str(alphaIdx) ...
        '_EPS_'     num2str(epsIdx) ...
        '_SIG_'     num2str(sigIdx)];
    fl_pth = [fldr_name fl_name '.mat'];
    
    if numel(dir(fl_pth)) > 0 
        
        % load(fl_pth, 'res')
        
        % [q] = COMPUTE_MAIN_EFFECT_QUANT_FROM_RES(res);
        
        load(fl_pth) % , 'TASK', 'AGENT', 'Agent', 'Labels')
        
        [q,res] = COMPUTE_MAIN_EFFECT_QUANT(TASK, AGENT, Agent, Labels);
    
        meq(:, cmprsIdx, alphaIdx, epsIdx, sigIdx) = q;
    
    end
    
end

end