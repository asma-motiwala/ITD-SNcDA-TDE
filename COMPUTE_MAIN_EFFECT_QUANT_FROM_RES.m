

function [q] = COMPUTE_MAIN_EFFECT_QUANT_FROM_RES(res)


%% Compute quantifications for main effects

q = nan(5,1);

%  Difference in average TDEs at interval offset between short and long
%   intervals

avgTDEshort = mean(mean(res.avgSecToneTDE(1:3,:)));
avgTDElong = mean(mean(res.avgSecToneTDE(4:6,:)));
q(1) = avgTDEshort - avgTDElong;


%  Difference in average TDEs at interval offset between easy and
%   near-boundary intervals

avgTDEeasy = mean(mean(res.avgSecToneTDE([1 6],:)));
avgTDEnearBoundary = mean(mean(res.avgSecToneTDE([3 4],:)));

q(2) = avgTDEeasy - avgTDEnearBoundary;

%  Average difference between psychometric curve for low and high TDE at
%   interval offset

q(3) = mean(res.psychCrvsDiff(:));

%  Difference between average RTs for long choices for all long and 
%   vs short intervals

avgRTshortIshortC = nanmean(nanmean(res.avgRT(1:3,1,:)));
avgRTlongIshortC = nanmean(nanmean(res.avgRT(4:6,1,:)));
avgRTshortIlongC = nanmean(nanmean(res.avgRT(1:3,2,:)));
avgRTlongIlongC = nanmean(nanmean(res.avgRT(4:6,2,:)));

q(4) = avgRTshortIlongC - avgRTlongIlongC;

%  Difference between average RTs for short choices for all short and 
%   vs short intervals

q(5) = avgRTshortIshortC - avgRTlongIshortC;

end




