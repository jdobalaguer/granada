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
    
    %% NOT-A-STAIRCASE
    % task screen
    screen_task;
    % set task
    set_stair;
    % do task
    do_stair;
    
    %% END
    % show end screen
    screen_end;
    % close psychtoolbox
    ptb_stop;
    % clean
    data_clear;
    
    %% PSYCHOMETRY
    stair_psychometry;
    
    %% SAVE
    data_save;
    
catch err
    % close psychtoolbox
    ptb_stop;
    % save data
    data_error;
    % rethrow error
    rethrow(err);
end
