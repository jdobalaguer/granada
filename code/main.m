%{
    notes:
      requires PsychToolbox (http://psychtoolbox.org/HomePage)
%}

clear all;

%% SET
set_parameters;
set_index;
set_participant;

%% EXPERIMENT
try
    %% START
    % initialise psychtoolbox
    ptb_start;
    % show introduction screen
    screen_intro;
    
    %% TASK
    % task screen
    screen_task;
    % set task
    set_task;
    % do task
    do_task;
    
    %% LOTTERY
    % set lottery
    set_lottery;
    % do lottery
    do_lottery;
    
    %% END
    % show end screen
    screen_end;
    % close psychtoolbox
    ptb_stop;
    % clean
    data_clear;
    
catch err
    % close psychtoolbox
    ptb_stop;
    % save data
    data_error;
    % rethrow error
    rethrow(err);
end
