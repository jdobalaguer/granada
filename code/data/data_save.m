if parameters.flag_debug; return; end
if index.endtask; return; end

save(participant.filename_data,'data', 'parameters', 'participant', 'ptb');
