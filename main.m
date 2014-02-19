%{
    notes:
      requires PsychToolbox (http://psychtoolbox.org/HomePage)
      requires ezyfit       (http://www.fast.u-psud.fr/ezyfit)
%}

%% SET
set_parameters;
set_participant;

%% EXPERIMENT
try
    %% START
    % initialise psychtoolbox
    ptb_start;
    % show introduction screen
    ptb_screen_intro;
    
    %% STAIRCASE
    % set staircase
    set_stair;
    % do staircase
    do_stair;
    
    %% TASK
    % set task
    set_task;
    % do task
    do_task;
    
    %% END
    % show end screen
    ptb_screen_end;
    % close psychtoolbox
    ptb_stop;
    % clean
    data_clear;
    
catch err
    % close psychtoolbox
    ptb_stop;
    % save data
    data_error;
    % send mail
    set_alert;
    % rethrow error
    rethrow(err);
end
