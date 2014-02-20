
%% Background
Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

%% Time
% wait until it's time
while (ptb.screen_time_next>GetSecs); end
% calculate next times
ptb.screen_time_this = GetSecs;
ptb.screen_time_next = ptb.screen_time_this + parameters.time_response;

%% Plot
% draw gabor
ptb_screen_plotgabor;
% flip
Screen(ptb.screen_w,'Flip');

%% Get key
tmp_gs = GetSecs();
while   ~end_of_task && ...
        ~end_of_session && ...
        isnan(trialstruct.resp_angle) && ...
        (tmp_gs < ptb.screen_time_next)
    ptb_resp_kb;
end
