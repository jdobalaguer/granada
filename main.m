%{
    notes:
      requires PsychToolbox (http://psychtoolbox.org/HomePage)
      requires ezyfit       (http://www.fast.u-psud.fr/ezyfit)
%}

clear all;

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
    
    %% TASK
    % task screen
    ptb_screen_task;
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
%    data_clear;
    
catch err
    % close psychtoolbox
    ptb_stop;
    % save data
%    data_error;
    % rethrow error
    rethrow(err);
end
