if parameters.flag_debug; return; end
if parameters.flag_virtual; return; end
if end_of_task; return; end

vars = ', ''data'', ''parameters'', ''participant'', ''ptb'' ';

% if parameters.flag_foo;   vars = [vars,', ''var_name_here''']; end
if parameters.stair_do;   vars = [vars,', ''stair''']; end
if parameters.flag_model; vars = [vars,', ''model''']; end
    
eval(['save(participant.filename_data',vars,');']);
