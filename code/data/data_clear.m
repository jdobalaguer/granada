
vars = 'end_of_task data parameters participant ptb';

if parameters.stair_do;   vars = [vars,' stair']; end
if parameters.flag_model; vars = [vars,' model']; end
    
eval(['clearvars -except ',vars]);
