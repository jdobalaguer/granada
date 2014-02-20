            
if ~parameters.time_fixation; return; end;
if end_of_task; return; end

%% Background
Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

%% Time
% wait until it's time
while (ptb.screen_time_next>GetSecs); end
% calculate next times
ptb.screen_time_this = GetSecs;
ptb.screen_time_next = ptb.screen_time_this + parameters.time_fixation;

%% Plot
while GetSecs() < ptb.screen_time_next
    ptb_screen_plotfixation;
    % flip
    Screen(ptb.screen_w,'Flip');
end
