

function [rcne, allV_hat, allP_hat] = POOL_RECONST_ERROR_AND_REP_COST(fldr_name,v)

load([fldr_name 'v' num2str(v) '_allParam.mat'])

%%

siz = [numel(CMPRS) numel(ALPHA) numel(EPS) numel(SIG)];
rcne{numel(CMPRS), numel(ALPHA), numel(EPS), numel(SIG)} = [];
allV_hat{numel(CMPRS), numel(ALPHA), numel(EPS), numel(SIG)} = [];
allP_hat{numel(CMPRS), numel(ALPHA), numel(EPS), numel(SIG)} = [];

numIter = prod(siz); % siz(1)*siz(2);

%% Compute V_target & RC&E for unambiguous representation

for i = 1:numIter
    
    [cmprsIdx, alphaIdx, epsIdx, sigIdx] = ind2sub(siz,i);
    
    %%
    
    fl_name = ['v' num2str(v) ...
        '_CMPRS_'   num2str(cmprsIdx) ...
        '_ALPHA_'   num2str(alphaIdx) ...
        '_EPS_'     num2str(epsIdx) ...
        '_SIG_'     num2str(sigIdx)];
    fl_pth = [fldr_name fl_name '.mat'];
    
    if numel(dir(fl_pth)) > 0 && cmprsIdx == numel(CMPRS)
        
        load(fl_pth, 'CMPRS', 'ALPHA', 'EPS', 'SIG', ...
            'TASK', 'AGENT', 'Agent', 'Labels')
        
        [V_target, P_target, R_target, ...
            re_V, rc_V, re_P, rc_P, oR] = CV_RCnE_1(AGENT, Agent, Labels);
        
        rcne{cmprsIdx, alphaIdx, epsIdx, sigIdx} = ...
            [re_V, rc_V, re_P, rc_P, oR];
        allV_hat{cmprsIdx, alphaIdx, epsIdx, sigIdx} = V_target;
        allP_hat{cmprsIdx, alphaIdx, epsIdx, sigIdx} = P_target;
    
    end
    
end


%% Compute RC&E for all representaitons with compression

for i = 1:numIter
    
    [cmprsIdx, alphaIdx, epsIdx, sigIdx] = ind2sub(siz,i);
    
    %%
    
    fl_name = ['v' num2str(v) ...
        '_CMPRS_'   num2str(cmprsIdx) ...
        '_ALPHA_'   num2str(alphaIdx) ...
        '_EPS_'     num2str(epsIdx) ...
        '_SIG_'     num2str(sigIdx)];
    fl_pth = [fldr_name fl_name '.mat'];
    
    if numel(dir(fl_pth)) > 0 && cmprsIdx ~= numel(CMPRS)
        
        load(fl_pth, 'CMPRS', 'ALPHA', 'EPS', 'SIG', ...
            'TASK', 'AGENT', 'Agent', 'Labels')
        
        [re_V, rc_V, re_P, rc_P, oR, V_hat, P_hat] = ...
            CV_RCnE(AGENT, Agent, Labels, ...
            V_target, P_target, R_target);
        
        rcne{cmprsIdx, alphaIdx, epsIdx, sigIdx} = ...
            [re_V, rc_V, re_P, rc_P, oR];
        allV_hat{cmprsIdx, alphaIdx, epsIdx, sigIdx} = V_hat;
        allP_hat{cmprsIdx, alphaIdx, epsIdx, sigIdx} = P_hat;
    
    end
    
end


end


function [V_target, P_target, R_target, ...
            re_V, rc_V, re_P, rc_P, oR] = ...
            CV_RCnE_1(AGENT_, agent_,labels_)

numRepeats_ = size(AGENT_,1);

re_V = nan(numRepeats_,1);
rc_V = nan(numRepeats_,1);

re_P = nan(numRepeats_,3);
rc_P = nan(numRepeats_,3);

oR = nan(numRepeats_,1);

for ir = 1:numRepeats_
    
    indx_rep = 1:numRepeats_;
    indx_rep(ir) = [];
    
    tempV = zeros(AGENT_{1}.T_max+1, AGENT_{1}.T_max+1, ...
        numel(indx_rep));
    tempP = zeros(AGENT_{1}.T_max+1, AGENT_{1}.T_max+1, ...
        3, numel(indx_rep));
    tempR = zeros(1, numel(indx_rep));
    
    for irep = 1:numel(indx_rep)
        
        tempV(:,:,irep) = agent_{indx_rep(irep)}.V;
        
        tempP(:,:,1,irep) = ...
            squeeze(agent_{indx_rep(irep)}.p(1,:,:));
        
        tempP(:,:,2,irep) = ...
            sum(  agent_{indx_rep(irep)}.p(2:(end-1),:,:),1  );
        
        tempP(:,:,3,irep)  = ...
            squeeze(agent_{indx_rep(irep)}.p(end,:,:));
        
        tempR(irep) = nanmean(labels_{indx_rep(irep)}.reward);
        
    end
    
    target_V = mean(tempV,3);
    target_P = mean(tempP,4);
    target_R = mean(tempR);
    
    %% Compute reconstruction error for each repeat. Report mean +- std
    
    [MSE,entrpy,~] = COMPUTE_RECONST_ERROR_AND_REP_COST( ...
        target_V, agent_{ir}.V, AGENT_{ir}.cmprs, agent_{ir}.nuZ );
    
    re_V(ir) = MSE;
    rc_V(ir) = entrpy;
        
    %%
    
    tempPl = squeeze(   agent_{ir}.p(1,:,:) );
    tempPw = squeeze(sum(  agent_{ir}.p(2:(end-1),:,:),1  ));    
    tempPr = squeeze(   agent_{ir}.p(end,:,:)   );
    
    % Pdiff = target_P - cat(3, tempPl, tempPw, tempPr);
    % re_P(ir) = sqrt(sum( Pdiff(:).^2 ));
    
    tempP = cat(3, tempPl, tempPw, tempPr);
    
    for a = 1:3
        
        [MSE,entrpy,~] = COMPUTE_RECONST_ERROR_AND_REP_COST( ...
            squeeze(target_P(:,:,a)), squeeze(tempP(:,:,a)), ...
            AGENT_{ir}.cmprs, agent_{ir}.nuZ );
        
        re_P(ir,a) = MSE;
        rc_P(ir,a) = entrpy;
        
    end
    
    %%
    
    oR(ir) = nanmean(labels_{ir}.reward); 
            % (target_R - nanmean(labels_{ir}.reward)).^2;
    
end

%%

% tempV = zeros(AGENT_{1}.T_max+1, AGENT_{1}.T_max+1, ...
%     numel(indx_rep));

tempV = zeros(AGENT_{1}.T_max+1, AGENT_{1}.T_max+1, numRepeats_);
tempP = zeros(AGENT_{1}.T_max+1, AGENT_{1}.T_max+1, 3, numRepeats_);
tempR = zeros(1, numRepeats_);

for irep = 1:numRepeats_

    tempV(:,:,irep) = agent_{irep}.V;
    tempR(irep) = nanmean(labels_{irep}.reward);
    
    tempP(:,:,1,irep) = squeeze(agent_{irep}.p(1,:,:));
    tempP(:,:,2,irep) = sum(  agent_{irep}.p(2:(end-1),:,:),1  );
    tempP(:,:,3,irep)  = squeeze(agent_{irep}.p(end,:,:));
    
end

V_target = nanmean(tempV,3);
P_target = mean(tempP,4);
R_target = nanmean(tempR);

end


function [re_V, rc_V, re_P, rc_P, oR, V_hat, P_hat] = ...
            CV_RCnE(AGENT_, agent_, labels_, ...
            V_target, P_target, R_target)

numRepeats_ = size(AGENT_,1);

re_V = nan(numRepeats_,1);
rc_V = nan(numRepeats_,1);

re_P = nan(numRepeats_,3);
rc_P = nan(numRepeats_,3);

oR = nan(numRepeats_,1);

tempV = zeros(AGENT_{1}.T_max+1, AGENT_{1}.T_max+1, numRepeats_);
tempP = zeros(AGENT_{1}.T_max+1, AGENT_{1}.T_max+1, 3, numRepeats_);
tempR = zeros(1, numRepeats_);

tempVhat = zeros(AGENT_{1}.T_max+1, AGENT_{1}.T_max+1, numRepeats_);
tempPhat = zeros(AGENT_{1}.T_max+1, AGENT_{1}.T_max+1, 3, numRepeats_);

for ir = 1:numRepeats_
    
    tempV(:,:,ir) = agent_{ir}.V;
    
    tempP(:,:,1,ir) = squeeze(agent_{ir}.p(1,:,:));
    tempP(:,:,2,ir) = sum(  agent_{ir}.p(2:(end-1),:,:),1  );    
    tempP(:,:,3,ir) = squeeze(agent_{ir}.p(end,:,:));
    
    tempR(ir) = nanmean(labels_{ir}.reward);
    
    %% Compute reconstruction error for each repeat. Report mean +- std
    
    [MSE,entrpy,Vhat] = COMPUTE_RECONST_ERROR_AND_REP_COST( ...
        V_target, agent_{ir}.V, AGENT_{ir}.cmprs, agent_{ir}.nuZ );
    
    re_V(ir) = MSE;
    rc_V(ir) = entrpy;

    tempVhat(:,:,ir) = Vhat;
    
    %%
    
    for a = 1:3
        
        [MSE,entrpy,Phat] = COMPUTE_RECONST_ERROR_AND_REP_COST( ...
            squeeze(P_target(:,:,a)), squeeze(tempP(:,:,a)), ...
            AGENT_{ir}.cmprs, agent_{ir}.nuZ );
        
        re_P(ir,a) = MSE;
        rc_P(ir,a) = entrpy;
        
        tempPhat(:,:,a,ir) = Phat;
        
    end
    
    %%
        
    % oR(ir) = (R_target - nanmean(labels_{ir}.reward)).^2;
    oR(ir) = nanmean(labels_{ir}.reward);
    
end

V_hat = nanmean(tempVhat,3);
P_hat = nanmean(tempPhat,4);

end

