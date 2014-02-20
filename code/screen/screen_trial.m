

Screen(ptb.screen_w, 'FillRect',  ptb.screen_bg_color);

%% Plot
plot_frame;
plot_bonus;
plot_color;
plot_gabor;

%% Time
ptb.screen_time_this = GetSecs;
ptb.screen_time_next = ptb.screen_time_this + parameters.time_trial;
trialstruct.vb_getsecs = ptb.screen_time_this;

%% Flip
Screen(ptb.screen_w,'Flip');

%% Wait
% get response
gs = GetSecs();
while   gs < ptb.screen_time_next       && ... time
        isnan(trialstruct.resp_angle)   && ... response
        ~index.endtask                     ... exit
    resp_trial;
end
% wait until end
while GetSecs < ptb.screen_time_next
end
% no response
resp_none;
% set bonus
set_bonus;

%% Clean
clear gs;
