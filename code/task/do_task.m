
%% TASK
while ~end_of_task
    %% TRIGGER
    % task screen
    ptb_screen_session;
    % read trigger
    ptb_trigger;
    
    %% SESSION
    % set session
    set_session;
    % do session
    do_session;
    
    %% END OF TASK
    set_endoftask;
end

%% SAVE
data_save;
