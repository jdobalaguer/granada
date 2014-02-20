
if ~parameters.time_feedback; return; end;
if end_of_task; return; end

%% Background
Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

%% Time
% wait until it's time
while (ptb.screen_time_next>GetSecs); end
% calculate next times
ptb.screen_time_this = GetSecs;
ptb.screen_time_next = ptb.screen_time_this + parameters.time_feedback;

%% Audio
% slow
if isnan(trialstruct.resp_correct)
    ptb_audio_lowbeep;
elseif ~trialstruct.resp_correct
    ptb_audio_lowbeep;
else
    ptb_audio_highbeep;
end

%% Plot
Screen(ptb.screen_w, 'TextFont',  parameters.screen_fontname);
Screen(ptb.screen_w, 'TextSize',  parameters.screen_fontsize);
Screen(ptb.screen_w, 'TextColor', parameters.screen_fontcolor);
Screen(ptb.screen_w, 'TextBackgroundColor', parameters.screen_fontbgcolor);
while parameters.time_feedback && (GetSecs() < ptb.screen_time_next)
    % message
    if isnan(trialstruct.resp_correct)
        DrawFormattedText(ptb.screen_w,parameters.screen_txtslow,'center','center');
    end
    % flip
    Screen(ptb.screen_w,'Flip');
end
