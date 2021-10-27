

fldr_name = 'saved_variables_MEQ/';
v = 9;

[meq] = POOL_MAIN_EFFECT_QUANT(fldr_name,v);

fname = ['saved_variables_MEQ/' 'v' num2str(v) '_pooled_meq'];
save(fname, 'meq')

