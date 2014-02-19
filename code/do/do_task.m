if end_of_task; return; end



% set model
set_model;
% create data
data_create;
% task screen
ptb_screen_task;

%% BLOCK
while ~end_of_task
    % new block
    set_task_block;
    % alert
    set_alert;
    % block screen
    ptb_screen_block;

    %% TRIAL
    while (~end_of_task) && (~end_of_block)
        % isi screen
        ptb_screen_isi;
        % new trial
        set_task_trial;
        % fixation screen
        ptb_screen_fixation;
        % trial screen
        ptb_screen_task_trial;
        % feedback screen
        ptb_screen_feedback;
        % end of block
        set_task_endofblock;
    end
    % save data
    data_add;
    data_save;
    % end of task
    set_endoftask;
end

% alert
set_alert;
