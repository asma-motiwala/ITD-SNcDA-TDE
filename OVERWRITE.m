

function [struc] = OVERWRITE(struc, struc_)

% Compatible with task versions: v7, v9, v10

names = fieldnames(struc_);
nf = numel(names) - sum(strcmp(names, 'dummy'));

if nf > 0
    for ii = 1:nf
        struc.(names{ii}) = struc_.(names{ii});
    end
end

end



