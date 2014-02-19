if end_of_task; return; end
if end_of_staircase; return; end
if parameters.flag_virtual; return; end
if ~parameters.stair_do; return; end


% create stair
stair_create;
% task screen
ptb_screen_staircase;

%% BLOCK
while (~end_of_task) && (~end_of_staircase)
    % new block
    set_stair_block;
    
    

    
    
    %% TRIAL
    while (~end_of_task) && (~end_of_block)
        % isi screen
        ptb_screen_isi;
        % new trial
        set_stair_trial;
        % fixation screen
        ptb_screen_fixation;
        % trial screen
        ptb_screen_stair_trial;
        % feedback screen
        ptb_screen_feedback;
        % end of block
        set_stair_endofblock;
    end
    % add data
    stair_add;
    
    % end of task
    set_endofstair;
end

% set contrast
set_contrast;
% save
stair_save;
% clean
data_clear;
