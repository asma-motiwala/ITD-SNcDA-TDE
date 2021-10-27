

function [labels] = FIX_NUM_ELEMENTS(labels)

% Compatible with task versions: v7

names = fieldnames(labels);
nf = numel(names);

numEl = nan(1,nf);

for ii = 1:nf
      
    numEl(ii) = size(labels.(names{ii}),2);
    
end

numEl = min(numEl);

for ii = 1:nf
      
    labels.(names{ii}) = labels.(names{ii})(:,1:numEl);
    
end




