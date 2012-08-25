% Expand a structure in it's fields

% based on Jason's 'expand_structure.m', works for one or multiple entries 

fields_wt = fieldnames(structure);

for i=1:length(fields_wt);
    eval(sprintf('clear %s;',fields_wt{i}));
end;

for i=1:length(structure)
    for k_structure=1:length(fields_wt),
        eval(sprintf('%s(i) = structure(i).%s;',fields_wt{k_structure},fields_wt{k_structure}));
    end
end;