

fldr_name = 'saved_variables_RCnE/';
v = 9; 

[rcne, allV_hat, allP_hat] = POOL_RECONST_ERROR_AND_REP_COST(fldr_name,v);


fname = ['saved_variables_RCnE/' 'v' num2str(v) '_pooled_rcne'];
save(fname, 'rcne', 'allV_hat', 'allP_hat')

