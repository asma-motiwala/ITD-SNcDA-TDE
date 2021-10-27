

function [RSS,entrpy,V_hat] = ...
    COMPUTE_RECONST_ERROR_AND_REP_COST(V_target, V, lam, nuZ)



%% For the compression parameter (lam) specified, compute the boundaries of
%   the basis functions

K  = size(V,1);

B  = [0 1:K-1]; % Boundaries of basis functions along z^1

C_hat = B; % Boundaries of basis functions along z^2 for the target/full representation
C  = [0 1 min((2:K-1)/lam,K)];% [0 1 1+((1:K-2)*(K-lam*(K-1)))];
        % Boundaries of basis functions along z^2 for the compressed representation

%%

V_hat = nan(K,K); % (size(V_target));

V_hat(:,1) = V(:,1);

for k = 2:K-1 % For each column of the reconstructed representation V_hat
    
    cl = C_hat(k);
    cu = C_hat(k+1);
    
    jl = find(C <= cl, 1, 'last' );
    ju = find(C >= cu, 1, 'first' );
    
    if jl == ju-1 % if the boundaries of the reconst rep are enclosed
        V_hat(:,k) = V(:,jl);
    else
        w = C(jl+1) - (cl); % proportional to the overlap with each of 
                            % the bases of the compressed rep
        V_hat(:,k) = w*V(:,jl) + (1-w)*V(:,ju);
    end
    
end

RSS = nanmean(((V_hat(:) - V_target(:)).^2).*nuZ(:));
TSS = nanmean(((V_hat(:) - nanmean(V_hat(:))).^2).*nuZ(:));

Rsqrd = 1 - (RSS/TSS);

%%

[counts,~] = histcounts(V(:),-4:.2:10);

p = counts/sum(counts);
entrpy =  -nansum(p.*log2(p)); 


end

